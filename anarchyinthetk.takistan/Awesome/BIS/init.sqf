#define ExecSQF(FILE) [] call compile preprocessFileLineNumbers FILE;
#define SpawnExecSQF(PASS, FILE) PASS spawn compile preprocessFileLineNumbers FILE;
#define SpawnSQF(FILE) SpawnExecSQF([], FILE)
#define ExecSQFwait(FILE) private["_handler"]; _handler = [] spawn (compile (preprocessFileLineNumbers FILE)); waitUntil{scriptDone _handler};

/* 
	BIS module setup
		Functions
		Clouds
		Environment - Effects
		Environment - Colors
*/


BIS_WeatherParticles_logic 		= A_BIS_LOGIC;
BIS_WeatherPostprocess_logic 	= A_BIS_LOGIC;
BIS_functions_mainscope			= A_BIS_LOGIC;


BIS_fnc_init = false;
ExecSQF("\ca\Modules\MP\data\scripts\MPframework.sqf")


if (isServer) then {
//		SpawnExecSQF([A_BIS_LOGIC], "ca\modules\functions\main.sqf")
		[] spawn {
				waituntil {!isnil "BIS_MPF_InitDone"};
				[nil, nil, "per", rEXECVM,"ca\Modules\Functions\init.sqf"] call RE;
			};
		SpawnExecSQF([A_BIS_LOGIC], "Awesome\BIS\weather\main.sqf")
	}else{
		[] exec "Awesome\BIS\clouds\system.sqs";
	};		  
