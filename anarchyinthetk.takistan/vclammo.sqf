 _art = _this select 0;

if (_art == "use") then

{

_item   = _this select 1;
_anzahl = _this select 2;
_vcl    = vehicle player;

if (player == _vcl) exitWith {player groupChat localize "STRS_inv_item_vclammo_novehicle";};
_vehiclepimpweapons = ["DSHKM","M2","PKT","M134","TwinM134","2A14","M240_veh","AGS30","PKT_high_AI_dispersion"];
_vehiclepimpammos   = ["150Rnd_127x107_DSHKM","100Rnd_127x99_M2","100Rnd_762x54_PK","2000Rnd_762x51_M134","4000Rnd_762x51_M134","40Rnd_23mm_AZP85","100Rnd_762x51_M240","29Rnd_30mm_AGS30","1500Rnd_762x54_PKT"];
_hasRearmableWeapon = 0;
_rearmWeaponarray   = [];

for [{_i=0}, {_i < (count _vehiclepimpweapons)}, {_i=_i+1}] do

	{

	if ((_vehiclepimpweapons select _i) in (weapons _vcl)) then

		{

		_rearmWeaponarray = _rearmWeaponarray + [ [(_vehiclepimpweapons select _i), _i] ];
		_hasRearmableWeapon = 1;

		};

	};

if (_hasRearmableWeapon == 0) exitWith {player groupChat localize "STRS_inv_item_vclammo_nomg";};

	{

	_waffe = _x select 0;
	_muni = _vehiclepimpammos select (_x select 1);
	_vcl RemoveMagazines _waffe;
	 _vcl AddMagazine _muni;
	sleep 0.1;

	} forEach _rearmWeaponarray;

player groupChat localize "STRS_inv_item_vclammo_rearmed";
[player, _item, -1] call INV_AddInventoryItem;

};