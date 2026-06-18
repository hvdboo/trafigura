-- Pluto
create table xtr_pluto_dbf as



select * 
from csvread('M:\_Projects\CEDOil\Master file\workbench\Pluto\tblquotesmap.csv')

-- EAI
select * 
from csvread('M:\_Projects\CEDOil\Master file\workbench\Pluto\tblquotesmap.csv')


select * 
from csvread('M:\_Projects\CEDOil\Master file\repo\staticData\Analysis\ICE.csv') ice

select *  
from csvread('M:\_Projects\CEDOil\Master file\repo\staticData\Analysis\CCE_OilToMx.csv') mas

select * 
from csvread('M:\_Projects\CEDOil\Master file\repo\staticData\Analysis\Yamini.csv') yam

select 
rtrim(mas.MXINSLABEL) PLI,
rtrim(mas.PLUTO1) PLU,
coalesce(
(rpad(rtrim(mas.PLUTO2),10,' ')||'|'||rpad(rtrim(mas.PLUTO3),10,' ')||'|'||rpad(rtrim(mas.PLUTO4),10,' ')||'|'||rpad(rtrim(mas.PLUTO5),10,' ')),
(rpad(rtrim(mas.PLUTO2),10,' ')||'|'||rpad(rtrim(mas.PLUTO3),10,' ')||'|'||rpad(rtrim(mas.PLUTO4),10,' ')),
(rpad(rtrim(mas.PLUTO2),10,' ')||'|'||rpad(rtrim(mas.PLUTO3),10,' ')),
(rpad(rtrim(mas.PLUTO2),10,' ')) 
 )PLUSEQ
from csvread('M:\_Projects\CEDOil\Master file\repo\staticData\Analysis\CCE_OilToMx.csv') mas

where rtrim(mas.PLUTO1) is not null
order by PLI


