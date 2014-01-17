//script by eddiev223 and cobra

private["_selection"];
_selection = _this select 0;

if (_selection == "use") then {
player  groupchat "Your Mobile Road Block is Spawning. Please move 10 meters back while it spawns!";
sleep 5;

private["_playerpos", "_theroadblock", "_nextobjpos1", "_nextobjpos2", "_nextobjpos3", "_thesign", "_thegate", "_thetower"];
_playerpos = getpos player;       //Sign_Checkpoint_TK_EP1
_theroadblock =  "Land_fortified_nest_small_EP1" createvehicle _playerpos;
  //NEXT
_nextobjpos1 = [(playerpos select 0)+5, _playerpos select 1 , _playerpos select 2];
_thesign = "Sign_Checkpoint_TK_EP1" createvehicle _nextobjpos1;
     //NEXT
_nextobjpos2 = [(playerpos select 0)+1, _playerpos select 1 , _playerpos select 2];
_thegate = "ZavoraAnim" createvehicle _nextobjpos2;
         //NEXT       _
_nextobjpos3 = [(playerpos select 0)-1, _playerpos select 1 , _playerpos select 2];
_thetower = "Land_transport_kiosk_EP1" createvehicle _nextobjpos3;


player groupchat "mobile road block script called";
};





