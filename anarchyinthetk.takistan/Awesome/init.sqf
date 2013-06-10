_h = [] execVM "Awesome\Paint\Paint.sqf";
waitUntil {scriptDone _h};
[] spawn P_init;

sleep 1;

[] execVM "Awesome\Functions\faction_functions.sqf";
[] execVM "Awesome\Functions\gear_functions.sqf";
[] execVM "Awesome\Functions\pos_functions.sqf";
[] execVM "Awesome\Functions\stun_functions.sqf";

[] execVM "Awesome\Effects\mortar_effects.sqf";

[] execVM "Awesome\R3F\init.sqf";

_h = [] execVM "Awesome\Scripts\white_black_list.sqf";
waitUntil {scriptDone _h};

_h = [] execVM "Awesome\Scripts\newactions.sqf"; 
waitUntil{scriptDone _h};

_h = [] execVM "Awesome\Retributions\functions.sqf"; 
waitUntil{scriptDone _h};

_h = [] execVM "Awesome\Functions\armoredsuv_functions.sqf"; 
waitUntil{scriptDone _h};

_h = [] execVM "Awesome\Functions\halo_functions.sqf"; 
waitUntil{scriptDone _h};

_h = [] execVM "Awesome\Functions\trunk_functions.sqf"; 
waitUntil{scriptDone _h};


if (isServer) then {
	[] execVM "Awesome\Server\Server_Loop.sqf";
	[] spawn A_WBL_F_INIT_S;
};


if(isClient) then {
	[] execVM "Awesome\Scripts\communications.sqf";
	[] execVM "Awesome\Client\client_loop.sqf";
	[] execVM "Awesome\Scripts\speedgun.sqf";
	[] spawn A_WBL_F_INIT_C;
};
	

enableEngineArtillery false;

[player, "isstunned", false] call player_set_bool;

ins_area_1 setTriggerActivation ["VEHICLE", "PRESENT", true];
opfor_area_1 setTriggerActivation ["VEHICLE", "PRESENT", true];
blufor_area_1 setTriggerActivation ["VEHICLE", "PRESENT", true];
Jail setTriggerActivation ["VEHICLE", "PRESENT", true];

ins_area_1 setTriggerStatements ["this", "", ""];
opfor_area_1 setTriggerStatements ["this", "", ""];
blufor_area_1 setTriggerStatements ["this", "", ""];
Jail setTriggerStatements ["this", "", ""];


A_DYNO_OM	= compile (preprocessfilelinenumbers "ca\modules\dyno\data\scripts\objectMapper.sqf");
A_DYNO_OG	= compile (preprocessfilelinenumbers "ca\modules\dyno\data\scripts\objectGrabber.sqf");

respawnButtonPressed = false;

A_HALO_VEHICLE = objNull;

M_smoke = "SmokeShell";

//	SmokeShell
//	SmokeShellBlue
//	SmokeShellGreen
//	SmokeShellOrange
//	SmokeShellPurple
//	SmokeShellRed
//	SmokeShellYellow

//	G_40mm_Smoke
//	G_40mm_SmokeGreen
//	G_40mm_SmokeRed
//	G_40mm_SmokeYellow

M_flare = "F_40mm_Yellow";

//F_40mm_Green
//F_40mm_Red
//F_40mm_White
//F_40mm_Yellow

	M_ill_style = "highest";
//	M_ill_style = "timed";
//		M_ill_delay = 10;
//	M_ill_style = "height";
//		M_ill_height = 100;	

//	M_ill_lit = "F";
//	M_ill_lit = "T";
//		M_ill_time = 60;
//	M_ill_lit = "G";
//		M_ill_decent = 0.0075;
M_ill_lit = "TG";
M_ill_time = 60;
M_ill_decent = 0.0075;

pmc_shop_list = [pmccar, pmcair, pmcbox, fortshop2, "pmc_license_journeyman", "pmc_license_defense", "pmc_license_air"];

pmc_skin_list = [];

{
	_array = [_x] call C_array_d;
	pmc_skin_list set[(count pmc_skin_list), (_array select 1)];
} forEach CSL_PMC_1;




