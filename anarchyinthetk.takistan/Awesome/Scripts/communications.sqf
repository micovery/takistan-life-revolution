DEBUG_SUBMENU = [
	["Debug menu", false],
	["",[],"",-1,[],"0","0"],
	["(debug)	Current position", [2], "", -5, [["expression", "theplayerpos21 = getpos player; hint format [""%1"" , theplayerpos21]"]], "1", "1"],
	["(debug)	Closest Building", [3], "", -5, [["expression", "hint format [""%1"", typeOf nearestObject [player,""building""]]"]], "1", "1"],
	["(debug)	Groups", [4], "", -5, [["expression", "groupnumber = count allgroups; hint format[""%1 many groups"" , groupnumber]"]], "1", "1"],
	["",[],"",-1,[],"0","0"]
];



BIS_MENU_GroupCommunication = [
	//--- Name, context sensitive
	["Communications Menu",false],
	//--- Item name, shortcut, -5 (do not change), expression, show, enable
	["Settings", [], "", -5, [["expression", "[""Einstellungen""] call A_SCRIPT_SETTINGS;"]], "1", "1"],
	["",[],"",-1,[],"0","0"],
	["Say text #1", [2], "", -5, [["expression", "[RadioTextMsg_1, RadioTextArt_1] call SayDirectSpeach;"]], "1", "1"],
	["Say text #2", [3], "", -5, [["expression", "[RadioTextMsg_2, RadioTextArt_2] call SayDirectSpeach;"]], "1", "1"],
	["Say text #3", [4], "", -5, [["expression", "[RadioTextMsg_3, RadioTextArt_3] call SayDirectSpeach;"]], "1", "1"],
	["Say text #4", [5], "", -5, [["expression", "[RadioTextMsg_4, RadioTextArt_4] call SayDirectSpeach;"]], "1", "1"],
	["",[],"",-1,[],"0","0"],
	["Headbug", [0], "", -5, [["expression", "fixme = [] execVM ""headbug.sqf"""]], "1", "1"],
	["",[],"",-1,[],"0","0"]
]; 

showCommandingMenu "#USER:BIS_MENU_GroupCommunication";

