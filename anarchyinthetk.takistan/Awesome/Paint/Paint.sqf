P_init =
{
private ["_h", "_n"];

	_h = [] execVM "Awesome\Paint\P_dialog_functions.sqf";
	waituntil {scriptDone _h};



	P_T_Styles =
	[
		"color",
		"perlinNoise",
		"irradiance",
		"fresnelGlass",
		"waterIrradiance",
		"treeCrown",
		"custom"
	];

	P_T_Formats =
	[
		"RGB",
		"ARGB",
		"AI"
	];
	
	P_T_Custom =
	[
		["#(ARGB,8,8,3)color(1,0,0,0.5)", "Red"],
		["#(ARGB,8,8,3)color(0,1,0,0.5)", "Green"],
		["#(ARGB,8,8,3)color(0,0,1,0.5)", "Blue"],
		["#(ARGB,8,8,3)color(1,1,1,1)", "White"],
		["#(ARGB,8,8,3)color(0,0,0,0.5)", "Black"]
	];
	
	P_T_Width = [];
	P_T_Height = [];
	P_T_MiniMap = [];

	_n = count P_T_Width;
	for [{_c = 1}, {_c <= 128}, {_c=_c * 2}] do
	{
		P_T_Width set [_n, _c];
		_n = _n + 1;
	};

	_n = count P_T_Height;
	for [{_c = 1}, {_c <= 128}, {_c=_c * 2}] do
	{
		
		P_T_Height set [_n, _c];
		_n = _n + 1;
	};

	_n = count P_T_MiniMap;
	for [{_c = 1}, {_c <= 8}, {_c=_c+1}] do
	{
		P_T_MiniMap set [_n, _c];
		_n = _n + 1;
	};

	P_T_P = [];


	P_texts =
	[
		0,
		1,
		2,
		3,
		4
	];
	
	
	Paint_Shops =
	[
		// Shop spawn, flag1, flag2
		[ps_1_s, ps_1_flag1],
		[ps_2_s, ps_2_flag1],
		[ps_3_s, ps_3_flag1],
		[ps_4_s, ps_4_flag1],
		[ps_5_s, ps_5_flag1],
		[ps_6_s, ps_6_flag1]
	];
	
	P_cost = 25000;
	
};


[] spawn P_init;