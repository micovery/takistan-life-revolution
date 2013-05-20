#include "Awesome\Functions\macro.h"

_art = _this select 0;

if (_art == "init") then {
    INV_hunger         = 25;
    INV_HungerProSek   = 0.010;
    INV_HungerSchaden  = 0.1;
    INV_HungerStartVal = 25;
    hungernachricht    = 0;
    _sleepTime         = 10;
    
    if (!isClient) exitWith {};

    while {true} do {
        if (INV_hunger >= 100) then {
            titleText [localize "STRS_inv_item_nahrung_verhungern", "plain"];
            player setDamage ((damage player) + (INV_HungerSchaden*_sleepTime));
            INV_hunger = 100;
        } else {
            INV_hunger = INV_hunger + (INV_HungerProSek*_sleepTime);

            if ((hungernachricht == 0) and (INV_hunger >= 90) and (INV_hunger < 91)) then {
                titleText [localize "STRS_inv_item_nahrung_verhungern", "plain"];
                hungernachricht = hungernachricht + 1;
            };

            if ((hungernachricht == 1) and (INV_hunger >= 91) and (INV_hunger < 92)) then {
                titleText [localize "STRS_inv_item_nahrung_verhungern", "plain"];
                hungernachricht = hungernachricht + 1;
            };

            if ((hungernachricht == 2) and (INV_hunger >= 92) and (INV_hunger < 93)) then {
                titleText [localize "STRS_inv_item_nahrung_verhungern", "plain"];
                hungernachricht = hungernachricht + 1;
            };

            if ((hungernachricht == 3) and (INV_hunger >= 93) and (INV_hunger < 94)) then {
                titleText [localize "STRS_inv_item_nahrung_verhungern", "plain"];
                hungernachricht = hungernachricht + 1;
            };

            if ((hungernachricht == 4) and (INV_hunger >= 94) and (INV_hunger < 95)) then {
                titleText [localize "STRS_inv_item_nahrung_verhungern", "plain"];
                hungernachricht = hungernachricht + 1;
            };

            if ((hungernachricht == 5) and (INV_hunger >= 95) and (INV_hunger < 96)) then {
                titleText [localize "STRS_inv_item_nahrung_verhungern", "plain"];
                hungernachricht = hungernachricht + 1;
            };

            if ((hungernachricht == 6) and (INV_hunger >= 96) and (INV_hunger < 97)) then {
                titleText [localize "STRS_inv_item_nahrung_verhungern", "plain"];
                hungernachricht = hungernachricht + 1;
            };

            if ((hungernachricht == 7) and (INV_hunger >= 97) and (INV_hunger < 98)) then {
                titleText [localize "STRS_inv_item_nahrung_verhungern", "plain"];
                hungernachricht = hungernachricht + 1;
            };

            if ((hungernachricht == 8) and (INV_hunger >= 98) and (INV_hunger < 99)) then {
                titleText [localize "STRS_inv_item_nahrung_verhungern", "plain"];
                hungernachricht = hungernachricht + 1;
            };

            if ((hungernachricht == 9) and (INV_hunger >= 99) and (INV_hunger < 100)) then {
                titleText [localize "STRS_inv_item_nahrung_verhungern", "plain"];
                hungernachricht = hungernachricht + 1;
            };

            if ((hungernachricht > 0) and (INV_hunger <= 90)) then {
                hungernachricht = 0;
            };

            if (!alive player) then {
                INV_hunger = 50;
            };
        };
        sleep _sleepTime;
    };
};


if (_art == "use") then {
    _item   = _this select 1;
    _anzahl = _this select 2;
    _hungerStillen = 0;
    _amount = [player, _item] call INV_GetItemAmount;

    switch _item do {
        case "trout":  { _hungerStillen = 20; };
        case "walleye":  { _hungerStillen = 20; };
        case "perch":  { _hungerStillen = 20; };
        case "bass":  { _hungerStillen = 20; };
        case "Whale":     { _hungerStillen = 50; };
        case "Donut":     { _hungerStillen = 25;  };
        case "Bread":     { _hungerStillen = 10;  };
        case "boar":     { _hungerStillen = 25;  };
        case "rabbit":     { _hungerStillen = 20;  };
        case "strangemeat":     { _hungerStillen = 15;  };
    };

    if (_amount >= _anzahl) then {
        [player, _item, -(_anzahl)] call INV_AddInventoryItem;
        if(_item == "Donut" and isciv)exitwith{player groupchat "the donut turns to ash in your mouth..."};
        INV_hunger = INV_hunger - (_hungerStillen*_anzahl);
        if (INV_hunger < 0) then {INV_hunger = 0};
        player groupChat format[localize "STRS_inv_item_nahrung_gegessen", strN((round (100-INV_hunger)))];
    } else {
        player groupchat "You do not have enough of this item";
    };
};

