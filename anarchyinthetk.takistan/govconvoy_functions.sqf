
convoy_side_msg = {
	private ["_msg1","_msg2"];
	_msg1 = _this select 0;
	switch(_msg1) do {
	case 1:{
			_msg1="All units, supply truck has entered North Takistan. Defend it against bandits and terrorists, and escort it to base!";
			_msg2="Villagers rumors indicates a valuable North Government truck somewhere in north of our country!!";
		   };
	case 2:{
			_msg1="The governemnt convoy driver is dead. Get in his truck and drive it to North Gov base!!";
			_msg2="Villagers rumors indicates a valuable North Government truck somewhere in north of our country!!";
	      };
	case 3:{
			_msg1="All units, governemnt convoy is heavily damaged!! Move to truck position and protect a 50m perimeter!!";
			_msg2="";
	      };
	case 4:{
			[player, govconvoybonus] call bank_transaction; 
			_msg1= format["you received $%1 for the successfully escorting the convoy", govconvoybonus];
			_msg2="";
		   };
	
};

if( [player] call player_cop) then { player sidechat format [ "%1",_msg1];}
 else { if(_msg2!="") then{ player sidechat format [ "%1",_msg2];}; };  
};

