private ["_healer"];
_healer = _this select 1;

if (!(_healer getVariable "FA_healer")) exitWith {
		diag_log format ["FA_HEALER_ healerStop.sqf EXIT - NOT healer"];
	};
if (!(_healer getVariable "FA_healEnabled")) exitWith {
		diag_log format ["FA_HEALER_ healerStop.sqf EXIT - NOT FA_healEnabled"];
	};

_healer setVariable ["FA_healEnabled", false,true];

detach _healer;