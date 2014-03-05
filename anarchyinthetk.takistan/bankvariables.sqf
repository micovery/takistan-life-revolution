startmoneh					= if(debug)then{1000000000}else{50000};
donatormoneh				= startmoneh * 5; //(250k)
silvermoneh					= donatormoneh * 2; //(500k)
goldmoneh					= donatormoneh * 3; //(750k)
platinummoneh				= donatormoneh * 4 ; //(1 million)
adminmoneh					= donatormoneh * 12;  //(3 million)

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
if(isNil "bank_tax") then{
	bank_tax				= 5;
	publicVariable	"bank_tax";
};
zinsen_prozent               = 1;
zinsen_dauer                 = 1200;
robenable                    = true;

if (isServer) then {
	_handle = [] spawn listFile_loadDonators_Init;
	 waitUntil{scriptDone _handle};
} else {
	private["_timeout"];
	_timeout = time + 5;
	waitUntil {(server getVariable ["DONATOR_LOAD", false]) || (time > _timeout)};
	donators0     = server getVariable ["donators0",[]];
	donators1     = server getVariable ["donators1",[]];
	donators2     = server getVariable ["donators2",[]];
	donators3     = server getVariable ["donators3",[]];
	donators4     = server getVariable ["donators4",[]];
	alldonators   = donators1 + donators2 + donators3 + donators4;
};
	
private["_uid"];
_uid = getPlayerUID player;

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

if (isAdmin) then {
	startmoneh = startmoneh + adminmoneh;
};

if (isNil "bankaccount") then {
	["bankaccount", ([startmoneh] call encode_number)] call stats_init_variable;
};


shopflagarray            = [shop1,shop2,shop3,shop4];
bankflagarray            = [mainbank, copbank, atm1, atm2, atm3, atm4, atm5, atm6, atm8, atm11, atm12, atmpf, atmins, pmcatm, adminbank];
carshoparray             = [carshop1, carshop2, carshop3, carshop4, carshop5, carshop6, carshop7, carshop8];
speedcamarray            = [speed1,speed2,speed3,speed4,speed5];
drugsellarray            = [mdrugsell,cdrugsell,ldrugsell,hdrugsell];
GasStationArray          = [
    (nearestobject[getPosATL fuelshop1, "Land_Ind_FuelStation_Feed_Ep1"]),
    (nearestobject[getPosATL fuelshop2, "Land_Ind_FuelStation_Feed_Ep1"]),
    (nearestobject[getPosATL fuelshop3, "Land_Ind_FuelStation_Feed_Ep1"]),
    (nearestobject[getPosATL fuelshop4, "Land_Ind_FuelStation_Feed_Ep1"]),
    (nearestobject[getPosATL fuelshop5, "Land_Ind_FuelStation_Feed_Ep1"]),
    (nearestobject[getPosATL fuelshop6, "Land_Ind_FuelStation_Feed_Ep1"]),
    (nearestobject[getPosATL fuelshop7, "Land_Ind_FuelStation_Feed_Ep1"]),
    (nearestobject[getPosATL fuelshop8, "Land_Ind_FuelStation_Feed_Ep1"]),
    (nearestobject[getPosATL fuelshop9, "Land_Ind_FuelStation_Feed_Ep1"])
];


//	[] spawn compile preProcessFileLineNumbers "interest.sqf";