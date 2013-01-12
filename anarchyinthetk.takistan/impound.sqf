liafu = true;
_vcl = _this select 0;
_art = _this select 1;

if(_art == "spawn_remove")then {
	_crew = crew _vcl;
	{
		_x action ["Eject",_vcl];
	} forEach _crew;
	//if ((count crew _vcl) > 0) exitWith {};
	
	sleep 1;
	
	if(_vcl distance impoundarea2 < 10)exitwith{};
	if(!alive _vcl)exitwith{deleteVehicle _vcl;};

	_vcl setpos [(getPosATL impoundarea1 select 0)-(random 50)+(random 50), (getPosATL impoundarea1 select 1)-(random 50)+(random 50), getPosATL impoundarea1 select 2];

	format['hint format["%1 has been impounded for blocking a spawn",  %1]', _vcl] call broadcast;
	_vcl setdamage 0;
	_vcl engineOn false;
	_vcl setvehiclelock "locked";
};

if(_art == "impound")then {
	if ((count crew _vcl) > 0) exitWith {
		player groupChat "The vehicle is not empty!"
	};

	if(_vcl distance impoundarea2 < 30) exitwith {
		player groupchat "the vehicle is already impounded!"
	};

	if(_vcl iskindof "air")exitwith { 
		player groupchat "you cannot impound this vehicle!"
	};

	//if(!alive _vcl)exitwith{player groupchat "you cannot impound this wreck!"};
	if(!alive _vcl) exitwith {
		player groupchat "Removing Wreck"; deleteVehicle _vcl; 
	};

	_incarpark = false;

	//{if ((player distance (_x select 0)) < (_x select 1)) then {_incarpark = true};} forEach INV_VehicleGaragen;
	{if (_vcl in (list _x)) then {_incarpark = true};} foreach INV_VehicleGaragen;

	if(_incarpark) exitwith {
		player groupchat "this vehicle is in a carpark. you cannot impound it!"
	};

	_vcl setpos [(getPosATL impoundarea1 select 0)-(random 50)+(random 50), (getPosATL impoundarea1 select 1)-(random 50)+(random 50), getPosATL impoundarea1 select 2];
	player groupChat localize "STRS_inventar_impound_success";

	format['hint format[localize "STRS_inventar_impound_gesehen", "%1", "(%2)", %3]', name player, player, _vcl] call broadcast;
	liafu = true;
	_vcl setdamage 0;
	_vcl engineOn false;
	_vcl setvehiclelock "locked";
};

if(_art == "buy")then {
	_moneh = [player, "money"] call INV_GetItemAmount;

	if(_moneh < impoundpay) exitwith {
		player groupchat "you do not have enough money"
	};

	if(iscop and count (nearestobjects [getpos ccarspawn,["Ship","car","motorcycle","truck"], 3]) > 0)exitwith{player groupchat "there is a vehicle blocking the spawn!"};

	[player, "money", -impoundpay] call INV_AddInventoryItem;

	_vcl = call compile format["%1", _vcl];

	if(isciv)then {
		_vcl setpos [(getPosATL impoundarea2 select 0)-(random 10)+(random 10), (getPosATL impoundarea2 select 1)-(random 10)+(random 10), getPosATL impoundarea2 select 2];
		_vcl setdir getdir impoundarea2;
	} else {
		_vcl setpos getpos ccarspawn;
		_vcl setdir getdir ccarspawn;
	};

	player groupchat format["You payed the $%1 fine and retrieved your vehicle!", impoundpay];
};

