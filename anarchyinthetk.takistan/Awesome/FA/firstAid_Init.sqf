private[
		"_string", "_player"
	];
	
A_FA_PATH	= format["Awesome\FA"];
FA_FSM_P	= format["%1\FSM\", A_FA_PATH];
FA_SCRIPT_P	= format["%1\scripts\", A_FA_PATH];

FA_actions			= compile preprocessFileLineNumbers (FA_SCRIPT_P + "actions.sqf");
FA_transfer			= compile preprocessFileLineNumbers (FA_SCRIPT_P + "transfer.sqf");
FA_healerScript 	= compile preprocessFileLineNumbers (FA_SCRIPT_P + "healer.sqf");
FA_healerStop 		= compile preprocessFileLineNumbers (FA_SCRIPT_P + "healerStop.sqf");
//	FA_hDamage			= FA_FSM_P + "damaging.fsm";
FA_hDamage			= compile preprocessFileLineNumbers "Awesome\EH\Eh_handleDamage.sqf";

if (A_FA_DEBUG_ON && A_DEBUG_ON) then {
		EF_UNIT = "player";
	/*	onEachFrame  {
				_unit = call compile EF_UNIT;
				hintSilent composeText[
						format['TARGET - %1-%2', _unit, EF_UNIT],
						lineBreak,
						lineBreak,
						format['LIFE STATE-%1', lifeState _unit],
						lineBreak,
						format['A HANDLE-%1', _unit getVariable "FA_agonyHandle"],
						lineBreak,
						format['dead-%1', _unit getVariable "FA_isDead"],
						lineBreak,
						format['agony-%1', _unit getVariable "FA_inAgony"],
						lineBreak,
						format['AD-%1', _unit getVariable "FA_agonyDam"],
						lineBreak,
						format['H-%1', _unit getVariable "FA_healer"],
						lineBreak,
						format['HE-%1', _unit getVariable "FA_healEnabled"],
						lineBreak,
						format['D-%1', _unit getVariable "FA_dragger"],
						lineBreak,
						format['C-%1', _unit getVariable "FA_carrier"],
						lineBreak,
						format['DW-%1', _unit getVariable "FA_dragWanted"],
						lineBreak,
						format['CW-%1', _unit getVariable "FA_carryWanted"],
						lineBreak,
						format['DD-%1', _unit getVariable "FA_dragged"],
						lineBreak,
						format['CD-%1', _unit getVariable "FA_carried"],
						lineBreak,
						lineBreak,
						format['DAMAGE-%1', damage _unit],
						lineBreak,
						format['total-%1', _unit getVariable ""],
						lineBreak,
						format['hea_hit-%1', _unit getVariable "head_hit"],
						lineBreak,
						format['body-%1', _unit getVariable "body"],
						lineBreak,
						format['hands-%1', _unit getVariable "hands"],
						lineBreak,
						format['legs-%1', _unit getVariable "legs"],
						lineBreak,
						format['bl-%1', _unit getVariable "bloodloss"],
						lineBreak,
						format['blps-%1', _unit getVariable "bloodlossPerSecond"],
						lineBreak,
						format['can stand-%1', canStand _unit],
						lineBreak,
						format['hands hit-%1', handsHit _unit],
						lineBreak,
						lineBreak,
						format['HP0W-%1', _unit getVariable "FA_healPlace0who"],
						lineBreak,
						format['HP1W-%1', _unit getVariable "FA_healPlace1who"],
						lineBreak,
						format['HP0WL-%1', _unit getVariable "FA_healPlace0whoLast"],
						lineBreak,
						format['HP1WL-%1', _unit getVariable "FA_healPlace1whoLast"],
						lineBreak,
						format['HP0LT-%1', _unit getVariable "FA_healPlace0LastTime"],
						lineBreak,
						format['HP1LT-%1', _unit getVariable "FA_healPlace1LastTime"],
						lineBreak,
						lineBreak,
						format['TIME-%1', time],
						lineBreak,
						format['TIME D0-%1', time - (_unit getVariable "FA_healPlace0LastTime")],
						lineBreak,
						format['TIME D1-%1', time - (_unit getVariable "FA_healPlace1LastTime")],
						lineBreak,
						
						lineBreak,
						format["END"]
					]; 
			}; */
	};

FA_agonyDam								= 0.6;
FA_healInjuredModelChestPosition 		= [0, +0.08, 0];
FA_healPlace0 							= [0.75, 0.15,0];
FA_healPlace1 							= [-0.75, 0.1, 0]; 
FA_healDist 							= 2.5;
FA_healingEfficiency 					= 1.0;
FA_healingEfficiencyMedic 				= 1.5;
FA_bodyParts 							= ["", "body", "head_hit", "hands", "legs"];
FA_healInjuredModelHeadPosition 		= [-0.10,-0.35,0];
FA_healInjuredModelMiddlePosition 		= [0,0.2,0];
FA_healInjuredModelLegPosition 			= [0,0.75,0];
FA_dragInjuredModelPosition 			= [0.10,0.350,0];
FA_dragDist 							= 2;
FA_healPlaceTimeMax 					= 10 * 60;

A_fnc_EH_init	= compile (preprocessfileLineNumbers "Awesome\EH\init.sqf");
A_fnc_EH_fired	= compile (preprocessfileLineNumbers "Awesome\EH\EH_fired.sqf");
A_fnc_EH_wa		= compile (preprocessfileLineNumbers "Awesome\EH\EH_weaponassembled.sqf");

A_fnc_FA_init	= compile (preprocessfileLineNumbers "Awesome\FA\scripts\set.sqf");

FA_isMedic	= {
		((getNumber(configFile >> "CfgVehicles" >> (typeOf (_this select 0)) >> "attendant")) == 1)
	};

FA_fHeal = {
		private["_unit"];
		_unit = _this;

		(_this) setVariable ["",0,true];
		(_this) setVariable ["head_hit",0,true];
		(_this) setVariable ["hands",0,true];
		(_this) setVariable ["body",0,true];
		(_this) setVariable ["legs",0,true];
		(_this) setVariable ["bloodloss",0,true];
		(_this) setVariable ["bloodlossPerSecond",0,true];
		
		_unit setVariable["FA_healPlace0who", objNull,true];
		_unit setVariable["FA_healPlace1who", objNull,true];
		_unit setVariable["FA_healPlace0whoLast", objNull,true];
		_unit setVariable["FA_healPlace1whoLast", objNull,true];
		_unit setVariable["FA_healPlace0LastTime", 0,true];
		_unit setVariable["FA_healPlace1LastTime", 0,true];
	};
	
FA_hHeal	= {
		format['HEALER THIS-%1 PLAYER-%2', _this, player] call A_FA_DEBUG;

/*		if (!((_this select 0) getVariable ["FA_inAgony", false])) then{
				(_this select 0) setVariable ["",0,true];
				(_this select 0) setVariable ["head_hit",0,true];
				(_this select 0) setVariable ["hands",0,true];
				(_this select 0) setVariable ["body",0,true];
				(_this select 0) setVariable ["legs",0,true];
				(_this select 0) setVariable ["bloodloss",0,true];
				(_this select 0) setVariable ["bloodlossPerSecond",0,true];   
			//	{(_this select 0) setVariable [_x, 0, false];} forEach ["", "head_hit", "hands", "body", "legs", "bloodlossPerSecond"];
				false
			}else{
				_this spawn FA_healerScript; 
				true
			};
*/
		false
	};

FA_DAMAGEHEAL =  {
		private ["_injured", "_part", "_capInjured", "_capHealer", "_damageToApply","_damage"];
		_injured 			= _this select 0;
		_part 				= _this select 1;
		_damageToApply 		= _this select 2;
		_capInjured 		= _this select 3;
		_capHealer 			= _this select 4;
		_damage 			= (_injured getVariable [_part,0]) + _damageToApply;
		_damage 			= _capInjured max _damage;
		_damage 			= _capHealer max _damage;
		_injured setVariable [_part, _damage, true];   
	};

FA_armed = {
		private["_unit"];
		_unit = _this select 0;
		((primaryWeapon _unit) != "")
	};
	
FA_holster = {
		private["_unit", "_wep_P", "_wep_C", "_type", "_holster"];
		_unit = _this select 0;
		
		_return = [];
		_holster = false;
		_code = {};
		_wep_P = primaryWeapon _unit;
		_wep_C = currentWeapon _unit;
		if ( _wep_P != "") then {
				if (_wep_P != _wep_C) then {
						_unit selectWeapon _wep_P;
						_code = {waitUntil {(currentWeapon _this) == (primaryWeapon _this)}; sleep 2;};
					};
			}else{
				_type = [_wep_C] call getClass;
				switch _type do {
						case "pistol": {
								_holster = true;
								[_unit] call holster_hide_weapon;
								_code = {sleep 2;};
							};
						case "launcher": {
								_unit action ["WeaponOnBack", _unit];
								if (([] call shop_get_player_third_weapon) != "") then {
										_holster = true;
										[_unit] call holster_hide_weapon;
										_code = {sleep 2;};
									};
								_code = {sleep 5;};
							};
						case "none": {};
						default {};
					};
			};
			
		_return = [_holster, _code];
			
		_return
	};
	
FA_dragB = {
		private["_unit", "_target"];
		_unit 	= _this select 0;
		_target = cursorTarget;
					
		if ( (_target isKindOf "CAManBase") && (isPlayer _target) ) then {
					(
						(_unit != _target)
						&& (alive _target)
						&& (_target getVariable ["FA_inAgony",false])	
						&& (((_target modelToWorld FA_dragInjuredModelPosition) distance (_unit)) < FA_dragDist)
						&& (!(_target getVariable ["FA_dragged",false]))
						&& (!(_target getVariable ["FA_carried",false]))
						&& (alive _unit)
						&& (canStand _unit)
						&& (!(_unit getVariable ["FA_dragger",false]))
						&& (!(_unit getVariable ["FA_carrier",false]))
						&& (!(_unit getVariable ["FA_inAgony",false]))
						&& (!(_unit getVariable ["FA_healer",false]))
					)
				} else {
					false
				};
	};

FA_carryB = {
		private["_unit", "_target"];
		_unit 	= _this select 0;
		_target = cursorTarget;
					
		if ( (_target isKindOf "CAManBase") && (isPlayer _target) ) then {
					(
						(_unit != _target)
						&& (alive _target)
						&& (alive _unit)
						&& (!(_unit getVariable ["FA_inAgony", false]))
						&& (!(_unit getVariable ["FA_healer", false]))
						&& (_unit getVariable ["FA_dragger", false])
						&& ([_unit] call FA_armed)
						&& ( (primaryWeapon _unit) == (currentWeapon _unit) )
					)
				} else {
					false
				};
	};

FA_takeB = {
		private["_unit", "_target", "_kind", "_crew", "_injured", "_mounted"];
		_unit 	= _this select 0;
		_target = cursorTarget;
		
		_kind = (
				(_target isKindOf "LandVehicle")
				|| (_target isKindOf "Air")
				|| (_target isKindOf "Ship")
			);
		
		if ( _kind ) then {
					_crew = crew _target;
					if ((count _crew) > 0) then {
							_injured = false;
							{
								if  ( (_x getVariable ["FA_inAgony", false]) && (alive _x) ) then {
										_injured = true;
									};
							} forEach _crew;
							if (_injured) then {
									true
								}else{
									_mounted = [_target] call mounted_get_occupants;
									if (isNil "_mounted")then{
											false
										} else {
											{
												if (_x getVariable ["FA_inAgony", false]) then {
														_injured = true;
													};
											} forEach _mounted;
											_injured
										};
								};
						} else {
							false
						};
				} else {
					false
				};
	};

FA_faB = {
		private[
				"_unit", "_target"
			];
		
		_unit	= player;
		_target	= cursorTarget;
		
		if ( (_target isKindOf "CAManBase") && (isPlayer _target) ) then {
					(
						(_unit != _target)
						&& (alive _target)
						&& (_target getVariable ["FA_inAgony",false])	
						&& (((_target modelToWorld FA_dragInjuredModelPosition) distance (_unit)) < FA_dragDist)
						&& (!(_target getVariable ["FA_dragged",false]))
						&& (!(_target getVariable ["FA_carried",false]))
						&& (alive _unit)
						&& (canStand _unit)
						&& (!(_unit getVariable ["FA_dragger",false]))
						&& (!(_unit getVariable ["FA_carrier",false]))
						&& (!(_unit getVariable ["FA_inAgony",false]))
						&& (!(_unit getVariable ["FA_healer",false]))
						&& ([_target] call FA_isMedic)
						&& ( ( (playerSide) getFriend (side _target)) < 0.6)
					)
				} else {
					false
				};
	};

_player = nil;
{
	_string = _x;
	_player = missionNamespace getVariable _string;
	if (!isNil "_player") then {
			if (!isNull _player) then {
					if (isPlayer _player) then {
							[_player] call A_fnc_FA_init;
						};
				};
		};
	_player = nil;
} forEach playerStringArray;