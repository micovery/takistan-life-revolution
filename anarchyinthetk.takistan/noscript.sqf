_target = _this select 0;
_caller = _this select 1;
_id = _this select 2;
_com = _this select 3;

if ((typeName _com) == "ARRAY") then {
	{[_target, _caller, _id] call compile format [ "%1", _x];} forEach _com;
} else {
	[_target, _caller, _id] call compile format [ "%1", _com];
};

