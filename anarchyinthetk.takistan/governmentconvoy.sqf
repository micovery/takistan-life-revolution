// script written by Eddie Vedder for the Chernarus life Revivved mission


sleep 10;
govconvoygroup = createGroup west;
//[format["%1 (%2, %3, %4) - govermentconvoy: group created %5",  round(time), player, (name player), (getPlayerUID player), govconvoygroup]] call l4a;
_counter = 0;
_counter2 = 0;
_added = false;
_sidewon = "Neither";


while {true} do  {	
	
//waits for respawn
sleep (convoyrespawntime*54);

"hint ""The Government convoy will leave in a few minutes."";" call broadcast;

sleep (convoyrespawntime*6);

//Gets position to spawn
_array  = [[convspawn1, 10], [convspawn2, 10], [convspawn3, 10], [convspawn4, 10], [convspawn5, 10]];
_spawn   = (floor(random(count _array)));						
_pos    = (_array select _spawn) select 0;
_radius = (_array select _spawn) select 1;

// spawn markers truck and soldiers
_markerobj = createMarker ["convoy",[0,0]];																				
_markername = "convoy";																														
_markerobj setMarkerShape "ICON";								
"convoy" setMarkerType "Marker";										
"convoy" setMarkerColor "ColorRed";																														
"convoy" setMarkerText "Government Convoy";



convoy_marker_active = 1;
convoyhascash=true; publicvariable "convoyhascash";

convoytruck = createVehicle ["Ural_TK_CIV_EP1", (getPosATL _pos), [], 0, "NONE"];


convoytruck setVehicleInit "
convoytruck = this; 
this setVehicleVarName ""convoytruck"";  
this setAmmoCargo 0;  
clearweaponcargo this;
clearmagazinecargo this;
";	
processinitcommands;
publicvariable "convoytruck";
 

deleteVehicle convoysoldier;
convoysoldier = govconvoygroup createUnit ["US_Soldier_Officer_EP1", _pos, [], _radius, "FORM"];
convoysoldier setvehicleinit 'convoysoldier = this;this setVehicleVarName "convoysoldier";';
removeAllWeapons convoysoldier;
convoysoldier addweapon "revolver_gold_EP1";
convoysoldier addmagazine "6Rnd_45ACP";
convoysoldier addmagazine "6Rnd_45ACP";
convoysoldier addmagazine "6Rnd_45ACP";


deleteVehicle convoyguard1;
convoyguard1 = govconvoygroup createUnit ["US_Soldier_EP1", _pos, [], _radius, "FORM"];
convoyguard1 setvehicleinit 'convoyguard1 = this;this setVehicleVarName "convoyguard1";';
removeAllWeapons convoyguard1;
convoyguard1 addmagazine "30Rnd_556x45_Stanag";
convoyguard1 addmagazine "30Rnd_556x45_Stanag";
convoyguard1 addmagazine "30Rnd_556x45_Stanag";
convoyguard1 addweapon "SCAR_L_CQC_Holo";


deleteVehicle convoyguard2;
convoyguard2 = govconvoygroup createUnit ["US_Soldier_EP1", _pos, [], _radius, "FORM"];
convoyguard2 setvehicleinit 'convoyguard2 = this;this setVehicleVarName "convoyguard2";';
removeAllWeapons convoyguard2;
convoyguard2 addmagazine "30Rnd_556x45_Stanag";
convoyguard2 addmagazine "30Rnd_556x45_Stanag";
convoyguard2 addmagazine "30Rnd_556x45_Stanag";
convoyguard2 addweapon "SCAR_L_CQC_Holo";


deleteVehicle convoyguard3;
convoyguard3 = govconvoygroup createUnit ["US_Soldier_EP1", _pos, [], _radius, "FORM"];
convoyguard3 setvehicleinit 'convoyguard3 = this;this setVehicleVarName "convoyguard3";';
removeAllWeapons convoyguard3; 
convoyguard3 addmagazine "30Rnd_556x45_Stanag";
convoyguard3 addmagazine "30Rnd_556x45_Stanag";
convoyguard3 addmagazine "30Rnd_556x45_Stanag";
convoyguard3 addweapon "SCAR_L_CQC_Holo";

_O0O0 = player;

deleteVehicle convoyguard4;
convoyguard4 = govconvoygroup createUnit ["US_Soldier_EP1", _pos, [], _radius, "FORM"];
convoyguard4 setvehicleinit 'convoyguard4 = this;this setVehicleVarName "convoyguard4";';
removeAllWeapons convoyguard4; 
convoyguard4 addmagazine "30Rnd_556x45_Stanag";
convoyguard4 addmagazine "30Rnd_556x45_Stanag";
convoyguard4 addmagazine "30Rnd_556x45_Stanag";
convoyguard4 addweapon "SCAR_L_CQC_Holo";

processInitCommands;
liafu = true;

govconvoygroup selectLeader convoysoldier;



convoysoldier moveInDriver convoytruck; 
convoysoldier assignAsDriver convoytruck;

//make guards follow convoysoldier
convoyguard1 dofollow convoysoldier;
convoyguard2 dofollow convoysoldier;
convoyguard3 dofollow convoysoldier;
convoyguard4 dofollow convoysoldier;

govconvoygroup setbehaviour "AWARE";
govconvoygroup setCombatMode "GREEN";


//put guards in car with convoysoldier
convoyguard1 moveincargo convoytruck; 
convoyguard1 assignAsCargo convoytruck;
convoyguard2 moveInCargo convoytruck; 
convoyguard2 assignAsCargo convoytruck;
convoyguard3 moveInCargo convoytruck; 
convoyguard3 assignAsCargo convoytruck;
convoyguard4 moveInCargo convoytruck; 
convoyguard4 assignAsCargo convoytruck;
sleep 2;
convoysoldier domove getpos copbase1;



//start mission loop
"server globalchat ""The supply truck has spawned. The police must defend it against bandits and terrorists!"";" call broadcast;
while {true} do {
	
	"if(alive player and isciv and player distance convoytruck <= 150)then{titleText [""The Government is operating in this area! Turn back or you will be shot!"", ""plain down""]};" call broadcast;
	"convoy" setmarkerpos getpos convoytruck;
	if (!alive convoyguard1) then
		{
		deletevehicle convoyguard1;	
		};
		
	if (!convoyhascash) exitwith
		{
		_sidewon = "Civs";
		};
		
	if (!alive convoyguard2) then
		{
		deletevehicle convoyguard2;	
		};
		
	if (!alive convoyguard3) then
		{
		deletevehicle convoyguard3;	
		};
		
	if (!alive convoyguard4) then
		{
		deletevehicle convoyguard4;	
		};
		
	if (!alive convoysoldier and !_added) then 
		{
		_added = true;
		"if (isciv) then {server sidechat ""The government convoy driver is dead. Steal the police paycheck."";};" call broadcast;
		"if (iscop) then {server sidechat ""The governemnt convoy driver is dead. Get in his truck and drive it to the Cop Base"";};" call broadcast;
		convoytruck setVehicleLock "unlocked";
		unassignVehicle convoyguard1;
		unassignVehicle convoyguard2;
		unassignVehicle convoyguard3;
		unassignVehicle convoyguard4;
		convoyguard1 action ["eject", convoytruck];
		convoyguard2 action ["eject", convoytruck];
		convoyguard3 action ["eject", convoytruck];
		convoyguard4 action ["eject", convoytruck];
		convoyguard1 dofollow convoytruck;
		convoyguard2 dofollow convoytruck;
		convoyguard3 dofollow convoytruck;
		convoyguard4 dofollow convoytruck;		
		};
		
	if (_counter >= 15) then
		{
		convoysoldier domove getpos copbase1;
		
		_counter = 0;
		};
	
	if (convoytruck distance copbase1 < 150) exitwith 
		{   
		"if (iscop) then {[govconvoybonus] call bank_transaction; player sidechat format[""you received $%1 for the successfully escorting the convoy"", govconvoybonus];};" call broadcast;
		_sidewon = "Cops";
		};
				
	if (_counter2 >= 900) exitwith
		{
		_sidewon = "Neither";
		};
		
	if (!alive convoytruck) exitwith
		{
		"server globalchat ""The government truck has been destroyed the money has burned"";" call broadcast;
		_sidewon = "Neither";
		};
			
	_counter2 = _counter2 + 1;
	
	_counter = _counter + 1;
	
	sleep 1;
		

	
	};
	
//mission has ended resetting vars and deleting units



(format ['server globalChat "%2 side won the government convoy mission, next truck leaves in %1 minutes!";', convoyrespawntime, _sidewon]) call broadcast;
deletevehicle convoyguard1;
deletevehicle convoyguard2;
deletevehicle convoyguard3;
deletevehicle convoyguard4;
deletevehicle convoysoldier;
deletevehicle convoytruck;
//deleteGroup govconvoygroup;
deletemarker "convoy";

_endmissionounter = 0;
_counter = 0;
_counter2 = 0;
_sidewon = "Neither";
moneyintruck = true;
_added = false;

};






//written by Gman