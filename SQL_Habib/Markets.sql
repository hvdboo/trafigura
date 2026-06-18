set colsep '#';
SET TERMOUT OFF;
SPOOL &1;
set linesize 150;
set pagesize 2048;
select T1.M_SE_MARKET as Market, T1.M_SE_CALEND as Calendar, 
case when T2.M_COUNTRY  is null  then ' '
else T2.M_COUNTRY 
end as Country, 
CAST(T1.M_SE_CUR AS VARCHAR2(9)) as Currency,T1.M_SE_ARCH as CutOffArchiving, T1.M_SE_ATYPE as CutOffArchivingType
from SE_MKT1_DBF T1, CR_CTRY_DBF T2
where T1.M_SE_CRY_REF = T2.M_REFERENCE (+)
order by T1.M_SE_MARKET;
quit;
SPOOL OFF;