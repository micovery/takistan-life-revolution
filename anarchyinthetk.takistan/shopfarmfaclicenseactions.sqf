#include "Awesome\Functions\macro.h"

private ["_counter"];
_counter = 0;

private["_b1", "_b2", "_b3"];
_b1 = 0; _b2 = 0; _b3 = 0;

private["_c1", "_c2", "_c3"];
_c1 = 0; _c2 = 0; _c3 = 0;

private["_Arr1", "_Arr2"];
_Arr1 = [];
_Arr2 = [];

private["_z"];
for [{_z=0}, {_z < (count INV_FarmItemArray)},{_z=_z+1}] do {
	_Arr1 set[count _Arr1, 0];
};

private["_z"];
for [{_z=0}, {_z < (count INV_Licenses)},{_z=_z+1}] do {
	_Arr2 set[count _Arr2, 0];
};

shopusearray = [];
sleep 10;

//==================================SHOPACTIONS========================================

for [{_z=0}, {_z < (count INV_ItemShops)}, {_z=_z+1}] do {
	private["_object"];
	_object   = ((INV_ItemShops select _z) select 0);
	shopusearray set[(count shopusearray), _object];
};

//===================================FARMING===============================================

private["_arr", "_added", "_isInArea", "_hasVehicle", "_license", "_flags", "_licensename", "_cost", "_added", "_flag1", "_flag2", "_flag3", "_flag4", "_CShopa", "_CLocation", "_PShopa", "_PSpawn", "_PLocation_1", "_veh"];

_license = "";
_flags = [];
_cost = -1;

while {true} do {
	for [{_z = 0}, {_z < (count INV_FarmItemArray)}, {_z = _z + 1}] do {
		_arr    = (INV_FarmItemArray select _z);
		_added  = (_Arr1 select _z);
		_isInArea = false;
		
		if(iscop and ((_arr select 1) == "Whale" or (_arr select 1) == "Unprocessed_cocain")) exitWith {}; 
		
		{
			if (((vehicle player) distance (getMarkerPos (_x select 0))) < (_x select 1)) then {_isInArea = true;};
		} forEach (_arr select 0);

		_hasVehicle = false;

		{
			if ((vehicle player) isKindOf _x) then {_hasVehicle = true;};
		} forEach (_arr select 4);

		if ((_isInArea) and (_hasVehicle) and (speed (vehicle player) > 2 or ((_arr select 4) select 0) == "Ship")) then {
			[(_arr select 1), (_arr select 2), (_arr select 3), (_arr select 4)] execVM "gathergen.sqf";
		};
	};
	//======================================LICENSES=========================================
	for [{_z = 0}, {_z < (count INV_Licenses)}, {_z = _z + 1}] do {
		_license     	= ((INV_Licenses select _z) select 0);
		_flags        	= ((INV_Licenses select _z) select 1);
		_licensename 	= ((INV_Licenses select _z) select 2);
		_cost        	= ((INV_Licenses select _z) select 3);
		
		_added       	= _Arr2 select _z;
		_flag1			= (_flags select 0);
		_flag2			= (_flags select 1);
		_flag3			= (_flags select 2);
		_flag4			= (_flags select 3);

		if ( ((player distance _flag1 <= 5) OR (player distance _flag2 <= 5) OR (player distance _flag3 <= 5) OR (player distance _flag4 <= 5)) AND !(_license call INV_HasLicense) and (_added == 0) ) then {
		//		[] call compile format ["a_license%1 = player addaction [format[localize ""STRS_inv_actions_buy"", ""%2"", ""%3""], ""addlicense.sqf"", [%1, ""add""]];", _z, _licensename, strM(_cost)];
				missionNamespace setVariable [format["a_license%1", _z], (
						player addaction [format[localize "STRS_inv_actions_buy", _licensename, strM(_cost)], "addlicense.sqf", [_z, "add"]]
					)];
				_Arr2 set [_z, 1];
			};

		if (((player distance _flag1 > 5) AND (player distance _flag2 > 5) AND (player distance _flag3 > 5) AND (player distance _flag4 > 5)) AND (_added == 1) || (_license call INV_HasLicense)) then {
		//		[] call compile format ["player removeaction a_license%1; ", _z];
				player removeAction (missionNamespace getVariable [format["a_license%1", _z], -1]);
				_Arr2 set [_z,0];
			};
	};
	//======================================CLOTHING=========================================
	for [{_z = 0}, {_z < (count Clothing_Shops)}, {_z = _z + 1}] do {
		_CShopa		= (Clothing_Shops select _z);
		_CLocation 	= _CShopa	select 0;

		if (player distance _CLocation <= 2) then {
			if (_b1 == 0) then {
				CLOTHECHANGEA	=	_CLocation addaction ["Access Clothes", "Awesome\Clothes\Clothes Dialogs.sqf", [_z], 1, false, true, "", ""];
				_b1 = 1;
				_c1 = _z;
			};	
		};
		
		if ((player distance _CLocation > 2) and (_b1 == 1) and (_c1 == _z)	) then {
			_CLocation removeaction CLOTHECHANGEA;
			_b1 = 0;
		};
	};

	//======================================PAINT=========================================
	for [{_z = 0}, {_z < (count Paint_Shops)}, {_z = _z + 1}] do
	{

		_PShopa			= (Paint_Shops select _z);
		_PSpawn		 	= _PShopa	select 0;
		_PLocation_1 	= _PShopa	select 1;
		//_PLocation_2 	= _PShopa	select 2;

		_veh = vehicle player;

		if ( ( ((_veh) distance _PLocation_1) <= 10) && ( (_veh) != player) ) then {
				if (_b2 == 0) then {
					(_veh)  removeaction PAINTSHOPA1;
					PAINTSHOPA1	=	(_veh) addaction ["Access Car Painting", "Awesome\Paint\Paint Dialogs.sqf", [_PSpawn], 1, false, true, "", ""];
					_b2 = 1;
					_c2 = _z;
				};
			};
		
		if (	( (((_veh) distance _PLocation_1 ) > 10) || ((vehicle player) == player)) 	and		 (_b2 == 1) and (_c2 == _z)	) then {
				(_veh)  removeaction PAINTSHOPA1;
				_b2 = 0;
		};
	};

	sleep 1;
	_counter = _counter + 1;
	if (_counter >= 5000) exitwith {[] execVM "shopfarmfaclicenseactions.sqf"};
};
