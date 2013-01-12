INV_Licenses =
    [

        ["car",[licenseflag3,university,licenseflag5,pmclicenses],localize "STRS_license_car",5000],
        //["pick-up",[university,university,university,university],localize "STRS_licence_pick-up",25000],
        //["boat",[university,university,university,university],localize "STRS_license_boat",1500],
        ["truck",[licenseflag3,university,pmclicenses,licenseflag5],localize "STRS_license_truck",32500],
        ["oil",[Oil_1,Oil_1,Oil_1,Oil_1],"Oil Processor's License",45000],
        ["diamond",[Diamond_1,Diamond_1,Diamond_1,Diamond_1],"Diamond Processor's License",95000],
        //["Baker",[Bakery_1,Bakery_1,Bakery_1,Bakery_1],"Baker's license",1000],
        ["glassblowing",[Glassblower,Glassblower,Glassblower,Glassblower],localize "STRS_license_glassblowerlicense",65000],
        ["cocaine ga1",[gangarea1,gangarea1,gangarea1,gangarea1],"GA1 Cocaine Processing Training",30000],
        ["lsd ga1",[gangarea1,gangarea1,gangarea1,gangarea1],"GA1 LSD Processing Training",15000],
        ["heroin ga2",[gangarea2,gangarea2,gangarea2,gangarea2],"GA2 Heroin Processing Training",25000],
        ["lsd ga2",[gangarea2,gangarea2,gangarea2,gangarea2],"GA2 LSD Processing Training",15000],
        ["heroin ga3",[gangarea3,gangarea3,gangarea3,gangarea3],"GA3 Heroin Processing Training",25000],
        ["marijuana ga3",[gangarea3,gangarea3,gangarea3,gangarea3],"GA3 Marijuana Processing Training",10000],
        ["air",[licenseflag3,licenseflag5,university,pmclicenses],localize "STRS_license_air",1275000],
        ["pistollicense",[pmclicenses,licenseflag2,licenseflag2,licenseflag2],"Pistol License",40000],
        //["gunprobationpistol",[],"Probation Pistol License",5000],
        ["riflelicense",[pmclicenses,licenseflag2,licenseflag2,licenseflag2],"Rifle License",125000],
        ["automatic",[pmclicenses,licenseflag2,licenseflag2,licenseflag2],"Assault Weapon License",205000],
		["engineer",[pmclicenses,university,atmins,atm5],localize "STRS_license_engineer",65000],
        ["bomb",[airshop3,atmins,atm5,terrorshop],"Combat Training",3000000],
        ["probator",[copbank,copbank,copbank,copbank],localize "STRS_license_probator",10000],
        ["patrol_training",[copbank,copbank,copbank,copbank],localize "STRS_license_coppatrol",15000],
        ["response_training",[copbank,copbank,copbank,copbank],localize "STRS_license_copresponse",350000],
        ["sobr_training",[copbank,copbank,copbank,copbank],localize "STRS_license_copswat",3000000],
        ["air_support_training",[copbank,copbank,copbank,copbank],localize "STRS_license_copairsupport",1250000],
        ["passport_civilian",[licenseflag3,licenseflag3,licenseflag5,licenseflag5],"Takistani Passport",85000],
        ["pmc_license_journeyman",[pmclicenses,pmclicenses,licenseflag3,licenseflag3],"PMC Journeyman License",3000000],
        ["pmc_license_defense",[pmclicenses,pmclicenses,pmclicenses,pmclicenses],"PMC Defense License",5000000],
        ["pmc_license_air",[pmclicenses,pmclicenses,pmclicenses,pmclicenses],"PMC Pilot License",2500000],
		["soviet_vehicles",[atmins,atm5,airshop3,terrorshop],"Soviet Vehicle Training",5000000],
        ["soviet_air_veh",[atmins,atm5,airshop3,terrorshop],"Soviet Aircraft Training",3000000],
        ["paramedic_license",[tdoc,tdoc,tdoc,tdoc],"Paramedic Training",750000]
        //["assassin",[agunshop,agunshop,objnull],"Assassin Training",30000]
    ];

["INV_LicenseOwner", []] call stats_init_variable;