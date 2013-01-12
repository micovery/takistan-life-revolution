private["_killer", "_owner"];

_killer = _this select 0;
_owner  = _this select 1;

if(_killer == _owner) exitWith {};

private["_killer_cop"];
_killer_cop = [_killer] call player_cop;
if(_killer_cop) exitWith {};

private["_message"];
_message = format["%1-%2 killed one of %3-%4's workers!", _killer, (name _killer), _owner, (name _owner)];
format['server globalChat toString(%1);', toArray(_message)] call broadcast;
[_killer, format["killed %1's workers", _owner], 10000] call player_update_warrants;
