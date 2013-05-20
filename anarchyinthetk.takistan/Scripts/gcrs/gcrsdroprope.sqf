// GeneralCarver Repel Script
// Drop Rope Script
// Version: v1, 8/3/09

deletevehicle gcrsrope1;
deletevehicle gcrsrope2;
deletevehicle gcrsrope3;
deletevehicle gcrsrope4;
deletevehicle gcrsrope5;
deletevehicle gcrsrope6;
deletevehicle gcrsrope7;
deletevehicle gcrsrope8;
deletevehicle gcrsrope9;
deletevehicle gcrsrope10;
deletevehicle gcrsrope11;
deletevehicle gcrsrope12;
deletevehicle gcrsrope13;
deletevehicle gcrsrope14;
deletevehicle gcrsrope15;
gcrsropedeployed = "false";
gcrsplayerveharray = [vehicle player];
gcrsrapelheloarray = gcrsrapelheloarray - gcrsplayerveharray;
publicvariable "gcrsrapelheloarray";
hint "Rapel Ropes Dropped";