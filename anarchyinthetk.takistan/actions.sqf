if(A_running) exitwith {};
A_running = true;

private["_role"];
_role = player;

//====================================== HQ BOMB ======================================================
action1 =	_role addaction ["Defuse Bomb","noscript.sqf",'if(planting)exitwith{};planting=true;player playmove "AinvPknlMstpSlayWrflDnon_medic";sleep 4;waituntil {animationstate player != "AinvPknlMstpSlayWrflDnon_medic"};planting=false;if(!alive player)exitwith{};bombactive=false;publicvariable "bombactive";"hint ""The bomb has been defused!"";server globalchat ""The bomb has been defused!"";playsound ""fanfare"";" call broadcast;',1,false,true,"","player distance HQ <= 5 and iscop and bombactive and !planting"];
action2 =	_role addaction ["Plant Bomb","noscript.sqf",'if(planting)exitwith{};planting=true;publicvariable "planting";player playmove "AinvPknlMstpSlayWrflDnon_medic";sleep 4;waituntil {animationstate player != "AinvPknlMstpSlayWrflDnon_medic"};planting=false;publicvariable "planting";if(!alive player)exitwith{};bombactive=true;publicvariable "bombactive";',1,false,true,"","player distance HQ <= 5 and !bombactive and !planting and isciv"];
//====================================== BANK ROB =====================================================
action4 =	_role addaction ["Rob safe","bankrob.sqf", ["ausrauben", safe1],1,false,true,"","player distance safe1 <= 3 and isciv"];
action5 =	_role addaction ["Rob safe","bankrob.sqf", ["ausrauben", safe2],1,false,true,"","player distance safe2 <= 3 and isciv"];
action6 =	_role addaction ["Rob safe","bankrob.sqf", ["ausrauben", safe3],1,false,true,"","player distance safe3 <= 3 and isciv"];
//==================================== HOLSTER RIFLE ==================================================
//action7 = 	_role addaction ["Holster Rifle","\noscript.sqf",[""],1,false,true,"",'player distance workplacejob_deliveryflag3 <= 4'];
//===================================== ASSASSINATION =================================================
action8 = 	_role addaction ["Get Assassination job","assassination.sqf",["getajob_assassin"],1,false,true,"","player distance assassin <= 3 and isciv"];
action9 =   _role addaction ["Escort VIP", "noscript.sqf", "[VIPtarget] join (group player); player groupchat ""escort the VIP to the police base before he is assassinated!"";",1,false,true,"","player distance VIPtarget < 5 and iscop"];

//========================================= HUNTING ===================================================
action_h1 =  _role addaction ["Take boar meat","noscript.sqf",
'_no = ceil(random 7);if (((call INV_GetOwnWeight) + ("boar" call INV_GetItemTypeKg)*_no) > INV_CarryingCapacity)exitwith{player groupChat localize "STRS_inv_buyitems_maxgewicht"};(nearestobjects [getpos player, ["wildboar"],  3] select 0) setvariable ["inuse", 1, true]; player playmove "AinvPknlMstpSlayWrflDnon_medic";sleep 4;waituntil {animationstate player != "AinvPknlMstpSlayWrflDnon_medic"};deletevehicle (nearestobjects [getpos player, ["wildboar"],  3] select 0);[player, "boar", _no] call INV_AddInventoryItem;player groupchat format["you got %1 boar meat", _no];',
1,true,true,"",
'_w = (nearestobjects [getpos player, ["wildboar"],  3] select 0) getvariable "inuse"; isnil "_w" and player distance (nearestobjects [getpos player, ["wildboar"],  3] select 0) < 5 and !alive (nearestobjects [getpos player, ["wildboar"],  3] select 0) and isciv'];

action_h2 =	_role addaction ["Take rabbit meat","noscript.sqf",
'_no = ceil(random 2);if (((call INV_GetOwnWeight) + ("rabbit" call INV_GetItemTypeKg)*_no) > INV_CarryingCapacity)exitwith{player groupChat localize "STRS_inv_buyitems_maxgewicht"};(nearestobjects [getpos player, ["rabbit"],  3] select 0) setvariable ["inuse", 1, true]; player playmove "AinvPknlMstpSlayWrflDnon_medic";sleep 4;waituntil {animationstate player != "AinvPknlMstpSlayWrflDnon_medic"};deletevehicle (nearestobjects [getpos player, ["rabbit"],  3] select 0);[player, "rabbit", _no] call INV_AddInventoryItem;player groupchat format["you got %1 rabbit meat", _no];',
1,true,true,"",
'_w = (nearestobjects [getpos player, ["rabbit"],  3] select 0) getvariable "inuse"; isnil "_w" and player distance (nearestobjects [getpos player, ["rabbit"],  3] select 0) < 5 and !alive (nearestobjects [getpos player, ["rabbit"],  3] select 0) and isciv'];

action_h3 =	_role addaction ["Take Chicken meat","noscript.sqf",
'_no = ceil(random 2);if (((call INV_GetOwnWeight) + ("chicken" call INV_GetItemTypeKg)*_no) > INV_CarryingCapacity)exitwith{player groupChat localize "STRS_inv_buyitems_maxgewicht"};(nearestobjects [getpos player, ["Hen"],  3] select 0) setvariable ["inuse", 1, true]; player playmove "AinvPknlMstpSlayWrflDnon_medic";sleep 4;waituntil {animationstate player != "AinvPknlMstpSlayWrflDnon_medic"};deletevehicle (nearestobjects [getpos player, ["Hen"],  3] select 0);[player, "chicken", _no] call INV_AddInventoryItem;player groupchat format["you got %1 chicken meat", _no];',
1,true,true,"",
'_w = (nearestobjects [getpos player, ["Hen"],  3] select 0) getvariable "inuse"; isnil "_w" and player distance (nearestobjects [getpos player, ["Hen"],  3] select 0) < 5 and !alive (nearestobjects [getpos player, ["Hen"],  3] select 0) and isciv'];

action_h4 =	_role addaction ["Take Cow meat","noscript.sqf",
'_no = ceil(random 2);if (((call INV_GetOwnWeight) + ("cow" call INV_GetItemTypeKg)*_no) > INV_CarryingCapacity)exitwith{player groupChat localize "STRS_inv_buyitems_maxgewicht"};(nearestobjects [getpos player, ["Cow"],  3] select 0) setvariable ["inuse", 1, true]; player playmove "AinvPknlMstpSlayWrflDnon_medic";sleep 4;waituntil {animationstate player != "AinvPknlMstpSlayWrflDnon_medic"};deletevehicle (nearestobjects [getpos player, ["Cow"],  3] select 0);[player, "cow", _no] call INV_AddInventoryItem;player groupchat format["you got %1 cow meat", _no];',
1,true,true,"",
'_w = (nearestobjects [getpos player, ["Cow"],  3] select 0) getvariable "inuse"; isnil "_w" and player distance (nearestobjects [getpos player, ["Cow"],  3] select 0) < 5 and !alive (nearestobjects [getpos player, ["Cow"],  3] select 0) and isciv'];

action_h5 =	_role addaction ["Take Dog meat","noscript.sqf",
'_no = ceil(random 2);if (((call INV_GetOwnWeight) + ("dog" call INV_GetItemTypeKg)*_no) > INV_CarryingCapacity)exitwith{player groupChat localize "STRS_inv_buyitems_maxgewicht"};(nearestobjects [getpos player, ["Fin", "Pastor"],  3] select 0) setvariable ["inuse", 1, true]; player playmove "AinvPknlMstpSlayWrflDnon_medic";sleep 4;waituntil {animationstate player != "AinvPknlMstpSlayWrflDnon_medic"};deletevehicle (nearestobjects [getpos player, ["Fin", "Pastor"],  3] select 0);[player, "dog", _no] call INV_AddInventoryItem;player groupchat format["you got %1 dog meat", _no];',
1,true,true,"",
'_w = (nearestobjects [getpos player, ["Fin", "Pastor"],  3] select 0) getvariable "inuse"; isnil "_w" and player distance (nearestobjects [getpos player, ["Fin", "Pastor"],  3] select 0) < 5 and !alive (nearestobjects [getpos player, ["Fin", "Pastor"],  3] select 0) and isciv'];

action_h6 =	_role addaction ["Take Sheep meat","noscript.sqf",
'_no = ceil(random 2);if (((call INV_GetOwnWeight) + ("sheep" call INV_GetItemTypeKg)*_no) > INV_CarryingCapacity)exitwith{player groupChat localize "STRS_inv_buyitems_maxgewicht"};(nearestobjects [getpos player, ["Sheep"],  3] select 0) setvariable ["inuse", 1, true]; player playmove "AinvPknlMstpSlayWrflDnon_medic";sleep 4;waituntil {animationstate player != "AinvPknlMstpSlayWrflDnon_medic"};deletevehicle (nearestobjects [getpos player, ["Sheep"],  3] select 0);[player, "sheep", _no] call INV_AddInventoryItem;player groupchat format["you got %1 sheep meat", _no];',
1,true,true,"",
'_w = (nearestobjects [getpos player, ["Sheep"],  3] select 0) getvariable "inuse"; isnil "_w" and player distance (nearestobjects [getpos player, ["Sheep"],  3] select 0) < 5 and !alive (nearestobjects [getpos player, ["Sheep"],  3] select 0) and isciv'];

action_h7 =	_role addaction ["Take Goat meat","noscript.sqf",
'_no = ceil(random 2);if (((call INV_GetOwnWeight) + ("goat" call INV_GetItemTypeKg)*_no) > INV_CarryingCapacity)exitwith{player groupChat localize "STRS_inv_buyitems_maxgewicht"};(nearestobjects [getpos player, ["Goat"],  3] select 0) setvariable ["inuse", 1, true]; player playmove "AinvPknlMstpSlayWrflDnon_medic";sleep 4;waituntil {animationstate player != "AinvPknlMstpSlayWrflDnon_medic"};deletevehicle (nearestobjects [getpos player, ["Goat"],  3] select 0);[player, "goat", _no] call INV_AddInventoryItem;player groupchat format["you got %1 goat meat", _no];',
1,true,true,"",
'_w = (nearestobjects [getpos player, ["Goat"],  3] select 0) getvariable "inuse"; isnil "_w" and player distance (nearestobjects [getpos player, ["Goat"],  3] select 0) < 5 and !alive (nearestobjects [getpos player, ["Goat"],  3] select 0) and isciv'];


//===================================== TARGET RESET ==================================================
action12 = _role addaction ["Reset targets","noscript.sqf",'{_x animate["terc",0]} foreach (nearestobjects [getPosATL player, ["TargetEpopup","TargetPopUpTarget"],  100])',1,true,true,"",'player distance gunshop1 < 5'];
action113 = _role addaction ["Reset targets","noscript.sqf",'{_x animate["terc",0]} foreach (nearestobjects [getPosATL coprangetrigger, ["TargetEpopup","TargetPopUpTarget","TargetFakeTank_Lockable_EP1"],  900])',1,true,true,"",'player distance coprangereset < 5'];
//=================================== COP RECRUITMENT =================================================
//action13 = _role addaction [format["Restore Kord MG ($%1)", MGcost],"recruitai.sqf","MG1",1,false,true,"","_gunner = gunner MG1; player distance recruitai <= 5 and (!alive _gunner or isnull _gunner or !alive MG1)"];
//action14 = _role addaction [format["Restore Kord MG ($%1)", MGcost],"recruitai.sqf","MG2",1,false,true,"","_gunner = gunner MG2; player distance recruitai <= 5 and (!alive _gunner or isnull _gunner or !alive MG2)"];
//action15 = _role addaction [format["Restore Kord MG ($%1)", MGcost],"recruitai.sqf","MG3",1,false,true,"","_gunner = gunner MG3; player distance recruitai <= 5 and (!alive _gunner or isnull _gunner or !alive MG3)"];
//action16 = _role addaction [format["Restore Kord MG ($%1)", MGcost],"recruitai.sqf","MG4",1,false,true,"","_gunner = gunner MG4; player distance recruitai <= 5 and (!alive _gunner or isnull _gunner or !alive MG4)"];
//action17 = _role addaction [format["Restore PK NEST ($%1)", PKcost],"recruitai.sqf","PK1",1,false,true,"","_gunner = gunner PK1; player distance recruitai <= 5 and (!alive _gunner or isnull _gunner or !alive PK1)"];
//action18 = _role addaction [format["Restore PK NEST ($%1)", PKcost],"recruitai.sqf","PK2",1,false,true,"","_gunner = gunner PK2; player distance recruitai <= 5 and (!alive _gunner or isnull _gunner or !alive PK2)"];
//action19 = _role addaction [format["Restore PK NEST ($%1)", PKcost],"recruitai.sqf","PK3",1,false,true,"","_gunner = gunner PK3; player distance recruitai <= 5 and (!alive _gunner or isnull _gunner or !alive PK3)"];
//action20 = _role addaction [format["Restore PK NEST ($%1)", PKcost],"recruitai.sqf","PK4",1,false,true,"","_gunner = gunner PK4; player distance recruitai <= 5 and (!alive _gunner or isnull _gunner or !alive PK4)"];

cpbkp = _role addaction ["Recruit Soldier $200000","noscript.sqf",'[player] call interact_recruit_ai;',1,false,true,"","!curreccop and player distance copbackup <= 10 and count (units group player) < 8 and iscop"];
opbkp = _role addaction ["Recruit Soldier $150000","noscript.sqf",'[player] call interact_recruit_ai;',1,false,true,"","!currecred and player distance redbackup <= 10 and count (units group player) < 8"];
insbkp = _role addaction ["Recruit Fighter $100000","noscript.sqf",'[player] call interact_recruit_ai;',1,false,true,"","!currecins and player distance civbackup <= 10 and count (units group player) < 8"];

//===================================== IMPOUND AREA ==================================================
action21 = _role addaction ["Impound Lot","maindialogs.sqf",["impound"],1,false,true,"","player distance impoundbuy <= 5 or player distance copcar <= 5"];
//action22 = _role addaction ["Impound Lot","maindialogs.sqf",["impound"],1,false,true,"","player distance copcar <= 5"];
//================================== COP DELETE EVIDENCE ================================================
//action23 = _role addaction ["Take evidence","noscript.sqf",'player groupchat "evidence removed."; {deletevehicle _x} foreach (nearestobjects [getpos player, ["weaponholder"], 3])',1,true,true,"",'_weps = (nearestobjects [getpos player, ["weaponholder"], 3] select 0); player distance _weps < 5 and iscop'];
//================================== COP SLAVE ACTIONS ================================================
action24 = _role addaction ["Who do you work for?","noscript.sqf",'player groupchat format["this slave works for %1.", leader (nearestobjects [getpos player, civslavearray,  3] select 0)]',1,true,true,"",'_slave = (nearestobjects [getpos player, civslavearray, 3] select 0); not([_slave] call player_human) and ((player distance _slave) < 5) and ([(leader _slave)] call player_human) and iscop'];
action25 = _role addaction ["Set slave free","noscript.sqf",'_slave = (nearestobjects [getpos player, civslavearray,  3] select 0); _civ = leader _slave; deletevehicle _slave; [player, "(human-exploitation)", 20000] call player_update_warrants; player groupchat "the slave has been freed!";',1,true,true,"",'_slave = (nearestobjects [getpos player, civslavearray, 3] select 0); not([_slave] call player_human) and ((player distance _slave) < 5) and ([(leader _slave)] call player_human) and iscop'];
//==================================== OBJECT ACTIONS =================================================
//action89 = _role addaction ["Remove Searchlight","noscript.sqf",'if (((call INV_GetOwnWeight) + ("SearchLight_US_EP1" call INV_GetItemTypeKg)) > INV_CarryingCapacity)exitwith{player groupChat localize "STRS_inv_buyitems_maxgewicht"};deletevehicle (nearestobjects [getpos player, ["SearchLight_US_EP1"], 3] select 0);[player, "SearchLight_US_EP1", 1] call INV_AddInventoryItem;player groupchat "you picked up a searchlight";',1,true,true,"",'_light = (nearestobjects [getpos player, ["SearchLight_US_EP1"],  3] select 0); !(_light in speedcamarray) and player distance _light < 5 and iscop'];
//action26 = _role addaction ["Remove Roadblock","noscript.sqf",'if (((call INV_GetOwnWeight) + ("roadblock" call INV_GetItemTypeKg)) > INV_CarryingCapacity)exitwith{player groupChat localize "STRS_inv_buyitems_maxgewicht"};deletevehicle (nearestobjects [getpos player, ["Land_CncBlock_Stripes"],  3] select 0);[player, "roadblock", 1] call INV_AddInventoryItem;player groupchat "you picked up a roadblock";',1,true,true,"",'player distance (nearestobjects [getpos player, ["Land_CncBlock_Stripes"],  3] select 0) < 5 and iscop'];
//action27 = _role addaction ["Remove Bargate","noscript.sqf",'if (((call INV_GetOwnWeight) + ("Bargate" call INV_GetItemTypeKg)) > INV_CarryingCapacity)exitwith{player groupChat localize "STRS_inv_buyitems_maxgewicht"};deletevehicle (nearestobjects [getpos player, ["ZavoraAnim"],  10] select 0);[player, "Bargate", 1] call INV_AddInventoryItem;player groupchat "you picked up a bargate";',1,true,true,"",'player distance (nearestobjects [getpos player, ["ZavoraAnim"],  10] select 0) < 7 and iscop'];
//action28 = _role addaction ["Remove Road Cone","noscript.sqf",'if (((call INV_GetOwnWeight) + ("roadcone" call INV_GetItemTypeKg)) > INV_CarryingCapacity)exitwith{player groupChat localize "STRS_inv_buyitems_maxgewicht"};deletevehicle (nearestobjects [getpos player, ["Land_coneLight"],  3] select 0);[player, "roadcone", 1] call INV_AddInventoryItem;player groupchat "you picked up a road cone";',1,true,true,"",'player distance (nearestobjects [getpos player, ["Land_coneLight"],  3] select 0) < 5 and iscop'];
//action91 = _role addaction ["Remove M2 Static","noscript.sqf",'if (((call INV_GetOwnWeight) + ("M2StaticMG_US_EP1" call INV_GetItemTypeKg)) > INV_CarryingCapacity)exitwith{player groupChat localize "STRS_inv_buyitems_maxgewicht"};deletevehicle (nearestobjects [getpos player, ["M2StaticMG_US_EP1"],  3] select 0);[player, "M2StaticMG_US_EP1", 1] call INV_AddInventoryItem;player groupchat "you picked up a M2 Static";',1,true,true,"",'player distance (nearestobjects [getpos player, ["M2StaticMG_US_EP1"],  3] select 0) < 5 and iscop'];
//action29 = _role addaction ["Open/close gate","noscript.sqf",'_gate = (nearestobjects [getpos player, ["ZavoraAnim"],  10] select 0); if(_gate animationPhase "bargate" == 1)then{_gate animate ["bargate", 0]}else{_gate animate ["bargate", 1]};',1,true,true,"",'player distance (nearestobjects [getpos player, ["ZavoraAnim"],  10] select 0) < 7 and iscop'];
//action30 = _role addaction ["Open/close gate","noscript.sqf",'_gate = (nearestobjects [getpos player, ["ZavoraAnim"],  10] select 0); if(_gate animationPhase "bargate" == 1)then{_gate animate ["bargate", 0]}else{_gate animate ["bargate", 1]};',1,true,true,"",'player distance (nearestobjects [getpos player, ["ZavoraAnim"],  10] select 0) < 7 and isciv'];
//action31 = _role addaction ["Remove Big bag fence (corner)","noscript.sqf",'if (((call INV_GetOwnWeight) + ("BigbagfenceCorner" call INV_GetItemTypeKg)) > INV_CarryingCapacity)exitwith{player groupChat localize "STRS_inv_buyitems_maxgewicht"};deletevehicle (nearestobjects [getpos player, ["Land_fort_bagfence_corner"],  3] select 0);[player, "BigbagfenceCorner", 1] call INV_AddInventoryItem;player groupchat "you picked up a sandbag wall (corner)";',1,true,true,"",'player distance (nearestobjects [getpos player, ["Land_fort_bagfence_corner"],  3] select 0) < 5'];
//action32 = _role addaction ["Remove Big bag fence","noscript.sqf",'if (((call INV_GetOwnWeight) + ("bigbagfence" call INV_GetItemTypeKg)) > INV_CarryingCapacity)exitwith{player groupChat localize "STRS_inv_buyitems_maxgewicht"};deletevehicle (nearestobjects [getpos player, ["Land_fort_bagfence_long"],  3] select 0);[player, "bigbagfence", 1] call INV_AddInventoryItem;player groupchat "you picked up a sandbag wall";',1,true,true,"",'player distance (nearestobjects [getpos player, ["Land_fort_bagfence_long"],  3] select 0) < 5'];
//action33 = _role addaction ["Remove Big bag fence (round)","noscript.sqf",'if (((call INV_GetOwnWeight) + ("bigbagfenceRound" call INV_GetItemTypeKg)) > INV_CarryingCapacity)exitwith{player groupChat localize "STRS_inv_buyitems_maxgewicht"};deletevehicle (nearestobjects [getpos player, ["Land_fort_bagfence_round"],  3] select 0);[player, "bigbagfenceRound", 1] call INV_AddInventoryItem;player groupchat "you picked up a sandbag wall (round)";',1,true,true,"",'player distance (nearestobjects [getpos player, ["Land_fort_bagfence_round"],  3] select 0) < 5'];
//action34 = _role addaction ["Remove Bunker (small)","noscript.sqf",'if (((call INV_GetOwnWeight) + ("bunkersmall" call INV_GetItemTypeKg)) > INV_CarryingCapacity)exitwith{player groupChat localize "STRS_inv_buyitems_maxgewicht"};deletevehicle (nearestobjects [getpos player, ["Land_fortified_nest_small"],  3] select 0);[player, "bunkersmall", 1] call INV_AddInventoryItem;player groupchat "you picked up a bunker (small)";',1,true,true,"",'player distance (nearestobjects [getpos player, ["Land_fortified_nest_small"],  3] select 0) < 5'];
//action35 = _role addaction ["Remove Danger Sign","noscript.sqf",'if (((call INV_GetOwnWeight) + ("danger" call INV_GetItemTypeKg)) > INV_CarryingCapacity)exitwith{player groupChat localize "STRS_inv_buyitems_maxgewicht"};deletevehicle (nearestobjects [getpos player, ["Sign_Danger"],  3] select 0);[player, "danger", 1] call INV_AddInventoryItem;player groupchat "you picked up a danger sign";',1,true,true,"",'player distance (nearestobjects [getpos player, ["Sign_danger"],  3] select 0) < 5'];
//action36 = _role addaction ["Remove Factory","noscript.sqf",'if (((call INV_GetOwnWeight) + ("factory" call INV_GetItemTypeKg)) > INV_CarryingCapacity)exitwith{player groupChat localize "STRS_inv_buyitems_maxgewicht"};deletevehicle (nearestobjects [getpos player, ["Land_A_GeneralStore_01a"],  3] select 0);[player, "factory", 1] call INV_AddInventoryItem;player groupchat "you picked up a factory";',1,true,true,"",'player distance (nearestobjects [getpos player, ["Land_A_GeneralStore_01a"],  3] select 0) < 5 and isciv'];
//action37 = _role addaction ["Remove Office Building","noscript.sqf",'if (((call INV_GetOwnWeight) + ("officebuilding" call INV_GetItemTypeKg)) > INV_CarryingCapacity)exitwith{player groupChat localize "STRS_inv_buyitems_maxgewicht"};deletevehicle (nearestobjects [getpos player, ["land_A_Office01"],  3] select 0);[player, "officebuilding", 1] call INV_AddInventoryItem;player groupchat "you picked up a officebuilding";',1,true,true,"",'player distance (nearestobjects [getpos player, ["Land_A_office01"],  3] select 0) < 5 and isciv'];
//action38 = _role addaction ["Remove Barrack","noscript.sqf",'if (((call INV_GetOwnWeight) + ("barrack" call INV_GetItemTypeKg)) > INV_CarryingCapacity)exitwith{player groupChat localize "STRS_inv_buyitems_maxgewicht"};deletevehicle (nearestobjects [getpos player, ["land_Barrack2"],  3] select 0);[player, "barrack", 1] call INV_AddInventoryItem;player groupchat "you picked up a barrack";',1,true,true,"",'player distance (nearestobjects [getpos player, ["Land_Barrack2"],  3] select 0) < 5 and isciv'];
//action39 = _role addaction ["Remove Hedgehog","noscript.sqf",'if (((call INV_GetOwnWeight) + ("Hedgehog_EP1" call INV_GetItemTypeKg)) > INV_CarryingCapacity)exitwith{player groupChat localize "STRS_inv_buyitems_maxgewicht"};deletevehicle (nearestobjects [getpos player, ["Hedgehog_EP1"],  3] select 0);[player, "Hedgehog_EP1", 1] call INV_AddInventoryItem;player groupchat "you picked up a Hedgehog";',1,true,true,"",'player distance (nearestobjects [getpos player, ["Hedgehog_EP1"],  3] select 0) < 5 and iscop'];
//action40 = _role addaction ["Remove Checkpoint sign","noscript.sqf",'if (((call INV_GetOwnWeight) + ("Sign_Checkpoint_US_EP1" call INV_GetItemTypeKg)) > INV_CarryingCapacity)exitwith{player groupChat localize "STRS_inv_buyitems_maxgewicht"};deletevehicle (nearestobjects [getpos player, ["Sign_Checkpoint_US_EP1"],  3] select 0);[player, "Sign_Checkpoint_US_EP1", 1] call INV_AddInventoryItem;player groupchat "you picked up a Checkpoint sign";',1,true,true,"",'player distance (nearestobjects [getpos player, ["Sign_Checkpoint_US_EP1"],  3] select 0) < 5 and iscop'];
//action410 = _role addaction ["Remove Camo net","noscript.sqf",'if (((call INV_GetOwnWeight) + ("Land_CamoNetVar_NATO_EP1" call INV_GetItemTypeKg)) > INV_CarryingCapacity)exitwith{player groupChat localize "STRS_inv_buyitems_maxgewicht"};deletevehicle (nearestobjects [getpos player, ["Land_CamoNetVar_NATO_EP1"],  3] select 0);[player, "Land_CamoNetVar_NATO_EP1", 1] call INV_AddInventoryItem;player groupchat "you picked up a Camo net";',1,true,true,"",'player distance (nearestobjects [getpos player, ["Land_CamoNetVar_NATO_EP1"],  3] select 0) < 5'];
//action420 = _role addaction ["Remove Breaching ladder","noscript.sqf",'if (((call INV_GetOwnWeight) + ("Land_ladderEP1" call INV_GetItemTypeKg)) > INV_CarryingCapacity)exitwith{player groupChat localize "STRS_inv_buyitems_maxgewicht"};deletevehicle (nearestobjects [getpos player, ["Land_ladderEP1"],  5] select 0);[player, "Land_ladderEP1", 1] call INV_AddInventoryItem;player groupchat "you picked up a Breaching Ladder";',1,true,true,"",'player distance (nearestobjects [getpos player, ["Land_ladderEP1"],  5] select 0) < 5'];
//action420 = _role addaction ["Remove Campfire","noscript.sqf",'if (((call INV_GetOwnWeight) + ("Land_Campfire_burning" call INV_GetItemTypeKg)) > INV_CarryingCapacity)exitwith{player groupChat localize "STRS_inv_buyitems_maxgewicht"};deletevehicle (nearestobjects [getpos player, ["Land_Campfire_burning"],  5] select 0);[player, "Land_Campfire_burning", 1] call INV_AddInventoryItem;player groupchat "you picked up a Campfire";',1,true,true,"",'player distance (nearestobjects [getpos player, ["Land_Campfire_burning"],  5] select 0) < 5'];
//action430 = _role addaction ["Remove Road Barricade","noscript.sqf",'if (((call INV_GetOwnWeight) + ("Fort_Barricade_EP1" call INV_GetItemTypeKg)) > INV_CarryingCapacity)exitwith{player groupChat localize "STRS_inv_buyitems_maxgewicht"};deletevehicle (nearestobjects [getpos player, ["Fort_Barricade_EP1"],  5] select 0);[player, "Fort_Barricade_EP1", 1] call INV_AddInventoryItem;player groupchat "you picked up a Road Barricade";',1,true,true,"",'player distance (nearestobjects [getpos player, ["Fort_Barricade_EP1"],  5] select 0) < 5'];
//==================================== REPAIR POWER ===================================================
action41 = _role addaction [format["Restore Power 1 ($%1)", powerrestorecost],"noscript.sqf",'_moneh = [player, "money"] call INV_GetItemAmount; if(_moneh < powerrestorecost)exitwith{player groupchat "you do not have enough money"};[player, "money", -(powerrestorecost)] call INV_AddInventoryItem; "power1 setdamage 0;liafu = true;" call broadcast',1,false,true,"","player distance power1 <= 7 and !alive power1 and iscop"];
action42 = _role addaction [format["Restore Power 2 ($%1)", powerrestorecost],"noscript.sqf",'_moneh = [player, "money"] call INV_GetItemAmount; if(_moneh < powerrestorecost)exitwith{player groupchat "you do not have enough money"};[player, "money", -(powerrestorecost)] call INV_AddInventoryItem; "power2 setdamage 0;liafu = true;" call broadcast',1,false,true,"","player distance power2 <= 7 and !alive power2 and iscop"];
//================================== COP CHIEF ELECTION ===============================================
action43 = _role addaction ["Elect a Chief","maindialogs.sqf",["chief"],1,false,true,"","player distance copbank < 7"];
//==================================== MAYOR ELECTION =================================================
action44 = _role addaction ["Elect a President","maindialogs.sqf",["wahlen"],1,false,true,"","player distance rathaus <= 3"];
//===================================== MAYOR ACTIONS =================================================
action45 = _role addaction ["Change the Law","maindialogs.sqf",["gesetz"],1,false,true,"","player distance rathaus <= 3 and isMayor"];
action46 = _role addaction ["Change taxes","maindialogs.sqf",["steuern"],1,false,true,"","player distance rathaus <= 3 and isMayor"];
//===================================== BUY HIDEOUT ===================================================
//_role addaction [format["Buy Hideout ($%1)", hideoutcost],"noscript.sqf",'if( [player, "money"] call INV_GetItemAmount < hideoutcost)exitwith{player groupchat "not enough money"};[player, "money", -hideoutcost] call INV_AddInventoryItem;[player, "hideout", 1] call INV_AddInventoryItem;player groupchat format["you bought a hideout for $%1", hideoutcost];',1,false,true,"","player distance rathaus <= 3 and isciv"];
//===================================== BUY INSURANCE ===================================================
action47 = _role addaction [format["Buy bank insurance ($%1)", ("bankversicherung" call INV_GetItemBuyCost)],"noscript.sqf",'[player] call interact_buy_insurance;', 1 , false,true,"","(!interact_buy_item_active && (player distance mainbank <= 3 or player distance copbank <= 3 or player distance licenseflag5 <= 3 or player distance licenseflag6 <= 3 or player distance storage <= 7))"];
//======================================= CRIMELOG ====================================================
action48 = _role addaction ["Crime Log","maindialogs.sqf",["coplog"],1,false,true,"","player distance rathaus <= 3"];
//======================================== SLAVES =====================================================
action49 = _role addaction [format ["Buy Slave ($%1)", slave_cost],"slaves.sqf", ["slave"],1,false,true,"","!currecciv and player distance slaveflag <= 10 and isciv"];
//==================================== PRIVATE STORAGE ================================================
action50 = _role addaction ["Private storage","noscript.sqf",'[player] call interact_private_storage_menu;', 1, false,true,"","player distance storage < 7"];
storage1 = _role addaction ["Private storage","noscript.sqf",'[player] call interact_private_storage_menu;', 1, false,true,"","player distance copbank < 7"];
storage2 = _role addaction ["Private storage","noscript.sqf",'[player] call interact_private_storage_menu;', 1, false,true,"","player distance pmcatm < 7"];
storage3 = _role addaction ["Private storage","noscript.sqf",'[player] call interact_private_storage_menu;', 1, false,true,"","player distance atmins < 7"];
storage4 = _role addaction ["Private storage","noscript.sqf",'[player] call interact_private_storage_menu;', 1, false,true,"","player distance atm5 < 7"];
//========================================= BAIL ======================================================
action51 = _role addaction [format ["Pay Bail", slave_cost],"maindialogs.sqf", ["bail"],1,false,true,"","player distance bailflag <= 5 and isciv"];
//===================================== ITEM PROCESS ==================================================
action52 = _role addAction 
[
	"Process Diamond rock", "noscript.sqf", '[player, "Diamond rock", "Diamondring", 12] call interact_item_process;', 1, false, true, "",
	'((player distance Diamond_1) <= 5) && isciv && ([player, "diamond"] call player_has_license)'
];

action53 = _role addAction 
[
	"Process Oil", "noscript.sqf", '[player, "Oil", "OilBarrel", 10] call interact_item_process;', 1, false, true, "", 
	'((player distance Oil_1) <= 5) && isciv && ([player, "oil"] call player_has_license)'
];


action54 = _role addAction
[
	"Make Glass", "noscript.sqf", '[player, "Sand", "Glass", 2] call interact_item_process;', 1 , false, true, "", 
	'((player distance Glassblower) <= 5) && isciv && ([player, "glassblowing"] call player_has_license)'
];

//action55 = _role addaction 
//[
//		"Process Wheat", "noscript.sqf", '[player, "getreide", "Bread", 2] call interact_item_process;', 1, false, true, "", 
//		'((player distance Bakery_1) <= 5) && isciv && ([player, "Baker"] call player_has_license)'
//];

//===================================== CONVOY CASH ===================================================
action56 = _role addAction ["Steal police payroll","noscript.sqf",'convoy_cash=false; publicvariable "convoy_cash"; _cash = (playersNumber west)* govconvoybonus; [player, "money", _cash] call INV_AddInventoryItem; [player, "(convoy-heist)", _cash] call player_update_warrants;  player groupchat format["You stole $%1!", _cash];',1,false,true,"","_driver = driver convoy_truck; (player distance convoy_truck) <= 7 && convoy_cash && not([player] call player_cop) && (not(alive _driver) || (isNull _driver))"];
//action57 =  nil;
//action58 =  nil;
//action59 = nil;
//action60 = nil;
//======================================== WORKERS =====================================================
//_role addaction [format ["Hire a worker ($%1)", huren_cost],"worker.sqf", ["holen"],1,false,true,"","(player distance workplace_getjobflag_1 <= 5 or player distance workplace_getjobflag_2 <= 5 or player distance workplace_getjobflag_3 <= 5) and isciv"];
//======================================= WORKPLACE ====================================================
action61 = _role addaction ["Get courier job","delivery.sqf", ["getajob_delivery"],1,false,true,"","(player distance workplace_getjobflag_1 <= 5 or player distance workplace_getjobflag_2 <= 5 or player distance workplace_getjobflag_3 <= 5) and isciv"];
action62 = _role addaction ["Cancel delivery mission","delivery.sqf", ["cancel"],1,false,true,"","(player distance workplace_getjobflag_1 <= 5 or player distance workplace_getjobflag_2 <= 5 or player distance workplace_getjobflag_3 <= 5) and isciv and alreadygotaworkplacejob == 1"];
action63 = _role addaction ["Get taxi job","taxi.sqf", ["getajob_taxi"],1,false,true,"","(player distance workplace_getjobflag_1 <= 7 or player distance workplace_getjobflag_2 <= 7 or player distance workplace_getjobflag_3 <= 7) and isciv"];
action64 = _role addaction ["Finish taxi mission","taxi.sqf", ["canceljob_taxi"],1,false,true,"","(player distance workplace_getjobflag_1 <= 5 or player distance workplace_getjobflag_2 <= 5 or player distance workplace_getjobflag_3 <= 5) and isciv and workplacejob_taxi_active"];
action65 = _role addaction [format [localize "STRS_addAction_buy_shop", (BuyAbleBuildingsArray select 0) select 1, (BuyAbleBuildingsArray select 0) select 3],"buyshop.sqf", ["property", 0],1,false,true,"","player distance ((BuyAbleBuildingsArray select 0) select 2) <= 5 and !(((BuyAbleBuildingsArray select 0) select 0) in BuildingsOwnerArray)"];
action66 = _role addaction [format [localize "STRS_addAction_buy_shop", (BuyAbleBuildingsArray select 1) select 1, (BuyAbleBuildingsArray select 1) select 3],"buyshop.sqf", ["property", 1],1,false,true,"","player distance ((BuyAbleBuildingsArray select 1) select 2) <= 5 and !(((BuyAbleBuildingsArray select 1) select 0) in BuildingsOwnerArray)"];
action67 = _role addaction [format [localize "STRS_addAction_buy_shop", (BuyAbleBuildingsArray select 2) select 1, (BuyAbleBuildingsArray select 2) select 3],"buyshop.sqf", ["property", 2],1,false,true,"","player distance ((BuyAbleBuildingsArray select 2) select 2) <= 5 and !(((BuyAbleBuildingsArray select 2) select 0) in BuildingsOwnerArray)"];
//====================================== VEHICLE ACTIONS ================================================
action68 = _role addaction [localize "STRS_addaction_trunk_see","noscript.sqf",'_vcl = (nearestobjects [getpos player, ["Air", "Ship", "LandVehicle"], 3] select 0);_str = ([_vcl] call vehicle_storage_name);[_str] call A_SCRIPT_VEHICLECHECK;',1,true,true,"",'_vcl = (nearestobjects [getpos player, ["Air", "Ship", "LandVehicle"], 3] select 0);player distance _vcl < 10 and not([player, _vcl] call vehicle_owner) and ([_vcl] call INV_IsPlayerVehicle) and iscop'];
action69 = _role addaction [localize "STRS_addaction_trunk_check","noscript.sqf",'_vcl = (nearestobjects [getpos player, ["Air", "Ship", "LandVehicle"], 3] select 0);_str = ([_vcl] call vehicle_storage_name);if([_vcl,_str] call INV_RemoveIllegalStorage)then{call compile format["publicvariable ""%1"";", _str]};',1,true,true,"",'_vcl = (nearestobjects [getpos player, ["Air", "Ship", "LandVehicle"], 3] select 0);player distance _vcl < 10 and not([player, _vcl] call vehicle_owner) and ([_vcl] call INV_IsPlayerVehicle) and iscop'];
action70 = _role addaction ["Impound vehicle","noscript.sqf",'_vcl = (nearestobjects [getpos player, ["Air", "Ship", "LandVehicle"], 3] select 0);[_vcl, "impound"] call A_SCRIPT_IMPOUND;',1,true,true,"",'_vcl = (nearestobjects [getpos player, ["Air", "Ship", "LandVehicle"], 3] select 0);player distance _vcl < 10 and ([_vcl] call INV_IsPlayerVehicle) and iscop'];
action71 = _role addaction ["Pull out","noscript.sqf",'(nearestobjects [getpos player, ["Air", "Ship", "LandVehicle"], 3] select 0) execVM "pullout.sqf";',1,true,true,"",'_vcl = (nearestobjects [getpos player, ["Air", "Ship", "LandVehicle"], 3] select 0);player distance _vcl < 10 and count (crew _vcl) > 0 and ([_vcl] call INV_IsPlayerVehicle) and (call INV_IsArmed)'];
action72 = _role addaction [localize "STRS_addAction_vehicleinfo","noscript.sqf",'(nearestobjects [getpos player, ["Air", "Ship", "LandVehicle"], 3] select 0) call A_SCRIPT_VEHINFO;',1,true,true,"",'_vcl = (nearestobjects [getpos player, ["Air", "Ship", "LandVehicle"], 3] select 0);player distance _vcl < 10 and ([_vcl] call INV_IsPlayerVehicle)'];
//action73 = nil;
//action74 = nil;
//action75 = nil;
//action76 = nil;
//action77 = nil;
//action78 = nil;
//======================================== SHOP EXPORT ==================================================
action79 = _role addaction ["Shop 1 export","noscript.sqf","[(shop1 call INV_GetShopNum)] call shop_open_dialog;",1,false,true,"","player distance shop1export <= 3"];
action80 = _role addaction ["Shop 2 export","noscript.sqf","[(shop2 call INV_GetShopNum)] call shop_open_dialog;",1,false,true,"","player distance shop2export <= 3"];
action81 = _role addaction ["Shop 3 export","noscript.sqf","[(shop3 call INV_GetShopNum)] call shop_open_dialog;",1,false,true,"","player distance shop3export <= 3"];
action82 = _role addaction ["Shop 4 export","noscript.sqf","[(shop4 call INV_GetShopNum)] call shop_open_dialog;",1,false,true,"","player distance shop4export <= 3"];
//action83 = nil; 							
//action84 = nil;	
//action85 = nil;
//===================================== Gas station Robbing===============================================
gsshop1 = fuelshop1 addaction ["Rob Gas Station 1", "noscript.sqf", '[player, 1] call player_rob_station', 1, false, true, ""," not(iscop) && station1money >= 10000"];
gsshop2 = fuelshop2 addaction ["Rob Gas Station 2", "noscript.sqf", '[player, 2] call player_rob_station', 1, false, true, ""," not(iscop) && station2money >= 10000"];
gsshop3 = fuelshop3 addaction ["Rob Gas Station 3", "noscript.sqf", '[player, 3] call player_rob_station', 1, false, true, "",  "not(iscop) && station3money >= 10000"];
gsshop4 = fuelshop4 addaction ["Rob Gas Station 4", "noscript.sqf", '[player, 4] call player_rob_station', 1, false, true, "", "not(iscop) && station4money >= 10000"];
gsshop5 = fuelshop5 addaction ["Rob Gas Station 5", "noscript.sqf", '[player, 5] call player_rob_station', 1, false, true, "", "not(iscop) && station5money >= 10000"];
gsshop6 = fuelshop6 addaction ["Rob Gas Station 6", "noscript.sqf", '[player, 6] call player_rob_station', 1, false, true, "", "not(iscop) && station6money >= 10000"];
gsshop7 = fuelshop7 addaction ["Rob Gas Station 7", "noscript.sqf", '[player, 7] call player_rob_station', 1, false, true, "", "not(iscop) && station7money >= 10000"];
gsshop8 = fuelshop8 addaction ["Rob Gas Station 8", "noscript.sqf", '[player, 8] call player_rob_station', 1, false, true, "", "not(iscop) && station8money >= 10000"];
gsshop9 = fuelshop9 addaction ["Rob Gas Station 9", "noscript.sqf", '[player, 9] call player_rob_station', 1, false, true, "", "not(iscop) && station9money >= 10000"];
//========================   unflip vehicle     ================================
action86 = _role addaction ["Unflip vehicle","noscript.sqf","_this call vehicle_unflip;",1,false,true,"",'_vcl = (nearestobjects [getpos player, ["Air", "Ship", "LandVehicle"], 3] select 0);player distance _vcl < 5 and ([player, _vcl] call vehicle_owner)'];
//=========================    Cop Patrol actions   ==============================
action87 = _role addaction["Get patrol mission","coppatrol.sqf",["start"],1,false,true,"","iscop and player distance copbank <= 4 and !pmissionactive and !patrolwaittime"];
action88 = _role addaction["Cancel patrol mission","coppatrol.sqf",["end"],1,false,true,"","iscop and pmissionactive and player distance copbank <= 4"];
//========================   HOSTAGE  ================================================
action89 = _role addaction ["Take Hostage Mission","hostage.sqf",["getajob_hostage"],1,false,true,"","player distance hostage <= 3 and isciv"];
action90 = _role addaction ["Take Hostage", "noscript.sqf", "[hostage1] join (group player); player groupchat ""Keep the hostage close or you will fail!"";",1,false,true,"","player distance hostage1 < 5 and isciv"];
//=======================  Escape Locked Vehicle ==============================================
//action91 = (vehicle player) addaction ["Jump Off","noscript.sqf",'moveOut player;',1,false,true,"",'_vcl = vehicle player;((_vcl iskindof "Motorcycle") or (_vcl iskindof "ATV_Base_EP1")) and not([player, _vcl] call vehicle_owner) and (locked _vcl) and (speed _vcl < 30)'];
//action112 = (vehicle player) addaction ["Break Out","noscript.sqf",'moveOut player;',1,false,true,"",'_vcl = vehicle player;(player != _vcl) and not([player, _vcl] call vehicle_owner) and (locked _vcl) and !(_vcl iskindof "Motorcycle") and !(_vcl iskindof "ATV_Base_EP1") and (speed _vcl < 30)'];
//=======================   ADMIN CAMERA ==============================================
//action91 = _role addaction ["Camera Console","aaacode.sqf",[],1,false,true,"","player distance rubblepile <= 2"];
//action112 = _role addaction ["Get Code","code.sqf",[],1,false,true,"","isciv and player distance hide1 <= 4"];
//=======================   Road Gates ==============================================
/*
action92 = _role addaction ["Raise Gates","rgate1.sqf",[],1,false,true,"","iscop and player distance copgate1 <= 5"];
action93 = _role addaction ["Lower Gates","lgate1.sqf",[],1,false,true,"","iscop and player distance copgate1 <= 5"];
action94 = _role addaction ["Raise Gates","rgate2.sqf",[],1,false,true,"","iscop and player distance copgate2 <= 5"];
action95 = _role addaction ["Lower Gates","lgate2.sqf",[],1,false,true,"","iscop and player distance copgate2 <= 5"];
action96 = _role addaction ["Raise Gates","rgate3.sqf",[],1,false,true,"","iscop and player distance copgate3 <= 5"];
action97 = _role addaction ["Lower Gates","lgate3.sqf",[],1,false,true,"","iscop and player distance copgate3 <= 5"];
action98 = _role addaction ["Raise Gates","rgate4.sqf",[],1,false,true,"","iscop and player distance copgate4 <= 5"];
action99 = _role addaction ["Lower Gates","lgate4.sqf",[],1,false,true,"","iscop and player distance copgate4 <= 5"];
action100 = _role addaction ["Lower Gates","lgate5.sqf",[],1,false,true,"","player distance pmcgate <= 5 and (""pmc_license_journeyman"" call INV_HasLicense)"];
action101 = _role addaction ["Lower Gates","lgate6.sqf",[],1,false,true,"","isciv and player distance terrgate <= 4"];
*/

action94 = _role addaction ["Raise Gates","rgate2.sqf",[],1,false,true,"","iscop and player distance copgate2 <= 5"];
action95 = _role addaction ["Lower Gates","lgate2.sqf",[],1,false,true,"","iscop and player distance copgate2 <= 5"];
action96 = _role addaction ["Raise Gates","rgate3.sqf",[],1,false,true,"","iscop and player distance copgate3 <= 5"];
action97 = _role addaction ["Lower Gates","lgate3.sqf",[],1,false,true,"","iscop and player distance copgate3 <= 5"];
action98 = _role addaction ["Raise Gates","rgate4.sqf",[],1,false,true,"","iscop and player distance copgate4 <= 5"];
action99 = _role addaction ["Lower Gates","lgate4.sqf",[],1,false,true,"","iscop and player distance copgate4 <= 5"];
action100 = _role addaction ["Lower Gates","lgate5.sqf",[],1,false,true,"","player distance pmcgate <= 5 and (""pmc_license_journeyman"" call INV_HasLicense)"];
action101 = _role addaction ["Lower Gates","lgate6.sqf",[],1,false,true,"","isciv and player distance terrgate <= 4"];
action102 = _role addaction ["Raise Gates","rgate5.sqf",[],1,false,true,"","isins and player distance opforgate2 <= 5"];
action103 = _role addaction ["Lower Gates","lgate8.sqf",[],1,false,true,"","isins and player distance opforgate2 <= 5"];
action104 = _role addaction ["Raise Gates","rgate6.sqf",[],1,false,true,"","isopf and player distance opforgate1 <= 5"];
action105 = _role addaction ["Lower Gates","lgate9.sqf",[],1,false,true,"","isopf and player distance opforgate1 <= 5"];
action106 = _role addaction ["Raise Gates","rgate7.sqf",[],1,false,true,"","isopf and player distance opforgate3 <= 5"];
action107 = _role addaction ["Lower Gates","lgate10.sqf",[],1,false,true,"","isopf and player distance opforgate3 <= 5"];
action108 = _role addaction ["Lower Gates","lgate11.sqf",[],1,false,true,"","isopf and player distance opforgateb <= 5"];


[copbank, ["Access PMC White List", "maindialogs.sqf", ["pmc_whitelist"], 0, false, true, "", "true"]] call add_new_action;
[player] call holster_add_actions;
A_running = false;