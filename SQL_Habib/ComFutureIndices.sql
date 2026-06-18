set colsep '#';
SET TERMOUT OFF;
SPOOL &1;
set linesize 800;
set pagesize 2048;
select T1.M_IND_LAB as IndexLabel, T1.M_IND_DESC as Description,
case when T7.M_LABEL is null then ' ' else T7.M_LABEL end as Asset, T1.M_IND_CODE as Code,
case 	when (T1.M_FLEX = 0 ) then 'UNCHECKED' when (T1.M_FLEX = 1) then 'CHECKED' end as Flex ,
case when T2.M_LABEL is null then ' ' else T2.M_LABEL end as UnderlyingFutureForPrice,  
case when T8.M_LABEL is null then ' ' else T8.M_LABEL end as Maturity,
case when T3.M_LABEL is null then ' ' else T3.M_LABEL end as IndexQuotation
-------
from RT_INDEX_DBF T1, CM_FUT_DBF T2, CMC_QUOT_DBF T3,  CM_ASSET_DBF T7, CM_FMAT1_DBF T8
where T1.M_CATEGORY=9 
and  T1.M_COM_FUT = T2.M_REFERENCE (+)
and  T1.M_COM_QUOT = T3.M_REFERENCE (+)
and T1.M_COM_MAT = T8.M_REFERENCE (+)
and to_number(T1.M_RT_SELAB) = T7.M_REFERENCE (+)
order by T1.M_IND_LAB;
quit;
SPOOL OFF;