private["_action"];
_action = _this select 0;

if (_action == "use") then {
	private["_item", "_number"];
	_item   = _this select 1;
	_number = _this select 2;
	
	if (_item == "pistol") then {
		[player] call holster_show_weapon;
	};
};