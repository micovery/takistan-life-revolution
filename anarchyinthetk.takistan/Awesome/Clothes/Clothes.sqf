if (not(isNil "clothes_functions_defined")) exitWith {};

// Sets up everything, main startup
C_libraries = {
	private ["_h"];
	[] call C_variables;
	_h = [] execVM "Awesome\Clothes\C_shop.sqf";
	waituntil {scriptDone _h};
	_h = [] execVM "Awesome\Clothes\Clothes Actions.sqf";
	waituntil {scriptDone _h};
	_h = [] execVM "Awesome\Clothes\Clothes Dialog Functions.sqf";
	waituntil {scriptDone _h};
};


// Prepares all variables, may be placed in the save/load
C_variables = {
	//C_original_v = vehicleVarName player;
	["C_original_v", rolestring] call stats_init_variable;
	["C_original_c", (typeOf player)] call stats_init_variable;
	["C_changing", false] call stats_init_variable;	

	["C_original_west_v", ""] call stats_init_variable;
	["C_original_civ_v", ""] call stats_init_variable;
	["C_original_east_v", ""] call stats_init_variable;
	["C_original_guer_v", ""] call stats_init_variable;
	
	["C_original_west_c", ""] call stats_init_variable;
	["C_original_civ_c", ""] call stats_init_variable;
	["C_original_east_c", ""] call stats_init_variable;
	["C_original_guer_c", ""] call stats_init_variable;
	
	["C_haschanged", false] call stats_init_variable;

	["C_haschanged_west", false] call stats_init_variable;
	["C_haschanged_civ", false] call stats_init_variable;
	["C_haschanged_east", false] call stats_init_variable;
	["C_haschanged_guer", false] call stats_init_variable;


	["C_haschanged_c", ""] call stats_init_variable;

	["C_haschanged_west_c", ""] call stats_init_variable;
	["C_haschanged_civ_c", ""] call stats_init_variable;
	["C_haschanged_east_c", ""] call stats_init_variable;
	["C_haschanged_guer_c", ""] call stats_init_variable;
	

	["C_storage", []] call stats_init_variable;
	["C_storage_west", []] call stats_init_variable;
	["C_storage_civ", []] call stats_init_variable;
	["C_storage_east", []] call stats_init_variable;
	["C_storage_guer", []] call stats_init_variable;
		

	C_Side = playerside;
	C_spawn = getmarkerpos format["C_SPAWN_%1", playerSide];

	C_T_Styles =
	[
		"color",
		"perlinNoise",
		"irradiance",
		"fresnelGlass",
		"waterIrradiance",
		"treeCrown",
		"custom"
	];

	C_T_Formats =
	[
		"RGB",
		"ARGB",
		"AI"
	];

	C_T_Custom =
	[
		["#(ARGB,8,8,3)color(1,0,0,0.5)", "Red"],
		["#(ARGB,8,8,3)color(0,1,0,0.5)", "Green"],
		["#(ARGB,8,8,3)color(0,0,1,0.5)", "Blue"],
		["#(ARGB,8,8,3)color(1,1,1,1)", "White"],
		["#(ARGB,8,8,3)color(0,0,0,0.5)", "Black"]
	];

	C_T_Width = [];
	C_T_Height = [];
	C_T_MiniMap = [];
	
	private["_n", "_c"];
	
	_n = count C_T_Width;
	for [{_c = 1}, {_c <= 128}, {_c=_c * 2}] do
	{
		C_T_Width set [_n, _c];
		_n = _n + 1;
	};

	_n = count C_T_Height;
	for [{_c = 1}, {_c <= 128}, {_c=_c * 2}] do
	{
		
		C_T_Height set [_n, _c];
		_n = _n + 1;
	};

	_n = count C_T_MiniMap;
	for [{_c = 1}, {_c <= 8}, {_c=_c+1}] do
	{
		C_T_MiniMap set [_n, _c];
		_n = _n + 1;
	};

	C_T_Change = false;
	C_T_P = [];
};


// Function for saving all Clothes stuff to shorten
C_save = {
	private["_side"];
	_side = C_side;
	// Dynamic set-up
	["C_haschanged", C_haschanged] spawn stats_client_save;
	[format["C_haschanged_%1", _side], C_haschanged] spawn stats_client_save;
	[format["C_haschanged_%1_c", _side], C_haschanged_c]	spawn stats_client_save;	
	[format["C_original_%1_v", _side], C_original_v] spawn stats_client_save;	
	[format["C_original_%1_c", _side], C_original_c] spawn stats_client_save;
	["C_storage", C_storage] spawn stats_client_save;
	["C_storage_west",	 C_storage_west] spawn stats_client_save;
	["C_storage_civ", C_storage_civ] spawn stats_client_save;
	["C_storage_east", C_storage_east] spawn stats_client_save;
	["C_storage_guer", C_storage_guer] spawn stats_client_save;
};

C_array_d = {
	private ["_i", "_return", "_find"];
	
	_find	= _this select 0;
	_return = [];
	
	for [{_i = 0}, {_i < count Clothes}, {_i = _i + 1}] do {
		if (((Clothes select _i) select 0) == _find) then {
			_return = (Clothes select _i);
		};			
	};
	
	_return
};

C_array_c = {
	private ["_i", "_return", "_find"];
	
	_find	= _this select 0;
	_return = [];
	
	for [{_i = 0}, {_i < count Clothes}, {_i = _i + 1}] do {
		if (((Clothes select _i) select 1) == _find) then {
			_return = (Clothes select _i);
		};			
	};
	
	_return
};

C_array_s = {};
	
// Used for client connection, run by the client
C_connect_client = {
	private ["_side", "_changed"];
	C_clothes_loaded = false;
	
	_side = C_side;
	private["_variableName"];
	_variableName = format["C_haschanged_%1", _side];
	_changed = missionNamespace getVariable _variableName ;
	_changed = if (isNil "_changed") then { false } else {_changed};
	_changed = if (typeName _changed != "BOOL") then { false } else {_changed};
	
	C_haschanged = _changed;
	C_haschanged_c = missionNamespace getVariable format["C_haschanged_%1_c", _side];

	C_original_v = str(player);
	C_original_c = typeOf player;
	C_changing = false;

	private["_player"];
	_player = player;
	if (C_haschanged) then {
		_player = [C_haschanged_c] call C_change_load;
		_player = if (isNil "_player") then {player} else {_player};
	};

	[] spawn C_save;
	uiSleep 1;
	C_clothes_loaded = true;

	(_player)
};

clothes_functions_defined = true;