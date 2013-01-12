_handler = [] execVM "bankvariables.sqf";
waitUntil {scriptDone _handler};

_handler = [] execVM "interest.sqf";

