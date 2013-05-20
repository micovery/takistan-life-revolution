// GeneralCarver Repel Script
// Deploy Rope Script
// Version: v1, 10/14/09
// Description: This script deploys the rappeling rope from the chopper. It creates a series of flag poles attached to the chopper depending on its class. Safe guards are put it to ensure the chopper is within the limits to deploy the ropes.




// ======================================================================================
// Define Variables
// ======================================================================================

gcrsrepelvehicle = vehicle player;
_playervehclass = typeof gcrspilotvehicle;
_vehiclepos = getpos vehicle player;




// ======================================================================================
// Check is the player's chopper is within the limits for deploying the rope
// ======================================================================================

if (velocity vehicle player select 0 > 5) exitWith
	{
	hint "Unable to deploy rapel ropes. Your vehicle is not stationary.";
	};
	
if (velocity vehicle player select 0 < -5) exitWith
	{
	hint "Unable to deploy rapel ropes. Your vehicle is not stationary.";
	};

if (velocity vehicle player select 1 > 5) exitWith
	{
	hint "Unable to deploy rapel ropes. Your vehicle is not stationary.";
	};
	
if (velocity vehicle player select 1 < -5) exitWith
	{
	hint "Unable to deploy rapel ropes. Your vehicle is not stationary.";
	};
	
if (velocity vehicle player select 2 > 5) exitWith
	{
	hint "Unable to deploy rapel ropes. Your vehicle is not stationary.";
	};

if (velocity vehicle player select 2 < -5) exitWith
	{
	hint "Unable to deploy rapel ropes. Your vehicle is not stationary.";
	};

if (_vehiclepos select 2 > 100) exitWith
	{
	hint "Unable to deploy rapel ropes. Your vehicle is not between 25 and 100 feet altitude above the surface below you.";
	};

if (_vehiclepos select 2 < 25) exitWith
	{
	hint "Unable to deploy rapel ropes. Your vehicle is not between 25 and 100 feet altitude above the surface below you.";
	};
	
liafu = true;
	
	
// ======================================================================================
// Deploy the rope depending on which class the chopper is
// ======================================================================================

if (_playervehclass == "MH6J_EP1") then
	{
	gcrsrope1 = createVehicle ["FlagCarrier", [0,0,0], [], 0, "NONE"];
	gcrsrope1 setFlagTexture "";
	gcrsrope1 attachto [gcrsrepelvehicle,[-1.25,2,-3]];
	gcrsrope2 = createVehicle ["FlagCarrier", [0,0,0], [], 0, "NONE"];
	gcrsrope2 setFlagTexture "";
	gcrsrope2 attachto [gcrsrepelvehicle,[-1.25,2,-10]];
	gcrsrope3 = createVehicle ["FlagCarrier", [0,0,0], [], 0, "NONE"];
	gcrsrope3 setFlagTexture "";
	gcrsrope3 attachto [gcrsrepelvehicle,[-1.25,2,-17]];
	gcrsrope4 = createVehicle ["FlagCarrier", [0,0,0], [], 0, "NONE"];
	gcrsrope4 setFlagTexture "";
	gcrsrope4 attachto [gcrsrepelvehicle,[-1.25,2,-24]];
	gcrsrope5 = createVehicle ["FlagCarrier", [0,0,0], [], 0, "NONE"];
	gcrsrope5 setFlagTexture "";
	gcrsrope5 attachto [gcrsrepelvehicle,[-1.25,2,-31]];
	gcrsrope6 = createVehicle ["FlagCarrier", [0,0,0], [], 0, "NONE"];
	gcrsrope6 setFlagTexture "";
	gcrsrope6 attachto [gcrsrepelvehicle,[-1.25,2,-38]];
	gcrsrope7 = createVehicle ["FlagCarrier", [0,0,0], [], 0, "NONE"];
	gcrsrope7 setFlagTexture "";
	gcrsrope7 attachto [gcrsrepelvehicle,[-1.25,2,-45]];
	gcrsrope8 = createVehicle ["FlagCarrier", [0,0,0], [], 0, "NONE"];
	gcrsrope8 setFlagTexture "";
	gcrsrope8 attachto [gcrsrepelvehicle,[-1.25,2,-52]];
	gcrsrope9 = createVehicle ["FlagCarrier", [0,0,0], [], 0, "NONE"];
	gcrsrope9 setFlagTexture "";
	gcrsrope9 attachto [gcrsrepelvehicle,[-1.25,2,-59]];
	gcrsrope10 = createVehicle ["FlagCarrier", [0,0,0], [], 0, "NONE"];
	gcrsrope10 setFlagTexture "";
	gcrsrope10 attachto [gcrsrepelvehicle,[-1.25,2,-66]];
	gcrsrope11 = createVehicle ["FlagCarrier", [0,0,0], [], 0, "NONE"];
	gcrsrope11 setFlagTexture "";
	gcrsrope11 attachto [gcrsrepelvehicle,[-1.25,2,-73]];
	gcrsrope12 = createVehicle ["FlagCarrier", [0,0,0], [], 0, "NONE"];
	gcrsrope12 setFlagTexture "";
	gcrsrope12 attachto [gcrsrepelvehicle,[-1.25,2,-80]];
	gcrsrope13 = createVehicle ["FlagCarrier", [0,0,0], [], 0, "NONE"];
	gcrsrope13 setFlagTexture "";
	gcrsrope13 attachto [gcrsrepelvehicle,[-1.25,2,-87]];
	gcrsrope14 = createVehicle ["FlagCarrier", [0,0,0], [], 0, "NONE"];
	gcrsrope14 setFlagTexture "";
	gcrsrope14 attachto [gcrsrepelvehicle,[-1.25,2,-94]];
	gcrsrope15 = createVehicle ["FlagCarrier", [0,0,0], [], 0, "NONE"];
	gcrsrope15 setFlagTexture "";
	gcrsrope15 attachto [gcrsrepelvehicle,[-1.25,2,-101]];
	gcrsropedeployed = "true";
	hint "Rapel Rope Deployed";
	};

if (_playervehclass == "UH1H_TK_GUE_EP1") then
	{
	gcrsrope1 = createVehicle ["FlagCarrier", [0,0,0], [], 0, "NONE"];
	gcrsrope1 setFlagTexture "";
	gcrsrope1 attachto [gcrsrepelvehicle,[-1.25,-3,-3]];
	gcrsrope2 = createVehicle ["FlagCarrier", [0,0,0], [], 0, "NONE"];
	gcrsrope2 setFlagTexture "";
	gcrsrope2 attachto [gcrsrepelvehicle,[-1.25,-3,-10]];
	gcrsrope3 = createVehicle ["FlagCarrier", [0,0,0], [], 0, "NONE"];
	gcrsrope3 setFlagTexture "";
	gcrsrope3 attachto [gcrsrepelvehicle,[-1.25,-3,-17]];
	gcrsrope4 = createVehicle ["FlagCarrier", [0,0,0], [], 0, "NONE"];
	gcrsrope4 setFlagTexture "";
	gcrsrope4 attachto [gcrsrepelvehicle,[-1.25,-3,-24]];
	gcrsrope5 = createVehicle ["FlagCarrier", [0,0,0], [], 0, "NONE"];
	gcrsrope5 setFlagTexture "";
	gcrsrope5 attachto [gcrsrepelvehicle,[-1.25,-3,-31]];
	gcrsrope6 = createVehicle ["FlagCarrier", [0,0,0], [], 0, "NONE"];
	gcrsrope6 setFlagTexture "";
	gcrsrope6 attachto [gcrsrepelvehicle,[-1.25,-3,-38]];
	gcrsrope7 = createVehicle ["FlagCarrier", [0,0,0], [], 0, "NONE"];
	gcrsrope7 setFlagTexture "";
	gcrsrope7 attachto [gcrsrepelvehicle,[-1.25,-3,-45]];
	gcrsrope8 = createVehicle ["FlagCarrier", [0,0,0], [], 0, "NONE"];
	gcrsrope8 setFlagTexture "";
	gcrsrope8 attachto [gcrsrepelvehicle,[-1.25,-3,-52]];
	gcrsrope9 = createVehicle ["FlagCarrier", [0,0,0], [], 0, "NONE"];
	gcrsrope9 setFlagTexture "";
	gcrsrope9 attachto [gcrsrepelvehicle,[-1.25,-3,-59]];
	gcrsrope10 = createVehicle ["FlagCarrier", [0,0,0], [], 0, "NONE"];
	gcrsrope10 setFlagTexture "";
	gcrsrope10 attachto [gcrsrepelvehicle,[-1.25,-3,-66]];
	gcrsrope11 = createVehicle ["FlagCarrier", [0,0,0], [], 0, "NONE"];
	gcrsrope11 setFlagTexture "";
	gcrsrope11 attachto [gcrsrepelvehicle,[-1.25,-3,-73]];
	gcrsrope12 = createVehicle ["FlagCarrier", [0,0,0], [], 0, "NONE"];
	gcrsrope12 setFlagTexture "";
	gcrsrope12 attachto [gcrsrepelvehicle,[-1.25,-3,-80]];
	gcrsrope13 = createVehicle ["FlagCarrier", [0,0,0], [], 0, "NONE"];
	gcrsrope13 setFlagTexture "";
	gcrsrope13 attachto [gcrsrepelvehicle,[-1.25,-3,-87]];
	gcrsrope14 = createVehicle ["FlagCarrier", [0,0,0], [], 0, "NONE"];
	gcrsrope14 setFlagTexture "";
	gcrsrope14 attachto [gcrsrepelvehicle,[-1.25,-3,-94]];
	gcrsrope15 = createVehicle ["FlagCarrier", [0,0,0], [], 0, "NONE"];
	gcrsrope15 setFlagTexture "";
	gcrsrope15 attachto [gcrsrepelvehicle,[-1.25,-3,-101]];
	gcrsropedeployed = "true";
	hint "Rapel Rope Deployed";
	};

	
	
	
// ======================================================================================
// Rope is deployed. Add player vehicle to global variable containing list of choppers with rope deployed and publically transmist across network.
// ======================================================================================

gcrsplayerveharray = [vehicle player];
gcrsrapelheloarray = gcrsrapelheloarray + gcrsplayerveharray;
publicvariable "gcrsrapelheloarray";