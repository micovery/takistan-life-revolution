private["_vehicle", "_height", "_playerVehClass"];

_vehicle = (vehicle player);
if ((speed _vehicle) >= 5) exitwith {
		hint "Unable to deploy rapel ropes. Your vehicle is not stationary.";
	};

_height = (getPosATL _vehicle) select 2;
if ((_height > 100) || (_height < 25)) exitwith {
		hint "Unable to deploy rapel ropes. Your vehicle is not between 25 and 100 feet altitude above the surface below you.";
	};

_vehicle removeAction (_vehicle getVariable [A_R_DEPLOYID_V, -1]);
_vehicle setVariable [A_R_DEPLOYID_V, -1, false];
_vehicle setVariable [A_R_DEPLOY_V, true, true];

hint "Rapel Rope Deployed";