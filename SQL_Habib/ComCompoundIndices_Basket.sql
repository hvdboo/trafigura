set colsep '#';
SET TERMOUT OFF;
SPOOL &1;
set linesize 1930;
set pagesize 2048;
select T1.M_IND_LAB as CommodityBasket,
T1.M_IND_DESC as Description, 
case when T9.M_LABEL is null then ' ' else T9.M_LABEL end as Asset,
T1.M_IND_CODE as Code, 
T2.M_GRP_DESC as ArchivingGroup, 
case when ((T1.M_RESET <> 0) and (T1.M_ESTIM_MODE=0)) then 'Current Index'
	 when ((T1.M_RESET <> 0) and (T1.M_ESTIM_MODE =1)) then 'Underlying Indices' 
	else ' ' 
end as EstimationMode, 
case when (T1.M_OFF_RESET = 0) then 'UNCHECKED' 
when (T1.M_OFF_RESET =1) then 'CHECKED' end as OfficialReset,
case when (T1.M_FLEX = 0 ) then 'UNCHECKED' when (T1.M_FLEX = 1) then 'CHECKED' end as Flex,
case when T1.M_BSK_MODE=0 then 'Weighted Average'
    when T1.M_BSK_MODE=1 then 'Sum'
	when T1.M_BSK_MODE=2 then 'Multiplication'
	when T1.M_BSK_MODE=3 then 'Max'
	when T1.M_BSK_MODE=4 then 'Min'
	when T1.M_BSK_MODE=5 then 'Ratio'
	when T1.M_BSK_MODE=6 then 'Inverse'
	when T1.M_BSK_MODE=7 then 'User Defined'
end as FormulaType,
case when T1.M_BSK_MODE=7 then T10.M_BUFFER else ' ' end as FormulaDetails,
case when T1.M_CRND_RULE = 0 then 'None'
	when T1.M_CRND_RULE = 1 then 'Nearest'
	when T1.M_CRND_RULE = 2 then 'By default'
	when T1.M_CRND_RULE = 3 then 'By excess'
end as RoundingRule,
case when T1.M_CRND_RULE <> 0  then to_char(T1.M_CRND_DEC) else ' ' end as RoundingRuleDecimals,
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
T1.M_CURRENCY as BasketCurrency,
case when T1.M_UNIT_TYPE0 =1 then T7.M_LABEL when T1.M_UNIT_TYPE0 =2 then 'UnitLess' else ' ' end as QuantityUnit,
case when T1.M_UNIT_TYPE1 =1 then T8.M_LABEL when T1.M_UNIT_TYPE1 =2 then 'UnitLess'  else ' ' end as QuotationUnit,
case when T1.M_AVG_UND = 1 then 'Yes' else 'No' end as AveragedComponents,
case when T1.M_AVG_UND = 0 then ' '
	when T1.M_MEAN_TYPE = 0 then 'Simple'
	when T1.M_MEAN_TYPE = 3 then 'Automatically weighted'
	when T1.M_MEAN_TYPE = 2 then 'Manually weighted'
	when T1.M_MEAN_TYPE = 1 then 'Built on weighting schedule'
	when T1.M_MEAN_TYPE = 4 then 'Sum'
	when T1.M_MEAN_TYPE = 5 then 'Min'
	when T1.M_MEAN_TYPE = 6 then 'Max'
end as MeanType,
case when T1.M_AVG_UND = 1 then T1.M_UEI else ' ' end as UnderlyingFixingSchedule,
case when T1.M_AVG_UND = 0 then ' '
	when T1.M_F_SHIFT=0 then 'No'
	when T1.M_F_SHIFT=1 then 'Yes'
end as ShiftFirstDate,
case when (T1.M_AVG_UND = 0  or T1.M_F_SHIFT = 0) then ' '
	when T1.M_L_SHIFT = 0 then 'First'
	when T1.M_L_SHIFT = 1 then 'Last'
end as ShiftDate1,
case when (T1.M_AVG_UND = 0  or T1.M_F_SHIFT = 0) then ' '
	else T1.M_F_SHIFTER
end as ShiftFirstDateShifter,
case when T1.M_AVG_UND = 0 then ' '
	when T1.M_U_LSHIFT=0 then 'No'
	when T1.M_U_LSHIFT=1 then 'Yes'
end as ShiftLastDate,
case when (T1.M_AVG_UND = 0  or T1.M_U_LSHIFT = 0) then ' '
	when T1.M_U_FSHIFT = 0 then 'Last'
	when T1.M_U_FSHIFT = 1 then 'First'
end as ShiftDate2,
case when (T1.M_AVG_UND = 0  or T1.M_U_LSHIFT = 0) then ' '
	else T1.M_L_SHIFTER
end as ShiftLastDateShifter,
case when T1.M_AVG_UND = 0 then ' '
	when T1.M_FIRST_EXCL = 0 then 'Included'
	when T1.M_FIRST_EXCL = 1 then 'Excluded'
end as FirstDate,
case when T1.M_AVG_UND = 0 then ' '
	when T1.M_LAST_EXCL = 0 then 'Included'
	when T1.M_LAST_EXCL = 1 then 'Excluded'
end as LastDate,
case when (T1.M_AVG_UND = 0 or T1.M_MEAN_TYPE <>1) then ' '
	else T1.M_UECF
end as WeightingSchedule,
case when (T1.M_AVG_UND = 1 and T1.M_BROKEN = 0) then 'Up front'
    when (T1.M_AVG_UND = 1 and T1.M_BROKEN = 1) then 'In arrears' else ' ' 
end as StubPeriod,
case when T1.M_AVG_UND = 0 then ' '
	when T1.M_LOK_PER = 1 then 'Yes'
	when T1.M_LOK_PER = 0 then 'No'
end as Lockoutperiod,
case when (T1.M_AVG_UND = 1 and T1.M_LOK_PER = 1) then T1.M_LOK_PER_SH 
    else ' ' 
end as LockoutPeriodShifter,
case when T1.M_AVG_UND = 0 then ' '
	when T1.M_EXCLUDE = 1 then 'Yes'
	when T1.M_EXCLUDE = 0 then 'No'
end as UndExcludeDates,
case when (T1.M_AVG_UND = 0 or T1.M_EXCLUDE = 0) then ' '
	when T1.M_EXCL_STYLE = 0 then 'InheritedFromUnderlying'
	when T1.M_EXCL_STYLE = 1 then 'Specific'
end as UndExcludeDatesStyle,
case when (T1.M_AVG_UND = 0 or T1.M_CONVERT = 0) then ' '
	when T1.M_CNV_APPL = 0 then 'Underlying'
	when T1.M_CNV_APPL = 1 then 'Mean'
end as ConversionApplication,
T1.M_EI as FixingSchedule,
T3.M_ORDER as ComponentOrder,
case when (T5.M_CATEGORY=8 and T5.M_RESET=6) then T5.M_IND_LAB 
when ( T5.M_CATEGORY<>8 or T5.M_RESET NOT IN (0,3,4,6)) then 'NewBskElem'
else ' ' end as BskElemNearbies,
case when (T5.M_CATEGORY=8 and T5.M_RESET=4) then T5.M_IND_LAB
when ( T5.M_CATEGORY<>8 or T5.M_RESET NOT IN (0,3,4,6)) then 'NewBskElem'
else ' ' end as BskElemComBskInd,
case when (T5.M_CATEGORY=8 and T5.M_RESET=0) then T5.M_IND_LAB
when ( T5.M_CATEGORY<>8 or T5.M_RESET NOT IN (0,3,4,6)) then 'NewBskElem'
else ' ' end as BskElemComSpotInd,
case when (T5.M_CATEGORY=8 and T5.M_RESET=3) then T5.M_IND_LAB
when ( T5.M_CATEGORY<>8 or T5.M_RESET NOT IN (0,3,4,6)) then 'NewBskElem'
else ' ' end as BskElemAvgInd,
-------
case
when T3.M_FORMULA = ' ' then 'Inherited' 
when T3.M_FORMULA like 'P%' then T6.M_LABEL
when T3.M_FORMULA not like 'P%' then T11.M_LABEL
end as Formula,
-------
T3.M_WEIGHT as Weight,
case when T3.M_REFERENCE_COMPONENT=1 then 'Reference' 
else 'Inherited'
end as Mode1, 
T3.M_CONVERSION as ConvFactor,
case when T3.M_EXCLUDE_DATES = '1' then 'Yes'  when T3.M_EXCLUDE_DATES = '0' then 'No' else ' ' end as ExcludeDates,
case when T1.M_CST_FLAG = 0 then 'Unchecked'
	when T1.M_CST_FLAG = 1 then 'Checked'
end as UseConstant,
case when T1.M_CST_FLAG = 0 then ' '
	when T1.M_CST_FLAG = 1 then to_char(T1.M_CST)
end as ConstantValue
-------
from  RT_GROUP_DBF T2, RT_INDEX_DBF T1
left outer join RT_INDBK_COMPONENT_DBF T3 on T3.M_BASKET_REFERENCE=T1.M_REFERENCE 
left outer join RT_INDEX_DBF T5 on T3.M_INDEX=T5.M_INDEX 
left outer join CM_MKTSR_DBF T6 on rtrim(TRIM(LEADING 'P' from T3.M_FORMULA))=to_char(T6.M_SERIE) 
left outer join CM_UNIT_DBF T7 on T1.M_UNIT_REF0 = T7.M_REFERENCE
left outer join CM_UNIT_DBF T8 on T1.M_UNIT_REF1 = T8.M_REFERENCE
left outer join CM_ASSET_DBF T9 on to_number ( case when T1.M_RT_SELAB = ' ' then '-1' else T1.M_RT_SELAB end) = T9.M_REFERENCE
left outer join FRM_FILE_DBF T10 on T1.M_IND_FORMID = T10.M_GROUP
left outer join CM_PROFH_DBF T11 on LTRIM(RTRIM(T3.M_FORMULA)) = to_char(T11.M_REFERENCE)
-------
where T1.M_RESET=4 
and T1.M_CATEGORY=8
and T1.M_HISFILE =T2.M_HISFILE
order by T1.M_IND_LAB,T3.M_ORDER;
quit;
SPOOL OFF;