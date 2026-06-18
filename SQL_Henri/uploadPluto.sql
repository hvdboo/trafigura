drop table XTR_PLUTO;
create table XTR_PLUTO as select * from CSVREAD('M:\_Projects\CEDOil\Master file\workbench\Pluto\Instruments from Pluto.csv'); 