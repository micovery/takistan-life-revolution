private[
		"_target", "_caller", "_id", "_arg",
		"_injured", "_dragger",
		"_dragWanted", "_t", 
		"_offset", "_dragActionNo", "_currPos", "_pos", "_code",
		"_holster", "_check"
	];

_target = _this select 0;
_caller	= _this select 1;
_id		= _this select 2;
_arg	= _this select 3;

format['DRAGGER %1', _this] call A_FA_DEBUG;

if (!local _caller) exitwith {
		format['DRAGGER EXIT (NON LOCAL)'] call A_FA_DEBUG;
	};

_injured	= cursorTarget;
_dragger 	= _caller;

format['DRAGGER-%1 INJURED-%2', _dragger, _injured] call A_FA_DEBUG;

if (_dragger getVariable ["FA_dragger", false]) exitWith {};

_dragger	setVariable["FA_dragger", true, true];
_dragger	setVariable["FA_dragWanted", true, true];

_injured	setVariable["FA_dragged", true, true];
_injured	setVariable["FA_healEnabled", false, true];

waitUntil {
		((animationState _injured) != "ainjppnemstpsnonwrfldnon_rolltoback")
	};

_holster = [_dragger] call FA_holster;
_check = _dragger spawn (_holster select 1);
waitUntil {scriptDone _check;};

[nil,_injured,rSWITCHMOVE,"ainjppnemstpsnonwrfldb_grab"] call RE;

_offset = [0.12, 0.95, 0];

_injured attachTo [_dragger, _offset];
sleep 0.1;

[nil, _injured, rSETDIR, 180] call RE;

//[nil, _dragger, rPLAYMOVE, "AcinPknlMstpSrasWrflDnon"] call RE;
_dragger playActionNow "grabDrag";
//[nil, _dragger,"loc",rPLAYACTIONNOW,"grabDrag"] call RE;

_t = 5.0;
_currPos = getPos _injured;
_dragWanted = true;

while {_dragWanted} do {	
	
		_dragWanted = _dragger getVariable "FA_dragWanted";
	
		if ( ((lifeState _dragger) == "UNCONSCIOUS") || (!alive _dragger) ) then {
				_dragWanted = false;
			};
		
		if (vehicle _injured != _injured) then {
				_dragWanted = false; 
				_dragger switchAction "playerCrouch";
			};
			
		if (vehicle _dragger != _dragger) then {
				_dragWanted = false;
				if ((if (isNil {_injured getVariable "FA_inAgony"}) then {false} else {(_injured getVariable "FA_inAgony")})) then {
						[nil, _injured,"loc",rPLAYACTIONNOW,"agonyStart"] call RE;
					} else {
						[nil, _injured,"loc",rPLAYACTIONNOW,"agonyStop"] call RE;
					};
			  };	
		
		if (inputAction "MoveForward" != 0) then {
				_dragWanted = false;
			}; 
		
		_t = _t - 0.3;
		_currPos = getPos _injured;
		sleep 0.3;
	};

_dragger setVariable ["FA_dragWanted",false,true];

detach _injured;

_pos = getPosATL _injured;
if (  ((_pos select 2) < 0) || ((_pos select 2) > 0.1)  ) then {
		if (surfaceIsWater _pos || getPosATL _dragger select 2 > 0.1) then {
				_pos set [2, getPosATL _dragger select 2];
			} else {
				_pos set [2, 0];
			};	
		_injured setPosATL _pos;
	};

[nil, _dragger, rPLAYACTION, "released"] call RE;

if (lifeState _injured == "UNCONSCIOUS") then{
		[nil, _injured, rPLAYACTION, "agonyStart"] call RE;
	} else {
		[nil, _injured, rSWITCHMOVE, "ainjppnemstpsnonwrfldb_release"] call RE;
	};
	
Sleep (0.2);

_dragger	setVariable["FA_dragger", false, true];
_dragger	setVariable["FA_dragWanted", false, true];

_injured	setVariable["FA_dragged", false, true];

if (_dragger getVariable "FA_carryWanted") then {
		_injured	setVariable ["FA_healEnabled", false, true];
	} else {
		_injured	setVariable ["FA_healEnabled", true, true];
	};

// Variable stuff
// dont forget carry script change
