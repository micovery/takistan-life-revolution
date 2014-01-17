//stun_armor

private["_action","_item","_amount","_veh","_Addrounds"];
_action = _this select 0;
_item   = _this select 1;
_amount = _this select 2;

_veh = vehicle player;

if !(_veh iskindOf "StaticMortar") exitwith {
	player groupchat "You must be in a M252 or Podnos static";
};

_Addrounds = {
	private ["_veh", "_mag"];
	_veh = _this select 0;
	_mag = _this select 1;

	if (_veh isKindOf "M252") then {
		switch _mag do {
			case "HE":
			{
				_veh addMagazine "8Rnd_81mmHE_M252";
			};
			case "WP":
			{
				_veh addMagazine "8Rnd_81mmWP_M252";
			};
			case "IL":
			{
				_veh addMagazine "8Rnd_81mmILLUM_M252";
			};
		};
	};

	if (_veh isKindOf "2b14_82mm") then {
		switch _mag do {
			case "HE":
			{
				_veh addMagazine "8Rnd_82mmHE_2B14";
			};
			case "WP":
			{
				_veh addMagazine "8Rnd_82mmWP_2B14";
			};
			case "IL":
			{
				_veh addMagazine "8Rnd_82mmILLUM_2B14";
			};
		};	
	};	
};	

switch _item do {
	case "Mammo_HE": {
		[_veh, "HE"] call _Addrounds;
		player groupchat "8 High Explosive rounds added";
		[player, _item, -1] call INV_AddInventoryItem;
	};

	case "Mammo_WP": {
		[_veh, "WP"] call _Addrounds;
		player groupchat "8 Willie Pete rounds added";
		[player, _item, -1] call INV_AddInventoryItem;
	};

	case "Mammo_IL": {
		[_veh, "IL"] call _Addrounds;
		player groupchat "8 Illumination rounds added";
		[player, _item, -1] call INV_AddInventoryItem;
	};
};


