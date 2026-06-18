set colsep '#';
SET TERMOUT OFF;
SPOOL &1;
set linesize 1100;
set pagesize 2048;
select T1.M_INSTR as CapFloorGenerator, T1.M_INSTR_DESC as Description, T1.M_NB_PHASE as Phases ,T3.M_IND_LAB as IndexLabel, 
T2.M_CURRENCY0 as PaymentCurrency,T2.M_START0 as StartDelay, CAST(T2.M_PAY_CLN0 AS VARCHAR2(15)) as PaymentCalendar, CAST(T2.M_FIX_CLN0 AS VARCHAR2(15)) as Fixingcalendar,
-------
case when (T1.M_BROKEN =0 ) then 'Up front'
when (T1.M_BROKEN =1 ) then 'In arrears' 
when (T1.M_BROKEN=3 ) then 'Both ends (backward)'
when (T1.M_BROKEN = 5) then 'Both ends (forward)'
when (T1.M_BROKEN = 2) then 'None' 
end as StubPeriod ,
-------
case when (T2.M_BROK_COUP0 =0 ) then 'Short coupon'   
when (T2.M_BROK_COUP0 =1 ) then 'Long coupon' 
when (T2.M_BROK_COUP0 =3 ) then 'Full coupon' 
when (T2.M_BROK_COUP0 = 4) then 'Conditional' 
end as Coupon ,
-------
case when  (T2.M_BROK_IND0  =0 ) then 'Current index'  
when (T2.M_BROK_IND0  = 1 ) then 'Closest index'  
when (T2.M_BROK_IND0  = 2) then 'Next index'
when (T2.M_BROK_IND0  = 3) then 'Previous index'  
when (T2.M_BROK_IND0  = 4) then 'Interpolated' 
end as StubPeriodRate,
-------
case when T2.M_ECP_TYPE0=0 then 'DrivingSchedule'
when T2.M_ECP_TYPE0=1 then 'EqualTo'
when T2.M_ECP_TYPE0=2 then 'DeducedFrom'
end as CalculationStartSchedule,
-------
case when T2.M_ECP_UNDRL0=-1 then ' '
when T2.M_ECP_TYPE0=0 then ' '
when T2.M_ECP_UNDRL0=7 then 'CalculationEndSchedule'
when T2.M_ECP_UNDRL0=0 then 'PaymentSchedule'
when T2.M_ECP_UNDRL0=2 then 'FixingSchedule'
when T2.M_ECP_UNDRL0=4 then 'CapitalCalculationSchedule'
end as CalculationStartBis,
-------
CAST(T2.M_ECP0 AS VARCHAR2(20)) as ScheduleGenerator,
-------
case when T2.M_ECPE_TYPE0=0 then 'DrivingSchedule'
when T2.M_ECPE_TYPE0=1 then 'EqualTo'
when T2.M_ECPE_TYPE0=2 then 'DeducedFrom'
end as CalculationEndSchedule,
-------
case when T2.M_ECPE_UNDR0=1 then 'CalculationStartSchedule' 
when T2.M_ECPE_UNDR0=2 then 'Fixing Schedule'
when T2.M_ECPE_UNDR0=8 then 'CapitalCalculationSchedule'
when T2.M_ECPE_UNDR0=0 then 'Payment Schedule'
when T2.M_ECPE_UNDR0=-1 then ' '         
end as CalculationEndBis,
-------
CAST(T2.M_ECPE0 AS VARCHAR2(20)) as CalcEndDeduction,
-------
case when T2.M_EP_TYPE0=0 then 'DrivingSchedule'
when T2.M_EP_TYPE0=1 then 'EqualTo'
when T2.M_EP_TYPE0=2 then 'DeducedFrom'
end as PaymentSchedule,
-------
case when T2.M_EP_TYPE0=0 Then ' '
when T2.M_EP_UNDRL0=1 then 'CalculationStartSchedule' 
when T2.M_EP_UNDRL0=7 then 'CalculationEndSchedule' 
when T2.M_EP_UNDRL0=2 then 'Fixing Schedule' 
when T2.M_EP_UNDRL0=4 then 'CapitalCalculationSchedule'
when T2.M_EP_UNDRL0=-1 then ' '       
end as PaymentBis,
-------
T2.M_EP0 as PayDeduction,T2.M_EP_FREQ0 as PaymentFreq,
-------
case when T2.M_EI_TYPE0=0 then 'DrivingSchedule'
when T2.M_EI_TYPE0=1 then 'EqualTo'
when T2.M_EI_TYPE0=2 then 'DeducedFrom'
end as FixingSchedule,
-------
case when T2.M_EI_UNDRL0=1 then 'CalculationStartSchedule' 
when T2.M_EI_UNDRL0=7 then 'CalculationEndSchedule'
when T2.M_EI_UNDRL0=0 then 'Payment Schedule'
when T2.M_EI_UNDRL0=4 then 'CapitalCalculationSchedule'
when T2.M_EI_UNDRL0=-1 then ' '        
end as FixingBis,
-------
T2.M_EI0 as FixDeduction,T2.M_EI_FREQ0 as FixingFreq,
-------
CAST(T2.M_RATE_CONV0 AS VARCHAR2(20)) as MarginConvention, T2.M_CONVERT0 as MarginConversion,
T2.M_CAP_FACT0 as ConvertFrom, T2.M_IMP_RATE0 as ConvertTo, 
case when (T2.M_CVRT_PER0=-21) then 'Instrument total period'
when (T2.M_CVRT_PER0=-22) then 'Total interest period'
when (T2.M_CVRT_PER0=-20) then 'Interest calculation period'
end as ConversionPeriod, 
-------
case when (T2.M_RCRND_RL0=0) then 'None'
when (T2.M_RCRND_RL0=1) then 'Nearest'
when (T2.M_RCRND_RL0=2) then 'By default'
when (T2.M_RCRND_RL0=3) then 'By excess'
when (T2.M_RCRND_RL0=5) then 'Nearest 5th'
when (T2.M_RCRND_RL0=6) then 'By excess 5th'
when (T2.M_RCRND_RL0=7) then 'By default 5th'
end as ConversionRounding,
-------
T2.M_RC_DEC0 as ConvRoundingDecimals,
-------
case	when (T3.M_CATEGORY in ( 1,2, 3 ) or T2.M_LNGN_FLGS0 = 1026) then 
	case	when (T2.M_RETINT0 = 0) then 'Return (P2-P1)/P1'
		when (T2.M_RETINT0 = 1) then 'Spread (P2-P1)'
		when (T2.M_RETINT0 = 2) then 'Initial return (P2-P0)/P0'
		when (T2.M_RETINT0 = 3) then 'Initial spread (P2-P0)'
		when (T2.M_RETINT0 = 4) then 'Ratio P2/P1'
		when (T2.M_RETINT0 = 5) then 'Initial ratio P2/P0'
		when (T2.M_RETINT0 = 6) then 'Plain rate'
	end
else ' ' end as ReturnType,
case	when (T3.M_CATEGORY in ( 1,2, 3 ) or T2.M_LNGN_FLGS0 = 1026) then
	case	when (T2.M_PROTZ0 = 0) then 'Ignore'
when (T2.M_PROTZ0 = 1) then 'Apply'
	end
else ' ' end as ReturnDayCountFraction,
case	when (T3.M_CATEGORY in ( 1,2, 3 ) or T2.M_LNGN_FLGS0 = 1026) then T2.M_RSHIFT0 else ' ' end as ReturnFixingLag,
-------
case when (T2.M_ROUND_RUL0 = 0) then 'None' 
when (T2.M_ROUND_RUL0 = 1) then 'Nearest' 
when (T2.M_ROUND_RUL0 = 2) then 'By default' 
when (T2.M_ROUND_RUL0 = 3) then 'By excess' end as RoundingRule,
T2.M_DECIMALS0 as Decimals,
-------
case when T2.M_SIMP_SCH0=0 then 'No' 
when T2.M_SIMP_SCH0=1 then 'Yes' end as SinglePeriod , 	
case when (T2.M_INDEXED0 = 0 ) then  'No' when (T2.M_INDEXED0 = 1) then 'Yes' end as Indexed
-------
from RT_INSGN_DBF T1, RT_LNGN_DBF T2
-------
left outer join RT_INDEX_DBF  T3 on T2.M_INDEX0 = T3.M_INDEX
left outer join CM_PROFH_DBF T8 on T8.M_REFERENCE=T2.M_PROFILE0
left outer join RT_INDEX_DBF T9 on T2.M_INDEX1=T9.M_INDEX
-------
where T1.M_GEN_NUM = T2.M_GEN_NUM
and T1.M_CREAT_MODE=0 
and T1.M_INSTR_TYPE=2 
-------
order by T1.M_INSTR;
quit;
SPOOL OFF;

