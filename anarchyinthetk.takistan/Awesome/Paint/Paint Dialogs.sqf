_location = (_this select 3) select 0;

if ((vehicle player) == player) exitwith {player groupchat "P ERROR: NOT IN VEHICLE";};

player groupchat "For easy Textures select the following options:";
player groupchat "Top right box: Select a numbered slot for the textures";
player groupchat "*WARNING SOME VEHICLES DO NOT HAVE TEXTURE SLOTS*";
player groupchat "Styles dropbox: Custom";
player groupchat "Custom dropbox: Whatever color you want";
player groupchat "Then select apply and buy!";


[_location] call P_Dialog_Full;