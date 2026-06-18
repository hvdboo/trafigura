set colsep '#';
SET TERMOUT OFF;
SPOOL &1;
set linesize 1539;
set pagesize 2048;
select T1.M_SE_D_LABEL as Label,T1.M_SE_GROUP as SecurityGroup, T1.M_SE_TYPE as SecurityType,
case when (T10.M_LN_RNG0 = 0)  or (T10.M_LN_RNG0 is null) then 'Unchecked'
         when (T10.M_LN_RNG0 = 1) then 'Checked'  end as IsRange,
case when (T10.M_LN_RNG0 = 1)  and  (T14.M_RNG_SCYN=0) then 'Daily'
         when (T10.M_LN_RNG0 = 1)  and (T14.M_RNG_SCYN=1) then 'Other' else ' ' end as RangeSchedType, 
case when (T10.M_LN_RNG0 = 1 and T14.M_RNG_SCYN=1) then T14.M_RNG_CAL else ' '  end as RangeCalendar,
case when (T10.M_LN_RNG0 = 1 and T14.M_RNG_SCYN=1) then T14.M_RNG_SCH else ' '  end as RangeSched,
case when (T10.M_LN_RNG0 = 1 and T14.M_RNG_SCYN=0 and T14.M_RNG_SCHED = 0) then 'Days'
	when (T10.M_LN_RNG0 = 1 and T14.M_RNG_SCYN=0 and T14.M_RNG_SCHED = 1) then 'Business days'
	else ' '  end as NumberOf,
case when (T10.M_LN_RNG0 = 1 and T14.M_PSHIFT_M = 0) then 'Off'
	when (T10.M_LN_RNG0 = 1 and T14.M_PSHIFT_M = 1) then 'Standard'
	when (T10.M_LN_RNG0 = 1 and T14.M_PSHIFT_M = 2) then 'Before adjustment'
	else ' ' end as PerDayShift,
case when (T10.M_LN_RNG0 = 1 and T14.M_PSHIFT_M in (1,2)) then T14.M_RNG_PSHI
	else ' ' end as PerDayShifter,
case when (T10.M_LN_RNG0 = 1 and T14.M_GSHIFT_M = 0) then 'Off'
	when (T10.M_LN_RNG0 = 1 and T14.M_GSHIFT_M = 1) then 'Standard'
	when (T10.M_LN_RNG0 = 1 and T14.M_GSHIFT_M = 2) then 'Keep same number of days'
	else ' ' end as GlobalShift,
case when (T10.M_LN_RNG0 = 1 and T14.M_GSHIFT_M in (1,2)) then T14.M_RNG_GSHI
	else ' ' end as GlobalShifter,
case when (T10.M_LN_RNG0 = 1)  and (T14.M_LCK_OUT =0) then 'No'
        when (T10.M_LN_RNG0 = 1)  and (T14.M_LCK_OUT =1)  then 'Yes'  else ' ' end as RangeLockout,
case when (T10.M_LN_RNG0 = 1 and T14.M_LCK_OUT =1) then T14.M_LCK_OUTS else ' ' end as RangeLockoutShifter,
case when (T10.M_LN_RNG0 = 1 and T14.M_LCK_OUT =1)  and (T14.M_LCK_OUT_M =0) then 'Crystallized'
         when (T10.M_LN_RNG0 = 1 and T14.M_LCK_OUT =1)  and (T14.M_LCK_OUT_M =1) then 'Skipped' else ' ' end as RgeLockoutMode,
case when (T10.M_LN_RNG0 = 1)  and (T14.M_RNG_APPLYT =0) then 'Coupon'
         when (T10.M_LN_RNG0 = 1)  and (T14.M_RNG_APPLYT =1) then 'Rate' else ' ' end as RangeApplyTo,
case   when (T10.M_LN_RNG0 = 0)  or T15.M_IND_LAB is null then ' ' else T15.M_IND_LAB end as RangeIndex,  
  case when (T10.M_LN_RNG0 = 0) or  T14.M_RNG_RFACT is null then ' '  else to_char(T14.M_RNG_RFACT) end as RangeFactor, 
  case when (T10.M_LN_RNG0 = 1)  and (T14.M_RNG_TYPE =0) then 'above(>)'
          when (T10.M_LN_RNG0 = 1)  and (T14.M_RNG_TYPE =1) then 'below(<)'
          when (T10.M_LN_RNG0 = 1)  and (T14.M_RNG_TYPE =2) then 'between (> and <)'
          when (T10.M_LN_RNG0 = 1)  and (T14.M_RNG_TYPE =3) then 'above (>=)'
          when (T10.M_LN_RNG0 = 1)  and (T14.M_RNG_TYPE =4) then 'below (<=)'
          when (T10.M_LN_RNG0 = 1)  and (T14.M_RNG_TYPE =5) then 'between (>= and <=)'
          when (T10.M_LN_RNG0 = 1)  and (T14.M_RNG_TYPE =6) then 'between (> and <=)'
          when (T10.M_LN_RNG0 = 1)  and (T14.M_RNG_TYPE =7) then 'between (>= and <)'
          when (T10.M_LN_RNG0 = 1)  and (T14.M_RNG_TYPE =8) then 'outside (< or >)'
          when (T10.M_LN_RNG0 = 1)  and (T14.M_RNG_TYPE =9) then 'outside (<= or >=)'
         when (T10.M_LN_RNG0 = 1)  and (T14.M_RNG_TYPE =10) then 'outside (< or >=)'
         when (T10.M_LN_RNG0 = 1)  and (T14.M_RNG_TYPE =11) then 'outside (<= or >)' else ' ' end as RangeType,
 case when (T10.M_LN_RNG0 = 0) or (T14.M_RNG_RATE0 is null) then ' ' else to_char(T14.M_RNG_RATE0) end as RangeRate1, 
 case when (T10.M_LN_RNG0 = 0)   or (T14.M_RNG_RATE1 is null) then ' ' else to_char(T14.M_RNG_RATE1) end as RangeRate2,
  case when (T10.M_LN_RNG0 = 1)  and (T14.M_RNG_FSTDAY =0) then 'Included'
          when (T10.M_LN_RNG0 = 1)  and (T14.M_RNG_FSTDAY =1) then 'Excluded' else ' ' end as RangeFirstDay,
case when (T10.M_LN_RNG0 = 1)  and (T14.M_RNG_LSTDAY =0) then 'Included'
          when (T10.M_LN_RNG0 = 1)  and (T14.M_RNG_LSTDAY =1) then 'Excluded' else ' ' end as RangeLastDay
-----
from  SE_ROOT_DBF T2,  BD_BOND_DBF T4 , SE_MKTOP_DBF T5,  SE_HEAD_DBF  T1,
 RT_LNSEC_DBF T10 , RNK_SRC_DBF T11, SE_SRNDR_DBF T12,
 RT_RANGE_DBF T14, RT_INDEX_DBF T15
-----
where T1.M_SE_LABEL = T2.M_SE_LABEL
and T4.M_BD_INUM  = T5.M_SE_INUM
and T1.M_SE_LABEL = T5.M_SE_LABEL 													
and (T4.M_BD_INUM = T10.M_NB and T10.M_LN_RNG0 = 1)
and T10.M_NB = T14.M_RNG_NB (+)
and T14.M_RNG_INDEX = T15.M_INDEX (+)
and T1.M_RANK_SRC = T11.M_REFERENCE (+)
and T2.M_SE_RND_R = T12.M_REFERENCE (+) 
and case when T10.M_IDENTITY is null then 0 else T10.M_IDENTITY end in
(select min(M_IDENTITY) from RT_LNSEC_DBF group by M_NB UNION select 0 from DUAL)
--- Filter to be amended with new additional features
order by T1.M_SE_D_LABEL;
quit;
SPOOL OFF;