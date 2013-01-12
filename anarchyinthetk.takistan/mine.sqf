
private["_action", "_minearray"];

_action = _this select 0;
if (_action != "use") exitWith {};
if (working) exitWith {};

private["_item", "_number"];
_item   = _this select 1;
_number = _this select 2;

private["_isInArea"];

working = true;
_isInArea = false;

{
	if (player distance (getMarkerPos ((_x select 0) select 0)) < ((_x select 0) select 1) && not(iscop)) then {
		_isInArea = true; 
		_minearray = _x
	};
} forEach miningarray;

private["_resource", "_max", "_infos", "_name"];
_resource = _minearray select 1;
_max = _minearray select 2;
_infos = _resource call INV_GetItemArray;
_name = (_infos call INV_GetItemName);

if (not(_isInArea)) exitWith {
	player groupChat "You are not near a mine.";
	working = false;
};

if (_item == "Shovel") then {
	totalamount=0;
	_max = shovelmax;
	
	private["_i"];
	_i = 0;
	while { _i < 4 } do {
		_amount = round (random _max);
		titletext ["Digging...", "PLAIN DOWN", 0.1];
		player playmove "AinvPknlMstpSlayWrflDnon";
		
		sleep 1.3;
		player switchmove "normal";
		shoveldur = shoveldur - (floor (random 2));

		if(shoveldur <= 0) exitWith {
			player groupchat "The shovel broke"; 
			[player, "Shovel", -1] call INV_AddInventoryItem; shoveldur=20;
		};

		_avail = floor (INV_CarryingCapacity - (call INV_GetOwnWeight));

		totalamount = totalamount + _amount;
		if ((totalamount*3) >= _avail) exitWith {
			totalamount = (_avail/3); 
			player groupchat "maximum weight reached"; 
			_i = 6;
		};
		
		player groupchat format["You got %1 %2.", _amount, _name];
		_i = _i + 1;
	};
	
	totalamount = (floor (totalamount));
	[player, _resource, totalamount] call INV_AddInventoryItem;
};

if (_item == "Pickaxe") then {
	private["_max"];
	totalamount=0;
	_max = pickaxemax;
	
	private["_i"];
	_i = 0;
	while { _i < 4 } do {
		private["_amount"];
		_amount = round (random _max);
		
		titletext ["Working...", "PLAIN DOWN", 0.1];
		
		player playmove "AinvPknlMstpSlayWrflDnon";
		sleep 1.3;
		player switchmove "normal";
		
		pickaxedur = pickaxedur - (floor (random 2));

		if(pickaxedur <= 0) exitWith {
			player groupchat "The pickaxe broke"; 
			[player, "Pickaxe", -1] call INV_AddInventoryItem; 
			pickaxedur=50;
		};

		_avail = floor (INV_CarryingCapacity - (call INV_GetOwnWeight));

		totalamount = totalamount + _amount;
		if((totalamount*3) >= _avail) exitwith {
			totalamount = (_avail/3); player groupchat "maximum weight reached"; _i=6;
		};

		player groupchat format["You got %1 %2.", _amount, _name];
		_i = _i + 1;
	};
	
	totalamount = (floor (totalamount));
	[player, _resource, totalamount] call INV_AddInventoryItem;
};

if (_item == "JackHammer") then {
	totalamount=0;
	_max = hammermax;

	private["_i"];
	_i = 0;
	while { _i < 4 } do {
		titletext ["Drilling...", "PLAIN DOWN", 0.1];
		player playmove "AmovPercMstpSnonWnonDnon_exercisekneeBendB";
		
		private["_amount", "_avail" ];
		_amount = round (random _max);
		hammerdur = hammerdur - (floor (random 2));
		
		if(hammerdur <= 0) exitWith {
			player groupchat "The Jack Hammer broke"; 
			[player, "Jack Hammer", -1] call INV_AddInventoryItem; 
			hammerdur=100;
		};
		
		_avail = floor (INV_CarryingCapacity - (call INV_GetOwnWeight));
		totalamount = totalamount + _amount;
		
		if ((totalamount*3) >= _avail) exitWith {
			totalamount = (_avail/3); player groupchat "maximum weight reached"; _i=6;
		};
		
		player groupchat format["You got %1 %2", _amount, _name];
		sleep 0.8;
		_amount = round (random _max);
		
		hammerdur = hammerdur - (floor (random 2));
		
		if (hammerdur <= 0) exitWith {
			player groupchat "The Jack Hammer broke"; 
			[player, "Jack Hammer", -1] call INV_AddInventoryItem; 
			hammerdur=100;
		};
		
		_avail = floor (INV_CarryingCapacity - (call INV_GetOwnWeight));
		totalamount = totalamount + _amount;
		if ((totalamount*3) >= _avail) exitWith {
			totalamount = (_avail/3); player groupchat "maximum weight reached"; _i=6;
		};
		
		player groupchat format["You got %1 %2", _amount, _name];
		sleep 0.8;
		_amount = round (random _max);
		hammerdur = hammerdur - (floor (random 2));
		if (hammerdur <= 0) exitWith {
			player groupchat "The Jack Hammer broke"; 
			[player, "Jack Hammer", -1] call INV_AddInventoryItem; 
			hammerdur=100;
		};
		
		_avail = floor (INV_CarryingCapacity - (call INV_GetOwnWeight));
		totalamount = totalamount + _amount;
		
		if ((totalamount*3) >= _avail) exitWith {
			totalamount = (_avail/3); player groupchat "maximum weight reached"; _i=6;
		};
		
		player groupchat format["You got %1 %2", _amount, _name];
		waitUntil { animationstate player != "amovPercMstpSnonWnonDnon_exercisekneeBendB" };
		
		_i = _i + 1;
	};
	
	totalamount = (floor (totalamount));
	[player, _resource, totalamount] call INV_AddInventoryItem;
};

working = false;

