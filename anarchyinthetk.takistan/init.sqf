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

ExecSQF("Awesome\Functions\debug.sqf");
ExecSQF("Awesome\Functions\uid_lists.sqf");
ExecSQF("Awesome\Functions\encodingfunctions.sqf");
ExecSQF("Awesome\Functions\music.sqf");
ExecSQF("Awesome\MyStats\persist.sqf");
ExecSQF("Awesome\Functions\time_functions.sqf");
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

["init"] spawn A_SCRIPT_BOMBS;
ExecSQF("Awesome\Functions\interaction.sqf");
ExecSQF("triggers.sqf");

if (isClient) then {
		[0.2] call stats_client_update_loading_progress;
		["Loading - Stage 2/5"] call stats_client_update_loading_title;
	};

ExecSQF("customfunctions.sqf");
ExecSQF("strfuncs.sqf");
ExecSQF("1007210.sqf");
ExecSQF("4422894.sqf");
ExecSQF("miscfunctions.sqf");
ExecSQF("Awesome\Functions\quicksort.sqf");
ExecSQF("INVvars.sqf");
ExecSQF("Awesome\Shops\functions.sqf");
ExecSQF("Awesome\Functions\bankfunctions.sqf");
ExecSQFwait("bankvariables.sqf");
ExecSQF("execlotto.sqf");
ExecSQF("initWPmissions.sqf");
ExecSQF("gfx.sqf");
ExecSQF("animList.sqf");
ExecSQF("variables.sqf");
ExecSQF("Awesome\Functions\money_functions.sqf");
ExecSQF("Awesome\Functions\gang_functions.sqf");
ExecSQF("Awesome\Functions\convoy_functions.sqf");
ExecSQF("Awesome\Functions\factory_functions.sqf");
ExecSQFwait("Awesome\MountedSlots\functions.sqf");

if (isClient) then {
		[0.6] call stats_client_update_loading_progress;
		["Loading - Stage 3/5"] call stats_client_update_loading_title;
	};

// Starts up Awesome scripts
ExecSQF("Awesome\init.sqf");


// initializes Fixes
ExecSQF("Fixes\init.sqf");

if(isClient) then {
	[0.8] call stats_client_update_loading_progress;
	["Loading - Stage 4/5"] call stats_client_update_loading_title;
	
	ExecSQFspawn("briefing.sqf");
	
	ExecSQFwait("Awesome\Functions\camera_functions.sqf")
	ExecSQFwait("Awesome\Functions\admin_functions.sqf")
	ExecSQFwait("Awesome\Functions\markers.sqf");
	ExecSQFwait("Awesome\Functions\holster.sqf");
	ExecSQFspawn("clientloop.sqf");
	[] spawn gangs_loop;
	ExecSQFspawn("respawn.sqf");
	ExecSQFspawn("petrolactions.sqf");
	ExecSQFspawn("nametags.sqf");
	ExecSQFspawn("Awesome\Functions\salary.sqf");
	ExecSQFspawn("motd.sqf");
	ExecSQFspawnpass(["client"], "bombs.sqf");
	
	ExecSQFwait("onKeyPress.sqf")
	
	[1] call stats_client_update_loading_progress;
	["Loading - Stage 5/5"] call stats_client_update_loading_title;
	
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
	ExecSQFspawn("stationrobloop.sqf");
};