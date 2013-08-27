#include "Awesome\Functions\macro.h"

#define SleepWait(timeA) private["_waittt"]; _waittt = time + timeA; waitUntil {time >= _waittt};

private["_art", "_safe"];
_this = _this select 3;
_art  = _this select 0;
_safe = _this select 1;

switch (toLower _art) do {
		case "rob": {
				
				if(!(call INV_IsArmed) and !debug)exitWith{player groupChat localize "STRS_bank_rob_noweapon";};
				
				
				private["_timeS", "_local_time"];
				
				_timeS = format["robtime%1", _safe];
				_local_time = missionNamespace getVariable [_timeS, 0];
				
				if( (time - _local_time) < (60 * 60) )exitwith{player groupchat "this safe has recently been stolen from and is empty"};
				
				
				if(!robenable)exitwith{player groupchat "you are already robbing the bank"};
				robenable = false;
				
				
				missionNamespace setVariable [_timeS, time];
				publicVariable _timeS;
				
				private["_total_cash", "_local_cash"];
				
				_total_cash = 0;
				_local_cash = 0;
				{
					if (!isNull _x) then {
							if (isPlayer _x) then {
									_total_cash = _total_cash + ([_x] call bank_get_value);
								};
						};
				} forEach playableUnits;
				
				_local_cash = round(_total_cash / 30);
				
				player groupChat format[localize "STRS_bank_rob_info", strM(_local_cash)];
				
				private["_nearCops"];
				_nearCops = [player, 300, true] call player_near_west;
				
				format['[0,1,2,["victim", %1, %2, %3, %4]] execVM "bankrob.sqf";', _safe, _local_cash, player, _nearCops] call broadcast;

				player playmove "AinvPknlMstpSlayWrflDnon_medic";
				SleepWait(5)
				waituntil {animationstate player != "AinvPknlMstpSlayWrflDnon_medic"};
				
				robenable = true;
				
				if (alive player) then {
					[player, 'money', _local_cash] call INV_AddInventoryItem;
					player groupChat format[localize "STRS_bank_rob_success"];
					
					if (_nearCops) then {
							[player, "Bank Robbery", _local_cash, -1, false] call player_update_warrants;
						};
					
					player setVariable ["robTime", time, true];
					
				//	[_local_cash] spawn Bank_Rob_End_Script;
				};

				stolencash = stolencash + _local_cash;

				local_useBankPossible = false;
				rblock = rblock + ((_local_cash/50000)*60);
				_rblock = rblock;

				SleepWait(2)

				if(_rblock != rblock)exitwith{};

				for [{rblock}, {rblock > -1}, {rblock=rblock-1}] do {SleepWait(1)};

				local_useBankPossible = true;
				stolencash = 0;
				rblock = 0;
			};
		case "victim": {
				private["_robpool", "_robber", "_known", "_message", "_bank_account", "_insurances_inv", "_insurances_stor", "_insurance", "_verlust", "_verlustA", "_verlustB", "_pLost"];
				_robpool = _this select 2;
				_robber = _this select 3;
				_known = _this select 4;
				
				_message = "";
				_message = if _known then {
						format[localize "STRS_bank_rob_titlemsg_known", _robber, name _robber]
					}else{
						localize "STRS_bank_rob_titlemsg"
					};
					
				titleText [_message, "PLAIN DOWN"];
				

				{_x say "Bank_alarm";} forEach [_safe, copbase1];

				SleepWait(8)

				["Bank", "civilian", _robpool] spawn Isse_AddCrimeLogEntry;
				server globalchat format["The thief stole $%1!", _robpool];

				SleepWait(4)
				
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
								player groupChat format[localize "STRS_bank_rob_somemoneylost", strM(_pLost), strM(_bank_account)];
							};
						
						default {};
					};
			};
		default {};
	};
