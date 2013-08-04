_effekt = _this select 0;
_ParticleParams = [["\Ca\Data\ParticleEffects\FireandSmokeAnim\SmokeAnim.p3d",8,1,8],  "", "Billboard", 1, 37, [0, 0, 29],[0, 0, 0.09],0,11.0,9,0.075,[1, 1.5, 6, 22],[[0.1, 0.1, 0.1, 1], [0.15, 0.15, 0.15 , 0.7], [0.2,0.2,0.2,0.5], [0.3,0.3,0.3,0]], [0.08],1,0,"","", ""];
_RandomParams = [5,[0, 0, 0],[0.25, 0.25, 0.25],1,0.5,[0.1,0.1,0.1,0.1],1,0];

if (_effekt == "rauch") then {
	_obj = (_this select 1);
	_pos = (_this select 2);
	liafu = true;
	while {true} do {
		_rauch= "#particlesource" createVehicleLocal _pos;
		_rauch setParticleRandom _RandomParams;
		_rauch setParticleParams _ParticleParams;
		_rauch setDropInterval 0.015;
		waitUntil {!(alive _obj)};
		deleteVehicle _rauch;
		waitUntil {alive _obj};
	};
};

if (_effekt == "light") then {

	_object     = _this select 1;
	_helligkeit = 0.1;
	_farbe      = [0.5, 0.5, 0.5];

	if ((count _this) > 2) then {_helligkeit = _this select 2;};
	if ((count _this) > 3) then {_farbe      = _this select 3;};

	_light = "#lightpoint" createVehicleLocal getpos _object;
	_light lightAttachObject [_object, [0,0,0]];
	_light setLightBrightness _helligkeit;
	_light setLightAmbient    _farbe;
	_light setLightColor      _farbe;
};

