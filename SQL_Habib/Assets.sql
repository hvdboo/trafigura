set colsep '#';
SET TERMOUT OFF;
SPOOL &1;
set linesize 150;
set pagesize 2048;
select T1.M_LABEL as Asset, T1.M_DESC as Description, 
case when T2.M_LABEL is null then ' ' else T2.M_LABEL end as AssetType
from CM_ASSET_DBF T1, CM_ATYPE_DBF T2
where T1.M_TYPE = T2.M_REFERENCE (+)
order by T1.M_LABEL;
quit;
SPOOL OFF;