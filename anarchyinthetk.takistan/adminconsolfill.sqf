#define AdminConsol 1000
#define AdminPlayers 2006

private ["_c", "_player_variable_name", "_player_variable"];

_c = 0;
_player_variable_name = "";


for [{_c=0}, {_c < (count playerstringarray)}, {_c=_c+1}] do {
	_player_variable_name = playerstringarray select _c;
	_player_variable = missionNamespace getVariable _player_variable_name;
	
	if ([_player_variable] call player_exists) then {
		private["_player_name", "_index"];
		_player_name = (name _player_variable);
		_index = lbAdd [AdminPlayers, format ["%1 - (%2)", _player_variable_name, _player_name]];
		lbSetData [AdminPlayers, _index, format["%1", _player_variable]];	
	};
};

_array =
	[
		["------ Items ------",	{}],
		
		["10 Lockpicks", {
			[player, 'lockpick',10] call INV_AddInventoryItem;
		}],
			
		["Add 100k Dollars to Bank", {
			[player, 100000] call bank_transaction;
		}],
			
		["Add 100k Dollars to Inventory", {
			[player, 'money',100000] call INV_AddInventoryItem;
		}],
			
		["Large Repair Kit", {
			[player, 'reparaturkit',1] call INV_AddInventoryItem;
		}],
			
		["Medkit", {
			[player, 'medikit',1] call INV_AddInventoryItem;
		}],
			
		["10 Bank insurance", {
			[player, 'bankversicherung',10] call INV_AddInventoryItem;
		}],
			
		["Gas mask", {
			[player, 'gasmask',1] call INV_AddInventoryItem;
		}],
			
		["Vehicle Ammo", {
			[player, 'vclammo',1] call INV_AddInventoryItem;
		}],
			
		["Refuel Can", {
			[player, 'kanister',1] call INV_AddInventoryItem;
		}],
			
		["Jack Hammer", {
			[player, 'JackHammer',1] call INV_AddInventoryItem;
		}],
		
		["------ Weapons ------", {}],
			
		["Pistol", {
			{player addMagazine "17Rnd_9x19_glock17";} forEach [1,2,3,4,5,6,7,8];
			player addweapon "glock17_EP1";
			player action ["switchweapon", player, player, 0];
		}],
		
		["GPS NV Binoc", {
			player addweapon "ItemGPS";
			player addweapon "NVGoggles";
			player addweapon "Binocular";
		}],
			
		["Cheap Gunz", {
			{player addMagazine "30Rnd_762x39_AK47";} forEach [1,2,3,4,5,6,7,8];
			player addweapon "AK_47_S";
			{player addMagazine "7Rnd_45ACP_1911";} forEach [1,2,3,4,5,6,7,8];
			player addweapon "Colt1911";
			player action ["switchweapon", player, player, 0];
		}],
			
		["Decent Gunz", {
			{player addMagazine "PG7V";} forEach [1,2,3];
			player addweapon "RPG7V";
			{player addMagazine "30Rnd_762x39_SA58";} forEach [1,2,3,4,5,6];
			player addweapon "Sa58V_CCO_EP1";
			{player addMagazine "20Rnd_B_765x17_Ball";} forEach [1,2,3,4,5,6,7,8];
			player addweapon "Sa61_EP1";
			player action ["switchweapon", player, player, 0];
		}],
		
		["Quiet Gunz", {
			{player addMagazine "20Rnd_762x51_SB_SCAR";} forEach [1,2,3,4,5,6,7,8,9,10,11,12];
			player addweapon "SCAR_H_CQC_CCO_SD";
			{player addMagazine "30Rnd_9x19_UZI_SD";} forEach [1,2,3,4,5,6,7,8];
			player addweapon "UZI_SD_EP1";
			player action ["switchweapon", player, player, 0];
		}],
			
		["Sniper Gunz", {
			{player addMagazine "20Rnd_762x51_B_SCAR";} forEach [1,2,3,4,5,6,7,8,9,10,11,12];
			player addweapon "M110_NVG_EP1";
			{player addMagazine "30Rnd_9x19_UZI";} forEach [1,2,3,4,5,6,7,8];
			player addweapon "UZI_EP1";
			player action ["switchweapon", player, player, 0];
		}],
		
		
		["------ Upgrades ------", {}],
		
		["Pimp My Ride", {
			(vehicle player) setvariable ["tuning", 5, true];
			(vehicle player) setvariable ["nitro", 1, true];
		}],
		
		["Fix My Ride", {
			vehicle player setFuel 1;
			vehicle player setvehicleammo 1;
			vehicle player setDamage 0;
		}],
		
		["------ Admin Related Commands ------", {}],
		["Create poll (enter question in inputfield)", {
			[parseText(_inputText)] call admin_create_poll;
		}],
		
		["Self Teleport", {
			hint "Click on the map to Teleport!";
			liafu = true;
			closeDialog 0;
			openMap true;
			onMapSingleClick "onMapSingleClick """";liafu = true; (vehicle player) setpos [_pos select 0, _pos select 1, 0]; openMap false;";
		}],
			
		["Admin Camera (Toggle)", {
			handle = [] execVM "camera.sqf";
		}],
			
		["Carmagedon", {
			_distance = parseNumber(_inputText);
	
			if ((typeName _distance) == (typeName (1234))) then {
			
					player groupchat format["Starting Carmagedon at a range of %1 meters", _distance];
			
					{
						{		
							if ({alive _x} count crew _x == 0) then {
									deleteVehicle _x;
							};
						} foreach((getpos player) nearObjects [_x, _distance]);
					} forEach (droppableitems + ["LandVehicle", "Air", "Car", "Motorcycle", "Bicycle", "UAV", "Wreck", "Wreck_Base", "HelicopterWreck", "UH1Wreck", "UH1_Base", "UH1H_base", "AH6_Base_EP1","CraterLong", "Ka60_Base_PMC", "Ka137_Base_PMC", "A10"]);
				} 
				else {
					hint "ERROR: expected number";
				};
		}],
		
		["Remove player weapons", {
			format['
				[] spawn
				{
					if (player != %1) exitWith {};
					liafu = true;
					[player] call player_reset_gear;
				};
			', _selectedplayer] call broadcast;
		}],
			
		["Kill player", {
			format['
				[] spawn
				{
					if (player != %1) exitWith {};
					liafu = true;
					(player) setDamage 1; 
				};
			', _selectedplayer] call broadcast;
		}],
			
		["Destroy player vehicle", {
			format['
				[] spawn
				{
					if (player != %1) exitWith {};
					liafu = true;
					(vehicle player) setDamage 1; 
				};
			', _selectedplayer] call broadcast;
		}],
		
		["Wipe player stats", {
			private["_variableName"];
			_variableName = (vehicleVarName _selectedplayer);
			if (isNil "_variableName") exitWith{};
			if (_variableName == "") exitWith {};

			format['if (isServer) then {["%1"] call stats_server_wipe_player_data;};', _variableName] call broadcast;
			player groupChat format["Request to wipe %1's stats sent", (name _selectedplayer)];
		}],
			
		["+1 Hour time", {
			[1] call time_move;
			player groupChat "+1 Hour, please wait for time to catch-up, before using again";
		}],
			
		["-1 Hour time", {
			[-1] call time_move;
			player groupChat "-1 Hour, please wait for time to catch-up, before using again"; 
		}],
		
		["Reset time(40m dy, 20m nt)", {
			player groupChat "Time reset (40-min day, 20-min night), please wait for synchronization to complete";
			[40,20] call time_reset;
		}],
			
		["Reset time(60m dy, 30m nt)", {
			player groupChat "Time reset (60-min day, 30-min night), please wait for synchronization to complete";
			[60,30] call time_reset;
		}],
			
		["MOTD (use input field)", {
			custom_motd = _inputText;
			publicVariable "custom_motd";
		}],
		
		["Delete Target (Man)", {
			private["_target"];
			_target = cursorTarget;
			if (not(isNil "_target")) then {
				if (typeName _target == "OBJECT") then {
					if (_target isKindOf "Man" && not([_target] call object_shop)) then {
						[_target] call C_delete;
					};
				};
			};
		}],
		
		
		["------ White / Black Lists ------", {}],
		
		["COP - 1 List", {
			["COP_1"] spawn A_WBL_F_DIALOG_INIT;
		}],

		["BLANK", {}]
	];


{
	private["_text", "_code", "_index"];
	_text = _x select 0;
	_code = _x select 1;
	
	_index = lbAdd [AdminConsol, _text];
	lbSetData [AdminConsol, _index, format['call %1', _code]];
} forEach _array;



