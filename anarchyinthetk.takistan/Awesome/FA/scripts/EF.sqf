_choice = missionnamespace getVariable ["EF_CHOICE", true];

if (_choice) then {
		EF_UNIT = "player"
	} else {
		EF_UNIT = "cursorTarget";
	};

missionNamespace setVariable["EF_CHOICE", !_choice];



