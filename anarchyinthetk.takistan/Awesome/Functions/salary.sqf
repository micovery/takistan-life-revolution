#include "macro.h"

if (not(isNil "salary_functions_defined")) exitWith {};


cop_salary_handout = {
	if (not(iscop)) exitWith {};
	
	private["_income"];
	_income = add_copmoney;

	if ("patrol_training" call INV_HasLicense) then {
		_income = _income + 500;
	};

	if ("response_training" call INV_HasLicense) then {
		_income = _income + 1000;
	};

	if ("sobr_training" call INV_HasLicense) then {
		_income = _income + 1250;
	};

	if ("air_support_training" call INV_HasLicense) then {
		_income = _income + 1000;
	};

	if (ischief) then {
		_income = _income + chiefExtraPay;
	};

	_income = if (isNil "_income") then { add_copmoney } else {_income};
	_income = if (typeName _income != "SCALAR") then { add_copmoney } else { _income };
	
	[player, (round _income)] call bank_transaction;
	
	player groupChat format[localize "STRS_moneh_copmoneyadd", rolestring, strM((round _income))];
	sleep 1;
	
	if(ischief)then{
		player groupchat format["As a Police Chief you get an extra paycheck of $%1.", strM(chiefExtraPay)]
	};
};


civilian_salary_handout = {
	if (iscop) exitWith {};
	if ([player] call player_get_dead) exitWith {
		player groupChat format[localize "STRS_moneh_paycheckdead"];
	};
	
	private["_player"];
	_player = player;
	
	private["_income", "_activecount"];
	_income = add_civmoney;
	
	_activecount = 0;
	
	private["_i"];
	for [{_i=0}, {_i < (count BuildingsOwnerArray)}, {_i=_i+1}] do {
		private["_check"];
		_check = ( round((random 2)*((BuyAbleBuildingsArray select _i) select 4) ) );
		_income = _income + _check;
	};

	if (timeinworkplace > 0) then {
		private["_workplacepaycheck"];
		_workplacepaycheck = (round(add_workplace/180*timeinworkplace));
		_income = _income + _workplacepaycheck;
	};

	private["_gang_income"];
	_gang_income = [_player] call gangs_calculate_income;
	if (_gang_income > 0) then {
		player groupChat format["%1-%2, because you are in a gang with that controls gang areas, you get extra $%3 income", _player, (name _player), strM(_gang_income)];
		_income = _income + _gang_income;
	};

	timeinworkplace = 0;
	_income = if (isNil "_income") then { add_civmoney } else {_income};
	_income = if (typeName _income != "SCALAR") then { add_civmoney } else { _income };
	
	_income = round _income;
	[player, _income] call bank_transaction;
	
	player groupChat format[localize "STRS_moneh_civmoneyadd", rolestring, strM(_income)];
	
	private["_taxes"];
	_taxes = round((call shop_get_paid_taxes));
	
	if (isMayor) then {
		MayorTaxes = MayorTaxes + _taxes;
		MayorTaxes = round(MayorTaxes*(MayorTaxPercent/100));
		[player, (MayorTaxes + MayorExtraPay)] call bank_transaction;
		player groupchat format["As president you get an extra paycheck of $%1. You also got $%2 taxes.", strM(MayorExtraPay), strM(MayorTaxes)];
		MayorTaxes = 0;
	}
	else {if (_taxes > 0) then {
		(format["if (isMayor) then {MayorTaxes = MayorTaxes + %1;};", _taxes]) call broadcast;
	};};

	call shop_reset_paid_taxes;
};

cop_salary_loop = {
	if (not(iscop)) exitWith {};

	private["_i", "_salary_delay"];
	_salary_delay =  5;
	_i = _salary_delay;
	while { _i > 0 && iscop } do {
		player groupChat format[localize "STRS_moneh_countdown", _i];
		[60] call isleep;
		_i = _i - 1;
	};
	if (not(iscop)) exitWith {};
	[] spawn cop_salary_handout;
	[1] call isleep;
	[] spawn cop_salary_loop;
};

civilian_salary_loop = {
	if (iscop) exitWith {};

	private["_i", "_salary_delay"];
	_salary_delay = 5;
	_i = _salary_delay;
	while { _i > 0 && not(iscop) } do {
		player groupChat format[localize "STRS_moneh_countdown", _i];
		[60] call isleep;
		_i = _i - 1;
	};
	if (iscop) exitWith {};
	
	[] spawn civilian_salary_handout;
	[1] call isleep;
	[] spawn civilian_salary_loop;
};


[] spawn cop_salary_loop;
[] spawn civilian_salary_loop;

salary_functions_defined = true;
