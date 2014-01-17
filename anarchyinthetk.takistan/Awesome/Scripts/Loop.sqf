private["_a1","_a2","_a3","_f1","_f2","_f3","_Cshopa","_Clocation","_PShopa","_PSpawn","_PLocation_1","_PLocation_2","_veh","_i"];
_a1 = 0;
_a2 = 0;
_a3 = 0;

_f1 = 0;
_f2 = 0;
_f3 = 0;



while {true} do {

for [{_i = 0}, {_i < (count Clothing_Shops)}, {_i = _i + 1}] do
{
	_CShopa		= (Clothing_Shops select _i);
	_CLocation 	= _CShopa	select 0;

	if ( player distance _CLocation <= 2) then {
			if (_a1 == 0) then {
				CLOTHECHANGEA	=	_CLocation addaction ["Access Clothes", "Awesome\Clothes\Clothes Dialogs.sqf", [_i], 1, false, true, "", ""];
				_a1 = 1;
				_f1 = _i;
			};	
		};
	
	if (	(player distance _CLocation > 2) and (_a1 == 1) and (_f1 == _i)	) then {
			_CLocation removeaction CLOTHECHANGEA;
			_a1 = 0;
		};
};


for [{_i = 0}, {_i < (count Paint_Shops)}, {_i = _i + 1}] do
{

	_PShopa			= (Paint_Shops select _i);
	_PSpawn		 	= _PShopa	select 0;
	_PLocation_1 	= _PShopa	select 1;
	_PLocation_2 	= _PShopa	select 2;

	_veh = vehicle player;

	if ( ( ((_veh) distance _PLocation_1) <= 10) && ( (_veh) != player) ) then {
			if (_a2 == 0) then {
				PAINTSHOPA1	=	(_veh) addaction ["Access Car Paiting", "Awesome\Paint\Paint Dialogs.sqf", [_PSpawn], 1, false, true, "", ""];
				_a2 = 1;
				_f2 = _i;
			};
		};
	
	if ( ((_veh) distance _PLocation_2 <= 10 ) && ( (_veh) != player)  ) then {
			if (_a3 == 0) then {
				PAINTSHOPA2	=	(_veh) addaction ["Access Car Paiting", "Awesome\Paint\Paint Dialogs.sqf", [_PSpawn], 1, false, true, "", ""];
				_a3 = 1;
				_f3 = _i;
			};
		};
	
	if (	( (((_veh) distance _PLocation_1 ) > 10) || ((vehicle player) == player)  ) and (_a2 == 1) and (_f2 == _i)	) then {
			(_veh)  removeaction PAINTSHOPA1;
			_a2 = 0;
		};
	
	if (	( ( ((_veh) distance _PLocation_2 ) > 10) || ((vehicle player) == player) ) and (_a3 == 1) and (_f3 == _i)	) then {
			(_veh)  removeaction PAINTSHOPA2;
			_a3 = 0;
		};
	
	
};







sleep 1;

};