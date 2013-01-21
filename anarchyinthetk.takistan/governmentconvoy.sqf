

// Convoy ideia by Eddie Vedder for the Chernarus life Revivved mission, code rewrite and improvement by a old beggar working for food :P
private ["_counter","_counter2","_added","_sidewon","_array","_spawn","_pos","_radius","_markerobj","_markername","_convvehicle","_oldpos","_leader","_target","_convoyArray"];


while {true} do  {
sleep 10;
govconvoygroup = createGroup west;

_counter = 0;
_counter2 = 0;
_added = false;
_sidewon = "Neither";	

//waits for respawn
//sleep (convoyrespawntime*54);

"hint ""Rumors suggest about a convoy leaving in a few minutes."";" call broadcast;

//sleep (convoyrespawntime*6);

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



//convoy_marker_active = 1;
convoyhascash=true; publicvariable "convoyhascash";
_convvehicle= ["Ural_TK_CIV_EP1", "MTVR_DES_EP1"] call BIS_fnc_selectRandom;
//convoygpk= createVehicle["HMMWV_M1151_M2_DES_EP1", (getPosATL _pos), [], 15, "NONE"];
convoytruck = createVehicle [_convvehicle, (getPosATL _pos), [], 0, "NONE"];

convoytruck setVehicleInit "convoytruck = this; this setVehicleVarName ""convoytruck"";  this setAmmoCargo 0;  clearweaponcargo this;clearmagazinecargo this;";	

convoytruck setvariable ["tuning", 5, true];
processinitcommands;
publicvariable "convoytruck";


_convoyArray=[convoysoldier,convoyguard1,convoyguard2,convoyguard3,convoyguard4,convoyguard5,convoyguardmg,convoyguardmg2];

{
	"US_Soldier_LAT_EP1" createUnit [_pos,govconvoygroup,'_x=this;this setSpeedMode "full";this allowFleeing 0;', _radius, "FORM"];	
	removeAllWeapons _x;
	_x addMPEventHandler ["MPKilled", { _this call player_handle_mpkilled }];
	if(_forEachIndex>=6) then {_x addweapon "Mk_48_DES_EP1";_x addmagazine "100Rnd_762x51_M240"; _x setskill 0.75;}
    else {_x addweapon "SCAR_L_CQC_Holo";_x addmagazine ["30Rnd_556x45_Stanag",3]; _x setskill 0.75};
	_x addWeapon "NVGoggles";
	if(_forEachIndex==0) then
	 {
		govconvoygroup selectLeader _x;
		_leader= _x;
		_x moveInDriver convoytruck; 
		_x assignAsDriver convoytruck;
		_x setskill 0.86;
		_x setskill ["commanding", 1];
	 } 
	 else
	  {
		_x dofollow convoytruck;
		_x moveincargo convoytruck; 
		_x assignAsCargo convoytruck;
	  };
	  	
} foreach _convoyArray;


processInitCommands;
liafu = true;
govconvoygroup setbehaviour "AWARE";
govconvoygroup setCombatMode "RED";
sleep 2;

format['["All units, supply truck has entered North Takistan. Defend it against bandits and terrorists, and escort it to base!","Villagers rumors indicates a valuable North Government truck somewhere in north of our country!!"] call broadcast_side_msg;'] call broadcast;


//start mission loop
_oldpos=[0,0,0];
while { true } do 
{
	if(!convoyhascash) exitwith{ _sidewon = "Civs";};
	
    // check if player have guns, if so... it becames a target	
	  {
	   if (!(side _x==west) and (count (weapons _x - nonlethalweapons) > 0) and (alive _x)) then 
	    {
		 "titleText [""The Government is operating in this area! Turn back or you will be shot!"", ""plain down""];" call broadcast;
		 _target=_x;
		 {
		   _x doTarget _target;			
		   _x doFire _target;
		 } foreach units govconvoygroup;
		};
	  } foreach nearestObjects [getpos convoytruck,["Man"],150];	 
	
	
	"convoy" setmarkerpos getpos convoytruck;
	
	// after leader is dead, for some reason, sometimes other AI soldier takes driver seat and drives to cop base
	// this behavior isn't forbidden as it's a good option, AI  decidea if drives the convoy or figth against agressors, lets be this way to get a more dynamic mission
    if(alive _leader ) then 
	 {
	  if((getPos _leader) distance _oldpos < 2) then {(driver convoytruck) domove (getPosATL copbase1);};
	 } 
	 else 
	  {
	    if(!_added ) then	 
		 { 
		  _added = true;		  
		  convoytruck setVehicleLock "unlocked";
		  govconvoygroup setbehaviour "COMBAT";
	      { 
		   if(_forEachIndex>0) then 
		    {
		     _x setskill ["general",0.86];
		     _x setskill ["endurance",1];
		     _x setskill ["spotDistance",1];
		     _x setskill ["commanding", 1];		
		     unassignVehicle _x;
		     doGetOut _x;
		     //_x action ["eject", convoytruck]; // can't eject as the truck can be moving
		     _x doWatch getPos convoytruck;
			};
		   } foreach units govconvoygroup;	
		 format['["The governemnt convoy driver is dead. Get in his truck and drive it to North Gov base!!","The government convoy driver is dead. Steal North Gov paycheck before reinforcements arrives!!"] call broadcast_side_msg;'] call broadcast;
	    };
	   };
	
	if(!(canMove convoytruck) and (alive _leader) ) then 
	 {
		convoytruck setVehicleLock "unlocked";
		govconvoygroup setbehaviour "COMBAT";
		{ 
		  _x setskill ["general",0.8];
		  _x setskill ["endurance",1];
		  _x setskill ["spotDistance",1];
		  unassignVehicle _x;
		  doGetOut _x;
		  //_x action ["eject", convoytruck];
		  _x doWatch getPos convoytruck;
		} foreach units govconvoygroup;		
		format['["All units, governemnt convoy is heavily damaged!! Move to truck position and protect a 50m perimeter!!",""] call broadcast_side_msg;'] call broadcast;				
	 };
		
	if((damage convoytruck > 0.2) and !(isnull (driver convoytruck))) then 
	 {
		_vel = velocity convoytruck ;
		_dir = direction convoytruck ;		
		_speed = 5; 
		// speed boost when shots hits vehicle, is a permanent max fullspeed for vehicle, as 5 m/s is 180km/h
        convoytruck  setVelocity [(_vel select 0)+((sin _dir)*_speed),(_vel select 1)+ ((cos _dir)*_speed),(_vel select 2)];
	 };
	
	
	if (_counter > 20 && ((getPos convoytruck) distance _oldpos < 3) && (alive _leader)) then
	 {
		_newpos= [((getPosATL copbase1 select 0)+(getPos _leader select 0))/2 ,((getPosATL copbase1 select 1)+(getPos _leader select 1))/2 , 0];
		_leader domove _newpos;		
		_counter = 0;				
	 };
	 
	if (_counter >30) then {_counter = 0;};
	
	if (convoytruck distance copbase1 < 150) exitwith 
		{   
		"if ([player] call player_cop) then {[player, govconvoybonus] call bank_transaction; player sidechat format[""you received $%1 for the successfully escorting the convoy"", govconvoybonus];};" call broadcast;
		_sidewon = "Cops";
		};
				
	if (_counter2 >= 900) exitwith
		{
		// if there's a cop nearby and the trucks have the payroll until now, so this cop is well protecting truck :]
		 {
           if((side _x) == west) exitwith {_sidewon = "Cops";};
		 } foreach nearestObjects [getpos convoytruck,["Man"],60];	
		_sidewon = "Neither";
		};
		
	if (!alive convoytruck) exitwith
		{
		 server globalchat "The government truck has been destroyed the money has burned";
		_sidewon = "Neither";
		};
			
	_counter2 = _counter2 + 1;	
	_counter = _counter + 1;	
	_oldpos= getpos convoytruck;
	sleep 1;
};

	
//mission has ended resetting vars and deleting units

(format ['server globalChat "%2 side won the government convoy mission, next truck leaves in %1 minutes!";', convoyrespawntime, _sidewon]) call broadcast;
sleep 8;
{deletevehicle _x; } foreach units govconvoygroup;
deletevehicle convoytruck; 
deleteGroup govconvoygroup;
deletemarker "convoy";
moneyintruck = true;
};





//written by Gman, rewrited by aliens