set colsep '#';
SET TERMOUT OFF;
SPOOL &1;
set linesize 650;
set pagesize 2048;
----- date filter used is 20081215 
select distinct T1.M_LABEL as PillarSets, T1.M_DESC as Description, 
case when (T4.M_LABEL is NULL) then ' ' else T4.M_LABEL end as OptionSet,
case when (T3.M_REFERENCE  <> T6.M_FMAT_ID) or T6.M_LABEL is null then ' ' else T3.M_LABEL end as FutureSets,
case when (T3.M_REFERENCE  <> T6.M_FMAT_ID) or T6.M_LABEL is null then ' ' else T6.M_LABEL end as Maturities,
case when (T3.M_REFERENCE  <> T6.M_FMAT_ID) or T6.M_LABEL is null then ' ' else to_char(T6.M_QT_START) end as QuotationStart,
case when (T3.M_REFERENCE  <> T6.M_FMAT_ID) or T6.M_LABEL is null then ' ' else to_char(T6.M_QT_END) end as QuotationEnd,
case when (T3.M_REFERENCE  <> T6.M_FMAT_ID) or T6.M_LABEL is null then ' ' else to_char(T6.M_ST_START) end as DeliveryStart,
case when (T3.M_REFERENCE  <> T6.M_FMAT_ID) or T6.M_LABEL is null then ' ' else to_char(T6.M_ST_END) end as DeliveryEnd,
case when (T3.M_REFERENCE  <> T6.M_FMAT_ID) or T6.M_LABEL is null then ' '
when (T5.M_PIL_MODE=1) then 'Along bucket'
when (T5.M_PIL_MODE=2) then 'On Pillar'
when (T5.M_PIL_MODE=3) then 'Along bucket +1d'
end as IndexGravity,
case when (T3.M_REFERENCE  <> T6.M_FMAT_ID) or T6.M_LABEL is null then ' '
when (T5.M_PIL_MODE2=1) then 'Finest'
when (T5.M_PIL_MODE2=2) then 'Bucket'
end as DeliveryMode2
-------------
from CM_PLST_DBF T1, CMG_CNFL_DBF T2, CM_FMAT_DBF T3, CMG_GRPP_DBF T5, CM_FMAT1_DBF T6
-----------
where T1.M_REFERENCE = T2.M_LIST  (+)
and T2.M_MS_FUT = T3.M_REFERENCE  (+)
and T1.M_REFERENCE = T5.M_PIL_SET (+)
and T5.M_MAT_CODE =T6.M_REFERENCE (+)
----------
and M__DATE_= '20081215'
order by PillarSets, FutureSets, Maturities;
quit;
SPOOL OFF;