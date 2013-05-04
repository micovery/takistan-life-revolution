if (not(isNil "tlr_life_functions_loaded")) exitWith {};

//Settings


tlr_life_settings = [
	//Enabled?
	true,
	//Life persistend?
	true,
	//Thirst persistend?
	true,
	//Tiredness persistend?
	true,
	//Hunger persistend?
	true,
	//Use HUD?
	true,
	//Thirst per minute 1 = 100% 0 = 0%
	0.0025,
	//Hunger per minute
	0.001,
	//Tiredness per minute
	0.0015,
	//Lifeloss per minute on empty food 1=instant dead
	0.01,
	//Lifelos per minute on empty drinks 1 = instant dead
	0.05,
	//Lifeloss per minute on completely tired
	0.005,
	//Time for sleeping (in seconds)
	45,
	//Lifegain from sleeping 0 = nothing, 1= full health
	0.5
	
];
tlr_life_enabled = 0;
tlr_life_persistend_life = 1;
tlr_life_persistend_thirst = 2;
tlr_life_persistend_tiredness = 3;
tlr_life_persistend_hunger = 4;
tlr_life_hudd = 5;
tlr_life_thpm = 6;
tlr_life_hupm = 7;
tlr_life_tipm = 8;
tlr_life_hull = 9;
tlr_life_thll = 10;
tlr_life_till = 11;
tlr_life_sleep = 12;
tlr_life_sleephealth = 13;

//Creating array for the loop, always the time of it's last run
//0 = Hunger
//1 = Thirst
//2 = Tired
//3 = Time to save

tlr_life_run_array = [time, time, time, time];

//Client variables
//0 = full, 1 = emtpy
//Starting with full stats
tlr_life_hunger = 0;
tlr_life_thirst = 0;
tlr_life_tiredness = 0;

tlr_life_init = {
	private["_var", "_life"];
	if (not(isClient)) exitWith {};
	//Loading stats if persitend and enabled
	if (not(tlr_life_settings select tlr_life_enabled)) exitWith {};
	waitUntil {alive player};
	waitUntil {(side player) in [civilian, west, east, resistance]};
	//player groupChat "INIT RUNNING";
	//Hunger
	if (tlr_life_settings select tlr_life_persistend_hunger) then {
		_var = format["hunger_%1", (side player)];
		tlr_life_hunger = [player, _var] call player_get_scalar;
	};
	
	//Thirst
	if (tlr_life_settings select tlr_life_persistend_thirst) then {
		_var = format["thirst_%1", (side player)];
		tlr_life_thirst = [player, _var] call player_get_scalar;
	};
	
	//Tiredness
	if (tlr_life_settings select tlr_life_persistend_tiredness) then {
		_var = format["tiredness_%1", (side player)];
		tlr_life_tiredness = [player, _var] call player_get_scalar;
	};
	
	//Life
	if (tlr_life_settings select tlr_life_persistend_life) then {
		_var = format["life_%1", (side player)];
		_life = [player, _var] call player_get_scalar;
		player setDamage _life;
	};
	
	[0] spawn tlr_life_client_loop;
};

tlr_life_hud = {
	if (not(tlr_life_settings select tlr_life_hudd)) exitWith {};
	//player groupChat "HUD RUNNING";
	private["_hud", "_life", "_hunger", "_thirst", "_tired"];
	_life = round((1-(damage player))*1000); //Life in percent - counting down
	_hunger = round(tlr_life_hunger*1000); //Hunger in percent - counting up
	_thirst = round(tlr_life_thirst*1000); //Thirst in percent - counting up
	_tired = round(tlr_life_tiredness*1000); //Tiredness in percent - counting up
	
	_hud = parseText format["
	<t color='#FFFFFF' align='center'>%1</t><br /><br />
	<t color='#FF0404' align='left'>Life: %2</t><br />
	<t color='#18A015' align='left'>Hunger: %3</t><br />
	<t color='#0083FF' align='left'>Thirst: %4</t><br />
	<t color='#4c4c4c' align='left'>Sleepy: %5</t><br />
	", (name player), _life, _hunger, _thirst, _tired];
	hintSilent _hud;
};

tlr_life_fhunger = {
	//Wait at least a second before updating
	if (time < (tlr_life_run_array select 0) + 1) exitWith {};
	//player groupChat "HUNGER RUNNING";
	//Hunger			Hunger			Act. Time		Time Last Run					Hunger per minute					60
	//Hunger			Hunger		+			(Time since last run in sec		*		Hunger per sec)
	// As hint: 1 = Hungry, 0=Can't eat anymore... so it counts up
	tlr_life_hunger = tlr_life_hunger + ((time -(tlr_life_run_array select 0)) * ((tlr_life_settings select tlr_life_hupm)/60));

	
	//Remove life if hunger >= 1
	if (tlr_life_hunger >= 1) then {
		private["_life"];
				//Act life		+	((Time - lastrun)					*  (damage per min / 60)
				//Act life		+   timediff in sec	* damage per sec
		_life = (damage player) + ((time -(tlr_life_run_array select 0)) * ((tlr_life_settings select tlr_life_hull)/60));
		player setDamage _life;
		tlr_life_hunger = 1;
	};
	tlr_life_run_array set [0, time];
};

tlr_life_fthirst = {
	if (time < (tlr_life_run_array select 1) + 1) exitWith {};
	//player groupChat "THIRST RUNNING";
	tlr_life_thirst = tlr_life_thirst + ((time -(tlr_life_run_array select 1)) * ((tlr_life_settings select tlr_life_thpm)/60));
	if (tlr_life_thirst >= 1) then {
		private["_life"];
				//Act life		+	((Time - lastrun)					*  (damage per min / 60)
				//Act life		+   timediff in sec	* damage per sec
		_life = (damage player) + ((time -(tlr_life_run_array select 1)) * ((tlr_life_settings select tlr_life_thll)/60));
		player setDamage _life;
		tlr_life_thirst = 1;
	};
	tlr_life_run_array set [1, time];
};

tlr_life_ftiredness = {
	if (time < (tlr_life_run_array select 2) + 1) exitWith {};
	//player groupChat "TIREDNESS RUNNING";
	tlr_life_tiredness = tlr_life_tiredness + ((time -(tlr_life_run_array select 2)) * ((tlr_life_settings select tlr_life_tipm)/60));
	if (tlr_life_tiredness >= 1) then {
		private["_life"];
				//Act life		+	((Time - lastrun)					*  (damage per min / 60)
				//Act life		+   timediff in sec	* damage per sec
		_life = (damage player) + ((time -(tlr_life_run_array select 2)) * ((tlr_life_settings select tlr_life_till)/60));
		player setDamage _life;
		tlr_life_tiredness = 1;
	};
	tlr_life_run_array set [2, time];
};

tlr_life_persistend = {
	private["_var", "_forced"];
	//Just save everything, if it's disabled it just won't be loaded
	//[83, 97, 118, 105, 110, 103, 32, 101, 118, 101, 114, 121, 32, 53, 32, 115, 101, 99, 111, 110, 100, 115];
	_forced = _this select 0;
	
	if ((time < (tlr_life_run_array select 3) + parseNumber (toString([53]))) and not(_forced)) exitWith {};
	// groupChat "PERSISTEND RUNNING";
	_var = format["hunger_%1", (side player)];
	[player, _var, tlr_life_hunger] call player_set_scalar;
	_var = format["thirst_%1", (side player)];
	[player, _var, tlr_life_thirst] call player_set_scalar;
	_var = format["tiredness_%1", (side player)];
	[player, _var, tlr_life_tiredness] call player_set_scalar;
	_var = format["life_%1", (side player)];
	[player, _var, (damage player)] call player_set_scalar;
	tlr_life_run_array set [3, time];
	
};

tlr_life_eat = {
	//Eating something
	private["_item", "_amount", "_item_name", "_restore_hunger", "_restore_health", "_life"];
	_item = _this select 0;
	_amount = _this select 1;
	_item_name = _item call INV_GetItemName;
	_life = damage player;
	//Type and avail amount are already checked in the usefood handler for calling this function
	//Restore is value in percentage of maximum, all would be 100
	//Negative values mean lifeloss / hungerloss
	switch _item do {
		case "boar": {_restore_hunger = 50; _restore_health = 25;};
		case "rabbit": {_restore_hunger = 15; _restore_health = 2.5;};
		case "chicken": {_restore_hunger = 15; _restore_health = 2.5;};
		case "cow": {_restore_hunger = 100; _restore_health = 50;};
		case "dog": {_restore_hunger = 20; _restore_health = 5;};
		case "sheep": {_restore_hunger = 50; _restore_health = 25;};
		case "goat": {_restore_hunger = 100; _restore_health = 100;};
		case "strangemeat": {_restore_hunger = -25; _restore_health = -10;};
		case "trout": {_restore_hunger = 10; _restore_health = 2;};
		case "walleye": {_restore_hunger = 12.5; _restore_health = 2.25;};
		case "perch": {_restore_hunger = 15; _restore_health = 3;};
		case "bass": {_restore_hunger = 14; _restore_health = 4;};
		case "Bread": {_restore_hunger = 100; _restore_health = 0;};
	};
	
	_restore_hunger = (_restore_hunger)/100 * _amount;
	_restore_health = (_restore_health)/100 * _amount;
	
	//Actual restoring
	//Hunger
	tlr_life_hunger = tlr_life_hunger - _restore_hunger;
	if (tlr_life_hunger < 0) then {tlr_life_hunger = 0;};
	
	//Life
	_life = _life - _restore_health;
	if (_life < 0) then {_life = 0;};
	player setDamage _life;
	
	player groupChat format["You ate %1 units of %2", _amount, _item_name];
	
};

tlr_life_drink = {
	//Drinking something
	private["_item", "_amount", "_item_name", "_restore_thirst", "_restore_tiredness", "_tiredness", "_drunk"];
	_item = _this select 0;
	_amount = _this select 1;
	_item_name = _item call INV_GetItemName;

	//Type and avail amount are already checked in the usefood handler for calling this function
	//Restore is value in percentage of maximum, all would be 100
	//Negative values mean lifeloss / hungerloss
	//Restore_hunger = thirst, restore_health = tiredness, too lazy to rename
	switch _item do {
		case "beer": {_restore_thirst = 15; _restore_tiredness = -5; _drunk = true;};
		case "beer2": {_restore_thirst = 15; _restore_tiredness = -5;_drunk = true;};
		case "vodka": {_restore_thirst = 5; _restore_tiredness = -7.5;_drunk = true;};
		case "smirnoff": {_restore_thirst = 10; _restore_tiredness = -6;_drunk = true;};
		case "wiskey": {_restore_thirst = 5; _restore_tiredness = -7.5;_drunk = true;};
		case "wine": {_restore_thirst = 20; _restore_tiredness = -2.5;_drunk = true;};
		case "wine2": {_restore_thirst = 20; _restore_tiredness = -2.5;_drunk = true;};
		case "water": {_restore_thirst = 50; _restore_tiredness = 0;_drunk = false;};
		case "coffee": {_restore_thirst = -10; _restore_tiredness = 50;_drunk = false;};
	};
	
	_restore_thirst = (_restore_thirst)/100 * _amount;
	_restore_tiredness = (_restore_tiredness)/100 * _amount;
	
	//Actual restoring
	//Thirst
	tlr_life_thirst = tlr_life_thirst - _restore_thirst;
	if (tlr_life_thirst < 0) then {tlr_life_thirst = 0;};
	
	//Tiredness
	tlr_life_tiredness = tlr_life_tiredness - _restore_tiredness;
	if (tlr_life_tiredness < 0) then {tlr_life_tiredness = 0;};
	
	player groupChat format["You drunk %1 cups of %2.", _amount, _item_name];
	
	//Drunk?
	if (_drunk) then {
		["use", _item, _amount] execVM "alkeffekt.sqf";
	};

};

tlr_life_fsleep = {
	//Triggered using a action
	if (tlr_life_tiredness < 0.1) exitWith {
		player groupChat "You can't sleep now, you just got up";
	};
	//Animation "play dead"
	player playmove "AinjPpneMstpSnonWrflDnon_rolltoback";
	//Disabling input
	disableuserinput true;
	//Animation (hit)
	private["_sleeptime"];
	_sleeptime = time + (tlr_life_settings select tlr_life_sleep);
	while {time < _sleeptime} do {
		if (not(alive player)) exitWith {player groupChat "You got killed while sleeping... Better hide next time";};
		sleep 1;
	};
	//Getting up and Enabeling input again
	player playmove "";
	disableUserInput false;
	
	tlr_life_tiredness = 0;
	if ((tlr_life_settings select tlr_life_sleephealth) > 0) then {
		private["_life"];
		_life = damage player;
		if (alive player) then {
			player setDamage (_life-(tlr_life_settings select tlr_life_sleephealth));
		};
	};
	player groupChat "You woke up again and feel refreshed";
};

tlr_life_client_loop = {
	private["_run"];
	_run = _this select 0;
	if (isNil "_run") then {_run=0;};
	if (typeName _run != "SCALAR") then {_run = 0;};
	
	//Checking for kill and restoring
	if (not(alive player)) then {
		tlr_life_hunger = 0;
		tlr_life_thirst = 0;
		tlr_life_tiredness = 0;
		[true] call tlr_life_persistend;
		waitUntil{alive player};
		tlr_life_run_array = [time, time, time, (tlr_life_run_array select 3)];
	};
	//Update HUD
	[] call tlr_life_hud;
	//Update hunger
	[] call tlr_life_fhunger;
	//Update thirst
	[] call tlr_life_fthirst;
	//Update tiredness
	[] call tlr_life_ftiredness;
	//Save stats
	[false] call tlr_life_persistend;
	
	[_run + 1] call tlr_life_client_loop;
	
};

[] call tlr_life_init;

tlr_life_functions_loaded = true;