#include "Awesome\Functions\macro.h"

_this = _this select 3;
_art  = _this select 0;
_safe = _this select 1;

if (_art == "ausrauben") then {
	call compile format["local_cash = robpool%1", _safe];

	if(local_cash < 50000)exitwith{player groupchat "this safe has recently been stolen from and is empty"};

	if(!robenable)exitwith{player groupchat "you are already robbing the bank"};
	if(!(call INV_IsArmed) and !debug)exitWith{player groupChat localize "STRS_bank_rob_noweapon";};
	robenable = false;
	call compile format["robpool%1 = 0;publicvariable ""robpool%1"";", _safe];
	player groupChat format[localize "STRS_bank_rob_info", strM(robb_money)];

	format['[0,1,2,["opfer", %1, %2]] execVM "bankrob.sqf";', _safe, local_cash] call broadcast;

	player playmove "AinvPknlMstpSlayWrflDnon_medic";
	sleep 5;
	waituntil {animationstate player != "AinvPknlMstpSlayWrflDnon_medic"};

	if (alive player) then {
		[player, 'money', local_cash] call INV_AddInventoryItem;
		player groupChat format[localize "STRS_bank_rob_success"];
		[local_cash] spawn Bank_Rob_End_Script;
	};

	stolencash = stolencash + local_cash;

	local_useBankPossible = false;
	robenable = true;
	rblock = rblock + ((local_cash/50000)*60);
	_rblock = rblock;

	sleep 2;

	if(_rblock != rblock)exitwith{};

	for [{rblock}, {rblock > -1}, {rblock=rblock-1}] do {sleep 1;};

	local_useBankPossible = true;
	stolencash = 0;
	rblock = 0;
};


if (_art == "opfer") then {
	private["_bank_account", "_insurances_inv", "_insurances_stor"];
	_robpool = _this select 2;

	titleText [localize "STRS_bank_rob_titlemsg", "plain"];

	_safe say "Bank_alarm";
	copbase1 say "Bank_alarm";

	sleep 8;

	["Bank", "civilian", _robpool] spawn Isse_AddCrimeLogEntry;
	server globalchat format["The thief stole $%1!", _robpool];

	sleep 4;

	private["_bank_account", "_verlust", "_verlustA", "_verlustB"];
	_bank_account = [player] call bank_get_value;
	_verlust = round(_bank_account*Maxbankrobpercentlost);
	_verlustA = round(_bank_account*MaxbankrobpercentlostA);
	_verlustB = round(_bank_account*MaxbankrobpercentlostB);

	_bank_account = [player] call bank_get_value;
	_insurances_inv = [player, 'bankversicherung'] call INV_GetItemAmount;
	_insurances_stor = [player, 'bankversicherung', 'private_storage'] call INV_GetStorageAmount;
	
	
	if ((_bank_account <= _verlust) and (_bank_account >= 1) and ((_insurances_inv + _insurances_stor) == 0)) exitWith {
		[player, 0] call bank_set_value;	
		player groupChat localize "STRS_bank_rob_allmoneylost";
	};

	//Takes 5 percent from bank account if player has less than 100k (1/24/2012 IsHoOtYoUnOw)
	_bank_account = [player] call bank_get_value;
	if((_bank_account >  _verlust) and (_bank_account <= 99999) and ((_insurances_inv + _insurances_stor) == 0)) exitWith {
		[player, -(_verlust)] call bank_transaction;
		_bank_account = [player] call bank_get_value;
		player groupChat format[localize "STRS_bank_rob_somemoneylost", strM(_verlust), strM(_bank_account)];
	};

	//Takes 10 percent from bank account if player has 100k - 999k (1/24/2012 IsHoOtYoUnOw)	
	_bank_account = [player] call bank_get_value;
	if((_bank_account >  _verlust) and (_bank_account >= 100000) and (_bank_account <= 999999) and ((_insurances_inv + _insurances_stor) == 0)) exitWith {
		[player, -(_verlustA)] call bank_transaction;
		_bank_account = [player] call bank_get_value;
		player groupChat format[localize "STRS_bank_rob_somemoneylost", strM(_verlustA), strM(_bank_account)];
	};

	//Takes 20 percent from bank account if player has 1mil or more (1/24/2012 IsHoOtYoUnOw)
	_bank_account =[player] call bank_get_value;
	if((_bank_account >  _verlust) and (_bank_account >= 1000000) and ((_insurances_inv + _insurances_stor) == 0)) exitWith {
		[player, -(_verlustB)] call bank_transaction;
		_bank_account = [player] call bank_get_value;
		player groupChat format[localize "STRS_bank_rob_somemoneylost", strM(_verlustB), strM(_bank_account)];
	};	

	if (_insurances_inv > 0) exitWith {
		player groupChat localize "STRS_bank_rob_lostnomoney";
		[player, 'bankversicherung', -(1)] call INV_AddInventoryItem;
	};
	
	if(_insurances_stor > 0) exitWith {
		player groupChat localize "STRS_bank_rob_lostnomoney";
		[player, 'bankversicherung', -(1), 'private_storage'] call INV_AddItemStorage;
	};
};

