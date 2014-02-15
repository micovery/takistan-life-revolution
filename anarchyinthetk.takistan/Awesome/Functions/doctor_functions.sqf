#define SleepWait(timeA) private["_waittt"]; _waittt = time + timeA; waitUntil {time >= _waittt};

A_DK_Price = 2000;

A_DK_Array = [
	[Doctor1],
	[Doctor2],
	[Doctor3],
	[Doctor4],
	[Doctor5],
	[Doctor6]
];

A_DK_NearDoctor = {
	private["_unit", "_doctor", "_near"];
	_unit = _this select 0;
	_near = false;
	{
		_doctor = _x select 0;
		if ((_unit distance _doctor) <= 3) exitwith {
				_near = true;
			};
	} forEach A_DK_Array;
	
	_near
};

A_DK_Heal = {

};

A_DK_hasMoney = {
	private["_player","_cost","_playerMoney"];
	_player = _this select 0;
	_cost = _this select 1;
	
	_playerMoney = [_player, "money"] call INV_GetItemAmount;
	
	_playerMoney < _cost
};

A_DK_operation = {
	private["_player", "_cost"];
	_player = _this select 0;

	_cost = A_DK_Price;

	if ([_player, _cost] call A_DK_hasMoney) exitWith {
			_player globalChat format["You do not have enough money for this operation"];
		}; 
	[_player, "money", -(_cost)] call INV_AddInventoryItem;
	
	_player groupChat format["Here you go"];
	
	keyblock = true;
	_player playmove "AinvPknlMstpSlayWrflDnon_healed2";
	SleepWait(5)
	waituntil {animationstate _player != "AinvPknlMstpSlayWrflDnon_healed2"};
	keyblock = false;
	
	[_player] call FA_fHeal;
};