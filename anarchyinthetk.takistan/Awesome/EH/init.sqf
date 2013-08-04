// A_fnc_EH_init
private["_unit"];

_unit = _this select 0;

_unit removeAllEventHandlers "fired";
_unit removeAllEventHandlers "WeaponAssembled";
_unit removeAllEventHandlers "handleDamage";
 
_unit removeAllMPEventHandlers "MPkilled"; 
_unit removeAllMPEventHandlers "MPRespawn"; 

_unit addEventHandler ["fired", {_this spawn A_fnc_EH_fired}];
_unit addEventHandler ["WeaponAssembled", {_this spawn A_fnc_EH_wa}];
_unit addEventHandler ["handleDamage",	{_this spawn FA_hDamage; 0}];

_unit addMPEventHandler ["MPKilled", { _this call player_handle_mpkilled }];
_unit addMPEventHandler ["MPRespawn", { _this call player_handle_mprespawn }];

