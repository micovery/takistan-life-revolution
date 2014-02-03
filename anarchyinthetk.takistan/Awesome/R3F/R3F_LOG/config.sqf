/*
This file contains the configuration variables of the logistics system.
Important note : All the classes names which inherits from the ones used in configuration variables will be also available.
There are two ways to manage new objects with the logistics system. The first is to add these objects in the
	following appropriate lists. The second is to create a new external file in the /addons_config/ directory,
	according to the same scheme as the existing ones, and to add a #include at the end of this current file.
*/

/******TOW WITH VEHICLE******/

//  List of class names of (ground or air) vehicles which can tow towables objects.
R3F_LOG_CFG_remorqueurs =
[
	// e.g. : "MyTowingVehicleClassName1", "MyTowingVehicleClassName2"
];

//  List of class names of towables objects.
R3F_LOG_CFG_objets_remorquables =
[
	// e.g. : "MyTowableObjectClassName1", "MyTowableObjectClassName2"
];


/******LIFT WITH VEHICLE******/

// List of class names of air vehicles which can lift liftables objects.
R3F_LOG_CFG_heliporteurs =
[
	// e.g. : "MyLifterVehicleClassName1", "MyLifterVehicleClassName2"
];

//  List of class names of liftables objects.
R3F_LOG_CFG_objets_heliportables =
[
	// e.g. : "MyLiftableObjectClassName1", "MyLiftableObjectClassName2"
];


/******LOAD IN VEHICLE******/

// This section use a quantification of the volume and/or weight of the objets.
// The arbitrary referencial used is : an ammo box of type USVehicleBox "weights" 12 units.
// Note : the priority of a declaration of capacity to another corresponds to their order in the tables.
//   For example : the "Truck" class is in the "Car" class (see http://community.bistudio.com/wiki/ArmA_2:_CfgVehicles).
//   If "Truck" is declared with a capacity of 140 before "Car". And if "Car" is declared after "Truck" with a capacity of 40,
//   Then all the sub-classes in "Truck" will have a capacity of 140. And all the sub-classes of "Car", excepted the ones
//   in "Truck", will have a capacity of 40.

// List of class names of (ground or air) vehicles which can transport transportables objects.
// The second element of the arrays is the load capacity (in relation with the capacity cost of the objects).
R3F_LOG_CFG_transporteurs =
[
	// e.g. : ["MyTransporterClassName1", itsCapacity], ["MyTransporterClassName2", itsCapacity]
];

// List of class names of transportables objects.
// The second element of the arrays is the cost capacity (in relation with the capacity of the vehicles).
R3F_LOG_CFG_objets_transportables =
[
	// e.g. : ["MyTransportableObjectClassName1", itsCost], ["MyTransportableObjectClassName2", itsCost]
];

/******MOVABLE-BY-PLAYER OBJECTS******/

// List of class names of objects moveables by player.
R3F_LOG_CFG_objets_deplacables =
[
	// e.g. : "MyMovableObjectClassName1", "MyMovableObjectClassName2"
];

// List of files adding objects in the arrays of logistics configuration (e.g. R3F_LOG_CFG_remorqueurs)
// Add an include to the new file here if you want to use the logistics with a new addon.
#include "addons_config\arma2_CO_objects.sqf"