private["_effect"];
_effect = _this select 0;

if (_effect == "light") exitwith {
	private["_obj", "_color", "_brightness"];
	
	_obj     	= _this select 1;
	_brightness = 0.1;
	_color      = [0.5, 0.5, 0.5];

	if ((count _this) > 2) then {_brightness = _this select 2;};
	if ((count _this) > 3) then {_color      = _this select 3;};

	_light = "#lightpoint" createVehicleLocal (getPosATL _obj);
	_light lightAttachObject [_obj, [0,0,0]];
	_light setLightBrightness _brightness;
	_light setLightAmbient    _color;
	_light setLightColor      _color;
};

