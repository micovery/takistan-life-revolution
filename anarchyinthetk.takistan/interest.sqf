#include "Awesome\Functions\macro.h"

BANK_zinsen = {
	private ["_bank_account", "_interest"];
	_bank_account = [player] call bank_get_value;
	if (_bank_account > 0) then {
		_interest = round(_bank_account*(zinsen_prozent/100));
		[player, _interest] call bank_transaction;
		_bank_account = [player] call bank_get_value;
		player groupChat format [localize "STRS_bank_zinsen", strM(_bank_account), strM(zinsen_prozent)];
	};
};

if (isServer) then {while {true} do {sleep zinsen_dauer;"[] spawn BANK_zinsen;" call broadcast;};};
