set colsep '#';
SET TERMOUT OFF;
SPOOL &1;
set linesize 650;
set pagesize 2048;
select T1.M_IND_LAB as InflationIndex, T1.M_IND_DESC as Description,
case when (T1.M_CATEGORY=3) then 'Inflation' end as Category,
T1.M_IND_CODE as Code, T2.M_GRP_DESC as ArchivingGroup,
case when (T1.M_FLEX=0) then 'No'
when (T1.M_FLEX=0) then 'No'
end as Flex,
T1.M_CURRENCY as Currency,
case when (T1.M_INFLTYPE=0) then 'Growth Rate'
when (T1.M_INFLTYPE=1) then 'Inflation curve'
end as Type,
case when (T1.M_INFLTYPE=0) then to_char(T1.M_GROWTH) else ' ' end as AssumedGrowthRate,
case when (T1.M_REBASED=0) then 'No'
when (T1.M_REBASED=1) then 'Yes'
end as Rebased,
case when (T1.M_INTRPL=0) then 'No'
when (T1.M_INTRPL=1) then 'Yes' 
end as Interpolation, 
case when (T1.M_INTRPL=0) then ' '
	when (T1.M_INTPL_BN=1) then '30E'
when (T1.M_INTPL_BN=0) then 'ACT'
end as InterpolBasisNumerator,
case when (T1.M_INTRPL=0) then ' '
when (T1.M_INTPL_BD=0) then 'ACT'
when (T1.M_INTPL_BD=1) then '30' 
end as InterpolBasisDenominator,
case when (T1.M_ROUND_RUL =0) then 'None'
when (T1.M_ROUND_RUL=1) then 'Nearest'
when (T1.M_ROUND_RUL=2) then 'By Default'
when (T1.M_ROUND_RUL=3) then 'By Excess'
end as IndexRoundingRule ,
-------
T1.M_DECIMALS as IndexRndDecimals,T1.M_UECF as FixingShifter,
case when (T1.M_USERACV=0) then 'No'
when (T1.M_USERACV=1) then 'Yes'
end as UseRateConvention, 
-------
case when (T1.M_FREQUENCY=0) then 'Monthly'
when (T1.M_FREQUENCY=1) then 'Daily'
when (T1.M_FREQUENCY=2) then 'Quarterly up front'
when (T1.M_FREQUENCY=3) then 'Quarterly in arrears'
end as FixingFrequency,
CAST(T1.M_F_SHIFTER AS VARCHAR2(20)) as PublicationShifter,
-------
T1.M_FIXANN as AnniversaryDate,T1.M_RATE_CONV as RateConvention
-------
from RT_INDEX_DBF T1, RT_GROUP_DBF T2
-------
where T1.M_CATEGORY=3 
and T1.M_HISFILE=T2.M_HISFILE
order by T1.M_IND_LAB;
quit;
SPOOL OFF;