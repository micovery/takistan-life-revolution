if (R3F_LOG_mutex_local_verrou) then {
	player globalChat STR_R3F_LOG_mutex_action_en_cours;
} else {
	R3F_LOG_mutex_local_verrou = true;
	
	private ["_heliporteur", "_objet"];
	
	_heliporteur = _this select 0;
	_objet = _heliporteur getVariable "R3F_LOG_heliporte";
	
	// On mémorise sur le réseau que le véhicule n'héliporte plus rien
	_heliporteur setVariable ["R3F_LOG_heliporte", objNull, true];
	// On mémorise aussi sur le réseau que l'objet n'est plus attaché
	_objet setVariable ["R3F_LOG_est_transporte_par", objNull, true];
	
	detach _objet;
	
	_objet setPos [getPos _objet select 0, getPos _objet select 1, 0];
	_objet setVelocity [0, 0, 0];
	
	player globalChat format [STR_R3F_LOG_action_heliport_larguer_fait, getText (configFile >> "CfgVehicles" >> (typeOf _objet) >> "displayName")];
	
	R3F_LOG_mutex_local_verrou = false;
};