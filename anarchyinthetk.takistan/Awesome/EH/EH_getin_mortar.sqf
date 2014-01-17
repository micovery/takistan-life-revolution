private["_vehicle","_position","_unit"];
_vehicle = _this select 0;
_position = _this select 1;
_unit = _this select 2;


if (vehicle player != _vehicle) exitwith {};


if (_vehicle isKindOf "StaticMortar") then {


private ["_piece", "_canon", "_azimut", "_elevation", "_str_azimut", "_str_elevation"];	
	
_piece = _vehicle;
_canon = weapons _piece select 0;
	
_azimut = 0;
_elevation = 0;
	
_str_azimut = "";
_str_elevation = "";
	
while {vehicle player == _piece} do {
	
		_azimut = ((_piece weaponDirection _canon) select 0) atan2 ((_piece weaponDirection _canon) select 1);
		_azimut = round (_azimut*100) / 100;

		if (_azimut < 0) then {_azimut = _azimut + 360};

		_elevation = asin ((_piece weaponDirection _canon) select 2);
		_elevation = round (_elevation*100) / 100;

		_str_azimut = str _azimut;

		if (round (_azimut*100) mod 10 == 0) then {
							
				if (round (_azimut*100) mod 100 == 0) then {			
						_str_azimut = _str_azimut + ".00";		
					} else {		
						_str_azimut = _str_azimut + "0";		
					};				
			};	

		if (_elevation >= 0) then {					
				_str_elevation = str _elevation;	
				
				if (round (_elevation*100) mod 10 == 0) then {						
				
					if (round (_elevation*100) mod 100 == 0) then {							
							_str_elevation = _str_elevation + ".00";					
						} else {								
							_str_elevation = _str_elevation + "0";					
						};				
				};
					
			} else {				
				_str_elevation = str (-_elevation);

				if (round (-_elevation*100) mod 10 == 0) then {
										
						if (round (-_elevation*100) mod 100 == 0) then {							
								_str_elevation = _str_elevation + ".00";						
							} else {					
								_str_elevation = _str_elevation + "0";				
							};			
					};
					
				_str_elevation = "-" + _str_elevation;				
			};

		M_Elevation = _str_elevation;
		M_Azimut	= _str_azimut;
		
	//	titleText [format["E: %1		A: %2", _str_elevation, _str_azimut], "plain down", 0.01];
		hintSilent format["E: %1		A: %2", _str_elevation, _str_azimut];
	};

};
