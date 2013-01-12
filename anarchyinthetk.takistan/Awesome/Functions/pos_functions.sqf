is_prone = {
	private ["_unit", "_return", "_check"];

	_unit = _this select 0;
	_return = false;
	_check = (_unit selectionPosition "neck" select 2);

	if (_check <= 0.5) then { _return = true; } else { _return = false; };
	_return;
};


is_facing = {
	private ["_unit1", "_unit2", "_return"];

	_unit1 = _this select 0;
	_unit2 = _this select 1;

	_return = [getpos _unit1, getdir _unit1, 45, getpos _unit2] call BIS_fnc_inAngleSector;
	_return;
};


is_frontback = {
	private ["_unit1", "_unit2", "_return", "_check"];

	_unit1 = _this select 0;
	_unit2 = _this select 1;
	_return = "";

	_check = [getpos _unit2, getdir _unit2, 180, getpos _unit1] call BIS_fnc_inAngleSector;
	if (_check) then {
			_return = "front";
		} else {
			_return = "back";
		};

	_return;
};

