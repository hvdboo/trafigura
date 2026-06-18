set colsep '#';
SET TERMOUT OFF;
SPOOL &1;
set colsep '#';
set linesize 450;
set pagesize 2048;
select T1.M_IND_LAB as MortgageIndex, T1.M_IND_DESC as Description, 
case when (T1.M_CATEGORY=5) then 'Pool Factor' end as Category, 
T1.M_IND_CODE as Code, T2.M_GRP_DESC as ArchivingGroup, 
case when (T1.M_GEN_ESTIM=0) then 'Last known' 
when (T1.M_GEN_ESTIM=1) then 'Forward curve' 
when (T1.M_GEN_ESTIM=2) then 'CPR curve' 
when (T1.M_GEN_ESTIM=3) then 'PSA benchmark' 
end as Estimation, 
T1.M_FLEX as Flex, 
T1.M_CURRENCY as Currency, T1.M_GMP_GROUP as GMPGroup, 
case when (T1.M_INTRPL=0) then 'No' 
when (T1.M_INTRPL=1) then 'Linear' 
when (T1.M_INTRPL=2) then 'Backward Scale' 
when (T1.M_INTRPL=3) then 'Forward scale' 
end as Interpolation, 
case when (T1.M_FREQUENCY=0) then 'Monthly'
 when (T1.M_FREQUENCY=1) then 'Daily'
  end as Frequency,
T1.M_FIXANN as PublicationDate,
T1.M_F_SHIFTER as Shifter,
case when T3.M_SE_D_LABEL is null then ' ' else T3.M_SE_D_LABEL end as Security,
T1.M_RT_MKT as Market
-------
-------
from RT_INDEX_DBF T1, RT_GROUP_DBF T2, SE_HEAD_DBF T3 
-------
where T1.M_CATEGORY=5 
and T1.M_HISFILE=T2.M_HISFILE
and T1.M_RT_SELAB = T3.M_SE_LABEL (+)
order by T1.M_IND_LAB;
quit;
SPOOL OFF;