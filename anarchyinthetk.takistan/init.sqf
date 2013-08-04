#define ExecSQF(FILE) [] call compile preprocessFileLineNumbers FILE
#define ExecSQFwait(FILE) private["_handler"]; _handler = [] spawn (compile (preprocessFileLineNumbers FILE)); waitUntil{scriptDone _handler};

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
		
		[] execFSM "Awesome\Performance\fpsManagerDynamic.fsm";
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

if (isClient) then {
		[0.6] call stats_client_update_loading_progress;
		["Loading - Stage 3/5"] call stats_client_update_loading_title;
	};


// Starts up Awesome scripts
ExecSQF("Awesome\init.sqf");

if(isClient) then {
	[0.8] call stats_client_update_loading_progress;
	["Loading - Stage 4/5"] call stats_client_update_loading_title;
	
	[] execVM "briefing.sqf";
	[] execVM "Awesome\Functions\holster.sqf";
	[] execVM "clientloop.sqf";
	[] spawn gangs_loop;
	[] execVM "respawn.sqf";
	[] execVM "petrolactions.sqf";
	[] execVM "nametags.sqf";
	[] execVM "Awesome\Functions\markers.sqf";
	[] execVM "Awesome\Functions\salary.sqf";
	[] execVM "motd.sqf";
	[] ExecVM "Awesome\MountedSlots\functions.sqf";
	["client"] execVM "bombs.sqf";

	[] execVM "onKeyPress.sqf";
	
	[] ExecVM "Awesome\Functions\camera_functions.sqf";
	[] ExecVM "Awesome\Functions\admin_functions.sqf";
	
	[1] call stats_client_update_loading_progress;
	["Loading - Stage 5/5"] call stats_client_update_loading_title;
	
	[] call stats_client_stop_loading;
	
	[] call music_stop;
};

if (isServer) then {
	[0, 0, 0, ["serverloop"]] execVM "mayorserverloop.sqf";
	[0, 0, 0, ["serverloop"]] execVM "chiefserverloop.sqf";
	[] execVM "targets.sqf";
	[] execVM "druguse.sqf";
	[] execVM "drugreplenish.sqf";
	[] execVM "Awesome\Scripts\hunting.sqf";
	[] execVM "setObjectPitches.sqf";
	
	[] spawn (compile preProcessFileLineNumbers "stationrobloop.sqf");
};