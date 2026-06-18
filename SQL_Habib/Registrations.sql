set colsep '#';
SET TERMOUT OFF;
SPOOL &1;
set linesize 2048;
set pagesize 2048;
select T1.M_LABEL as Registration,
case when T1.M__INTID_ = 'MmEvI39325' then 'Location'
	when T1.M__INTID_ = 'MPeMi57044' then 'CommoditySpotIndex'
end as RegistrtionCategory,
case when T1.M_DESC is null then ' ' else T1.M_DESC end as Description,
case when T2.M_LABEL is null then ' ' else T2.M_LABEL end as RegistrationType,
case when T3.M_LABEL is null then ' ' else T3.M_LABEL end as Publication,
T1.M_CODE as RegistrationCode
from CM_REG_DBF T1
left join CM_REGTYPE_DBF T2 on T1.M_TYPE = T2.M_REFERENCE
left join CM_MKT_DBF T3 on T1.M_PUBLICATION = T3.M_REFERENCE
order by 1;
quit;
SPOOL OFF;