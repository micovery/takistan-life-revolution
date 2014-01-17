private["_art"];
_art = _this select 0;

if (_art == "use") then {	
	[(_this select 1)] call item_lockpick_use;
};
