BTK Cargo Drop v1.92

With this script you can load objects and vehicles into helicopter and
aircrafts and drop them somewhere.
The Object will be dropped on a parachte with a blue smoke grenade.

Works in (dedicated) multiplayer (JIP)!

Works with AND without Operation Arrowhead, British Armed Forces or ACE2.



******* INSTALLATION *******

Copy and paste the BTK folder to your mission folder.

Add this line to your init.sqf:
execVM "BTK\Cargo Drop\Start.sqf";

To disable the feature at all, do the comment thing:
// execVM "BTK\Cargo Drop\Start.sqf";



******* SETTINGS *******

You can change the loadable objects by editing the
"BTK\Cargo Drop\Settings_Objects.sqf" and
"BTK\Cargo Drop\Settings_Transporter.sqf" files.



******* INGAME USAGE *******

The action for loading cargo will be added automatically to all compatible
vehicles.

Just place an object near the transporter and select the "Load cargo"
action. To drop off or unload select the unload action...



******* SUPPORTED VEHICLES *******

Small (can load ammoboxes, small objects and most static weapons)
+ All AH and MH6 types
+ All Su25 types
+ All F35 types
+ All AV8B2 types
+ All AH1 types
+ All Kamov types
+ All L39 types
+ All An2 types
+ A10
+ MQ9PredatorB

Medium (same like small + atv and motorcycle)
+ All UH1 types
+ All UH1H types
+ All UH60 types
+ All Mi171Sh types
+ All Mi24 types
+ AW159
+ Merlin HC3

Large (ammoboxes, small objects, static weapons, cars and boats)
+ All CH47 types
+ MV22

Xtra Large (same like large + trucks, apcs and cargo containers)
+ All C130 types



******* Changelog v1.9 *******


******* NEW *******
+ Please delete any older version - New script and file structure!
+ The "Load cargo" action gets now inizialied to the vehicles automatically,
even after respawn.
+ Lots of new vehicles supported.
+ New Hints.

+ For mission makers:

BTK_CargoDrop_ObjectLoaded - This detects whenever a object is loaded in.
Sample:
_YourVariable = YOUROBJECT getVariable "BTK_CargoDrop_ObjectLoaded";
_YourVariable = true; // means the object has been loaded in.

BTK_CargoDrop_TransporterLoaded - This detects whenever a transporter contains cargo.
Sample:
_YourVariable = YOUROBJECT getVariable "BTK_CargoDrop_TransporterLoaded";
_YourVariable = true; // means the transporter has cargo loaded.

Both are LOCAL ONLY ! See Demo mission files for more details!



******* CHANGED *******
+ Changed load, unload and drop code for better results.
+ Optimized some attach positions.
+ Lots of small improvements.
+ Now using big parachute for a better drop-off behaviour.
+ Increased radius for loading in for most vehicles.



******* FIXED *******
+ JIP. You can now use the functions after reconnecting to the
mission/server.
+ Sometimes objects stuck in the air after drop.
+ Sometimes objects disappeared into the ground after drop.
+ Fixed: R3F lifting is now possible when cargo loaded. You have to hover
very low for that. (This fix is still wip)



******* Changelog v1.91 *******


******* CHANGED *******
+ Added all trucks and apcs to XL transporters (C130)
+ Changed unload procedure
+ Demo Mission is now optional (Select the Start Mission action to start it)



******* Changelog v1.92 *******


******* CHANGED *******
+ AW159 Wildcat is now small transporter
+ Mi17 and Mi117 are now large transporters
+ C130 positions tweaked (thx spyhunter82)
+ F35 load position (to avoid collison)
+ PAA file is now included (No more error messages for not-arrowhead users)