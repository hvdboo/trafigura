set colsep '#';
SET TERMOUT OFF;
SPOOL &1;
set linesize 1539;
set pagesize 2048;
select T1.M_KEY as AliasKey,
T1.M_LABEL as ObjectLabel,
T1.M_ALIAS as Alias, 
case when T1.M_ALIASTYPE = 0 then 'LOCAL' when T1.M_ALIASTYPE = 1 then 'GLOBAL' end as AliasType
from FX_ALIAS_DBF T1
order by 1,2,3;
quit;
SPOOL OFF;