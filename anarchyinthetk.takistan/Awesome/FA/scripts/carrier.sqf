private[
		"_target", "_caller", "_id", "_arg",
		"_injured", "_carrier",
		"_carryWanted", 
		"_t", "_carry_offset", "_offset", "_anim", "_array"
	];

_target = _this select 0;
_caller	= _this select 1;
_id		= _this select 2;
_arg	= _this select 3;

if (!local _caller) exitwith {};

_injured = cursorTarget;
_carrier = _caller;

if (_carrier getVariable "FA_carrier") exitWith {};

_carrier	setVariable["FA_dragWanted", false, true];

_carrier	setVariable["FA_carrier", true, true];
_carrier	setVariable["FA_carryWanted", true, true];

_injured	setVariable["FA_carried", true, true];

waitUntil{
		((animationState _carrier) == "amovpknlmstpsraswrfldnon") 
	};

[nil, _injured, rSETDIR, (getDir _carrier + 180)] call RE;	
_injured setPosATL (_carrier modelToWorld [0.08, 0.82, 0]);

[nil,_carrier,rSWITCHMOVE,"AcinPknlMstpSrasWrflDnon_AcinPercMrunSrasWrflDnon"] call RE;
//_carrier playActionNow "grabCarry";
[nil,_injured,rSWITCHMOVE,"AinjPfalMstpSnonWrflDnon_carried_Up"] call RE;

sleep 10;

//	[nil,_injured,rSWITCHMOVE,"AinjPfalMstpSnonWrflDf_carried"] call RE;

_offset = [-0.05,-0.15,-1.2];
_injured attachTo [_carrier, _offset, "RightShoulder"];
[nil, _injured, rSETDIR, 180] call RE;	

sleep 0.1;

waitUntil {(animationState _carrier != "AcinPknlMstpSrasWrflDnon_AcinPercMrunSrasWrflDnon")};

sleep 1;

/*
_offset = [-0.05,-0.15,-1.2];
_injured attachTo [_carrier, _offset, "RightShoulder"];
[nil, _injured, rSETDIR, 180] call RE;
*/

_carryWanted = true;
_t = 12.0;

while {_carryWanted} do {
		
		_carryWanted = _carrier getVariable "FA_carryWanted";	
		
		if ((_carrier getVariable "FA_inAgony") ||	!(alive _carrier)) exitwith  {
				_carrier setVariable ["FA_carryWanted",false,true];
				_carrier playActionNow "agonyStart";
			};	
		
		if (inputAction "MoveBack" != 0) exitwith {}; 
		
		sleep 0.1;	
	};

detach _injured;

if ( (alive _carrier) && !(_carrier getVariable "FA_inAgony") ) then {
		[nil, _carrier,"loc",rSWITCHMOVE,"AcinPercMrunSrasWrflDf_AmovPercMstpSlowWrflDnon"] call RE;
		[nil, _injured,"loc",rSWITCHMOVE,"AinjPfalMstpSnonWrflDnon_carried_Down"] call RE;
	} else {
		[nil, _carrier,"loc",rSWITCHMOVE,"AdthPercMstpSlowWrflDf_carrier"] call RE;
		[nil, _injured,"loc",rSWITCHMOVE,"AinjPfalMstpSnonWrflDf_carried_fall"] call RE;
	};
	
	
	
if ((vehicle _carrier) != _carrier) then {
		if (_injured getVariable ["FA_inAgony", false]) then {
				[nil, _injured,"loc",rSWITCHACTION,"agonyStart"] call RE;
			} else {
				[nil, _injured,"loc",rSWITCHACTION,"agonyStop"] call RE;
			};
	};


_carrier	setVariable["FA_carrier", false, true];
_carrier	setVariable["FA_carryWanted", false, true];

_injured	setVariable["FA_carried", false, true];
_injured	setVariable["FA_healEnabled", true, true];
