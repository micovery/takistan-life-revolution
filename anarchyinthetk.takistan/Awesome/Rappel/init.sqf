if !(isClient) exitwith {};

#define SleepWait(timeA) private["_waittt"]; _waittt = time + timeA; waitUntil {time >= _waittt};

private["_i","_var"];
for [{_i = 0}, {_i <= 15}, {_i = _i + 1}] do {
		_var = format["A_R_rope%1", _i];
		missionNamespace setVariable [_var, objNull];
	};
	

A_R_vehicles = ["MH6J_EP1", "UH1H_TK_GUE_EP1", "UH60M_EP1", "UH60M_MEV_EP1", "MH60S", "BAF_Merlin_HC3_D", "CH_47F_EP1", "Mi17_UN_CDF_EP1", "Ka60_PMC"];

A_R_DEPLOY_V = "A_R_DEPLOYED";
A_R_DEPLOYID_V = "A_R_DEPLOYED_ID";
A_R_DROPID_V = "A_R_DROP_ID";
A_R_RAPPELID_V = "A_R_RAPPEL_ID";


A_R_LOOP = {
		private["_veh", "_unit"];
		_veh = _this select 0;
		_unit = _this select 2;
		
		if (player != _unit) exitwith {};
		if !(_veh isKindOf "helicopter") exitwith {};
		if !((toUpper(typeOf _veh)) in A_R_vehicles) exitwith {};
		
		if ((_this select 1) == "driver") then {
				[_veh] spawn A_R_LOOP_P;
			}else{
				[_veh] spawn A_R_LOOP_C;
			};
	};

A_R_LOOP_P = {
		private["_veh", "_unit", "_speedMax", "_elevMin", "_elevMax", "_speedOver", "_deployed", "_actionId_Deploy", "_actionId_Drop", "_height", "_heightBreak"];
		_veh = _this select 0;
		_unit = player;
		
		_speedMax = 5;
		_elevMin = 25;
		_elevMax = 100;
		
		_speedOver = false;
		_heightBreak = false;
		_deployed = false;
		_height = -1;
		_actionId_Deploy = -1;
		_actionId_Drop = -1;
		
		while {
					(alive _unit) && 
					((damage _veh) < 0.9) &&
					((vehicle _unit) == _veh)
				} do {
				
				_deployed = _veh getVariable [A_R_DEPLOY_V, false];
				_actionId_Drop = _veh getVariable [A_R_DROPID_V, -1];
				_actionId_Deploy = _veh getVariable [A_R_DEPLOYID_V, -1];
				
				_speedOver = (speed _veh) > _speedMax;
				_height = (getPosATL _veh) select 2;
				_heightBreak = (_height <= _elevMin) && (_height >= _elevMax);
				
				if (_deployed) then {
						if (_actionId_Drop < 0) then {
								_veh removeAction _actionId_Deploy;
								_actionId_Deploy = -1;
								
								_actionId_Drop = _veh addAction ["Drop Rappel Rope", "Awesome\Rappel\drop.sqf", "", 0, false, false, "", ""];
								_veh setVariable [A_R_DROPID_V, _actionId_Drop, false];
							};
					}else{
						if (_actionId_Deploy < 0) then {
								_veh removeAction _actionId_Drop;
								_actionId_Drop = -1;
								
								_actionId_Deploy = _veh addAction ["Deploy Rappel Rope", "Awesome\Rappel\deploy.sqf", "", 0, false, false, "", ""];
								_veh setVariable [A_R_DEPLOYID_V, _actionId_Deploy, false];
							};
					};
				
				if (_speedOver && _deployed) then {
						[] call A_R_DROP;
						hint "You are going over 5 kmph, dropping rope";
					}else{
						if (_heightBreak && _deployed) then {
								[] call A_R_DROP;
								hint "You are not in the correct height range of 25-100 meters, dropping rope";
							};
					};
				
				SleepWait(3)
			};
			
		[] call A_R_DROP;
		_veh setVariable [A_R_DEPLOYID_V, -1, false];
		_veh setVariable [A_R_DROPID_V, -1, false];
		_veh removeAction _actionId_Drop;
		_veh removeAction _actionId_Deploy;
		
	};

A_R_LOOP_C = {
		private["_veh", "_unit", "_deployed", "_actionId_rappel"];
		_veh = _this select 0;
		_unit = player;
		
		_deployed = false;
		_actionId_rappel = -1;
		_veh setVariable [A_R_RAPPEL_V, _actionId_rappel, false];
		
		while {
					(alive _unit) && 
					((damage _veh) < 0.9) &&
					((vehicle _unit) == _veh)
				} do {
				
				_deployed = _veh getVariable [A_R_DEPLOY_V, false];
				
				if (_deployed) then {
						if (_actionId_rappel < 0) then {
								_actionId_rappel = _veh addAction ["Rappel from Chopper", "Awesome\Rappel\repel.sqf", "", 0, false, false, "", ""];
								_veh setVariable [A_R_RAPPEL_V, _actionId_rappel, false];
							};
						
					}else{
						if (_actionId_rappel != -1) then {
								_veh removeAction _actionId_rappel;
							};
					};
					
				SleepWait(3)
			};
			
		_veh removeAction _actionId_rappel;
	};

A_R_DROP = {
		(_this select 0) setVariable [A_R_DEPLOY_V, false, true];
		{deleteVehicle _x} forEach [A_R_rope1, A_R_rope2, A_R_rope3, A_R_rope4, A_R_rope5, A_R_rope6, A_R_rope7, A_R_rope8, A_R_rope9, A_R_rope10, A_R_rope11, A_R_rope12, A_R_rope13, A_R_rope14, A_R_rope15];
	};

















