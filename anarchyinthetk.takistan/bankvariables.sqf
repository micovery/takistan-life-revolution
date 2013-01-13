
startmoneh                   = 50000;

donatormoneh                 = 250000;
silvermoneh                  = 500000;
goldmoneh                    = 750000;
platinummoneh                = 1000000;

robb_timeSperre              = 1200;
local_useBankPossible        = true;
maxinsafe                    = 1000000000;
BankRaubKontoverlust         = 4000;
ShopRaubKontovershop         = 0;
ShopRaubProzentVershop       = 0;
rblock                       = 0;
stolencash                   = 0;
Maxbankrobpercentlost        = 0.05;
MaxbankrobpercentlostA       = 0.10;
MaxbankrobpercentlostB       = 0.20;
bank_tax                  = 5;
zinsen_prozent               = 1;
zinsen_dauer                 = 1200;
robenable                    = true;

_uid                         = getPlayerUID player;

donators1     = ["32114118","11864902","11872198","3478662","36557446","26082630","11060102","48390213","38996486","68448198","50452678","55164870","4022278","27321414","19960774","3289670","75077446","27514246","21532166","6028038","17781638","73708486","73764294","26213190","93001990","5803968"];
donators2     = ["71662278","51369350","6095040","34373126","10154566"];
donators3     = ["11124934","10006086","12071430"];
donators4     = ["24943814","72681222"];

if (_uid in donators1) then {
    startmoneh = donatormoneh;
}
else { if (_uid in donators2) then {
    startmoneh = silvermoneh;
}
else { if (_uid in donators3) then {
    startmoneh = goldmoneh;
}
else { if (_uid in donators4) then {
    startmoneh = platinummoneh;
};};};};

if (isNil "bankaccount") then {
    [player, startmoneh] call bank_set_value;
};

shopflagarray            = [shop1,shop2,shop3,shop4];
bankflagarray            = [mainbank, copbank, coppbank_1, atm1, atm2, atm3, atm4, atm5, atm6, atm8, atm11, atm12, atmpf, atmins, pmcatm, adminbank];
carshoparray             = [carshop1, carshop2, carshop3, carshop4, carshop5, carshop6, carshop7, carshop8];
speedcamarray            = [speed1,speed2,speed3,speed4,speed5];
drugsellarray            = [mdrugsell,cdrugsell,ldrugsell,hdrugsell];
GasStationArray          =
[
    copfuel,
    (nearestobject[getpos fuelshop1,"Land_Ind_FuelStation_Feed_Ep1"]),
    (nearestobject[getpos fuelshop2,"Land_Ind_FuelStation_Feed_Ep1"]),
    (nearestobject[getpos fuelshop3,"Land_Ind_FuelStation_Feed_Ep1"]),
    (nearestobject[getpos fuelshop4,"Land_Ind_FuelStation_Feed_Ep1"]),
    (nearestobject[getpos fuelshop5,"Land_Ind_FuelStation_Feed_Ep1"]),
    (nearestobject[getpos fuelshop6,"Land_Ind_FuelStation_Feed_Ep1"]),
    (nearestobject[getpos fuelshop7,"Land_Ind_FuelStation_Feed_Ep1"]),
    (nearestobject[getpos fuelshop8,"Land_Ind_FuelStation_Feed_Ep1"]),
    (nearestobject[getpos fuelshop9,"Land_Ind_FuelStation_Feed_Ep1"])
];