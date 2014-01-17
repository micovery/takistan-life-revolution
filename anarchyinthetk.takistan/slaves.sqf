#include "Awesome\Functions\macro.h"

private["_art","_moneh"];
_art  = ((_this select 3) select 0);
_moneh = [player, 'money'] call INV_GetItemAmount;

if (_art == "slave") exitWith {

	if (localslave >= maxslave) exitWith {
		role groupChat localize "STRS_slave_zuviele"
	};

	if (_moneh < slave_cost) exitWith {
		role groupChat localize "STRS_slave_nomoney"
	};

	if (currecciv) exitWith {
		role groupChat "Already buying a slave!"
	};

	currecciv = true;
	role groupChat "Buying slave";
	sleep 2;

	[player, 'money', -(slave_cost)] call INV_AddInventoryItem;

	player groupChat format[localize "STRS_slave_gekauft", strM(slave_cost)];
	
	private["_arbeiternummer", "_slavenumber", "_slavename", "_civ"];
	
	_arbeiternummer   = localslavecounter;
	localslavecounter = localslavecounter + 1;
	localslave        = localslave + 1;
	_slavenumber      = localslavecounter;
	_slavename        = player;
	_civ 		  = civslavearray select round random(count civslavearray - 1);

	[] call compile format [
		'
		private["_slavename"];
		_slavename = "%3" createUnit [getmarkerpos "terrorist", group player, "%1slave%2 = this; this setVehicleVarName ""%1slave%2"";"]; 
		_slavename = %1slave%2;
		_slavename setpos getmarkerpos "terrorist"
		', rolestring, _slavenumber, _civ];
		

	(format [
	"
		if (local server) then {
			publicarbeiterarctionarray = publicarbeiterarctionarray + [ [%1slave%2, %3] ];
		};
	", rolestring, _slavenumber, player]) call broadcast;

	currecciv = false;

	processInitCommands;

	[] call compile format ["arbeitergeld%1 = 0;", _arbeiternummer];
	
	private["_slavemoney","_exitvar","_a1","_action"];
	_slavemoney = 0;
	_exitvar = 0;
	_a1 = 0;
	_action = 0;

	while {true} do {
		if (_exitvar == 1) exitWith {}; 
		
		{
			if ((player distance (_x select 0)) < (_x select 1)) then {call compile format ["arbeitergeld%1 = arbeitergeld%1 + slavemoneyprosekunde + round(random 500 - random 500);", _arbeiternummer];};
		} forEach slavearray;

		private["_i"];
		
		for [{_i=0}, {_i < 60}, {_i=_i+1}] do {
			if ( (not(alive _slavename)) or (not(alive player))) exitWith {
				sleep 2; 
				if (!isnull _slavename) then {
					player groupChat localize "STRS_slave_tot";
				} else {
					player groupChat "A slave you owned has been set free! you are now wanted.";
					[player, "(human-trafficking)", slave_cost, 150, false] call player_update_warrants;
				}; 
				localslave = localslave - 1; 
				_slavename SETDAMAGE 1; 
				_exitvar = 1;
			};

			if ((player distance _slavename >= 5 or (call compile format ["arbeitergeld%1 == 0", _arbeiternummer])) and _a1 == 1) then {
				player removeaction _action; _a1 = 0;
			};

			if (player distance _slavename < 5 and _a1 == 0 and (call compile format ["arbeitergeld%1 > 0", _arbeiternummer])) then {
				_action = player addaction [localize "STRS_slave_moneyaction", "slaves.sqf",["money", _arbeiternummer]]; 
				_a1 = 1;
			};

			if (not(iscop) and ((vehicle _slavename) DISTANCE copbase1 <= 250) and (alive _slavename)) then {
				player groupChat localize "STRS_arbeiter_in_copbase";
				if (not((vehicle _slavename) == _slavename)) then {
					_slavename action ["eject", (vehicle _slavename)];
				};
				_slavename setpos getmarkerpos "civarea";
			};
			sleep 1;
		};
	};

	player removeaction _action;
	sleep 15;
	deletevehicle _slavename;
};

if (_art == "money") exitWith {
	private["_arbeiternummer", "_arbeitergeld"];
	_arbeiternummer = (_this select 3) select 1;
	_arbeitergeld   = call compile format ["arbeitergeld%1;", _arbeiternummer];

	if (_arbeitergeld > 0) then {
		[player, 'money', _arbeitergeld] call INV_AddInventoryItem;
		call compile format ["arbeitergeld%1 = 0;", _arbeiternummer];
		player groupChat format [localize "STRS_slave_geldabnahme_ja", strM(_arbeitergeld)];

	}
	else {
		player groupChat localize "STRS_slave_geldabnahme_nein";
	};
};

