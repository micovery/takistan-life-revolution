

M_effect_WP = {
	private ["_decal_dir", "_pos_projectile"];
	
	_pos_projectile = _this select 0;
	
	_decal_dir = random 90;
	
	createVehicle [M_smoke, (_pos_projectile), [], 0, "NONE"];
	
	sleep 3;
	
	//format['%1 createVehicle %2', M_smoke, _pos_projectile] call broadcast;
	//format['%1 createVehicle %2', M_smoke, [(_pos_projectile select 0) + 5*cos (_decal_dir+0),(_pos_projectile select 1) + 5*sin (_decal_dir+0),0]] call broadcast;
	//format['%1 createVehicle %2', M_smoke, [(_pos_projectile select 0) + 5*cos (_decal_dir+90),(_pos_projectile select 1) + 5*sin (_decal_dir+90),0]] call broadcast;
	//format['%1 createVehicle %2', M_smoke, [(_pos_projectile select 0) + 5*cos (_decal_dir+180),(_pos_projectile select 1) + 5*sin (_decal_dir+180),0]] call broadcast;
	//format['%1 createVehicle %2', M_smoke, [(_pos_projectile select 0) + 5*cos (_decal_dir+270),(_pos_projectile select 1) + 5*sin (_decal_dir+270),0]] call broadcast;
	
	createVehicle [M_smoke,
	[
		(_pos_projectile select 0) + 5*cos (_decal_dir+0),
		(_pos_projectile select 1) + 5*sin (_decal_dir+0),
		0
	]
	, [], 0, "NONE"];

/*	createVehicle [M_smoke, 
	[
		(_pos_projectile select 0) + 5*cos (_decal_dir+90),
		(_pos_projectile select 1) + 5*sin (_decal_dir+90),
		0
	]
	, [], 0, "NONE"];

	createVehicle [M_smoke, 
	[
		(_pos_projectile select 0) + 5*cos (_decal_dir+180),
		(_pos_projectile select 1) + 5*sin (_decal_dir+180),
		0
	]
	, [], 0, "NONE"];
*/

	createVehicle [M_smoke, 
	[
		(_pos_projectile select 0) + 5*cos (_decal_dir+270),
		(_pos_projectile select 1) + 5*sin (_decal_dir+270),
		0
	]
	, [], 0, "NONE"];
};

M_effect_IL = {
	private ["_projectile", "_pos", "_M_time" ,"_flare", "_flareH", "_choice"];
	
	_projectile = _this select 0;
	_pos = getpos _projectile;
	_choice = _this select 1;
	
	switch _choice do {
		case "F": {
			_pos = getpos _projectile;
			while {alive _projectile} do {
				_flare = M_flare createVehicle _pos;
				while {alive _flare} do {
					_pos = getpos _projectile;
					_flare setPosATL _pos;
					if (!alive _projectile) then {
						deleteVehicle _flare;
					};
				};
			};
			deleteVehicle _flare;
		};
		case "T": {
			deleteVehicle _projectile;
			_pos = getpos _projectile;
			
			_M_time = time + M_ill_time;
			
			while {time < _M_time} do {
				_flare = M_flare createVehicle _pos;
				while {alive _flare} do {
					_flare setPosATL _pos;
					if (time > _M_time) then {deleteVehicle _flare;};
				};
			};
			deleteVehicle _flare;
		};
		case "G": {
			_pos = getpos _projectile;
			deleteVehicle _projectile;
		
			_flareH = true;
			
			while {_flareH} do {
				_flare = M_flare createVehicle _pos;
				while {alive _flare} do {
					_flare setPosATL _pos;
					_pos	= [ (_pos select 0), (_pos select 1), ((_pos select 2) - M_ill_decent) ];
					if ( ((getPosATL _flare) select 2) > 1 ) then {
						_flareH = false;
					};
					if (!_flareH) then {deleteVehicle _flare;};
				};
			};
			deleteVehicle _flare;
		};
		case "TG": {
			_pos = getpos _projectile;
			deleteVehicle _projectile;
		
			_M_time = time + M_ill_time;
			
			while {time < _M_time} do {
				_flare = M_flare createVehicle _pos;
				while {alive _flare} do {
					_flare setPosATL _pos;
					_pos	= [ (_pos select 0), (_pos select 1), ((_pos select 2) - M_ill_decent) ];
					if (time > _M_time) then {deleteVehicle _flare;};
				};
			};
			deleteVehicle _flare;
		};
	};
};