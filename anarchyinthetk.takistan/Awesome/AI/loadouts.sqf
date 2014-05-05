if (not(isNil "custom_ai_loadouts_loaded")) exitWith {};


/* Loadout Format:
 * ["Displayname", check, [Weapons], [Magazines], ai class, price];
 * 0 = Displayname
 * 1 = check
 * 2 = Weapons array
 * 3 = Magazine array
 * 4 = class type (skin)
 * 5 = price
*/

/*

*/

private["_ai_base_price"];
_ai_base_price = 100000;

customAILoadouts = [
					["Default Cop AI", 			"(isCop)", 																["ItemMap","ItemRadio","ItemCompass","ItemWatch","m16a4"],					["30Rnd_556x45_Stanag","30Rnd_556x45_Stanag","30Rnd_556x45_Stanag","30Rnd_556x45_Stanag","30Rnd_556x45_Stanag","30Rnd_556x45_Stanag","SmokeShell","SmokeShell",	"HandGrenade","HandGrenade"],			"UN_CDF_Soldier_EP1", 		_ai_base_price+("m16a4" call INV_GetItemBuyCost)+("Rnd_556x45_Stanag" call INV_GetItemBuyCost)*6],
					["Default Opfor AI", 		"(isOpf)", 																["ItemMap","ItemRadio","ItemCompass","ItemWatch","AK_74_GL_kobra"],			["30Rnd_545x39_AK","30Rnd_545x39_AK","30Rnd_545x39_AK","30Rnd_545x39_AK","30Rnd_545x39_AK","30Rnd_545x39_AK","HandGrenade_East","HandGrenade_East"],													"TK_Soldier_EP1", 			_ai_base_price+("AKS74kobragl" call INV_GetItemBuyCost)+("Rnd_545x39_AK" call INV_GetItemBuyCost)*6],
					["Default Insurgent AI", 	"(isIns)",									 							["ItemMap","ItemRadio","ItemCompass","ItemWatch","AK_47_S"], 				["30Rnd_762x39_AK47","30Rnd_762x39_AK47","30Rnd_762x39_AK47","30Rnd_762x39_AK47","30Rnd_762x39_AK47","30Rnd_762x39_AK47","HandGrenade_East","HandGrenade_East"],										"TK_GUE_Soldier_EP1", 		_ai_base_price+("AK_47_S" call INV_GetItemBuyCost)+("Rnd_545x39_AK" call INV_GetItemBuyCost)*6],
					["Sniper", 					'(isCop and ([player, "sobr_training"] call player_has_license))', 		["ItemMap", "ItemRadio", "ItemCompass", "ItemWatch", "NVGoggles", "DMR"], 	["20Rnd_762x51_DMR","20Rnd_762x51_DMR","20Rnd_762x51_DMR","20Rnd_762x51_DMR"],																															"UN_CDF_Soldier_EP1", 		_ai_base_price+("DMR" call INV_GetItemBuyCost)+("Rnd_762x51_DMR" call INV_GetItemBuyCost)*4+("NVGoggles" call INV_GetItemBuyCost)],
					["Sniper", 					'(isOpf and ([player, "bomb"] call player_has_license))',			 	["ItemMap", "ItemRadio", "ItemCompass", "ItemWatch", "NVGoggles", "SVD"], 	["10Rnd_762x54_SVD","10Rnd_762x54_SVD","10Rnd_762x54_SVD","10Rnd_762x54_SVD"], 																															"TK_Soldier_EP1", 			_ai_base_price+("SVD" call INV_GetItemBuyCost)+("Rnd_762x54_SVD" call INV_GetItemBuyCost)*4+("NVGoggles" call INV_GetItemBuyCost)],
					["Sniper", 					'(isIns and ([player, "bomb"] call player_has_license))', 				["ItemMap", "ItemRadio", "ItemCompass", "ItemWatch", "NVGoggles", "SVD"], 	["10Rnd_762x54_SVD","10Rnd_762x54_SVD","10Rnd_762x54_SVD","10Rnd_762x54_SVD"], 																															"TK_GUE_Soldier_EP1", 		_ai_base_price+("SVD" call INV_GetItemBuyCost)+("Rnd_762x54_SVD" call INV_GetItemBuyCost)*4+("NVGoggles" call INV_GetItemBuyCost)],
					["Medic (Unarmed)", 		'(isIns)',																["ItemMap", "ItemRadio", "ItemCompass", "ItemWatch"],						[],																																																		"GUE_Soldier_Medic",		_ai_base_price],
					["Medic (Unarmed)", 		'(isOpf)',																["ItemMap", "ItemRadio", "ItemCompass", "ItemWatch"],						[],																																																		"TK_Soldier_Medic_EP1",		_ai_base_price],
					["Medic (Unarmed)", 		'(isCop)',																["ItemMap", "ItemRadio", "ItemCompass", "ItemWatch"],						[],																																																		"US_Soldier_Medic_EP1",		_ai_base_price],
					["Gunner",					'(isCop and ([player, "sobr_training"] call player_has_license))',		["ItemMap", "ItemRadio", "ItemCompass", "ItemWatch","M240"],				["100Rnd_762x51_M240","100Rnd_762x51_M240","100Rnd_762x51_M240"],																																		"UN_CDF_Soldier_EP1",		_ai_base_price+("m240" call INV_GetItemBuyCost)+("Rnd_762x51_M240" call INV_GetItemBuyCost)*3],
					["Gunner",					'(isOpf and ([player, "bomb"] call player_has_license))',				["ItemMap", "ItemRadio", "ItemCompass", "ItemWatch","PK"],					["100Rnd_762x54_PK","100Rnd_762x54_PK","100Rnd_762x54_PK"],																																				"TK_Soldier_EP1",			_ai_base_price+("PK" call INV_GetItemBuyCost)+("Rnd_762x54_PK" call INV_GetItemBuyCost)*3],
					["Gunner",					'(isIns and ([player, "bomb"] call player_has_license))',				["ItemMap", "ItemRadio", "ItemCompass", "ItemWatch","PK"],					["100Rnd_762x54_PK","100Rnd_762x54_PK","100Rnd_762x54_PK"],																																				"TK_GUE_Soldier_EP1",		_ai_base_price+("PK" call INV_GetItemBuyCost)+("Rnd_762x54_PK" call INV_GetItemBuyCost)*3]
];





custom_ai_loadouts_loaded = true;