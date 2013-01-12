if (!isNil "gang_functions_defined") exitWith {};

add_positions =
{
	_pos1 = _this select 0;
	_pos2 = _this select 1;
	[(_pos1 select 0) + (_pos2 select 0), (_pos1 select 1) + (_pos2 select 1), (_pos1 select 2) + (_pos2 select 2)]
};


flag_gang_get_offset = {
	private ["_anchor", "_banner", "_old_offset"];
	
	_anchor = _this select 0;
	_banner = _anchor  getVariable "banner";
	if (isNil "_banner") exitWith { nil};
	
	_old_offset = _banner getVariable "offset";
	_old_offset
};

flag_gang_set_offset = {
	private ["_anchor", "_offset", "_banner", "_old_offset", "_new_offset"];
	
	_anchor = _this select 0;
	_offset = _this select 1;
	

	_banner = _anchor  getVariable "banner";
	_old_offset = _banner getVariable "offset";
	_new_offset = [_old_offset, _offset] call add_positions;
	
	//player groupChat format["_offset = %1, _old_offset = %2, _new_offset = %3", _offset, _old_offset, _new_offset];
	
	_banner attachTo [_anchor, _new_offset];
	
	_banner setVariable ["offset", _new_offset, true];
	_new_offset
};

flag_gang_reset_offset = {
	private ["_anchor", "_offset", "_banner", "_old_offset", "_new_offset"];
	
	_anchor = _this select 0;
	_offset = _this select 1;
	
	_banner = _anchor  getVariable "banner";
	_banner attachTo [_anchor, _offset];
	_banner setVariable ["offset", _offset, true];
	_offset
};

flag_gang_setup = {
	private ["_banner", "_anchor"];
	
	_anchor = _this select 0;
	_banner = _anchor getVariable "banner";
	
	if (isNil "_banner") then
	{
		//player groupChat "Setting up flag banner";
		_banner = createVehicle ["FlagCarrierTKMilitia_EP1", getpos _anchor, [], 0, "CAN_COLLIDE"];
		_anchor setVariable ["banner", _banner, true];
		_offset = [0,0,-7.5];
		_banner attachTo [_anchor,_offset];
		_banner setVariable ["offset", _offset, true];	
	};
};

gang_functions_defined = true;