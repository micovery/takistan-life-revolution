// List used
// 0 - None
// 1 - White list
// 2 - Black list
A_WBL_V_ACTIVE_PMC_1 = 1;
A_WBL_V_ACTIVE_COP_1 = 2;

// White list variable
A_WBL_V_W_PMC_1		= [];
A_WBL_V_W_COP_1		= [];

// Black list variable
A_WBL_V_B_PMC_1		= [];
A_WBL_V_B_COP_1		= [];

A_WBL_FOLDER		= "LISTS\";

// White list file
A_WBL_WL_PMC_1		= format["%1WBL_white_list_pmc_1.log", A_WBL_FOLDER];
A_WBL_WL_COP_1		= format["%1WBL_white_list_cop_1.log", A_WBL_FOLDER];

// Black list file
A_WBL_BL_PMC_1		= format["%1WBL_black_list_pmc_1.log", A_WBL_FOLDER];
A_WBL_BL_COP_1		= format["%1WBL_black_list_cop_1.log", A_WBL_FOLDER];

// Public variable server sends out to update clients list
A_WBL_PV_S_W_PMC_1 = [];
A_WBL_PV_S_B_PMC_1 = [];

A_WBL_PV_S_W_COP_1 = [];
A_WBL_PV_S_B_COP_1 = [];


// Public variable a client sends out to update servers list
A_WBL_PV_C_W_PMC_1 = [];
A_WBL_PV_C_B_PMC_1 = [];

A_WBL_PV_C_W_COP_1 = [];
A_WBL_PV_C_B_COP_1 = [];


// List of variables
// PMC-1: White List
// PMC-1: Black List

// List Name
// Local List
// File Name
// Server-Client PV
// Client-Server PV

A_WBL_LISTS = 
[
	["A_WBL_WL_PMC1", "A_WBL_V_W_PMC_1", A_WBL_WL_PMC_1, "A_WBL_PV_S_W_PMC_1", "A_WBL_PV_C_W_PMC_1"],
	["A_WBL_BL_PMC1", "A_WBL_V_B_PMC_1", A_WBL_BL_PMC_1, "A_WBL_PV_S_B_PMC_1", "A_WBL_PV_C_B_PMC_1"],
	
	["A_WBL_WL_COP1", "A_WBL_V_W_COP_1", A_WBL_WL_COP_1, "A_WBL_PV_S_W_COP_1", "A_WBL_PV_C_B_PMC_1"],
	["A_WBL_BL_COP1", "A_WBL_V_B_COP_1", A_WBL_BL_COP_1, "A_WBL_PV_S_B_COP_1", "A_WBL_PV_C_B_COP_1"]
];

// List of list names for variables

// List name
// White List - list name
// Black List - list name
A_WBL_LISTS_ALL =
[
	["PMC_1", "A_WBL_WL_PMC1", "A_WBL_BL_PMC1", A_WBL_V_ACTIVE_PMC_1],
	["COP_1", "A_WBL_WL_COP1", "A_WBL_BL_COP1", A_WBL_V_ACTIVE_COP_1]
];

A_WBL_SAVING = false;

A_LIST_ADMINS	=
[
	"1039168", 
	"815680",  
	"966656",  
	"146561",  
	"12544",  
	"4160710",  
	"3855360",  
	"8337542",  
	"9828358",  
	"9739718",  
	"4022918",  
	"6125382",  
	"31922886", 
	"35492678", 
	"36142086", 
	"1999302", 
	"11124934", 
	"2069056", 
	"26082630", 
	"24943814", 
	"15457926", 
	"11060102",
	"7547206",
	"9784838",
	"76476806",
	"92317702",
	"4022278",
	"37713478",
	"610753AX",
	"36621830",
	"106972294",
	"21532166",
	"135130118",
	"121911814",
	"73708486",
	"28237446",
	"59597766",
	"6903040"
];

A_LIST_DONATORS = [];

isAdmin = (getPlayerUID player) in A_LIST_ADMINS;

// Used for white-black list dialog
A_WBL_F_DIALOG_INIT = {
	private
	[
		"_DFML", 
		"_DFML_LIST1", "_DFML_LIST2", "_DFML_LIST3",
		"_DFML_BUTTON_B_1", "_DFML_BUTTON_B_2", "_DFML_BUTTON_B_3",
		"_DFML_BUTTON_W_1", "_DFML_BUTTON_W_2", "_DFML_BUTTON_W_3",
		"_DFML_TITLE_1", "_DFML_TITLE_2", "_DFML_TITLE_3", "_DFML_TITLE_1_DESC", "_DFML_TITLE_2_DESC", "_DFML_TITLE_3_DESC", 
		"_list_name", "_array", "_whiteList", "_blackList", "_list_choice_num",
		"_uid", "_whiteList_active", "_blackList_active",
		"_type_num", "_type_name", "_index",
		"_playerList_update", "_whiteList_update", "_blackList_update",
		"_playerList_array_DFML", "_whiteList_array_DFML", "_blackList_array_DFML",
		"_playerList_array_DFML_T", "_whiteList_array_DFML_T", "_blackList_array_DFML_T",
		"_whiteList_variable", "_blackList_variable",
		"_i"
	];

	if (!(createDialog "white_black_list")) exitWith {hint "Dialog Error!";};
	
	disableSerialization;
	
	_DFML = findDisplay 3005;
	
	_DFML_LIST1 		= (_DFML displayCtrl 1500);
	_DFML_LIST2 		= (_DFML displayCtrl 1501);
	_DFML_LIST3 		= (_DFML displayCtrl 1502);
	
	_DFML_BUTTON_B_1	= (_DFML displayCtrl 1700);
	_DFML_BUTTON_B_2	= (_DFML displayCtrl 1701);
	_DFML_BUTTON_B_3	= (_DFML displayCtrl 1705);
	_DFML_BUTTON_B_4	= (_DFML displayCtrl 1707);
	
	_DFML_BUTTON_W_1	= (_DFML displayCtrl 1702);
	_DFML_BUTTON_W_2	= (_DFML displayCtrl 1703);
	_DFML_BUTTON_W_3	= (_DFML displayCtrl 1706);
	_DFML_BUTTON_W_4	= (_DFML displayCtrl 1708);
	
	_DFML_TITLE_1		= (_DFML displayCtrl 1000);
	_DFML_TITLE_2		= (_DFML displayCtrl 1001);
	_DFML_TITLE_3		= (_DFML displayCtrl 1002);
	
	_DFML_TITLE_1_DESC	= (_DFML displayCtrl 1003);
	_DFML_TITLE_2_DESC	= (_DFML displayCtrl 1004);
	_DFML_TITLE_3_DESC	= (_DFML displayCtrl 1005);
	
	_list_name		= _this select 0;
	_array			= [];
	
	_playerList_array_DFML 	= [];
	_whiteList_array_DFML	= [];
	_blackList_array_DFML 	= [];
	
	_playerList_array_DFML_T 	= [];
	_whiteList_array_DFML_T		= [];
	_blackList_array_DFML_T 	= [];
	
	{
		if ((_x select 0) == _list_name) then {
				_array = _x;
				_whiteList		= _array select 1;
				_blackList		= _array select 2;
				_list_choice_num	= _array select 3;
			};
	} forEach A_WBL_LISTS_ALL;
	
	{
		if ((_x select 0) == _whiteList) then {
			_whiteList_variable 	= _x select 1;
		};
			
		if ((_x select 0) == _blackList) then {
			_blackList_variable 	= _x select 1;
		};
	} forEach A_WBL_LISTS;

	_DFML_BUTTON_B_1 ctrlSetText format["Add to Black List"];
	_DFML_BUTTON_B_2 ctrlSetText format["Remove from Black List"];
	_DFML_BUTTON_B_3 ctrlSetText format["Remove selected Player from BL"];
	_DFML_BUTTON_B_4 ctrlSetText format["Clear Black List"];
	
	_DFML_BUTTON_W_1 ctrlSetText format["Add to White List"];
	_DFML_BUTTON_W_2 ctrlSetText format["Remove from White List"];
	_DFML_BUTTON_W_3 ctrlSetText format["Remove selected Player from WL"];
	_DFML_BUTTON_W_4 ctrlSetText format["Clear White List"];
	
	_whiteList_active = "";
	_blackList_active = "";
	
	if (_list_choice_num == 1) then {
		_whiteList_active = "Active";
	} else {
		_whiteList_active = "In-Active";
		
		_DFML_BUTTON_W_1 ctrlEnable false;
		_DFML_BUTTON_W_2 ctrlEnable false;
		_DFML_BUTTON_W_3 ctrlEnable false;
		_DFML_BUTTON_W_4 ctrlEnable false;
	};
	
	if (_list_choice_num == 2) then {
		_blackList_active = "Active";
	} else {
		_blackList_active = "In-Active";
		
		_DFML_BUTTON_B_1 ctrlEnable false;
		_DFML_BUTTON_B_2 ctrlEnable false;
		_DFML_BUTTON_B_3 ctrlEnable false;
		_DFML_BUTTON_B_4 ctrlEnable false;
	};
	
	_DFML_TITLE_1 ctrlSetText format["White List - %1", _whiteList_active];
	_DFML_TITLE_2 ctrlSetText format["Black List - %1", _blackList_active];
	_DFML_TITLE_3 ctrlSetText format["Player List"];
	
	if (isAdmin) then {
		_DFML_TITLE_1_DESC ctrlSetText format["UID		-		TYPE"];
		_DFML_TITLE_2_DESC ctrlSetText format["UID		-		TYPE"];
		_DFML_TITLE_3_DESC ctrlSetText format["UID	-	NAME	-	SLOT	- In White List?	-	In Black List?		-		In Admin List?		-		In Donator List?"];
	} else {
		_DFML_TITLE_1_DESC ctrlSetText format["UID"];
		_DFML_TITLE_2_DESC ctrlSetText format["UID"];
		_DFML_TITLE_3_DESC ctrlSetText format["UID	-	NAME	-	SLOT	- In White List?	-	In Black List?"];
	};

	_playerList_update	= false;
	_whiteList_update = false;
	_blackList_update = false;

	while {dialog} do {
		_DFML_BUTTON_B_1 buttonSetAction format["[""%1"", ""%2""] call %3;", _blackList, (_DFML_LIST3 lbData (lbCurSel _DFML_LIST3)), A_WBL_F_L_ADD];
		_DFML_BUTTON_B_2 buttonSetAction format["[""%1"", ""%2""] call %3;", _blackList, (_DFML_LIST2 lbData (lbCurSel _DFML_LIST2)), A_WBL_F_L_REMOVE];
		_DFML_BUTTON_B_3 buttonSetAction format["[""%1"", ""%2""] call %3;", _blackList, (_DFML_LIST3 lbData (lbCurSel _DFML_LIST3)), A_WBL_F_L_REMOVE];
		_DFML_BUTTON_B_4 buttonSetAction format["[""%1""] call %2;", _blackList, A_WBL_F_L_REMOVE_ALL];
		
		_DFML_BUTTON_W_1 buttonSetAction format["[""%1"", ""%2""] call %3;", _whiteList, (_DFML_LIST3 lbData (lbCurSel _DFML_LIST3)), A_WBL_F_L_ADD];
		_DFML_BUTTON_W_2 buttonSetAction format["[""%1"", ""%2""] call %3;", _whiteList, (_DFML_LIST1 lbData (lbCurSel _DFML_LIST1)), A_WBL_F_L_REMOVE];
		_DFML_BUTTON_W_3 buttonSetAction format["[""%1"", ""%2""] call %3;", _whiteList, (_DFML_LIST3 lbData (lbCurSel _DFML_LIST3)), A_WBL_F_L_REMOVE];
		_DFML_BUTTON_W_4 buttonSetAction format["[""%1""] call %2;", _whiteList, A_WBL_F_L_REMOVE_ALL];
		
		_playerList_array_DFML_T = [];
		{
			if (isPlayer _x) then {
				_uid	= (getPlayerUID _x);
				_playerList_array_DFML_T set[(count _playerList_array_DFML_T), _uid];
			};
		} forEach allUnits;
		
		if ((count _playerList_array_DFML) != (count _playerList_array_DFML_T)	) then {
			_playerList_update = true;
		} else {
			_i = 0;
			{
				if (	(_x) != (_playerList_array_DFML_T select _i)	) then {
					_playerList_update = true;
				};
				_i = _i + 1;
			} forEach _playerList_array_DFML;
		};
		
		if (_playerList_update) then {
			player groupchat format['PLAYERLIST UPDATING'];
			_playerList_array_DFML = [];
			
			lbClear _DFML_LIST3;
			
			{
				if ([_x] call player_human) then {
					private["_uid"];
					_uid = (getPlayerUID _x);
					
					if (isAdmin) then {
						_index = _DFML_LIST3 lbAdd 
						(

							format[
								"%1 - %2 - %3 - %4 - %5 - %6 - %7", 
								_uid, 
								(name _x), 
								(_x),
								(call compile format["""%1"" in %2;", _uid, _whiteList_variable]), 
								(call compile format["""%1"" in %2;", _uid, _blackList_variable]),
								(_uid in A_LIST_ADMINS), (_uid in A_LIST_DONATORS)
							  ]
						);
					} 
					else {
						_index	= _DFML_LIST3 lbAdd 
						(
							format[
								"%1	-	%2	-	%3	-	%4	-	%5", 
								_uid, 
								(name _x), 
								(_x), 
								(call compile format["""%1"" in %2;", _uid, _whiteList_variable]), 
								(call compile format["""%1"" in %2;", _uid, _blackList_variable])
							]
						);
					};
					
					_DFML_LIST3 lbSetData [_index, (_uid)];
					_playerList_array_DFML set [(count _playerList_array_DFML), _uid];
				};
			} forEach allUnits;
			
			_playerList_update = false;
			
			player groupchat format['PLAYERLIST UPDATED'];
		};

		_whiteList_array_DFML_T	= call compile _whiteList_variable;
		
		if ((count _whiteList_array_DFML) != (count _whiteList_array_DFML_T)	) then {
			_whiteList_update = true;
		} else {
			_i = 0;
			{
				if ((_x) != (_whiteList_array_DFML_T select _i)	) then {
					_whiteList_update = true;
				};
				_i = _i + 1;
			} forEach _whiteList_array_DFML;
		};
		
		if (_whiteList_update) then {
			player groupchat format['WHITELIST UPDATING'];
			_whiteList_array_DFML = call compile _whiteList_variable;
			_DFML_LIST1 lbSetCurSel 0;

			lbClear _DFML_LIST1;
			{
				_type_num	= [_x] call A_WBL_GETTYPE_NUM;
				_type_name	= [_type_num] call A_WBL_GETTYPE_NAME;
				
				if (isAdmin) then {
						_index	= _DFML_LIST1 lbAdd (format["%1		-		%2", (_x), (_type_name)]);
					} else {
						_index	= _DFML_LIST1 lbAdd (format["%1", (_x), (_type_name)]);
					};
					
				_DFML_LIST1 lbSetData [_index, (_x)];
			} forEach (_whiteList_array_DFML);
				
			_whiteList_update = false;
			
			_DFML_LIST1 lbSetCurSel 0;
			
			player groupchat format['WHITELIST UPDATED'];
		};
		
		_blackList_array_DFML_T	= call compile _blackList_variable;
		
		if ((count _blackList_array_DFML) != (count _blackList_array_DFML_T)	) then {
			_blackList_update = true;
		} else {
			_i = 0;
			{
				if (	(_x) != (_blackList_array_DFML_T select _i)	) then {
						_blackList_update = true;
					};
				_i = _i + 1;
			} forEach _blackList_array_DFML;
		};
		
		if (_blackList_update) then {
			player groupchat format['BLACKLIST UPDATING'];
			_blackList_array_DFML = call compile _blackList_variable;
			_DFML_LIST2 lbSetCurSel 0;
				
			lbClear _DFML_LIST2;
			{
				_type_num	= [_x] call A_WBL_GETTYPE_NUM;
				_type_name	= [_type_num] call A_WBL_GETTYPE_NAME;
				
				if (isAdmin) then {
						_index	= _DFML_LIST2 lbAdd (format["%1		-		%2", (_x), (_type_name)]);
					} else {
						_index	= _DFML_LIST2 lbAdd (format["%1", (_x), (_type_name)]);
					};
				
				_DFML_LIST2 lbSetData [_index, (_x)];
			} forEach (_blackList_array_DFML);
				
			_blackList_update = false;
			
			_DFML_LIST2 lbSetCurSel 0;
			
			player groupchat format['BLACKLIST UPDATED'];
		};
		sleep 5;
	};
};

// Init - server
A_WBL_F_INIT_S =  {
	private["_pv_c"];

	{
		_pv_c		= _x select 4;
		_x call A_WBL_F_LOAD_S;
		_pv_c addPublicVariableEventHandler {_this call A_WBL_F_R;};
	} forEach A_WBL_LISTS;
};

// Init - client
A_WBL_F_INIT_C =  {
	private["_pv_s"];

	{
		_pv_s	= _x select 3;
		_pv_s addPublicVariableEventHandler {_this call A_WBL_F_REFRESH_R;};
	} forEach A_WBL_LISTS;
};

// Loads list - Server
A_WBL_F_LOAD_S = {
	private["_variable", "_file", "_pv_s", "_pv_c", "_list_name", "_i", "_true", "_text", "_array", "_out"];

	_list_name 	= _this select 0;

	{
		if ((_x select 0) == _list_name) then {
			_variable 	= _x select 1;
			_file		= _x select 2;
			_pv_s		= _x select 3;
			_pv_c		= _x select 4;
				
			_i = 0;
			_true = true;
			_text = "";
			_array = [];
		
			_out = "stdio" callExtension format["read(%1,%2)", _file, _i];

			while {_true} do {
				_text = _text + _out;
				_i = _i + 1;
				_out = "stdio" callExtension format["read(%1,%2)", _file, _i];
				if (_out == "") then {_true = false};
			};
				
			_array = [] call compile _text;
			
			missionNamespace setVariable [_variable, []];
			missionNamespace setVariable [_pv_s, []];
			missionNamespace setVariable [_pv_c, []];
						
			_i = 0;
			for [{_i=0}, {_i < (count _array)}, {_i=_i+1}] do {
				[] call compile format["%1 set[%2, ""%3""];", _variable, _i, _array select _i];
				[] call compile format["%1 set[%2, ""%3""];", _pv_s, _i, _array select _i];
			};
			publicVariable _pv_s;
		};
	} forEach A_WBL_LISTS;
};


// Saves list (server)
A_WBL_F_SAVE =  {
	private["_section_change", "_section_value", "_section", "_file", "_array", "_value", "_change", "_i"];
	
	_section_change		= _this select 0;
	_section_value		= _this select 1;
	
	_section = "";
	_file = "";

	{
		_section	= _x select 0;
		_file		= _x select 2;

		if (_section == _section_change) then {
			_array = [];
			_array = _section_value;
			_change = [];

			for [{_i = 0}, {_i < (count _array)}, {_i = _i + 1}] do {
				if ((_array select _i) == "1337") then {
					_change set[(count _change), _i];
				};
			};

			{
				_array = _array - ["1337"];
			} forEach _change;

			"stdio" callExtension format["write(%1)%2", _file, "[""1337""]"];

			{
				_value = _x;
				"stdio" callExtension (format["append(%1) +%2", _file, toString [10]] + format["%1",[_value]]);
			} forEach _array;
		};
	} forEach A_WBL_LISTS;
};

// Refreshes all lists, sends (server)
A_WBL_F_REFRESH_S =  {
	{
		_x call A_WBL_F_LOAD_S; 
	} forEach A_WBL_LISTS;
};

// Refreshes list, receives (Client - Server)
A_WBL_F_REFRESH_R =  {
	private[ "_pvariable_name", "_pvariable_value", "_variable", "_pv_s", "_i"];
	
	_pvariable_name 	= _this select 0;
	_pvariable_value 	= _this select 1;
	
	{
		_variable 	= _x select 1;
		_pv_s		= _x select 3;

		if (_pvariable_name == _pv_s) then {
			missionNamespace setVariable [_variable, []];
			_i = 0;
			for [{_i=0}, {_i < (count _pvariable_value)}, {_i=_i+1}] do {
				[] call compile format["%1 set[%2, ""%3""];", _variable, _i, _pvariable_value select _i];
			};
		};
	} forEach A_WBL_LISTS;
};


// Recieves new list (Server)
A_WBL_F_R =  {
	private["_name", "_value", "_section"];

	_name = _this select 0;
	_value = (_this select 1);
	
	{
		if ((_x select 4) == _name) then {
		
				_section	= _x select 0;

				[_section, _value] call A_WBL_F_SAVE;
			};		
	} forEach A_WBL_LISTS;
};

// Add onto list
A_WBL_F_L_ADD = {
	private["_list_name", "_uid", "_List_variable", "_List_pv_c"];
	
	_list_name 	= _this select 0;
	_uid		= _this select 1;
	
	if (_uid == "") exitwith {player groupchat "ERROR: Please reselect the list item then retry the add button";};
	
	_List_variable 	= "";
	_List_pv_c		= "";
	
	{
		if ((_x select 0) == _list_name) then {
			_List_variable 		= _x select 1;
			_List_pv_c			= _x select 4;
		};
	} forEach A_WBL_LISTS;
	
	if(	!(_uid in (call compile _List_variable))	) then {
		player groupchat "Adding to list...";
		
		[] call compile format["%1 set[count %1, ""%2""];", _List_variable, _uid];
		[] call compile format["%1 = %2;", _List_pv_c, _List_variable];

//		Do not use, variables passed as strings		
//		missionNamespace setVariable [_List_pv_c, _List_variable];
		
		publicVariableServer _List_pv_c;
		
		player groupchat "Sent to server, please wait for lists to update";
		
	} else {
		player groupchat "ERROR: Already in list";
	};
};

// Remove from list
A_WBL_F_L_REMOVE = {
	private["_list_name", "_uid", "_List_variable", "_List_pv_c"];
	
	_list_name 	= _this select 0;
	_uid		= _this select 1;
	
	if (_uid == "") exitwith {
		player groupchat "ERROR: Please reselect the list item then retry the removal button";
	};

	_List_variable 	= "";
	_List_pv_c		= "";
	
	{
		if ((_x select 0) == _list_name) then {
			_List_variable 		= _x select 1;
			_List_pv_c			= _x select 4;
		};
	} forEach A_WBL_LISTS;
	
	if ((_uid in (call compile _List_variable))	) then {
		player groupchat "Removing from list...";
		
		[] call compile format["%1 = %1 - [""%2""];", _List_variable, _uid];
		[] call compile format["%1 = %2", _List_pv_c, _List_variable];

//		Do note use, variables passed as string		
//		missionNamespace setVariable [_List_pv_c, _List_variable];
		
		
		publicVariableServer _List_pv_c;
		
		player groupchat "Sent to server, please wait for lists to update";
	} else {
		player groupchat "ERROR: selected not in list";
	};
};

// Remove ALL from list
A_WBL_F_L_REMOVE_ALL = {
	private["_list_name", "_List_variable", "_List_pv_c"];
	
	_list_name 	= _this select 0;
	
	_List_variable 	= "";
	_List_pv_c		= "";
	
	{
		if ((_x select 0) == _list_name) then {
			_List_variable 		= _x select 1;
			_List_pv_c			= _x select 4;
		};
	} forEach A_WBL_LISTS;
	
	player groupchat "Clearing list...";
	
//	Do not use, variables are passed as strings
//	missionNamespace setVariable [_List_variable, []];
//	missionNamespace setVariable [_List_pv_c, _List_variable];
	
	[] call compile format["%1 = [];", _List_variable];
	[] call compile format["%1 = %2", _List_pv_c, _List_variable];

	publicVariableServer _List_pv_c;	
	player groupchat "Sent to server, please wait for lists to update";
};

// Gets the type number from the UID
A_WBL_GETTYPE_NUM = {
	private["_uid", "_return"];

	_uid	= _this select 0;
	_return = -1;

	if (_uid in A_LIST_ADMINS) then {
			_return = 0;
	} else { if (_uid in A_LIST_DONATORS) then {
			_return = 1;
	} else {
		_return = 2;
	};};
		
	_return
};

// Gets the type name from the UID
A_WBL_GETTYPE_NAME = {
	private["_num", "_return"];

	_num	= _this select 0;
	_return = "";

	switch _num do {
		case -1: {
			_return = "ERROR";
		};
		case 0: {
			_return = "ADMIN";
		};
		case 1: {
			_return = "DONATOR";
		};
		case 2: {
			_return = "PLAYER";
		};
	};
		
	_return
};
