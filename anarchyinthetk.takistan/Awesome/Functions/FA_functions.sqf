FA_setup = {
	private["_unit","_sel"];
	_unit = _this select 0;
	
	{
		_sel = _x;
		_unit setVariable [_sel, 0, true];
	} forEach FA_hitList;
	
};

FA_hitList = ["", "head_hit", "body", "hands", "legs"];

FA_isMedic	= {
		((getNumber(configFile >> "CfgVehicles" >> (typeOf (_this select 0)) >> "attendant")) == 1)
	};

// Fully heal a unit, no questions asked
FA_fHeal = {
		private["_unit", "_sel"];
		_unit = _this select 0;
		
		_unit setDamage 0;
		
		{
			_sel = _x;
			_unit setVariable [_sel, 0, true];
		} forEach FA_hitList;
		
		format['if(local %1)then{{%1 setHit [_x, 0]} forEach FA_hitList;}', _unit] call broadcast;
	};
	
// Handle Heal, for healing event handler. Return false for not handled, true for handled
// [Unit, Healer, Healer in medic skin]
FA_hHeal	= {
		format['HEALER THIS-%1 PLAYER-%2', _this, player] call A_FA_DEBUG;
		
		false
	};