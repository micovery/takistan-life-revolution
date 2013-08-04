private[
		"_unit", "_agonyHandle", "_corpse"
	];

// A_fnc_FA_init
/*
FA_healer
FA_healEnabled

FA_dragger
FA_carrier

FA_dragWanted
FA_carryWanted

FA_dragged
FA_carried

FA_inAgony
FA_agonyDam

""
"head_hit"
"body"
"hands"
"legs"
"bloodloss" 
"bloodlossPerSecond"

FA_animHandlerStarted

FA_isDead

FA_healPlace0who
FA_healPlace1who
FA_healPlace0whoLast
FA_healPlace1whoLast
FA_healPlace0LastTime
FA_healPlace1LastTime

*/

#define SleepWait(timeA) private["_waittt"]; _waittt = time + timeA; waitUntil {time >= _waittt};

_unit = _this select 0;
_corpse = if ((count _this) > 1)then{_this select 1}else{objNull};

if (true) exitwith {
				if (local _unit) then {
						[_unit] call A_fnc_EH_init;
					};
			};

if ((count _this) > 1) then {
		if (local (_this select 1)) then {
				(_this select 1) removeAllEventHandlers "fired";
				(_this select 1) removeAllEventHandlers "handleDamage";
				(_this select 1) removeAllEventHandlers "WeaponAssembled";
				(_this select 1) removeAllMPEventHandlers "MPkilled"; 
				(_this select 1) removeAllMPEventHandlers "MPRespawn";
			};
	};

if (local  _unit) then {

		//_unit is first-aiding somebody 
		_unit setVariable ["FA_healer",false, true];
				
		//option to heal - gives action, prevents fast healer.sqf reexecute (see end of healer.sqf)
		_unit setVariable ["FA_healEnabled",true,true];

		//_unit is dragging somebody
		_unit setVariable ["FA_dragger",false,true]; 
					
		//_unit is carrying somebody
		_unit setVariable ["FA_carrier",false,true];
					
		//if _unit is dragger dragWanted controls drag loop
		_unit setVariable ["FA_dragWanted",false,true];
					
		//if _unit is dragger dragWanted controls drag loop
		_unit setVariable ["FA_carryWanted",false,true];
				
		_unit setVariable ["FA_dragged",false,true];
		_unit setVariable ["FA_carried",false,true];
				
		//Injury system initialization
		//handled separately 
		//variables accumulating damage
		//blood loss in liters, 3+ is fatal
		//empty name variable works - accumulates structural dammage
		_unit setVariable ["",0,true];
		_unit setVariable ["head_hit",0,true]; 
		_unit setVariable ["body",0,true];
		_unit setVariable ["hands",0,true];
		_unit setVariable ["legs",0,true];
		_unit setVariable ["bloodloss",0,true]; 
		_unit setVariable ["bloodlossPerSecond",0,true];

		//_unit will be in agony if it has damage of FA_agonyDam or more
		_unit setVariable ["FA_agonyDam", FA_agonyDam,true]; 
				
		//not in agony at start
		_unit setVariable ["FA_inAgony",false,true]; 
				
		_unit setVariable["FA_animHandlerStarted", nil,true];
				
		_unit setVariable["FA_isDead", false,true];
		
		_unit setVariable["FA_healPlace0who", objNull,true];
		_unit setVariable["FA_healPlace1who", objNull,true];
		_unit setVariable["FA_healPlace0whoLast", objNull,true];
		_unit setVariable["FA_healPlace1whoLast", objNull,true];
		_unit setVariable["FA_healPlace0LastTime", 0,true];
		_unit setVariable["FA_healPlace1LastTime", 0,true];
		
		if (isNil {_unit getVariable ["FA_agonyHandle",nil]}) then {
				_agonyHandle = [_unit] execFSM FA_FSM_P + "agony.fsm";
				_unit setVariable ["FA_agonyHandle", _agonyHandle, false]; 
			};
		format['AH - %1', (_unit getVariable ["FA_agonyHandle",0])] call A_FA_DEBUG;
		(_unit getVariable ["FA_agonyHandle",0]) setFSMvariable ["who", _unit];
		
		_unit removeAllEventHandlers "handleDamage";
	//	_unit addEventHandler ["handleDamage",	{_this execFSM FA_hDamage; 0}];
		_unit addEventHandler ["handleDamage",	{_this spawn FA_hDamage; 0}];

	//	[_unit] call FA_actions;
		
		
		[nil,nil,rSPAWN, [_unit], {
				format["ADDING HH - %1-%2", _this, _this select 0] call A_FA_DEBUG;
				(_this select 0) removeAllEventHandlers "handleHeal";
				(_this select 0) addEventHandler ["handleHeal", {_this spawn FA_hHeal;}];
			}] call RE;
			
		FA_COMPLETE = true;
		
	}else{
		format["ADDING HH - %1-%2 non local", _this, _this select 0] call A_FA_DEBUG;
		_unit removeAllEventHandlers "handleHeal";
		_unit addEventHandler ["handleHeal", {_this spawn FA_hHeal;}];
	};
	

