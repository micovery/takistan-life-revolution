private[
		"_old", "_new", "_sel", "_num"
	];

_old 	= _this select 0;
_new	= _this select 1;

_new setDamage (damage _old);

if (true) exitwith {[_new] call A_fnc_EH_init;};

{
	_sel = _x;
	_num = _old getVariable[_sel, 0];
	_new setHit[_sel, _num];
	_new setVariable[_sel, _num, true];
} forEach [
		"",
		"head_hit",
		"body",
		"hands",
		"legs",
		"bloodloss",
		"bloodlossPerSecond"
	];
	
_new	setVariable["FA_isDead", false, true];
_new	setVariable["FA_inAgony", (_old getVariable["FA_inAgony", false]), true];
_new	setVariable["FA_agonyDam", (_old getVariable["FA_agonyDam", FA_agonyDam]), true];
_new	setVariable["FA_healer", false, true];
_new	setVariable["FA_healEnabled", true, true];
	
_new	setVariable["FA_dragger", false, true];
_new	setVariable["FA_carrier", false, true];
_new	setVariable["FA_dragWanted", false, true];
_new	setVariable["FA_carryWanted", false, true];
_new	setVariable["FA_dragged", false, true];
_new	setVariable["FA_carried", false, true];

_new 	setVariable["FA_healPlace0who", (_old getVariable["FA_healPlace0who", objNull]),true];
_new 	setVariable["FA_healPlace1who", (_old getVariable["FA_healPlace1who", objNull]),true];
_new 	setVariable["FA_healPlace0whoLast", (_old getVariable["FA_healPlace0whoLast", objNull]),true];
_new 	setVariable["FA_healPlace1whoLast", (_old getVariable["FA_healPlace1whoLast", objNull]),true];
_new 	setVariable["FA_healPlace0LastTime", (_old getVariable["FA_healPlace0LastTime", 0]),true];
_new 	setVariable["FA_healPlace1LastTime", (_old getVariable["FA_healPlace1LastTime", 0]),true];

(_old getVariable ["FA_agonyHandle", 0]) setFSMvariable["end", true];

_agonyHandle = [_new] execFSM FA_FSM_P + "agony.fsm";
format["NEW H - %1 old - %2", _agonyHandle, (_old getVariable ["FA_agonyHandle",0])] call A_FA_DEBUG;
_new setVariable ["FA_agonyHandle", _agonyHandle, false]; 
(_new getVariable ["FA_agonyHandle",0]) setFSMvariable ["who", _new];

_new removeAllEventHandlers "handleDamage";
//_new addEventHandler ["handleDamage",	{_this execFSM FA_hDamage; 0}];
_new addEventHandler ["handleDamage",	{_this spawn FA_hDamage; 0}];

[_new] call FA_actions;
[_new] call A_fnc_EH_init;

[nil,nil,rSPAWN, [_new], {
		format["ADDING HH - %1-%2", _this, _this select 0] call A_FA_DEBUG;
		(_this select 0) removeAllEventHandlers "handleHeal";
		(_this select 0) addEventHandler ["handleHeal", {_this spawn FA_hHeal;}];
	}] call RE;








