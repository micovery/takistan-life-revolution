INV_MAX_ITEMS           = 1000000;
INV_MAX_DROPS	 		= 300;
INV_shortcuts           = true;

#define ExecSQF(FILE) [] call compile preprocessFileLineNumbers FILE

ExecSQF("createfunctions.sqf");
ExecSQF("carparks.sqf");
ExecSQF("masterarray.sqf");
ExecSQF("Awesome\Scripts\optimize_2.sqf");
ExecSQF("Awesome\Scripts\shops.sqf");
ExecSQF("facharvest.sqf");
ExecSQF("licensearray.sqf");

if (isClient) then {
	[] execVM "shopfarmfaclicenseactions.sqf";
};