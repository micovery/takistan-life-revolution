#include "Awesome\Functions\macro.h"

_lotto     = (_this  select 0) call GetLottoArray;
_lottocost = (_lotto select 2);
_lottowin  = (_lotto select 3);
_chance    = (_lotto select 4);
_winner    = random 200;
_moneh      = [player, 'money'] call INV_GetItemAmount;

if (playing_lotto == 1) exitWith {
	player groupChat "You can only buy one ticket at a time.";
};

if (_moneh < _lottocost) exitWith {
	role groupChat localize "STRS_lotto_nomoney";
};

[player, 'money', -(_lottocost)] call INV_AddInventoryItem;

player groupChat format[localize "STRS_lotto_wait"];

playing_lotto = 1;
sleep 1800;
playing_lotto = 0;

if (_winner >= _chance) then {
	player groupChat localize "STRS_lotto_lost";
}
else {
	[player, 'money', _lottowin] call INV_AddInventoryItem;
	player groupChat format[localize "STRS_lotto_winner", strM(_lottowin)];
};

