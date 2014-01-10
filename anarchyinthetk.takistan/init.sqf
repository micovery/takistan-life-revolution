#define ExecSQF(FILE) [] call compile preprocessFileLineNumbers FILE
#define ExecSQFspawnpass(PASS, FILE) PASS spawn compile preprocessFileLineNumbers FILE
#define ExecSQFspawn(FILE) ExecSQFspawnpass([], FILE)
#define ExecSQFwait(FILE) private["_handler"]; _handler = [] spawn (compile (preprocessFileLineNumbers FILE)); waitUntil{scriptDone _handler};
#define ExecSQFwaitPass(PASS, FILE) private["_handler"]; _handler = PASS spawn (compile (preprocessFileLineNumbers FILE)); waitUntil{scriptDone _handler};
#define SleepWait(timeA) private["_waittt"]; _waittt = time + timeA; waitUntil {time >= _waittt};

ALL_LOADING_DONE = false;
enableSaving [false, false];

isClient = !isServer || (isServer && !isDedicated);

ExecSQFwait("Awesome\BIS\init.sqf")

sleep 0.5;

ExecSQF("Awesome\Functions\debug.sqf");
ExecSQF("Awesome\Functions\restart.sqf");
ExecSQF("Awesome\Functions\encodingfunctions.sqf");
ExecSQF("Awesome\Functions\music.sqf");
ExecSQF("Awesome\MyStats\persist.sqf");
ExecSQF("Awesome\Functions\time_functions.sqf");
ExecSQF("Awesome\Scripts\white_black_list.sqf");
ExecSQF("Awesome\Functions\player_functions.sqf");
ExecSQF("Awesome\Rappel\init.sqf");
ExecSQF("Awesome\MyStats\functions.sqf");

ExecSQF("Awesome\Functions\server_functions.sqf");
ExecSQF("Awesome\Functions\list_functions.sqf");
ExecSQF("Awesome\Functions\vehicle_storage_functions.sqf");

if (isClient) then {
		[] call stats_client_start_loading;
		["Loading - Stage 1/5"] call stats_client_update_loading_title;
		[0] call stats_client_update_loading_progress;
		
//		[] execFSM "Awesome\Performance\fpsManagerDynamic.fsm";
//		[] execFSM "Awesome\Client\afkCheck.fsm";
	};

WEST setFriend [EAST, 0];
WEST setFriend [RESISTANCE, 0];
EAST setFriend [WEST, 0];
EAST setFriend [RESISTANCE, 0];
RESISTANCE setFriend [EAST, 0];
RESISTANCE setFriend [WEST, 0];
CIVILIAN setFriend [WEST, 0];
CIVILIAN setFriend [EAST, 0];
CIVILIAN setFriend [RESISTANCE, 0];

ExecSQF("Awesome\Scripts\optimize_1.sqf");

["init"] execVM "bombs.sqf";
if (isServer) then {
		["server"] execVM "bombs.sqf";
	};

ExecSQF("Awesome\Functions\interaction.sqf");
ExecSQF("triggers.sqf");

if (isClient) then {
		[0.2] call stats_client_update_loading_progress;
		["Loading - Stage 2/5"] call stats_client_update_loading_title;
	};

ExecSQF("broadcast.sqf");
ExecSQF("customfunctions.sqf");
ExecSQF("strfuncs.sqf");
ExecSQF("1007210.sqf");
ExecSQF("4422894.sqf");
ExecSQF("miscfunctions.sqf");
ExecSQF("Awesome\Functions\quicksort.sqf");
ExecSQF("INVvars.sqf");
ExecSQF("Awesome\Shops\functions.sqf");
ExecSQF("Awesome\Functions\bankfunctions.sqf");
ExecSQF("bankvariables.sqf");
ExecSQF("execlotto.sqf");
ExecSQF("initWPmissions.sqf");
ExecSQF("gfx.sqf");
ExecSQF("animList.sqf");
ExecSQF("variables.sqf");
ExecSQF("Awesome\Functions\money_functions.sqf");
ExecSQF("Awesome\Functions\gang_functions.sqf");
ExecSQF("Awesome\Functions\convoy_functions.sqf");
ExecSQF("Awesome\Functions\factory_functions.sqf");
ExecSQF("setPitchBank.sqf");

format['LOADING 3/5 - Part 1'] call A_DEBUG_S;
if (isClient) then {
		[0.6] call stats_client_update_loading_progress;
		["Loading - Stage 3/5"] call stats_client_update_loading_title;
	};
format['LOADING 3/5 - Part 2'] call A_DEBUG_S;

// Starts up Awesome scripts
ExecSQF("Awesome\init.sqf");

format['LOADING 3/5 - Part 3'] call A_DEBUG_S;

if(isClient) then {
	[0.8] call stats_client_update_loading_progress;
	["Loading - Stage 4/5"] call stats_client_update_loading_title;
	
	format['LOADING 4/5 - Part 1'] call A_DEBUG_S;
	ExecSQFspawn("briefing.sqf");
	
	format['LOADING 4/5 - Part 2'] call A_DEBUG_S;
	ExecSQFwait("Awesome\Functions\camera_functions.sqf")
	format['LOADING 4/5 - Part 3'] call A_DEBUG_S;
	ExecSQFwait("Awesome\Functions\admin_functions.sqf")
	format['LOADING 4/5 - Part 4'] call A_DEBUG_S;
	ExecSQFwait("Awesome\Functions\markers.sqf");
	format['LOADING 4/5 - Part 5'] call A_DEBUG_S;
	ExecSQFwait("Awesome\Functions\holster.sqf");
	format['LOADING 4/5 - Part 6'] call A_DEBUG_S;
	ExecSQFwait("Awesome\MountedSlots\functions.sqf");
	
	format['LOADING 4/5 - Part 7'] call A_DEBUG_S;
	ExecSQFspawn("clientloop.sqf");
	format['LOADING 4/5 - Part 8'] call A_DEBUG_S;
	[] spawn gangs_loop;
	format['LOADING 4/5 - Part 9'] call A_DEBUG_S;
	ExecSQFspawn("respawn.sqf");
	format['LOADING 4/5 - Part 10'] call A_DEBUG_S;
	ExecSQFspawn("petrolactions.sqf");
	format['LOADING 4/5 - Part 11'] call A_DEBUG_S;
	ExecSQFspawn("nametags.sqf");
	format['LOADING 4/5 - Part 12'] call A_DEBUG_S;
	ExecSQFspawn("Awesome\Functions\salary.sqf");
	format['LOADING 4/5 - Part 13'] call A_DEBUG_S;
	ExecSQFspawn("motd.sqf");
	format['LOADING 4/5 - Part 14'] call A_DEBUG_S;
	ExecSQFspawnpass(["client"], "bombs.sqf");
	
	format['LOADING 4/5 - Part 15'] call A_DEBUG_S;
	ExecSQFwait("onKeyPress.sqf")
	
	format['LOADING 4/5 - Part 16'] call A_DEBUG_S;
	
	[1] call stats_client_update_loading_progress;
	["Loading - Stage 5/5"] call stats_client_update_loading_title;
	
	format['LOADING 5/5'] call A_DEBUG_S;
	
	[] call stats_client_stop_loading;
	
	[] call music_stop;
	
	SleepWait(30)
	[] spawn ftf_init;
	
};

ALL_LOADING_DONE = true;

if (isServer) then {
	[0,0,0,["serverloop"]] spawn compile preprocessfilelineNumbers "mayorserverloop.sqf";
	[0,0,0,["serverloop"]] spawn compile preprocessfilelineNumbers "chiefserverloop.sqf";

	ExecSQFspawn("targets.sqf");
	ExecSQFspawn("druguse.sqf");
	ExecSQFspawn("drugreplenish.sqf");
	ExecSQFspawn("Awesome\Scripts\hunting.sqf");
	ExecSQFspawn("setObjectPitches.sqf");
	ExecSQFspawn("stationrobloop.sqf");
};