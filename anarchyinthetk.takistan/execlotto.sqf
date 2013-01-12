_handler = [] execVM "lottoarrays.sqf";
waitUntil {scriptDone _handler};

if (isClient) then {
	_handler = [] execVM "lottoactions.sqf";
};
