liafu = true;

if(pickingup)exitwith{};


pickingup=true;

_this 		= _this select 3;
_gangarea 	= _this select 0;
_type		= _this select 1;




if(!debug) then {
	player playmove "AinvPknlMstpSlayWrflDnon_medic";
	sleep 5;
	waituntil {animationstate player != "AinvPknlMstpSlayWrflDnon_medic"};
};


if(_type == "neutralise")then {
	private["_new_pos"];
	[_gangarea] call flag_gang_setup;
	_new_pos = [_gangarea, [0,0,0.5*-1]] call flag_gang_set_offset;

	if((_new_pos select 2) <= -7)then {
		_mygang  = call INV_MyGang;
		_control = _gangarea getvariable "control";

		if(_mygang != "" and !isnil "_control")then {
			_gangarea setvariable["control", nil, true];
			format["hint ""%1 has been neutralised by %2!"";", _gangarea, _mygang] call broadcast;
		};
	};
};

if(_type == "capture")then {
	private["_new_pos"];
	[_gangarea] call flag_gang_setup;
	
	_new_pos = [_gangarea, [0,0,0.5]] call flag_gang_set_offset;

	//player groupchat format["_new_pos = %1", _new_pos];
	if((_new_pos select 2) >= 0)then { 
		[_gangarea, [0,0,0]] call flag_gang_reset_offset;
		
		_mygang  = call INV_MyGang;
		_control = _gangarea getvariable "control";

		if(_mygang != "" and isnil "_control")then {
			_gangarea setvariable["control", _mygang, true];
			format["hint ""%1 has been captured by %2!"";", _gangarea, _mygang] call broadcast;
		};
	};
};

pickingup=false;