tlr_hud_array set [(count tlr_hud_array), ["Please read the TLR tabs on map before playing",(time+5)]];
//hint ;
server globalchat "[MoTD]Welcome to Takistan Life: Revolution!";
custom_motd = nil;
while {true} do {
	server globalchat "[MoTD] http://www.takistanliferevolution.com";
	server globalchat "[MoTD] TS3: tlr.ts3dns.com";
	server globalChat "[MoTD] All Blufor, Opfor, and Independent factions are required to be on TS3";
	if (not(isNil "custom_motd")) then { if (typeName custom_motd == "STRING") then { if (custom_motd != "") then {
		server globalChat format["[MoTD] %1", custom_motd];
	};};};
	sleep (3 * motdwaittime);
};
