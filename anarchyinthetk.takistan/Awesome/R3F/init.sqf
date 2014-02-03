/**
 * Copyright (C) 2010 madbull ~R3F~
 * 
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 * 
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 * 
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */
 
STR_R3F_ARTY_LOG_nom_produit = "[R3F] Artillery and Logistic";

[] call compile preprocessFile "Awesome\R3F\R3F_LOG\en_strings_lang.sqf";

if (isServer) then {
	// Service offert par le serveur : orienter un objet (car setDir est à argument local)
	R3F_ARTY_AND_LOG_FNCT_PUBVAR_setDir = {
		private ["_objet", "_direction"];
		_objet = _this select 1 select 0;
		_direction = _this select 1 select 1;
		
		// Orienter l'objet et broadcaster l'effet
		_objet setDir _direction;
		_objet setPosATL (getPosATL _objet);
	};
	"R3F_ARTY_AND_LOG_PUBVAR_setDir" addPublicVariableEventHandler R3F_ARTY_AND_LOG_FNCT_PUBVAR_setDir;
};
	
	
#include "R3F_LOG\init.sqf"
R3F_LOG_active = true;
	
if !(isServer && isDedicated) then {
	// Client
	[] execVM "Awesome\R3F\surveiller_nouveaux_objets.sqf";
}else{
	// Server
	[] execVM "Awesome\R3F\surveiller_nouveaux_objets_dedie.sqf";
};
