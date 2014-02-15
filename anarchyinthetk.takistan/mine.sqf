private["_action", "_minearray", "_item", "_number"];

_action = _this select 0;
if (player != (vehicle player)) exitwith {player groupChat "You cannot use this in a vehicle"};
if (_action != "use") exitWith {};
if (working) exitWith {};

private["_item", "_number", "_isInArea"];
_item   = _this select 1;
_number = _this select 2;

working = true;
_isInArea = false;

{
	if (player distance (getMarkerPos ((_x select 0) select 0)) < ((_x select 0) select 1) && not(iscop)) then {
		_isInArea = true; 
		_minearray = _x
	};
} forEach miningarray;

private [
		"_resource", "_max", "_infos", "_name", "_LN", "_total", "_amount", "_avail", "_space",
		"_shovel", "_pick", "_hammer", 
		"_workT", "_anim", "_animS", "_max", "_loop", "_weight"
	];	
	
_resource = _minearray select 1;
_infos = _resource call INV_GetItemArray;
_name = (_infos call INV_GetItemName);
_weight = (_infos call INV_GetItemTypeKg);
_LN = 0;

if (not(_isInArea)) exitWith {
		player groupChat "You are not near a mine.";
		working = false;
	};


#define SleepWait(timeA) private["_waittt"]; _waittt = time + timeA; waitUntil {time >= _waittt};


_shovel = false;
_pick = false;
_hammer = false;

_max = 0;
_loop = 0;
_total = 0;
_workT = "";
_anim = "";
_animS = 0;

switch (toLower _item) do {
			case "shovel": {
					_shovel = true;
					_workT = "Digging...";
					_anim = "AinvPknlMstpSlayWrflDnon";
					_animS = 1.3;
					_max = m_shovel_max;
					_loop = m_shovel_loop;
				};
			case "pickaxe": {
					_pick = true;
					_workT = "Working...";
					_anim = "AinvPknlMstpSlayWrflDnon";
					_animS = 1.3;
					_max = m_pick_max;
					_loop = m_pick_loop;
				};
			case "jackhammer": {
					_hammer = true;
					_workT = "Drilling...";
					_anim = "AmovPercMstpSnonWnonDnon_exercisekneeBendB";
					_animS = 0.8;
					_max = m_drill_max;
					_loop = m_drill_loop;
				};
			default {};
		};

while { _LN < _loop } do {
		titletext [_workT, "PLAIN DOWN", 0.5];
		
		player playmove _anim;
		
		SleepWait(_animS)
		
		if (_hammer) then {
				waitUntil { animationstate player != "amovPercMstpSnonWnonDnon_exercisekneeBendB" };
			}else{
				player switchmove "normal";
			};
			
		_LN = _LN + 1;
	};


_avail = floor (INV_CarryingCapacity - (call INV_GetOwnWeight));
_space = floor(INV_CarryingCapacity * _max);

if (_space > _avail) then {
		_space = _avail;
	};

if ((_space % _weight) > 0) then {
		_space = _space - (_space % _weight);
	};
_amount = _space / _weight;


player groupchat format["You got %1 %2.", _amount, _name];

[player, _resource, _amount] call INV_AddInventoryItem;

working = false;



