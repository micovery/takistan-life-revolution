if(iscop)exitwith{player groupchat "only civilians can do this!"};

_this 	 = _this select 3;
_item1	 = _this select 0;
_item2	 = _this select 1;
_req	 = _this select 2;
_license = _this select 3;

if(!(_license call INV_HasLicense))exitwith{player groupchat "you do not have the license to do this"};

_nitem1  = [player, _item1] call INV_GetItemAmount;


_multi = floor(_nitem1/_req);
_total = _req*_multi;

[player, _item1, -(_total)] call INV_AddInventoryItem;
[player, _item2, _multi, ([player] call player_inventory_name)] call INV_CreateItem;

_name1   = _item1 call INV_GetItemName;
_name2   = _item2 call INV_GetItemName;

player groupchat format["%1 %2 was processed into %3 %4!", _total, _name1, _multi, _name2];