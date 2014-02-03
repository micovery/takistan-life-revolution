#define SleepWait(timeA) private["_waittt"]; _waittt = time + timeA; waitUntil {time >= _waittt};

// Attente fin briefing
SleepWait(0.1)

private ["_liste_objets_depl_heli_remorq_transp", "_liste_vehicules_connus", "_liste_vehicules", "_count_liste_vehicules", "_i", "_objet"];

// Union des tableaux de types d'objets servant dans un isKindOf
_liste_objets_depl_heli_remorq_transp = R3F_LOG_CFG_objets_deplacables + R3F_LOG_CFG_objets_heliportables +
	R3F_LOG_CFG_objets_remorquables + R3F_LOG_classes_objets_transportables;

// Contiendra la liste des v�hicules (et objets) d�j� initialis�s
_liste_vehicules_connus = [];

while {true} do {
	if !(isNull player) then {
		// R�cup�ration des tout les nouveaux v�hicules de la carte et des nouveaux objets d�rivant de "Static" (caisse de mun, drapeau, ...) proches du joueur
		_liste_vehicules = (vehicles + nearestObjects[player, ["Static"], 80]) - _liste_vehicules_connus;
		_count_liste_vehicules = count _liste_vehicules;
		
		if (_count_liste_vehicules > 0) then {
			// On parcoure tout les v�hicules pr�sents dans le jeu en 18 secondes
			for [{_i = 0}, {_i < _count_liste_vehicules}, {_i = _i + 1}] do {
				_objet = _liste_vehicules select _i;
				
				// Si l'objet est un objet d�pla�able/h�liportable/remorquable/transportable
				if ({_objet isKindOf _x} count _liste_objets_depl_heli_remorq_transp > 0) then {
					[_objet] spawn R3F_LOG_FNCT_objet_init;
				};
				
				// Si l'objet est un v�hicule h�liporteur
				if ({_objet isKindOf _x} count R3F_LOG_CFG_heliporteurs > 0) then {
					[_objet] spawn R3F_LOG_FNCT_heliporteur_init;
				};
				
				// Si l'objet est un v�hicule remorqueur
				if ({_objet isKindOf _x} count R3F_LOG_CFG_remorqueurs > 0) then {
					[_objet] spawn R3F_LOG_FNCT_remorqueur_init;
				};
				
				// Si l'objet est un v�hicule remorqueur
				if ({_objet isKindOf _x} count R3F_LOG_classes_transporteurs > 0) then {
					[_objet] spawn R3F_LOG_FNCT_transporteur_init;
				};
				
				SleepWait(18/_count_liste_vehicules)
			};
			
			// Les objets ont �t� initialis�s, on les m�morise pour ne plus les r�-initialiser
			_liste_vehicules_connus = _liste_vehicules_connus + _liste_vehicules;
		} else {
			SleepWait(18)
		};
	} else {
		SleepWait(2)
	};
};