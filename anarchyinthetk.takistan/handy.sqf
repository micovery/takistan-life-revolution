private["_action"];
_action = _this select 0;

if (_action == "use") then {
	call interact_mobile_use;
};