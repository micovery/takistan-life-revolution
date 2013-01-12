_target = _this select 0;

_arguments = _this select 3;

_action_name = _arguments select 0;
_home   = _arguments select 1;


if (_action_name == "buy" ) then {
    _moneh  = [player, 'money'] call INV_GetItemAmount;
    _cost = (_home select home_buying_price);
    if (_moneh < _cost) 
        exitWith {player groupChat "Not enough money in your inventory to buy this house";};
	
    [player, 'money', -(_cost)] call INV_AddInventoryItem;

    [_home] call home_buy;  
	
    if(true) exitWith{};
};

if (_action_name == "sell") then {
    _moneh  = [player, 'money'] call INV_GetItemAmount;
    _cost = (_home select home_selling_price);

    [player, 'money', (_cost)] call INV_AddInventoryItem;
    [_home] call home_sell;
	
    if(true) exitWith{};
};

if (_action_name == "lock") then
{
    [_home] call home_lock;
    if(true) exitWith{};
};

if (_action_name == "unlock") then
{
    [_home] call home_unlock;
    if(true) exitWith{};
};

if (_action_name == "info") then
{
    [_home] call home_info;
    if(true) exitWith{};
};
