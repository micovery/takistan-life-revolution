private[
		"_target", "_caller", "_id", "_arg", "_pass", "_healer", "_injured", "_healerMedic"
	];

_target = _this select 0;
_caller	= _this select 1;
_id		= _this select 2;
_arg	= _this select 3;

_pass = [];

_healer = player;
_injured = cursorTarget;
_healerMedic = [_healer] call FA_isMedic;

_pass	set[0, _injured];
_pass	set[1, _healer];
_pass	set[2, _healerMedic];

_pass spawn FA_hHeal;