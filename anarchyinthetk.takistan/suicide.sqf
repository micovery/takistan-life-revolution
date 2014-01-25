#define SleepWait(timeA) private["_waittt"]; _waittt = time + timeA; waitUntil {time >= _waittt};

private["_art"];
_art = _this select 0;

if (_art == "use") then {

	private["_inVehicle","_mounted","_exit"];
	
	_inVehicle = ((vehicle player) != player);
	if (_inVehicle) exitwith {
			player groupChat format["You cannot use the suicide bomb in a vehicle"];
		};
		
	_mounted = [player] call mounted_player_get_vehicle;
	_exit = false;
	if !(isNil "_mounted") then {
			if !(isNull _mounted) then {
					_exit = true;
					player groupChat format["You cannot use the suicide bomb in a vehicle"];
				};
		};
	if _exit exitwith {};

		
	if ((player distance (getmarkerpos "respawn_civilian")) < 130) exitWith {
		player groupchat "Some supernatural force prevents you from detonating a bomb in this holy place!"
	};

	private["_item","_anzahl","_weapon","_magazine", "_nearby", "_i", "_dam"];
	_item   = _this select 1;
	_anzahl = _this select 2;
//	"hint localize ""STRS_inv_item_selbstmordbombe_globalmsg"";" call broadcast;

	["Allah Hu Akbar infidels", "direct"] call SayDirectSpeach;
	
	_nearby = (getPosATL player) nearEntities ["caManBase", 100];
	if ( ({(isPlayer _x) && (alive _x) && ((side _x) == West)} count _nearby) > 0 ) then {
			[player, "Activating a Suicide Bomb", 100000, -1, false] call player_update_warrants;
		};
	
	for [{_i=10}, {_i >= 0}, {_i=_i-1}] do {
		titletext [format ["Bombcountdown: -->*%1*<--", _i],"plain"];
		SleepWait(1)
	};
	
	[player, _item, -1] call INV_AddInventoryItem;
	if (
			!(alive player) ||
			([player, "isstunned"] call player_get_bool) ||
			([player, "restrained"] call player_get_bool) ||
			!((vehicle player) == player) ||
			!(isNull([player] call mounted_player_get_vehicle))
		) exitWith {
			player groupChat format["The bomb failed to work"];
			titleText ["", "plain"];
		};
//	call compile format ["autobombe%2 = createVehicle [""Bo_GBU12_LGB"", (%1), [], 0, ""NONE""];",(getpos player), (round (random 2000))];
	
	_weapon = "BombLauncher";
	_magazine = "6Rnd_GBU12_AV8B";
	_dam = damage player;
	
	player addWeapon _weapon;
	player addMagazine [_magazine, 1];
	
	player selectWeapon _weapon;
	waitUntil { (currentWeapon player) == _weapon};
	
	reload player;
	
	SleepWait(3)
	
	if (
			(alive player) &&
			(!(([player, "isstunned"] call player_get_bool))) &&
			(!([player, "restrained"] call player_get_bool))
		) then {
			player fire [currentWeapon player];
		}else{
			player groupChat format["The bomb failed to work"];
		};
	
	player removeMagazine _magazine;
	player removeWeapon _weapon;
};
