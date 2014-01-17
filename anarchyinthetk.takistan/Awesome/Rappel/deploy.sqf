private["_vehicle", "_height", "_playerVehClass"];

_vehicle = (vehicle player);
if ((speed _vehicle) >= 5) exitwith {
		hint "Unable to deploy rapel ropes. Your vehicle is not stationary.";
	};

_height = (getPosATL _vehicle) select 2;
if ((_height > 100) || (_height < 25)) exitwith {
		hint "Unable to deploy rapel ropes. Your vehicle is not between 25 and 100 feet altitude above the surface below you.";
	};
	
_playervehclass = toUpper(typeof _vehicle);

private["_flagclass","_flagPos","_flagtexture"];
_flagClass = "FlagCarrier";
_flagPos = [0,0,0];
_flagTexture = "";

private["_attachX","_attachY","_attachZB","_attachZM","_attachZA"];
_attachX = 0;
_attachY = 0;
_attachZB = -3;
_attachZM = -101;
_attachZA = -7;

_attachY = switch _playervehclass do {
		case "MH6J_EP1": {
				2
				
			};
		case "UH1H_TK_GUE_EP1": {
				-3
			};
		default {0};
	};

private["_i","_stringVariable","_flag","_attach","_Z"];
for [{_i = 0}, {_i <= 15}, {_i = _i + 1}] do {
		_stringVariable = format["A_R_rope%1", _i];
		
		_flag = createVehicle [_flagClass, _flagPos, [], 0, "NONE"];
		_flag setFlagTexture _flagTexture;
		
		_attach = [_attachX, _attachY, _attachZB];
		for [{_Z = _attachZB}, {_Z >= _attachZM}, {_Z = _Z + _attachZA}] do {
				_attach set [2, _Z];
				_flag attachTo [_vehicle, _attach];
			};
			
		missionNamespace setVariable [_stringVariable, _flag];
	};

_vehicle removeAction (_vehicle getVariable [A_R_DEPLOYID_V, -1]);
_vehicle setVariable [A_R_DEPLOYID_V, -1, false];
_vehicle setVariable [A_R_DEPLOY_V, true, true];

hint "Rapel Rope Deployed";