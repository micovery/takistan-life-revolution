_bullet			= _this select 1;
_this			= _this select 0;

_unit 			= _this select 0;
_weapon			= _this select 1;
_muzzle			= _this select 2;
_mode			= _this select 3;
_ammo			= _this select 4;
_magazine		= _this select 5;
_projectile		= _this select 6;


if ( (typeName _bullet) != "OBJECT") exitwith {};


_Tear_gas =
{
	_pos = _this select 0;
	_timenow = time;
	_array = [];	
	
	while{time < (_timenow + 10) || (!(isnull _pos))}do
		{
		  if(!gasmask) then {
			sleep 1;
			if(!(isnull _pos))then
				{
					if(count(nearestObjects [_pos, ["Man"], 10]) > 0)then
						{

							{
								_x setVariable ["flashed",true, true];
								_array set [count _array,_x];

							} foreach nearestObjects [_pos, ["Man"], 10];
						
						}else{
						
							{
								_unit = _x;
								_unit setVariable ["flashed",false, true];
								{
									if(_x == _unit)then
										{
											_array = _array - [_x];
										};
								} foreach _array;
				
							}foreach _array;
						
						};
				};
			};
		};	
};



_BPos = [];

while {!isNull _bullet and ((velocity _bullet)select 0 > 0.1)} do {
	_BPos = getPosATL _bullet;
};

switch (_ammo) do
{
    case "SmokeShell":
    {
		[_bullet] spawn _Tear_gas;
    };   
    case "G_40mm_Smoke":
    {
		[_bullet] spawn _Tear_gas;
    };   
};