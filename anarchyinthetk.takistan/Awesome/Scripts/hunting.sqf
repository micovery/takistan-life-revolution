if (!isServer) exitwith {};

private ["_i", "_array"];

for [{_i=0}, {_i < (count huntingarray)},{_i=_i+1}] do {

		_array 		= huntingarray select _i;
		
		[_array] spawn {
				
				private ["_i", "_array", "_marker", "_area", "_classes", "_limits", "_timers", "_pos", "_area1", "_area2", "_sleepy", "_spawnTime", "_class", "_limit", "_timer", "_animals1", "_animals2", "_spawnTime_0", "_spawnTime_1", "_spawnTime_2", "_spawnTime_3", "_spawnTime_4", "_spawnTime_5", "_spawnTime_6", "_spawnTime_7", "_spawnTime_8", "_spawnTime_9", "_spawnTime_10"];
				
				_array = _this select 0;
		
				_marker		= _array select 0;
				_text		= _array select 1;
				_area		= _array select 2;
				_classes	= _array select 3;
				_limits		= _array select 4;
				_timers		= _array select 5;
				
				_pos		= getMarkerPos _marker;
				
				_marker setMarkerText _text;
				
				_area1		= _area;
				_area2		= _area + 200;
				
				_sleepy		= 30;
				
				_spawnTime	= time;
				
				for [{_i=0}, {_i < (count _classes)},{_i=_i+1}] do {
						call compile format["_spawnTime_%1 = %2", _i, time];
					};
				
				while {true} do {
						for [{_i=0}, {_i < (count _classes)},{_i=_i+1}] do {
								
								liafu = true;
								
								call compile format["_spawnTime = _spawnTime_%1", _i];
								
								_class 	= _classes select _i;
								_limit	= _limits select _i;
								_timer	= _timers select _i;
								
								_animals1	= nearestobjects [_pos, [_class], _area1];
								_animals2	= nearestobjects [_pos, [_class], _area2];
								
								if(	(count _animals2) > (count _animals1)	) then { deletevehicle (_animals2 select (count _animals2 - 1))};
								
								if (time >= _spawnTime) then {
								
										if(count _animals1 < _limit) then {
												_animal = createAgent [_class, _pos, [], _area1, "NONE"];
												
											};
											
										call compile format["_spawnTime_%1 = %2", _i, time + _timer];
										
									} else {
										
									};
							};
							
						_marker setMarkerText _text;	
						sleep _sleepy;
						
					};
			};
	};

	
while {false} do {
		
		private ["_i", "_array", "_marker", "_area", "_classes", "_limits", "_timers", "_pos", "_area1", "_area2", "_sleepy", "_spawnTime", "_class", "_limit", "_timer", "_animals1", "_animals2", "_spawnTime_0", "_spawnTime_1", "_spawnTime_2", "_spawnTime_3", "_spawnTime_4", "_spawnTime_5", "_spawnTime_6", "_spawnTime_7", "_spawnTime_8", "_spawnTime_9", "_spawnTime_10"];
				
		
		for [{_i=0}, {_i < (count huntingarray)},{_i=_i+1}] do {
				
				_array 		= huntingarray select _i;
				
				_marker		= _array select 0;
				_text		= _array select 1;
				_area		= _array select 2;
				_classes	= _array select 3;
				_limits		= _array select 4;
				_timers		= _array select 5;
				
				_pos		= getMarkerPos _marker;
				_animals	= nearestobjects [_pos, _classes, _area];
				
				
				player groupchat format["COUNT %1: %2", _i, count _animals];
			};
	
		sleep 60;
	};
	
