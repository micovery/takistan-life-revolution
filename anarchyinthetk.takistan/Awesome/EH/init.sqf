A_fnc_EH_hDamage		= compile (preprocessFileLineNumbers "Awesome\EH\Eh_handleDamage.sqf");
A_fnc_EH_hDamageV		= compile (preprocessFileLineNumbers "Awesome\EH\Eh_handleDamageVeh.sqf");
A_fnc_EH_fired			= compile (preprocessfileLineNumbers "Awesome\EH\EH_fired.sqf");
A_fnc_EH_firedV			= compile (preprocessfileLineNumbers "Awesome\EH\EH_fired_vehicle.sqf");
A_fnc_EH_wa				= compile (preprocessfileLineNumbers "Awesome\EH\EH_weaponassembled.sqf");
A_fnc_EH_iMortar		= compile (preprocessfileLineNumbers "Awesome\EH\EH_getin_mortar.sqf");
A_fnc_EH_fMortar		= compile (preprocessfileLineNumbers "Awesome\EH\EH_fired_mortar.sqf");

A_fnc_EH_init = {
		private["_unit"];
		_unit = _this select 0;
		
		[_unit] call A_fnc_EH_remove;
		
		_unit addEventHandler ["fired", {_this spawn A_fnc_EH_fired}];
		_unit addEventHandler ["WeaponAssembled", {_this spawn A_fnc_EH_wa}];
		_unit addEventHandler ["handleDamage",	{_this spawn A_fnc_EH_hDamage; 0}];

		_unit addMPEventHandler ["MPKilled", {_this call player_handle_mpkilled}];
		_unit addMPEventHandler ["MPRespawn", {_this call player_handle_mprespawn}];
	};
	
A_fnc_EH_remove = {
		private["_unit"];
		_unit = _this select 0;
		
		_unit removeAllEventHandlers "fired";
		_unit removeAllEventHandlers "WeaponAssembled";
		_unit removeAllEventHandlers "handleDamage";
		 
		_unit removeAllMPEventHandlers "MPkilled";
		_unit removeAllMPEventHandlers "MPRespawn";
	};