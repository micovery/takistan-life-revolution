
C_Dialog_Choice = {
	liafu = true;
	private ["_DFML"];

	disableSerialization;

	if (!(createDialog "Option_window_2")) exitWith {hint "Dialog Error!";};
	_DFML = findDisplay 3002;

	(_DFML displayCtrl 1) ctrlSetText format ['Select your choice'];
	(_DFML displayCtrl 2) ctrlSetText format ['Open shop menu'];
	(_DFML displayCtrl 3) ctrlSetText format ['Open storage menu'];
	buttonSetAction [2, 'C_choice = "store";		closeDialog 0;'];
	buttonSetAction [3, 'C_choice = "storage";		closeDialog 0;'];
	buttonSetAction [4, 'C_exit = true;				closeDialog 0;'];
	_DFML displayAddEventHandler ['onUnload', 'C_exit = true;'];

	waitUntil {!ctrlVisible 1030};
};


C_Dialog_Full = {
	liafu = true;
	private ["_cam", "_IA", "_index", "_item", "_cost", "_lic", "_armorb", "_armors", "_texts", "_class", "_cfg", "_pack", "_DFML", "_n", "_c", "_t_cfg", "_t_count", "_selected_maps"];

	disableSerialization;
	
	C_Preview_Logic		= C_shoparray select 5;
	
	C_CamOffsetX = 0;
	C_CamOffsetY = 0;
	C_CamZoomX = 3.5;
	C_CamZoomY = 0;
	C_CamDir = 1;

	C_Preview_Class = typeOf player;
	//C_Preview_Group = createGroup C_side;
	C_Preview_Group = (group server);
	
	C_Preview_Pos = getPosATL C_Preview_Logic;
	C_Preview_Unit = C_Preview_Group createUnit [C_Preview_Class, C_Preview_Pos, [], 0, "CAN_COLLIDE"];
	[C_Preview_Unit] joinSilent C_Preview_Group;
	C_Preview_Unit setVehicleInit format["liafu = true; this setVehicleVarName '%1_%2_C_Dummy'; %1_%2_C_Dummy = this; this disableAI 'move';this disableAI 'anim'; this allowDamage false;", player, round(time)];
	processInitCommands;
	C_Preview_Unit setDir ((getDir C_Preview_Logic));
	C_Preview_Unit setBehaviour "CARELESS";
	C_Preview_Unit setposATL C_Preview_Pos;
	C_Preview_Group setFormDir ((getDir C_Preview_Logic));
	
	["light", C_Preview_Unit, 0.01] execvm "effects.sqf";
	
	[C_Preview_Unit] call player_reset_gear;
	C_Preview_Unit allowDamage false;
	doStop C_Preview_Unit;
	
	C_T_P = [];
	C_T_Change = false;
	
	format["if(player != %1) then { %2 hideObject true; };", player, C_Preview_Unit] call broadcast;
	
	if (!(createDialog "Clothes_Dialog")) exitWith {hint "Dialog Error!";};
	[] call C_Dialog_Setup;
	
	_cam = "Camera" camCreate [0, 0, 0];
	_cam cameraEffect ["internal", "front"];
	
	{
		_IA 	= [_x] call C_array_d;
		_index	= lbAdd [1500, format["%1", (_IA select 2)]];
		lbSetData [1500, _index, _x];
	} foreach C_List;
	
	_past_item = "";
	_selected_maps = "0";
	
	while {dialog} do {
		showCinemaBorder false;
		_cam camSetTarget [(getPosATL C_Preview_Unit select 0) + C_CamOffsetX, (getPosATL C_Preview_Unit select 1) + C_CamOffsetY, 1];
		_cam camSetRelPos [C_CamZoomX, C_CamZoomY, 0];
		_cam camCommit 0;
		
		if ((lbCurSel 1500) >= 0) then {
				_item = lbData [1500, (lbCurSel 1500)];
				lbClear 1502;
			if (_item != "") then {
				ctrlEnable [1700, true];
				ctrlEnable [1701, true];
				ctrlEnable [1702, true];
				
				C_selectedarray = [_item] call C_array_d;
	
				_class = C_selectedarray select 1;
				_cost = C_selectedarray select 6;
				_lic = C_selectedarray select 7;
				_armorb = C_selectedarray select 8;
				_armors = C_selectedarray select 9;
				
				_texts = [];
				//_texts		= C_selectedarray select 10;
				_t_cfg		= getArray (configFile >> "CfgVehicles" >> _class >> "hiddenselections");
				_t_count	= count _t_cfg;
				
				if (_t_count > 0) then {
					_n = 0;
					{
						_texts set [_n, _n];
						_n = _n + 1;
					} foreach _t_cfg;
				};
					
				_cfg = getNumber (configFile >> "CfgVehicles" >> _class >> "cancarrybackpack");
				_pack = false;
				if (_cfg == 1) then {
					_pack = true;
				} else {
					_pack = false;
				};
					
				if (_item != _past_item) then {
					lbClear 1501;
			
					lbAdd [1501, format["Cost: $%1", 			_cost]];
					lbAdd [1501, format["Licenses-",			_lic]];
					
					if ( (_lic select 0) != ("") ) then {
						{
							lbAdd [1501, format["%1: %2", (_lic find _x) + 1,_x call INV_GetLicenseName]];
						} foreach _lic;
					};
					
					lbAdd [1501, format["Texture Slots: %1", 	_texts]];
					lbAdd [1501, format["Supported Stun Armor: %1", 	_armors]];
					lbAdd [1501, format["Supported Body Armor: %1", 	_armorb]];
					lbAdd [1501, format["Backpack: %1", 		_pack]];
				
					_past_item = _item;
				};
					
				if ( (count _texts) > 0 ) then {
					_DFML = findDisplay 3003;
					
					{
						_index	= lbAdd [1502, format["%1", (_x)]];
						lbSetData [1502, _index, format["%1", (_x)]];
					} foreach _texts;
						
					C_T_Slot 	= lbData [1502, (lbCurSel 1502)];
					C_T_S	 	= lbData [2100, (lbCurSel 2100)];
					C_T_M		= lbData [2104, (lbCurSel 2104)];
						
					switch C_T_S do {
						case "color": {
							(_DFML displayCtrl 1009) 		ctrlSetText 		format ['Red'];
							(_DFML displayCtrl 1010) 		ctrlSetText 		format ['Green'];
							(_DFML displayCtrl 1011) 		ctrlSetText 		format ['Blue'];
							(_DFML displayCtrl 1012) 		ctrlSetText 		format ['Alpha'];
							(_DFML displayCtrl 1013) 		ctrlSetText 		format ['N/A'];
						
							if ( ((lbCurSel 1502) >= 0) && ((lbCurSel 2100) >= 0) && ((lbCurSel 2101) >= 0) && ((lbCurSel 2102) >= 0) && ((lbCurSel 2103) >= 0) && ((lbCurSel 2104) >= 0) ) then {
								ctrlEnable [1713, true];
							} else {
								ctrlEnable [1713, false];
							};
						};
							
						case "perlinNoise": {
							(_DFML displayCtrl 1009) 		ctrlSetText 		format ['Y Scale'];
							(_DFML displayCtrl 1010) 		ctrlSetText 		format ['X Scale'];
							(_DFML displayCtrl 1011) 		ctrlSetText 		format ['Min'];
							(_DFML displayCtrl 1012) 		ctrlSetText 		format ['Max'];
							(_DFML displayCtrl 1013) 		ctrlSetText 		format ['N/A'];
						
							if ( ((lbCurSel 1502) >= 0) && ((lbCurSel 2100) >= 0) && ((lbCurSel 2101) >= 0) && ((lbCurSel 2102) >= 0) && ((lbCurSel 2103) >= 0) && ((lbCurSel 2104) >= 0) ) then {
								ctrlEnable [1713, true];
							} else {
								ctrlEnable [1713, false];
							};
						};
							
						case "irradiance": {
							(_DFML displayCtrl 1009) 		ctrlSetText 		format ['Specular'];
							(_DFML displayCtrl 1010) 		ctrlSetText 		format ['N/A'];
							(_DFML displayCtrl 1011) 		ctrlSetText 		format ['N/A'];
							(_DFML displayCtrl 1012) 		ctrlSetText 		format ['N/A'];
							(_DFML displayCtrl 1013) 		ctrlSetText 		format ['N/A'];
						
							if ( ((lbCurSel 1502) >= 0) && ((lbCurSel 2100) >= 0) && ((lbCurSel 2101) >= 0) && ((lbCurSel 2102) >= 0) && ((lbCurSel 2103) >= 0) && ((lbCurSel 2104) >= 0) ) then {
								ctrlEnable [1713, true];
							} else {
								ctrlEnable [1713, false];
							};
						};
							
						case "fresnelGlass": {
							(_DFML displayCtrl 1009) 		ctrlSetText 		format ['N/A'];
							(_DFML displayCtrl 1010) 		ctrlSetText 		format ['N/A'];
							(_DFML displayCtrl 1011) 		ctrlSetText 		format ['N/A'];
							(_DFML displayCtrl 1012) 		ctrlSetText 		format ['N/A'];
							(_DFML displayCtrl 1013) 		ctrlSetText 		format ['N/A'];
						
							if ( ((lbCurSel 1502) >= 0) && ((lbCurSel 2100) >= 0) && ((lbCurSel 2101) >= 0) && ((lbCurSel 2102) >= 0) && ((lbCurSel 2103) >= 0) && ((lbCurSel 2104) >= 0) ) then {
								ctrlEnable [1713, true];
							} else {
								ctrlEnable [1713, false];
							};
						};
							
						case "waterIrradiance": {
							(_DFML displayCtrl 1009) 		ctrlSetText 		format ['Specular'];
							(_DFML displayCtrl 1010) 		ctrlSetText 		format ['N/A'];
							(_DFML displayCtrl 1011) 		ctrlSetText 		format ['N/A'];
							(_DFML displayCtrl 1012) 		ctrlSetText 		format ['N/A'];
							(_DFML displayCtrl 1013) 		ctrlSetText 		format ['N/A'];
						
							if ( ((lbCurSel 1502) >= 0) && ((lbCurSel 2100) >= 0) && ((lbCurSel 2101) >= 0) && ((lbCurSel 2102) >= 0) && ((lbCurSel 2103) >= 0) && ((lbCurSel 2104) >= 0) ) then {
								ctrlEnable [1713, true];
							} else {
								ctrlEnable [1713, false];
							};
						};
							
						case "treeCrown": {
							(_DFML displayCtrl 1009) 		ctrlSetText 		format ['Density'];
							(_DFML displayCtrl 1010) 		ctrlSetText 		format ['N/A'];
							(_DFML displayCtrl 1011) 		ctrlSetText 		format ['N/A'];
							(_DFML displayCtrl 1012) 		ctrlSetText 		format ['N/A'];
							(_DFML displayCtrl 1013) 		ctrlSetText 		format ['N/A'];
						
							if ( ((lbCurSel 1502) >= 0) && ((lbCurSel 2100) >= 0) && ((lbCurSel 2101) >= 0) && ((lbCurSel 2102) >= 0) && ((lbCurSel 2103) >= 0) && ((lbCurSel 2104) >= 0) ) then {
								ctrlEnable [1713, true];
							} else {
								ctrlEnable [1713, false];
							};
						};
							
						case "custom": {
							(_DFML displayCtrl 1009) 		ctrlSetText 		format ['N/A'];
							(_DFML displayCtrl 1010) 		ctrlSetText 		format ['N/A'];
							(_DFML displayCtrl 1011) 		ctrlSetText 		format ['N/A'];
							(_DFML displayCtrl 1012) 		ctrlSetText 		format ['N/A'];
							(_DFML displayCtrl 1013) 		ctrlSetText 		format ['N/A'];
						
							if ( ((lbCurSel 2105) >= 0) ) then {
								ctrlEnable [1713, true];
							} else {
								ctrlEnable [1713, false];
							};
						};
					};
						
					if (_selected_maps != C_T_M) then {
						switch C_T_M do {
							case "1": {
								C_T_Height = [];
								_selected_maps = "1";
								_n = 0;
								for [{_c = 1}, {_c <= 128}, {_c = _c * 2}] do
								{
									C_T_Height set [_n, _c];
									_n = _n + 1;
								};
							};
								
							case "2": {
								C_T_Height = [];
								_selected_maps = "2";
								_n = 0;
								for [{_c = 2}, {_c <= 128}, {_c=_c * 2}] do
								{
									C_T_Height set [_n, _c];
									_n = _n + 1;
								};
							};
								
							case "3": {
								C_T_Height = [];
								_selected_maps = "3";
								_n = 0;
								_c = 4;
								for [{_c = 4}, {_c <= 128}, {_c=_c * 2}] do
								{
									C_T_Height set [_n, _c];
									_n = _n + 1;
								};
							};
								
							case "4": {
								C_T_Height = [];
								_selected_maps = "4";
								_n = 0;
								_c = 9;
								for [{_c = 8}, {_c <= 128}, {_c=_c * 2}] do
								{
									C_T_Height set [_n, _c];
									_n = _n + 1;
								};
							};
								
							case "5": {
								C_T_Height = [];
								_selected_maps = "5";
								_n = 0;
								_c = 16;
								for [{_c = 16}, {_c <= 128}, {_c=_c * 2}] do
								{
									C_T_Height set [_n, _c];
									_n = _n + 1;
								};
							};
								
							case "6": {
								C_T_Height = [];
								_selected_maps = "6";
								_n = 0;
								_c = 32;
								for [{_c = 32}, {_c <= 128}, {_c=_c * 2}] do
								{
									C_T_Height set [_n, _c];
									_n = _n + 1;
								};
							};
								
							case "7": {	
								C_T_Height = [];
								_selected_maps = "7";
								_n = 0;
								_c = 64;
								for [{_c = 64}, {_c <= 128}, {_c=_c * 2}] do
								{
									C_T_Height set [_n, _c];
									_n = _n + 1;
								};
							};
								
							case "8": {
								C_T_Height = [];
								_selected_maps = "8";
								_n = 0;
								_c = 128;
								for [{_c = 128}, {_c <= 128}, {_c=_c * 2}] do {
									C_T_Height set [_n, _c];
									_n = _n + 1;
								};
							};
						};
								
						lbClear 2103;
						
						{
							_index	= lbAdd [2103, format["%1", (_x)]];
							lbSetData [2103, _index, format["%1", (_x)]];
						} foreach C_T_Height;
						
						lbSetCurSel [2103, 0];
					};
				} else {
					ctrlEnable [1705, false];
					ctrlEnable [1712, false];
					ctrlEnable [1713, false];
				};
			} else {
				ctrlEnable [1700, false];
				ctrlEnable [1701, false];
				ctrlEnable [1702, false];
				
				lbClear 1501;
				
				ctrlEnable [1705, false];
				ctrlEnable [1712, false];
				ctrlEnable [1713, false];
			};
		} else {
			ctrlEnable [1700, false];
			ctrlEnable [1701, false];
			ctrlEnable [1702, false];
			ctrlEnable [1705, false];
			ctrlEnable [1712, false];
			ctrlEnable [1713, false];
		};
		
		if (C_choice == "storage") then {
			ctrlEnable [1701, false];
		};
		
		if (C_choice == "store") then {
			ctrlEnable [1701, true];
		};
		sleep 0.01;
	};
	
	_cam cameraEffect ["terminate", "front"];
	camDestroy _cam;
	
	deleteVehicle C_Preview_Unit;
	//deleteGroup C_Preview_Group;
};


C_Dialog_Switch = {
	liafu = true;
	private ["_IA", "_index"];

	Switch C_choice do {
		case "storage": {
			C_List = C_ShopList;
			C_choice = "store";
		};
		
		case "store": {
			C_List = C_tstorage + [format["%1",([C_original_c] call C_array_c) select 0]];
			C_choice = "storage";
		};
	};

	lbClear 1500;
	lbClear 2100;
	lbClear 2101;
	lbClear 2102;
	lbClear 2103;
	lbClear 2104;
	lbClear 2105;
		
	{
		_IA 	= [_x] call C_array_d;
		_index	= lbAdd [1500, format["%1", (_IA select 2)]];
		lbSetData [1500, _index, _x];
	} foreach C_List;

	[] call C_Dialog_Setup;
};


C_Preview_Zoom = {
	liafu = true;
	private ["_choice"];

	_choice = _this select 0;
	
	switch _choice do {
		case 1: {
			switch C_CamDir do {
				case 1: {
						If (C_CamZoomX > 0.5) Then {C_CamZoomX = C_CamZoomX - 0.5};
					};
				case 2: {
						If (C_CamZoomX < -0.5) Then {C_CamZoomX = C_CamZoomX + 0.5};
					};
				case 3: {
						If (C_CamZoomY < -0.5) Then {C_CamZoomY = C_CamZoomY + 0.5};
					};
				case 4: {
						If (C_CamZoomY > 0.5) Then {C_CamZoomY = C_CamZoomY - 0.5};
					};
			};
		};
		case 2: {
			switch C_CamDir do {
				case 1: {
					If (C_CamZoomX < 10) Then {C_CamZoomX = C_CamZoomX + 0.5};
				};
				case 2: {
					If (C_CamZoomX > -10) Then {C_CamZoomX = C_CamZoomX - 0.5};
				};
				case 3: {
					If (C_CamZoomY > -10) Then {C_CamZoomY = C_CamZoomY - 0.5};
				};
				case 4: {
					If (C_CamZoomY < 10) Then {C_CamZoomY = C_CamZoomY + 0.5};
				};
			};
		};
	};
};


C_Preview_Camera = {
	liafu = true;
	private ["_choice"];

	_choice = _this select 0;
	
	switch _choice do {
		case 1: {
			C_CamOffsetX = 0;
			C_CamOffsetY = 0;
			C_CamZoomX = 3.5;
			C_CamZoomY = 0;
			C_CamDir = 1;
		};
		case 2: {
			C_CamOffsetX = 0;
			C_CamOffsetY = 0;
			C_CamZoomX = -3.5;
			C_CamZoomY = 0;
			C_CamDir = 2;
		};
		case 3: {
			C_CamOffsetX = 0;
			C_CamOffsetY = 0;
			C_CamZoomX = 0;
			C_CamZoomY = -3.5;
			C_CamDir = 3;
		};
		case 4: {
			C_CamOffsetX = 0;
			C_CamOffsetY = 0;
			C_CamZoomX = 0;
			C_CamZoomY = 3.5;
			C_CamDir = 4;
		};
	};
};


C_Preview = {
	liafu = true;
	deleteVehicle C_Preview_Unit;

	C_Preview_Class = C_selectedarray select 1;
	
	C_Preview_Unit = C_Preview_Group createUnit [C_Preview_Class, C_Preview_Pos, [], 0, "CAN_COLLIDE"];
	[C_Preview_Unit] joinSilent C_Preview_Group;
	C_Preview_Unit setVehicleInit format["liafu = true; this setVehicleVarName '%1_%2_C_Dummy'; %1_%2_C_Dummy = this; this disableAI 'move';this disableAI 'anim'; this allowDamage false;", player, round(time)];
	processInitCommands;
	C_Preview_Unit setDir ((getDir C_Preview_Logic));
	C_Preview_Unit setBehaviour "CARELESS";
	C_Preview_Unit setposATL C_Preview_Pos;
	C_Preview_Group setFormDir ((getDir C_Preview_Logic));
	
	["light", C_Preview_Unit, 0.01] execvm "effects.sqf";
	
	[C_Preview_Unit] call player_reset_gear;
	C_Preview_Unit allowDamage false;
	doStop C_Preview_Unit;
	
	C_T_P = [];
	C_T_Change = false;
	
	format["if(player != %1) then { %2 hideObject true; };", player, C_Preview_Unit] call broadcast;
};


C_buy = {
	liafu = true;
	private ["_choice"];

	_choice = _this select 0;
	switch _choice do {
		// buy
		case 1: {
			[C_selectedarray, C_shopnum] spawn C_shop_buy;
		};
		// buy and change
		case 2: {
			if ( C_Preview_Class != (C_selectedarray select 1) ) then { C_T_Change = false; } else { C_T_Change = true;};
			[C_selectedarray, C_shopnum] spawn C_change_shop;
		};
	};
};

C_Switch_Storage = {
	liafu = true;
	private ["_choice"];

	_choice = _this select 0;
	switch _choice do {
		// Nothing
		case 1: { };
		// Change to selected stored skin/clothes
		case 2: {
			if ( C_Preview_Class != (C_selectedarray select 1) ) then { C_T_Change = false; } else { C_T_Change = true;};
			[C_selectedarray, C_shopnum] spawn C_change_storage;
		};
	};
};


C_T_Apply = {
	liafu = true;
	private ["_exit"];

	C_T_SSlot 		= parseNumber (lbData [1502, (lbCurSel 1502)]);
	C_T_SStyle		= lbData [2100, (lbCurSel 2100)];
	C_T_SFormat		= lbData [2101, (lbCurSel 2101)];
	C_T_SWidth		= parseNumber (lbData [2102, (lbCurSel 2102)]);
	C_T_SHeight 	= parseNumber (lbData [2103, (lbCurSel 2103)]);
	C_T_SMap		= parseNumber (lbData [2104, (lbCurSel 2104)]);
	C_T_SCustom		= lbData [2105, (lbCurSel 2105)];

	C_T_C_1			= ctrlText 1400;
	C_T_C_2			= ctrlText 1401;
	C_T_C_3			= ctrlText 1402;
	C_T_C_4			= ctrlText 1403;
	C_T_C_5			= ctrlText 1404;
	
	C_T_C_1	= (parseNumber(C_T_C_1) + 0);
	C_T_C_2	= (parseNumber(C_T_C_2) + 0);
	C_T_C_3	= (parseNumber(C_T_C_3) + 0);
	C_T_C_4	= (parseNumber(C_T_C_4) + 0);
	
	C_Texture = "";
	_exit = false;
	
	if ((C_T_SStyle != "") && (C_T_SStyle != "custom") ) then {
		if ( (C_T_SWidth <= 0) || ((typeName C_T_SWidth) != "SCALAR") ) then {
			player groupchat "C ERROR: Incorrect Width Value";
			_exit = true;
		};
		
		if ( (C_T_SHeight <= 0) || ((typeName C_T_SHeight) != "SCALAR") ) then {
			player groupchat "C ERROR: Incorrect Height Value";
			_exit = true;
		};
			
		if ( (C_T_SMap <= 0) || ((typeName C_T_SMap) != "SCALAR") ) then {
			player groupchat "C ERROR: Incorrect Minimaps Value";
			_exit = true;
		};
	};
	
	if ( _exit ) exitwith {};
	
	switch C_T_SStyle do {
	
		case "color": {
			_exit = false;
		
			if ((C_T_C_1) < 0 ) then { 
				player groupchat "C ERROR: Red must be higher than or equal to 0";
				_exit = true;
			};
			
			if ((C_T_C_1) > 1 ) then { 
				player groupchat "C ERROR: Red must be less than or equal to 1"; 
				_exit = true; 
			};
			
			if ((C_T_C_2) < 0 ) then { 
				player groupchat "C ERROR: Green must be higher than or equal to 0";
				_exit = true; 
			};
			
			if ((C_T_C_2) > 1 ) then { 
				player groupchat "C ERROR: Green must be less than or equal to 1"; 
				_exit = true; 
			};
			
			if ((C_T_C_3) < 0 ) then { 
				player groupchat "C ERROR: Blue must be higher than or equal to 0"; 
				_exit = true; 
			};
			
			if ((C_T_C_3) > 1 ) then { 
				player groupchat "C ERROR: Blue must be less than or equal to 1"; 
				_exit = true; 
			};
			
			if ((C_T_C_4) < 0.5 ) then { 
				player groupchat "C ERROR: Alpha must be higher than or equal to 0.5";
				_exit = true; 
			};
			
			if ((C_T_C_4) > 1 ) then { 
				player groupchat "C ERROR: Alpha must be less than or equal to 1"; 
				_exit = true; 
			};
			
			if ( _exit ) exitwith {};
			
			C_Texture = format['#(%1,%2,%3,%4)color(%5,%6,%7,%8)', C_T_SFormat, C_T_SWidth, C_T_SHeight, C_T_SMap, C_T_C_1, C_T_C_2, C_T_C_3, C_T_C_4];
		};
		
		case "perlinNoise": {
			if ( (C_T_C_1) < 0 ) then { player groupchat "C ERROR: Specular must be higher than or equal to 0"; _exit = true;};
			

			if ( _exit ) exitwith {};
			
			C_Texture = format['#(%1,%2,%3,%4)perlinNoise(%5,%6,%7,%8)', C_T_SFormat, C_T_SWidth, C_T_SHeight, C_T_SMap, C_T_C_1, C_T_C_2, C_T_C_3, C_T_C_4];
		};
		
		case "irradiance": {
			if ( (C_T_C_1) < 0 ) then { player groupchat "C ERROR: Specular must be higher than or equal to 0"; _exit = true;};
			
			if ( _exit ) exitwith {};
			
			C_Texture = format['#(%1,%2,%3,%4)irradiance(%5)', C_T_SFormat, C_T_SWidth, C_T_SHeight, C_T_SMap, C_T_C_1];
		};
		
		case "fresnelGlass": {
			C_Texture = format['#(%1,%2,%3,%4)fresnelGlass()', C_T_SFormat, C_T_SWidth, C_T_SHeight, C_T_SMap];
		};
		
		case "waterIrradiance": {
			if ( (C_T_C_1) < 0 ) then { player groupchat "C ERROR: Specular must be higher than or equal to 0"; _exit = true;};
			
			if ( _exit ) exitwith {};
			
			C_Texture = format['#(%1,%2,%3,%4)waterIrradiance(%5)', C_T_SFormat, C_T_SWidth, C_T_SHeight, C_T_SMap, C_T_C_1];
		};
		
		case "treeCrown": {
			if ( (C_T_C_1) < 0 ) then { player groupchat "C ERROR: Specular must be higher than or equal to 0"; _exit = true;};
			
			if ( _exit ) exitwith {};
			
			C_Texture = format['#(%1,%2,%3,%4)treeCrown(%5)', C_T_SFormat, C_T_SWidth, C_T_SHeight, C_T_SMap, C_T_C_1];
		};
	
		case "custom": {	
			C_Texture = C_T_SCustom;
		};
	};
	
	if (C_Texture != "") then {
		player groupchat "Texture Applied";
		C_Preview_Unit setObjectTexture [C_T_SSlot, C_Texture];
		C_T_P set [C_T_SSlot, C_Texture];
		C_T_Change = true;
	};
};


C_T_R_Slot = {
	liafu = true;
	private ["_c", "_x", "_cfg1", "_cfg2", "_C_T_P"];

	C_T_SSlot 		= parseNumber (lbData [1502, (lbCurSel 1502)]);
	
	_cfg1		= getArray (configFile >> "CfgVehicles" >> C_Preview_Class >> "hiddenselections");
	_cfg2		= getArray (configFile >> "CfgVehicles" >> C_Preview_Class >> "hiddenselectionstextures");
	
	C_Preview_Unit setObjectTexture [C_T_SSlot, _cfg2 select C_T_SSlot];
	
	_C_T_P = C_T_P;
	C_T_P = [];
	
	if ( C_T_Change ) then {
		for [{_c = 0}, {_c < (count _C_T_P) }, {_c=_c+1}] do {
			_x = _C_T_P select _c;
			
			if ( (typeName _x) == "STRING" ) then {
				if ( _c != C_T_SSlot ) then {
					C_T_P set [_c, _x];
				};
			};
		};
	};
};


C_T_R_All = {
	liafu = true;
	private ["_n", "_x", "_cfg1", "_cfg2"];

	_cfg1		= getArray (configFile >> "CfgVehicles" >> P_Preview_Class >> "hiddenselections");
	_cfg2		= getArray (configFile >> "CfgVehicles" >> P_Preview_Class >> "hiddenselectionstextures");
	
	_n = 0;
	{
		P_Preview_Unit setObjectTexture [_n, _x];
		_n = _n + 1;
	} foreach _cfg2;
	
	C_T_P = [];
	C_T_Change = false;
	
	format["if(player != %1) then { %2 hideObject true; };", player, C_Preview_Unit] call broadcast;
};


C_Dialog_Setup = {
	liafu = true;
	private ["_DFML", "_shop", "_shop_change", "_c_1", "_c_2", "_cb_1", "_cb_2", "_index"];

	_DFML = findDisplay 3003;
	
	_shop			= "";
	_shop_change 	= "";
	_c_1			= "";
	_c_2			= "";
	_cb_1			= "";
	_cb_2			= "";
	
	if (C_choice == "store") then {
		_shop			= "Store";
		_shop_change 	= "Storage";
		_c_1			= "Buy";
		_c_2			= "Buy and Change";
		_cb_1			= "[1] call C_buy";
		_cb_2			= "[2] call C_buy";
	};
	
	if (C_choice == "storage") then {
		_shop			= "Storage";
		_shop_change 	= "Store";
		_c_1			= "---";
		_c_2			= "Change";
		_cb_1			= "[1] call C_Switch_Storage";
		_cb_2			= "[2] call C_Switch_Storage";
	};
	
	// Titles Texts
	(_DFML displayCtrl 1000) 		ctrlSetText 		format['Clothes %1', _shop];
	(_DFML displayCtrl 1001) 		ctrlSetText 		format['Camera Control'];
	(_DFML displayCtrl 1002) 		ctrlSetText 		format ['Textures'];
	
	(_DFML displayCtrl 1008) 		ctrlSetText 		format ['Custom Texture'];
	(_DFML displayCtrl 1003) 		ctrlSetText 		format ['Style'];
	(_DFML displayCtrl 1004) 		ctrlSetText 		format ['Format'];
	(_DFML displayCtrl 1005) 		ctrlSetText 		format ['Width'];
	(_DFML displayCtrl 1006) 		ctrlSetText 		format ['Height'];
	(_DFML displayCtrl 1007) 		ctrlSetText 		format ['Minimaps'];
	
	(_DFML displayCtrl 1009) 		ctrlSetText 		format ['Custom 1'];
	(_DFML displayCtrl 1010) 		ctrlSetText 		format ['Custom 2'];
	(_DFML displayCtrl 1011) 		ctrlSetText 		format ['Custom 3'];
	(_DFML displayCtrl 1012) 		ctrlSetText 		format ['Custom 4'];
	(_DFML displayCtrl 1013) 		ctrlSetText 		format ['Custom 5'];
	
	// Button Texts
	(_DFML displayCtrl 1701) 		ctrlSetText 		format ['%1', _c_1];
	(_DFML displayCtrl 1702) 		ctrlSetText 		format ['%1', _c_2];
	(_DFML displayCtrl 1703) 		ctrlSetText 		format ['Cancel - Close'];
	(_DFML displayCtrl 1700) 		ctrlSetText 		format ['Preview'];
	(_DFML displayCtrl 1704) 		ctrlSetText 		format ['Switch to %1', _shop_change];
	
	(_DFML displayCtrl 1706) 		ctrlSetText 		format ['Zoom In'];
	(_DFML displayCtrl 1707) 		ctrlSetText 		format ['Zoom Out'];
	
	(_DFML displayCtrl 1708) 		ctrlSetText 		format ['Camera Front'];
	(_DFML displayCtrl 1709) 		ctrlSetText 		format ['Camera Back'];
	(_DFML displayCtrl 1710) 		ctrlSetText 		format ['Camera Left'];
	(_DFML displayCtrl 1711) 		ctrlSetText 		format ['Camera Right'];
	
	(_DFML displayCtrl 1713) 		ctrlSetText 		format ['Apply Texture'];
	(_DFML displayCtrl 1712) 		ctrlSetText 		format ['Reset Slot'];
	(_DFML displayCtrl 1705) 		ctrlSetText 		format ['Reset All'];
	
	// Button Actions
	(_DFML displayCtrl 1701) 		buttonsetaction 	format ['%1;', _cb_1];
	(_DFML displayCtrl 1702) 		buttonsetaction 	format ['%1;', _cb_2];
	(_DFML displayCtrl 1703) 		buttonsetaction 	format ['closeDialog 0;'];
	(_DFML displayCtrl 1700) 		buttonsetaction 	format ['[] Call C_Preview'];
	(_DFML displayCtrl 1704) 		buttonsetaction 	format ['[] call C_Dialog_Switch'];
	
	(_DFML displayCtrl 1706) 		buttonsetaction 	format ['[1] call C_Preview_Zoom;'];
	(_DFML displayCtrl 1707) 		buttonsetaction 	format ['[2] call C_Preview_Zoom;'];
	
	(_DFML displayCtrl 1708) 		buttonsetaction 	format ['[1] call C_Preview_Camera;'];
	(_DFML displayCtrl 1709) 		buttonsetaction 	format ['[2] call C_Preview_Camera;'];
	(_DFML displayCtrl 1710) 		buttonsetaction 	format ['[3] call C_Preview_Camera;'];
	(_DFML displayCtrl 1711) 		buttonsetaction 	format ['[4] call C_Preview_Camera;'];
	
	(_DFML displayCtrl 1713) 		buttonsetaction 	format ['[] call C_T_Apply'];
	(_DFML displayCtrl 1712) 		buttonsetaction 	format ['[] call C_T_R_Slot'];
	(_DFML displayCtrl 1705) 		buttonsetaction 	format ['[] call C_T_R_All'];

							
	{
		_index	= lbAdd [2100, format["%1", (_x)]];
		lbSetData [2100, _index, _x];
	} foreach C_T_Styles;
								
	{
		_index	= lbAdd [2101, format["%1", (_x)]];
		lbSetData [2101, _index, _x];
	} foreach C_T_Formats;
								
	{
		_index	= lbAdd [2102, format["%1", (_x)]];
		lbSetData [2102, _index, format["%1", (_x)]];
	} foreach C_T_Width;
								
	{
		_index	= lbAdd [2103, format["%1", (_x)]];
		lbSetData [2103, _index, format["%1", (_x)]];
	} foreach C_T_Height;
								
	{
		_index	= lbAdd [2104, format["%1", (_x)]];
		lbSetData [2104, _index, format["%1", (_x)]];
	} foreach C_T_MiniMap;
								
	{
		_index	= lbAdd [2105, format["%1", (_x select 1)]];
		lbSetData [2105, _index, format["%1", (_x select 0)]];
	} foreach C_T_Custom;
};