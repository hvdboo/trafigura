set colsep '#';
SET TERMOUT OFF;
SPOOL &1;
set linesize 150;
set pagesize 2048;
select	T1.M_COUNTRY as Country, 
case when (T2.M_AREA is null) then ' ' else T2.M_AREA end as Area,
T1.M_DESC as Description
from CR_CTRY_DBF T1
left outer join  CR_AREA_DBF T2 on T1.M_AREA=T2.M_REFERENCE
order by T1.M_COUNTRY;
quit;
SPOOL OFF;