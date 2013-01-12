if(pickingup)exitwith {player groupchat "you are already picking up an item"};

pickingup   = true;

_action	    = _this select 2;
_this 	    = _this select 3;

_object	    = _this select 0;
_item  	    = _this select 1;
_encoded_amount = _this select 2;
_tamount    = [_encoded_amount] call decode_number;
_infos      = _item call INV_GetItemArray;
_name       = _infos call INV_GetItemName;
_itemweight = (_infos call INV_GetItemTypeKg)*_tamount;
_ownweight  = call INV_GetOwnWeight;
_amount     = [_encoded_amount] call decode_number;
_exitvar    = 0;
_time       = round time;

if ((_ownweight + _itemweight) > INV_CarryingCapacity) then {
	_amount = (floor((INV_CarryingCapacity - _ownweight) / (_infos call INV_GetItemTypeKg)));
	if (_amount <= 0) exitWith {player groupChat localize "STRS_inv_buyitems_maxgewicht"; _exitvar = 1; pickingup = false; };
};

if(_exitvar == 1) exitwith{};
pickingup   = true;

_object setvariable ["droparray", nil, true];

if(primaryweapon player == "" and secondaryweapon player == "")then{player playmove "AmovPercMstpSnonWnonDnon_AinvPknlMstpSnonWnonDnon"}else{player playmove "AinvPknlMstpSlayWrflDnon"};

sleep 1;

[player, _item, _amount, ([player] call player_inventory_name)] call INV_CreateItem;

player groupchat format["You picked up %1 %2", _amount, _name];

if(_amount < _tamount) then {
	_amount = _tamount - _amount;
	_object setvariable ["droparray", [([_amount] call encode_number), _item], true];
	_n = iactionarr find _object;
	if ( _n >= 0) then {
		player groupchat format["_object: %1, _n: %2, iactionarr: %3",_object, _n,  iactionarr];
		iactionarr set [_n, 0];
		iactionarr = iactionarr - [0, (iactionarr select (_n + 1))];
	};
}
else {
	deletevehicle _object;
};

pickingup   = false;



