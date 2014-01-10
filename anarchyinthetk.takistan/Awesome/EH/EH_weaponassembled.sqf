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
			this addeventhandler [""getIn"", {_this execVM ""Awesome\EH\EH_getin_mortar.sqf""}];
			this addeventhandler [""fired"", {_this execVM ""Awesome\EH\EH_fired_mortar.sqf""}];
		";
		processInitCommands;
	};
	