private["_unit","_weapon"];
_unit 		= _this select 0;
_weapon		= _this select 1;


_weapon setVehicleInit 
format[
"
static_%1_%2 = this;
this setVehicleVarName 'static_%1_%2';
", player, round(time)];

processInitCommands;

if (_weapon isKindOf "StaticMortar") then {
		_weapon setVehicleInit "
			this addeventhandler [""getIn"", {_this spawn A_fnc_EH_iMortar}];
			this addeventhandler [""fired"", {_this spawn A_fnc_EH_fMortar}];
		";
		processInitCommands;
	};
	