liafu = true;

pmcgate1 setPosATL [(getPosATL pmcgate1 select 0),(getPosATL pmcgate1 select 1),-5];
pmcgate2 setPosATL [(getPosATL pmcgate2 select 0),(getPosATL pmcgate2 select 1),-5];
sleep 20;
pmcgate1 setPosATL [(getPosATL pmcgate1 select 0),(getPosATL pmcgate1 select 1),0];
pmcgate2 setPosATL [(getPosATL pmcgate2 select 0),(getPosATL pmcgate2 select 1),0];
