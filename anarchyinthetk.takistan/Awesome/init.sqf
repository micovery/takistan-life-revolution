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

//AI
ExecSQF("Awesome\AI\loadouts.sqf");
ExecSQF("Awesome\AI\functions.sqf");

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

A_HALO_VEHICLE = objNull;

pmc_shop_list = [pmccar, pmcair, pmcbox, fortshop2, "pmc_license_journeyman", "pmc_license_defense", "pmc_license_air"];
