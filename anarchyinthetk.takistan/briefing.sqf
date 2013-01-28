if(player diarySubjectExists "Rules") exitwith{};


player createDiarySubject ["rules","Rules"];
player createDiarySubject ["blufor","Bluefor Faction"];
player createDiarySubject ["opfor","Opfor Faction"];
player createDiarySubject ["indfor","Indfor Faction"];
player createDiarySubject ["controls","TLR Controls"];
player createDiarySubject ["stun","TLR Stunning"];
player createDiarySubject ["hunting","TLR Hunting"];
player createDiarySubject ["clothes","TLR Clothing"];
player createDiarySubject ["paint","TLR Painting"];
player createDiarySubject ["donations","Donations"];
player createDiarySubject ["credits","TS3, Website and Credits"];
player createDiarySubject ["origins","History of Life RP Maps"];
player createDiarySubject ["help","Help and Tips"];

///////////////////////////////////////////////////////////////////////////////////////

player createDiaryRecord ["paint",
[
"",
"
<br/>
TLR PAINTING-<br/>
Check map keys for the marker<br/>
Locations:<br/>
		-South Airfield<br/>
		-North Airfield<br/>
		-Feruz Abad<br/>
		-Mosque<br/>
		-Cop Base<br/>
		-PMC Base<br/>
<br/>
How to use:<br/>
		MAKE SURE YOU ARE IN A VEHICLE<br/>
		Drive up to the flag(s)<br/>
		You will get an option to Access Painting on the action menu<br/>
<br/>
"
]
];

///////////////////////////////////////////////////////////////////////////////////////

player createDiaryRecord ["clothes",
[
"",
"
<br/>
TLR CLOTHING-<br/>
Check map keys for the marker<br/>
Locations:<br/>
		-Mosque (Civilian)<br/>
		-Rasman (Civilian)<br/>
		-PMC (Civilian)<br/>
		-Terror (Civilian)<br/>
		-Blufor Base (Blufor)<br/>
		-Opfor Base (Opfor)<br/>
		-Insurgent base (Independent)<br/>
Only the sides in the () can access the given shop<br/>
You cannot die while near a clothing shop barrel<br/>
<br/>
You can switch between the Shop and the Storage from within the menu, you do not need to re-open the dialog<br/>
The controls are self explanatory<br/>
<br/>
Texture Customization<br/>
<br/>
Texture Slots<br/>
Some skins are not able to change colors, this is how BIS made them, we cannot do anything<br/>
<br/>
Quick Textures<br/>
On the right panel is texture options, no guide for it all will be written here at the time<br/>
For Quick Textures<br/>
		-MAKE SURE YOU SELECT A TEXTURE SLOT AT THE TOP RIGHT CORNER<br/>
		-Select custom under the Style dropbox<br/>
		-Select RGB under the Format dropbox<br/>
		-Enter 1 in the Width, Height, Minimap<br/>
		-Select a color under the Custom dropbox<br/>
		-Click Apply<br/>
<br/>
Custom Textures<br/>
		-MAKE SURE YOU SELECT A TEXTURE SLOT AT THE TOP RIGHT CORNER<br/>
		-Select color under the Style dropbox<br/>
		-Select RGB under the Format dropbox<br/>
		-Enter 1 in the Width, Height, Minimap boxes<br/>
		-Enter from the scale 1 to 0 in the Red, Green, and Blue boxes<br/>
		-Enter from the scale 1 to 0.5 in the Alpha box<br/>
		-Click Apply<br/>
<br/>		
If you find a skin that makes an invisible look on your character please report it to avoid being called a hacker!<br/>
<br/>
"
]
];


player createDiaryRecord ["credits",
[
"",
"
Teamspeak 3 Information:<br/>
Address: tlr.ts3dns.com<br/>
Port: (Default)
Passwork: (No Password)
<br/>
Official Website: http://TLR.enjin.com<br/>
Join the forums, make suggestions and voice complaints!<br/>
<br/>
<br/>
Original scripts by Issetea and Fewo<br/>
Additional life scripts by Pogoman, Gman, TeeTime and HarryWorner<br/>
Ported to OA by EddieV, ported to Takistan by Destructo and CrazyMonkey<br/>
Current version by Trotsky, iShOoTyOuNoW, Marinesharp, M5iC, Droo_k6, Micovery<br/>
<br/>
Special thanks to Eddie from GC!<br/>
"
]
];

player createDiaryRecord ["origins",
[
"",
"
These games have a long history, going back to Crime City for Operation Flashpoint <br/>
In Arma 1, Sahrani Life was created by Issetea and Fewo. It was the basis for all RPG missions to come.<br/>
Chernarus Life was the first RPG map for Arma 2, and most of the basic code from it is still in use in Zargabad, Takistan and Island Life today<br/>
The map you are playing is the product of years of work by dozens, if not hundreds of different people. It's FREE and belongs to EVERYONE!<br/>
"
]
];

player createDiaryRecord ["help",
[
"",
"
Please report bugs to admins!<br/>
<br/>
If you require help please visit the forums or join teamspeak 3.
<br/>
Website: http://TLR.enjin.com<br/>
Teamspeak 3: tlr.ts3dns.com<br/>
<br/>
We look forward to hearing from you!<br/>
<br/>
Map Key is located on the top-left side of the map.<br/>
"
]
];

player createDiaryRecord ["controls",
	[
	"",
	"
	Key: Function<br/>
	Description<br/>
	<br/>
	General keys:<br/>
	1: Stats<br/>
	Displays basic info about the player and server. Tells you how much money you have, who is wanted, etc.
	<br/>
	2: Inventory<br/>
	Shows items in player inventory. Allows you to drop, use, and give them to other people. (Note: to give another player a copy of your car keys, first press Use while Keychain is selected)
	<br/>
	3: Hands Up<br/>
	Raises hands to indicate surrender. Police can search and handcuff a civilian while their hands are raised.
	<br/>
	4: Hands Down / Quick Draw<br/>
	Cancels the current animation. Can be used to quick draw a weapon.
	<br/>
	5: Gang Menu (civs only)<br/>
	Civs can access the gang menu to view, join and create gangs.
	<br/>
	`(tilde key (to the left of the 1 key): Cop Menu (cops only)<br/>
	Cops can set bounties, release jailed civilians and more. When accessed in a vehicle, choosing Sat Cam in cop menu gives an overhead satellite view of the map.
	<br/>
	<br>
	Ctrl + F (in a vehicle): Toggle Siren On/Off (cops only)<br/>
	Ctrl + G (in a vehicle as driver): Turn on/off speedgun (cops only)<br/>
	Ctrl + H (in a vehicle): Activate Police Horn (cops only)<br/>
	Police can turn on a siren while driving vehicles to signal to civilians to pull over.<br>
	<br>
	<br/>
	E: Action<br/>
	The basic action button.  Used to interact with shops, ATM's, and other players (while they are stunned and/or restrained).
	<br/>
	T: Access Vehicle Trunk<br/>
	when you own a car or other vehicle, you can access that car's inventory by standing next to the car and pressing T.  You will then be shown two box's.  The left box is what is in the car, and the right box is what is in your inventory.  Highlight the object you want to transfer, then select the amount and press the button on the side that has the item.  Car's hold a certain amount of weight just like your charactor so be aware of what you stash in there.  Also, if your vehicle is destroyed then you will loose whatever you place in here.  Coppers can search for drugs or other ileagal items.  If they find them in your car it will disappear and the coppers gain money equal to the value of the drugs.
	<br/>
	F: Remove Safety<br/>
	When unholstering a weapon, you may need to press F before it will fire. F is also a default ArmA 2 key that adjusts the firing mode of the weapon.
	<br/>
	Ctrl + F: Pistol whip / Rifle butt<br/>
	Disables and disarms another player, allowing you to rob them by pressing E. Only works if you have a weapon.
	<br/>
	Ctrl + Space: Unlock/ Lock Vehicle<br/>
	Unlocks or locks the vehicle closest to you if you have the keys.
	<br/>
	0-0-6, 0-0-7, 0-0-8: shout outs<br/>
	Press these buttons to shout out measages on the fly.  For civilians the default says ""Don't Shoot, I surrender!"".  For cops, it says a variety of things but mainly says, ""Put up your hands or your dead"" kinda thing.
	<br/>
	0-0: options<br/>
	this should give you the options for video settings, shout outs, fix head bug, and even a quick-brief tutorial on TLR.""
	<br/>
	0-8 Communications<br/>
	Allows same menu as radio but just in case you cannot access your radio.
	<br/>
	"
]
];


player createDiaryRecord ["stun",
	[
	"",
	"
	<br/>
	New Stun Information<br/>
	<br/>
	Pistol<br/>
				Only works with pistols<br/>
				M9SD Mag must be loaded<br/>
				Upon loading a new M9SD Magazine in, a check is run and all M9SD magazines will be set to 3 rounds<br/>
				Plays a tazer sound on firing<br/>
				Range-<br/>
						* 1-5 Meters, full stun effect<br/>
						* 5-15 Meters, light stun effect<br/>
				Damage-<br/>
						* 25% of damage applied<br/>
	<br/>
	Shotgun<br/>
				Only works with M1014<br/>
				Slug mags must be loaded<br/>
				Range-<br/>
						* 0-50 Meters, full stun effect<br/>
						* 50-100 Meters, light stun effect<br/>
				Damage-<br/>
						* 25% of damage applied<br/>
	<br/>
	Stun Armor<br/>
	Light- Protects chest area<br/>
		-If stunned in area other than chest you will stagger a bit<br/>
	Full- Protects whole body<br/>
	<br/>
	Stun rounds will not effect cops<br/>
	You will only be ejected from a vehicle if shot with a stun round if you are on a vehicle like a bike or atv<br/>
	<br/>
	Melee<br/>
	Different kinds of weapons have different animations and effects now<br/>
	There is pistol whacking, rifle butting and punching<br/>
	All have different stun times as well as action/reaction animations as well as taking front or back hits into account, you must be facing them within a 45 degree angel of your view<br/>
	Punching can kill someone after the person is hit enough<br/>
	There is differnet/random punch combinations<br/>
	"
]
];

player createDiaryRecord ["hunting",
	[
	"",
	"
	<br/>
	TLR Hunting-<br/>
	There is 5 hunting areas, each with different areas, animals, and spawn times<br/>
	<br/>
	Hunting Areas-<br/>
			1-<br/>
					-Chickens, Cows<br/>
					-500 Meter range<br/>
			2-<br/>
					-Wild Boar, Rabbit<br/>
					-500 Meter range<br/>
			3-<br/>
					-Dogs, Sheep<br/>
					-500 Meter Range<br/>
			4-<br/>
					-Wild Boar, Rabbit<br/>
					-500 Meter Range<br/>
			5-<br/>
					-Goats<br/>
					-2000 Meter Range<br/>
	<br/>
	Legal Hunting Animals-<br/>
			-Cow<br/>
			-Rabbit<br/>
			-Chicken<br/>
			-Sheep<br/>
	Illegal Hunting Animals-<br/>
			-Goat<br/>
			-Boar<br/>
			-Dog<br/>
	<br/>
	<br/>
	*WARNING INFORMATION*<br/>
	Animal Lovers in the Takistan Region have been known to attach IEDs to animals in attempts to lower illegal animal hunter numbers<br/>
	<br/>
	"
]
];


player createDiaryRecord ["rules",
[
"Rules",
"
Rules for Players:<br/>
<br/>
All rules are enforced by the admins!<br/>
<br/>
1) Do not kill unarmed civilians.<br/>
<br/>
2) Do not teamkill or rob teammates as BLUFOR / OPFOR / INDFOR.<br/>
<br/>
3) Do not randomly stun / detain / arrest civilians as BLUFOR.<br/>
<br/>
4) Do not use offensive racist, sexist, or homophobic language. Do not insult another player based on their real or perceived race, sex, national origin or sexual preference.<br/>
<br/>
5) Please get on Teamspeak if you are BLUFOR / Cop.<br/>
<br/>
Rules are enforced by the Admins.<br/>
<br/>
Guidelines are to give out helpful information. The admins will not enforce them unless deemed necessary.
"
]
];

player createDiaryRecord ["rules",
[
"DeathMatching Rule",
"
Deathmatching is killing unarmed civilians without a legit reason.<br/>
This applies to all factions: Civilians, Blufor, Opfor, Independent.<br/>
<br/>
Civilians may kill members of the other factions (Not Civilian) without the Deathmatching rule applying.<br/>
Opfor may kill Blufor and Independent Freely.<br/>
Blufor may kill Opfor and Independent Freely.<br/>
Independent may kill Blufor and Opfor Freely.<br/>
Private Military Contractors count as Blufor and may be killed by all but they do not work as Blufor so they may not be a threat to you.<br/>
<br/>
Don't forget to read the Private Military Contractor rules.
"
]
];

player createDiaryRecord ["rules",
[
"Private Military Contractors Rules",
"
P.M.C. <br/>
Private Military Company.<br/>
Private Military Contractor.<br/>
<br/>
Private Military Company is a place where Civilians can become Private Military Contractors.<br/>
	-PMCs may be killed by other factions if they feel, deathmatching will not apply since PMC is Blufor related.<br/>
	-It is NOT a place where people can buy guns to use for war-personal use that is not related to company ordeals.<br/>
	-All the equipment is meant for the safety of PMC employees and contract related materials.<br/>
	-Private Military Contractors may engage any member of the Opfor and Insurgent factions like any other civilian.<br/>
	-Private Military Contractors must not directly engage Blufor. You may only attack Blufor forces if your company are engaged upon first.<br/>
	-You may use your equipment against any faction for completion of a contract that abides by the server rules or for personal safety.<br/>
	-PMCs may attack Blufor forces if they are engaged upon first.<br/>
	-Company demands you are not allowed to sell PMC equipment for any reason.<br/>
	-PMCs must wear PMC clothing at all times unless the situation has been cleared with the police chief or an administrator.<br/>
	-Contracts must not be against the Blufor forces in anyway, shape or form.<br/>
	-PMCs are allowed to posess PMC equipment and have in all public areas unless a police chief has made an order against in public places.<br/>
	-PMCs are allowed to carry PMC equipment, police may however can search you for your licence.<br/>
By breaking a PMC rule one of several things can happen:<br/>
	-Removed from the PMC Whitelist.<br/>
	-Licenses, Clothing and all Equipment revoked.<br/>
	-Blufor lawful action.<br/>
	-You may be blacklisted from PMC temporarily or permanently.<br/>
<br/>
<br/>
Contracts Examples:<br/>
	-Bodyguards/Defence<br/>
	-Delivery/Logistics<br/>
	-Securing/Retrieval of Personal/Material<br/>
	-Protection of a civilian area<br/>
	-Extraction<br/>
	-Transport<br/>
	-Border Patrol<br/>
	-Law Enforcement<br/>
<br/>
Illegal-Rule Breaking Contract Examples:<br/>
	-Bounty hunting<br/>
	-Assault-Conquest-Hostile Takeover<br/>
	-Protection of a military area<br/>
	-Direct involvment in a war (contracts that requie fighting)<br/>
<br/>
"
]
];

player createDiaryRecord ["rules",
[
"Communication Guidelines",
"
Teamspeak spying is cheating. Joining an opponents teamspeak channel to gather information about an opponent is teamspeak cheating.<br/>
Try to only use global chat only for emergencies.<br/>
"
]
];

player createDiaryRecord ["rules",
[
"Search Guidelines",
"
Random searches are allowed but must not be abused.<br/>
Examples of when you should search:<br/>
		-Checking people around a bank that has been robbed<br/>
		-Near or in the area of a crime<br/>
		-Checking people going through a checkpoint<br/>
		-Because the person looks suspicious<br/>
"
]
];

player createDiaryRecord ["blufor",
[
"Blufor/Cop Guidelines",
"
***LETHAL FORCE SHOULD ONLY BE USED IF YOUR LIFE IS IN IMMEDIATE DANGER.***<br/>
Personal safety is your first priority, and Civilian safety is your second priority!<br/>
Your main objective is to keep peace in Northern Takistan.<br/>
All Blufor should carry a stun weapon.<br/>
Blufor must obey traffic laws, unless responding to a call. Police must have their lights and sirens on for legitimate reasons in order to speed.<br/>
If a vehicle is illegally parked or blocking an area they should ask the civilian to move it, if the civilian does not move the vehicle, they may impound it.<br/>
Any vehicle used in a crime must be impounded. (All illegal items in a vehicle are removed when its impounded) Any weapon used in a crime must be taken as evidence.<br/>
Fortify the borders and provent the propaganda from the South spreading hate across Takistan, before your citizens turn against you.<br/>
Tickets should only be given for legitimate reasons. Here is a small guide:<br/>
	-Not cooperating: 10k<br/>
	-Blocking roads: 15k<br/>
Arrests should only be given for legitimate reasons. Here is also a small guide:<br/>
	-Still not cooperating: 1minute<br/>
	-Aiding a criminal: 4minutes<br/>
	-Bank robbery: 6minutes<br/>
	-Killing Blufor: 12minutes<br/>
	-Mass murder: 20minutes<br/>
Aviod firing on unknown aircraft, unless you know for 100% that it is hostile.<br/>
<br/>
All Blufor Must join Teamspeak 3 at tlr.ts3dns.com<br/>
This will help with operations and communication. Join the Blufor Channels, and make sure your name is the same as ingame.<br/>
<br/>
LAWS<br/>
	-**A LAW CANNOT DIRECTLY COUNTER A SERVER RULE!**<br/>
	-The Blufor are not required to enforce any laws made by the president unless the Police Chief agrees<br/>
<br/>
Private Military Contractors<br/>
	-Blufor must not engage PMCs unless they have a legitimate reason and or are deemed a direct threat to the safety of others. Not a excuse to outright kill them on sight.<br/>
"
]
];

player createDiaryRecord ["indfor",
[
"Insurgent Guidelines",
"
All Independent Must join Teamspeak 3 at tlr.ts3dns.com<br/>
You are a insurgent and a rebel to the Takistan Government. <br/>
Do so by acting in this manner, destory anything that comes into your path.<br/>
Rob, Murder, Destory.<br/>
Allah is your master and commander.
"
]
];

player createDiaryRecord ["opfor",
[
"Opfor Guidelines",
"
All Opfor Must join Teamspeak 3 at tlr.ts3dns.com<br/>
You are a member of the Takistan Liberation Army. Your objective is to hold your territory from the democracy in the North.<br/>
Your commanders have ordered you to liberate all foreign members from your land and try to restore dictatorship in Takistan.<br/>
Do what ever you need to do to fulfill their commands, even if it means temporary maintaining a ceasefire with the Northen governments.<br/>
Your main concern is the insurgents that have established in the west, rid them from your land.<br/>
"
]
];

player createDiaryRecord ["rules",
[
"Government Guidelines",
"
President<br/>
	-Must be a civilian.<br/>
	-May not be involved in any illegal activities.<br/>
	-Cannot stop Martial Law.<br/>
<br/>
Police Chief<br/>
	-Represent and maintain the Blufor faction.<br/>
	-Handle relations with other factions and government officials including the president.<br/>
	-May declare Martial Law. (Preventing Civilians from directy entering areas and/or containing weapons in a given area)<br/>
"
]
];

player createDiaryRecord ["rules",
[
"New Life Guidelines",
"
The New Life is when you are killed, or suicide.<br/>
<br/>
"
]
];

player createDiaryRecord ["donations",
[
"Donations",
"
Donate at http://tlr.enjin.com for extra starting money! More donator rewards coming soon, special shops and private houses!<br/>
<br/>
"
]
];