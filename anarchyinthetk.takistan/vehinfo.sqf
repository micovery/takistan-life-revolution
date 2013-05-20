_type    = typeOf _this;
_driver  = "No driver";

if ((_this emptyPositions "Driver") == 0) then {_driver = driver _this};

hint format[localize "STRS_hints_vehicle_information",  _type,  (round(getdir _this)),  (round(getposASL _this select 2)),  _this,  _driver,  (_this emptyPositions "cargo")+(_this emptyPositions "driver"),  (round((sizeOf _type)*10)/10), _businfo];



