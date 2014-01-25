scriptName "Weather\data\scripts\main.sqf";
/*
	File: main.sqf
	Author: Karel Moricky

	Description:
	Init script - Environment Effects

	Parameter(s):
	_this: Weather logic unit which triggered this script.
*/
private["_logic", "_logicFnc", "_debug", "_intensity", "_delay", "_particleEffects", "_center"];
_logic = _this select 0;
_logic setpos [1,1,1];

//--- Execute Functions
if (isnil "bis_fnc_init") then {
	_logicFnc = (group _logic) createunit ["FunctionsManager",position player,[],0,"none"];
};
waituntil {!isnil "BIS_fnc_init"};	//--- Wait for functions

///////////////////////////////////////////////////////////////////////////////////
///// Custom params
///////////////////////////////////////////////////////////////////////////////////
//--- Debug
_debug = if (isnil {_logic getvariable "debug"}) then {false} else {true};
_logic setvariable ["debug",_debug,true];

//--- Intensity
_intensity = if (isnil {_logic getvariable "intensity"}) then {0.8} else {_logic getvariable "intensity";};
_logic setvariable ["intensity",_intensity,true];

//--- Delay
_delay = if (isnil {_logic getvariable "delay"}) then {1} else {_logic getvariable "delay";};
_logic setvariable ["delay",_delay,true];

//--- Particle Effects
_particleEffects = if (isnil {_logic getvariable "particleEffects"}) then {[0,1,2,3]} else {_logic getvariable "particleEffects";};
_logic setvariable ["particleEffects",_particleEffects,true];

//--- Center
_center = _logic getvariable ["center", objnull];
_logic setvariable ["center",_center,true];

///////////////////////////////////////////////////////////////////////////////////
///// Execute
///////////////////////////////////////////////////////////////////////////////////
[nil, nil, "per", rEXECFSM, "Awesome\BIS\Weather\postprocess.fsm", _logic] call RE;
[nil, nil, "per", rEXECFSM, "Awesome\BIS\Weather\particle.fsm", _logic] call RE;