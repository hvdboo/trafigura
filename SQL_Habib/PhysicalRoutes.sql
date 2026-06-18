set colsep '#';
SET TERMOUT OFF;
SPOOL &1;
set linesize 320;
set pagesize 2048;
-------
select T1.M_LABEL as PhysicalRoute, T1.M_DESC as Description,
T1.M_TYPE as Type,
T2.M_LABEL as OrigAccount,
T3.M_LABEL as BenefAccount,
T4.M_LABEL as Unit,
T1.M_GRANULAR as Granularity
-------
from ROUTE_PHYS_DBF T1, ACT_PHYS_DBF T2, ACT_PHYS_DBF T3, CM_UNIT_DBF T4
where T1.M_ORIG_ACC = T2.M_REFERENCE (+)
and T1.M_BENEF_ACC = T3.M_REFERENCE (+)
and T1.M_UNIT = T4.M_REFERENCE (+)
order by T1.M_LABEL;
quit;
SPOOL OFF;
