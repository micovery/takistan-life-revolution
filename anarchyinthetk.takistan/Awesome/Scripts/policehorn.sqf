private["_vcl","_class","_isbike","_isdriver"];

_vcl  = vehicle player;
if (isNil "HORN_Playing") then	{ HORN_Playing = false;	};
_class = typeOf (vehicle (player));
_isbike = (configName(inheritsFrom(inheritsFrom (configFile >> "CfgVehicles" >> _class))) == "Bicycle");
_isdriver = (player == (driver _vcl));

if (HORN_Playing || _isbike || !_isdriver) exitWith {};
HORN_Playing = true;

format["

_vehicle = %1;
_distance = player distance _vehicle;

if ( _distance <= 60 ) then
{
	[_vehicle, player] say3D ""policehorn"";
};

", _vcl] call broadcast;
sleep 3;
HORN_Playing = false;
