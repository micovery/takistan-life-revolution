#define strM(x) ([x, ","] call format_integer)

A_impound_check = {
//		((["impound_lot", (_this select 0)] call vehicle_storage_contains))
		
		private["_vehicle"];
		_vehicle = objNull;
		
		if ((typeName (_this select 0)) == "STRING") then {
				missionNamespace getVariable [(_this select 0), objNull]
			}else{
				(_this select 0)
			};
		
		if (isNull _vehicle) exitwith {false};
		
		((_vehicle distance impoundarea2) <= 100)
	};

A_impound = {
		private["_vcl", "_crew"];
		
		_vcl = _this select 0;
		
	
		if(!alive _vcl)exitwith{deleteVehicle _vcl;};	
		if([str(_vcl)] call A_impound_check)exitwith{};
		
		
		_crew = crew _vcl;
		{
			_x action ["Eject",_vcl];
		} forEach _crew;
		
		sleep 0.1;
		
		_vcl setPosATL [(getPosATL impoundarea1 select 0)-(random 50)+(random 50), (getPosATL impoundarea1 select 1)-(random 50)+(random 50), getPosATL impoundarea1 select 2];
		
		_vcl engineOn false;
		_vcl lock true;
		
		_vcl setVariable ["impoundTime", time, true];
	
/*		[_storage, _player, _vcl] call vehicle_storage_put;
		[_vcl] call vehicle_save_stats;
		
		[_vcl] call vehicle_unload_stats; //no need to keep the vehicle stats in memory anymore
		
		deleteVehicle _vcl;
*/	
	};
	
A_impound_vacant = {
		private["_vc"];
		_vcl = _this select 0;
		[_vcl] spawn A_impound;
		format['hintSilent format["%1 has been vacant for too long and impounded",  %1]', _vcl] call broadcast;
	};
	
A_impound_spawnBlock = {
		private["_vcl"];
		_vcl = _this select 0;
		[_vcl] spawn A_impound;
		format['hintSilent format["%1 has been impounded for blocking a spawn",  %1]', _vcl] call broadcast;
	};

A_impound_action = {
		private["_vcl"];
	
		_vcl = _this select 0;
		
		if(!alive _vcl) exitwith {
				player groupchat "Removing Wreck"; 
				deleteVehicle _vcl; 
			};
		
		if ((count crew _vcl) > 0) exitWith {
				player groupChat "The vehicle is not empty!"
			};

		if([_vcl] call A_impound_check)exitwith{
				player groupchat "the vehicle is already impounded!"
			};

		if(_vcl iskindof "air")exitwith { 
				player groupchat "you cannot impound this vehicle!"
			};
		
		if ( ({_vcl in (list _x)} count INV_VehiclePark) > 0 ) exitwith {
				player groupchat "this vehicle is in a carpark. you cannot impound it!"
			};
		
		[_vcl] spawn A_impound;
		player groupChat localize "STRS_inventar_impound_success";
		format['hintSilent format[localize "STRS_inventar_impound_gesehen", "%1", "(%2)", %3]', name player, player, _vcl] call broadcast;
	};

A_impound_dialog = {
		disableSerialization;
		if (!(createDialog "distribute")) exitWith {hint "Dialog Error!"};
		_DFML = findDisplay -1;
		
		lbClear 1;
		lbClear (_DFML displayCtrl 1);
		
		private "_j"; 
		ctrlSetText [3, format["Retrieve impounded vehicle ($%1)", strM(impoundpay)]];
		
		private["_vehicles"];
		_vehicles = [];
		_vehicles = [player] call vehicle_list;
		for [{_j=0}, {_j < (count _vehicles)}, {_j=_j+1}] do {
				_vehicle = (_vehicles select _j);
				if (!isNull _vehicle and _vehicle distance impoundarea1 < 200) then {
						_index = (_DFML displayCtrl 1)	lbAdd format["%1 (%2)", _vehicle, typeof _vehicle];
						(_DFML displayCtrl 1)	lbSetData [_index, format["%1", _vehicle]];
					};
			};
		buttonSetAction [2, "[lbData [1, (lbCurSel 1)]] call A_impound_buy;"];
	
		
/*	
		private ["_impound_lot_data"];
		
		_impound_lot_data = ["impound_lot"] call vehicle_storage_data;
		if ((typeName _impound_lot_data) != "ARRAY") exitwith {
				player groupChat format["ERROR: The impound lot has not been initialized"];
			};
		
		
		private["_vehicles_name_list","_impounded_vehicles_name_list", "_impounded_vehicles_data"];
		
		
		_vehicles_name_list = [_player, "vehicles_name_list"] call player_get_array;
		
		_impounded_vehicles_name_list = _impound_lot_data select vehicle_storage_data_keys;
		_impounded_vehicles_entry_list = _impound_lot_data select vehicle_storage_data_entries;


		{
			if (true) then {
					private["_vehicle_name", "_index"];
					_vehicle_name = _x;
					_index = _impounded_vehicles_name_list find _vehicle_name;
					if (_index < 0) exitWith {};
					
					private["_vehicle_entry", "_vehicle_class"];
					_vehicle_entry = _impounded_vehicles_entry_list select _index;
					_vehicle_class = _vehicle_entry select vehicle_storage_data_entry_class;
					
					_index = (_display displayCtrl 1) lbAdd format["%1 (%2)", _vehicle_name, _vehicle_class];
					(_display displayCtrl 1) lbSetData [_index, format["%1", _vehicle_name]];
				};
		} forEach _vehicles_name_list;
		
		buttonSetAction [2, format['[%1, (lbData [1, (lbCurSel 1)])] spawn A_impound_buy;', _player]];
*/		
	};

A_impound_buy = {
		if(([player, "money"] call INV_GetItemAmount) < impoundpay) exitwith {
				player groupchat "you do not have enough money"
			};
		
		private["_logic", "_dir", "_pos"];
		_logic = objNull;
		_dir = 0;
		_pos = [0,0,0];
		
		if ((player distance copcar) <= 5) then {
				_logic = ccarspawn;
				_pos = (getPosATL ccarspawn);
				_dir = (getdir ccarspawn);
			}else{
				if ((player distance impoundbuy1) <= 5) then {
						_logic = impoundarea2;
						_pos = [(getPosATL impoundarea2 select 0)-(random 10)+(random 10), (getPosATL impoundarea2 select 1)-(random 10)+(random 10), getPosATL impoundarea2 select 2];
						_dir = (getdir impoundarea2);
					}else{
						if ((player distance impoundbuy2) <= 5) then {
								_logic = impoundarea3;
								_pos = (getPosATL impoundarea3);
								_dir = (getdir impoundarea3);
							};
					};
			};
			
		if (isNull _logic) exitwith {
				player groupchat "Impound Error: Logic Null";
			};
		
		
		if(count (nearestobjects [getPosATL _logic, ["Ship","car","motorcycle","truck"], 3]) > 0) exitWith {
				player groupChat format["WARNING: Unable to retrieve vehicle, there is a vehicle blocking the spawn"];
			};
		
		player groupChat format["Please wait while your vehicle is retrieved ..."];
		
		_vehicle = ObjNull;
		_vehicle = _this select 0;
		
		if ((typeName _vehicle) == "STRING") then {
				_vehicle = missionNamespace getVariable [_vehicle, objNull];
			};
		
		if (isNull _vehicle) exitwith {player groupchat "Vehicle Retrieval Failed"};
		
		[player, "money", -impoundpay] call INV_AddInventoryItem;
		
		
/*		private["_storage"];
		_storage = "impound_lot";
		
		if (not([_storage, _vehicle_name] call vehicle_storage_contains)) exitWith {
			player groupChat format["ERROR: The vehicle '%1' was not found in the impound lot", _vehicle_name];
		};
		
		private["_vehicle_entry"];
		_vehicle_entry = [_storage, _vehicle_name] call vehicle_storage_get;
		if ((typeName _vehicle_entry) != "ARRAY") exitWith {
			player groupChat format["ERROR: THe vehicle '%1' could not be retrived form the impound lot", _vehicle_name];
		};
		
		private["_vehicle_class", "_vehicle"];
		_vehicle_class = _vehicle_entry select vehicle_storage_data_entry_class;
		
		_vehicle = [_vehicle_name, _vehicle_class] call vehicle_recreate;
		[_storage, _vehicle_name] call vehicle_storage_remove;
*/
		
		_vehicle setPosATL _pos;
		_vehicle setDir _dir;

		player groupchat format["You payed the $%1 fine and retrieved your vehicle!", impoundpay];
	};











	