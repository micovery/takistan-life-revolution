// hitpart event handler scripts
// EH_hitpart.sqf
// This event handler is fired localy to the shooter
_target			= _this select 0;	// Object		Object that got damaged
_shooter		= _this select 1;	// Object		Object that inflicted damage
_bullet			= _this select 2;	// Object		object fired
_position		= _this select 3;	// Position3D	Position the bullet impacted (ASL)
_velocity		= _this select 4;	// Vector3D		3D speed at which bullet impacted
_selection		= _this select 5;	// Array		Array of strings with named selections that were hit
_ammo			= _this select 6;	// Array 		Array: [hit value, indirect hit value, indirect hit range, explosive damage, ammo class name] OR, if there is no shot object: [impulse value on object collided with,0,0,0]
_direction		= _this select 7;	// Vector3D		Vector that is orthogonal (perpendicular) to the surface struck (if a wall was hit, vector would be pointing out of the wall at a 90 degree angle.)
_radius			= _this select 8;	// Number		Radius of component hit
_surface		= _this select 9;	// String		Surface type hit
_direct			= _this select 10;	// Bool			dirrect (true) or indirect hit (false)