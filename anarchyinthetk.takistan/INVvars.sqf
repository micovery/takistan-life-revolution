INV_MAX_ITEMS           = 1000000;
INV_MAX_DROPS	 		= 300;
INV_shortcuts           = true;
INV_SperrenVerbotArray  = [[copbase1, 250],[mosqueprop, 120], [banklogic, 35], [pmcprop, 70], [tairspawn, 150], [asairspawn, 30], [afacspawn, 30], [airfacspawn, 30], [insvehspawn, 80],[redhelispawn, 100],[CopPrisonAusgang, 20]];

#define ExecSQF(FILE) [] call compile preprocessFileLineNumbers FILE

ExecSQF("INVfunctions.sqf");
ExecSQF("createfunctions.sqf");
ExecSQF("carparks.sqf");
ExecSQF("masterarray.sqf");
ExecSQF("Awesome\Scripts\optimize_2.sqf");
ExecSQF("Awesome\Scripts\shops.sqf");
ExecSQF("facharvest.sqf");
ExecSQF("licensearray.sqf");

if (isClient) then {
	_handler = [] execVM "shopfarmfaclicenseactions.sqf";
};