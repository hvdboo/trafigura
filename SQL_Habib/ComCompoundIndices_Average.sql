set colsep '#';
SET TERMOUT OFF;
SPOOL &1;
set linesize 1200;
set pagesize 2048;
select T1.M_IND_LAB as CommodityAverageIndex, 
T1.M_IND_DESC as Description, 
case when T5.M_LABEL is null then ' ' else T5.M_LABEL end as Asset,
T1.M_IND_CODE as Code, 
T2.M_GRP_DESC as ArchivingGroup, 
case when (T1.M_RESET <> 0) and (T1.M_ESTIM_MODE=0) then 'Current Index'
	when (T1.M_RESET <> 0) and (T1.M_ESTIM_MODE =1) then 'Underlying Indices' 
	else ' ' 
end as EstimationMode, 
case when (T1.M_OFF_RESET = 0) then 'UNCHECKED' when (T1.M_OFF_RESET =1) then 'CHECKED' end as OfficialReset,
case when (T1.M_FLEX = 0 ) then 'UNCHECKED' when (T1.M_FLEX = 1) then 'CHECKED' end as Flex,
-------
case when T1.M_MEAN_TYPE = 0 then 'Simple'
	when T1.M_MEAN_TYPE = 3 then 'Automatically weighted'
	when T1.M_MEAN_TYPE = 2 then 'Manually weighted'
	when T1.M_MEAN_TYPE = 1 then 'Built on weighting schedule'
	when T1.M_MEAN_TYPE = 4 then 'Sum'
	when T1.M_MEAN_TYPE = 5 then 'Min'
	when T1.M_MEAN_TYPE = 6 then 'Max'
end as MeanType,
-------
case when T1.M_CRND_RULE = 0 then 'None'
	when T1.M_CRND_RULE = 1 then 'Nearest'
	when T1.M_CRND_RULE = 2 then 'ByDefault'
	when T1.M_CRND_RULE = 3 then 'ByExcess'
end as RoundingRule,
case when T1.M_CRND_RULE = 0 then ' ' else to_char(T1.M_CRND_DEC) end as RoundingRuleDec,
-------
case when T4.M_IND_LAB is null then ' ' else T4.M_IND_LAB end as UnderlyingIndex,
case when T1.M_UEI  is null then ' ' else T1.M_UEI end as UnderlyingFixingSchedule,
case 	when T1.M_F_SHIFT=0 then 'No'
	when T1.M_F_SHIFT=1 then 'Yes'
end as ShiftFirstDate,
case when (T1.M_F_SHIFT = 0) then ' '
	when T1.M_U_LSHIFT = 0 then 'First'
	when T1.M_U_LSHIFT = 1 then 'Last'
end as ShiftDate1,
case when (T1.M_F_SHIFT = 0) then ' '
	else T1.M_F_SHIFTER
end as ShiftFirstDateShifter,
case when T1.M_L_SHIFT=0 then 'No'
	when T1.M_L_SHIFT=1 then 'Yes'
end as ShiftLastDate,
case when (T1.M_L_SHIFT = 0) then ' '
	when T1.M_U_FSHIFT = 0 then 'Last'
	when T1.M_U_FSHIFT = 1 then 'First'
end as ShiftDate2,
case when (T1.M_L_SHIFT = 0) then ' '
	else T1.M_L_SHIFTER
end as ShiftLastDateShifter,
case when T1.M_FIRST_EXCL = 0 then 'Included'
	when T1.M_FIRST_EXCL = 1 then 'Excluded'
end as FirstDate,
case when T1.M_LAST_EXCL = 0 then 'Included'
	when T1.M_LAST_EXCL = 1 then 'Excluded'
end as LastDate,
case when ( T1.M_MEAN_TYPE <>1) then ' '
	else T1.M_UECF
end as WeightingSchedule,
case when (T1.M_BROKEN = 0) then 'Up front' when ( T1.M_BROKEN = 1) then 'In arrears' else ' ' end as StubPeriod,
-------
case when T1.M_CONVERT = 0 then 'No' when T1.M_CONVERT = 1 then 'Yes' end as RateConversion,
case when T1.M_CONVERT = 0 then ' ' else T1.M_CAP_FACT end as ConversionConvertFrom,
case when T1.M_CONVERT = 0 then ' ' else T1.M_IMP_RATE end as ConversionTo,
case when T1.M_CONVERT = 0 then ' ' else to_char(T1.M_CVRT_PER) end as ConversionNumberOfDays,
case when T1.M_CONVERT = 0 then ' '
	 when T1.M_RCRND_RL = 0 then 'None'
	when T1.M_RCRND_RL = 1 then 'Nearest'
	when T1.M_RCRND_RL = 2 then 'By default'
	when T1.M_RCRND_RL = 3 then 'By excess'
	when T1.M_RCRND_RL = 5 then 'Nearest 5th'
	when T1.M_RCRND_RL = 6 then 'By excess 5th'
	when T1.M_RCRND_RL = 7 then 'By default 5th'
end as ConversionRoundingRule,
case when (T1.M_CONVERT = 0 and T1.M_RCRND_RL = 0 ) then ' ' else to_char(T1.M_RC_DEC) end as ConvRoundingRuleDecimals,
-------
case when T1.M_LOK_PER = 1 then 'Yes'
	when T1.M_LOK_PER = 0 then 'No'
end as Lockoutperiod,
case when ( T1.M_LOK_PER = 1) then T1.M_LOK_PER_SH else ' ' end as LockoutPeriodShifter,
case when T1.M_EXCLUDE = 1 then 'Yes'
	when T1.M_EXCLUDE = 0 then 'No'
end as UndExcludeDates,
case when (T1.M_EXCLUDE = 0) then ' '
	when T1.M_EXCL_STYLE = 0 then 'InheritedFromUnderlying'
	when T1.M_EXCL_STYLE = 1 then 'Specific'
end as UndExcludeDatesStyle,
case when T1.M_CONVERT = 0 then ' '
	when T1.M_CNV_APPL = 0 then 'Underlying'
	when T1.M_CNV_APPL = 1 then 'Mean'
end as ConversionApplication
-------
from RT_GROUP_DBF T2 , RT_INDEX_DBF T1
left outer join RT_INDEX_DBF T4 on T1.M_UNDRL= T4.M_INDEX
left outer join CM_ASSET_DBF T5 on to_number ( case when T1.M_RT_SELAB = ' ' then '-1' else T1.M_RT_SELAB end) = T5.M_REFERENCE
where T1.M_CATEGORY=8 and T1.M_RESET=3
and T1.M_HISFILE=T2.M_HISFILE
and T1.M_CREAT_MODE=0
order by T1.M_IND_LAB;
quit;
SPOOL OFF;
