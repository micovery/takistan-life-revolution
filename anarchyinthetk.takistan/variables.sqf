//============================================================================================================================================
seizemoneyreturn		 = 0.25; 							//Amount of money the cop gets by seizing illegal items (in percent of sell price)
INV_smscost              = 25;
add_civmoney             = 1250;
add_copmoney             = 2500;
add_workplace            = 1250;
CopWaffenAvailable       = 0;
CopInPrisonTime          = 180;
shooting_self            = 0;
srHinbewegen             = 0;
["isstunned", false] call stats_init_variable;
hatGanggebietErobert     = false;
CivTimeInPrison          = 0;
CopLog                   = [];
MayorTaxes               = 0;
MayorTaxPercent          = 35;
chiefSteuern             = 0;
chiefBekommtSteuern      = 35;
eigene_zeit              = time;

money_limit              = 1000000000;
bank_limit               = 1000000000;

wantedbonus              = 25000;
monehStehlenMax          = 200000;
demerits                 = 0;
gtbonus                  = 10;
gtactive                 = false;
keyblock                 = false;
maxmanitime              = 2400;
powerrestorecost         = 10000;
impoundpay               = 1000;
noholster                = false;
MGcost                   = 10000;
PKcost                   = 10000;
SQUADcost                = 20000;
maxinfai                 = 16;
firestrikes              = 3;
totalstrikes             = 3;
facworkercost            = 15000;
fvspam                   = false;
maxfacworkers            = 50;
maxfacworkers2           = 41;
firingcaptive            = false;
lockpickchance           = 30;
planting                 = false;
drugstockinc             = 900;
druguserate              = 120;

currecciv               = false;
curreccop               = false;
currecins               = false;
currecred               = false;

buybi                   = false;

//========robbing variables===========
stolenfromtime          = 300;
stolenfromtimeractive   = false;  // dont change
//========AWESOME===========

stunshots              = 0;
stunshotsmax           = 3;

stunloop               = false;

MaxStunTime            = 15;

StunActiveTime         = 0;
StunTimePerHit         = 15;

Stuntimelight          = 5;

M_punch                = 1.5;

stunpistolfront        = 10;
stunpistolback         = 15;

stunriflefront         = 15;
stunrifleback          = 20;

stunpronecrit          = 30;
stunpronehev           = 25;
stunpronereg           = 20;

stunfrontcrit          = 25;
stunfronthev           = 20;
stunfrontreg           = 15;

stunbackcrit           = 30;
stunbackhev            = 25;
stunbackreg            = 25;

M_prone_crit           = 0.1;
M_prone_hev            = 0.05;
M_prone_reg            = 0.01;

M_front_crit           = 0.05;
M_front_hev            = 0.01;
M_front_reg            = 0.005;

M_back_crit            = 0.5;
M_back_hev             = 0.1;
M_back_reg             = 0.05;

pmcopmax               = 3;
pmccoplimit            = 0;
pmccoptimer            = 60 * 30;
pmccoptimerz           = false;

S_LOADED               = false;
A_running              = false;

A_actions              = compile preprocessfilelinenumbers "actions.sqf";
A_actionsremove        = compile preprocessfilelinenumbers "actionsRemove.sqf";

huntingarray           = 
[
    ["hunting1", "Hunting Area 1 - Chickens, Cows",     500, ["Hen", "Cock", "Cow", "Cow01", "Cow02", "Cow03", "Cow04", "Cow01_EP1"], [35,5,5,5,5,5,5,5], [25,25,25,75,55,15,25,35]],
    ["hunting2", "Hunting Area 2 - Boars, Rabbits",     500, ["WildBoar", "Rabbit"], [35,50], [120,30]],
    ["hunting3", "Hunting Area 3 - Dogs, Sheep",         500, ["Pastor", "Fin", "Sheep", "Sheep02_EP1"], [5,5,40,10], [200,150,60,120]],
    ["hunting4", "Hunting Area 4 - Boars, Rabbits",     500, ["WildBoar", "Rabbit"], [35,50], [120,30]],
    ["hunting5", "Hunting Area 5 - Goats",                 500, ["Goat", "Goat01_EP1", "Goat02_EP1"], [10,10,10], [350, 800, 175]]
];

backup_cop_weapons      =
[
    "ItemMap",
    "ItemRadio",
    "ItemCompass",
    "ItemWatch",
    "M9",
    "m16a4"
];

backup_cop_magazines    =
[
    "15Rnd_9x19_M9",
    "15Rnd_9x19_M9",
    "15Rnd_9x19_M9SD",
    "15Rnd_9x19_M9SD",
    "30Rnd_556x45_Stanag",
    "30Rnd_556x45_Stanag",
    "30Rnd_556x45_Stanag",
    "30Rnd_556x45_Stanag",
    "30Rnd_556x45_Stanag",
    "30Rnd_556x45_Stanag",
    "SmokeShell",
    "SmokeShell",
    "HandGrenade",
    "HandGrenade"
];

backup_opf_weapons      =
[
    "ItemMap",
    "ItemRadio",
    "ItemCompass",
    "ItemWatch",
    "Makarov",
    "AK_74_GL_kobra"
];
backup_opf_magazines    =
[
    "8Rnd_9x18_Makarov",
    "8Rnd_9x18_Makarov",
    "30Rnd_545x39_AK",
    "30Rnd_545x39_AK",
    "30Rnd_545x39_AK",
    "30Rnd_545x39_AK",
    "30Rnd_545x39_AK",
    "30Rnd_545x39_AK",
    "HandGrenade_East",
    "HandGrenade_East"
];

backup_ins_weapons      =
[
    "ItemMap",
    "ItemRadio",
    "ItemCompass",
    "ItemWatch",
    "AK_47_S"
];

backup_ins_magazines    =
[
    "30Rnd_762x39_AK47",
    "30Rnd_762x39_AK47",
    "30Rnd_762x39_AK47",
    "30Rnd_762x39_AK47",
    "30Rnd_762x39_AK47",
    "30Rnd_762x39_AK47",
    "HandGrenade_East",
    "HandGrenade_East"
];


//========AWESOME===========


//===============MOTD==================
motdwaittime            = 120;

//===============Cop Patrol==================

pmissionactive          = false;
patrolwaittime          = false;
patrolmoneyperkm        = 5.0;  // 1 would be equal to $7,000 for 1KM

//=========government convoy=============
govconvoybonus          = 20000;
convoyrespawntime       = 30;  //reset to 30 after testing

//===== Gas station robbing
maxstationmoney         = 35000;
wantedamountforrobbing  = 25000;

if(debug)then{drugstockinc = 6;druguserate = 20};
//==============================PETROL/OIL=========================================
fuel_max_reserve        = 10000; //(how many liters in reserve)
fuel_per_barrel         = 100; //(how many liters in 1 barrel)
fuel_pump_rate          = 3; //(how fast in liters/second fuel is dispensed)
fuel_base_price         = 1; //(price of 1 liter of fuel)
if (isServer) then { [0] call shop_set_fuel_consumed; };


//==============================MINING=============================================
shoveldur=20;
shovelmax=2;
pickaxedur=50;
pickaxemax=3;
hammerdur=100;
hammermax=4;
working=false;

//===============================GANGS=============================================
gangincome          = 15000;
gangcreatecost      = 75000;
gangdeltime         = 300;
gangareas           = [gangarea1,gangarea2,gangarea3];

//=================================================================================
CityLocationArray   = [[CityLogic1, 500], [CityLogic2, 400], [CityLogic4, 500], [CityLogic5, 200], [Militarybase, 200]];
respawnarray        = [respawn1,respawn2,respawn3,respawn4,respawn5,respawn6,respawn7,respawn8,respawn9,respawn10,respawn11,respawn12];

//=========== cop patrol array ==========
coppatrolarray  =
[
    getmarkerpos "patrolpoint1",
    getmarkerpos "patrolpoint2",
    getmarkerpos "patrolpoint3",
    getmarkerpos "patrolpoint4",
    getmarkerpos "patrolpoint5",
    getmarkerpos "patrolpoint6",
    getmarkerpos "patrolpoint7",
    getmarkerpos "patrolpoint8",
    getmarkerpos "patrolpoint9",
    getmarkerpos "patrolpoint10",
    getmarkerpos "patrolpoint11",
    getmarkerpos "patrolpoint12",
    getmarkerpos "patrolpoint13"
];

if (iscop) then {
    RadioTextMsg_1 = "Put your fucking hands up!";
    RadioTextMsg_2 = "Pull over and stay in your vehicle!";
    RadioTextMsg_3 = "Drop your weapon and put your hands on your head!";
    RadioTextMsg_4 = "Your free to go, have a nice day";
} else {
    RadioTextMsg_1 = "Put your fucking hands up now!";
    RadioTextMsg_2 = "Step away from the vehicle!";
    RadioTextMsg_3 = "Do it now or your dead!";
    RadioTextMsg_4 = "Dont shoot i give up!";
};

RadioTextArt_1 = "direct";
RadioTextArt_2 = "direct";
RadioTextArt_3 = "direct";
RadioTextArt_4 = "direct";

publicarbeiterarctionarray = [];

private["_i"];

robpoolsafe1           = 0; 
robpoolsafe2           = 0;
robpoolsafe3           = 0;
deadtimebonus          = 0.001;

["arrested", false] call stats_init_variable;
["deadtimes", 0] call stats_init_variable;
["copskilled", 0] call stats_init_variable;
["civskilled", 0] call stats_init_variable;
["arrestsmade", 0] call stats_init_variable;

selfkilled               = 0;
killstrafe               = 20000;
copteamkillstrafe        = 20000;
GesetzAnzahl             = 10;
LawsArray              = [
	"Always Drive on the RIGHT side of the road", 
	"DONT place buildings or hideouts on streets", 
	"Always Holster weapons in Towns 1k/1min jail.",
	"Completing an assassination mission is murder", 
	"_______________(empty)__________________", 
	"_______________(empty)__________________", 
	"_______________(empty)__________________", 
	"_______________(empty)__________________",  
	"_______________(empty)__________________",  
	"_______________(empty)__________________"
];

isMayor                  = false;
WahlArray                = [];
MayorNumber              = -1;
MayorExtraPay            = 5000;

private["_i"];
_i = 0;
while { _i < (count playerstringarray) } do {
	WahlArray = WahlArray + [ [] ];
	_i = _i + 1;
};

ischief                  = false;
WahlArrayc               = [];
chiefNumber              = -1;
chiefExtraPay            = 10000;

private["_i"];
_i = 0;
while { _i < (count playerstringarray) } do {
	WahlArrayc = WahlArrayc + [ [] ];
	_i = _i + 1;
};

atmscriptrunning = 0;
shopactivescript = 0;
deadcam_wechsel_dauer    = 5;
slave_cost               = 50000;
slavemoneyprosekunde	 = 500;
maxslave                 = 6;
copslaveallowed          = 1;
localslave               = 0;
localslavecounter        = 0;
huren_cost               = 50000;
hoemoneyprosekunde       = 500;
maxhuren                 = 5;
copworkerallowed         = 0;
pimpactive               = 0;
localhuren               = 0;
localhurencounter        = 0;
speedbomb_minspeed       = 1;
speedbomb_maxspeed       = 100;
speedbomb_mindur         = 10;
speedbomb_maxdur         = 300;
zeitbombe_mintime        = 1;
zeitbombe_maxtime        = 10;
HideoutLocationArray     = CityLocationArray;
publichideoutarray       = [];
hideoutcost              = 20000;
marker_ausserhalb        = param1;
marker_innerhalb         = 5;
marker_CopDistance       = 50; //controls distance cops need to be to make civ dots appear outside of towns.
CivMarkerUngenau         = 20;

classmap = 
[
	["money", "EvMoney"],
	["kanister", "Land_Canister_EP1"],
	["fernzuender", "SatPhone"],
	["fernzuenderbombe", "Explosive"],
	["selbstmordbombe", "Explosive"],
	["zeitzuenderbombe", "Explosive"],
	["aktivierungsbombe", "Explosive"],
	["geschwindigkeitsbombe", "Explosive"],
	["OilBarrel", "Barrel4"],
	["Oil", "Barrel1"],
	["Unprocessed_Cocaine", "Land_Bag_EP1"],
	["Unprocessed_Marijuana", "Land_Bag_EP1"],
	["Unprocessed_LSD", "Land_Bag_EP1"],
	["Unprocessed_Heroin", "Land_Bag_EP1"],
	["marijuana", "Land_Sack_EP1"],
	["cocaine", "Land_Sack_EP1"],
	["lsd", "Land_Sack_EP1"],
	["heroin", "Land_Sack_EP1"],
	["kleinesreparaturkit", "Land_Pneu"],
	["reparaturkit", "Land_Pneu"],
	["medkit", "Suitcase"],
	["bankversicherung", "EvKobalt"]
];

droppableitems = [];
{
	private["_map", "_class"];
	_map = _x;
	_class = _map select 1;
	droppableitems set [(count droppableitems), _class];
} forEach classmap;

item2class = {
	private["_item", "_class"];
	_item = _this select 0;
	_class = "Suitcase";
	
	//player groupChat format["item to class %1", _item];
	if (isNil "_item") exitWith {_class};
	if (typeName _item != "STRING") exitWith {_class};
	
	
	{	
		private["_cmap", "_citem", "_cclass"];
		_cmap = _x;
		_citem = _cmap select 0;
		_cclass = _cmap select 1;
		//player groupChat format["map: %1", _cmap];
		if (_item == _citem) exitWith {
			_class = _cclass;
		};
	} forEach classmap;
	
	_class
};

workplace_object = 0;
workplace_radius = 1;
workplacearray           = [[workplace1, 80], [workplace2, 80], [workplace3, 60]];

nonlethalweapons         = ["Binocular", "NVGoggles", "ItemMap", "ItemCompass", "ItemRadio", "ItemWatch", "ItemGPS"];
slavearray               = workplacearray;
timeinworkplace          = 0;
wpcapacity               = 10;
INV_hasitemshop          = 0;
INV_haswepshop           = 0;
gunlicensetargets        = [t11,t12,t21,t22,t31,t32,t41,t42,t51,t52,t61,t62,t71,t72,t81,t82,t91,t92,t101,t111,t112,t121,t131,t132,t133,t134,t135];
["BuildingsOwnerArray", []] call stats_init_variable;

tlr_hud_array = [];

if(isciv) then {
BuyAbleBuildingsArray    =
    [
        ["wp1", "Workplace 1", workplace_getjobflag_1, 100000, 500, "wp", "WpAblage_1"],
        ["wp2", "Workplace 2", workplace_getjobflag_2, 200000, 1000, "wp", "WpAblage_2"],
        ["wp3", "Workplace 3", workplace_getjobflag_3, 350000, 1500, "wp", "WpAblage_3"]
    ];
};

// array used in taxi missions
civclassarray         =
[
    "TK_CIV_Takistani01_EP1",
    "TK_CIV_Takistani02_EP1",
    "TK_CIV_Takistani03_EP1",
    "TK_CIV_Takistani04_EP1",
    "TK_CIV_Takistani05_EP1",
    "TK_CIV_Takistani06_EP1",
    "TK_CIV_Woman01_EP1",
    "TK_CIV_Woman02_EP1",
    "TK_CIV_Woman03_EP1",
    "TK_CIV_Worker01_EP1",
    "TK_CIV_Worker02_EP1",
    "Citizen2_EP1",
    "Citizen3_EP1",
    "CIV_EuroMan01_EP1",
    "CIV_EuroMan02_EP1",
    "Dr_Hladik_EP1",
    "Functionary1_EP1",
    "Functionary2_EP1",
    "Haris_Press_EP1",
    "Profiteer2_EP1"
];

civslavearray          = ["Hooker1","Hooker2","Hooker3","Hooker4","RU_Hooker1","RU_Hooker2","RU_Hooker3","RU_Hooker4"];
civworkerarray         = ["Worker1","Worker2","Worker3","Worker4"];
terroristarray         = ["TK_GUE_Soldier_3_EP1","TK_GUE_Soldier_AAT_EP1","TK_GUE_Soldier_AT_EP1","TK_GUE_Soldier_EP1","TK_GUE_Soldier_HAT_EP1","TK_INS_Soldier_AAT_EP1","TK_INS_Soldier_EP1"];

player_connected_handler = {
	private["_id", "_name", "_uid"];
	_id = _this select 0;
	_name = _this select 1;
	_uid = _this select 2;
	
	publicVariable "LawsArray";
	publicVariable "INV_ItemTypenArray";
	publicVariable "INV_ItemStocks";
	publicVariable "INV_ItemMaxStocks";
};

if(isServer)then {
	onPlayerConnected { [_id, _name, _uid] call player_connected_handler };
};
