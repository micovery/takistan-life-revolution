private[
		"_injured","_healer", "_frequency",
		"_healingEfficiency","_healerIsMedic","_waituntilT",
		"_deltaT","_waitStartT", "_handle", "_healerIsAlreadyDragger", 
		"_healerIsAlreadyHealer",
		"_PERIOD", "_injuredWasAgony", "_healingEfficiency",
		"_secondsToHeal", "_chanceOfMisheal", 
		"_healPlaceString", "_healPlace", "_injuredPosOrig", "_posh", "_posi",
		"_dy", "_dx", "_healQuant", "_healerAgonized",
		"_holster", "_check"
	];

format['HEALER SCRIPT THIS-%1', _this] call A_FA_DEBUG;
	
_injured = _this select 0;
_healer = _this select 1;
_healerIsMedic = _this select 2;


if (isNil "_injured") exitWith {
		format['HEALER SCRIPT EXIT INJURED NIL -%1', _injured] call A_FA_DEBUG;
	};
if (isNull _injured) exitWith {
		format['HEALER SCRIPT EXIT INJURED NULL -%1', _injured] call A_FA_DEBUG;
	};
if (isNil "_healer") exitWith {
		format['HEALER SCRIPT EXIT INJURED NIL -%1', _healer] call A_FA_DEBUG;
	};
if (isNull _healer) exitWith {
		format['HEALER SCRIPT EXIT INJURED NULL -%1', _healer] call A_FA_DEBUG;
	};

if (
		false
		||(_injured getVariable ["FA_dragger",false])
		||(_injured getVariable ["FA_carrier",false])
		||(_injured getVariable ["FA_dragWanted",false])
		||(_injured getVariable ["FA_carryWanted",false])
		||(_injured getVariable ["FA_dragged",false])
		||(_injured getVariable ["FA_carried",false])
		||(_healer getVariable ["FA_dragger",false])
		||(_healer getVariable ["FA_carrier",false])
		||(_healer getVariable ["FA_dragWanted",false])
		||(_healer getVariable ["FA_carryWanted",false])
		||(_healer getVariable ["FA_dragged",false])
		||(_healer getVariable ["FA_carried",false])
	) exitwith {
		format['FA_HEALER_ EXIT DRAGGER-CARRIER VARIABLES'] call A_FA_DEBUG;
	};

_injuredWasAgony	= _injured getVariable ["FA_inAgony", false];

if (isNil {_healer getVariable ["FA_animHandlerStarted", nil]}) then	{
		_handle = (_healer addEventHandler ["animStateChanged", "_this execFSM FA_FSM_P + 'animHandler.fsm'"]);
		_healer setVariable ["FA_animHandlerStarted", _handle];
	};

_healerIsAlreadyDragger = _healer getVariable ["FA_dragger", false];

if (_healerIsAlreadyDragger) then {
		_healer setVariable ["FA_dragWanted",false,true];  
		WaitUntil {!(_healer getVariable ["FA_dragger",false])};
	}; 
 
if (_healer getVariable ["FA_inAgony", false]) exitWith {
		format['FA_HEALER_ EXIT healer in FA_inAgony %1',[_injured, _healer]] call A_FA_DEBUG;
	};

_healerIsAlreadyHealer 	= _healer getVariable ["FA_healer", false];
if (_healerIsAlreadyHealer) exitWith {
		format['FA_HEALER_ EXIT _healerIsAlreadyHealer %1', [_injured, _healer]] call A_FA_DEBUG;
	};

if !(_healer getVariable ["FA_healEnabled",true]) exitWith{
		format['HEALER EXIT - HEALER FA_healEnabled FALSE'] call A_FA_DEBUG;
	};

if !(_injured getVariable ["FA_healEnabled",true]) exitWith{
		format['HEALER EXIT - INJURED FA_healEnabled FALSE'] call A_FA_DEBUG;
	};
	
_healer setVariable ["FA_healer",true,true];


if (_healer == _injured) exitWith {
		if (_healerIsMedic) then {
				//medic selfheal (medic is not in agony)
				_healer playActionNow "medicStart";
      
				//twice! - first stops bleeding, second heals completely      
				[_healer, _injured, "loc", rEXECFSM, FA_hDamage, _injured,"healMedic",10000] call RE;
				[_healer, _injured, "loc", rEXECFSM, FA_hDamage, _injured,"healMedic",10000] call RE;
				
				//synchronization: wait for quantum to reach _injured (execution of damaging.fsm with heal)
				waitUntil {(damage _injured) <= 0}; //medic 
				if (!isNil {_injured getVariable "head_hit"}) then {waitUntil {((_injured getVariable "head_hit") <= 0)};};
				if (!isNil {_injured getVariable "body"}) then {waitUntil {((_injured getVariable "body") <= 0)};};
				if (!isNil {_injured getVariable ""}) then {waitUntil {((_injured getVariable "") <= 0)};};
				if (!isNil {_injured getVariable "hands"}) then {waitUntil {((_injured getVariable "hands") <= 0)};};
				if (!isNil {_injured getVariable "legs"}) then {waitUntil {((_injured getVariable "legs") <= 0)};};    
			};
  
		sleep 2;
		
		//healer still assigned
		AISFinishHeal[_injured, _healer, true];
		
		_healer switchAction "medicStart";
		_healer playActionNow "medicStop";
	};


_frequency = 0.5; 
_PERIOD = 1 / _frequency;

_healingEfficiency 	= FA_healingEfficiency;

_secondsToHeal = 100;
_chanceOfMisheal = 0.05;


//find healplace where objNull object, set myself there
if (
		isNull (_injured getVariable "FA_healPlace0who") &&
		!(
				(isNull (_injured getVariable "FA_healPlace1who")) 
				&& ((_healer distance (_injured modelToWorld FA_healPlace1)) < (_healer distance (_injured modelToWorld FA_healPlace0)))
			)
	) then {
		  _healPlaceString = "FA_healPlace0";
		  _injured setVariable["FA_healPlace0who", _healer,true];     
		  _healPlace = FA_healPlace0;
		} else {
			if (isNull (_injured getVariable "FA_healPlace1who")) then {
					_healPlaceString = "FA_healPlace1";
					_injured setVariable["FA_healPlace1who", _healer,true];     
					_healPlace = FA_healPlace1;
				};
		};


if (isNil "_healPlace") exitWith {
		format['HEALER EXIT -  HEALPLACE NIL'] call A_FA_DEBUG;
	};

_holster = [_healer] call FA_holster;
_check = _healer spawn (_holster select 1);
waitUntil {scriptDone _check;};
	
//if injured moves (dragged / shot at with tank or something) enough, stop heal
_injuredPosOrig = getPosATL _injured;

if (_healPlaceString == "FA_healPlace0") then {
		_healer playActionNow "medicStartRightSide";
	} else {
		_healer playActionNow "medicStart";
	};


//duplicated here (also in loop) - for healing ppl not in agony (used?)
//must directly follow attachTo 
_posh = _healer modelToWorld [0,0,0]; 
_posi = _injured modelToWorld FA_healInjuredModelChestPosition;
_dy = (_posh select 1) - (_posi select 1); _dx = (_posh select 0) - (_posi select 0);

_healer attachTo [_injured, _healPlace];
Sleep 0.001;
// engine bug: we need to wait for next frame (attachTo changes orientation of _healer - but in next frame)

//duplicated here (also in loop) - for healing ppl not in agony (used?)
//must directly follow attachTo 
_posh = _healer modelToWorld [0,0,0]; 
_posi = _injured modelToWorld FA_healInjuredModelChestPosition;
_dy = (_posh select 1) - (_posi select 1); _dx = (_posh select 0) - (_posi select 0);
_healer setDir (270- (_dy atan2 _dx) - direction _injured);

if (_injuredWasAgony) then {
		//only if agony not true
		//action escaping injured states is in agony.fsm)  
		[_healer, _injured,"loc",rPLAYACTIONNOW,"healedStart"] call RE;
	} else {
		//should not happen (engine side healing used)
		[_healer, _injured,"loc",rPLAYACTIONNOW,"treated"] call RE;        
	};

_waitStartT = time;
_waituntilT = time + _PERIOD;
_deltaT = 0;

format['HEALER SCRIPT - STARTING LOOP'] call A_FA_DEBUG;
while {
			(_healer != _injured)
			&&  (
					(((_injured modelToWorld FA_healInjuredModelHeadPosition) distance (_healer)) < FA_healDist) ||
					(((_injured modelToWorld FA_healInjuredModelLegPosition) distance (_healer)) < FA_healDist) ||
					(((_injured modelToWorld FA_healInjuredModelMiddlePosition) distance (_healer)) < FA_healDist)	
				)
			&& (_injured getVariable ["FA_inAgony",false]) 
			&& (!(_healer getVariable ["FA_inAgony",false]))
			&& (!(_healer getVariable ["FA_dragger",false]))
			&& (!(_healer getVariable ["FA_carrier",false]))
			&& (_healer getVariable ["FA_healEnabled",true])
			&& (alive _healer)
			&& (alive _injured)
			&& ((_injuredPosOrig distance (getPosATL _injured)) < 1.5)
		} do {

		if (time < _waituntilT) then {
				Sleep (_waituntilT - time);
			};
  
		_deltaT = time - _waitStartT;
		_waitStartT = time;
		_waituntilT = time + _PERIOD;
	
		if ((random 1) > _chanceOfMisheal) then {
				//heal - substract damage, trigger animation (injured is healed)
				
				//TODO: count not with frequency but elapsed time (script can be lagging)
				_healQuant = _healingEfficiency * (_deltaT) * (1/_secondsToHeal);		
				if (_healerIsMedic) then  {			  
						_healQuant = _healQuant * (FA_healingEfficiencyMedic/FA_healingEfficiency);	
						[_healer, _injured, "loc", rEXECFSM, FA_hDamage, _injured,"healMedic",_healQuant] call RE;
					} else {			  
						[_healer, _injured, "loc", rEXECFSM, FA_hDamage, _injured,"heal",_healQuant] call RE;
					};
			};
			
		_healer lookAt _injured;
		_healer doWatch _injured;
		
	};
format['HEALER SCRIPT - ENDING LOOP'] call A_FA_DEBUG;
	
_injured setVariable[(_healPlaceString+"who"), objNull,true];

if ((isNull(_injured getVariable "FA_healPlace0who")) && (isNull (_injured getVariable "FA_healPlace1who"))) then {
		if (_injuredWasAgony) then {    
				[_healer, _injured,"loc",rPLAYACTIONNOW,"healedStop"] call RE;  
			};
	};

if (_healer getVariable ["FA_healEnabled",true]) then {
		//healer.sqf was not ended with EH
		//diag_log format ["FA_HEALER medic end - death/agony %1",[_healer getVariable "FA_inAgony", _healerAgonized, damage _healer]];
		if (alive _healer) then {
				_healerAgonized = _healer getVariable ["FA_inAgony",false];
				if (isNil "_healerAgonized") then {_healerAgonized = false;};
				if (!_healerAgonized) then {
						//healer is alive and not agonized - get him out of animations states using normal way (other are die or agonyStart)
						_healer switchAction "medicStart";
						_healer playActionNow "medicStop";  
					};
			};
	};

[_injured, _healer] call FA_healerStop;

_waituntilT = time;

if (isNil {_injured getVariable ["FA_inAgony",false]}) then {
		format['FA_ ERROR: _injured %1 has FA_inAgony %2', _injured, _injured getVariable "FA_inAgony"] call A_FA_DEBUG;
	};

if (_healerIsMedic) then {
		//twice! one for stop bleed      
		[_healer, _injured, "loc", rEXECFSM, FA_hDamage, _injured,"healMedic",10000] call RE;
		[_healer, _injured, "loc", rEXECFSM, FA_hDamage, _injured,"healMedic",10000] call RE;
		
		//wait for quantum to reach object (execution of damaging.fsm with heal)
		waitUntil {(damage _injured) <= 0}; //medic 
		if (!isNil {_injured getVariable "head_hit"}) then {waitUntil {((_injured getVariable "head_hit") <= 0)};};
		if (!isNil {_injured getVariable "body"}) then {waitUntil {((_injured getVariable "body") <= 0)};};
		if (!isNil {_injured getVariable ""}) then {waitUntil {((_injured getVariable "") <= 0)};};
		if (!isNil {_injured getVariable "hands"}) then {waitUntil {((_injured getVariable "hands") <= 0)};};
		if (!isNil {_injured getVariable "legs"}) then {waitUntil {((_injured getVariable "legs") <= 0)};};
	};

AISFinishHeal[_injured, _healer, !(_injured getVariable "FA_inAgony")];

_healer removeEventHandler ["animStateChanged", (_healer getVariable "FA_animHandlerStarted")];
_healer setVariable ["FA_animHandlerStarted", nil, false];
	
_healer setVariable ["FA_healer", false,true];
_healer setVariable ["FA_healEnabled", true,true];

if (_holster select 0) then {
		[_healer] call holster_show_weapon;
	};
