#include "macro.h"
#include "constants.h"

if (not(isNil "interaction_functions_defined")) exitWith {};

interact_human = {
	private["_player", "_target"];
	_player = _this select 0;
	_target = _this select 1;
	
	if (not([_player] call player_human)) exitWith { false };
	if (not([_target] call player_human)) exitWith { false };
	
	civ_variable_name = str(_target);
	civ_player_variable  = _target;
	
	if (([_player] call player_cop) && (not([_target] call player_cop) || ischief)) exitWith {
		if (not(createDialog "civmenu")) exitWith { hint "Dialog Error!";};
		true;
	};
	
	if (([_player] call player_civilian) || ([_player] call player_opfor)  || ([_player] call player_insurgent)) exitWith {
		if (!(createDialog "civinteraktion")) exitWith {hint "Dialog Error!";};
		true
	};
	false
};


interact_ai = {
	private["_player", "_target"];
	
	_player = _this select 0;
	_target = _this select 1;
	
	if (isNil "_player") exitWith {false};
	if (isNil "_target") exitWith {false};
	
	if (not([_player] call player_human)) exitWith {false};
	if ([_target] call player_human) exitWith {false};
	if (not(_target in shopusearray)) exitWith {false};
	
	private["_id"];
	_id = _target call INV_GetShopNum;
	
	if(([_player] call player_cop) and (_target in drugsellarray)) exitWith {
		[_id] spawn shop_drug_search;
		true;
	};
	
	private["_handled"];
	if((_target in pmc_shop_list)) exitWith {
		if (not([_player] call player_civilian)) exitWith {
			hint "You cannot access PMC Shops: Not a civilian";
			false
		};

		if (not([_player] call player_pmc_whitelist)) exitWith {
			hint "You cannot access PMC Shops: Not in whitelist";
			false
		};

		if ([_player] call player_pmc_blacklist) exitWith {
			hint "You cannot access PMC Shops: In blacklist";
			false
		};

		[_id] call shop_open_dialog;
		true
	};

	[_id] call shop_open_dialog;
	true
};


interact_atm = {
	private["_player", "_target"];
	
	_player = _this select 0;
	_target = _this select 1;
	
	if (isNil "_player") exitWith {false};
	if (isNil "_target") exitWith {false};
	
	if (not([_player] call player_human)) exitWith {false};
	if ([_target] call player_human) exitWith {false};
	if (not(_target in bankflagarray)) exitWith {false};
	
	if(!local_useBankPossible) exitWith {
		hint "The ATM rejected your card";
		false
	};
	
	call interact_atm_menu;
	true
};


interact_arrest_player = {
	private["_player", "_victim", "_minutes", "_bail_percent"];

	_player = _this select 0;
	_victim = _this select 1;
	_minutes = _this select 2;
	_bail_percent = _this select 3;
	
	if (not([_player] call player_human)) exitWith {};
	if (not([_victim] call player_human)) exitWith {};
	if (isNil "_minutes") exitWith {};
	if (isNil "_bail_percent") exitWith {};
	
	
	if (typeName _minutes != "SCALAR") exitWith {};
	if (_minutes <= 0) exitWith {};
	
	if (typeName _bail_percent != "SCALAR") exitWith {};
	if (_bail_percent <= 0) exitWith {};
	
	
	if (not([_victim, "restrained"] call player_get_bool)) exitWith {
		player groupChat format["%1-%2 is not restrained!", _victim, (name _victim)];
	};
	
	if ([_victim] call player_get_arrest) exitWith {
		player groupChat format["%1 is already under arrest!", _victim];
	};
	
	private["_seconds", "_victim_side"];
	_minutes = if ([_victim] call player_civilian) then { _minutes } else { (15 max _minutes)};
	
	private["_message"];
	_message = format["%1-%2 was arrested by %3-%4", _victim, (name _victim), _player, (name _player)];
	format['server globalChat toString(%1);', toArray(_message)] call broadcast;
	

	[_player, "arrestsmade", 1] call player_update_scalar;
	
	private["_bounty"];
	_bounty = [_victim] call player_get_bounty;
	if (_bounty > 0) then {
		player groupChat format["%1-%2 had a bounty of $%3. You got that bounty!", _victim, (name _victim), _bounty];
		[_player, _bounty] call bank_transaction;
		[_victim, 0] call player_set_bounty;
	};
	
	format['[%1, %2] call player_prison_time;', _victim, _minutes] call broadcast;
	format['[%1, %2] call player_prison_bail;', _victim, _bail_percent] call broadcast;
	format['[%1] call player_prison_convict;', _victim] call broadcast;
};

interact_pay_bail = {
	private["_player", "_bail"];

	_player = _this select 0;
	_bail = _this select 1;

	if (isNil "_player") exitWith {};	
	if (isNil "_bail") exitWith{};

	_bail = [_bail] call parse_number;
	if (_bail <= 0) exitWith {};

	private["_money"];
	_money = [_player] call player_get_total_money;

	if (_bail > _money) exitWith {
		player groupChat format["You do not have enough money to pay $%1 in bail", _bail];
	};

	private["_cop_count", "_cop_bail"];
	_cop_count = playersNumber west;
	_cop_bail = round(_bail/_cop_count);
	[_player, _bail] call player_lose_money;
	[_player, -(_bail)] call player_update_bail;
		
	player groupChat format ["You paid $%1 in bail", strM(_bail)];
	private["_message"];
	_message = format["Prisoner %1-%2 paid $%3 in bail", _player, (name _player), strM(_bail)];
	format['if(not(iscop)) then {server globalChat toString(%1);};', toArray(_message)] call broadcast;
		
	_message = format["You got $%1 because prisoner %2-%3 paid %4 in bail", _cop_bail, _player, (name _player), strM(_bail)];
	format['if (iscop) then {server globalChat toString(%1);};', toArray(_message)] call broadcast;
};

interact_toggle_restrains = {
	private["_player", "_victim"];
	
	_player = _this select 0;
	_victim = _this select 1;
	
	if (not([_player] call player_human)) exitWith {};
	if (not([_victim] call player_human)) exitWith {};
	if (not(alive _victim)) exitWith {};
	
	private["_inVehicle", "_victim_name"];
	_inVehicle = (vehicle _victim != _victim);
	_victim_name = (name _victim);
	
	if (_inVehicle) exitWith {
		player groupChat format["%1-%2 is in a vehicle!", _victim, _victim_name];
	};
	
	private["_message"];
	if ([_victim, "restrained"] call player_get_bool) then {
		[_victim, "restrained", false] call player_set_bool;
		_message = format["%1-%2 was unrestrained by %3", _victim, _victim_name, (name _player)];
		format['server globalChat toString(%1);', toArray(_message)] call broadcast;
	}
	else {
		if (not([_victim] call player_vulnerable)) exitWith {
			player groupChat format["%1-%2 cannot be restrained, he is not subdued.", _victim, _victim_name];
		};
		
		[_victim, "restrained", true] call player_set_bool;
		_message = format["%1-%2 was restrained by %3", _victim, _victim_name, (name _player)];
		format['server globalChat toString(%1);', toArray(_message)] call broadcast;
	};
};

interact_release_player = {
	private["_player", "_victim"];
	
	_player = _this select 0;
	_victim = _this select 1;
	
	if (not([_player] call player_human)) exitWith {};
	if (not([_victim] call player_human)) exitWith {};
	
	if (_victim == player) exitWith {
		player groupChat format["You cannot release yourself from prison"];
	};
	
	if (not([_victim] call player_get_arrest)) exitWith {
		player groupChat format["%1-%2 is not in prison", _victim,  (name _victim)];
	};
	
	private["_message"];
	_message = format["%1-%2 has been set free by %3-%4", _victim, (name _victim), _player, (name _player)];
	format['server globalChat toString(%1);', toArray(_message)] call broadcast;
	[_victim, false] call player_set_arrest;
};

interact_want_player = {
	private["_player", "_victim", "_reason"];
	
	_player = _this select 0;
	_victim = _this select 1;
	_reason = _this select 2;
	
	if (not([_player] call player_human)) exitWith {};
	if (not([_victim] call player_human)) exitWith {};
	if (isNil "_reason") exitWIth {};
	if (typeName _reason != "STRING") exitWith {};
	
	if (_victim == player) exitWith {
		player groupChat format["You cannot set yourself wanted"];
	};
	
	if ([_victim] call player_get_arrest) exitWith {
		player groupChat format["%1-%2 is in prison, cannot be set wanted", _victim,  (name _victim)];
	};
	
	if (not(alive _victim)) exitWith {
		player groupChat format["%1-%2 is not alive, cannot be set wanted", _victim,  (name _victim)];
	};
	
	if (_reason == "Description of crime") exitWith {
		player groupChat "You must enter a description of the crime!"
	};
	
	private["_message"];
	_message = format["%1-%2 has been set wanted by %3-%4 for %5", _victim, (name _victim), _player, (name _player), _reason];
	format['server globalChat toString(%1);', toArray(_message)] call broadcast;
	_reason = _reason + format[" by %1-%2", _player, (name _player)];
	[_victim, _reason, 0] call player_update_warrants;
};


interact_unwant_player = {
	private["_player", "_victim"];
	
	_player = _this select 0;
	_victim = _this select 1;
	
	if (not([_player] call player_human)) exitWith {};
	if (not([_victim] call player_human)) exitWith {};
	
	if (_victim == player) exitWith {
		player groupChat format["You cannot set yourself unwanted"];
	};
	
	if (not(([_victim] call player_get_wanted))) exitWith {
		player groupChat format["%1-%2 is not wanted", _victim, (name _victim)];
	};

	private["_message"];
	_message = format["%1-%2 has cleared %3-%4's warrants", _player, (name _player), _victim, (name _victim)];
	format['server globalChat toString(%1);', toArray(_message)] call broadcast;
	[_victim] call player_reset_warrants;
}; 


interact_president_elect = { _this spawn {
	private["_player", "_target"];
	
	
	_player = _this select 0;
	_target = _this select 1;
	
	if (not([_player] call player_human)) exitWith {};
	if (not([_target] call player_human)) exitWith {};
	
	WahlSperre = if (isNil "WahlSperre") then {false} else {WahlSperre};

	private["_sleep_time"];
	_sleep_time = 30;
	if (WahlSperre) exitWith {
		player groupChat format["You have already voted in the last %1 seconds", _sleep_time];
	};
	
	
	private["_voter_number", "_candidate_number"];
	_voter_number = [_player] call player_get_index;
	_candidate_number = [_target] call player_get_index;
	
	if (_voter_number < 0 || _candidate_number < 0) exitWith {
		player groupChat format["Unable to find candidate number"];
	};
	
	
	private["_next_election_str", "_next_election"];
	_next_election = server getVariable "next_president_election";
	_next_election_str = if (not(isNil "_next_election")) then { format["The results will be announced in %1 minute/s", _next_election]} else {""};
	
	player groupChat format["You voted for %1-%2. %3", _target, (name _target), _next_election_str];
	format['if (isServer) then { [%1, %2] call interact_president_update_votes;}',_voter_number, _candidate_number] call broadcast;

	WahlSperre = true;
	sleep _sleep_time;
	WahlSperre = false;
	
};};

interact_president_update_votes = {
	private["_voter_number", "_candidate_number"];
	
	if (not(isServer)) exitWith {};
	_voter_number = _this select 0;
	_candidate_number = _this select 1;
	
	if (isNil "_voter_number") exitWith {};
	if (isNil "_candidate_number") exitWith {};
	
	if (typeName _voter_number != "SCALAR") exitWith{};
	if (typeName _candidate_number != "SCALAR") exitWith {};
	
	
	private["_i"];
	//remove the voter from all arrays first
	_i = 0;
	while { _i < (count WahlArray) } do {
		private["_array"];
		_array = (WahlArray select _i);
		if (_voter_number in _array) exitWith {
			_array = _array - [_voter_number];
			WahlArray SET [_i, _array];
		};
		_i = _i + 1;
	};

	//then add the voter to this candidate's array of voters
	WahlArray SET [_candidate_number, ((WahlArray select _candidate_number ) + [_voter_number])];
};



interact_president_change_laws = {
	private["_number", "_text"];
	
	_number = _this select 0;
	_text   = _this select 1;
	
	if (isNil "_number") exitWith {};
	if (typeName _number != "SCALAR") exitWith {};
	
	if (isNil "_text") exitWith {};
	if (typeName _text != "STRING") exitWith {};
	
	if (_number == -1) exitWith {};
	
	private["_text_length"];
	
	_text_length = [_text] call strlen;
	if (_text_length > 60) exitWith {
		player groupChat "The text for this law is too long";
	};
	
	LawsArray set [_number, _text]; 
	publicVariable "LawsArray";
	
	private["_message"];
	_message = format["Law #%1 has changed.\n%2", _number, _text];
	format['hint toString(%1);', toArray(_message)] call broadcast;
};


interact_president_change_taxes = {
	private["_item", "_mag", "_weap", "_vcl", "_bank"];
	
	_item = _this select 0;
	_mag  = _this select 1;
	_weap = _this select 2;
	_vcl  = _this select 3;
	_bank = _this select 4;
	
	format ["
		(INV_ItemTypeArray select 0) set [2, %1];
		(INV_ItemTypeArray select 1) set [2, %2];
		(INV_ItemTypeArray select 2) set [2, %3];
		(INV_ItemTypeArray select 3) set [2, %4];
		bank_tax = %5;
		hint ""The President has changed the tax rates!"";
	", _item, _vcl, _mag, _weap, _bank] call broadcast;
};

civilian_camera_cost_per_second = 1000000;

interact_civilian_camera_menu = {_this spawn {
	if (!(createDialog "civcamdialog")) exitWith {hint "Dialog Error!";};
	
	[1] call DialogCivilianPlayersList;
	lbSetCurSel    [1, 0];
	sliderSetRange [2, 5, 30];
	sliderSetSpeed [2, 1, 5];

	while {ctrlVisible 1002} do {
		private["_seconds", "_cost"];
		_seconds =  round(sliderPosition 2);
		_cost = _seconds * civilian_camera_cost_per_second;
		ctrlSetText [3, strM(_cost)]; 
		ctrlSetText [5, str(_seconds)];
	};
};};


interact_civilian_camera = {_this spawn {
	private["_player", "_target", "_watchtime"];
	
	_player = _this select 0;
	_target = _this select 1;
	_watchtime = _this select 2;

	
	if (not([_player] call player_human)) exitWith {};
	if (not([_target] call player_human)) exitWith {};
	
	if (_player != player) exitWith {};
	
	if (true) exitWith {
		player groupChat format["Civilian camera has been disabled"];
	};
	
	private["_cost"];
	_cost = _watchtime * civilian_camera_cost_per_second;
	
	private["_money"];
	_money = [_player] call player_get_total_money;
	
	
	if (_money < _cost) exitWith {
		player groupChat format["You do not have enough money to use civilian camera"];
	};
	
	[_player, _cost] call player_lose_money;
	
	
	if (not(([_target] call player_get_bounty) > 0)) exitWith {
		player groupChat format["%1-%2 cannot be watched, he is not wanted", _target, (name _target)];
	};
	
	
	private["_message"];
	_message = format["%1-%2 has paid $%3 to watch %4-%5 for %6 second/s in civilian camera!", _player, (name _player), strM(_cost), _target, (name _target), _watchtime];
	format['server globalChat toString(%1);', toArray(_message)] call broadcast;
	

	private["_tx", "_ty", "_tz", "_tpos"];
	_tpos = getPosATL _target;
	_tx = _tpos select 0;
	_ty = _tpos select 1;
	_tz = _tpos select 2;
	
	private["_camera"];
	_camera = "camera" camcreate [_tx, _ty, 15];
	
	if (not(createDialog "MainCamDialog")) exitWith {hint "Dialog Error!";};
	
	[0,0,0,["camcontrol",_camera,[10,30]]] execVM "copcams.sqf";
	
	_camera cameraEffect ["internal", "back"];
	_camera camSetPos [(getPosATL vehicle _target select 0),(getPosATL vehicle _target select 1),10];
	_camera camSetTarget vehicle _target;
	_camera camSetFOV 0.700;
	_camera camPreload 5;
	_camera camCommit 0;
	waitUntil {camCommitted _camera};
	_camera camsetpos [_tx, _ty ,10];
	_camera camSetTarget vehicle _target;
	_camera camSetFOV 0.700;
	_camera camCommit 0;
	private["_endTime"];
	_endTime = time + _watchtime;

	sliderSetRange [1055, 0, 50];
	sliderSetSpeed [1055, 100, 250];
	sliderSetPosition [1055, 10];

	private["_dx"];
	_dx = -20;

	while {(ctrlVisible 1050) and (time < _endTime)} do {
		private["_tx", "_ty", "_tpos"];
		_tpos = getPosATL (vehicle _target);
		_tx = _tpos select 0;
		_ty = _tpos select 1;
		_tz = _tpos select 2;
		_td = getDir (vehicle _target);
		
		_camera camSetTarget [(10 * sin(_td)+ _tx), (10*cos(_td)+_ty), _tz];
		_camera camSetPos [(_tx + _dx * sin(_td)), (_ty + _dx * cos(_td)), (_tz+(round(sliderPosition 1055)))];
		_camera camSetFOV 0.700;
		_camera camCommit 0;
		waituntil {camCommitted _camera};
		sleep 0.01;
	};

	setAperture -1;
	closeDialog 0;
};};

interact_warrants_menu = { _this spawn {
	if (!(createDialog "wantedrelease")) exitWith {hint "Dialog Error!";};
	[1] call DialogNotCopsList;
	lbSetCurSel [1, 0];
	[11] call DialogNotCopsList;
	lbSetCurSel [11, 0];
};};



interact_mobile_receive = {
	private["_player", "_sender", "_text"];

	_player = _this select 0;
	_sender = _this select 1;
	_text = _this select 2;
	
	if (not([_player] call player_human)) exitWith {};
	if (not([_sender] call player_human)) exitWith {};
	if (_player != player) exitWith {};
	
	private["_header"];
	_header = format["%1-%2 sent you a text message.", _sender, (name _sender)];
	
	titleText [_header + "\n" + _text, "PLAIN"];
	player groupChat (_header + " " + _text);
};

interact_mobile_send = {
	private["_player", "_target"];

	_player = _this select 0;
	_target = _this select 1;
	_text = _this select 2;
	
	if (not([_player] call player_human)) exitWith {};
	if (not([_target] call player_human)) exitWith {};
	if (_player != player) exitWith {};
	
	if (isNil "_text") exitWith {};
	if (typeName _text != "STRING") exitWith {};
	
	if (_text == "") exitWith {
		player groupChat format["You cannot send an empty message"];
	};
		
	private["_max_size"];
	_max_size = 100;
	if (([_text] call strlen) > _max_size) exitWith {
		player groupChat format["Cannot send the text message. It is longer than %1 characters.", _max_size];
	};

	
	private["_money", "_cost"];
	_money  = [player, 'money'] call INV_GetItemAmount;
	_cost = INV_smscost;
	
	
	if (_money < _cost) exitWith {
		player groupChat format["Text messages cost %1, you do not have enough money on you.", strM(INV_smscost)];
	};
	
	[_player, 'money', -(_cost)] call INV_AddInventoryItem;
	
	if (not([_target, "mobile"] call player_get_bool)) exitWith {
		player groupChat format["%1-%2 does not have a mobile phone, your text message bounced", _target, (name _target)];
	};

	player groupChat format["You sent a text message to %1-%2 for $%3", _target, (name _target), strM(_cost)];
	
	
	private["_message"];
	_message = format["%1", _text];
	format['[%1, %2, toString(%3)] spawn interact_mobile_receive;', _target, _player, toArray(_message)] call broadcast;
};

interact_mobile_use = {
	if (!(createDialog "handydialog")) exitWith {hint "Dialog Error!";};
	[2] call DialogAllPlayersList;
	lbSetCurSel [99, 0];
	ctrlSetText [4, format["Cost: $%1", INV_smscost]];
	buttonSetAction [3, '[player, (missionNamespace getVariable (lbData [2, lbCurSel 2])), (ctrlText 1)] call interact_mobile_send; closedialog 0;'];
};


interact_deposit_receive = {
	private["_player", "_sender", "_amount"];
	
	_player = _this select 0;
	_sender = _this select 1;
	_amount = _this select 2;
	
	if (not([_player] call player_human)) exitWith {};
	if (not([_sender] call player_human)) exitWith {};
	if (_player != player) exitWith {};
	
	if (isNil "_amount") exitWith {};
	if (typeName _amount != "SCALAR") exitWith {};
	if (_amount <= 0) exitWith {};
	
	[_player, _amount] call bank_transaction;
	
	player groupChat format["You received $%1 from %2-%3 on your bank account", strM(_amount), _sender, (name _sender)];
};

interact_deposit_other = {
	private["_player", "_target", "_amount"];
	
	_player = _this select 0;
	_target = _this select 1;
	_amount = _this select 2;
	
	if (not([_player] call player_human)) exitWith {};
	if (not([_target] call player_human)) exitWith {};
	if (_player != player) exitWith {};
	
	if (isNil "_amount") exitWith {};
	if (typeName _amount != "SCALAR") exitWith {};
	if (_amount <= 0) exitWith {};
	
	
	private["_player_variable", "_player_variable_name", "_bank_amount"];
	private["_tax_fee", "_total_due"];
	_tax_fee = round(_amount * (bank_tax/100));	
	_total_due = _tax_fee + _amount;
	_bank_amount = [_player] call bank_get_value;
	
	if (_bank_amount < _total_due) exitWith {
		player groupChat format["You do not have enough money in your account to send $%1, with tax fee $%2", strM(_amount), strM(_tax_fee)];
	};
	
	[_player, -(_total_due)] call bank_transaction;
	[_tax_fee] call shop_update_taxes;
	
	player groupChat format["You have sent $%1 to %2-%3, your tax fee was $%4", strM(_amount), _target, (name _target), strM(_tax_fee)];
	format['[%1, %2, %3] call interact_deposit_receive;', _target, _player, strN(_amount)] call broadcast;
};

interact_check_trx_minimum = {
	private["_amount"];
	_amount = _this select 0;
	private["_minimum"];
	_minimum = 10;
	if (_amount < _minimum) exitWith {
		player groupChat format["THe minimum about for a bank transaction is $%1", strM(_minimum)];
		true
	};
	false
};

interact_deposit_self ={
	private["_player", "_target", "_amount"];
	
	_player = _this select 0;
	_target = _this select 1;
	_amount = _this select 2;
	
	if (not([_player] call player_human)) exitWith {};
	if (not([_target] call player_human)) exitWith {};
	if (_player != player) exitWith {};
	
	if (isNil "_amount") exitWith {};
	if (typeName _amount != "SCALAR") exitWith {};
	if (_amount <= 0) exitWith {};
	
	if ([_amount] call interact_check_trx_minimum) exitWith {};
	
	private["_money"];
	_money = [player, 'money'] call INV_GetItemAmount;
	
	if (_money < _amount) exitWith {
		player groupChat format["You do not have enough money in your inventory to deposit $%1", strM(_amount)];
	};
	
	player groupChat format["You have deposited $%1 into your bank account", strM(_amount)];
	[_player, _amount] call bank_transaction;
	[_player, 'money', -(_amount)] call INV_AddInventoryItem;
};

interact_deposit = { 
	private["_player", "_target", "_amount"];
	
	_player = _this select 0;
	_target = _this select 1;
	_amount  = _this select 2;
	
	if (not([_player] call player_human)) exitWith {};
	if (not([_target] call player_human)) exitWith {};
	
	if (_player != player) exitWith {};
	
	if (isNil "_amount") exitWith {};
	if (typeName _amount != "SCALAR") exitWith {};
	if (_amount <= 0) exitWith {};
	
	if ([_amount] call interact_check_trx_minimum) exitWith {};
		
	if (_player == _target) exitWith {
		(_this call interact_deposit_self)
	};

	(_this call interact_deposit_other)	
};

interact_withdraw = { 
	private["_player", "_amount"];
	
	_player = _this select 0;
	_amount = _this select 1;
	
	if (not([_player] call player_human)) exitWith {};
	if (_player != player) exitWith {};
	
	if (isNil "_amount") exitWith {};
	if (typeName _amount != "SCALAR") exitWith {};
	if (_amount <= 0) exitWith {};
	
	if ([_amount] call interact_check_trx_minimum) exitWith {};
	
	private["_bank_amount"];
	_bank_amount = [_player] call bank_get_value;
	
	if (_amount > _bank_amount) exitWith {
		player groupChat format["You do not have enough money on your bank account to withdraw $%1", strM(_amount)];
	};
	
	[_player, -(_amount)] call bank_transaction;
	[_player, 'money', (_amount)] call INV_AddInventoryItem;
	player groupChat format["You have withdrawn $%1 from your bank account", strM(_amount)];
};

interact_atm_menu = { _this spawn {
	private["_player"];
	
	_player = _this select 0;
	if (not([_player] call player_human)) exitWith {};
	if (_player != player) exitWith {};

	if (local_robbsperre == 1)  exitWith {
		player groupChat format ["You robbed the bank a few minutes ago. You can not use it for %1 minutes after you robbed it.", strM(local_robbsperre_zeit)];
	};

	if (!(createDialog "bank")) exitWith {hint "Dialog Error!";};

	private["_my_index"];

	_my_index = [1] call DialogAllPlayersList;

	if (_my_index >= 0) then {
		lbSetCurSel [1, _my_index];
	};
	
	buttonSetAction [10, format["[%1, (missionNamespace getVariable(lbData [1, lbCurSel 1])), ([ctrlText 2] call parse_number)] call interact_deposit; closedialog 0;", _player] ];
	buttonSetAction [11, format["[%1, ([ctrlText 6] call parse_number)] call interact_withdraw; closedialog 0;", _player] ];

	while {ctrlVisible 1003} do {
		private["_money", "_bank"];
		_money = [player, "money"] call INV_GetItemAmount;
		_bank = [player] call bank_get_value;
		CtrlSetText [101, format ["Money in your Inventory: $%1", strM(_money)]];
		CtrlSetText [102, format ["Money in your Account: $%1", strM(_bank)]];
		private["_amount"];
		_amount = [ctrlText 2] call parse_number;
		if (_amount < 0) then {_amount = 0};
		
		if ((lbCurSel 1) == _my_index) then {
			CtrlSetText [4,""];
			CtrlSetText [5,""];
		}
		else {
			CtrlSetText [4, "Incl. Taxes:"];
			CtrlSetText [5, format ["$%1", strM(_amount + round(_amount * (bank_tax/100)))]];
		};
		sleep 0.3;
	};
};};

interact_toggle_side_markers = {
	private["_player"];
	_player = _this select 0;
	
	if (isNil "_player") exitWith {};
	if (_player != player) exitWith {};
	
	private["_sidemarkers"];
	_sidemarkers = [_player, "sidemarkers"] call player_get_bool;
	_sidemarkers = not(_sidemarkers);
	[_player, "sidemarkers", _sidemarkers] call player_set_bool;
	
	if (not(_sidemarkers)) then {
		player groupChat format["Side markers disabled"];
	}
	else {
		player groupChat format["Side markers enabled"];
	};
};



interact_inventory_menu = {
	private["_player"];
	_player = _this select 0;
	if (not([_player] call player_human)) exitWith {};
	if (!(createDialog "inventar")) exitWith {hint "Dialog Error!";};

	private["_itemcounter"];
	_itemcounter = 0;

	private["_i"];
	_i = 0;
	private["_inventory"];
	_inventory = [_player] call player_get_inventory;
	while { _i < (count _inventory) } do {
		private ["_item", "_number", "_lbl_name"];
		_item = ((_inventory select _i) select 0);
		_number = ([player, _item] call INV_GetItemAmount);

		if (_number > 0) then {
			_lbl_name = (_item call INV_GetItemName);
			_index = lbAdd [1, format ["%1",_lbl_name]];
			lbSetData [1, _index, _item];
			_itemcounter = _itemcounter + 1;
		};
		_i = _i + 1;
	};

	if (_itemcounter == 0) exitWith {
		player groupChat format["Your inventory is empty"];
	};

	private["_c"];
	_c = 0;
	while { _c < (count playerstringarray) } do {
		private["_player_variable_name", "_player_variable"];
		_player_variable_name = playerstringarray select _c;
		_player_variable = missionNamespace getVariable _player_variable_name;
		//player groupChat format["_player_variable_name = %1", _player_variable_name];
		
		if ([_player_variable] call player_human) then {
			private["_player_name"];
			_player_name = (name _player_variable);
			_index = lbAdd [99, format ["%1 - (%2)", _player_variable_name, _player_name]];
			lbSetData [99, _index, format["%1", _c]];
		};
		_c = _c + 1;
	};

	lbSetCurSel [99, 0];
	lbSetCurSel [1, 0];
	buttonSetAction [3,format["[""use"",  lbData [1, (lbCurSel 1)], ctrlText 501, lbData [99, (lbCurSel 99)]] execVM ""INVactions.sqf""; closedialog 0;"] ];
	buttonSetAction [4,format["[""drop"", lbData [1, (lbCurSel 1)], ctrlText 501, lbData [99, (lbCurSel 99)]] execVM ""INVactions.sqf""; closedialog 0;"] ];
	buttonSetAction [246,format["[""give"", lbData [1, (lbCurSel 1)], ctrlText 501, lbData [99, (lbCurSel 99)]] execVM ""INVactions.sqf""; closedialog 0;"] ];

	while {ctrlVisible 1001} do {
		_item   = lbData [1, (lbCurSel 1)];
		_number = [player, _item]  call INV_GetItemAmount;
		_array  = _item call INV_GetItemArray;

		ctrlSetText [62,  format ["%1", strN(_number)]];
		ctrlSetText [52,  format ["%1", _array call INV_GetItemName]];
		ctrlSetText [72,  format ["%1", _array call INV_GetItemDescription1]];
		ctrlSetText [7,   format ["%1", _array call INV_GetItemDescription2]];
		ctrlSetText [202, format ["%1/%2", (_array call INV_GetItemTypeKg), strN(((_array call INV_GetItemTypeKg)*(_number)))]];
		
		sleep 0.1;
	};
};

interact_check_distance = {
	private["_player", "_target", "_interaction"];
	_player = _this select 0;
	_target = _this select 1;
	_interaction = _this select 2;

	if (not([_player] call player_human)) exitWith {};
	if (not([_target] call player_human)) exitWith {};
	if (isNil "_interaction") exitWith {};
	if (typeName _interaction != "STRING") exitWith {};
	
	private["_distance"];
	_distance = _player distance _target;
	
	if ((_distance > 5)) exitWIth {
		player groupChat format["You cannot %1 %2-%3, you are too far", _interaction, _target, (name _target)];
		false
	};

	if (not(alive _target)) exitWith {
		player groupChat format["You cannot %1 %2-%3, he is dead", _interaction, _target, (name _target)];
		false
	};
	
	true	
};

interact_check_armed = {
	private["_player", "_target", "_interaction"];
	_player = _this select 0;
	_target = _this select 1;
	_interaction = _this select 2;

	if (not([_player] call player_human)) exitWith {};
	if (not([_target] call player_human)) exitWith {};
	if (isNil "_interaction") exitWith {};
	if (typeName _interaction != "STRING") exitWith {};

	
	if (not([player] call check_armed_player)) exitWith {
		player groupChat format["You cannot %1 %2-%3, you are not armed", _interaction, _target, (name _target)];
		false
	};
	
	true
};


//HEALING
interact_heal_player = {
	private["_player", "_target"];
	_player = _this select 0;
	_target = _this select 1;
	
	if (not([_player] call player_human)) exitWith {};
	if (not([_target] call player_human)) exitWith {};
	
	private["_interaction"];
	_interaction = "heal";
	if (not([_player, _target, _interaction] call interact_check_distance)) exitWith {};
	
	player groupChat format["You healed %1-%2", _target, (name _target)];
	format['[%1, %2] call interact_heal_receive;', _player, _target] call broadcast;
};

interact_heal_receive = {
	private["_player", "_target"];
	_player = _this select 0;
	_target = _this select 1;
	
	if (not([_player] call player_human)) exitWith {};
	if (not([_target] call player_human)) exitWith {};
	
	if (_target != player) exitWith {};
	
	player setDamage 0;
	player groupChat format["%1-%2 healed you", _player, (name _player)];
};


//////////////////// CHECK INVENTORY ////////////////////

interact_check_inventory = {
	private["_player", "_target"];
	_player = _this select 0;
	_target = _this select 1;
	
	if (not([_player] call player_human)) exitWith {};
	if (not([_target] call player_human)) exitWith {};
	
	if (_player != player) exitWith {};
	
	private["_interaction"];
	_interaction = "search";
	if (not([_player, _target, _interaction] call interact_check_distance)) exitWith {};
	if (not([_player, _target, _interaction] call interact_check_armed)) exitWith {};
	

	if(!([_target] call player_vulnerable))exitwith{
		player groupChat format["%1-%2 does not have his hands up, or is subdued", _target, (name _target)];
	};
	
	format['[%1, %2] call interact_check_inventory_receive;', _player, _target] call broadcast;
};


interact_check_inventory_response = {
	private["_player", "_target", "_licenses", "_inventory"];
	_player = _this select 0;
	_target = _this select 1;
	_licenses = _this select 2;
	_inventory = _this select 3;
	
	if (not([_player] call player_human)) exitWith {};
	if (not([_target] call player_human)) exitWith {};
	if (isNil "_licenses") exitWith {};
	if (typeName _licenses != "ARRAY") exitWith {};
	if (isNil "_inventory") exitWith {};
	if (typeName _inventory != "ARRAY") exitWith {};
	
	if (_player != player) exitWith {};
	
	[0, 0, 0, ["inventorycheck", _licenses, _inventory, _target]] execVM "maindialogs.sqf";
};

interact_check_inventory_receive = {
	private["_player", "_target"];
	_player = _this select 0;
	_target = _this select 1;
	
	if (not([_player] call player_human)) exitWith {};
	if (not([_target] call player_human)) exitWith {};
	if (_target != player) exitWith {};
	
	private["_inventory", "_licenses"];
	_inventory = [_target] call player_get_inventory;
	_licenses = [_target, "INV_LicenseOwner"] call player_get_array;
	format['[%1, %2, %3, %4] call interact_check_inventory_response;', _player, _target, _licenses, _inventory] call broadcast;
};


//////////////////// ROBBING ////////////////////

interact_rob_inventory = {
	private["_player", "_target"];
	_player = _this select 0;
	_target = _this select 1;
	
	if (not([_player] call player_human)) exitWith {};
	if (not([_target] call player_human)) exitWith {};
	
	if (_player != player) exitWith {};
	
	private["_interaction"];
	_interaction = "rob";
	if (not([_player, _target, _interaction] call interact_check_distance)) exitWith {};
	if (not([_player, _target, _interaction] call interact_check_armed)) exitWith {};
	
	
	private["_near_cops"];
	if (([player, 40] call player_near_cops) && not([_target] call player_cop)) then {
		player groupChat format["You cannot rob %1-%2, there is a cop near", _target, (name _target)];
	};
	
	if (not([_target] call player_vulnerable)) exitWith {
		player groupChat format["%1-%2 does not have his hands up, or is not subdued", _target, (name _target)];
	};

	format['[%1, %2] call interact_rob_inventory_receive;', _player, _target] call broadcast;
};


interact_rob_inventory_response = {
	private["_player", "_target", "_amount"];
	_player = _this select 0;
	_target = _this select 1;
	_amount = _this select 2;
	
	if (not([_player] call player_human)) exitWith {};
	if (not([_target] call player_human)) exitWith {};
	if (isNil "_amount") exitWith {};
	if (typeName _amount != "SCALAR") exitWith {};
	if (_amount <= 0) exitWith {};
	
	if (_player != player) exitWith {};
	
	[_player, "money", _amount] call INV_AddInventoryItem;
};

interact_rob_inventory_receive = {
	private["_player", "_target"];
	_player = _this select 0;
	_target = _this select 1;
	
	if (not([_player] call player_human)) exitWith {};
	if (not([_target] call player_human)) exitWith {};
	
	if (_target != player) exitWith {};
	
	private["_money"];
	_money  = [player, 'money'] call INV_GetItemAmount;
	
	private["_amount"];
	_amount = (floor(random _money));
	[_target, "money", -(_amount)] call INV_AddInventoryItem;
	
	if (stolenfromtimeractive || (_money <= 0) || (_amount <= 0)) exitwith {
		[_player, format["(failed-armed-robbery, %1-%2)", _target, (name _target)], 20000] call player_update_warrants;
		
		private["_message"];
		_message = format["%1-%2 attemted to rob %3-%4 but failed", _player, (name _player), _target, (name _target)];
		format['hint toString(%1);', toArray(_message)] call broadcast;
	};
	
	format['[%1, %2, %3] call interact_rob_inventory_response;', _player, _target, _amount] call broadcast;
	[_player, format["(armed-robbery, %1-%2)", _target, (name _target)], _amount] call player_update_warrants;
	
	private["_message"];
	_message = format["%1-%2 stole $%3 from %4-%5", _player, (name _player), strM(_amount), _target, (name _target)];
	format['hint toString(%1);', toArray(_message)] call broadcast;
	
	[] spawn {
		stolenfromtimeractive = true;
		sleep stolenfromtime;
		stolenfromtimeractive = false;
	};
};

//////////////////// DRUG SEARCHING ////////////////////

interact_drug_search = {
	private["_player", "_target"];
	_player = _this select 0;
	_target = _this select 1;
	
	if (not([_player] call player_human)) exitWith {};
	if (not([_target] call player_human)) exitWith {};
	
	if (_player != player) exitWith {};
	
	private["_interaction"];
	_interaction = "search";
	if (not([_player, _target, _interaction] call interact_check_distance)) exitWith {};
	if (not([_player, _target, _interaction] call interact_check_armed)) exitWith {};

	format['[%1, %2] call interact_drug_search_receive;', _player, _target] call broadcast;
};

interact_drug_search_response = {
	private["_player", "_target", "_amount"];
	_player = _this select 0;
	_target = _this select 1;
	_amount = _this select 2;
	
	if (not([_player] call player_human)) exitWith {};
	if (not([_target] call player_human)) exitWith {};
	if (isNil "_amount") exitWith {};
	if (typeName _amount != "SCALAR") exitWith {};
	
	if (_amount < 0) exitWith {};
	
	if (_player != player) exitWith {};
	
	_amount = round(_amount);
	
	if (_amount == 0) exitWith {
		player groupChat format["%1-%2 does not have any drugs", _target, (name _target)];
	};
	
	private["_message"];
	_message = format["%1-%2 had drugs, you removed them. You should arrest %1-%2 or give him a ticket of $%3. ", _target, (name _target), strM(_amount/2)];
	player groupChat _message;
	
	_message = format["%1-%2 had $%3 worth of drugs!", _target, (name _target), strM(_amount)];
	format['titleText [toString(%1), "PLAIN"];', toArray(_message)] call broadcast;	
};

interact_drug_search_count = {
	private["_target"];
	_target = _this select 0;
	
	if (not([_target] call player_human)) exitWith {0};
	if (_target != player) exitWith {0};

	private["_i", "_drugs_value"];
	_drugs_value = 0;
	_i = 0;
	
	private["_inventory"];
	_inventory = [_target] call player_get_inventory;
	
	while { _i <  (count _inventory) } do {
		private["_item", "_infos"];
		_item   = ((_inventory select _i) select 0);
		_infos  = _item call INV_GetItemArray;
		
		if(_item call INV_GetItemKindOf == "drug") then {
			private["_amount", "_price"];
			_amount = ([player, _item] call INV_GetItemAmount);
			_price  = (_infos call INV_GetItemBuyCost);
			_drugs_value = _drugs_value + (_price*_amount);
		};
		_i = _i + 1;
	};
	
	_drugs_value
};

interact_drug_search_receive = {
	private["_player", "_target"];
	_player = _this select 0;
	_target = _this select 1;
	
	if (not([_player] call player_human)) exitWith {};
	if (not([_target] call player_human)) exitWith {};
	
	if (_target != player) exitWith {};
	

	private["_drugs_value"];
	_drugs_value = [_target] call interact_drug_search_count;
	
	if (_drugs_value <= 0) exitWith {
		format['[%1, %2, 0] call interact_drug_search_response;', _player, _target] call broadcast;
	};
	
	[_target, ([_target] call player_inventory_name), "drug"] call INV_StorageRemoveKindOf;
	[_target, "(drug-possession)", _drugs_value] call player_update_warrants;
	
	
	format['[%1, %2, %3] call interact_drug_search_response;', _player, _target, strN(_drugs_value)] call broadcast;
	player groupChat format["%1-%2 removed your drugs", _player, (name _player)];;
};


//////////////////// DISARMING ////////////////////

interact_disarm = {
	private["_player", "_target"];
	_player = _this select 0;
	_target = _this select 1;
	
	if (not([_player] call player_human)) exitWith {};
	if (not([_target] call player_human)) exitWith {};
	
	if (_player != player) exitWith {};
	
	private["_interaction"];
	_interaction = "disarm";
	if (not([_player, _target, _interaction] call interact_check_distance)) exitWith {};
	if (not([_player, _target, _interaction] call interact_check_armed)) exitWith {};
	
	
	if(not([_target] call player_vulnerable)) exitWith {
		player groupChat format["You cannot disarm %1-%2, he is not subdued", _target, (name _target)];
	};
	
	private["_weapons"];
	_weapons = (weapons _target);
	if (count _weapons == 0) exitWith {
		player groupChat format["%1-%2 is not armed!", _target, (name _target)];
	};

	private["_message"];
	_message = format["%1-%2 disarmed %3-%4", _player, (name _player), _target, (name _target)];
	format['server globalChat toString(%1);', toArray(_message)] call broadcast;
	
	format['[%1, %2] call interact_disarm_receive;', _player, _target] call broadcast;
};


interact_disarm_receive = {
	private["_player", "_target"];
	_player = _this select 0;
	_target = _this select 1;
	
	if (not([_player] call player_human)) exitWith {};
	if (not([_target] call player_human)) exitWith {};
	
	if (_target != player) exitWith {};
	
	private["_weapons"];
	_weapons = (weapons _target) - nonlethalweapons;
	if (count _weapons > 0) then {
		{_target removeWeapon _x} forEach _weapons;
	};
	
	[_target] call INV_RemoveIllegal;
};

//////////////////// TICKETING ////////////////////

interact_ticket = {
	private["_player", "_target", "_amount"];
	_player = _this select 0;
	_target = _this select 1;
	_amount = _this select 2;
	
	if (not([_player] call player_human)) exitWith {};
	if (not([_target] call player_human)) exitWith {};
	if (_amount <= 0) exitWith {};
	
	if (_player != player) exitWith {};
	
	_amount = round(_amount);
	
	private["_interaction"];
	_interaction = "ticket";
	if (not([_player, _target, _interaction] call interact_check_distance)) exitWith {};
	if (not([_player, _target, _interaction] call interact_check_armed)) exitWith {};
	
	private["_message"];
	_message = format["%1-%2 gave a %3-%4 a ticket of $%5", _player, (name _player), _target, (name _target), strM(_amount)];
	format['server globalChat toString(%1);', toArray(_message)] call broadcast;
	format['[%1, %2, %3] call interact_ticket_receive;', _player, _target, _amount] call broadcast;
};


interact_ticket_distribute = {
	private["_player", "_target", "_amount"];
	_player = _this select 0;
	_target = _this select 1;
	_amount = _this select 2;
	
	if (not([_player] call player_human)) exitWith {};
	if (not([_target] call player_human)) exitWith {};
	if (_amount <= 0) exitWith {};
	
	if (not(iscop)) exitWith {
		_message = format["%1-%2 paid %3-%4's ticket of $%5", _target, (name _target), _player, (name _player), strM(_amount)];
		server globalChat _message;
	};
	
	private["_cop_count", "_cop_money"];
	_cop_count = playersNumber west;
	_cop_money = round(_amount / _cop_count);
	player groupChat format["You got $%1 because %2-%3 paid %4-%5's ticket of $%6", _cop_money, _target, (name _target), _player, (name _player), strM(_amount)];
	[player, _cop_money] call bank_transaction;
};

interact_ticket_receive = { _this spawn {
	private["_player", "_target", "_amount"];
	_player = _this select 0;
	_target = _this select 1;
	_amount = _this select 2;
	
	if (not([_player] call player_human)) exitWith {};
	if (not([_target] call player_human)) exitWith {};
	if (_amount <= 0) exitWith {};
	
	if (_target != player) exitWith {};
	
	_amount = round(_amount);

	response = false;
	if (!(createDialog "ja_nein")) exitWith {hint "Dialog Error!"};
	ctrlSetText [1, format["%1-%2 gave you a ticket of $%3. Do you agree to pay?", _player, (name _player), strM(_amount)]];
	waitUntil{(not(ctrlVisible 1023))};
	
	if (not(response)) exitWith {
		private["_message"];
		_message = format["%1-%2 did not agree to pay %3-%4's ticket of $%5", _target, (name _target), _player, (name _player), strM(_amount)];
		format['server globalChat toString(%1);', toArray(_message)] call broadcast;
	};

	private ["_player_money"];
	_player_money = [_target] call player_get_total_money;
		
	if (_amount > _player_money ) exitWith {
		private["_message"];
		_message = format["%1-%2 did not have enough money to pay %3-%4's ticket of $%5", _target, (name _target), _player, (name _player), strM(_amount)];
		format['server globalChat toString(%1);', toArray(_message)] call broadcast;
	};

	[_target, _amount] call player_lose_money;
	format['[%1, %2, %3] call interact_ticket_distribute;', _player, _target, _amount] call broadcast;
};};



interact_side_ai_magazines = {
	private["_side"];
	_side = _this select 0;
	if (isNil "_side") exitWith {[]};
	if (typeName _side != "SIDE") exitWith {[]};
	
	if (_side == west) exitWith { backup_cop_magazines };
	if (_side == east) exitWith { backup_opf_magazines };
	if (_side == resistance ) exitWith { backup_ins_magazines };
	
	[]
};

interact_side_ai_weapons = {
	private["_side"];
	_side = _this select 0;
	if (isNil "_side") exitWith {[]};
	if (typeName _side != "SIDE") exitWith {[]};
	
	if (_side == west) exitWith { backup_cop_weapons };
	if (_side == east) exitWith { backup_opf_weapons };
	if (_side == resistance ) exitWith { backup_ins_weapons };
	[]
};

interact_side_ai_class = {
	private["_side"];
	_side = _this select 0;
	if (isNil "_side") exitWith {""};
	if (typeName _side != "SIDE") exitWith {""};
	
	if (_side == west) exitWith {"UN_CDF_Soldier_EP1"};
	if (_side == east) exitWith {"TK_Soldier_EP1"};
	if (_side == resistance) exitWith {"TK_GUE_Soldier_EP1"};
	""
};

interact_recruit_ai_receive = {
	if (not(isServer)) exitWith {};
	private["_player"];
	
	player groupChat format["interact_recruit_ai_receive %1", _this];
	
	_player = _this select 0;
	if (not([_player] call player_human)) exitWith {};

	private["_class"];
	_class = [([_player] call player_side)] call interact_side_ai_class;
	
	private["_unit"];
	_unit = (group _player) createUnit [_class, position _player, [], 0, "FORM"];
	[_unit] joinSilent (group _player);
	
	private["_unit_name"];
	_unit_name = format["%1_Troop_%2_%3", str(_player), (count (units (group _player))), round(time)];

	_unit setVehicleInit format[
	'
		this setVehicleVarName "%1";
		%1 = this;
	', _unit_name];

	processInitCommands;

	_unit = missionNamespace getVariable _unit_name;
	_backup = call compile format["%1", _varName];

	private["_side_ai_weapons", "_side_ai_magazines"];
	
	_side_ai_weapons = [([_player] call player_side)] call interact_side_ai_weapons;
	_side_ai_magazines = [([_player] call player_side)] call interact_side_ai_magazines;
	
	[_unit] call player_reset_gear;
	{ _unit addWeapon _x } forEach _side_ai_weapons;
	{ _unit addMagazine _x } forEach _side_ai_magazines;
	
	reload _unit;
	_unit addMPEventHandler ["MPKilled", { _this call player_handle_mpkilled }];
};

interact_recruit_ai = { _this spawn {
	private["_player"];
	_player = _this select 0;
	if (not([_player] call player_human)) exitWith {};
	
	interact_recruit_ai_busy = if (isNil "interact_recruit_ai_busy") then { false } else {interact_recruit_ai_busy};
	
	if (interact_recruit_ai_busy) exitWith {
		player groupChat format["Already recruiting AI"];
	};
	
	interact_recruit_ai_busy = true;
	
	private["_money"];
	_money = [_player, 'money'] call INV_GetItemAmount;

	if (_money < 200000) exitWith {
		player groupChat "Not Enough Money";
		interact_recruit_ai_busy = false;
	};

	if (count (units group player) >= 8) exitWith {
		player groupChat "Squad Is Full"; 
		interact_recruit_ai_busy = false;
	};

	[_player, 'money', -(200000)] call INV_AddInventoryItem;
	player groupChat "Recruiting soldier";

	format['[%1] call interact_recruit_ai_receive;', _player] call broadcast;
	sleep 1;
	interact_recruit_ai_busy = false;
};};


interact_stranded_check = { 
	private["_player"];
	_player = _this select 0;
	if ([_player] call player_get_dead) exitWith {};
	if (not([_player] call player_stranded)) exitWith {};
	
	response = false;
	if (!(createDialog "ja_nein")) exitWith {hint "Dialog Error!";};
	
	ctrlSetText [1, format["Hey there, looks like you are stranded. Do you want to quickly respawn? Note that as a penalty, you will lose your gear, and inventory."]];
	waitUntil{(not(ctrlVisible 1023))};
	
	if (response) then {
		titleText ["", "BLACK OUT", 1];
		sleep 1;
		[_player] call player_teleport_spawn;
		[_player] call player_reset_gear;
		[_player] call player_reset_side_inventory;
		titleText ["", "BLACK IN", 1];
	}
	else {
		player groupChat "Good luck, may the force be with you!";
	};
};


interact_generic_storage_menu = { _this spawn {
	private["_left_button_code", "_right_button_code", 
			"_left_label_code", "_right_label_code", 
			"_left_list_code", "_right_list_code", 
			"_right_selection_code", "_left_selection_code"];
	
	_left_button_code = _this select 0;
	_left_selection_code = _this select 1;
	_left_list_code = _this select 2;
	_left_label_code = _this select 3;
	
	_right_button_code = _this select 4;
	_right_selection_code = _this select 5;
	_right_list_code = _this select 6;
	_right_label_code = _this select 7;
	
	if (isNil "_left_button_code") exitWith {};
	if (isNil "_left_selection_code") exitWith {};
	if (isNil "_left_list_code") exitWith {};
	if (isNil "_left_label_code") exitWith {};
	
	if (isNil "_right_button_code") exitWith {};
	if (isNil "_right_selection_code") exitWith {};
	if (isNil "_right_list_code") exitWith {};
	if (isNil "_right_label_code") exitWith {};
	
	if (typeName _left_button_code != "CODE") exitWith {};
	if (typeName _left_selection_code != "CODE") exitWith {};
	if (typeName _left_list_code != "CODE") exitWith {};
	if (typeName _left_label_code != "CODE") exitWith {};
	
	if (typeName _right_button_code != "CODE") exitWith {};
	if (typeName _right_selection_code != "CODE") exitWith {};
	if (typeName _right_list_code != "CODE") exitWith {};
	if (typeName _right_label_code != "CODE") exitWith {};
	
	if (!(createDialog "itemkaufdialog")) exitWith {hint "Dialog Error!";};
	disableSerialization;

	private["_display"];
	lbClear 1;
	lbClear 101;

	[_object, _arrname] call INV_CheckArray;
	_arr = _object getVariable _arrname;
	//player groupChat format["_arr = %1", _arr];

	CtrlSetText [91,localize "Take Items"];
	CtrlSetText [92,localize "Store Items"];
	
	CtrlSetText [765, (call _left_label_code)];
	CtrlSetText [100, (call _right_label_code)];

	private["_left_list"];
	_left_list = call _left_list_code;
	
	private["_right_list"];
	_right_list = call _right_list_code;
	
	{
		private["_index", "_text", "_value", "_entry"];
		_entry = _x;
		_text = _entry select 0;
		_value = _entry select 1;
		_index = lbAdd [1, _text];
		lbSetData [1, _index, _value];
	} forEach _left_list;
	
	{
		private["_index", "_text", "_value", "_entry"];
		_entry = _x;
		_text = _entry select 0;
		_value = _entry select 1;
		_index = lbAdd [101, _text];
		lbSetData [101, _index, _value];
	} forEach _right_list;
	

	buttonSetAction [3, format['[(lbData [1, (lbCurSel 1)]), ([(ctrlText 2)] call parse_number)] call %1', _left_button_code]];
	buttonSetAction [103, format['[(lbData [101, (lbCurSel 101)]), ([(ctrlText 102)] call parse_number)] call %1', _right_button_code]];

	while {ctrlVisible 1015} do {
		private["_left_selection"];
		_left_selection_index = (lbCurSel 1);

		if (_left_selection_index >= 0) then {
			private["_left_selection_value", "_left_amount"];
			_left_amount =  [(ctrlText 2)] call parse_number;
			_left_selection_value  = lbData [1, (lbCurSel 1)];
			CtrlSettext [3,  [_left_selection_value, _left_amount] call _left_selection_code];
		}
		else {
			CtrlSettext [3,  "/"];
		};
		
		private["_right_selection_index"];
		_right_selection_index = (lbCurSel 101);

		if (_right_selection_index >= 0) then {
			private["_right_selection_value", "_right_amount"];
			_right_selection_value = lbData [101, (lbCurSel 101)];
			_right_amount = [(ctrlText 102)] call parse_number;
			CtrlSettext [103,  [_right_selection_value, _right_amount] call _right_selection_code];
		}
		else {
			CtrlSettext [103,  "/"];
		};
		sleep 0.3;
	};

};};

interact_generate_storage_list_code = {
	private["_object", "_storage"];
	_object = _this select 0;
	_storage = _this select 1;
	
	if (isNil "_object") exitWith {{}};
	if (isNil "_storage") exitWith {{}};
	if (typeName _object != "OBJECT") exitWith {{}};
	if (typeName _storage != "STRING") exitWith {{}};

	private["_code"];
	_code = compile format[
	'
		_entries = [];
		{
			private["_entry", "_item", "_count","_text", "_item_weight", "_infos", "_name"];
			_entry = _x;
			_item = _entry select 0;
			_count = [(_entry select 1)] call decode_number;
			_infos  = _item call INV_GetItemArray;
			_item_weight = (_infos call INV_GetItemTypeKg);
			_name = (_infos call INV_GetItemName);
			if (_count > 0 && (_infos call INV_GetItemDropable)) then {
				_text = _name + " (" + strM(_count) + " - " + str(_item_weight * _count ) + "Kg)";
				_entries = _entries + [[_text, _item]];	
			};
		} forEach (%1 getVariable "%2");
		(_entries)
	', _object, _storage];
	
	_code
};

interact_generate_selection_code = {
	private["_action"];
	_action = _this select 0;
	if (isNil "_action") exitWith {{""}};
	if (typeName _action != "STRING") exitWith {{""}};
	
	private["_code"];
	_code = compile format[
	' 
		private["_item", "_count"];
		_item = _this select 0;
		_count = _this select 1;
		private["_infos", "_weight", "_text"];
		_infos  = _item call INV_GetItemArray;
		_weight = (_infos call INV_GetItemTypeKg) * _count;
		_text = ("%1 " + strM(_count) + " Item(s) (" + strM(_weight) + "Kg)");
		(_text)
	', _action];
	
	_code
};

interact_private_storage_menu = {
	private["_player"];
	
	_player = _this select 0;
	if (not([_player] call player_exists)) exitWith {};

	private["_private_storage_name", "_player_storage_name"];
	_private_storage_name = "private_storage";
	_player_storage_name = ([_player] call object_storage_name);
	
	private["_left_button_code", "_right_button_code", 
			"_left_label_code", "_right_label_code", 
			"_left_list_code", "_right_list_code", 
			"_right_selection_code", "_left_selection_code"];
			
	_left_list_code = [_player, _private_storage_name] call interact_generate_storage_list_code;
	_right_list_code = [_player, _player_storage_name] call interact_generate_storage_list_code;
	
	_left_selection_code = ["Take"] call interact_generate_selection_code;
	_right_selection_code = ["Put"] call interact_generate_selection_code;
	
	_left_button_code = compile format['
		private["_item", "_count"];
		_item = _this select 0;
		_count = _this select 1;
		if (_count <= 0) exitWith {};
		[%1, "%2", _item, -(_count)] call interact_generic_storage;
	', _player, _private_storage_name];
	
	_right_button_code = compile format['
		private["_item", "_count"];
		_item = _this select 0;
		_count = _this select 1;
		if (_count <= 0) exitWith {};
		[%1, "%2", _item, _count] call interact_generic_storage;	
	', _player, _private_storage_name];
	
	
	_left_label_code = compile format['
		private["_class", "_player", "_max_weight", "_weight"];
		_player = %1;
		_storage = "%2";
		_weight = [_player, _storage] call INV_GetStorageWeight;
		("Storage " + strM(_weight) + "/Unlimited" )
	', _player, _private_storage_name];
	
	_right_label_code = compile format['
		private["_class", "_player", "_max_weight", "_weight"];
		_player = %1;
		_storage = "%2";
		_weight = [_player, _storage] call INV_GetStorageWeight;
		_max_weight = INV_CarryingCapacity;
		("Inventory " + strM(_weight) + "/" + strM(_max_weight))
	', _player, _player_storage_name];
	
	[
		_left_button_code, _left_selection_code, _left_list_code, _left_label_code,
		_right_button_code, _right_selection_code, _right_list_code, _right_label_code 
	] call interact_generic_storage_menu;
};

factory_storage_menu = {
	//player groupChat format["factory_storage_menu %1", _this];
	private["_player", "_factory_storage_name"];
	
	_player = _this select 0;
	_factory_storage_name = _this select 1;
	if (not([_player] call player_exists)) exitWith {};
	if (isNil "_factory_storage_name") exitWIth {};
	if (typeName _factory_storage_name != "STRING") exitWith {};

	private["_player_storage_name"];
	_player_storage_name = ([_player] call object_storage_name);
	
	private["_left_button_code", "_right_button_code", 
			"_left_label_code", "_right_label_code", 
			"_left_list_code", "_right_list_code", 
			"_right_selection_code", "_left_selection_code"];
			
	_left_list_code = [_player, _factory_storage_name] call interact_generate_storage_list_code;
	_right_list_code = [_player, _player_storage_name] call interact_generate_storage_list_code;
	
	_left_selection_code = ["Take"] call interact_generate_selection_code;
	_right_selection_code = ["Put"] call interact_generate_selection_code;
	
	_left_button_code = compile format['
		private["_item", "_count"];
		_item = _this select 0;
		_count = _this select 1;
		if (_count <= 0) exitWith {};
		[%1, "%2", _item, -(_count)] call interact_factory_storage;
	', _player, _factory_storage_name];
	
	_right_button_code = compile format['
		private["_item", "_count"];
		_item = _this select 0;
		_count = _this select 1;
		if (_count <= 0) exitWith {};
		[%1, "%2", _item, _count] call interact_factory_storage;	
	', _player, _factory_storage_name];
	
	_left_label_code = compile format['
		private["_class", "_player", "_max_weight", "_weight"];
		_player = %1;
		_storage = "%2";
		_weight = [_player, _storage] call INV_GetStorageWeight;
		("Storage " + strM(_weight) + "/Unlimited" )
	', _player, _factory_storage_name];
	
	_right_label_code = compile format['
		private["_class", "_player", "_max_weight", "_weight"];
		_player = %1;
		_storage = "%2";
		_weight = [_player, _storage] call INV_GetStorageWeight;
		_max_weight = INV_CarryingCapacity;
		("Inventory " + strM(_weight) + "/" + strM(_max_weight))
	', _player, _player_storage_name];
	
	[
		_left_button_code, _left_selection_code, _left_list_code, _left_label_code,
		_right_button_code, _right_selection_code, _right_list_code, _right_label_code 
	] call interact_generic_storage_menu;
};

interact_vehicle_storage_menu = {
	private["_player", "_vehicle"];
	
	_player = _this select 0;
	_vehicle = _this select 1;
	
	if (not([_player] call player_exists)) exitWith {};
	if (not([_vehicle] call vehicle_exists)) exitWith {};
	
	private["_vehicle_storage_name", "_player_storage_name"];
	_vehicle_storage_name = ([_vehicle] call object_storage_name);
	_player_storage_name = ([_player] call object_storage_name);
	
	private["_left_button_code", "_right_button_code", 
			"_left_label_code", "_right_label_code", 
			"_left_list_code", "_right_list_code", 
			"_right_selection_code", "_left_selection_code"];
			
	_left_list_code = [_vehicle, _vehicle_storage_name] call interact_generate_storage_list_code;
	_right_list_code = [_player, _player_storage_name] call interact_generate_storage_list_code;
	
	_left_selection_code = ["Take"] call interact_generate_selection_code;
	_right_selection_code = ["Put"] call interact_generate_selection_code;
	
	_left_button_code = compile format['
		private["_item", "_count"];
		_item = _this select 0;
		_count = _this select 1;
		if (_count <= 0) exitWith {};
		[%1, _item, -(_count)] call interact_vehicle_storage;
	', _vehicle];
	
	_right_button_code = compile format['
		private["_item", "_count"];
		_item = _this select 0;
		_count = _this select 1;
		if (_count <= 0) exitWith {};
		[%1, _item, _count] call interact_vehicle_storage;
	', _vehicle];
	
	_left_label_code = compile format['
		private["_class", "_vehicle", "_max_weight", "_weight"];
		_vehicle = %1;
		_storage = "%2";
		_class = typeOf _vehicle;
		_weight = [_vehicle, _storage] call INV_GetStorageWeight;
		_max_weight = _class call INV_GetVehMaxKg;
		("Trunk " + strM(_weight) + "/" + strM(_max_weight))
	', _vehicle, _vehicle_storage_name];
	
	_right_label_code = compile format['
		private["_class", "_player", "_max_weight", "_weight"];
		_player = %1;
		_storage = "%2";
		_weight = [_player, _storage] call INV_GetStorageWeight;
		_max_weight = INV_CarryingCapacity;
		("Inventory " + strM(_weight) + "/" + strM(_max_weight))
	', _player, _player_storage_name];
	
	[
		_left_button_code, _left_selection_code, _left_list_code, _left_label_code,
		_right_button_code, _right_selection_code, _right_list_code, _right_label_code 
	] call interact_generic_storage_menu;
};



interact_vehicle_storage = {
	private["_vehicle", "_item", "_amount"];
	
	_vehicle = _this select 0;
	_item = _this select 1;
	_amount = _this select 2;
	
	if (not([_vehicle] call vehicle_exists)) exitWith {};
	
	if (isNil "_item") exitWith {};
	if (isNil "_amount") exitWith {};
	if (typeName _item != "STRING") exitWith {};
	if (typeName _amount != "SCALAR") exitWith {};
	
	if (_amount == 0) exitWith {};
	
	private["_class"];
	_class = typeOf _vehicle;
	
	private["_player", "_info", "_v_storage", "_p_storage"];
	_player = player;
	_info = _item call INV_GetItemArray;
	_v_storage = [_vehicle] call vehicle_storage_name;
	_p_storage = [_player] call player_inventory_name;
	
	private["_v_max_weight", "_v_cur_weight", "_own_weight", "_items_weight", "_p_cur_weight", "_p_max_weight", "_v_items_amount", "_p_items_amount" ];
	_v_max_weight = _class call INV_GetVehMaxKg;
	_v_cur_weight = [_vehicle, _v_storage] call INV_GetStorageWeight;
	_p_max_weight = INV_CarryingCapacity;
	_p_cur_weight = (call INV_GetOwnWeight);
	_items_weight = (_info call INV_GetItemTypeKg) * abs(_amount);
	
	_v_items_amount = ([_vehicle, _item, _v_storage] call INV_GetStorageAmount);
	_p_items_amount = ([_player, _item, _p_storage] call INV_GetStorageAmount);
	
	private["_valid"];
	_valid = false;
	if (_amount > 0) then {
		//adding items to the vehicle
		if (_amount > _p_items_amount) exitWith {
			player groupChat format["You do not have that many items in your inventory"];
		};
		
		if (_v_max_weight > 0 && (_items_weight + _v_cur_weight) > _v_max_weight) exitWith {
			player groupChat format["The total weight of the items exceed the vehicle's capacity"];
		};
		player groupChat format["You put %1 item(s) into the vehicle", strM(_amount)];
		_valid = true;
	}
	else {
		//removing items from the vehicle
		if (abs(_amount) > _v_items_amount) exitWith {
			player groupChat format["The vehicle does not have that many items"];
		};
		
		if (_p_max_weight> 0 && (_items_weight + _p_cur_weight) > _p_max_weight) exitWith {
			player groupChat format["The total weight of the items exceed the your carrying capacity"];
		};
		
		player groupChat format["You took %1 item(s) out of th vehicle", strM(abs(_amount))];
		_valid = true;		
	};
	
	if (not(_valid)) exitWith{};
	
	[_vehicle, _item, (_amount), _v_storage] call INV_AddItemStorage;
	[_player, _item, -(_amount), _p_storage] call INV_AddItemStorage;
	
	closeDialog 0;
	call shop_play_animation;
};



interact_factory_storage = {
	private["_player", "_factory", "_item", "_amount"];
	
	_player = _this select 0;
	_factory = _this select 1;
	_item = _this select 2;
	_amount = _this select 3;
	
	if (not([_player] call player_exists)) exitWith {};
	
	if (isNil "_factory") exitWith {};
	if (isNil "_item") exitWith {};
	if (isNil "_amount") exitWith {};
	if (typeName _factory != "STRING") exitWith {};
	if (typeName _item != "STRING") exitWith {};
	if (typeName _amount != "SCALAR") exitWith {};
	
	if (_amount == 0) exitWith {};
	
	private["_item_kind"];
	_item_kind = _item call INV_GetItemKindOf;
	
	if (not(_item_kind in ["ressource", "drug", "money"]) && _amount > 0) exitWith {
		player groupChat format ["You can only store money, drugs, and ressources in factories"];
	};

	private["_info", "_f_storage", "_p_storage"];
	_info = _item call INV_GetItemArray;
	_f_storage = _factory;
	_p_storage = [_player] call player_inventory_name;
	
	private["_f_max_weight", "_f_cur_weight", "_items_weight", "_p_cur_weight", "_p_max_weight", "_f_items_amount", "_p_items_amount"];
	_f_cur_weight = [_player, _f_storage] call INV_GetStorageWeight;
	_f_max_weight = -1; //factories ulimited
	_p_max_weight = INV_CarryingCapacity;
	_p_cur_weight = (call INV_GetOwnWeight);
	_items_weight = (_info call INV_GetItemTypeKg) * abs(_amount);
	
	_f_items_amount = ([_player, _item, _f_storage] call INV_GetStorageAmount);
	_p_items_amount = ([_player, _item, _p_storage] call INV_GetStorageAmount);
	
	private["_valid"];
	_valid = false;
	if (_amount > 0) then {
		//adding items to the factory
	
		if (_amount > _p_items_amount) exitWith {
			player groupChat format["You do not have that many items in your inventory"];
		};
		
		if (_f_max_weight > 0 && (_items_weight + _f_cur_weight) > _f_max_weight) exitWith {
			player groupChat format["The total weight of the items exceed the factory's capacity"];
		};
		_valid =  true;
	}
	else {
		//removing items from the factory
		if (abs(_amount) > _f_items_amount) exitWith {
			player groupChat format["The factory does not have that many item"];
		};
		
		if (_p_max_weight > 0 && (_items_weight + _p_cur_weight) > _p_max_weight) exitWith {
			player groupChat format["The total weight of the items exceed the your carrying capacity"];
		};
		_valid =  true;		
	};
	
	if (not(_valid)) exitWith {};
	
	[_player, _item, _amount, _f_storage] call INV_AddItemStorage;
	[_player, _item, -(_amount), _p_storage] call INV_AddItemStorage;
	[_f_storage, (_player getVariable _f_storage)] call stats_client_save;
	
	closeDialog 0;
	call shop_play_animation;
};


interact_generic_storage = {
	private["_player", "_storage", "_item", "_amount"];
	
	_player = _this select 0;
	_storage = _this select 1;
	_item = _this select 2;
	_amount = _this select 3;
	
	if (not([_player] call player_exists)) exitWith {};
	
	if (isNil "_storage") exitWith {};
	if (isNil "_item") exitWith {};
	if (isNil "_amount") exitWith {};
	if (typeName _storage != "STRING") exitWith {};
	if (typeName _item != "STRING") exitWith {};
	if (typeName _amount != "SCALAR") exitWith {};
	
	if (_amount == 0) exitWith {};
	
	//player groupChat format["interact_generic_storage %1", _this];
	
	private["_item_kind"];
	_item_kind = _item call INV_GetItemKindOf;

	private["_info", "_g_storage", "_p_storage"];
	_info = _item call INV_GetItemArray;
	_g_storage = _storage;
	_p_storage = [_player] call player_inventory_name;
	
	private["_g_max_weight", "_g_cur_weight", "_items_weight", "_p_cur_weight", "_p_max_weight", "_g_items_amount", "_p_items_amount"];
	_g_cur_weight = [_player, _g_storage] call INV_GetStorageWeight;
	_g_max_weight = -1; //factories ulimited weight
	_p_max_weight = INV_CarryingCapacity;
	_p_cur_weight = (call INV_GetOwnWeight);
	_items_weight = (_info call INV_GetItemTypeKg) * abs(_amount);
	
	_g_items_amount = ([_player, _item, _g_storage] call INV_GetStorageAmount);
	_p_items_amount = ([_player, _item, _p_storage] call INV_GetStorageAmount);
	
	private["_valid"];
	_valid = false;
	if (_amount > 0) then {
		//adding items to the storage
		if (_amount > _p_items_amount) exitWith {
			player groupChat format["You do not have that many items in your inventory"];
		};
		
		if (_g_max_weight > 0 && ((_items_weight + _g_cur_weight) > _g_max_weight)) exitWith {
			player groupChat format["The total weight of the items exceed the storage's capacity"];
		};
		
		_valid = true;	
	}
	else {
		//removing items from the storage
		if (abs(_amount) > _g_items_amount) exitWith {
			player groupChat format["The storage does not have that many item(s)"];
		};
		
		if (_p_max_weight > 0 && (_items_weight + _p_cur_weight) > _p_max_weight) exitWith {
			player groupChat format["The total weight of the items exceed the your carrying capacity"];
		};
		_valid = true;
	};
	
	if (not(_valid)) exitWith {};
	[_player, _item, (_amount), _g_storage] call INV_AddItemStorage;
	[_player, _item, -(_amount), _p_storage] call INV_AddItemStorage;
	[_g_storage, (_player getVariable _g_storage)] call stats_client_save;
	closeDialog 0;
	call shop_play_animation;
};


interact_vehicle_breakout = {
	private["_player", "_vehicle"];
	_player = _this select 0;
	_vehicle = _this select 1;
	if (not([_player] call player_human)) exitWith {};
	if (not([_vehicle] call vehicle_exists)) exitWith {};
	
	if (_vehicle == _player) exitWith {};
	
	breakingout = if (isNil "breakingout") then {false} else {breakingout};
	
	if (breakingout) exitWith {
		player groupChat "You are already trying to get out";
	};
	
	if(speed _vehicle > 30) exitWith {
		player groupChat "The vehicle is moving too fast";
	};

	if (not(locked _vehicle) ||
	    ([_player] call player_armed) ||
		([_player, _vehicle] call vehicle_owner) ||
		(_vehicle isKindOf "Motorcycle") ||
		(_vehicle isKindOf "ATV_Base_EP1") 
		) exitWith {
		[_player,_vehicle, true] call player_exit_vehicle;
	};
	
	breakingout = true;
	player groupchat "Wait 10 seconds while you find a way out of this vehicle";	
	sleep 10; 
	if(speed _vehicle > 30) exitWith {
		player groupchat "The vehicle is moving too fast";
		breakingout = false;
	};
	
	if (_vehicle == _player) exitWith {
		breakingout = false;
	};
	
	[_player, _vehicle, true] call player_exit_vehicle;
	breakingout = false;
};


///////////////  Poll triggered from the adminmenu  ///////////////
admin_create_poll = {
	private["_question", "_pollID", "_polltime"];
	_question = toArray(format["%1",(_this select 0)]);
	_pollID = format["poll%1", round(random(100))];;
	_polltime = round(time + 60);
	
	if((typeName "_question") != "STRING") exitWith {player groupChat "Error: No String";};
	//player groupChat format["id = %1, question = %2, %time = %3", _pollID, _question, _polltime];
	
	//Create a new empty poll on server
	//player groupChat "1";
	server setVariable [_pollID, [0,0], true];
	
	sleep 0.1;
	//Broadcast that there is a new poll
	//player groupChat "2";
	format["[%1,%2,%3] call admin_vote_poll", toArray(_pollID), _question, _polltime] call broadcast;

};

admin_vote_poll = {
	private["_question", "_pollID", "_polltime", "_votes"];
	//player groupChat "3";
	if (isServer) exitWith {};
	
	_pollID = _this select 0;
	_question = _this select 1;
	_polltime = _this select 2;
	//player groupChat format["id = %1, question = %2, %time = %3", _pollID, _question, _polltime];
	[_pollID, _question, _polltime] spawn admin_see_poll_results;
	
	response = false;
	if (!(createDialog "ja_nein")) exitWith {hint "Dialog Error!"};
	ctrlSetText [1, format["%1", toString(_question)]];
	waitUntil{(not(ctrlVisible 1023))};

	if (time > _polltime) exitWith{player groupChat "Sorry you voted to late, your vote could not be counted";};
	if(not(response)) then {
		//player voted no
		_votes = server getVariable toString(_pollID);
		_votes set [1, ((_votes select 1) + 1)];
		server setVariable [toString(_pollID), _votes, true];
	} else {
		_votes = server getVariable toString(_pollID);
		_votes set [0, ((_votes select 0) + 1)];
		server setVariable [toString(_pollID), _votes, true];	
	};
	
};

admin_see_poll_results = {
	private["_pollID", "_question", "_polltime", "_votes"];
	_pollID = toString(_this select 0);
	_question = toString(_this select 1);
	_polltime = _this select 2;
	
	
	while{time <= _polltime} do {
		_votes = server getVariable _pollID;
		hint format["Actual standings on the question: %1\n Yes: %2\nNo:%3\nPoll ends in %4 seconds", _question, (_votes select 0), (_votes select 1), round(_polltime - time)];
		sleep 1;
	};
	
	//Poll is over
	_votes = server getVariable _pollID;
	
	hint format["Result of the poll %1:\nVotes for yes: %2\nVotes for no: %3", _question, (_votes select 0), (_votes select 1)];
	sleep 10;
	hint "";
	//remove variable
	server setVariable [_pollID, nil, true];
};

interact_gang_menu = {
	private["_player"];
	_player = _this select 0;
	if (not([_player] call player_human)) exitWith {};
	
	if (not(createDialog "gang_menu")) exitWith {
		player groupChat format["ERROR: cannot create gang dialog"];	
	};

	private["_i", "_gangs_list"];
	_gangs_list = call gangs_get_list;
	_i = 0;
	while {_i < count (_gangs_list) } do {
		private["_gang"];
		_gang = _gangs_list select _i;
		private["_gang_id", "_gang_name", "_member_uids"];
		_gang_id = _gang select gang_id;
		_gang_name = _gang select gang_name;
		_gang_open = _gang select gang_open;
		_member_uids = _gang select gang_members;
		
		private["_member_names", "_open_str"];
		_member_names = [_member_uids] call gangs_uids_2_names;
		_open_str = if (_gang_open) then {"open"} else {"closed"};
		
		private["_index"];
		_index = lbAdd [202, format["%1 (%2) - Members: %3", _gang_name, _open_str, _member_names]];
		//player groupChat format["_index = %1, _gang_id = %2", _index, _gang_id];
		lbSetData[202, _index, _gang_id];
		_i = _i + 1;
	};
};

interact_gang_join = {
	//player groupChat format["interact_gang_join %1", _this];
	private["_player", "_gang_id"];
	_player = _this select 0;
	_gang_id = _this select 1;
	
	if (not([_player] call player_human)) exitWith {};
	if (isNil "_gang_id") exitWith {};
	if (typeName _gang_id != "STRING") exitWith {};
	
	if (_gang_id == "") exitWith {
		player groupChat format["%1-%2, you have not selected any gang to join", _player, (name _player)];
	};
	
	private["_gang"];
	_gang = [_gang_id] call gangs_lookup_id;
	if (isNil "_gang") exitWith {
		player groupChat format["%1-%2, the selected gang does not exist",  _player, (name _player)];
	};
	
	private["_cgang", "_player_uid"];
	_player_uid = [_player] call gang_player_uid;
	//player groupChat format["_player_uid = %1", _player_uid];
	_cgang = [_player_uid] call gangs_lookup_player_uid;
	//player groupChat format["_cgang = %1", _cgang];
	
	if (not(isNil "_cgang")) exitWith {
		private["_cgang_name"];
		_cgang_name = _cgang select gang_name;
		player groupChat format["%1-%2, you are already in gang %3", _player, (name _player), _cgang_name];
	};

	private["_gang_name"];
	_gang_name = _gang select gang_name;
		
	private["_recruiting"];
	_recruiting = _gang select gang_open;
	
	if (not(_recruiting)) exitWith {
		player groupChat format["%1-%2, gang %3 is not recruiting at the moment", _player, (name _player), _gang_name];
	};
	
	player groupChat format["%1-%2, you have joined gang %3", _player, (name _player), _gang_name];
	format['["%1", %2] call gang_add_member;', _gang_id, _player] call broadcast;
};

interact_gang_leave = {
	private["_player"];
	_player = _this select 0;
	if (not([_player] call player_human)) exitWith {};
	
	private["_player_uid", "_gang"];
	_player_uid = [_player] call gang_player_uid;
	_gang = [_player_uid] call gangs_lookup_player_uid;
	if (isNil "_gang") exitWith {
		player groupChat format["%1-%2, you are not in any gang", _player, (name _player)];
	};
	
	private["_gang_id"];
	_gang_id = _gang select gang_id;
	format['["%1", "%2"] call gang_remove_member;', _gang_id, _player_uid] call broadcast;
	player groupChat format["%1-%2, you have left gang %3", _player, (name _player), (_gang select gang_name)];
};

interact_gang_manage_menu = {
	//player groupChat format["interact_gang_manage_menu %1", _this];
	private["_player", "_gang_id"];
	
	_player = _this select 0;
	_gang_id = _this select 1;
	
	if (not([_player] call player_human)) exitWith {};
	if (isNil "_gang_id") exitWith {};
	if (typeName _gang_id != "STRING") exitWith {};
	
	private["_gang"];
	_gang = [_gang_id] call gangs_lookup_id;
	if (isNil "_gang") exitWith {};
	
	private["_gang_name", "_gang_open", "_player_uid"];
	_gang_name = _gang select gang_name;
	_gang_open = _gang select gang_open;
	_player_uid = [_player] call gang_player_uid;
	
	if (not(([_gang_id] call gang_leader_uid) == _player_uid)) exitWith {
		player groupChat format["%1-%2, you are not allowed to manage gang %3, you are not the leader", _player, (name _player), _gang_name];
	};
	
	if (not(createDialog "manage_gang_menu")) exitWith {
		player groupChat format["ERROR: clould not create gang management dialog"];
	};
	
	ctrlSetText [101, format["Manage %1", _gang_name]];
	
	selected_gang_id = _gang_id;
	call interact_gang_update_open_cbox;

	private["_member_uids", "_members"];
	_member_uids = _gang select gang_members;
	_members = [_member_uids] call gangs_uids_2_players;
	
	{
		private["_member", "_member_name", "_member_uid"];
		_member = _x;
		_member_name = (name _member);
		_member_uid = [_member] call gang_player_uid;
		private["_index"];
		_index = lbAdd [102, (format ["%1 (%2)", _member_name, _member])];
		lbSetData [102, _index, str(_member)];
	} forEach _members;
	
};

gang_animation = false;
interact_play_gang_animation = {
	private["_player"];
	_player = _this select 0;
	if (not([_player] call player_human)) exitWith {};
	
	gang_animation = true;
	player playmove "AinvPknlMstpSlayWrflDnon_medic";
	sleep 5;
	waitUntil {animationstate player != "AinvPknlMstpSlayWrflDnon_medic"};
	gang_animation = false;
};

interact_gang_area_neutralise = {
	private["_player", "_gang_area"];
	_player = _this select 0;
	_gang_area = _this select 1;
	if (not([_player] call player_human)) exitWith {};
	if (isNil "_gang_area") exitWith {};
	if (typeName _gang_area != "OBJECT") exitWith {};
	
	[_player] call interact_play_gang_animation;
	
	private["_new_pos"];
	[_gang_area] call gang_flag_setup;
	_new_pos = [_gang_area, [0,0,0.5*-1]] call gang_flag_set_offset;
	
	if (not((_new_pos select 2) <= -7)) exitWith {};

	private["_gang", "_player_uid"];
	_player_uid = [_player] call gang_player_uid;
	_gang = [_player_uid] call gangs_lookup_player_uid;
	if (isNil "_gang") exitWith {};
	
	private["_gang_name"];
	_gang_name = _gang select gang_name;
	[_gang_area, ""] call gang_area_set_control;
	
	private["_message"];
	_message = format["%1 has been neutralised by %2!", _gang_area, _gang_name];
	format['hint toString(%1);', toArray(_message)] call broadcast;
};

interact_gang_area_capture = {
	private["_player", "_gang_area"];
	_player = _this select 0;
	_gang_area = _this select 1;
	if (not([_player] call player_human)) exitWith {};
	if (isNil "_gang_area") exitWith {};
	if (typeName _gang_area != "OBJECT") exitWith {};
	
	[_player] call interact_play_gang_animation;
	
	private["_new_pos"];
	[_gang_area] call gang_flag_setup;
	
	_new_pos = [_gang_area, [0,0,0.5]] call gang_flag_set_offset;

	//player groupchat format["_new_pos = %1", _new_pos];
	if (not((_new_pos select 2) >= 0)) exitWith {};
	
	[_gang_area, [0,0,0]] call gang_flag_reset_offset;
	
	private["_gang", "_player_uid"];
	_player_uid = [_player] call gang_player_uid;
	_gang = [_player_uid] call gangs_lookup_player_uid;
	if (isNil "_gang") exitWith {};

	private["_gang_id", "_gang_name"];
	_gang_id = _gang select gang_id;
	_gang_name = _gang select gang_name;
	[_gang_area, _gang_id] call gang_area_set_control;
		
	private["_message"];
	_message = format["%1 has been captured by %2!", _gang_area, _gang_name];
	format['hint toString(%1);', toArray(_message)] call broadcast;
};

interact_gang_create_menu = {
	//player groupChat format["interact_gang_create_menu"];
	
	if (not(createDialog "gilde_gruenden")) exitWith {
		player groupChat format["ERROR: could not create gang creation dialog"];
	};
	
	private["_info"];
	_info = format["Note: Gang creation fee is $%1.", strM(gangcreatecost)] +
			format["If you leave and rejoin the game, you must rejoin the gang (there is no join fee)."] +
			format["The gang will be deleted after %1 minutes if there are no members in the gang.", round(gangdeltime/60)];
			
	ctrlSetText[5, _info];
};

interact_gang_create = {
	//player groupChat format["interact_gang_create %1", _this];
	private["_player", "_text"];
	_player = _this select 0;
	_text = _this select 1;
	if (not([_player] call player_human)) exitWith {};
	if (isNil "_text") exitWith {};
	if (typeName _text != "STRING") exitWith {};
	
	//check that player is not in a gang
	private["_gang", "_player_uid"];
	_player_uid = [_player] call gang_player_uid;
	_gang = [_player_uid] call gangs_lookup_player_uid;
	if (not(isNil "_gang")) exitWith {
		private["_gang_name"];
		_gang_name = _gang select gang_name;
		player groupChat format["%1-%2, you are already a member of gang %3", _player, (name _player), _gang_name];
	};
	
	//check that there is no other gang with the same name
	private["_cgang"];
	_cgang = [_text] call gangs_lookup_name;
	if (not(isNil "_cgang")) exitWith {
		private["_cgang_name"];
		_cgang_name = _cgang select gang_name;
		player groupChat format["%1-%2, there is already a gang named %3", _player, (name _player), _cgang_name];
	};
	

	//check that the gang meets the naming requirements
	private["_text_length"];
	_text_length = [_text] call strlen;
	private["_max_length", "_min_length"];
	_max_length = 30;
	_min_length = 3;
	
	if (_text_length < _min_length) exitWith {
		player groupChat format["%1-%2, the gang name you entered is less than %3 characters long", _player, (name _player), _min_length];
	};
	if (_text_length > _max_length) exitWith {
		player groupChat format["%1-%2, the gang name you entered is more than %3 characters long", _player, (name _player), _max_length];
	};

	//check that player has enough money to create the gang
	private["_money"];
	_money = [_player, 'money'] call INV_GetItemAmount;
	if (_money < gangcreatecost) exitWith {
		player groupChat format["%1-%2, you do not have enough money to create a gang", _player, (name _player)];
	};
	
	[player, 'money', -(gangcreatecost)] call INV_AddInventoryItem;
	format['[%1, toString(%2)] call gang_create;', _player, toArray(_text)] call broadcast;
	player groupChat format["%1-%2, you have created a new gang called %3", _player, (name _player), _text];
};

interact_gang_kick = { _this spawn {
	
	private["_player", "_member_variable"];
	_player = _this select 0;
	_member_variable = _this select 1;
	if (not([_player] call player_human)) exitWith {};
	if (isNil "_member_variable") exitWith {};
	if (typeName _member_variable != "STRING") exitWith {};
	
	_member = missionNamespace getVariable _member_variable;
	if (not([_member] call player_human)) exitWith {};
	
	private["_player_uid", "_member_uid"];
	_player_uid = [_player] call gang_player_uid;
	_member_uid = [_member] call gang_player_uid;
	
	private["_gang"];
	_gang = [_player_uid] call gangs_lookup_player_uid;
	if (isNil "_gang") exitWith {
		player groupChat format["%1-%2, you are no in a gang", _player, (name _player)];
	};
	
	private["_gang_id"];
	_gang_id = _gang select gang_id;
	if (not(([_gang_id] call gang_leader_uid) == _player_uid)) exitWith {
		player groupChat format["%1-%2, you are not the leader of this gang", _player, (name _player)];
	};
	
	if (_player_uid == _member_uid) exitWith {
		player groupChat format["%1-%2, you cannot kick yourself from the gang", _player, (name _player)];
	};
	
	private["_members"];
	_members = _gang select gang_members;
	if (not(_member_uid in _members)) exitWith {
		player groupChat format["%1-%2, %3-%4 is not a member of your gang", _player, (name _player), _member, (name _member)];
	};
	
	player groupChat format["%1-%2, you have kicked %3-%4 from your gang!", _player, (name _player), _member, (name _member)];
	
	format['["%1", "%2"] call gang_remove_member;', _gang_id, _member_uid] call broadcast;
	sleep 1;  //sleep a second to give enought time for the changes to take effect
	
	private["_message"];
	_message = format["%1-%2, you have been kicked out of your gang!", _member, (name _member)];
	format['if (player == %1) then {player groupChat toString(%2);};', _member, toArray(_message)] call broadcast;
};};

interact_gang_make_leader = { _this spawn {
	private["_player", "_member_variable"];
	_player = _this select 0;
	_member_variable = _this select 1;
	if (not([_player] call player_human)) exitWith {};
	if (isNil "_member_variable") exitWith {};
	if (typeName _member_variable != "STRING") exitWith {};
	
	_member = missionNamespace getVariable _member_variable;
	if (not([_member] call player_human)) exitWith {};
	
	private["_player_uid", "_member_uid"];
	_player_uid = [_player] call gang_player_uid;
	_member_uid = [_member] call gang_player_uid;
	
	private["_gang"];
	_gang = [_player_uid] call gangs_lookup_player_uid;
	if (isNil "_gang") exitWith {
		player groupChat format["%1-%2, you are no in a gang", _player, (name _player)];
	};
	
	private["_gang_id"];
	_gang_id = _gang select gang_id;
	if (not(([_gang_id] call gang_leader_uid) == _player_uid)) exitWith {
		player groupChat format["%1-%2, you are not the leader of this gang", _player, (name _player)];
	};
	
	if (_player_uid == _member_uid) exitWith {
		player groupChat format["%1-%2, you are already the leader of this gang", _player, (name _player)];
	};
	
	private["_members"];
	_members = _gang select gang_members;
	if (not(_member_uid in _members)) exitWith {
		player groupChat format["%1-%2, %3-%4 is not a member of your gang", _player, (name _player), _member, (name _member)];
	};
	
	player groupChat format["%1-%2, you have made %3-%4 the leader of your gang!", _player, (name _player), _member, (name _member)];
	
	format['["%1", "%2"] call gang_make_leader;', _gang_id, _member_uid] call broadcast;
	sleep 1;  //sleep a second to give enought time for the changes to take effect
	
	private["_message"];
	_message = format["%1-%2, you have been made the leader of your gang!", _member, (name _member)];
	format['if (player == %1) then { player groupChat toString(%2);};', _member, toArray(_message)] call broadcast;
};};



interact_gang_update_open_cbox = {
	private["_gang"];
	_gang = [selected_gang_id] call gangs_lookup_id;
	if (isNil "_gang") exitWith {};
	
	private["_open"];
	_open = _gang select gang_open;
	
	private["_text"];
	_text = if (_open) then { format["[x] Gang open"] } else {format["[ ] Gang open"]};
	ctrlSetText [202, _text];
};

interact_gang_toggle_open = {
	//player groupChat format["interact_gang_toggle_open %1", _this];
	private["_player"];
	_player = _this select 0;
	if (not([_player] call player_human)) exitWith {};
	
	private["_player_uid", "_gang"];
	_player_uid = [_player] call gang_player_uid;
	_gang = [_player_uid] call gangs_lookup_player_uid;
	
	private["_gang_id"];
	_gang_id = _gang select gang_id;
	if (not(([_gang_id] call gang_leader_uid) == _player_uid)) exitWith {
		player groupChat format["%1-%2, you are not the leader of this gang", _player, (name _player)];
	};
	
	private["_open"];
	_open = _gang select gang_open;
	_open = not(_open);
	_gang set [gang_open, _open];
	[_gang] call gangs_update_list;
	
	if (not(_open)) then {
		player groupChat format["%1-%2, you have closed your gang", _player, (name _player)];
	}
	else {
		player groupChat format["%1-%2, you have opened your gang", _player, (name _player)];
	};
};

interact_gang_open = {
	private["_player", "_open"];
	player groupChat format["interact_gang_open %1", _this];
	_player = _this select 0;
	_open = _this select 1;
	if (not([_player] call player_human)) exitWith {};
	if (isNil "_open") exitWith {};
	if (typeName _open != "BOOL") exitWith {};
	
	private["_player_uid", "_gang"];
	_player_uid = [_player] call gang_player_uid;
	_gang = [_player_uid] call gangs_lookup_player_uid;

	private["_gang_id"];
	_gang_id = _gang select gang_id;
	if (not(([_gang_id] call gang_leader_uid) == _player_uid)) exitWith {
		player groupChat format["%1-%2, you are not the leader of this gang", _player, (name _player)];
	};
	
	_gang set [gang_open, _open];
	[_gang] call gangs_update_list;
	
	if (not(_open)) then {
		player groupChat format["%1-%2, you have closed your gang", _player, (name _player)];
	}
	else {
		player groupChat format["%1-%2, you have opened your gang", _player, (name _player)];
	};
};

interact_item_process = {
	//player groupChat format["interact_item_process %1", _this];
	
	private["_player", "_item_name", "_item"];
	_player = _this select 0;
	_input_item = _this select 1;
	_output_item = _this select 2;
	_input_amount_required = _this select 3;
	
	if (not([_player] call player_human)) exitWith {};
	if (isNil "_input_item") exitWith {};
	if (isNil "_output_item") exitWith {};
	if (isNil "_input_amount_required") exitWith {};
	if (typeName _input_item != "STRING") exitWith {};
	if (typeName _output_item != "STRING") exitWith {};
	if (typeName _input_amount_required != "SCALAR") exitWith {};
	if (_input_amount_required <= 0) exitWith {};
	
	private["_input_item_name", "_output_item_name"];
	_input_item_name = _input_item call INV_GetItemName;
	_output_item_name = _output_item call INV_GetItemName;
	
	if ([_player] call player_cop) exitWith {
		player groupChat format["%1-%2, only civilians are allowed to process %3", _player, (name _player), _input_item_name];
	};
	
	private["_input_amount"];
	_input_amount = [_player, _input_item] call INV_GetItemAmount;
	
	if (_input_amount < _input_amount_required) exitWith {
		player groupChat format["%1-%2, you require at least %3 %4 to produce %5 %6", _player, (name _player), _input_amount_required, _input_item_name, 1, _output_item_name];
	};

	private["_output_amount"];
	_output_amount = floor(_input_amount/_input_amount_required);
	
	private["_input_amount_used"];
	_input_amount_used = round(_input_amount_required * _output_amount);
	
	[_player, _input_item, -(_input_amount_used)] call INV_AddInventoryItem;
	[_player, _output_item, _output_amount, ([_player] call player_inventory_name)] call INV_CreateItem;

	player groupChat format["%1-%2, you porcessed %3 %4 into %5 %6", _player, (name _player), _input_amount_used, _input_item_name, _output_amount, _output_item_name];
};

interaction_functions_defined = true;