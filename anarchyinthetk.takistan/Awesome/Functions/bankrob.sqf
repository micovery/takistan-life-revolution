#define SleepWait(timeA) private["_waittt"]; _waittt = time + timeA; waitUntil {time >= _waittt};
#define strM(x) ([x, ","] call format_integer)

bankRob_safeArray = [safe1, safe2, safe3];

bankRob_v_inUse = "inUse";
bankRob_v_useTime = "useTime";
bankRob_v_robTime = "lastRob";
bankRob_v_robbed = "robTime";
bankRob_v_localLoss = "local_loss";
bankRob_v_globalLoss = "global_loss";
bankRob_v_amountStolen = "stolenAmount";
bankRob_v_robDisc = "RobberDisconnect";

bankRob_pv_checkUse = "bankRob_checkUse";
bankRob_pv_checkUse addpublicVariableEventHandler {(_this select 1) call bankRob_safeInUse_s};

bankRob_pv_lossAdd = "bankRob_lossAdd";
bankRob_pv_lossAdd addpublicVariableEventHandler {(_this select 1) call bankRob_addLosses_s};

bankRob_timeCrack = 30;
bankRob_timeCool = 60 * 60;
bankRob_fakeChance = 0.3;
bankRob_divide = 30;
bankRob_s_vaultCrack = "Attempting to Crack a Bank Vault";
bankRob_s_robVault = "Robbed a Bank Vault";

// Starting robbery
bankRob_rob = {
	private["_player", "_safe", "_robTime", "_money", "_nearCops", "_i", "_damage", "_interupt"];
	_player = _this select 0;
	_safe = _this select 1;
	
	_robTime = time;
	_money = [_safe, _robTime] call bankRob_checkSafe;
	_nearCops = [_player, 300, true] call player_near_west;
	
	if (_nearCops) then {
			[_player, bankRob_s_vaultCrack, (100000), 100, false] call player_update_warrants;
			_player groupchat "You were detected and your gun licenses have been revoked";
			[_player, ["pistollicense","riflelicense","automatic"]] call player_remove_licenses;
		};
	[_player, _nearCops, _safe] spawn bankRob_victimStart;
	
	_player groupchat "The cracker is attached, this will take some time";
	
	
	_damage = damage _player;
	_interupt = false;
	for [{_i = 0}, {_i < 6}, {_i = _i + 1}] do {
			_player playmove "AinvPknlMstpSlayWrflDnon_medic";
			SleepWait(5)
			waituntil {animationstate _player != "AinvPknlMstpSlayWrflDnon_medic"};
			if (
				!(alive _player)
				|| ((damage _player) != _damage) 
				|| (_player getVariable ["isstunned", false]) 
				|| (_player getVariable ["isstunned", false])
				|| (_player getVariable ["FA_inAgony", false])
				) then {
					_i = 6;
					_interupt = true;
				};
		};
	
	if _interupt exitwith {
			_player groupChat "Your Cracking attempt was interrupted, the tool is now useless";
			format['[false, %1] call bankRob_victimEnd;', _money] call broadcast;
		};
	
	if (_money == 0) then {
			_player groupChat "The safe is empty, escape";
		}else{
			_player groupChat format[localize "STRS_bank_rob_success"];
			[_player, _money] call bankRob_addStolen;
			[_player, 'money', _money] call INV_AddInventoryItem;
			_player setVariable ["robTime", time, true];
		};
		
	format['[%1 != 0, %1] call bankRob_victimEnd;', _money] call broadcast;
	
	if ([_player, 300, true] call player_near_west) then {
			[_player, bankRob_s_robVault, (500000 + (round(_money * 0.3))), -1, false] call player_update_warrants;
		};
};

// Victim end of rob
bankRob_victimStart = {
	private["_player", "_nearCops", "_safe", "_message"];
	_player = _this select 0;
	_nearCops = _this select 1;
	_safe = _this select 2;
	
	_message = "";
	_message = if _nearCops then {
			format[localize "STRS_bank_rob_titlemsg_known", _player, name _player]
		}else{
			localize "STRS_bank_rob_titlemsg"
		};
		
	format['
		if (isClient) then {
				titleText ["%1", "PLAIN DOWN"];
				{_x say "Bank_alarm";} forEach [%2, copbase1];
			};
	', _message, _safe] call broadcast;
};

// Victim end of rob, money loss part
bankRob_victimEnd = {
	private["_success", "_money", "_bank_account", "_fdic", "_insurances_inv", "_insurances_stor", "_insurance", "_verlust", "_verlustA", "_verlustB", "_pLost"];
	_success = _this select 0;
	_money = _this select 1;
	
	if !(_success) exitwith {
			player groupchat format["The Robbery failed, no money lost"];
		};
		
	server globalchat format["The thief stole $%1!", _money];
	
	_bank_account = [player] call bank_get_value;
				
	// Federal Insurance
	_fdic = 100000;
				
	if (_bank_account <= _fdic) exitWith {
			player groupChat "The bank has been robbed, but you lost no money because of federal insurance";
		};
				
	_insurances_inv = [player, 'bankversicherung'] call INV_GetItemAmount;
	_insurances_stor = [player, 'bankversicherung', 'private_storage'] call INV_GetStorageAmount;
				
	_insurance = false;
	if ( (_insurances_inv > 0) || (_insurances_stor > 0)) then {
			player groupChat localize "STRS_bank_rob_lostnomoney";
			if (_insurances_inv > 0) then {
					[player, 'bankversicherung', -(1)] call INV_AddInventoryItem;
				}else{
					[player, 'bankversicherung', -(1), 'private_storage'] call INV_AddItemStorage;
				};
			_insurance = true;
		};
	if (_insurance) exitwith {};
				
	_verlust = round(_bank_account*Maxbankrobpercentlost);
	_verlustA = round(_bank_account*MaxbankrobpercentlostA);
	_verlustB = round(_bank_account*MaxbankrobpercentlostB);

	switch true do {
			case (_bank_account > _fdic): {
					_pLost = -1;
					switch true do {
							case (_bank_account <= 99999): {
									_pLost = _verlust;
								};
							case ((_bank_account >= 100000) and (_bank_account <= 999999)): {
									_pLost = _verlustA;
								};
							case (_bank_account >= 1000000): {
									_pLost = _verlustB;
								};
							default {};
						};
					if ((_bank_account - _pLost) < _fdic) then {
							_pLost = _bank_account - _fdic;
						};
					[player, -(_pLost)] call bank_transaction;
					player groupChat format[localize "STRS_bank_rob_somemoneylost", strM(_pLost), strM(_bank_account - _pLost)];
				};		
			default {};
		};
};

// Get money available in safe
bankRob_checkSafe = {
	private["_safe", "_robTime", "_total_cash", "_local_cash", "_local_losses", "_player_Cash", "_player_UID"];
	_safe = _this select 0;
	_robTime = _this select 1;
	
	_local_cash = 0;
	
	if ([_safe] call bankRob_safeTime) exitwith {_local_cash};
	if ([_safe] call bankRob_safeFake) exitwith {_local_cash};
	
	[_safe] call bankRob_safeSetTime;
	
	_local_losses = [];
	
	_total_cash = 0;
	_local_cash = 0;
	{
		if (!isNull _x) then {
				if (isPlayer _x) then {
						_player_Cash = ([_x] call bank_get_value);
						_player_UID = getPlayerUID _x;
						
						_local_losses set[(count _local_losses), [_player_UID, ([_x, _player_Cash] call bankRob_getLoss), _robTime]];
						_total_cash = _total_cash + _player_Cash;
					};
			};
	} forEach playableUnits;
	
	[player, _local_losses] call bankRob_addLosses;
	player setVariable [bankRob_v_robbed, _robTime, true];
	
	_local_cash = round(_total_cash / bankRob_divide);
	
	_local_cash			
};

// Safe check if empty, time check
bankRob_safeTime = {
	private["_safe", "_localtime"];
	_safe = _this select 0;
	_localTime = _safe getVariable [bankRob_v_robTime, 0];
	((time - _localTime) < bankRob_timeCool)
};

// Safe Check for failure
bankRob_safeFake = {((random 1) <= bankRob_fakeChance)};

// Get closest safe
bankRob_nearestSafe = {
		private["_player", "_pos", "_safe", "_safes"];
		_player = _this select 0;
		_pos = getPosATL _player;
		_safe = objNull;
		_safes = nearestObjects [_pos,["Misc_cargo_cont_tiny"], 100];
		if ( (count _safes) > 0) then {
				_safe = _safes select 0;
				if ((_pos distance _pos) > 5) then {
						objNull
					}else{
						_safe
					};
			}else{
				_safe
			};
	};

// Checks if safe is in use
bankRob_safeInUse = {
		private["_safe"];
		_safe = _this select 0;
		
		if ((time - (_safe getVariable [bankRob_v_useTime, 0])) < 60) exitwith {
				false
			};
		
		_safe setVariable [bankRob_v_inUse, "", false];
		
		missionNamespace setVariable [bankRob_pv_checkUse, [player, _safe]];
		publicVariableServer bankRob_pv_checkUse;
		
		waitUntil {((typeName (_safe getVariable [bankRob_v_inUse, ""])) == "BOOL")};
		
		(_safe getVariable [bankRob_v_inUse, false])
	};

// Sets time on safe rob
bankRob_safeSetTime = {
	private["_safe"];
	_safe = _this select 0;
	_safe setVariable [bankRob_v_robTime, time, true];
};
	
// Server side of safe in use check
bankRob_safeInUse_s = {
	private["_player", "_safe", "_timeUse", "_timeCheck"];
	_player = _this select 0;
	_safe = _this select 1;
	
	_timeUse = 0;
	_timeUse = _safe getVariable [bankRob_v_useTime, 0];
	_timeCheck = ((time - _timeUse) < 60);
	
	[
		format['%1 setVariable ["%2", %3, false]', _safe, bankRob_v_inUse, _timeCheck], 
		_player
	] call broadcast_client;
	
	if _timeCheck then {
			_safe setVariable [bankRob_v_useTime, time, true];
		};
};

// Get Money lost
bankRob_getLoss = {
	private["_money", "_percent", "_fdic", "_insurances"];
	_player = _this select 0;
	_money = _this select 1;
	
	
	_fdic = 100000;			
	if (_money <= _fdic) exitWith {0};
				
	_insurances = ([_player, 'bankversicherung'] call INV_GetItemAmount) + ([_player, 'bankversicherung', 'private_storage'] call INV_GetStorageAmount);
	if (_insurances > 0) exitwith {0};
	
	
	_percent = 0;
	switch true do {
			case (_money <= 99999): {
						_percent = Maxbankrobpercentlost;
					};
			case ((_money >= 100000) and (_money <= 999999)): {
						_percent = MaxbankrobpercentlostA;
					};
			case (_money >= 1000000): {
						_percent = MaxbankrobpercentlostB;
					};
		};
		
	(_money * _percent)
};

// Adds losses to global losses array, and to local player losses
bankRob_addLosses = {
	private["_player", "_losses", "_currentLoss"];
	_player = _this select 0;
	_losses = _this select 1;
	
	_currentLoss = player getVariable [bankRob_v_localLoss, []];
	{
		_currentLoss set[(count _currentLoss), _x];
	} forEach _losses;
	
	player setVariable [bankRob_v_localLoss, _currentLoss, false];
	
	missionNamespace setVariable [bankRob_pv_lossAdd, [player, _currentLoss]];
	publicVariableServer bankRob_pv_lossAdd;
};

// Adds losses to global array on server
bankRob_addLosses_s = {
	private["_player", "_loss", "_array"];
	_player = _this select 0;
	_loss = _this select 1;
	
	_array = _player getVariable [bankRob_v_localLoss, []];
	{
		_array set[(count _array), _x];
	} forEach _loss;
	
	_player setVariable [bankRob_v_localLoss, _loss, false];
};

bankRob_totalloss = {
	private["_player", "_array", "_total_money", "_money"];
	_player = _this select 0;
	_array = _player getVariable [bankRob_v_localLoss, []];
	
	_totalMoney = 0;
	{
		_money = _x select 1;
		_totalMoney = _totalMoney + _money;
	} forEach _array;
	
	_totalMoney
};

// Return amounts to all
bankRob_returnLost = {
	private["_player", "_lossArray", "_uid", "_money", "_time"];
	_player = _this select 0;
	_lossArray = _player getVariable [bankRob_v_localLoss, []];
	
	{
		_uid = _x select 0;
		_money = _x select 1;
		_time = _x select 2;
		
		if (_money > 0) then {
				{
					if (!isNull _x) then {
							if (isPlayer _x) then {
									if ((getPlayerUID _x) == _uid) then {
											format['
												if !(isClient) exitwith {};
												if ((getPlayerUID player) == "%1") then {
														player groupChat "Your money from the robbery has been returned - %3";
														[player, %2] call bank_transaction;
													};
											', _uid, _money, strM(_money)] call broadcast;
										};
								};
						};
				} forEach playableUnits;
			};
	} forEach _lossArray;
	
	_player setVariable [bankRob_v_localLoss, [], false];
	format['%1 setVariable [bankRob_v_localLoss, []]', _player] call broadcast_server;
};

// Add stolen amount
bankRob_addStolen = {
	private["_player","_amount"];
	_player = _this select 0;
	_amount = _this select 1;
	_player setVariable [bankRob_v_amountStolen, (player getVariable [bankRob_v_amountStolen, 0]) + _amount, true];
};

// Get amount stolen
bankRob_getStolen = {
	private["_player", "_stolen"];
	_player = _this select 0;
	_stolen = _player getVariable [bankRob_v_amountStolen, 0];
	
	_stolen
};

// Reset amount stolen
bankRob_resetStolen = {
	private["_player"];
	_player = _this select 0;
	_player setVariable [bankRob_v_amountStolen, 0, true];
};

// Check if a player is considered a robber
bankRob_checkRobber = {
	private["_player", "_losses", "_robTime"];
	_player = _this select 0;
	
	_losses = [_player] call bankRob_totalloss;
	_robTime = _player getVariable [bankRob_v_robbed, - (60 * 10)];
	_reason = [_player] call bankRob_robReason;
	
	( (((time - _robTime) < (10 * 60)) && (_losses > 0)) || _reason)
};

// Check if player is wanted for cracking/robbing a safe
bankRob_robReason = {
	private["_player", "_reasons"];
	_player = _this select 0;
	_reasons = [_player] call player_get_reason;
	
	((bankRob_s_vaultCrack in _reasons) || (bankRob_s_robVault in _reasons))
};

// Check if disconnected was robber
bankRob_disconnect = {
	private[];
	_player = _this select 0;
	_robAbort = _player getVariable [bankRob_v_robbed, 0];
	
	if ( ((time - _robAbort) < (60 * 3)) && (_robAbort > 0) ) exitwith {
			[_player] call bankRob_returnLost;
			[_player, bankRob_v_robDisc, true] call player_set_bool;
			format['server globalChat "%1-%2 was a robber and disconnected too early, money returned";', _player, (name _player)] call broadcast;
		};
};
