//if (isServer && !isDedicated) exitWith {};
#define kvlist 5003 

if (not(isNil "retribution_functions_defined")) exitWith {};

ks_type = 0;
ks_name = 1;
ks_uid = 2;
ks_money = 3;
ks_euid = 4;

vs_type = 0;
vs_name = 1;
vs_uid = 2;
vs_money = 3;
vs_euid = 4;

add_killer = {
	private ["_killers", "_killer", "_type", "_lost_money", "_killer_name", "_killer_uid", "_victim_uid", "_euid", "_killer_data", "_killer_fletter"];
	_killer = _this select 0;
	_type = _this select 1;
	_lost_money = [] call determine_retribution;
	_killer_name = name _killer;
	_killer_uid = getPlayerUID _killer;
	_victim_uid = getPlayerUID player;
	_euid = format["%1_%2_%3", _victim_uid, time, _type];
	
	_killer_data = [];
	_killer_data set [ks_name, toArray _killer_name];
	_killer_data set [ks_uid, _killer_uid];
	_killer_data set [ks_money, _lost_money];
	_killer_data set [ks_type, _type];
	_killer_data set [ks_euid, _euid ];
	
	_killer_fletter =  (toArray _killer_name) select 0;
	_killers =  player getVariable "killers";
	
	if (isNil "_killers") then { _killers = []; };
	if (typeName _killers != "ARRAY") then { _killers = []; };
	
	_killers set[(count _killers), _killer_data];
	
	//player groupChat format["Adding-Killer: %1", _killer_data];
	//player groupChat format["All-Killers: %1", _killers];
	
	player setVariable ["killers", _killers, true];
	
	format[
	'
		private["_puid", "_pfletter", "_victim", "_killer_uid", "_killer_fletter", "_type", "_euid", "_lost_money"];
		_puid = getPlayerUID player;
		_pfletter =  (toArray (name player)) select 0;
		
		_victim = %1;
		_killer_uid = "%2";
		_killer_fletter = %3;
		_type = "%4";
		_euid = "%5";
		_lost_money = %6;
		
		if (_puid == _killer_uid && _pfletter == _killer_fletter ) then
		{
			[_victim, _type, _euid, _lost_money] call add_victim;
		};
	', player, _killer_uid, _killer_fletter, _type, _euid, _lost_money] call broadcast;
};

add_victim = {
	private ["_victims","_victim","_type","_euid","_lost_money","_victim_name","_victim_uid","_victim_data"];
	_victim = _this select 0;
	_type = _this select 1;
	_euid = _this select 2;
	_lost_money = _this select 3;
	
	_victim_name = name _victim;
	_victim_uid = getPlayerUID _victim;
	
	_victim_data = [];
	_victim_data set [vs_name, toArray _victim_name];
	_victim_data set [vs_uid, _victim_uid];
	_victim_data set [vs_money, _lost_money];
	_victim_data set [vs_type, _type];
	_victim_data set [vs_euid, _euid];
		
	_victims = player getVariable "victims";
	if (isNil "_victims") then { _victims = []; };
	if (typeName _victims != "ARRAY") then { _victims = []; };
	
	_victims = _victims + [_victim_data];
	
	//player groupChat format["Adding-victim: %1", _victim_data];
	//player groupChat format["All-victim: %1", _victims];
	
	player setVariable ["victims", _victims, true];
};

remove_killer = {
	private["_i","_euid","_killers","_new_killers","_killer_data","_ceuid"];
	_euid = _this select 0;
	
	_killers = player getVariable "killers";
	if (isNil "_killers" || typeName _killers != "ARRAY") then { _killers = []; };
	
	_i = 0;
	_new_killers = [];
	for [{_i = 0}, {_i < (count _killers)}, {_i = _i + 1}] do {
		_killer_data = _killers select _i;
		_ceuid = _killer_data select ks_euid;
		if (_ceuid != _euid) then {
			_new_killers = _new_killers + [_killer_data];
		};
	};
	
	_killers = _new_killers;
	
	player setVariable["killers", _killers, true];
};

remove_victim = {
	private["_euid","_victims","_i","_new_victims","_ceuid","_victim_data"];
	_euid = _this select 0;
	
	_victims = player getVariable "victims";
	if (isNil "_victims" || typeName _victims != "ARRAY") then { _victims = []; };
	
	_i = 0;
	_new_victims = [];
	for [{_i = 0}, {_i < (count _victims)}, {_i = _i + 1}] do {
		_victim_data = _victims select _i;
		_ceuid = _victim_data select vs_euid;
		if (_ceuid != _euid) then {
			_new_victims = _new_victims + [_victim_data];
		};
	};
	
	_victims = _new_victims;
	player setVariable["victims", _victims, true];
};

calculate_fees = {
	private ["_damages", "_fees","_all_money","_p20"];
	_damages = _this select 0;
	_fees = 0;
	
	_all_money = [player] call player_get_total_money;
	_p20 = ceil(_all_money * 0.05);
	if (_p20 > _damages) then {
		_fees = _p20 - _damages;
	};
	
	_fees
};

fill_retributions = {
	lbClear kvlist;
	private ["_victims", "_damages", "_fees", "_victim_data", "_type", "_victim_name", "_victim_uid", "_lost_money", "_index"];
	
	_victims = [];
	_victims =  player getVariable ["victims", []];
	{
		_victim_data = _x;
		_type = _victim_data select vs_type;
		_victim_name = toString (_victim_data select vs_name);
		_victim_uid = _victim_data select vs_uid;
		_lost_money = _victim_data select vs_money;
		
		
		_damages = _lost_money;
		_fees = [_damages] call calculate_fees;

		if (_type == "TK") then {
			_index = lbAdd [kvlist, format ["victim(TK): %1 (+$%2, +$%3)", _victim_name, _damages, _fees]];
			lbSetData [kvlist, _index, format["%1", ["vtk", _victim_data]]];
			lbSetColor [kvlist, _index, [0, 1, 0, 1]];
		}
		else { if ( _type == "DM") then {
			_index = lbAdd [kvlist, format ["victim(DM): %1 (+$%2, +$%3)", _victim_name, _damages, _fees]];
			lbSetData [kvlist, _index, format["%1", ["vdm", _victim_data]]];
			lbSetColor [kvlist, _index, [0, 1, 0, 1]];
		};};
	} foreach _victims;
	
	private["_killers","_killer_data","_killer_name","_killer_uid"];
	
	_killers =  player getVariable ["killers", []];
	{
		_killer_data = _x;
		_type = _killer_data select ks_type;
		_killer_name = toString (_killer_data select ks_name);
		_killer_uid =  _killer_data select ks_uid;
		_lost_money = _killer_data select ks_money;
		
		if (_type == "TK") then {
			_index = lbAdd [kvlist, format ["Killer(TK): %1 (Set ablaze, -$%2)", _killer_name, _lost_money]];
			lbSetData [kvlist, _index, format["%1", ["ktk", _killer_data]]];
			lbSetColor [kvlist, _index, [1, 0, 0, 1]];
		}
		else { if ( _type == "DM") then {
			_index = lbAdd [kvlist, format ["Killer(DM): %1 (-$%2)", _killer_name, _lost_money]];
			lbSetData [kvlist, _index, format["%1", ["kdm", _killer_data]]];
			lbSetColor [kvlist, _index, [1, 0, 0, 1]];
		};};
		
	} foreach _killers;
	
};

open_retributions =  {
	if (dialog) exitWith { closeDialog 0; };
	private["_ok"];
	_ok = createDialog "Retribution";
	if (not(_ok)) then { 
		player groupChat "Unable to open the retributions dialog";
	};
	
	[] call fill_retributions;	
};


get_retribution_selection = {
	private["_selected_index","_selection"];
	_selected_index = lbCurSel kvlist;
	if (isNil "_selected_index" || typeName _selected_index != "SCALAR" || _selected_index < 0) exitWith { nil };
	_selection = [] call compile lbData [kvlist, _selected_index];
	_selection
};

kill_type_2_str = {
	private["_type"];
	_type = _this select 0;
	
	if (_type == "vtk" || _type == "ktk") exitWith { "team-killing" };
	if (_type == "vdm" || _type == "kdm" ) exitWith { "death-matching" };
	
	"unknown"
};

compensate_player = {
	private["_selection","_type","_p_data","_killer_name","_victim_name","_victim_fletter","_victim_uid","_lost_money","_euid"];
	_selection = [] call get_retribution_selection;
	if (isNil "_selection") exitWith { player groupChat "You have not selected a player to compensate";};
	_type = _selection select 0;
	_p_data = _selection select 1;
	if ( !(_type == "vtk" || _type == "vdm")) exitWith { player groupChat "You can only compensate team-kill or death-match victims";};
	
	_killer_name = (name player);
	_victim_name = toString (_p_data select vs_name);
	_victim_fletter = (toArray _victim_name) select 0;
	_victim_uid = _p_data select vs_uid;
	_lost_money = _p_data select vs_money;
	_euid = _p_data select vs_euid;
	
	private ["_message", "_damages", "_fees", "_type_str", "_compensation_money"];
	
	_damages = _lost_money;
	_fees = [_damages] call calculate_fees;
	_type_str = [_type] call kill_type_2_str;
	
	_message = format["%1 paid $%2 in damages to %3 for %4", _killer_name, _damages, _victim_name, _type_str];
	format[' server globalChat "%1"; ', _message] call broadcast;

	if (_fees > 0) then {
		_message = format["%1 paid additional $%2 in criminal fees, for %3", _killer_name, _fees, _type_str];
		format['server globalChat "%1"; ', _message] call broadcast;
	};
	
	_compensation_money = _damages + _fees;
	[player, _compensation_money] call player_lose_money;
	
	[_euid] call remove_victim;
	[] call fill_retributions;
	
	format[
	'
		private["_pname","_puid","_pfletter","_victim_name","_victim_fletter","_victim_uid","_euid","_damages"];
		_pname = name player;
		_puid = getPlayerUID player;
		_pfletter = (toArray _pname) select 0;
		
		_victim_name = "%1";
		_victim_fletter = %2;
		_victim_uid = "%3";
		_euid = "%4";
		_damages = %5;
		
		if (_victim_uid == _puid && _victim_fletter == _pfletter) then {
			[_euid] call remove_killer;
			[] call fill_retributions;
			[_damages] call bank_transaction;
		};
	', _victim_name, _victim_fletter, _victim_uid, _euid, _damages] call broadcast;
};



punish_player = {	
	private["_selection"];
	_selection = [] call get_retribution_selection;
	if (isNil "_selection") exitWith { player groupChat "You have not selected a player to punish";};
	private["_type","_p_data"];
	_type = _selection select 0;
	_p_data = _selection select 1;
	if ( !(_type == "ktk" || _type == "kdm")) exitWith { player groupChat "You can only punish team-killer or death-matchers";};
	
	private["_victim_name", "_killer_name", "_killer_fletter", "_killer_uid", "_killer_money", "_euid"];
	_victim_name = (name player);
	_killer_name = toString (_p_data select ks_name);
	_killer_fletter = (toArray _killer_name) select 0;
	_killer_uid = _p_data select ks_uid;
	_killer_money = _p_data select ks_money;
	_euid = _p_data select ks_euid;
	
	private ["_message", "_damages", "_fees", "_type_str"];
	
	_damages = _killer_money;
	_type_str = [_type] call kill_type_2_str;
	


	

	
	private["_konline"];
	_konline = false;
	{
		if ((getPlayerUID _x) == _killer_uid) exitWith {
			_konline = true;
		};
	} foreach playableUnits;
	
	if (not(_konline)) then {
		//Killer Offline
		_damages = _damages * 1.5;
		[_killer_uid, "remaining_ret", [_type, _euid, _damages, player]] call stats_player_save_offline;
		//Comp dodge message
		_message = format["%1 collected $%2 in damages from %3, for %4. %3 comp dodged and will be punished next time he logs in!", _victim_name, _damages, _killer_name, _type_str];
		format[' server globalChat "%1"; ', _message] call broadcast;
	
		
	} else {
	
		_message = format["%1 collected $%2 in damages from %3, for %4", _victim_name, _damages, _killer_name, _type_str];
		format[' server globalChat "%1"; ', _message] call broadcast;
		format[
		'
			private["_pname","_puid","_pfletter"];
			_pname = name player;
			_puid = getPlayerUID player;
			_pfletter = (toArray _pname) select 0;

			private ["_damages", "_fees", "_killer_name", "_killer_fletter", "_killer_uid", "_euid", "_type", "_victim"];
		
			_killer_name = (name player);
			_killer_fletter = %1;
			_killer_uid = "%2";
			_euid = "%3";
			_damages = %4;
			_type = "%5";
			_victim = %6;
		
			if (_killer_uid == _puid && _killer_fletter == _pfletter) then {
				[_type, _euid, _damages, _victim] call punished_logic;
			};
		', _killer_fletter, _killer_uid, _euid, _damages, _type, player] call broadcast;
	};
	[player, _damages] call bank_transaction;
	[_euid] call remove_killer;
	[] call fill_retributions;
};


punished_logic = {
	private ["_damages", "_fees", "_message", "_type_str", "_type", "_euid", "_killer_name", "_victim", "_punish_money"];
	
	_type = _this select 0;
	_euid = _this select 1;
	_damages = _this select 2;
	_victim = _this select 3;
	_killer_name = (name player);
	
	[_euid] call remove_victim;
	[] call fill_retributions;

	_fees = [_damages] call calculate_fees;
	_type_str = [_type] call kill_type_2_str;
	
	_punish_money = _damages + _fees;
	[player, _punish_money] call player_lose_money;
	
	if (_type == "ktk") then {
		_message = format["%1 was set ablaze as punishment for %2", _killer_name, _type_str];
		format[' server globalChat "%1"; ', _message] call broadcast;
		[] call setablaze_player;
		[player, _victim] spawn tk_penalty;
	};

	if (_fees > 0) then {
		_message = format["%1 paid additional $%2 in criminal fees, for %3", _killer_name, _fees, _type_str];
		format[' server globalChat "%1"; ', _message] call broadcast;
	};
	
	
};

forgive_player = {	
	private["_selection"];
	_selection = [] call get_retribution_selection;
	if (isNil "_selection") exitWith { player groupChat "You have not selected a player to punish";};
	private["_type","_p_data"];
	_type = _selection select 0;
	_p_data = _selection select 1;
	if ( !(_type == "ktk" || _type == "kdm")) exitWith { player groupChat "You can only forgive team-killer or death-matchers";};
	
	private["_victim_name","_killer_name","_killer_fletter","_killer_uid","_killer_money","_euid"];
	_victim_name = (name player);
	_killer_name = toString (_p_data select ks_name);
	_killer_fletter = (toArray _killer_name) select 0;
	_killer_uid = _p_data select ks_uid;
	_killer_money = _p_data select ks_money;
	_euid = _p_data select ks_euid;
	
	private ["_message","_type_str"];
	_type_str = [_type] call kill_type_2_str;

	_message = format["%1 forgave %2 for %3", _victim_name, _killer_name, _type_str];
	format[' server globalChat "%1"; ', _message] call broadcast;

	[_euid] call remove_killer;
	[] call fill_retributions;
	
	format[
	'
		private["_pname","_puid","_pfletter","_killer_fletter","_killer_uid","_euid","_killer_money","_type"];
		_pname = name player;
		_puid = getPlayerUID player;
		_pfletter = (toArray _pname) select 0;
		
		_killer_fletter = %1;
		_killer_uid = "%2";
		_euid = "%3";
		_killer_money = %4;
		_type = "%5";
		
		if (_killer_uid == _puid && _killer_fletter == _pfletter) then {
			[_euid] call remove_victim;
			[] call fill_retributions;
		};
	', _killer_fletter, _killer_uid, _euid, _killer_money, _type] call broadcast;
};

setablaze_player = {
	[] spawn {
		if (!(alive player)) exitWith {};
		
		private ["_damage"];
		format["[%1, 5, time, false,false] spawn BIS_Effects_Burn;", player] call broadcast;
		_damage = damage player;
		if (isNil "_damage" || typeName _damage != "SCALAR" || _damage < 0) then { _damage = 0;};
		while { _damage < 1 } do {
			
			format["if (missionNamespace getVariable [""player_rejoin_camera_complete"", true])then{[%1, player] say3D ""wilhelm"";};", player] call broadcast;
			_damage = _damage + 0.1;
			player setDamage _damage;
			[player] call player_client_saveDamage;
			sleep 6;
		};
	};
};

determine_retribution = {
	private["_lost_money", "_default_comp"];
	_lost_money  = [player, 'money'] call INV_GetItemAmount;
	
	_default_comp = 20000;
	if (isNil "_lost_money" || typeName _lost_money != "SCALAR" || _lost_money < _default_comp) then {
		_lost_money = _default_comp
	}
	else { if ( _lost_money <= 100000) then {
		_lost_money = round( _lost_money * 0.75);
	} 
	else { if (_lost_money > 100000 && _lost_money <= 250000) then {
		_lost_money = round( _lost_money * 0.50);
	}
	else { if (_lost_money > 250000 && _lost_money <= 500000) then {
		_lost_money = round( _lost_money * 0.25);
	}
	else { if (_lost_money > 500000 && _lost_money <= 1000000) then {
		_lost_money = round( _lost_money * 0.10);
	}
	else { if (_lost_money > 1000000) then {
		_lost_money = _default_comp;
	};};};};};};
	
	_lost_money
};

get_near_vehicle_driver =  {
	if ([] call fallCheck) exitwith {objNull};
	private["_driver", "_near_vehicles"];
	_driver = objNull;
	_near_vehicles = nearestObjects [(getPosATL player), ["Tank", "Motorcycle", "Car", "Air"], 10];
	//player groupChat format["Near VEHS: %1", _near_vehicles];
	{
		if ((speed _x > 10) and (!(isNull(driver _x)))) exitWith {
			_driver	= driver _x;
		};
	} forEach _near_vehicles;
	if (isNull(_driver)) then {
		{
			if ((speed _x > 10) and (!(isNull(gunner _x)))) exitWith {
				_driver = gunner _x;
			};
		} forEach _near_vehicles;
	};
	if (isNull(_driver)) then {
		{
			if ((speed _x > 10) and (!(isNull(crew _x)))) exitWith {
				if (count (crew _x) > 1) then {
					//To be fair I randomize here - I don't know who was on driver seat last time
					_driver = (crew _x) select (floor(random (count _x)));
				} else {
					_driver = (crew _x) select 0;
				};
			};
		} forEach _near_vehicles;
	};
	_driver
};

fallCheck = {
	private["_return","_falling"];
	_return = false;
	_falling = missionNamespace getVariable ["falling", -1];
	
	if (_falling <= 0)exitwith{_return};
	_return = (time - _falling) < 5;
	
	_return
};

//INDEXES FOR DEATH-PARAMETERS DATA STRUCTURE
dp_killer = 0;
dp_victim  = 1;
dp_victim_side = 2;
dp_killer_side = 3;
dp_is_victim_armed = 4;
dp_victim_bounty = 5;
dp_is_victim_criminal = 6;
dp_is_teamkill = 7;
dp_justified = 8;
dp_is_suicide = 9;
dp_killer_name = 10;
dp_victim_name = 11;
dp_is_roadkill = 12;
dp_enemies = 13;
dp_killer_uid = 14;
dp_victim_uid = 15;
dp_illSkin = 16;
dp_illVeh = 17;
dp_vehSuicide = 18;
dp_respawn = 19;
dp_PMC_victim = 20;
dp_PMC_Killer = 21;
dp_collateral = 22;

compute_death_parameters = {
	private["_killer", "_near_driver", "_victim_vehicle", "_crew", "_killer_name", "_victim_name", "_roadkill", "_is_driver_near", "_suicide", "_vehicleOut", "_vehSuicide","_respawnTime","_respawn"];
	_killer = _this select 0;
	
	_victim_vehicle = _this select 1;
	_victim_vehicle = if (isNull _victim_vehicle) then {objNull}else{if(_victim_vehicle == player)then{objNull}else{_victim_vehicle}};
	_crew = if (isNull _victim_vehicle) then {[]}else{crew _victim_vehicle};
	
	_near_driver =  [] call get_near_vehicle_driver;
	
	_killer_name = (name _killer);
	_victim_name = (name player);
	
	_vehicleOut = missionNamespace getVariable ["vehicleOut", []];
	_vehSuicide = false;
	if !(isNull _near_driver) then {
			if ((count _vehicleOut) > 0) then {
					if ((time - (_vehicleOut select 3)) < 3) then {
							_vehSuicide = true;
						};
				};
		};
		
	_respawnTime = missionNamespace getVariable ["respawnButtonPressed", -1];
	_respawn = false;
	if (_respawnTime > 0) then {
		if ((time - _respawnTime) < 60) then {
			_respawn = true;
		};
	};

		
	_roadkill = false;
	_is_driver_near = !(isNull _near_driver);
	
	_suicide = (_killer_name == _victim_name) || _vehSuicide || _respawn;
	if (_suicide && _is_driver_near && !_vehSuicide && !_respawn) then {
		_killer = _near_driver;
		_killer_name = (name _near_driver);
		_roadkill = true;
		_suicide = false;
	};
	
	private["_victim_armed", "_victim_illSkin", "_victim_illVeh", "_victim_side", "_killer_side", "_victim_bounty", "_victim_criminal", "_teamkill", "_justified", "_enemies", "_killer_uid", "_victim_uid", "_victim_PMC", "_killer_PMC", "_wantedtype"];
	
	_victim_armed = ([player] call player_shotRecently) || ([player] call player_armed) || ([player, _victim_vehicle] call player_vehicle_armed) || ([player] call player_armedBefore);
	
	_victim_illSkin = [player] call player_illSkin;
	_victim_illVeh = [player, _victim_vehicle] call player_illVeh;
	
	_victim_side = [player] call stats_get_faction;
	_killer_side = [_killer] call stats_get_faction;
	_victim_bounty = [player] call player_get_bounty;
	_victim_criminal =  (_victim_bounty > 0);
	_wantedtype = [player] call player_get_wantedtype;
	
	_killer_uid = getPlayerUID _killer;
	_victim_uid = getPlayerUID player;
	
	_victim_PMC = [player] call player_isPMC;
	_killer_PMC = [_killer] call player_isPMC;
	
	_collateral = [player, _victim_vehicle, _crew] call player_collateralVehicle;
	
	_teamkill = ((_victim_side == _killer_side) && (_victim_side != "Civilian")) || ((_victim_PMC && !_victim_criminal) && _killer_PMC) || ((_victim_PMC && !_victim_criminal) && (_killer_side == "Cop")) || (_killer_PMC && (_victim_side == "Cop"));
	_justified = (_victim_armed || _victim_illSkin || _victim_illVeh || _collateral || ((_victim_criminal) and (_wantedtype >= 200))) && !(_victim_PMC && _victim_criminal && (_wantedtype >= 200));
	_enemies = ((_killer_side != _victim_side) && !((_victim_side == "Civilian") || (_killer_side == "Civilian"))) || (_killer_PMC && (_victim_side in ["Opfor", "Insurgent"]));
	
	private["_result"];
	_result = [];
	_result set [dp_killer, _killer];
	_result set [dp_victim, player];
	_result set [dp_victim_side, _victim_side];
	_result set [dp_killer_side, _killer_side];
	_result set [dp_is_victim_armed,  _victim_armed];
	_result set [dp_victim_bounty, _victim_bounty];
	_result set [dp_is_victim_criminal, _victim_criminal];
	_result set [dp_is_teamkill, _teamkill];
	_result set [dp_justified, _justified];
	_result set [dp_is_suicide, _suicide];
	_result set [dp_victim_name, _victim_name];
	_result set [dp_killer_name, _killer_name];
	_result set [dp_is_roadkill, _roadkill];
	_result set [dp_enemies, _enemies];
	_result set [dp_killer_uid, _killer_uid];
	_result set [dp_victim_uid, _victim_uid];
	
	_result set [dp_illSkin, _victim_illSkin];
	_result set [dp_illVeh, _victim_illVeh];
	
	_result set [dp_vehSuicide, _vehSuicide];
	_result set [dp_respawn, _respawn];
	
	_result set [dp_PMC_victim, _victim_PMC];
	_result set [dp_PMC_Killer, _killer_PMC];
	
	_result set [dp_collateral, _collateral];
	
	//player groupChat format["RES: %1", _result];

	_result
};

substr = {
	private["_string","_offset","_length"];
	_string = _this select 0;
	_offset = _this select 1;
	_length = _this select 2;
	
	if (isNil "_string") exitWith {""};
	if (typeName _string != "STRING") exitWith {""};
	
	if (isNil "_offset") exitWith {""};
	if (typeName _offset != "SCALAR") exitWith {""};
	if (isNil "_length") exitWith {""};
	if (typeName _length != "SCALAR") exitWith {""};
	
	private["_array", "_sub_array"];
	_array = toArray _string;
	
	private["_i", "_count"];
	_count = (count _array);
	_sub_array = [];
	
	_i = _offset;
	while { (_i < _count) &&  (_length > 0) } do {
		_sub_array = _sub_array + [ (_array select _i)];
		_i = _i + 1;
		_length = _length - 1;
	};

	if ((count _sub_array) == 0) exitWith {""};
	
	toString _sub_array
};


criminal_reward = {
	private["_dp","_player", "_bounty", "_victim", "_victimBankMoney"];
	
	_dp = _this select 0;
	_bounty = _dp select dp_victim_bounty;
	_player = _dp select dp_killer;
	_victim = _dp select dp_victim;
	
	_victimBankMoney = [_victim] call bank_get_value;
	
	if (isNil "_player") exitWith {};
	if (isNil "_bounty") exitWith {};
	if (typeName _bounty != "SCALAR") exitWith {};
	if (typeName _victimBankMoney != "SCALAR") exitWith {};
	
	if (_player != player) exitWith {};
	
	private["_reward","_sendReward"];
	_reward = floor(_bounty/5);
	if (_victimBankMoney < _reward) then {
		_sendReward = _victimBankMoney;
		player groupChat format["The victim had a bounty of $%1. Because he doesn't have that much money you got 1/5 of the civs money totaling $%2", _reward, _sendReward];
	} else {
		_sendReward = _reward;
		player groupChat format["You got 1/5 of the civs bounty totaling $%1", _sendReward];
	};
	[_player, _sendReward] call bank_transaction; 
	[_victim, -(_sendReward)] call bank_transaction;
	
};

collect_criminal_reward = {
	private["_dp"];
	_dp = _this select 0;
	
	private["_bounty", "_killer"];
	_bounty = _dp select dp_victim_bounty;
	_killer = _dp select dp_killer;
	
	if (_bounty <= 0) exitWith {};
	format["[%1] call criminal_reward;", _dp] call broadcast;	
};

faction_reward = {
	private["_player", "_reward"];
	
	_player = _this select 0;
	_reward = _this select 1;
	
	if (isNil "_player") exitWith {};
	if (isNil "_reward") exitWith {};
	if (typeName _reward != "SCALAR") exitWith {};
	
	if (_player != player) exitWith {};
	
	[_player, _reward] call bank_transaction; 
	player groupChat format["You have received a reward of $%1 for killing an enemy", _reward];
};

collect_faction_reward = {
	private["_dp"];
	_dp = _this select 0;
	
	private["_reward", "_killer"];
	_killer = _dp select dp_killer;
	_reward = 20000;

	format["[%1, %2] call faction_reward;", _killer, _reward] call broadcast;	
};

death_set_wanted = {
	private["_dp", "_reason", "_bounty"];
	_dp = _this select 0;
	_reason = _this select 1;
	_bounty = _this select 2;
	
	private["_roadkill", "_killer_side", "_victim_side", "_victim_name", "_killer"];
	_roadkill = _dp select dp_is_roadkill;
	_killer_side = _dp select dp_killer_side;
	_victim_side = _dp select dp_victim_side;
	_victim_name = _dp select dp_victim_name;
	_killer = _dp select dp_killer;
	
	if (_killer_side == "Cop") exitWith {};
	
	private["_vehicle_str"];
	_vehicle_str = if (_roadkill) then { ", vehicle" } else {""};
	
	private["_wanted_str"];
	_wanted_str = format["(%1, %2-%3%4)", _reason, _victim_side, _victim_name, _vehicle_str];
	//player groupChat format["Setting %1 wanted for %2", _killer, _wanted_str];
	[_killer, _wanted_str, _bounty, -1, false] call player_update_warrants;
};


remove_vehicle_licenses = {
	private["_player"];
	_player = _this select 0;
	if (isNil "_player") exitWith {};

	if (_player != player) exitWith {};
	
	player groupchat "You have lost your vehicle licenses for reckless driving!";
	[_player, ["car","truck"]] call player_remove_licenses;
	
	demerits = 0;
};

remove_weapon_licenses = {
	private["_player"];
	_player = _this select 0;
	if (isNil "_player") exitWith {};
	if (_player != player) exitWith {};
	
	player groupchat "You are now wanted, and lost your gun licenses!";
	[_player, ["pistollicense","riflelicense","automatic"]] call player_remove_licenses;
};

remove_licenses = {
	private["_dp"];
	_dp = _this select 0;
	
	private["_killer_side", "_roadkill", "_killer"];
	_killer_side = _dp select dp_killer_side;
	_roadkill = _dp select dp_is_roadkill;
	_killer = _dp select dp_killer;
	
	if (_killer_side == "Cop") exitWith{};
	
	if (_roadkill) then {
		format["[%1] call remove_vehicle_licenses;", _killer] call broadcast;
	}
	else {
		format["[%1] call remove_weapon_licenses;", _killer] call broadcast;
	};
};


update_killer_stats = {
	private["_dp"];
	_dp = _this select 0;
	
	private["_suicide", "_victim_side", "_killer"];
	_suicide = _dp select dp_is_suicide;
	_victim_side = _dp select dp_victim_side;
	_killer = _dp select dp_killer;
	
	if (_suicide) exitWith {
		[_killer, "selfkilled", 1] call player_update_scalar;
	};
	
	if (_victim_side == "Civilian") exitWith {
		[_killer, "civskilled", 1] call player_update_scalar;
	};
	
	if (_victim_side == "Cop") exitWith {
		[_killer, "copskilled", 1] call player_update_scalar;
	};
};

tk_jail_cop = {
	private["_killer", "_victim"];
	_killer = _this select 0;
	_victim = _this select 1;
	
	if (isNil "_killer") exitWith {};
	if (isNil "_killer") exitWith {};
	
	if (_killer != player) exitWith{};
	if (not([_killer] call player_cop)) exitWith {};
	
//	if (! ((_victim distance copbase1) < 400 || (_killer distance copbase1) < 400 || copskilled > 5)) exitWith {};
	[_killer, "roeprisontime", CopInPrisonTime] call player_set_scalar;
	[_killer] call player_prison_roe;
};

tk_jail_pmc = {
	private["_killer", "_victim"];
	_killer = _this select 0;
	_victim = _this select 1;
	
	if (isNil "_killer") exitWith {};
	if (isNil "_killer") exitWith {};
	
	if (_killer != player) exitWith{};
	if !([_killer] call player_isPMC) exitWith {};
	
	private["_message"];
	_message = format["%1-%2 was sent to Jail for %3 Minutes for ROE Violations", _killer, (name _killer), 3];
	format['server globalChat toString(%1);', toArray(_message)] call broadcast;
	
	format['[%1, %2] call player_prison_time;', _killer, 3] call broadcast;
	format['[%1, %2] call player_prison_bail;', _killer, 50] call broadcast;
	format['[%1] call player_prison_convict;', _killer] call broadcast;
};

tk_penalty = {
	private["_killer","_victim"];
	_killer = _this select 0;
	_victim = _this select 1;
	
	private["_killer_side", "_victim_side", "_killer", "_victim", "_killer_PMC", "_victim_PMC"];
	_killer_side = [_killer] call stats_get_faction;
	_victim_side = [_victim] call stats_get_faction;
	
	_killer_PMC = [_killer] call player_isPMC;
	_victim_PMC = [_victim] call player_isPMC;;
	
	if ((_killer_side == "Opf") || (_killer_side == "Ins")) exitWith {};
	if !(
		(_killer_PMC && _victim_PMC) ||
		((_victim_side == "Cop") && _killer_PMC) ||
		((_killer_side == "Cop") && _victim_PMC) ||
		((_victim_side == "Cop") && (_killer_side == "Cop"))
	) exitwith {};
	
	if (_killer_side == "Cop") exitwith {
			format['[%1, %2] call tk_jail_cop;', _killer, _victim] call broadcast;
		};
	if (_killer_PMC) exitwith {
		format['[%1, %2] call tk_jail_pmc;', _killer, _victim] call broadcast;
	};
	
	// Sends to server to check time, Jail if needed
//	[_killer, _victim] call tk_check;
};

// Sends TK to server for check
tk_check = {
	private["_killer","_victim","_timeKill"];
	_killer = _this select 0;
	_victim = _this select 1;
	_timeKill = time;
	
	format['%1 call tk_check_server', [_killer, _victim, _timeKill]] call broadcast_server;
};

// Server check for TKs, if 3 teamkills in a minute than punish - not used
tk_check_server = {
	private["_killer","_victim","_timeKill"];
	_killer = _this select 0;
	_victim = _this select 1;
	_timeKill = _this select 2;
	
	_array = _killer getVariable ["tkArray", []];
	_array set[(count _array), _timeKill];
	_killer setVariable ["tkArray", _array, false];
	
	_killCount = 0;
	{
		_timeCheck = _this select 0;
		if ((time - _timeCheck) <= 60) then {
			_killCount = _killCount + 1;
		};
	} forEach _array;
	
	if (_killCount >= 3) then {
		if (([_killer] call stats_get_faction) == "Cop") exitwith {
			format['[%1, %2] call tk_jail_cop;', _killer, _victim] call broadcast;
		};
		if ([_killer] call player_isPMC) exitwith {
			format['[%1, %2] call tk_jail_pmc;', _killer, _victim] call broadcast;
		};
	};
};

time_penalty = {
	private["_dp"];
	_dp = _this select 0;
	private["_killer", "_killer_uid"];
	_killer = _dp select dp_killer;
	_killer_uid = getPlayerUID _killer;
	[_killer, "extradeadtime", 30] call player_update_scalar;
};

track_death = {
	private["_dp"];
	_dp = _this select 0;

	private["_victim", "_killer", "_suicide", "_victim_criminal", "_victim_armed", "_victim_side", "_killer_side", "_teamkill", "_enemies", "_victim_PMC", "_killer_PMC", "_victim_illSkin", "_victim_illVeh", "_collateral"];
	_victim = player;
	_killer = _dp select dp_killer;
	_suicide = _dp select dp_is_suicide;
	_victim_criminal = _dp select dp_is_victim_criminal;
	_victim_armed = _dp select dp_is_victim_armed;
	_victim_side = _dp select dp_victim_side;
	_killer_side = _dp select dp_killer_side;

	_teamkill = _dp select dp_is_teamkill;
	_enemies = _dp select dp_enemies;
	
	_victim_illSkin = _dp select dp_illSkin;
	_victim_illVeh = _dp select dp_illVeh;
	
	_victim_PMC = _dp select dp_PMC_victim;
	_killer_PMC = _dp select dp_PMC_Killer;
	
	_collateral = _dp select dp_collateral;
	
	[_dp] call update_killer_stats;
	
	private["_bounty"];
	_bounty = 30000;
	
	suicided = _suicide;
	if (_suicide) exitWith { 
		//no punishment here for suicide
	};
	
	if (_killer_side == "Cop") then {
		[_victim] call player_reset_warrants;
	};
	
	private["_armed_str"];
	_armed_str = if (_victim_armed) then { ", armed" } else {", unarmed"};
	
	private["_criminal_str"];
	_criminal_str = if (_victim_criminal) then { ", criminal" } else {", innocent"};
	
	private["_qualifier"];
	_qualifier = format["%1%2", _armed_str, _criminal_str];
	

	if ((_victim_side == "Civilian") and !(_victim_armed || _victim_criminal || _victim_illSkin || _victim_illVeh || _collateral) && !(_victim_PMC)) exitWith {
		[_dp] call time_penalty;
		[_dp] call remove_licenses;
		[_dp, format["aggravated-crime%1", _qualifier], _bounty] call death_set_wanted; 
	};
	
	if (_teamkill) exitWith {
		[_dp] call time_penalty;
		[_dp] call remove_licenses;
	};
	
	if (_victim_criminal and (_killer_side == "Cop")) then {
		[_dp] call collect_criminal_reward;
	};
	
	if (_enemies && !(isNull _killer)) then {
		[_dp] call collect_faction_reward;
	}
	else { if ((_killer_side == "Civilian") and (_victim_side == "Civilian") && !(_victim_criminal) && _victim_armed) then {
		[_dp] call time_penalty;
		[_dp] call remove_licenses;
		[_dp, format["homicide%1", _qualifier], _bounty] call death_set_wanted; 
	}
	else { if (_killer_side == "Civilian" and _victim_side == "Civilian" and _victim_criminal && not(_victim_armed)) then {
		[_dp] call time_penalty;
		[_dp, format["homicide%1", _qualifier], _bounty] call death_set_wanted; 
	}
	else { if ((_killer_side == "Civilian") and _victim_side == "Civilian" and _victim_criminal && _victim_armed) then {
		[_dp, format["homicide%1", _qualifier], _bounty] call death_set_wanted; 
	}
	else { if (((_killer_side == "Civilian") && !_killer_PMC) and (_victim_side == "Opfor" or _victim_side == "Insurgent")) then {
		[_dp, format["vigilante-crime%1", _qualifier], 0] call death_set_wanted; 
	}
	else { if (_killer_side == "Civilian" and (_victim_side == "Cop")) then {
		[_dp] call time_penalty;
		[_dp] call remove_licenses;
		[_dp, format["federal-crime%1", _qualifier], _bounty] call death_set_wanted; 
	}
	else { if ((_killer_side == "Opfor" || _killer_side == "Insurgent") and (_victim_side == "Civilian") && !_victim_PMC) then {
		[_dp] call time_penalty;
		[_dp] call remove_licenses;
		[_dp, format["war-crime%1", _qualifier], _bounty] call death_set_wanted; 
	}
	else { if (_killer_side == "Cop" and _victim_side == "Civilian") then {
		[_dp] call time_penalty;
	};};};};};};};};
};



victim = {
	private["_killer", "_victim", "_veh"];
	//player groupChat format["In victim!, _this = %1", _this];
	
	_killer = _this select 0;
	_victim = _this select 1;
	_veh = if(count _this > 2)then{_this select 2}else{objNull};
	
//	diag_log format['victim START - %1 - %2 - %3', _this, respawnButtonPressed, missionNamespace getVariable "lastShooter"];
	
	if (isNil "_killer") exitWith {};
	if (isNil "_victim") exitWith {};
	if (_victim != player) exitWith {};
	
	if !(_killer isKindOf "CAManBase") then {
			private["_newKiller"];
			_newKiller = [_killer] call player_vehicleGrabKiller;
			if !(isNull _newKiller) then {
					_killer = _newKiller;
				};
		};
	
	if (!([_killer] call player_exists)) then {
		//hmm, do nothing ...
	} else { if (!([_killer] call player_human)) then {
		[_victim] call player_reset_warrants;
		
		private["_message", "_victim_name"];
		_victim_name = (name _victim);
		_message = "";
		
		_message = switch true do {
				case ([_killer] call player_cop): {
						format["%1 was killed by the UN Stabilization Forces!", _victim_name]
					};
				case ([_killer] call player_opfor): {
						format["%1 was killed by the South Takistan Liberation Army!", _victim_name]
					};
				case ([_killer] call player_insurgent): {
						format["%1 was killed by the Insurgents!", _victim_name]
					};
				case ([_killer] call player_civilian): {
						format["%1 was killed by angry civilians!", _victim_name]
					};
				default {
						format["%1 - Death Message Error", _victim_name];
					};
			};
		
		if ((typeName _message) != "STRING") then {
				_message = format["%1-%2 - Death Message Error #1", _victim, _victim_name];
			}else{
				if (_message == "") then {
						_message = format["%1-%2 - Death Message Error #2", _victim, _victim_name];
					};
			};
		
		format['server globalChat (toString %1);', (toArray _message)] call broadcast;
	} else { 
		//player killed by human
		
		private ["_dp"];
		_dp = [_killer, _veh] call compute_death_parameters;
		format['["Died", "%1"] call Isse_AddCrimeLogEntry', player] call broadcast;
		format['server globalChat "%1";', ([_dp] call get_death_message)] call broadcast;
		
		[_dp] call track_retributions;
		[_dp] call track_death;
	};};
	
//	diag_log format['victim END - %1 - %2 - %3', _this, respawnButtonPressed, missionNamespace getVariable ["lastShooter", objNull]];
};

player_unfair_killed = false;

track_retributions = {
	private["_dp"];
	_dp = _this select 0;
	
	private["_killer", "_suicide", "_victim_armed", "_victim_criminal", "_roadkill", "_victim_side", "_killer_side", "_victim_name", "_killer_name", "_teamkill", "_justified", "_victim_illSkin", "_victim_illVeh"];
	
	_killer = _dp select dp_killer;
	_suicide = _dp select dp_is_suicide;
	_victim_armed = _dp select dp_is_victim_armed;
	_victim_criminal = _dp select dp_is_victim_criminal;
	_roadkill = _dp select dp_is_roadkill;
	_victim_side = _dp select dp_victim_side;
	_killer_side = _dp select dp_killer_side;
	_victim_name = _dp select dp_victim_name;
	_killer_name = _dp select dp_killer_name;
	_teamkill = _dp select dp_is_teamkill;
	_justified = _dp select dp_justified;
	
	_victim_illSkin = _dp select dp_illSkin;
	_victim_illVeh = _dp select dp_illVeh;
	
	_victim_PMC = _dp select dp_PMC_victim;
	_vehSuicide = _dp select dp_vehSuicide;
	_respawn = _dp select dp_respawn;

	
	//Retributions
	if (_suicide ||
		_killer_name == "Error: No vehicle" || 
		_killer_name == "Error: No unit" || 
		_victim_name == "Error: No vehicle" || 
		_victim_name == "Error: No unit") exitWith {};
	
	//player groupChat format["JUST: %1", _justified];
	if ((_victim_side == "Civilian") && !_justified) exitWith {
		[_killer, "DM"] call add_killer;
		player_unfair_killed = true;
	};
	
	if (_teamkill) exitWith {
		[_killer, "TK"] call add_killer;
		player_unfair_killed = true;
	};
};

respawn_retribution = {
	if (isNil "player_unfair_killed" ) exitWith{};
	if (typeName player_unfair_killed != "BOOL") exitWith{};
	if (not(player_unfair_killed)) exitWith {};
	
	player_unfair_killed = false;
	["open"] call retributions_main;
};

get_death_message = {
	private["_dp"];
	_dp = _this select 0;
	
	private["_killer", "_suicide", "_victim_armed", "_victim_criminal", "_roadkill", "_victim_side", "_killer_side", "_victim_name", "_killer_name", "_teamkill", "_justified", "_respawn", "_collateral", "_illSkin", "_illVeh"];
	_killer = _dp select dp_killer;
	_suicide = _dp select dp_is_suicide;
	_victim_armed = _dp select dp_is_victim_armed;
	_victim_criminal = _dp select dp_is_victim_criminal;
	_roadkill = _dp select dp_is_roadkill;
	_victim_side = _dp select dp_victim_side;
	_killer_side = _dp select dp_killer_side;
	_victim_name = _dp select dp_victim_name;
	_killer_name = _dp select dp_killer_name;
	_teamkill = _dp select dp_is_teamkill;
	_justified = _dp select dp_justified;
	
	_illSkin = _dp select dp_illSkin;
	_illVeh = _dp select dp_illVeh;
	
	_respawn = _dp select dp_respawn;
	
	_collateral = _dp select dp_collateral;
	
	if (_respawn) exitWith {
		format["%1 commited suicide, by clicking on respawn", _victim_name];
	};
	
	if (_suicide) exitWith { 
		format["%1 committed suicide", _victim_name];	
	};
	
	//Death messages
	private ["_message", "_armed_str", "_vehicle_str", "_criminal_str", "_veh_str", "_veh_str", "_collateral_str"];

	_armed_str = "Unarmed";
	if (_victim_armed) then { _armed_str = "Armed";};

	_criminal_str = "";
	if (_victim_criminal) then { _criminal_str = "-Criminal";};
	
	_skin_str = "";
	if (_illSkin) then { _skin_str = "-Illegal Skin";};
	
	_veh_str = "";
	if (_illVeh) then { _veh_str = "-Illegal Vehicle";};
	
	_vehicle_str = "";
	if (_roadkill) then {_vehicle_str = " with a vehicle";};
	
	_collateral_str = "";
	if (_collateral) then {_collateral_str = "- Collateral with Vehicle Crew"};
	
	if (_teamkill) exitWith {
		format["%1 team-killed %2 (%3%6 %4)%5", _killer_name, _victim_name, _armed_str, _victim_side, _vehicle_str, _criminal_str];
	};
	
	if (_victim_side == "Civilian") exitWith {
		format["%1 killed %2 (%3%6%7%8%9 %4)%5", _killer_name, _victim_name, _armed_str, _victim_side, _vehicle_str, _criminal_str, _skin_str, _veh_str, _collateral_str];
	};
	
	_message = format["%1 murdered %2 (%3%6%7%8%9 %4)%5", _killer_name, _victim_name, _armed_str, _victim_side, _vehicle_str, _criminal_str, _skin_str, _veh_str, _collateral_str];
	_message
};

retributions_main = {
	handling_retribution = if (isNil "handling_retribution") then {false} else {handling_retribution};
	
	private["_action"];
	_action = _this select 0;
	switch _action do {
		case "open": {
			[] call open_retributions;
		};
		case "compensate": {
			if (handling_retribution) exitWith { hint "Cannot handle compensation request";};
			handling_retribution = true;
			[] call compensate_player;
			handling_retribution = false;
		};
		case "punish": {
			if (handling_retribution) exitWith { hint "Cannot handle punish request";};
			handling_retribution = true;
			[] call punish_player;
			handling_retribution = false;
		};
		case "forgive": {
			if (handling_retribution) exitWith { hint "Cannot handle forgiveness request";};
			handling_retribution = true;
			[] call forgive_player;
			handling_retribution = false;
		};
	};
};

retributions_init = {
	//Check for old comp requests
	["player_rejoin_camera_complete"] call player_wait;
	private["_oldComp"];
	_oldComp = [player, "remaining_ret"] call player_get_array;
	//If nothing to comp exit:
	if (count(_oldComp) <= 0) exitWith {};
	_oldComp call punished_logic;
	[player, "remaining_ret", []] call player_set_array;
};

if (not(isServer)) then {
	[] spawn retributions_init;
};

retribution_functions_defined = true;