private["_action"];


_action = _this select 0;
if (_action == "use") then {
	private["_item", "_number"];
    _item = _this select 1;
    _number = _this select 2;
	
    if (!(createDialog "schluessel")) exitWith { hint "Dialog Error!";};

    private["_vehicles"];
    _vehicles = [player] call vehicle_list;
    {
        if (not(isnull _x)) then {
			private["_index"];
            _index = lbAdd [1, format ["%1 (%2)", typeOf _x, _x]];
            lbSetData [1, _index, format ["%1", _x]];
        };
    } forEach _vehicles;

    buttonSetAction [2, 
	"
        if ((lbCurSel 1) > -1) then {
            [""schluessel"",  (([player] call vehicle_list) select lbCurSel 1), lbCurSel 1] execVM ""keys.sqf"";
        };
        closedialog 0;
    "];

    buttonSetAction [4, 
	"
        if ((lbCurSel 1) > -1) then {
			[""dropschluessel"", (([player] call vehicle_list) select lbCurSel 1), lbCurSel 1] execVM ""keys.sqf"";
        };
        closedialog 0;
    "];

    buttonSetAction [5, 
	"
        if ((lbCurSel 1) > -1) then {
            [""schluesseluebergabe"", (([player] call vehicle_list) select lbCurSel 1), lbCurSel 1] execVM ""keys.sqf"";
        };
        closedialog 0;
    "];
};

if (_action == "schluessel") then {
	private["_vcl", "_sel"];
    _vcl = _this select 1;
    _sel = _this select 2;
	
    if (player distance _vcl < 13) then {
        if (not(locked _vcl)) then {
            format ["%1 lock true;", _vcl] call broadcast;
            player groupChat localize "STRS_inv_items_vehiclelock_locked";
        } 
		else {
            format ["%1 lock false;", _vcl] call broadcast;
            player groupChat localize "STRS_inv_items_vehiclelock_unlocked";
        };
    } 
	else {
        player groupChat localize "STRS_inv_items_vehiclelock_closer";
    };
};

if (_action == "dropschluessel") then {
	private["_vcl", "_sel"];
    _vcl = _this select 1;
    _sel = _this select 2;
    [player, _vcl] call vehicle_remove;
    player groupChat localize "STRS_inv_items_weggeworfen";
};

if (_action == "schluesseluebergabe") then {
	private["_vcl", "_sel"];
    _vcl = _this select 1;
    _sel = _this select 2;
	
	private["_player_number", "_player_variable_name", "_player_variable"];
	
    _player_number = call compile INV_InventarGiveReceiver;
    _player_variable_name = playerstringarray select _player_number;
    _player_variable = missionNamespace getVariable _player_variable_name;
	
    
    if (not([_player_variable] call player_exists))  exitWith {
        player groupChat localize "STRS_inv_not_ingame";
    };

    if (_player_variable == player)   exitWith {
        player groupChat localize "STRS_inv_inventar_uebergabe_self";
    };
	
	private["_near_players"];
	_near_players = nearestobjects [getpos player, ["LandVehicle", "Air", "Man"], 20];
    if (not(_player_variable in _near_players) && (player distance _player_variable > 20)) exitWith {
        player groupChat localize "STRS_inv_inventar_uebergabe_distance";
    };

    if (not(alive _vcl) or (isNull _vcl)) exitWith {};
	
	(
		format [
		"
			if (rolestring == ""%1"") then {
				[player, %2] call vehicle_add;
				player groupChat localize ""STRS_inv_items_uebergabe_schluessel_success""
			};
		", _player_variable_name, _vcl] 
	) call broadcast;
            
    player groupChat localize "STRS_inv_items_uebergabe_schluessel_success_self";
};

