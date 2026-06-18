set colsep '#';
SET TERMOUT OFF;
SPOOL &1;
set linesize 1200;
set pagesize 2048;
select  T1.M_INSTR as CallAccountGenerator,T1.M_INSTR_DESC as Description,
	case 	when (T2.M_RATE_TYPE0  = 0) then 'Fixed rate' when (T2.M_RATE_TYPE0= 1) then 'Floating rate' end as RateType,
	case when (T2.M_RATE_TYPE0= 1) then T3.M_IND_LAB else ' ' end as FloatingIndex,
T2.M_CURRENCY0 as PaymentCurrency, T2.M_START0 as StartDelay,
CAST(T2.M_PAY_CLN0 AS VARCHAR2(15)) as PaymentCalendar,
case when (T2.M_RATE_TYPE0= 1) then T2.M_FIX_CLN0 else ' ' end as FixingCalendar,
	case 	when (T2.M_ECP_TYPE0 = 0) then 'Driving schedule' 
		when (T2.M_ECP_TYPE0 = 1) then 'Equal to'
		when  (T2.M_ECP_TYPE0 = 2) then 'Deduced from'
	end as CalculationStartSchedule1, 
	case 	when (T2.M_ECP_UNDRL0 = -1) then ' ' 
		when (T2.M_ECP_UNDRL0= 0) then 'Payment schedule'
		when (T2.M_ECP_UNDRL0= 7) then 'Calculation end schedule'
		when (T2.M_ECP_UNDRL0 = 8) then 'Delivery schedule'
	end as CalculationStartSchedule2, 
	CAST(T2.M_ECP0 AS VARCHAR2(25)) as CalculationStartSchedule3,
	case 	when (T2.M_ECPE_TYPE0 = 1) then 'Equal to'
		when (T2.M_ECPE_TYPE0 = 2) then 'Deduced from'
	end as CalculationEndSchedule1, 
	case 	when (T2.M_ECPE_UNDR0 = -1) then ' ' 
		when (T2.M_ECPE_UNDR0 = 0) then 'Payment schedule'
		when (T2.M_ECPE_UNDR0 = 1) then 'Calculation start schedule'
		when (T2.M_ECPE_UNDR0 = 8) then 'Delivery schedule'
	end as CalculationEndSchedule2, 
	CAST(T2.M_ECPE0 AS VARCHAR2(25)) as CalculationEndSchedule3, 
	case 	when (T2.M_EP_TYPE0 = 0) then 'Driving schedule' 
		when (T2.M_EP_TYPE0 = 1) then 'Equal to'
		when  (T2.M_EP_TYPE0 = 2) then 'Deduced from'
	end as PaymentSchedule1, 
	case 	when (T2.M_EP_UNDRL0 = -1) then ' ' 
		when (T2.M_EP_UNDRL0 = 1) then 'Calculation start schedule'
		when (T2.M_EP_UNDRL0= 7) then 'Calculation end schedule'
		when (T2.M_EP_UNDRL0 = 8) then 'Delivery schedule'
	end as PaymentSchedule2,
	CAST(T2.M_EP0 AS VARCHAR2(20)) as PaymentSchedule3,
case when (T2.M_EP_FREQ0=-1) then 'Zero coupon'
when (T2.M_EP_FREQ0=-2) then 'Formula adjusted'
else to_char(T2.M_EP_FREQ0) end as PaymentFrequency,
--------
	case when (T2.M_RATE_TYPE0= 1) then (case when (T2.M_EI_TYPE0 = 0) then 'Driving schedule'
 when (T2.M_EI_TYPE0 = 1) then 'Equal to'
 when (T2.M_EI_TYPE0 = 2) then 'Deduced from' end)
else ' '
end as FixingSchedule1,
case when (T2.M_RATE_TYPE0= 1) then (case when ((T2.M_EI_UNDRL0 = -1) or (T2.M_EI_UNDRL0 = 0))  then ' '
 when (T2.M_EI_UNDRL0= 1) then 'Calculation start schedule'
 when (T2.M_EI_UNDRL0 = 7) then 'Calculation end schedule'
 when (T2.M_EI_UNDRL0 = 0) then 'Payment schedule'end)
else ' '
end as FixingSchedule2,
case when (T2.M_RATE_TYPE0= 1) then T2.M_EI0 else ' ' end as FixingSchedule3,
case when (T2.M_RATE_TYPE0= 1) then to_char(T2.M_EI_FREQ0) else ' ' end as FixingFrequency,
-------
case when (T2.M_SIMP_SCH0 = 0) then 'No'
 when (T2.M_SIMP_SCH0 = 1) then 'Yes'
end as SinglePeriod,
-------
case when (M_MRG_CMP0=0) then '(I+M) at (I+M)'
 when (M_MRG_CMP0=1) then '(I+M) at I'
 when (M_MRG_CMP0=2) then '(I at I) + M'
 when (M_MRG_CMP0=3) then 'I at (I+M)'			
 when (M_MRG_CMP0=4) then 'I at (I+M) + M'
 when (M_MRG_CMP0=5) then 'No compunding'
 when (M_MRG_CMP0=6) then '(I+M1) at (I+M2)'
 when (M_MRG_CMP0=8) then '(I+M) at C'
end as Compounding,
-------
case when (T2.M_RATE_TYPE0= 0) then (case when (T2.M_PAYMENT0=0) then 'In arrears'
 when (T2.M_PAYMENT0=1) then 'Up front'
 when (T2.M_PAYMENT0=2) then 'Up front disc.' end)
 else ' '
end as Payment,
	T2.M_RATE_CONV0 as RateConvention,
case when (T1.M_ACC_MOD=0) then '+1 open day'
 when (T1.M_ACC_MOD=1) then 'Redefined'
end as AccrualDelayMode,
-------
case when (T1.M_ACC_MOD=1) then T1.M_ACC else ' '
end as AccrualDelay,
-------
case when (T1.M_FLP_MOD=1) then 'Redefined'
 when (T1.M_FLP_MOD=0) then '+1 open day'
 else ' '
end as FlowsProjectionDelay,
case when (T1.M_FLP_MOD=1) then T1.M_FLP else ' '
end as FlowsProjectionShifter,
case when (T1.M_SETTL_MOD=1) then 'Specific delay'
 when (T1.M_SETTL_MOD=0) then 'Inherited from currency' else ' '
end as MarketOpDelay,
case when (T1.M_SETTL_MOD=1) then T1.M_SETTL else ' '
end as MarketOpShifter,
-------
case when (T2.M_ACC_METH0 = 0 ) then 'cf interest'
 when (T2.M_ACC_METH0 = 1 ) then 'Specific convention'
else ' '
end as AccrualMethod, 
-------
case when (T2.M_ACC_METH0 = 1 ) then T2.M_ACC_CONV0
else ' '
end as AccrualMethodConvention,
-------
case when (T2.M_ACC_ROUND0 = 0) then 'None' 
		when (T2.M_ACC_ROUND0 = 1) then 'Nearest' 
		when (T2.M_ACC_ROUND0 = 2) then 'By default' 
		when (T2.M_ACC_ROUND0 = 3) then 'By excess' 
	end as AccrualRoundingRule,
	T2.M_ACC_DEC0 as AccrualDecimals,
-------
case when (T2.M_ROUND_RUL0=0) then 'None'
		when (T2.M_ROUND_RUL0=1) then 'Nearest'
		when (T2.M_ROUND_RUL0=4) then 'Currency'
		when (T2.M_ROUND_RUL0=2) then 'By default'
		when (T2.M_ROUND_RUL0=3) then 'By excess'
		end as InterestFlowRounding,
	T2.M_DECIMALS0 as Decimals,
case when (T2.M_AMORT0=0) then 'None'
		when (T2.M_AMORT0=9) then 'Real coupon reinvestment'
		end as Amortizing
from RT_INSGN_DBF T1, RT_LNGN_DBF T2
left join RT_INDEX_DBF T3 on T2.M_INDEX0 = T3.M_INDEX
where	T1.M_GEN_NUM = T2.M_GEN_NUM
and T1.M_INSTR_TYPE = 8
and	T1.M_CREAT_MODE = 0
order by T1.M_INSTR;
quit;
SPOOL OFF;