hint "Please read the TLR tabs on map before playing";
server globalchat "[MoTD]Welcome to Takistan Life: Revolution!";
custom_motd = nil;
while {true} do {	
	{server globalChat format["[MoTD] %1", _x]} forEach [
			"http://www.takistanliferevolution.com",
			"TS3: tlr.ts.nfoservers.com",
			"All Blufor, Opfor, and Independent factions are required to be on TS3"
		];
	
	if (not(isNil "custom_motd")) then { if (typeName custom_motd == "STRING") then { if (custom_motd != "") then {
		server globalChat format["[MoTD] %1", custom_motd];
	};};};
	sleep (3 * motdwaittime);
};
