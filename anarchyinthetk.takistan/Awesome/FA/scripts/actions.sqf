private[
		"_unit", "_array", "_da", "_ta", "_ca", "_fa"
	];

_unit = _this select 0;

{
	_unit removeAction _x;
} forEach (_unit getVariable ["A_FA_ACTIONS", []]);
	
_da =	_unit addAction ["Drag", (FA_SCRIPT_P + "dragger.sqf"), [],99,true,false,"",
		'
			[_this] call FA_dragB;
	'];
_ca	=	_unit addAction ["Carry",(FA_SCRIPT_P + "carrier.sqf"),[],98,true,false,"", 
		'
			[_this] call FA_carryB;
	'];
_ta	= 	_unit addAction ["Take out injured",(FA_SCRIPT_P + "takeout.sqf"),[],98,true,false,"", 
		'
			[_this] call FA_takeB;
	'];
	
// this action is strictly for healing medics of an opposing faction since the default action does not work with them
_fa	= 	_unit addAction ["First Aid - Enemy",(FA_SCRIPT_P + "HealerFix.sqf"),[],98,true,false,"", 
		'
			[_this] call FA_faB;
	'];

_array = [_da, _ca, _ta, _fa];
if (A_DEBUG_ON && A_FA_DEBUG_ON)then{
	//	_debug	= 	_unit addAction ["SWITCH DEBUG TARGET",(FA_SCRIPT_P + "EF.sqf")];
	//	_array set[count _array, _debug];
	};

_unit setVariable["A_FA_ACTIONS", _array];







