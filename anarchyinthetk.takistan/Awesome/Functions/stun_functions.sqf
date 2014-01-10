stun_shot_close = {
	private ["_unit", "_shooter", "_selection", "_damage", "_armor", "_veh", "_inveh"];

	_unit = _this select 0;
	_shooter = _this select 1;
	_selection = _this select 2;
	_damage = _this select 3;
	_armor = _this select 4;
	_veh = _this select 5;
	_inveh = _this select 6;
	_distance = _this select 7;
	
	[_unit, _shooter] spawn stun_broadcast;
	
	_armor = _unit getVariable "stun_armor";
	
	if (typeName _armor != "STRING" ) then {
		_unit setVariable ["stun_armor", "none", true];
		_armor = _unit getVariable "stun_armor";
	};
	
	if (isNil "_armor" ) then {
		_unit setVariable ["stun_armor", "none", true];
		_armor = _unit getVariable "stun_armor";
	};
	
	if ((_armor != "full") && (_armor != "light") ) then {
		StunActiveTime = StunActiveTime + StunTimePerHit;

		if (_inveh) then {
			_unit action ["eject", _veh];
			sleep 0.01;
		};
					
		if ([_unit] call is_prone) then {
			format['%1 switchmove "AdthPpneMstpSlowWrflDf_1";',_unit] call broadcast;
		} else {
			format['%1 switchmove "adthpercmstpslowwrfldnon_4";',_unit] call broadcast;
		};
				
		if (isPlayer _unit) then {
			[_unit] spawn stun_effects_full;
		} else {
			format[ "if(isServer) then {[%1, %2] spawn stun_effects_AI;};", _unit, StunActiveTime ] call broadcast;
			StunActiveTime = 0;
		};

	} else { if (not(_armor  == "full") && (_armor == "light")) then {
		if (((_selection != "body") ) && (_damage > 1) ) exitWith {				
			StunActiveTime = StunActiveTime + StunTimePerHit;
			
			if (_inveh) then {
				_unit action ["eject", _veh];
				sleep 0.01;	
			};

			if ([_unit] call is_prone) then {
				format['%1 switchmove "adthpercmstpslowwrfldnon_4";',_unit] call broadcast;
			} else {
				format['%1 switchmove "AMELPERCMSTPSNONWNONDNON_ZASAH7BRICHO";',_unit] call broadcast;
			};

			if (isPlayer _unit) then {
				[_unit] spawn stun_effects_light;
			} else {
				format[ "if(isServer) then {[%1, %2] spawn stun_effects_AI;};", _unit, StunActiveTime ] call broadcast;
			};		
		};
	};};
};

stun_shot_far = {
	private ["_unit", "_shooter", "_selection", "_damage", "_armor", "_veh", "_inveh"];

	_unit = _this select 0;
	_shooter = _this select 1;
	_selection = _this select 2;
	_damage = _this select 3;
	_armor = _this select 4;
	_veh = _this select 5;
	_inveh = _this select 6;
	_distance = _this select 7;

	[_unit, _shooter] spawn stun_broadcast;
	
	_armor = _unit getVariable "stun_armor";
	
	if (typeName _armor != "STRING" ) then {
		_unit setVariable ["stun_armor", "none", true];
		_armor = _unit getVariable "stun_armor";
	};
	
	if (isNil "_armor" ) then {
		_unit setVariable ["stun_armor", "none", true];
		_armor = _unit getVariable "stun_armor";
	};
	
	if ((_armor != "full") && (_armor != "light") ) then {
		StunActiveTime = StunActiveTime + StunTimelight;
			
		if (_inveh) then {	
			_unit action ["eject", _veh];
			sleep 0.01;
		};

		if ([_unit] call is_prone) then {
			format['%1 switchmove "adthpercmstpslowwrfldnon_4";',_unit] call broadcast;
		} else {
			format['%1 switchmove "AMELPERCMSTPSNONWNONDNON_ZASAH7BRICHO";',_unit] call broadcast;
		};

		if (isPlayer _unit) then {
			[_unit] spawn stun_effects_light;
		} else {
			format[ "if(isServer) then {[%1, %2] spawn stun_effects_AI;};", _unit, StunActiveTime ] call broadcast;
			StunActiveTime = 0;
		};
	} else { if (not(_armor == "full") && (_armor == "light")) then {
		if ( ( (_selection != "body") ) && (_damage > 1) ) exitwith {		
			StunActiveTime = StunActiveTime + StunTimelight;		
			if (_inveh) then {
				_unit action ["eject", _veh];
				sleep 0.01;		
			};
					
			if ([_unit] call is_prone) then {
				format['%1 switchmove "adthpercmstpslowwrfldnon_4";',_unit] call broadcast;
			} else {
				format['%1 switchmove "AMELPERCMSTPSNONWNONDNON_ZASAH7BRICHO";',_unit] call broadcast;
			};

			if (isPlayer _unit) then {
				[_unit] spawn stun_effects_light;
			} else {
				format[ "if(isServer) then {[%1, %2] spawn stun_effects_AI;};", _unit, StunActiveTime ] call broadcast;
				StunActiveTime = 0;
			};
		};
	};};
};

stun_pistol_hit = {
	private ["_unit", "_man", "_time"];
	
	_man = _this select 0;
	_unit = _this select 1;
	_time = _this select 2;

	[_unit, _man] call stun_broad_light;
	//player groupchat format['You were hit by %1-%2', _man, name _man];
	
	StunActiveTime = StunActiveTime + _time;
	
	[_unit] spawn stun_effects_full;
};

stun_pistol = { _this spawn {
	private ["_man", "_unit", "_dir"];
	
	_unit = _this select 0;
	_man = _this select 1;
	
	if (stunning) exitwith {};
	stunning = true;
	
	format['%1 switchmove "AwopPercMstpSgthWnonDnon_end";',_unit] call broadcast;

	sleep 0.3;
	
	if (isNull _man) exitwith {stunning = false;};
	if (!alive _man) exitwith {stunning = false;};
	if (_man distance _unit > 3) exitwith {stunning = false;};
	if (not( [_unit, _man] call is_facing ) ) exitwith {stunning = false;};
	
	_dir = [_unit, _man] call is_frontback;
	
	if (_dir == "front") then {
		[_unit, _man] call stun_pistol_front;
	};
	if (_dir == "back") then {
		[_unit, _man] call stun_pistol_back;
	};

	stunning = false;
};};

stun_pistol_front = {
	private ["_unit", "_man"];

	_unit = _this select 0;
	_man = _this select 1;
	
	if ([_man] call is_prone) then {
		format['%1 switchmove "AdthPpneMstpSlowWrflDf_1";',_man] call broadcast;
	} else {
		format['%1 switchmove "adthpercmstpslowwrfldnon_4";',_man] call broadcast;
	};
	
	if (isPlayer _man) then {
		format['if (player == %2) then { [%1, %2, stunpistolfront] spawn stun_pistol_hit; };', _unit, _man] call broadcast;
	} else {
		format[ "if(isServer) then {[%1, %2] spawn stun_effects_AI;};", _man, StunPistolFront ] call broadcast;
	};
};

stun_pistol_back = {
	private ["_unit", "_man"];
	
	_unit = _this select 0;
	_man = _this select 1;
	
	if ([_man] call is_prone) then {
		format['%1 switchmove "AdthPpneMstpSlowWrflDf_1";',_man] call broadcast;
	} else {
		format['%1 switchmove "adthpercmstpslowwrfldnon_4";',_man] call broadcast;
	};
	
	if (isPlayer _man) then {
		format['if (player == %2) then { [%1, %2, stunpistolback] call stun_pistol_hit; };', _unit, _man] call broadcast;
	} else {
		format[ "if(isServer) then {[%1, %2] spawn stun_effects_AI;};", _man, StunPistolFront ] call broadcast;
	};
};

stun_rifle_hit = {
	private ["_unit", "_man", "_time"];
	
	_man = _this select 0;
	_unit = _this select 1;
	_time = _this select 2;

	[_unit, _man] call stun_broad_light;
	//player groupchat format['You were hit by %1-%2', _man, name _man];
	
	StunActiveTime = StunActiveTime + _time;
	
	[_unit] spawn stun_effects_full;
};

stun_rifle = { _this spawn {
	private ["_man", "_unit", "_dir"];
	
	_unit = _this select 0;
	_man = _this select 1;
	
	if (stunning) exitwith {};
	stunning = true;
	
	format['%1 switchmove "AmelPercMstpSlowWrflDnon_StrokeGun";',_unit] call broadcast;
	
	sleep 1.2;

	if(isNull _man) exitwith {stunning = false;};
	if(!alive _man) exitwith {stunning = false;};
	if(_man distance _unit > 3) exitwith {stunning = false;};
	if( !( [_unit, _man] call is_facing ) ) exitwith {stunning = false;};

	_dir = [_unit, _man] call is_frontback;

	if (_dir == "front") then {
		[_unit, _man] call stun_rifle_front;
	};
	
	if (_dir == "back") then {
		[_unit, _man] call stun_rifle_back;
	};

	stunning = false;
};};

stun_rifle_front = {
	private ["_unit", "_man"];
	
	_unit = _this select 0;
	_man = _this select 1;
	
	if ([_man] call is_prone) then {
		format['%1 switchmove "AdthPpneMstpSlowWrflDf_1";',_man] call broadcast;
	} else {
		format['%1 switchmove "AMELPERCMSTPSNONWNONDNON_ZASAH7BRICHO";',_man] call broadcast;
		sleep 1.3;
		format['%1 switchmove "adthpercmstpslowwrfldnon_4";',_man] call broadcast;
	};
	
	if (isPlayer _man) then {
		format['if (player == %2) then { [%1, %2, stunriflefront] spawn stun_rifle_hit; };', _unit, _man] call broadcast;
	} else {
		format[ "if(isServer) then {[%1, %2] spawn stun_effects_AI;};", _man, stunriflefront ] call broadcast;
	};
};

stun_rifle_back = {
	private ["_unit", "_man"];
	
	_unit = _this select 0;
	_man = _this select 1;
	
	if ([_man] call is_prone) then {
			format['%1 switchmove "AdthPpneMstpSlowWrflDf_1";',_man] call broadcast;
	} else {
		format['%1 switchmove "adthpercmstpslowwrfldnon_4";',_man] call broadcast;
	};
	
	if (isPlayer _man) then {
		format['if (player == %2) then { [%1, %2, stunrifleback] spawn stun_rifle_hit; };', _unit, _man] call broadcast;
	} else {
		format[ "if(isServer) then {[%1, %2] spawn stun_effects_AI;};", _man, stunrifleback ] call broadcast;
	};
};

stun_hands_hit = {
	private ["_unit", "_man", "_time"];
	
	_man = _this select 0;
	_unit = _this select 1;
	_time = _this select 2;

	[_unit, _man] call stun_broad_light;
	//player groupchat format['You were hit by %1-%2', _man, name _man];
	
	StunActiveTime = StunActiveTime + _time;
	
	[_unit] spawn stun_effects_full;
};

stun_hands = { _this spawn {
	private ["_man", "_unit", "_damage", "_pdamage", "_random", "_dir"];
	
	_unit = _this select 0;
	_man = _this select 1;
	
	if (stunning) exitwith {};
	stunning = true;
	
	_damage = damage _man;
	_pdamage = damage _unit;
	_random = round (random 100);
	
	if(isNull _man) exitwith {stunning = false;};
	if(!alive _man) exitwith {stunning = false;};
	if(_man distance _unit > 2) exitwith {stunning = false;};
	if( !( [_unit, _man] call is_facing ) ) exitwith {stunning = false;};
	
	_dir = [_unit, _man] call is_frontback;
	
	if ( [_man] call is_prone ) exitwith {
		[_unit, _man, _damage, _pdamage, _random] spawn stun_hands_prone;
	};
	
	if (_dir == "front") exitwith {
		[_unit, _man, _damage, _pdamage, _random] spawn stun_hands_front;
	};
	
	if (_dir == "back") exitwith {
		[_unit, _man, _damage, _pdamage, _random] spawn stun_hands_back;
	};
};};

stun_hands_prone = {
	private ["_unit", "_man", "_damage", "_pdamage", "_random", "_stun", "_idamage"];
	
	_unit = _this select 0;
	_man = _this select 1;
	_damage	= _this select 2;
	_pdamage = _this select 3;
	_random	= _this select 4;
	
	_stun		= 0;
	
	if ((_random <= 100) && (_random >= 90)) then {	
		format['%1 switchmove "AMELPERCMSTPSNONWNONDNON_AMATERUDER1";',_unit] call broadcast;
		sleep M_punch;
		
		if ([_unit, "isstunned"] call player_get_bool) exitwith {stunning = false;};
		if ((_man distance _unit) > 2) exitwith {stunning = false;};
		if (_pdamage != damage _unit) exitwith {stunning = false;};
		
		[_man] call stun_punched;
		format['%1 switchmove "AdthPpneMstpSlowWrflDf_1";',_man] call broadcast;
		format['%1 switchmove "AMELPERCMSTPSNONWNONDNON_AMATERUDER2";',_unit] call broadcast;
		sleep M_punch;
		
		if ([_unit, "isstunned"] call player_get_bool) exitwith {stunning = false;};
		if (_man distance _unit > 2) exitwith {stunning = false;};
		if (_pdamage != damage _unit) exitwith {stunning = false;};
		
		[_man] call stun_punched;
		format['%1 switchmove "AdthPpneMstpSlowWrflDf_1";',_man] call broadcast;
		format['%1 switchmove "AMELPERCMSTPSNONWNONDNON_AMATERUDER3";',_unit] call broadcast;
		sleep M_punch;
		
		if ([_unit, "isstunned"] call player_get_bool) exitwith {stunning = false;};
		if (_man distance _unit > 2) exitwith {stunning = false;};
		if (_pdamage != damage _unit) exitwith {stunning = false;};
		
		[_man] call stun_punched;
		format['%1 switchmove "AdthPpneMstpSlowWrflDf_1";',_man] call broadcast;
		sleep M_punch;
		if (_man distance _unit > 2) exitwith {stunning = false;};
		[_man] call stun_punched;
		format['%1 switchmove "AdthPpneMstpSlowWrflDf_1";',_man] call broadcast;
		
		_idamage =  (M_prone_crit);	
		_stun = stunpronecrit;		
	};
		
	if ((_random < 90) && (_random >= 50)) then {
		format['%1 switchmove "AMELPERCMSTPSNONWNONDNON_AMATERUDER1";',_unit] call broadcast;
		sleep M_punch;

		if ([_unit, "isstunned"] call player_get_bool) exitwith {stunning = false;};
		if(_man distance _unit > 2) exitwith {stunning = false;};
		if (_pdamage != damage _unit) exitwith {stunning = false;};
		
		[_man] call stun_punched;
		format['%1 switchmove "AdthPpneMstpSlowWrflDf_1";',_man] call broadcast;
		format['%1 switchmove "AMELPERCMSTPSNONWNONDNON_AMATERUDER2";',_unit] call broadcast;
		sleep M_punch;

		if ([_unit, "isstunned"] call player_get_bool) exitwith {stunning = false;};
		if(_man distance _unit > 2) exitwith {stunning = false;};
		if (_pdamage != damage _unit) exitwith {stunning = false;};
		
		[_man] call stun_punched;
		format['%1 switchmove "AdthPpneMstpSlowWrflDf_1";',_man] call broadcast;
					
		_idamage = (M_prone_hev);
		_stun = stunpronehev;
	};
		
	if ((_random < 50) && (_random >= 0)) then {
		[_man] call stun_punched;
		format['%1 switchmove "AMELPERCMSTPSNONWNONDNON_AMATERUDER3";',_unit] call broadcast;
		sleep M_punch;
		
		if ([_unit, "isstunned"] call player_get_bool) exitwith {stunning = false;};
		if (_man distance _unit > 2) exitwith {stunning = false;};
		if (_pdamage != damage _unit) exitwith {stunning = false;};
		
		[_man] call stun_punched;
		format['%1 switchmove "AdthPpneMstpSlowWrflDf_1";',_man] call broadcast;
			
		_idamage = (M_prone_reg);
		_stun = stunpronereg;
	};
	
	if (!stunning) exitwith {};
	
	_man setdamage (_damage + _idamage);
	
	if (!alive _man) then {
		if (isPlayer _man) then {
			format['[%1, %2] call victim;', _unit, _man] call broadcast;
		};
	} else { if(isPlayer _man) then {
		format['if (player == %2) then { [%1, %2, %3] spawn stun_hands_hit; };', _unit, _man, _stun] call broadcast;
	} else {
		format[ "if(isServer) then {[%1, %2] spawn stun_effects_AI;};", _man, _stun ] call broadcast;
	};};
		
	stunning = false;
};

stun_hands_front = {
	private ["_unit", "_man", "_damage", "_pdamage", "_random", "_stun", "_idamage"];
	
	_unit		= _this select 0;
	_man		= _this select 1;
	_damage		= _this select 2;
	_pdamage	= _this select 3;
	_random		= _this select 4;
	
	_stun		= 0;
	
	if ((_random <= 100) && (_random >= 90)) then {	
		[_man] call stun_punched;
		format['%1 switchmove "AMELPERCMSTPSNONWNONDNON_AMATERUDER1";',_unit] call broadcast;
		sleep M_punch;
		
		if ([_unit, "isstunned"] call player_get_bool) exitwith {stunning = false;};
		if (_man distance _unit > 2) exitwith {stunning = false;};
		if (_pdamage != damage _unit) exitwith {stunning = false;};
		
		[_man] call stun_punched;
		format['%1 switchmove "AMELPERCMSTPSNONWNONDNON_ZASAH1";',_man] call broadcast;
		format['%1 switchmove "AMELPERCMSTPSNONWNONDNON_AMATERUDER2";',_unit] call broadcast;
		sleep M_punch;
		
		if ([_unit, "isstunned"] call player_get_bool) exitwith {stunning = false;};
		if (_man distance _unit > 2) exitwith {stunning = false;};
		if (_pdamage != damage _unit) exitwith {stunning = false;};
		
		[_man] call stun_punched;
		format['%1 switchmove "AMELPERCMSTPSNONWNONDNON_ZASAH2";',_man] call broadcast;
		format['%1 switchmove "AMELPERCMSTPSNONWNONDNON_AMATERUDER3";',_unit] call broadcast;
		sleep M_punch;
		
		if ([_unit, "isstunned"] call player_get_bool) exitwith {stunning = false;};
		if (_man distance _unit > 2) exitwith {stunning = false;};
		if (_pdamage != damage _unit) exitwith {stunning = false;};
		
		[_man] call stun_punched;
		format['%1 switchmove "AMELPERCMSTPSNONWNONDNON_ZASAH3HARD";',_man] call broadcast;
		sleep M_punch;
		if (_man distance _unit > 2) exitwith {stunning = false;};
		
		[_man] call stun_punched;
		format['%1 switchmove "adthpercmstpslowwrfldnon_4";',_man] call broadcast;
		
		_idamage =  (M_front_crit);	
		_stun = stunfrontcrit;
	};		
		
	if ((_random < 90) && (_random >= 50)) then {
		[_man] call stun_punched;
		format['%1 switchmove "AMELPERCMSTPSNONWNONDNON_AMATERUDER1";',_unit] call broadcast;
		sleep M_punch;
		
		if ([_unit, "isstunned"] call player_get_bool) exitwith {stunning = false;};
		if (_man distance _unit > 2) exitwith {stunning = false;};
		if (_pdamage != damage _unit) exitwith {stunning = false;};
		
		[_man] call stun_punched;
		format['%1 switchmove "AMELPERCMSTPSNONWNONDNON_ZASAH1";',_man] call broadcast;
		format['%1 switchmove "AMELPERCMSTPSNONWNONDNON_AMATERUDER2";',_unit] call broadcast;
		sleep M_punch;
		
		if ([_unit, "isstunned"] call player_get_bool) exitwith {stunning = false;};
		if (_man distance _unit > 2) exitwith {stunning = false;};
		if (_pdamage != damage _unit) exitwith {stunning = false;};
		
		[_man] call stun_punched;
		format['%1 switchmove "AMELPERCMSTPSNONWNONDNON_ZASAH2";',_man] call broadcast;
				
		_idamage = (M_front_hev);
		_stun = stunfronthev;
	};
		
	if ((_random < 50) && (_random >= 0)) then {
		[_man] call stun_punched;
		format['%1 switchmove "AMELPERCMSTPSNONWNONDNON_AMATERUDER3";',_unit] call broadcast;
		sleep M_punch;
		
		if ([_unit, "isstunned"] call player_get_bool) exitwith {stunning = false;};
		if (_man distance _unit > 2) exitwith {stunning = false;};
		if (_pdamage != damage _unit) exitwith {stunning = false;};
		
		[_man] call stun_punched;
		format['%1 switchmove "AMELPERCMSTPSNONWNONDNON_ZASAH3HARD";',_man] call broadcast;
		
		_idamage = (M_front_reg);
		_stun = stunfrontreg;	
	};
	
	if (!stunning) exitwith {};

	_man setdamage (_damage + _idamage);
	
	if (!alive _man) then {
		if (isPlayer _man) then {
			format['[%1, %2] call victim;', _unit, _man] call broadcast;
		};
	} else { if(isPlayer _man) then {
		format['if (player == %2) then { [%1, %2, %3] spawn stun_hands_hit; };', _unit, _man, _stun] call broadcast;
	} else {
		format[ "if(isServer) then {[%1, %2] spawn stun_effects_AI;};", _man, _stun ] call broadcast;
	};};
		
	stunning = false;
};

stun_hands_back = {
	private ["_unit", "_man", "_damage", "_pdamage", "_random", "_stun", "_idamage"];
	
	_unit = _this select 0;
	_man = _this select 1;
	_damage	= _this select 2;
	_pdamage = _this select 3;
	_random	 = _this select 4;
	_stun = 0;
	
	if ((_random <= 100) && (_random >= 50)) then {	
		[_man] call stun_punched;
		format['%1 switchmove "AMELPERCMSTPSNONWNONDNON_AMATERUDER1";',_unit] call broadcast;
		sleep M_punch;
		
		if ([_unit, "isstunned"] call player_get_bool) exitwith {stunning = false;};
		if (_man distance _unit > 2) exitwith {stunning = false;};
		if (_pdamage != damage _unit) exitwith {stunning = false;};
		
		[_man] call stun_punched;
		format['%1 switchmove "AMELPERCMSTPSNONWNONDNON_ZASAH2";',_man] call broadcast;
		format['%1 switchmove "AMELPERCMSTPSNONWNONDNON_AMATERUDER2";',_unit] call broadcast;
		sleep M_punch;
		
		if ([_unit, "isstunned"] call player_get_bool) exitwith {stunning = false;};
		if (_man distance _unit > 2) exitwith {stunning = false;};
		if (_pdamage != damage _unit) exitwith {stunning = false;};
		
		[_man] call stun_punched;
		format['%1 switchmove "AMELPERCMSTPSNONWNONDNON_ZASAH4";',_man] call broadcast;
		format['%1 switchmove "AMELPERCMSTPSNONWNONDNON_AMATERUDER3";',_unit] call broadcast;
		sleep M_punch;
		if (_man distance _unit > 2) exitwith {stunning = false;};
		if (_pdamage != damage _unit) exitwith {stunning = false;};
		
		[_man] call stun_punched;
		format['%1 switchmove "adthpercmstpslowwrfldnon_2";',_man] call broadcast;
		format['%1 switchmove "adthpercmstpslowwrfldnon_4";',_man] call broadcast;
			
		_idamage = (M_back_crit);
		_stun = stunbackcrit;				
	};
	
	if ((_random < 50) && (_random >= 30)) then {
		[_man] call stun_punched;
		format['%1 switchmove "AMELPERCMSTPSNONWNONDNON_AMATERUDER1";',_unit] call broadcast;
		sleep M_punch;
		
		if ([_unit, "isstunned"] call player_get_bool) exitwith {stunning = false;};
		if (_man distance _unit > 2) exitwith {stunning = false;};
		if (_pdamage != damage _unit) exitwith {stunning = false;};
		
		[_man] call stun_punched;
		format['%1 switchmove "AMELPERCMSTPSNONWNONDNON_ZASAH5HARD";',_man] call broadcast;
		format['%1 switchmove "AMELPERCMSTPSNONWNONDNON_AMATERUDER2";',_unit] call broadcast;
		sleep M_punch;
		
		if ([_unit, "isstunned"] call player_get_bool) exitwith {stunning = false;};
		if (_man distance _unit > 2) exitwith {stunning = false;};
		if (_pdamage != damage _unit) exitwith {stunning = false;};
		
		[_man] call stun_punched;
		format['%1 switchmove "AMELPERCMSTPSNONWNONDNON_ZASAH4";',_man] call broadcast;
				
		_idamage = (M_back_hev);
		_stun = stunbackhev;
	};		
	
	if ((_random < 30) && (_random >= 0)) then {
		[_man] call stun_punched;
		format['%1 switchmove "AMELPERCMSTPSNONWNONDNON_AMATERUDER3";',_unit] call broadcast;
		sleep M_punch;
		
		if ([_unit, "isstunned"] call player_get_bool) exitwith {stunning = false;};
		if (_man distance _unit > 2) exitwith {stunning = false;};
		if (_pdamage != damage _unit) exitwith {stunning = false;};
		
		[_man] call stun_punched;
		format['%1 switchmove "adthpercmstpslowwrfldnon_2";',_man] call broadcast;
		
		_idamage = (M_back_reg);
		_stun = stunbackreg;
	};			
	
	if (!stunning) exitwith {};
	
	_man setdamage (_damage + _idamage);
	
	if (not(alive _man)) then {
		if (isPlayer _man) then {
			format['[%1, %2] call victim;', _unit, _man] call broadcast;
		};
	} else { if(isPlayer _man) then {
		format['if (player == %2) then { [%1, %2, %3] spawn stun_hands_hit; };', _unit, _man, _stun] call broadcast;
	} else {
		format[ "if(isServer) then {[%1, %2] spawn stun_effects_AI;};", _man, _stun ] call broadcast;
	};};
		
	stunning = false;
};

stun_punched = {
		(_this select 0) setVariable ["punched", time, true];
	};
	
stun_punch_check = {
		(time < ( ((_this select 0) getVariable ["punched", -5]) + 2 ))
	};

stun_broad_light = {
	private ["_unit", "_attacker"];
	
	_unit = _this select 0;
	_attacker = _this select 1;
	
	server globalchat format["You were hit by %1-%2", _attacker, name _attacker]
};

stun_broadcast = {
	private ["_unit", "_shooter"];
	
	if (missionNamespace getVariable ["stun_broadcasting", false]) exitwith {};
	
	stun_broadcasting = true;
	
	_unit = _this select 0;
	_shooter = _this select 1;
	
	format['if (player == %3) then {server globalchat "You were stunned by %1-%2" }; ', _shooter, name _shooter, _unit] call broadcast;
	format['if (player == %3) then {server globalchat "You stunned %1-%2" }; ', _unit, name _unit, _shooter] call broadcast;
	format[' server globalchat "%1-%2 was stunned by %3-%4" ', _unit, name _unit, _shooter, name _shooter] call broadcast;
	
	sleep 0.5;
	stun_broadcasting = false;
};

stun_effects_AI = {
	private ["_unit", "_time"];

	_unit = _this select 0;
	_time = _this select 1;
	
	[_unit] spawn stun_drop_weapons;

	sleep _time;

	format['%1 switchmove "amovppnemstpsnonwnondnon";',_unit] call broadcast;
};

stun_effects_light = {
	private ["_unit", "_time"];

	_unit = _this select 0;
	_time = _this select 1;
	
	if (stunloop) exitwith {};
	
	if (isPlayer _unit) then {
		"dynamicBlur" ppEffectEnable true;
		"dynamicBlur" ppEffectAdjust [10];
		"dynamicBlur" ppEffectCommit 0;
		waitUntil {ppEffectCommitted "dynamicBlur"};
		"dynamicBlur" ppEffectEnable true;
		"dynamicBlur" ppEffectAdjust [0];
		"dynamicBlur" ppEffectCommit StunActiveTime;
	};
	
	if (isPlayer _unit) then {	
		while{StunActiveTime > 0} do {
			stunloop = true;
			if(StunActiveTime > MaxStunTime) then {
				StunActiveTime = MaxStunTime;
			}; 
			StunActiveTime = StunActiveTime - 1; 
			sleep 1;
		};
		stunloop = false;
		StunActiveTime = 0;	
	} else {
		StunActiveTime = 0;
	};
};

stun_effects_full = {
	private ["_unit", "_restrained_q"];

	_unit = _this select 0;
	
	if (stunloop) exitwith {};
	
	[_unit, "isstunned", true] call player_set_bool;
	
	if (isPlayer _unit) then {
		"dynamicBlur" ppEffectEnable true;
		"dynamicBlur" ppEffectAdjust [10];
		"dynamicBlur" ppEffectCommit 0;
		waitUntil {ppEffectCommitted "dynamicBlur"};
		"dynamicBlur" ppEffectEnable true;
		"dynamicBlur" ppEffectAdjust [0];
		"dynamicBlur" ppEffectCommit StunActiveTime;
	};
						
	[_unit] spawn stun_drop_weapons;
	
	if (isPlayer _unit) then {	
		while{StunActiveTime > 0} do {
			stunloop = true;
			if(StunActiveTime > MaxStunTime) then {
				StunActiveTime = MaxStunTime;
			}; 
			StunActiveTime = StunActiveTime - 1; 
			sleep 1;
		};
			
		stunloop = false;
		StunActiveTime = 0;		
	} else {
		StunActiveTime = 0;
	};
			
	_restrained_q = [_unit, "restrained"] call player_get_bool;
	
	if ( typeName _restrained_q ==  "BOOL") then {
		if (!_restrained_q) then {
			[_unit, "isstunned", false] call player_set_bool;
			format['%1 switchmove "amovppnemstpsnonwnondnon";',_unit] call broadcast;
		};
	} 
	else {
		[_unit, "isstunned", false] call player_set_bool;
		if ([_unit] call is_prone) then {
				format['%1 switchmove "amovppnemstpsnonwnondnon";',_unit] call broadcast;
			};
	};

};

stun_drop_weapons = {
	private ["_unit", "_weapons", "_holder", "_pos"];
 
	 _unit = _this select 0;
	 _weapons = weapons _unit;
	 _weapons = _weapons - nonlethalweapons;
 
	if (not(count _weapons > 0)) exitWith {};

	if (isPlayer _unit) then  {
		{_unit removeWeapon _x} forEach _weapons;
	} else {
		//Don't ask me why but it has to be broadcasted to work...
		format["removeAllWeapons %1",_unit] call broadcast;
	};
	
	_holder = createVehicle ["weaponholder", (getPosATL _unit), [], 0, "NONE"];
	sleep 0.01;
	_pos = [ (getPosATL _unit) select 0, (getPosATL _unit) select 1, ((getPosATL _unit) select 2) + 0.05 ];
	_holder setPosATL _pos;
	{_holder addWeaponCargoGlobal [_x, 1];} foreach _weapons;
};
