// This script initiali/zes the Real Estate market in takistan


home_initial_buying_price = 150000;
home_initial_selling_price = round(home_initial_buying_price  * 0.8);

//meta-data for accessing the HOME pseudo object
home_name = 0;
home_position = 1;
home_owner_uid = 2;
home_owner_name = 3;
home_locked = 4;
home_object = 5;
home_ownership_action = 6;
home_locking_action = 7;
home_info_action = 8;
home_buying_price = 9;
home_selling_price = 10;
home_walls = 11;

//meta-data for accessing the WALL pseudo object
home_wall_type = 0;
home_wall_position = 1;
home_wall_direction = 2;

//meta-data for accessing the MSG pseudo object
homes_msg_from = 0;
homes_msg_to = 1;
homes_msg_type = 2;
homes_msg_data = 3;

homes_msg = 
[
 "",
 "",
 "",
 ""
];


if (isServer) then
{

//static definition of the location of the homes, and the location of the walls for each home
homes_list = 
[
    [ "Home1",       
      [ 5565.1235, 9332.3623, 2.99821],
      "", "",
      false,        
      objNull,
      -1, -1, -1,
      home_initial_buying_price, home_initial_selling_price,
      [[ "Concrete_Wall_EP1", [3.5, 4.2, 0], 0],
       [ "Concrete_Wall_EP1", [-3.5, 2.65, 0], 0],
       [ "Concrete_Wall_EP1", [-4.5, -4.35, 0], 0]]
    ],
    [ "Home2",       
      [5524.93, 9350.08,3.06506],
      "", "",
      false,        
      objNull,
      -1, -1, -1,
      home_initial_buying_price, home_initial_selling_price,
      [[ "Concrete_Wall_EP1", [1.4, 1.2, 0], 0],
       [ "Concrete_Wall_EP1", [2.0, -3.5, 0], 0]]
    ],
    [ "Home3",       
      [5532.32,9327.52,0.955223],
      "", "",
      false,        
      objNull,
      -1, -1, -1,
      home_initial_buying_price, home_initial_selling_price,
      [
       [ "Concrete_Wall_EP1", [-2.90, 8.2, 0], 0],
       [ "Concrete_Wall_EP1", [3.1, 4.4, 0], 90],
       [ "Concrete_Wall_EP1", [-9.55, 4.2, 0], 0],
       [ "Concrete_Wall_EP1", [-2.35, 5.2, 0], 0]]
    ],
    [ "Home4",       
      [5561.06,9354.53,0.834846],
      "",
      "",
      false,        
      objNull,
      -1, -1, -1,
      home_initial_buying_price, home_initial_selling_price,
      [
       [ "Concrete_Wall_EP1", [-3,-3.8, 0], 90],
       [ "Concrete_Wall_EP1", [1.3,-7.9, 0], 90],
       [ "Concrete_Wall_EP1", [4,3.1, 0], 0],
       [ "Concrete_Wall_EP1", [-7.2,-0.5, 0], 0]
      ]
    ]
];
};

//this is needed to identify the animation names for home doors
//zeroes, 0 - closed, 1 - open
//ones, 0 - open, 1 - closed

home_doors_zeroes = ["dvere","dvere1l","dvere1r","dvere2l","dvere2r","dvere_spodni_r","dvere_spodni_l","dvere_vrchni","vrata1","vrata2","vratal1","vratar1","vratal2","vratar2","vratal3","vratar3"];
home_doors_ones = ["door","door_1_1","door_1_2","door_2_1","door_2_2","dvere1","dvere2","dvere3","dvere4","dvere5","dvere6","dvere7","dvere8","dvere9","dvere10","dvere11","dvere12","dvere13","dvere14","doorl","doorr","door_01","door01_a","door_02","door02_a","door_03","door_04","door_05","door_06","door_1a","door_1","door_2"];


//these are functions that perform actions on a HOME object
//for some actions like buy, and sell, a message is broadcast to the rest of the clients
home_closeDoor =
{
    _home = _this select 0;
    _home_object = _home select home_object;
    
    {_home_object animate [format ["%1", _x], 0]} foreach home_doors_zeroes;
    {_home_object animate [format ["%1", _x], 1]} foreach home_doors_ones;
};
    
home_openDoor =
{
    _home = _this select 0;
    _home_object = _home select home_object;
    {_home_object animate [format ["%1", _x], 1]} foreach home_doors_zeroes;
    {_home_object animate [format ["%1", _x], 0]} foreach home_doors_ones;
};

    
home_isDoorOpening = 
{
    _home = _this select 0;
    _home_object = _home select home_object;
    
    _opening = false;
    
    {
        if((_home_object animationPhase format ["%1", _x]) > 0)
        exitWith { _opening = true;};
    } foreach home_doors_zeroes;
    
    {
        if((_home_object animationPhase format ["%1", _x]) < 1)
        exitWith { _opening = true;};
    } foreach home_doors_ones;
    
    _opening
};

home_unlock = 
{
    _home = _this select 0;
    _owner_name = name player;
    
    _home set [home_locked, false];
    player groupChat "House is now unlocked";
    
    [_home] call home_updateActions;    

    homes_msg = [_owner_name, "all", "update_home", _home];
    publicVariable "homes_msg";
};

home_lock =
{
    _home = _this select 0;
    _owner_name = name player;
    
    _home set [home_locked, true];
    player groupChat "House is now locked";
    
    [_home] call home_updateActions;    
    
    homes_msg = [_owner_name, "all", "update_home", _home];
    publicVariable "homes_msg";

};

home_isLocked =
{
    _home = _this select 0;
    _home select home_locked
};

home_buy =
{
    _home = _this select 0;
    _owner_name = name player;
    _owner_uid = getPlayerUID player;
     
    _home set [home_owner_uid, _owner_uid];
    _home set [home_owner_name, _owner_name];
    _home set [home_locked, false];
    player groupChat format["You bought this house for $%1", _home select home_buying_price];
    
    [_home] call home_updateActions;    
    
    homes_msg = [_owner_name, "all", "update_home", _home];
    publicVariable "homes_msg";
    
};

home_sell =
{
     //hint format["%1", _this];
    _home = _this select 0;
    _owner_name = name player;
    
    _home set [home_owner_uid, ""];
    _home set [home_owner_name, ""];
    _home set [home_locked, false];
    player groupChat format["You sold this house for $%1", _home select home_selling_price];

    [_home] call home_updateActions;
    
    homes_msg = [_owner_name, "all", "update_home", _home];
    publicVariable "homes_msg";
};

home_addPositions =
{
    _pos1 = _this select 0;
    _pos2 = _this select 1;
    [(_pos1 select 0) + (_pos2 select 0), (_pos1 select 1) + (_pos2 select 1), (_pos1 select 2) + (_pos2 select 2)]
};

home_addDirections =
{
    (_this select 0) + (_this select 1)
};

home_info =
{
    _home = _this select 0;

    _home_owner_name = _home select home_owner_name;
    
    if (_home_owner_name == "") then
    {
        hint format["This house is for sale", _home select home_buying_price];
    }
    else
    {
        hint format["This house belongs to %1", _home_owner_name];
    };
};

home_setObject = 
{
    _home = _this select 0;
    _home_pos = _home select home_position;
    _home_object = nearestObjects [[(_home_pos select 0), (_home_pos select 1), (_home_pos select 2)], ["House"], 5] select 0;
    _home set [home_object, _home_object];
    _home_object
};

home_isForSale =
{
    _home = _this select 0;
    _home_key = [_home] call home_getKey;
    (_home_key == "")
};

home_isOwnerConnected =
{
    _home = _this select 0;
    _owner_uid = _home select home_owner_uid;
    _owner_name = _home select home_owner_name;
    _connected = false;
    {
        _unit = call compile format ["%1", _x];
        
        if (((getPlayerUID _unit) == _owner_uid) && (name _unit == _owner_name)) exitWith 
        {
            _connected = true;
        };
        
    } forEach playerstringarray;
    
    
    _connected
};

home_getKey =
{
    _home = _this select 0;
    _owner = _home select home_owner_name;
    _uid = _home select home_owner_uid;
    
    if (_owner == "" or _uid == "") 
        exitWIth {"";};
        
    format["%1_%2", _owner, _uid]
};

home_myKey =
{
    format["%1_%2", name player, getPlayerUID player]
};

home_setForSale =
{
    _home = _this select 0;
    
    _home set [home_owner_name, ""];
    _home set [home_owner_uid, ""];
    _home set [home_locked, false];
    
    if (!isDedicated) then
    {
        [_home] call home_updateActions;
    };
    
    
    homes_msg = ["server", "all", "update_home", _home];
    publicVariable "homes_msg";
    
};

// this is the main logic for updating the player actions, each player executes this after receiving an update_home message
home_updateActions =
{
    _home = _this select 0;
    _home_object = _home select home_object;
    
    if ((_home select home_ownership_action) >= 0) then
    {
        _action = _home select home_ownership_action;
        _home_object removeAction _action;
        _home set [home_ownership_action, -1];
    };
    
    if ((_home select home_locking_action) >= 0) then
    {
        _action = _home select home_locking_action;
        _home_object removeAction _action;
        _home set [home_locking_action, -1];
    };
    
    if ((_home select home_info_action) >= 0) then
    {
        _action = _home select home_info_action;
        _home_object removeAction _action;
        _home set [home_info_action, -1];
    };
    
    _cur_key = [_home] call home_getKey;
    _my_key = [] call home_myKey;

    // if I am not the owner, I want to see the home info
    if (_my_key != _cur_key) then
    {        
        _action_id = _home_object addAction ["House information", "Awesome\Houses\homeactions.sqf", ["info", _home], 1];
        _home set [home_info_action, _action_id];
    };
    

    // if no owner, then home is for salae
    if (_cur_key == "_" or _cur_key == "") then
    {
        _action_id = _home_object addAction [format["Buy this house ($%1)", _home select home_buying_price], "Awesome\Houses\homeactions.sqf", ["buy", _home], 1];
        _home set [home_ownership_action, _action_id];
        _home set [home_locked, false];
    }
    else
    {
        //home has an owner, so it's not for sale
        
        if (_cur_key == _my_key) then
        {
            // I am the current owner
            _action_id = _home_object addAction [format["Sell this house ($%1)", _home select home_selling_price], "Awesome\Houses\homeactions.sqf", ["sell", _home], 1];
            _home set [home_ownership_action, _action_id];
            _home_locked = _home select home_locked;
            
            if (_home_locked) then
            {
                _action_id = _home_object addAction ["Unlock house", "Awesome\Houses\homeactions.sqf", ["unlock", _home], 1];
                _home set [home_locking_action, _action_id];
            }
            else
            {
                _action_id = _home_object addAction ["Lock house", "Awesome\Houses\homeactions.sqf", ["lock", _home], 1];
                _home set [home_locking_action, _action_id];
            };
        };
    };
    _home
};


//this function is only executed by server ... 
//basically it's watching for when a player disconnects, it sets the house back on sale.
_HomeWatch =
{
    while {true} do {
        {
            _home = _x;
            _home_name = _home select home_name;
            _c_home = server getVariable [_home_name, ""];
            
            if (!([_c_home] call home_isForSale)) then
            {
                if (!([_c_home] call home_isOwnerConnected)) then
                {
                    [_c_home] call home_setForSale;
                };
            };
            
        } forEach homes_list;
        sleep 1;
    };
};

//this function executes only in server ...
//it creates the walls for all homes once, and then goes into a loop to
//check that all home locked doors are kept closed 
_HomeLogic = 
{    
    _home = _this select 0;
    
    _x = _home select home_x;
    _y = _home select home_y;
    _z = _home select home_z;
    
    _home_object = _home select home_object;
    _home set [home_object, _home_object];
    
    _home_walls = _home select home_walls;
    
    {
        _home_wall = _x;
        _home_wall_type  = _home_wall select home_wall_type;
        
        _home_wall_pos = _home_wall select home_wall_position;
        _home_wall_dir = _home_wall select home_wall_direction;
        
        _home_object_pos = getPosATL _home_object;
        _home_object_dir = getDir _home_object;
        liafu = true;
        _wall = createVehicle [_home_wall_type,  [_home_object_pos, _home_wall_pos] call home_addPositions, [], 0, "CAN_COLLIDE"];
        _wall setDir ([_home_object_dir, _home_wall_dir] call home_addDirections)
        
    }forEach _home_walls;

    
    
    while{true} do
    {  
        _locked = [_home] call home_isLocked;
        _opening = [_home] call home_isDoorOpening;
                
        if(_locked and _opening) then 
        {
            [_home] call home_closeDoor;
        };
        sleep 0.1;
    };
};

//this is the main server/client model implementation for the home system
//throughout the whole mission, the server keeps the state of all homes, with the metadata
//like who is the owner, and if it's locked or not.
//
//when a player connects to the server, it sends a message ("request_homes") to server asking for list of homes
//and server then replies back sending "update_home" messages to that client.
//

"homes_msg" addPublicVariableEventHandler 
{
   _homes_msg = _this select 1;
   _msg_to = _homes_msg select homes_msg_to;
   _msg_from = _homes_msg select homes_msg_from;
   _msg_type = _homes_msg select homes_msg_type;
   _msg_data = _homes_msg select homes_msg_data;

   if (isServer) then
   {
      _myself = "server";
   
      if (_msg_to in [_myself, "all"]) then
      {
          //server globalChat format["RECV: %1", _homes_msg];
          //hint format["%1", _homes_msg];
           if (_msg_type == "request_homes") then
           {
               {
                   _home = _x;
                   _home_name = _home select home_name;
                   _c_home = server getVariable _home_name;
                   
                   homes_msg = [_myself, _msg_from, "update_home", _c_home];
                   //server globalChat format["SEND: %1", homes_msg];
                   publicVariable "homes_msg";
               } forEach homes_list;           
           }
           else { if (_msg_type == "update_home") then
           {
               _home = _msg_data;
               _home_name = _home select home_name;
               _c_home = server getVariable _home_name;
               _c_home set [home_owner_uid, _home select home_owner_uid];
               _c_home set [home_owner_name, _home select home_owner_name];
               _c_home set [home_locked, _home select home_locked];
               
               server setVariable [_home_name, _c_home];    
               
               if (!isDedicated) then
               {
                    server setVariable [_home_name, [_c_home] call home_updateActions];
               };
           };};
       };
   }
   else 
   {
        _myself = name player;
        if (_msg_to == _myself or _msg_to == "all")  then
        {
            //server globalChat format["RECV: %1", _homes_msg];
              //hint format["%1", _homes_msg];
            if (_msg_type == "update_home") then
            {
                _home = _msg_data;
                _home_name = _home select home_name;
                
                _c_home = server getVariable [_home_name, []];
                
                if (count _c_home == 0) then
                {
                    _home set [home_ownership_action, -1];
                    _home set [home_locking_action, -1];
                    _home set [home_object, objNull];
                    [_home] call home_setObject;
                    
                    server setVariable [_home_name, [_home] call home_updateActions];
                }
                else 
                {
                    _c_home set [home_owner_uid, _home select home_owner_uid];
                    _c_home set [home_owner_name, _home select home_owner_name];
                    _c_home set [home_locked, _home select home_locked];
                    
                    server setVariable [_home_name, [_c_home] call home_updateActions];
                };
            };
        };
   };
};

//this is where it all starts, server and player go on their different paths
_main = 
{
    if (isServer) then
    {
        _homes_count = count homes_list;
        
        for [{_i = 0}, {_i < _homes_count}, {_i=_i+1}] do
        {    
            _home = homes_list select _i;
            _home_object = [_home] call home_setObject;
            _home_name = _home select home_name;
            server setVariable [_home_name, _home];
            
            [_home] spawn _homeLogic;
            
            if (!isDedicated) then
            {
                server setVariable [_home_name, [_home] call home_updateActions];
            };
        };
        
        [] spawn _homeWatch;
    }
    else
    {
        homes_msg = [name player, "server", "request_homes",""];
        publicVariable "homes_msg";
    };
};



[] call _main;