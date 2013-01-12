liafu = true;

// script by eddiev223
_selection = _this select 0;
if (_selection == "use") then
{


// make roadblock array and location modifiers
_roadblockarray = ["Land_fortified_nest_small_EP1","Land_fortified_nest_small_EP1","SearchLight","Sign_Checkpoint_TK_EP1"];
_locationarray = [[0,0,0],[15,0,0],[0,5,0],[0,-5,0]];

//count how many entries
_number = count _roadblockarray;

// gets player location and modifies it for direction
_playerlocation = [(position player select 0) + (sin(getdir player)*2), (position player select 1) + (cos(getdir player)*2), 0];


for [{_x=0},{_x<=_number},{_x=_x+1}] do

{


_thebuilding = _roadblockarray select _x;
//_thelocationmod = _locationarraymod select _x;
_addtox = (_locationarray select _x) select 0;
_addtoy	= (_locationarray select _x) select 1;
_addtoz	= (_locationarray select _x) select 2;

_thenewlocation = [(_playerlocation select 0) + _addtox, (_playerlocation select 1) + _addtoy,  (_playerlocation select 2) + _addtoz];

call compile format ["
_thebuilding%1 =  createVehicle [_thebuilding, [0,0,0], [], 0, 'NONE'];
_thebuilding%1 setdir getdir player;
_thebuilding%1 setpos _thenewlocation;
liafu = true;
",_x];
};


};