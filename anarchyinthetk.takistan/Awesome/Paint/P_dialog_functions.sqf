
P_Dialog_Full = {
	private ["_cam", "_IA", "_index", "_item", "_cost", "_lic", "_armorb", "_armors", "_texts", "_class", "_cfg", "_pack", "_DFML", "_n", "_c", "_veh", "_selected_maps"];

	disableSerialization;
	
	P_Preview_Logic		= _this select 0;
	
	P_CamOffsetX = 0;
	P_CamOffsetY = 0;
	P_CamZoomX = 3.5;
	P_CamZoomY = 0;
	P_CamDir = 1;

	P_Preview_Class = typeOf (vehicle player);
	
	P_Preview_Pos = getPosATL P_Preview_Logic;
	P_Preview_Dir = getDir P_Preview_Logic;
	
	liafu = true;
	
	P_Preview_Unit = P_Preview_Class createVehicleLocal (P_Preview_Pos);
	P_Preview_Unit setVehicleInit format["liafu = true; this setVehicleVarName '%1_CP_Dummy'; %1_CP_Dummy = this; this lock true; this allowDamage false;", player];
	processInitCommands;
	P_Preview_Unit setDir P_Preview_Dir;
	P_Preview_Unit setpos P_Preview_Pos;
	P_Preview_Unit allowDamage false;
	
	["light", P_Preview_Unit, 0.01] execvm "effects.sqf";
	
	P_T_P = [];
	P_T_Change = false;
	
	_veh = vehicle player;

	if (!(createDialog "Paint_Dialog")) exitWith {hint "Dialog Error!";};
	[] call P_Dialog_Setup;
	
	_cam = "Camera" camCreate [0, 0, 0];
	_cam cameraEffect ["internal", "front"];
	
	_texts = [];
	//_texts		= C_selectedarray select 10;
	_t_cfg			= getArray (configFile >> "CfgVehicles" >> P_Preview_Class >> "hiddenselections");
	_t_count		= count _t_cfg;
						
	if (_t_count > 0) then {	
		_n = 0;
		{
			_texts set [_n, _n];
			_n = _n + 1;
		} foreach _t_cfg;				
	};
	
	//_texts = P_texts;				
								
	{
		_index	= lbAdd [1502, format["%1", (_x)]];
		lbSetData [1502, _index, format["%1", (_x)]];
	} foreach _texts;
	
	_selected_maps = "";
	
	while {dialog} do {
		showCinemaBorder false;
	
		_DFML = findDisplay 3004;
	
		_cam camSetTarget [(getPosATL P_Preview_Unit select 0) + P_CamOffsetX, (getPosATL P_Preview_Unit select 1) + P_CamOffsetY, 1];
		_cam camSetRelPos [P_CamZoomX, P_CamZoomY, 0];
		_cam camCommit 0;
		
		
		if ((lbCurSel 1502) >= 0) then {
			ctrlEnable [1700, true];
			ctrlEnable [1701, true];
			ctrlEnable [1702, true];
			
			ctrlEnable [1705, true];
			ctrlEnable [1712, true];				
							
			P_T_Slot = lbData [1502, (lbCurSel 1502)];
			P_T_S = lbData [2100, (lbCurSel 2100)];
			P_T_M = lbData [2104, (lbCurSel 2104)];
							
			switch P_T_S do {		
				case "color": {
					(_DFML displayCtrl 1009) ctrlSetText format ['Red'];
					(_DFML displayCtrl 1010) ctrlSetText format ['Green'];
					(_DFML displayCtrl 1011) ctrlSetText format ['Blue'];
					(_DFML displayCtrl 1012) ctrlSetText format ['Alpha'];
					(_DFML displayCtrl 1013) ctrlSetText format ['N/A'];
				
					if ( ((lbCurSel 1502) >= 0) && ((lbCurSel 2100) >= 0) && ((lbCurSel 2101) >= 0) && ((lbCurSel 2102) >= 0) && ((lbCurSel 2103) >= 0) && ((lbCurSel 2104) >= 0) ) then {
						ctrlEnable [1713, true];
					} else {
						ctrlEnable [1713, false];
					};
				};
				
				case "perlinNoise":{
					(_DFML displayCtrl 1009) ctrlSetText format ['Y Scale'];
					(_DFML displayCtrl 1010) ctrlSetText format ['X Scale'];
					(_DFML displayCtrl 1011) ctrlSetText format ['Min'];
					(_DFML displayCtrl 1012) ctrlSetText format ['Max'];
					(_DFML displayCtrl 1013) ctrlSetText format ['N/A'];
				
					if ( ((lbCurSel 1502) >= 0) && ((lbCurSel 2100) >= 0) && ((lbCurSel 2101) >= 0) && ((lbCurSel 2102) >= 0) && ((lbCurSel 2103) >= 0) && ((lbCurSel 2104) >= 0) ) then {
						ctrlEnable [1713, true];
					} else {
						ctrlEnable [1713, false];
					};
				};

				case "irradiance": {
					(_DFML displayCtrl 1009) ctrlSetText format ['Specular'];
					(_DFML displayCtrl 1010) ctrlSetText format ['N/A'];
					(_DFML displayCtrl 1011) ctrlSetText format ['N/A'];
					(_DFML displayCtrl 1012) ctrlSetText format ['N/A'];
					(_DFML displayCtrl 1013) ctrlSetText format ['N/A'];
					
					if ( ((lbCurSel 1502) >= 0) && ((lbCurSel 2100) >= 0) && ((lbCurSel 2101) >= 0) && ((lbCurSel 2102) >= 0) && ((lbCurSel 2103) >= 0) && ((lbCurSel 2104) >= 0) ) then {
						ctrlEnable [1713, true];
					} else {
						ctrlEnable [1713, false];
					};
				};

				case "fresnelGlass":{
					(_DFML displayCtrl 1009) ctrlSetText format ['N/A'];
					(_DFML displayCtrl 1010) ctrlSetText format ['N/A'];
					(_DFML displayCtrl 1011) ctrlSetText format ['N/A'];
					(_DFML displayCtrl 1012) ctrlSetText format ['N/A'];
					(_DFML displayCtrl 1013) ctrlSetText format ['N/A'];
				
					if ( ((lbCurSel 1502) >= 0) && ((lbCurSel 2100) >= 0) && ((lbCurSel 2101) >= 0) && ((lbCurSel 2102) >= 0) && ((lbCurSel 2103) >= 0) && ((lbCurSel 2104) >= 0) ) then {
						ctrlEnable [1713, true];
					} else {
						ctrlEnable [1713, false];
					};
				};

				case "waterIrradiance":{
					(_DFML displayCtrl 1009) ctrlSetText format ['Specular'];
					(_DFML displayCtrl 1010) ctrlSetText format ['N/A'];
					(_DFML displayCtrl 1011) ctrlSetText format ['N/A'];
					(_DFML displayCtrl 1012) ctrlSetText format ['N/A'];
					(_DFML displayCtrl 1013) ctrlSetText format ['N/A'];
				
					if ( ((lbCurSel 1502) >= 0) && ((lbCurSel 2100) >= 0) && ((lbCurSel 2101) >= 0) && ((lbCurSel 2102) >= 0) && ((lbCurSel 2103) >= 0) && ((lbCurSel 2104) >= 0) ) then {
						ctrlEnable [1713, true];
					} else {
						ctrlEnable [1713, false];
					};
				};

				case "treeCrown":{
					(_DFML displayCtrl 1009) ctrlSetText format ['Density'];
					(_DFML displayCtrl 1010) ctrlSetText format ['N/A'];
					(_DFML displayCtrl 1011) ctrlSetText format ['N/A'];
					(_DFML displayCtrl 1012) ctrlSetText format ['N/A'];
					(_DFML displayCtrl 1013) ctrlSetText format ['N/A'];
				
					if ( ((lbCurSel 1502) >= 0) && ((lbCurSel 2100) >= 0) && ((lbCurSel 2101) >= 0) && ((lbCurSel 2102) >= 0) && ((lbCurSel 2103) >= 0) && ((lbCurSel 2104) >= 0) ) then {
						ctrlEnable [1713, true];
					} else {
						ctrlEnable [1713, false];
					};
				};

				case "custom":{
					(_DFML displayCtrl 1009) ctrlSetText format ['N/A'];
					(_DFML displayCtrl 1010) ctrlSetText format ['N/A'];
					(_DFML displayCtrl 1011) ctrlSetText format ['N/A'];
					(_DFML displayCtrl 1012) ctrlSetText format ['N/A'];
					(_DFML displayCtrl 1013) ctrlSetText format ['N/A'];
				
					if ( ((lbCurSel 2105) >= 0) ) then {
						ctrlEnable [1713, true];
					} else {
						ctrlEnable [1713, false];
					};
				};
			};

			if (_selected_maps != P_T_M) then {
				switch P_T_M do {
					case "1": {
						P_T_Height = [];
						_selected_maps = "1";
						_n = 0;
						for [{_c = 1}, {_c <= 128}, {_c=_c * 2}] do {
							P_T_Height set [_n, _c];
							_n = _n + 1;
						};
					};
					case "2":{
						P_T_Height = [];
						_selected_maps = "2";
						_n = 0;
						for [{_c = 2}, {_c <= 128}, {_c=_c * 2}] do{
							P_T_Height set [_n, _c];
							_n = _n + 1;
						};
					};
					case "3":{
						P_T_Height = [];
						_selected_maps = "3";
						_n = 0;
						for [{_c = 4}, {_c <= 128}, {_c=_c * 2}] do{
							P_T_Height set [_n, _c];
							_n = _n + 1;
						};
					};
					case "4":{
						P_T_Height = [];
						_selected_maps = "4";
						_n = 0;
						for [{_c = 8}, {_c <= 128}, {_c=_c * 2}] do{
							P_T_Height set [_n, _c];
							_n = _n + 1;
						};
					};
					case "5":{
						P_T_Height = [];
						_selected_maps = "5";
						_n = 0;
						for [{_c = 16}, {_c <= 128}, {_c=_c * 2}] do{
							P_T_Height set [_n, _c];
							_n = _n + 1;
						};
					};
					case "6":{
						P_T_Height = [];
						_selected_maps = "6";
						_n = 0;
						for [{_c = 32}, {_c <= 128}, {_c=_c * 2}] do{
							P_T_Height set [_n, _c];
							_n = _n + 1;
						};
					};
					case "7": {	
						P_T_Height = [];
						_selected_maps = "7";
						_n = 0;
						for [{_c = 64}, {_c <= 128}, {_c=_c * 2}] do{
							P_T_Height set [_n, _c];
							_n = _n + 1;
						};
					};
					case "8": {
						P_T_Height = [];
						_selected_maps = "8";
						_n = 0;
						for [{_c = 128}, {_c <= 128}, {_c=_c * 2}] do{
							P_T_Height set [_n, _c];
							_n = _n + 1;
						};
					};		
				};
					
				lbClear 2103;
				
				{
					_index	= lbAdd [2103, format["%1", (_x)]];
					lbSetData [2103, _index, format["%1", (_x)]];
				} foreach P_T_Height;
					
				lbSetCurSel [2103, 0];
			};

			/*		
			if ( ((lbCurSel 1502) >= 0) && ((lbCurSel 2100) >= 0) && ((lbCurSel 2101) >= 0) && ((lbCurSel 2102) >= 0) && ((lbCurSel 2103) >= 0) && ((lbCurSel 2104) >= 0) ) then {
					ctrlEnable [1705, true];
					ctrlEnable [1712, true];
					ctrlEnable [1713, true];
				} else {
					ctrlEnable [1705, false];
					ctrlEnable [1712, false];
					ctrlEnable [1713, false];
				};
			*/			
		} else {
			ctrlEnable [1700, false];
			ctrlEnable [1701, false];
			ctrlEnable [1702, false];

			ctrlEnable [1705, false];
			ctrlEnable [1712, false];
			ctrlEnable [1713, false];
		};

		
		if (P_choice == "storage") then {
			ctrlEnable [1701, false];
		};
		
		if (P_choice == "store") then {
			ctrlEnable [1701, true];
		};
		
		if (vehicle player == player) then {closeDialog 0; player groupchat "P ERROR: Player exited vehicle"};
		if (vehicle player != _veh) then {closeDialog 0; player groupchat "P ERROR: Player Changed Vehicles"};
		
		sleep 0.01;
	};
	
	_cam cameraEffect ["terminate", "front"];
	camDestroy _cam;
	deleteVehicle P_Preview_Unit;
};


P_Preview_Zoom = {
	private ["_choice"];
	_choice = _this select 0;
	
	switch _choice do {
		case 1:{
			switch P_CamDir do {
				case 1:{
					if (P_CamZoomX > 0.5) Then {P_CamZoomX = P_CamZoomX - 0.5};
				};
				case 2:{
					if (P_CamZoomX < -0.5) Then {P_CamZoomX = P_CamZoomX + 0.5};
				};
				case 3:{
					if (P_CamZoomY < -0.5) Then {P_CamZoomY = P_CamZoomY + 0.5};
				};
				case 4:{
					if (P_CamZoomY > 0.5) Then {P_CamZoomY = P_CamZoomY - 0.5};
				};
			};
		};
		case 2:{
			switch P_CamDir do {
				case 1:{
					if (P_CamZoomX < 10) Then {P_CamZoomX = P_CamZoomX + 0.5};
				};
				case 2:{
					if (P_CamZoomX > -10) Then {P_CamZoomX = P_CamZoomX - 0.5};
				};
				case 3:{
					if (P_CamZoomY > -10) Then {P_CamZoomY = P_CamZoomY - 0.5};
				};
				case 4:{
					if (P_CamZoomY < 10) Then {P_CamZoomY = P_CamZoomY + 0.5};
				};
			};
		};
	};
};


P_Preview_Camera = {
	private ["_choice"];

	_choice = _this select 0;
	switch _choice do {
		case 1: {
			P_CamOffsetX = 0;
			P_CamOffsetY = 0;
			P_CamZoomX = 3.5;
			P_CamZoomY = 0;
			P_CamDir = 1;
		};
		case 2: {
			P_CamOffsetX = 0;
			P_CamOffsetY = 0;
			P_CamZoomX = -3.5;
			P_CamZoomY = 0;
			P_CamDir = 2;
		};
		case 3: {
			P_CamOffsetX = 0;
			P_CamOffsetY = 0;
			P_CamZoomX = 0;
			P_CamZoomY = -3.5;
			P_CamDir = 3;
		};
		case 4: {
			P_CamOffsetX = 0;
			P_CamOffsetY = 0;
			P_CamZoomX = 0;
			P_CamZoomY = 3.5;
			P_CamDir = 4;
		};
	};
};


P_buy = {
	private ["_x", "_c", "_moneh", "_cost"];

	_moneh  = [player, 'money'] call INV_GetItemAmount;
	_cost	= P_cost;
	
	if (_moneh < _cost) exitwith {player groupchat format["Your require $%1 for this", _cost];};
	
	[player, 'money', -(_cost)] call INV_AddInventoryItem;
	
	player groupchat format["You Paid $%1 to apply the paint to your car", _cost];
	
	if ( P_T_Change ) then {
		for [{_c = 0}, {_c < (count P_T_P) }, {_c=_c+1}] do {
			_x = P_T_P select _c;
			if ( (typeName _x) == "STRING" ) then {
				(vehicle player) setVehicleInit format["liafu = true; this setObjectTexture %1", [_c, _x]];
				processInitCommands;
			};
		};
		P_T_Change = false;
	};
};


P_r_buy = {
	private ["_x", "_n", "_moneh", "_cost", "_cfg1", "_cfg2"];
	_moneh  = [player, 'money'] call INV_GetItemAmount;
	_cost	= P_cost;
	
	if (_moneh < _cost) exitwith {player groupchat format["Your require $%1 for this", _cost];};
	
	[player, 'money', -(_cost)] call INV_AddInventoryItem;
	
	player groupchat format["You Paid $%1 to apply the original paint to your car", _cost];
	

	_cfg1		= getArray (configFile >> "CfgVehicles" >> P_Preview_Class >> "hiddenselections");
	_cfg2		= getArray (configFile >> "CfgVehicles" >> P_Preview_Class >> "hiddenselectionstextures");
	
	clearVehicleInit (vehicle player);
	
	_n = 0;
	{
		(vehicle player) setVehicleInit format["liafu = true; this setObjectTexture %1", [_n, _x]];
		processInitCommands;
		_n = _n + 1;
	} forEach _cfg2;
};

P_T_Apply = {
	private ["_exit"];

	P_T_SSlot = parseNumber (lbData [1502, (lbCurSel 1502)]);
	P_T_SStyle = lbData [2100, (lbCurSel 2100)];
	P_T_SFormat = lbData [2101, (lbCurSel 2101)];
	P_T_SWidth = parseNumber (lbData [2102, (lbCurSel 2102)]);
	P_T_SHeight = parseNumber (lbData [2103, (lbCurSel 2103)]);
	P_T_SMap = parseNumber (lbData [2104, (lbCurSel 2104)]);
	P_T_SCustom = lbData [2105, (lbCurSel 2105)];

	P_T_C_1_1 = ctrlText 1400;
	P_T_C_2_1 = ctrlText 1401;
	P_T_C_3_1 = ctrlText 1402;
	P_T_C_4_1 = ctrlText 1403;
	P_T_C_5_1 = ctrlText 1404;
	
	P_T_C_1	= ((parseNumber(P_T_C_1_1)) + 0);
	P_T_C_2	= ((parseNumber(P_T_C_2_1)) + 0);
	P_T_C_3	= ((parseNumber(P_T_C_3_1)) + 0);
	P_T_C_4	= ((parseNumber(P_T_C_4_1)) + 0);
	
	P_Texture = "";
	
	_exit = false;
	
	if ( (C_T_SStyle != "") && (C_T_SStyle != "custom") ) then {
		if ( (P_T_SWidth <= 0) || ((typeName P_T_SWidth) != "SCALAR") ) then {
			player groupchat "C ERROR: Incorrect Width Value";
			_exit = true;
		};
		if ( (P_T_SHeight <= 0) || ((typeName P_T_SHeight) != "SCALAR") ) then {
			player groupchat "C ERROR: Incorrect Height Value";
			_exit = true;
		};
		if ( (P_T_SMap <= 0) || ((typeName P_T_SMap) != "SCALAR") ) then {
			player groupchat "C ERROR: Incorrect Minimaps Value";
			_exit = true;
		};
	};
	
	if (_exit) exitwith {};
	
	switch P_T_SStyle do {
		case "color": {
			if ( (P_T_C_1) < 0 ) then { player groupchat "P ERROR: Red must be higher than or equal to 0"; _exit = true;};
			if ( (P_T_C_1) > 1  ) then { player groupchat "P ERROR: Red must be less than or equal to 1"; _exit = true; };
			
			if ( (P_T_C_2) < 0 ) then { player groupchat "P ERROR: Green must be higher than or equal to 0"; _exit = true; };
			if ( (P_T_C_2) > 1  ) then { player groupchat "P ERROR: Green must be less than or equal to 1"; _exit = true; };
			
			if ( (P_T_C_3) < 0 ) then { player groupchat "P ERROR: Blue must be higher than or equal to 0"; _exit = true; };
			if ( (P_T_C_3) > 1  ) then { player groupchat "P ERROR: Blue must be less than or equal to 1"; _exit = true; };
			
			if ( (P_T_C_4) < 0.5 ) then { player groupchat "P ERROR: Alpha must be higher than or equal to 0.5"; _exit = true; };
			if ( (P_T_C_4) > 1  ) then { player groupchat "P ERROR: Alpha must be less than or equal to 1"; _exit = true; };
			
			if ( _exit ) exitwith {};
			
			P_Texture = format['#(%1,%2,%3,%4)color(%5,%6,%7,%8)', P_T_SFormat, P_T_SWidth, P_T_SHeight, P_T_SMap, P_T_C_1, P_T_C_2, P_T_C_3, P_T_C_4];
		};
		
		case "perlinNoise":{
			if ( (P_T_C_1) < 0 ) then { player groupchat "P ERROR: Specular must be higher than or equal to 0"; _exit = true;};
			
			if ( _exit ) exitwith {};
			
			P_Texture = format['#(%1,%2,%3,%4)perlinNoise(%5,%6,%7,%8)', P_T_SFormat, P_T_SWidth, P_T_SHeight, P_T_SMap, P_T_C_1, P_T_C_2, P_T_C_3, P_T_C_4];
		};
		
		case "irradiance":{
			if ( (P_T_C_1) < 0 ) then { player groupchat "P ERROR: Specular must be higher than or equal to 0"; _exit = true;};
			
			if ( _exit ) exitwith {};
			
			P_Texture = format['#(%1,%2,%3,%4)irradiance(%5)', P_T_SFormat, P_T_SWidth, P_T_SHeight, P_T_SMap, P_T_C_1];
		};
		
		case "fresnelGlass": {
			P_Texture = format['#(%1,%2,%3,%4)fresnelGlass()', P_T_SFormat, P_T_SWidth, P_T_SHeight, P_T_SMap];
		};
		
		case "waterIrradiance": {
			if ( (P_T_C_1) < 0 ) then { player groupchat "P ERROR: Specular must be higher than or equal to 0"; _exit = true;};
			
			if ( _exit ) exitwith {};
			
			P_Texture = format['#(%1,%2,%3,%4)waterIrradiance(%5)', P_T_SFormat, P_T_SWidth, P_T_SHeight, P_T_SMap, P_T_C_1];
		};
		
		case "treeCrown":{
			if ( (P_T_C_1) < 0 ) then { player groupchat "P ERROR: Density must be higher than or equal to 0"; _exit = true;};
			
			if ( _exit ) exitwith {};
			
			P_Texture = format['#(%1,%2,%3,%4)treeCrown(%5)', P_T_SFormat, P_T_SWidth, P_T_SHeight, P_T_SMap, P_T_C_1];
		};
	
		case "custom": {
			P_Texture = P_T_SCustom;
		};
	};
	
	if ( _exit ) exitwith {};
	
	if (P_Texture != "") then {
		player groupchat "Texture Applied";
		P_Preview_Unit setObjectTexture [P_T_SSlot, P_Texture];
		P_T_P set [P_T_SSlot, P_Texture];
		P_T_Change = true;
	};
};


P_T_R_Slot = {
	private ["_c", "_x", "_cfg1", "_cfg2"];

	_cfg1 = getArray (configFile >> "CfgVehicles" >> P_Preview_Class >> "hiddenselections");
	_cfg2 = getArray (configFile >> "CfgVehicles" >> P_Preview_Class >> "hiddenselectionstextures");
	
	P_T_SSlot = parseNumber (lbData [1502, (lbCurSel 1502)]);
	
	P_Preview_Unit setObjectTexture [P_T_SSlot, _cfg2 select P_T_SSlot];
};


P_T_R_All ={
	private ["_cfg1", "_cfg2", "_x", "_n"];
	
	_cfg1 = getArray (configFile >> "CfgVehicles" >> P_Preview_Class >> "hiddenselections");
	_cfg2 = getArray (configFile >> "CfgVehicles" >> P_Preview_Class >> "hiddenselectionstextures");
	
	_n = 0;
	{
		P_Preview_Unit setObjectTexture [_n, _x];
		_n = _n + 1;
	} foreach _cfg2;
	
	P_T_P = [];
	P_T_Change = false;
};


P_Dialog_Setup = {
private ["_DFML", "_shop", "_shop_change", "_P_1", "_P_2", "_cb_1", "_cb_2", "_index"];

	_DFML = findDisplay 3004;
	
	
	// Titles Texts
	(_DFML displayCtrl 1001) ctrlSetText format['Camera Control'];
	(_DFML displayCtrl 1002) ctrlSetText format ['Textures'];
	
	(_DFML displayCtrl 1008) ctrlSetText format ['Custom Texture'];
	(_DFML displayCtrl 1003) ctrlSetText format ['Style'];
	(_DFML displayCtrl 1004) ctrlSetText format ['Format'];
	(_DFML displayCtrl 1005) ctrlSetText format ['Width'];
	(_DFML displayCtrl 1006) ctrlSetText format ['Height'];
	(_DFML displayCtrl 1007) ctrlSetText format ['Minimaps'];
	
	(_DFML displayCtrl 1009) ctrlSetText format ['Custom 1'];
	(_DFML displayCtrl 1010) ctrlSetText format ['Custom 2'];
	(_DFML displayCtrl 1011) ctrlSetText format ['Custom 3'];
	(_DFML displayCtrl 1012) ctrlSetText format ['Custom 4'];
	(_DFML displayCtrl 1013) ctrlSetText format ['Custom 5'];
	
	// Button Texts
	(_DFML displayCtrl 1700) ctrlSetText format ['Buy $%1', P_cost];
	(_DFML displayCtrl 1702) ctrlSetText format ['Reset $%1', P_cost];
	(_DFML displayCtrl 1701) ctrlSetText format ['Cancel - Close'];
	
	(_DFML displayCtrl 1706) ctrlSetText format ['Zoom In'];
	(_DFML displayCtrl 1707) ctrlSetText format ['Zoom Out'];
	
	(_DFML displayCtrl 1708) ctrlSetText format ['Camera Front'];
	(_DFML displayCtrl 1709) ctrlSetText format ['Camera Back'];
	(_DFML displayCtrl 1710) ctrlSetText format ['Camera Left'];
	(_DFML displayCtrl 1711) ctrlSetText format ['Camera Right'];
	
	(_DFML displayCtrl 1713) ctrlSetText format ['Apply Texture'];
	(_DFML displayCtrl 1712) ctrlSetText format ['Reset Slot'];
	(_DFML displayCtrl 1705) ctrlSetText format ['Reset All'];
	
	// Button Actions
	(_DFML displayCtrl 1700) buttonsetaction format ['[] call P_buy'];
	(_DFML displayCtrl 1702) buttonsetaction format ['[] call P_r_buy'];
	(_DFML displayCtrl 1701) buttonsetaction format ['closeDialog 0'];
	
	(_DFML displayCtrl 1706) buttonsetaction format ['[1] call P_Preview_Zoom;'];
	(_DFML displayCtrl 1707) buttonsetaction format ['[2] call P_Preview_Zoom;'];
	
	(_DFML displayCtrl 1708) buttonsetaction format ['[1] call P_Preview_Camera;'];
	(_DFML displayCtrl 1709) buttonsetaction format ['[2] call P_Preview_Camera;'];
	(_DFML displayCtrl 1710) buttonsetaction format ['[3] call P_Preview_Camera;'];
	(_DFML displayCtrl 1711) buttonsetaction format ['[4] call P_Preview_Camera;'];
	
	(_DFML displayCtrl 1713) buttonsetaction format ['[] call P_T_Apply'];
	(_DFML displayCtrl 1712) buttonsetaction format ['[] call P_T_R_Slot'];
	(_DFML displayCtrl 1705) buttonsetaction format ['[] call P_T_R_All'];


	{
		_index	= lbAdd [2100, format["%1", (_x)]];
		lbSetData [2100, _index, _x];
	} foreach P_T_Styles;

	{
		_index	= lbAdd [2101, format["%1", (_x)]];
		lbSetData [2101, _index, _x];
	} foreach P_T_Formats;

	{
		_index	= lbAdd [2102, format["%1", (_x)]];
		lbSetData [2102, _index, format["%1", (_x)]];
	} foreach P_T_Width;

	{
		_index	= lbAdd [2103, format["%1", (_x)]];
		lbSetData [2103, _index, format["%1", (_x)]];
	} foreach P_T_Height;

	{
		_index	= lbAdd [2104, format["%1", (_x)]];
		lbSetData [2104, _index, format["%1", (_x)]];
	} foreach P_T_MiniMap;
	
	{
		_index	= lbAdd [2105, format["%1", (_x select 1)]];
		lbSetData [2105, _index, format["%1", (_x select 0)]];
	} foreach P_T_Custom;
};