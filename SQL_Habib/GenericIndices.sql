set colsep '#';
SET TERMOUT OFF;
SPOOL &1;
set linesize 250;
set pagesize 2048;
select T1.M_IND_LAB as GenericIndex, T1.M_IND_DESC as Description,
case when T1.M_INTRADAY=0 then 'No' when T1.M_INTRADAY=1 then 'Yes' end as Intraday,
case when T1.M_INTRPL=0 then 'No'
 when T1.M_INTRPL=1 then 'Linear'
 when T1.M_INTRPL=2 then 'Backward scale'
 when T1.M_INTRPL=3 then 'Forward scale'
 when T1.M_INTRPL=4 then 'Along bucket'
end as CurveInterpolation,
T2.M_GRP_DESC as ArchivingGroup, 
case 	when (T1.M_FLEX = 0 ) then 'UNCHECKED' when (T1.M_FLEX = 1) then 'CHECKED' end as Flex 
from RT_INDEX_DBF T1, RT_GROUP_DBF T2
where T1.M_HISFILE=T2.M_HISFILE 
and  T1.M_CATEGORY=6
order by T1.M_IND_LAB;
quit;
SPOOL OFF;