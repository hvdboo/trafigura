set colsep '#';
SET TERMOUT OFF;
SPOOL &1;
set linesize 650;
set pagesize 2048;
----- date filter used is 20081215 
select distinct T1.M_LABEL as PillarSets, T1.M_DESC as Description, 
case when T2.M__TYPE_ =1 then 'Future maturity set' when T2.M__TYPE_ =2 then 'Option maturity set' end as PillarType,
case when (T3.M_LABEL is NULL) then ' ' else T3.M_LABEL end as FutureSet,
case when (T2.M_BL_TYPE=-9) then 'All'
when (T2.M_BL_TYPE=0) then 'Fixed'
when (T2.M_BL_TYPE=-1) then 'Floating'
when (T2.M_BL_TYPE=1) then 'Day (D)'
when (T2.M_BL_TYPE=2) then 'Week (W)'
when (T2.M_BL_TYPE=3) then 'Month(M)'
end as BlockType,
case when (T2.M_WIN_TYPE=3) then 'All'
when (T2.M_WIN_TYPE=2) then 'Range'
when (T2.M_WIN_TYPE=1) then 'Single'
end as Window,
T2.M_WIN_START as WindowStart, T2.M_WIN_END as WindowEnd,
case when (T2.M_DATE_TYPE=2) then 'Quotation end'
when (T2.M_DATE_TYPE=4) then 'Delivery start'
when (T2.M_DATE_TYPE=8) then 'Delivery end'
when (T2.M_DATE_TYPE=12) then 'Quoted contract'
when (T2.M_DATE_TYPE=0) then 'Ignore all'
end as DecisionBasedOn,
case when (T2.M_PIL_MODE=1) then 'Along bucket'
when (T2.M_PIL_MODE=2) then 'On Pillar'
when (T2.M_PIL_MODE=3) then 'Along bucket + 1d'
end as PriceGravity,
case when (T2.M_PIL_MODE2=1) then 'Finest'
when (T2.M_PIL_MODE2=2) then 'Bucket'
end as DeliveryMode
from CM_PLST_DBF T1, CMG_CNFL_DBF T2, CM_FMAT_DBF T3, CM_OMAT_DBF T4, CMG_GRPP_DBF T5
-----------
where T1.M_REFERENCE = T2.M_LIST  (+)
and T2.M_MS_FUT = T3.M_REFERENCE  (+)
and T2.M_MS_OFUT  = T4.M_REFERENCE  (+)
and T1.M_REFERENCE = T5.M_PIL_SET (+)
----------
and M__DATE_= '20081215'
order by PillarSets;
quit;
SPOOL OFF;