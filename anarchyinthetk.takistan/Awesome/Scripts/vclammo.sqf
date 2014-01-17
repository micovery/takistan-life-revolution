private["_art"];
_art = _this select 0;

if (_art != "use") exitwith {};

private["_item","_anzahl","_vcl"];
_item   	= _this select 1;
_anzahl 	= _this select 2;

_vcl    	= vehicle player;

if (player == _vcl) exitWith {player groupChat localize "STRS_inv_item_vclammo_novehicle";};

private["_role", "_path"];
_role		= assignedVehicleRole player;
_path		= _role select 1;

if (isNil "_path") exitwith {player groupchat "You cannot reArm in this seat!"};

private["_weapons"];
_weapons	= (vehicle player) weaponsTurret _path;
if ((count _weapons) <= 0) exitwith {player groupchat "This seat has no weapons!"};

private["_mag"];
{
	_mag = ((getArray (configFile >> "cfgWeapons" >> _x >> "Magazines")) select 0); 
	_vcl addMagazineTurret[_mag, _path];
} forEach _weapons;


player groupChat localize "STRS_inv_item_vclammo_rearmed";
[player, _item, -1] call INV_AddInventoryItem;