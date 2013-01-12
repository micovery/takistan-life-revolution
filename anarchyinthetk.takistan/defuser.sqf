 _art = _this select 0;

if (_art == "use") then {
	_item   = _this select 1;
	_anzahl = _this select 2;
	_DefuseBombArray = ["TimeBomb", "Mine", "MineE", "BAF_ied_v1", "BAF_ied_v2", "BAF_ied_v3", "BAF_ied_v4"];
	if (isNil "INV_BombDefuserInUse") then {
		INV_BombDefuserInUse = false;
	};

	if (not(INV_BombDefuserInUse)) then {
		INV_BombDefuserInUse = true;
		if (vehicle player == player) then {
			_bombs = [];

			{
				_bombs = _bombs + ( (position player) nearObjects  [_x, 3] );
			} forEach _DefuseBombArray;

			if (count _bombs > 0) then {

				if (random 100 < 99) then {
					player groupChat localize "STRS_inv_items_defuser_success";
					deletevehicle (_bombs select 0);
				}
				else {
					player groupChat localize "STRS_inv_items_defuser_failed";
					[(position player)] spawn Bomb_Vehicle;
				};
			}
			else {
				player groupChat localize "STRS_inv_items_defuser_nobomb";
			};
		}
		else {
			for [{_i=0}, {_i < (count INV_ServerBombArray)}, {_i=_i+1}] do {
				if (((INV_ServerBombArray select _i) select 1) == (vehicle player)) exitWith {
					format["""%1"" call INV_BombDelete", ((INV_ServerBombArray select _i) select 0)] call broadcast;
					[player, ((INV_ServerBombArray select _i) select 2), 1] call INV_AddInventoryItem;
					player groupChat localize "STRS_inv_items_defuser_success";
				};
			};
		};
	INV_BombDefuserInUse = false;
	};
};
