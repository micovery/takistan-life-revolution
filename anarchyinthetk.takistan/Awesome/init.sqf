#define ExecSQF(FILE) [] call compile preprocessFileLineNumbers FILE

ExecSQF("Awesome\Paint\Paint.sqf");
ExecSQF("Awesome\Functions\faction_functions.sqf");
ExecSQF("Awesome\Functions\gear_functions.sqf");

ExecSQF("Awesome\Functions\pos_functions.sqf");
ExecSQF("Awesome\Functions\stun_functions.sqf");

ExecSQF("Awesome\Effects\mortar_effects.sqf");

ExecSQF("Awesome\Scripts\newactions.sqf");

ExecSQF("Awesome\Retributions\functions.sqf");

ExecSQF("Awesome\Functions\armoredsuv_functions.sqf");
ExecSQF("Awesome\Functions\halo_functions.sqf");
ExecSQF("Awesome\Functions\trunk_functions.sqf");
ExecSQF("Awesome\Functions\impound.sqf");
ExecSQF("Awesome\Functions\bankrob.sqf");
ExecSQF("Awesome\Functions\items.sqf");
ExecSQF("Awesome\Functions\doctor_functions.sqf");

ExecSQF("Awesome\R3F\init.sqf");

if (isServer) then {
	[] execFSM "Awesome\Server\vehicle_loop.fsm";
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

EH_handleDamage = compile (preprocessFileLineNumbers "Awesome\EH\EH_handleDamageVeh.sqf");

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
