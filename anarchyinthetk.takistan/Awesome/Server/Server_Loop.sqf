if !(isServer) exitwith {};

if ((isNil "A_AI_ARRAY")) then {
	A_AI_ARRAY = [university, storage, govMan, bailflag, assassin, hostage, impoundbuy1, impoundbuy2, shop1export, shop2export, shop3export, shop4export, licenseflag6];
		
	{
		private["_shop"];
		_shop = _x select 0;
		A_AI_ARRAY set [count A_AI_ARRAY, _shop];
	} forEach INV_ItemShops;
	
	{
		private["_doc"];
		_doc = _x select 0;
		A_AI_ARRAY set [count A_AI_ARRAY, _doc];
	} forEach A_DK_Array;
	
	{
		private["_shop"];
		_shop = _x select 0;
		A_AI_ARRAY set [count A_AI_ARRAY, _shop];
	} forEach Clothing_Shops;
		
	{
		private["_ai"];
		_ai = _x select 0;
		A_AI_ARRAY set [count A_AI_ARRAY, _ai];
		_ai = _x select 3;
		A_AI_ARRAY set [count A_AI_ARRAY, _ai];
		_ai = _x select 4;
		A_AI_ARRAY set [count A_AI_ARRAY, _ai];
	} forEach all_factories;
	
	{
		private["_ai"];
		_ai = _x;
		A_AI_ARRAY set [count A_AI_ARRAY, _ai];
	} forEach workplacejob_deliveryflagarray;
	
	{
		private["_ai"];
		_ai = _x;
		A_AI_ARRAY set [count A_AI_ARRAY, _ai];
	} forEach bankflagarray;
		
	{
		private["_ai"];
		_ai = _x;
		A_AI_ARRAY set [count A_AI_ARRAY, _ai];
	} forEach drugsellarray;
		
	{
		private["_ai"];
		_ai = _x;
		A_AI_ARRAY set [count A_AI_ARRAY, _ai];
	} forEach shopflagarray;
		
	{
		private["_array"];
		_array = _x select 1;
		{
			A_AI_ARRAY set [count A_AI_ARRAY, _x];
		} forEach _array;
	} forEach INV_Licenses;
		
	{
		private["_dir"];
		_dir = getDir _x;
		_x attachTo [A_ATTACHTO];
		_x setDir _dir;
	} forEach A_AI_ARRAY;
		
	{
		[_x] joinSilent (group server);
	} forEach A_AI_ARRAY;
	
	publicVariable "A_AI_ARRAY";
	
	private["_file", "_fileLoad"];
	
	_file = "server\loop.sqf";
	
	if (_file != "") then {
		_fileLoad = preProcessFileLineNumbers _file;
		if (_fileLoad != "") then {
			[] spawn (compile _fileLoad);
		};
	};
};

private["_sleep", "_counter", "_time", "_time_wait", "_wait"];
_sleep = 5;
_counter = 0;
_time = 0;
_time_wait = 5;
_wait = _time + (60 * _time_wait);

format['SERVER_LOOP: '] call A_DEBUG_S;

while {true} do {

	if (_time >= _wait) then {
		format[''] call A_DEBUG_S;
		format['SERVER_LOOP: FPS MIN- %1 	FPS AVG- %2		TIME- %3 Minutes', diag_fpsmin, diag_fps, round(time / 60)] call A_DEBUG_S;
	};
		
	[] call A_WBL_F_REFRESH_S;
	[] call listFile_refreshAdmins_S;
			
	{
		if ((group _x) != (group server)) then {
			[_x] joinSilent (group server);
		};
	} forEach A_AI_ARRAY;
		
/*	private["_groups"];
	_groups = allGroups;
		
	if (_time >= _wait) then {
		format['SERVER_LOOP: allGroups Count- %1	Empty- %2	West- %3	East- %4	Resistance- %5	Civilian- %6	isNull groups- %7', count _groups, {(count (units _x)) <= 0} count _groups, {(side _x) == west} count _groups, {(side _x) == east} count _groups, {(side _x) == resistance} count _groups, {(side _x) == civilian} count _groups, {isNull _x} count _groups] call A_DEBUG_S;
		format['SERVER_LOOP: allGroups- %1', _groups] call A_DEBUG_S;
	};

	
	{
		private["_group", "_units", "_count"];
		_group = _x;
		_units = units _group;
		_count = count _units;
		
		if (_time >= _wait) then {
			format['SERVER_LOOP: group- %1	units- %2	count- %3	side- %4	isNull- %5', _group, _units, _count, side _group, isNull _group] call A_DEBUG_S;
		};
		
		if (_count <= 0) then {
		//	[dummyobj] joinSilent _group;
		//	[dummyobj] joinSilent A_SHOP_GROUP;
			deleteGroup _group;
		};
			
	} forEach _groups;
		
	if (_time >= _wait) then {
		_groups = allGroups;
		format['SERVER_LOOP: allGroups Count- %1	Empty- %2	West- %3	East- %4	Resistance- %5	Civilian- %6	isNull groups- %7', count _groups, {(count (units _x)) <= 0} count _groups, {(side _x) == west} count _groups, {(side _x) == east} count _groups, {(side _x) == resistance} count _groups, {(side _x) == civilian} count _groups, {isNull _x} count _groups] call A_DEBUG_S;
		format['SERVER_LOOP: allGroups- %1', _groups] call A_DEBUG_S;
	};
*/
		
	{
		private["_string", "_player", "_uid"];
		_string = _x;
		_player	= missionNamespace getVariable [_string, objNull];
		_uid = getPlayerUID _player;
		
		if ((!isNull _player) && (alive _player) && (isPlayer _player) && (_uid != "")) then {
			private["_player_cop","_player_opf","_player_ins"];
			_player_cop = ([_player] call player_cop);
			_player_opf = ([_player] call player_opfor);
			_player_ins = ([_player] call player_insurgent);
			
			if (_player_cop) then {					
				if (A_WBL_V_ACTIVE_COP_1 == 1) then {
					if (!(_uid in A_WBL_V_W_COP_1)) then { 
						[format['
							[] spawn {
									server globalChat "You are not on the Police Whitelist - you will be kicked back to the lobby in 10 seconds";
									sleep 10;
									failMission "END1"; 
								};
						'], _player] call broadcast_client;
					};	
				} else { if (A_WBL_V_ACTIVE_COP_1 == 2) then {
					if ((_uid in A_WBL_V_B_COP_1)) then {
						[format['
							[] spawn {
									server globalChat "You are on the Police Blacklist - you will be kicked back to the lobby in 10 seconds";
									sleep 10;
									failMission "END1";
								};
						'], _player] call broadcast_client;
					};
				};};
			}else{
				if (_player_ins) then {				
					if (A_WBL_V_ACTIVE_COP_1 == 1) then {
						if (!(_uid in A_WBL_V_W_COP_1)) then { 
							[format['
								[] spawn {
										server globalChat "You are not on the Insurgent Whitelist - you will be kicked back to the lobby in 10 seconds";
										sleep 10;
										failMission "END1"; 
									};
							'], _player] call broadcast_client;
						};	
					} else { if (A_WBL_V_ACTIVE_COP_1 == 2) then {
						if ((_uid in A_WBL_V_B_COP_1)) then {
							[format['
								[] spawn {
										server globalChat "You are on the Insurgent Blacklist - you will be kicked back to the lobby in 10 seconds";
										sleep 10;
										failMission "END1";
									};
							'], _player] call broadcast_client;
						};
					};};
				}else{
					if (_player_opf) then {				
						if (A_WBL_V_ACTIVE_COP_1 == 1) then {
							if (!(_uid in A_WBL_V_W_COP_1)) then { 
								[format['
									[] spawn {
											server globalChat "You are not on the Opfor Whitelist - you will be kicked back to the lobby in 10 seconds";
											sleep 10;
											failMission "END1"; 
										};
								'], _player] call broadcast_client;
							};	
						} else { if (A_WBL_V_ACTIVE_COP_1 == 2) then {
							if ((_uid in A_WBL_V_B_COP_1)) then {
								[format['
									[] spawn {
											server globalChat "You are on the Opfor Blacklist - you will be kicked back to the lobby in 10 seconds";
											sleep 10;
											failMission "END1";
										};
								'], _player] call broadcast_client;
							};
						};};
					};
				};
			};
		};
	} forEach playerstringarray;

	if (_time >= _wait) then {
		_wait = _time + (60 * _time_wait);
		format[''] call A_DEBUG_S;
	};
	
	sleep _sleep;
	_time = _time + _sleep;
	_counter = _counter + 1;
	if (_counter >= 5000) exitwith {[] execVM "Awesome\Server\Server_Loop.sqf";};
};