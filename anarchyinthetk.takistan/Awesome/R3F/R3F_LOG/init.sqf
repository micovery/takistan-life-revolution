#include "config.sqf"

if (isServer) then {
	// On crée le point d'attache qui servira aux attachTo pour les objets à charger virtuellement dans les véhicules
	R3F_LOG_PUBVAR_point_attache = "HeliHEmpty" createVehicle [0, 0, 0];
	publicVariable "R3F_LOG_PUBVAR_point_attache";
};

// Un serveur dédié n'en a pas besoin
if !(isServer && isDedicated) then {
	// Le client attend que le serveur ai créé et publié la référence de l'objet servant de point d'attache
	waitUntil {!isNil "R3F_LOG_PUBVAR_point_attache"};
	
	/** Indique quel objet le joueur est en train de déplacer, objNull si aucun */
	R3F_LOG_joueur_deplace_objet = objNull;
	
	/** Pseudo-mutex permettant de n'exécuter qu'un script de manipulation d'objet à la fois (true : vérouillé) */
	R3F_LOG_mutex_local_verrou = false;
	
	/** Objet actuellement sélectionner pour être chargé/remorqué */
	R3F_LOG_objet_selectionne = objNull;
	
	// On construit la liste des classes des transporteurs dans les quantités associés (pour les nearestObjects, count isKindOf, ...)
	R3F_LOG_classes_transporteurs = [];
	
	{
		R3F_LOG_classes_transporteurs = R3F_LOG_classes_transporteurs + [_x select 0];
	} forEach R3F_LOG_CFG_transporteurs;
	
	// On construit la liste des classes des transportables dans les quantités associés (pour les nearestObjects, count isKindOf, ...)
	R3F_LOG_classes_objets_transportables = [];
	
	{
		R3F_LOG_classes_objets_transportables = R3F_LOG_classes_objets_transportables + [_x select 0];
	} forEach R3F_LOG_CFG_objets_transportables;
	
	R3F_LOG_FNCT_objet_init = compile preprocessFile "Awesome\R3F\R3F_LOG\objet_init.sqf";
	R3F_LOG_FNCT_heliporteur_init = compile preprocessFile "Awesome\R3F\R3F_LOG\heliporteur\heliporteur_init.sqf";
	R3F_LOG_FNCT_remorqueur_init = compile preprocessFile "Awesome\R3F\R3F_LOG\remorqueur\remorqueur_init.sqf";
	R3F_LOG_FNCT_transporteur_init = compile preprocessFile "Awesome\R3F\R3F_LOG\transporteur\transporteur_init.sqf";
	
	R3F_LOG_FNCT_LOCKCHECK = {
			private["_player", "_object"];
			_player = _this select 0;
			_object = _this select 1;
			
			(
				(!(alive player)) ||
				(player getVariable ["isstunned", false]) ||
				(player getVariable ["restrained", false]) ||
				((player distance _object) > 15) ||
				false
			)
		};
		
	R3F_LOG_FNCT_STATICCHECK = {
		private["_object"];
		_object = _this select 0;
		if !(_object isKindOf "StaticWeapon") exitwith {true};
		(count(crew _object) == 0)
	};
	
	/** Indique quel est l'objet concerné par les variables d'actions des addAction */
	R3F_LOG_objet_addAction = objNull;
	
	// Liste des variables activant ou non les actions de menu
	R3F_LOG_action_charger_deplace_valide = false;
	R3F_LOG_action_charger_selection_valide = false;
	R3F_LOG_action_contenu_vehicule_valide = false;
	
	R3F_LOG_action_remorquer_deplace_valide = false;
	R3F_LOG_action_remorquer_selection_valide = false;
	
	R3F_LOG_action_heliporter_valide = false;
	R3F_LOG_action_heliport_larguer_valide = false;
	
	R3F_LOG_action_deplacer_objet_valide = false;
	R3F_LOG_action_remorquer_deplace_valide = false;
	R3F_LOG_action_selectionner_objet_remorque_valide = false;
	R3F_LOG_action_detacher_valide = false;
	R3F_LOG_action_charger_deplace_valide = false;
	R3F_LOG_action_selectionner_objet_charge_valide = false;
	
	/** Ce fil d'exécution permet de diminuer la fréquence des vérifications des conditions normalement faites dans les addAction (~60Hz) */
	[] execVM "Awesome\R3F\R3F_LOG\surveiller_conditions_actions_menu.sqf";
};