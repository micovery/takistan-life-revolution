_art = _this select 0;
_zusatzString = "";
if ((count _this)>1) then {_zusatzString = _this select 1;};

if (_art == "Einstellungen") then {
	if (!(createDialog "MainMenu")) exitWith {hint "Dialog Error!";};
};

if (_art == "GrafikEinstellungen") then {
	["closedialog 0; [""Einstellungen""] call A_SCRIPT_SETTINGS;"] execVM "3442919.sqf";
};

if (_art == "TextEinstellungen") then {
	if (_zusatzString == "oeffnen") then {
		if (!(createDialog "TextEinstellungenDialog")) exitWith {hint "Dialog Error!";};
			
		for [{_i=1}, {_i <= 4}, {_i=_i+1}] do {
			call compile format["ctrlSetText[%1, RadioTextMsg_%1];", _i];
			call compile format["_index = lbAdd [1%1, 'Global'];lbSetData [1%1, _index, 'global'];if(RadioTextArt_%1 == 'global')then{lbSetCurSel [1%1, 0]};", _i];
			call compile format["_index = lbAdd [1%1, 'Side'  ];lbSetData [1%1, _index, 'side'  ];if(RadioTextArt_%1 == 'side'  )then{lbSetCurSel [1%1, 1]};", _i];
			call compile format["_index = lbAdd [1%1, 'Direct'];lbSetData [1%1, _index, 'direct'];if(RadioTextArt_%1 == 'direct')then{lbSetCurSel [1%1, 2]};", _i];
		};
	};
		
	if ( (_zusatzString == "speichern") and (ctrlVisible 1034) ) then {
		for [{_i=1}, {_i <= 4}, {_i=_i+1}] do {
			call compile format["RadioTextMsg_%1 = (ctrlText %1);", _i];
			call compile format["RadioTextArt_%1 = lbText[1%1, (lbCurSel 1%1)];", _i];
		};
		player groupChat "Saved!";
	};		
};

if (_art == "Tutorial") then {
	if (!(createDialog "TutorialDialog")) exitWith {hint "Dialog Error!";};
	ctrlSetText[1, localize "STRS_mainmenu_MissionTutorial"];
};

if (_art == "FAQ") then {
	if (!(createDialog "FAQDialog")) exitWith {hint "Dialog Error!";};
	ctrlSetText[1, localize "STRS_mainmenu_FAQ"];
};

if (_art == "About") then {
	if (!(createDialog "AboutDialog")) exitWith {hint "Dialog Error!";};
	ctrlSetText[1, localize "STRS_mainmenu_AboutThisMission"];
};

/*
if (_art == "ItemList") then {
	_handler = ["closedialog 0; [""Einstellungen""] call A_SCRIPT_SETTINGS;", "Back"] execVM "740153.sqf";
	waitUntil {scriptDone _handler};
};
*/