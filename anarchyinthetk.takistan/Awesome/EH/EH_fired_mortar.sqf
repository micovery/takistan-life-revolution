// fired event handler script
// EH_fired.sqf

private["_unit", "_weapon", "_muzzle", "_mode", "_ammo", "_magazine", "_projectile"];

_unit = _this select 0;
_weapon	= _this select 1;
_muzzle = _this select 2;
_mode = _this select 3;
_ammo = _this select 4;
_magazine = _this select 5;
_projectile = _this select 6;


///////////////
// Firing Details
///////////////

if (vehicle player != _unit) exitwith {};

private["_M_effect"];

M_Round	= "";
_M_effect = "";

player groupchat "running";
_h = [] execVM "Awesome\Effects\mortar_effects.sqf";

if (_unit isKindOf "M252") then {
	switch _magazine do {
		case "8Rnd_81mmILLUM_M252": {
			M_Round = "81mm Illumination";
			_M_effect = "IL";
		};
		case "8Rnd_81mmWP_M252": {
			M_Round = "81mm Willie Pete";
			_M_effect = "WP";
		};
		case "8Rnd_81mmHE_M252": {
			M_Round = "81mm High Explosive";
			_M_effect = "HE";
		};
	};
};

if (_unit isKindOf "2b14_82mm") then {
	switch _magazine do {
		case "8Rnd_82mmILLUM_2B14": {
			M_Round = "82mm Illumination";
			_M_effect = "IL";
		};
		case "8Rnd_82mmWP_2B14": {
			M_Round = "82mm Willie Pete";
			_M_effect = "WP";
		};
		case "8Rnd_82mmHE_2B14": {
			M_Round = "82mm High explosive";
			_M_effect = "HE";
		};
	};
};

if (player in (crew _unit)) then {
	player groupchat format["SHOT TYPE: %1		ELEVATION: %2		AZIMUT: %3", M_Round  , M_Elevation, M_Azimut];
};


_unit setWeaponReloadingTime [_unit,currentWeapon _unit, 10];

///////////////
// Round Effects
///////////////

switch _M_effect do {
	case "HE": {
		deleteVehicle _projectile;
	};
	case "WP": {
		_pos_projectile = getPosATL _projectile;
		_tempo = 0.0075;

		while {alive _projectile} do {
			_pos_projectile = getPosATL _projectile;
			sleep _tempo;
		};

		[_pos_projectile] spawn M_effect_WP;
	};
	case "IL": {	
		switch M_ill_style do {
			case "highest": {
				_pro_height = 0;
				while { (getPosATL _projectile select 2) >  _pro_height} do {
					_pro_height = (getPosATL _projectile select 2);
					sleep 0.01;
				};
				[_projectile, M_ill_lit] spawn M_effect_IL;
			};
			case "timed": {
				sleep M_ill_delay;
				[_projectile, M_ill_lit] spawn M_effect_IL;
			};
			case "height": {
				waitUntil { (getPosATL _projectile select 2) > M_ill_height };
				[_projectile, M_ill_lit] spawn M_effect_IL;
			};
		};
	};
};