private["_handler"];
_handler = [] execVM "lottoarrays.sqf";
waitUntil {scriptDone _handler};

if (isClient) then {
	[] execVM "lottoactions.sqf";
};
