#include "constants.h"

disableserialization;
private ["_name_tags_i"];
_name_tags_i = 0;

object_atm = {
	private["_object"];
	_object = _this select 0;
	if (isNil "_object") exitWith {false};
	if (typeName _object != "OBJECT") exitWith {false};
	if (isNull _object) exitWith {false};
	
	(_object in bankflagarray)
};

object_shop = {
	private["_object"];
	_object = _this select 0;
	if (isNil "_object") exitWith {false};
	if (typeName _object != "OBJECT") exitWith {false};
	if (isNull _object) exitWith {false};
	
	(_object in shopusearray)
};


name_tags_vehicle = {
	private["_target"];
	_target = _this select 0;
	if ([_target] call player_human) exitWith {false};
	if (not([_target] call vehicle_exists)) exitWith {false};
	
	(
		_target isKindOf "LandVehicle" ||
		_target isKindOf "Air" ||
		_target isKindOf "Ship" ||
		_target isKindOf "LocalBasicWeaponsBox"
	)
};




name_tags_center_screen = {
	private["_x", "_y"];
	_x = (safezoneX + 0.5 * safezoneW);
	_y = (safezoneY + 0.5 * safezoneH);
	[_x, _y]
};



name_tags_head_position = {
	private["_target", "_pos", "_pos_x", "_pos_y", "_pos_z"];
	_target = _this select 0;

	private["_distance"];
	_distance = player distance _target;
	

	private["_pos", "_pos_x", "_pos_y", "_pos_z", "_part"];
	
	_part = if ((vehicle _target) == _target) then {"neck" } else {"engine"};
	_pos = (_target selectionPosition _part);
	
	_pos_x = (_pos select 0);
	_pos_y = (_pos select 1);
	_pos_z = (_pos select 2) + 0.2;
	private["_pos"];
	
	_pos_z = if (_pos_z > 1.6) then { 1.9 } else {_pos_z};
	_pos =  [_pos_x, _pos_y, _pos_z];
	//player groupChat format["_pos = %1", _pos];
	
	(worldToScreen (_target modelToWorld _pos))
	
};

name_tags_head_screen = {
	private["_target"];
	_target = _this select 0;
	
	private["_center"];
	_center = call name_tags_center_screen;
	
	if (isNil "_target") exitWith {_center};
	if (typeName _target != "OBJECT") exitWith {_center};
	if (isNull _target) exitWith {_center};
	if (not(_target isKindOf "Man" || _target isKindOf "LandVehicle")) exitWith {_center;};
	
	private["_pos2D"];
	_pos2D = ([_target] call name_tags_head_position);

	if (isNil "_pos2D") exitWith {_center};
	if (typeName _pos2D != "ARRAY") exitWith {_center};
	if (count _pos2D < 2) exitWith {_center};
	
	([(_pos2D select 0), (_pos2D select 1)])
};

name_tags_draw = {
	//player groupChat format["name_tags_draw %1", _this];
	
	private["_player", "_target", "_camera"];
	_player = _this select 0;
	_camera = _player getVariable "camera";
	_target = if (isNil "_camera") then {cursorTarget} else {call camera_target};
	
	
	if (not([_player] call player_human)) exitWith {false};
	if (isNil "_target") exitWith {false};
	if (typeName _target != "OBJECT") exitWith {false};
	if (isNull _target) exitWith {false};
	if (not(INV_shortcuts)) exitWith {false};
	if (visibleMap) exitWith {false};
	
	
	//don't draw tags while being inside a vehicle 
	private["_inside_vehicle"];
	_inside_vehicle = not((vehicle _player) == _player);
	if (_inside_vehicle) exitWith {false};
	
	private["_control"];
	_control = call name_tags_control;

	private["_target", "_distance", "_is_near", "_is_far"];;
	_distance = if (isNil "_camera") then {_player distance _target} else {_camera distance _target};

	
	if (([_target] call object_atm) && _distance < 3) exitWith {
		private["_center_pos"];
		_center_pos = call name_tags_center_screen;
		_control ctrlSetPosition _center_pos;
		_control ctrlSetStructuredText parseText format["<t size='1.2' font='Zeppelin33Italic' color='#00ff00'>ATM (E)</t>"];
		_control ctrlShow true;
		_control ctrlCommit 0;
		true
	};
	
	if ([_target] call object_shop && _distance < 3) exitWith {
		if(([_player] call player_cop) and _target in drugsellarray) then { 
			_control ctrlSetStructuredText parseText format["<t size='1.2' font='Zeppelin33Italic' color='#ffffff'>Drug Search (E)</t>"];
		}
		else {
			private["_shop_name"];
			_shop_name = (_target call INV_GetShopArray) select 1;
			_control ctrlSetStructuredText parseText format["<t size='1.2' font='Zeppelin33Italic' color='#ffffff'>%1 (E)</t>",_shop_name];
		};
		
		private["_head_pos"];
		_head_pos = [_target] call name_tags_head_screen;
		_control ctrlSetPosition _head_pos;
		_control ctrlShow true;
		_control ctrlCommit 0;
		
		true
	};
	
	if ([_target] call name_tags_vehicle && _distance < 25) exitWith {
		private["_owner", "_inside_vehicle", "_is_box"];
		_owner = ([player, _target] call vehicle_owner);
		_inside_vehicle = ([player, (vehicle player)] call mounted_player_inside);
		_is_box = _target isKindOf "LocalBasicWeaponsBox";
		private["_handled"];
		_handled = false;
		if (_distance < 5 && not(_inside_vehicle) && not(_is_box)) then {
			
			
			if (_owner && not(locked _target)) exitWith {
//				_control ctrlSetStructuredText parseText format["<t size='1.2' font='Zeppelin33Italic' color='#00ff00'>Enter (E)</t><br /><t size='1.2' font='Zeppelin33Italic' color='#ffffff'>Trunk (T)</t>"];
				_control ctrlSetStructuredText parseText format["<br /><t size='1.2' font='Zeppelin33Italic' color='#ffffff'>Trunk (T)</t>"];
				_handled = true;
			};
			
			if (_owner && (locked _target)) exitWith {
				_control ctrlSetStructuredText parseText format["<t size='1.2' font='Zeppelin33Italic' color='#00ff00'>Unlock (Control+Space)</t><br /><t size='1.2' font='Zeppelin33Italic' color='#ffffff'>Trunk (T)</t>"];
				_handled = true;
			};
		
			if (not(locked _target)) exitWith {	
//				_control ctrlSetStructuredText parseText format["<t size='1.2' font='Zeppelin33Italic' color='#00ff00'>Enter (E)</t>"];
				_control ctrlSetStructuredText parseText format["<t size='1.2' font='Zeppelin33Italic' color='#00ff00'>Enter</t>"];
				_handled = true;
			};
		};
		
		private["_center_pos"];
		_center_pos = if (_target isKindOf "LandVehicle") then {  [_target] call name_tags_head_screen;} else { call name_tags_center_screen};
		_control ctrlSetPosition _center_pos;
		_control ctrlShow true;
		_control ctrlCommit 0;
		_handled
	};
	
	if ([_target] call player_human &&  _distance < 25) exitWith {
		if ([_target, "has_admin_camera"] call player_get_bool) exitWith {};
		
		_control ctrlSetStructuredText parseText ([_target] call name_tags_text);
		
		private["_head_pos"];
		_head_pos = [_target] call name_tags_head_screen;
		_control ctrlSetPosition _head_pos;
		_control ctrlShow true;
		_control ctrlCommit 0;

		true
	};

	false
};

name_tags_text = {
	private["_target", "_bountytype", "_colorcode", "_colorcode_value", "_text"];
	_target = _this select 0;
	
	if (isNil "_target") exitWith {};
	if (not([_target] call player_human)) exitWith {};

	
	if (([_target] call player_isPMC) and ([_target] call player_civilian)) then {
		//PMC in PMC clothes
		_colorcode = "149107"; //Green
	} else {
		//Get colorcodes
		_bountytype = [_target] call player_get_wantedtype;
		_colorcode_value = _bountytype - 255;
		if (_colorcode_value < 0) then {_colorcode_value = _colorcode_value * -1;};
		_colorcode = format["%1%2%3", "FF", ([_colorcode_value, 2] call int_to_hex), "00"];
	};
	_text = format["<t size='1.2' font='Zeppelin33Italic' color='#%1'>%2 (%3)</t>", _colorcode, _target, (name _target)];
	
	_text
	
};

int_to_hex = {
	private["_valueD", "_valueH", "_len", "_hexarray","_i","_tmp"];
	_valueD = _this select 0;
	_len = _this select 1;
	_hexarray = ["0","1","2","3","4","5","6","7","8","9","A","B","C","D","E","F"];
	
	if (isNil "_valueD") then {_valueD = 0;};
	if (isNil "_len") then {_len = 1;};
	
	if (typeName _valueD != "SCALAR") then {_valueD = 0;};
	if (typeName _len != "SCALAR") then {_len = 1;};
	
	_i = 0;
	_valueH = "";
	
	while {(_i < _len)} do {
		_tmp = _valueD / 16;
		_valueD = floor _tmp;
		_tmp = round ((_tmp - _valueD) * 16);
		_valueH = format["%1%2", _valueH, (_hexarray select _tmp)];
		_i = _i + 1;
	};
	
	_valueH
};

name_3d_tags_draw = {
	private["_player", "_side"];

	if( isNil "name_tags_side_units") exitWith {};
	
	disableSerialization;
	_player = _this select 0;
	_side = _this select 1;
	

	private["_i","_count"];
	_count = 20; // this value has to be changed if more slots are added to any faction (at the moment, cops have the max 20)
	_i = 0;
	
	//put markers on players
	{
		if (not(_i < (count name_3d_controls)) ||
			not(INV_shortcuts)  || [_player] call player_civilian ||
			not(alive _player) || visibleMap) exitWith {};
		
		if (true) then {
			private["_control"];
			_control = name_3d_controls select _i;
			
			private["_target", "_cside", "_vehicle"];
			_target = _x;
			_cside = ([_target] call player_side);
			_vehicle = (vehicle player);
			
			if (not(_side == _cside) ||  not(alive _vehicle) || not(isPlayer _target) ||
				not(alive _target) || _target == _player ) exitWith {
				_control ctrlShow false;
			};

			private["_distance", "_has_admin_camera"];
			_has_admin_camera = [_target, "has_admin_camera"] call player_get_bool;
			_distance = _target distance _player;
			if (_distance <  5 || _has_admin_camera) exitWith {
				_control ctrlShow false;
			};

			private["_part", "_pos", "_pos2D"];
			_part = if ((vehicle _target) == _target) then {"neck" } else {"engine"};
			_pos = (_target selectionPosition _part);
			//player groupChat format["_pos = %1", _pos];
			_pos = [(_pos select 0), (_pos select 1), (_pos select 2) + 0.3];
			_pos2D = worldToScreen((vehicle _target) modelToWorld (_pos));
			if (not(count _pos2D == 2)) exitWith {
				_control ctrlShow false;
			};
		
			private["_size"];
			_size = (1 - _distance/120) max (0.6);
			_pos2D = [((_pos2D select 0)- 0.015), (_pos2D select 1) - 0.015];
			
			
			private["_x", "_y"];
			_x = abs((_pos2D select 0) - 0.5);
			_y = abs((_pos2D select 1) - 0.5);
			private["_aimin_at_center"];
			_aimin_at_center = (_x < 0.01 && _y < 0.01);
			if ((_aimin_at_center || _target == cursorTarget) && _distance > 25) then {
				_control ctrlSetStructuredText parseText format["<img  size=""%1"" color=""#ccFF6600"" image=""tri2.paa"" /><br /><t color='#ccFF6600'>[%2-%3, %4 m]</t>", _size, _target, (name _target), round(_distance)];
			}
			else {
				_control ctrlSetStructuredText parseText format["<img  size=""%1"" color=""#ccFF6600"" image=""tri2.paa"" />", _size];
			};
		
			_control ctrlShow true;
			_control ctrlSetPosition _pos2D;
			_control ctrlCommit 0;	
			_i = _i + 1;
		};
	} forEach name_tags_side_units;
	
	//hide the unused markers
	while { _i < (count name_3d_controls)} do {
		private["_control"];
		_control = name_3d_controls select _i;
		_control ctrlShow false;
		_i = _i + 1;
	};
};


name_tags_3d_controls_setup = {
	private["_marker_id", "_end"];
	_marker_id = tags_marker_start + 1;
	_end = tags_marker_end + 1;
	
	name_3d_controls = if (isNil "name_3d_controls") then { [] } else { name_3d_controls - [controlNull] };
	if (count name_3d_controls > 0) exitWith {};
	
	disableSerialization;
	cutRsc ["Rtags","PLAIN", 1e+011];
	
	private["_controls", "_display"];
	_controls = [];
	_display = (uiNamespace getVariable 'TAGS_HUD');
	
	while {_marker_id < _end } do {
		private["_control"];
		_control = _display displayCtrl _marker_id;
		_controls set[count(_controls), _control];
		_marker_id = _marker_id + 1;
	};
	name_3d_controls = _controls;
	//player groupChat format["name_3d_controls = %1", name_3d_controls];
	name_3d_controls
};

name_tags_control = {
	((uiNamespace getVariable 'TAGS_HUD') displayCtrl tags_name_id)
};

onEachFrameHack = {
	//player groupChat format["onEachFrameHack %1", _this];
	[player, ([player] call player_side)] call name_3d_tags_draw;
	if (!([player] call name_tags_draw)) then {
		([] call name_tags_control) ctrlShow false;
	};
};

//loop for making list of units in your own side 
//(this is needed so that we dont go through the full player list each time per frame)
name_tags_side_units = [];
name_tags_loop = {
	//player groupChat format["name_tags_loop"];
	private["_player"];
	_player = player;
	if (alive _player) then {
		private["_side"];
		_side = [_player] call player_side;
		name_tags_side_units = name_tags_side_units - [objNull];
		
		private["_cplayer", "_cside"];
		{
			_cplayer = _x;
			if (not(isNil "_cplayer")) then { 
				if ((typeName _cplayer) == "OBJECT") then {
					if !(isNull _cplayer) then { 
						_cside = side _cplayer;
						if (_cside == _side) then {
							if !(_cplayer in name_tags_side_units) then {
								name_tags_side_units set [count(name_tags_side_units), _cplayer];
							};
						};
					};
				};
			};
		} forEach playableUnits;
	};
	[] spawn name_tags_loop;
};

[] spawn name_tags_loop;