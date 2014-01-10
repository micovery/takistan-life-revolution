[alight, 1, 0] call setPitchBank;
[alight2, 1, 0] call setPitchBank;
[agunbox, 0, 3] call setPitchBank;

atv1 attachTo [atm1, [-0.7,0,0.7]];
atv2 attachTo [atm2, [-0.7,0,0.7]];
atv3 attachTo [atm3, [-0.7,0,0.7]];
atv4 attachTo [atm4, [-0.7,0,0.7]];
atv5 attachTo [atm5, [-0.7,0,0.7]];

atv1 setdir -90;
atv1 setpos getpos atv1;
atv2 setdir -90;
atv2 setpos getpos atv2;
atv3 setdir -90;
atv3 setpos getpos atv3;
atv4 setdir -90;
atv4 setpos getpos atv4;
atv5 setdir -90;
atv5 setpos getpos atv5;

anb1 attachTo [atm1, [-1.05,0.03,0.01]]; 
anb1 setVectorDirAndUp [[0, 0, 1],[-2, 0, 0]];
anb2 attachTo [atm2, [-1.05,0.03,0.01]]; 
anb2 setVectorDirAndUp [[0, 0, 1],[-2, 0, 0]];
anb3 attachTo [atm3, [-1.05,0.03,0.01]]; 
anb3 setVectorDirAndUp [[0, 0, 1],[-2, 0, 0]];

anb1 setpos getpos anb1;
anb2 setpos getpos anb2;
anb3 setpos getpos anb3;
