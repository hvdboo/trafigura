set colsep '#';
SET TERMOUT OFF;
SPOOL &1;
set linesize 2600;
set pagesize 2048;
set feedback off;
alter session
SET NLS_LANGUAGE='ENGLISH';
set feedback on;
select  T1.M_INSTR as BondGenerator,T1.M_INSTR_DESC as Description,T1.M_NB_LEG as NbLegs,T1.M_NB_PHASE as NbPhases,
case when (T1.M_EVAL_MODE = 0) then 'Default'
when (T1.M_EVAL_MODE = 1) then 'MTM'
when (T1.M_EVAL_MODE = 2) then 'Accrual'
end as EvaluationMode,
case when (T2.M_RATE_TYPE0  = 0) then 'Fixed rate' 
when (T2.M_RATE_TYPE0= 1) then 'Floating rate' 
end as RateType,
case when (T2.M_RATE_TYPE0= 1) then T6.M_IND_LAB else ' ' end as FloatingIndex,
case when (T2.M_FINALTP0 = 0) then 'Currency'
when (T2.M_FINALTP0 = 1) then 'Commodity'
when (T2.M_FINALTP0 = 2) then 'Bond'
when (T2.M_FINALTP0 = 3) then 'Equity'
end as InstrumentType,
T2.M_CURRENCY0 as PaymentCurrency, CAST(T2.M_PAY_CLN0 AS VARCHAR2(15)) as PaymentCalendar,
case when (T2.M_RATE_TYPE0  = 0) then ' ' else CAST(T2.M_FIX_CLN0 AS VARCHAR2(15)) end as FixingCalendar,
case when ((T2.M_RATE_TYPE0= 1) and (T2.M_FIXING0 = 0 )) then 'In advance'
when ((T2.M_RATE_TYPE0= 1) and (T2.M_FIXING0 = 1 )) then 'In arrears'
else ' '  end  as Fixing,
case when (T2.M_PAYMENT0 = 0) then 'In arrears' when  (T2.M_PAYMENT0 = 1) then 'Up front'
when (T2.M_PAYMENT0 = 2) then 'Up front disc.'end as Payment ,
T2.M_RATE_CONV0 as RateConvention,
case when (T2.M_ROUND_RUL0 = 0) then 'None' when (T2.M_ROUND_RUL0 = 1) then 'Nearest' when (T2.M_ROUND_RUL0 = 2) then 'By default'
when (T2.M_ROUND_RUL0 = 3) then 'By excess' end as RoundingRule,
case when (T2.M_ROUND_RUL0 = 0) then 0 else T2.M_DECIMALS0 end as Decimals,
case when (T2.M_AMORT0 = 0 ) then 'None'
when (T2.M_AMORT0 = 1 ) then 'Linear (rate)'
when (T2.M_AMORT0 = 2 ) then 'Constant'
when (T2.M_AMORT0 = 3 ) then 'Constant annuities'
when (T2.M_AMORT0 = 4 ) then 'Constant number of shares'
when (T2.M_AMORT0 = 5) then 'Coupon reinvestment'
when (T2.M_AMORT0 = 6 ) then 'Constant annuities (r)'
when (T2.M_AMORT0 = 7 ) then 'Linear (amount)'
when (T2.M_AMORT0 = 8 ) then 'Dividends reinvestment (in new shares)'
end as Amortizing,
case when (T1.M_BROKEN =0 ) then 'Up front'
when (T1.M_BROKEN =1 ) then 'In arrears'
when (T1.M_BROKEN=3 ) then 'Both ends (backward)'
when (T1.M_BROKEN = 5) then 'Both ends (forward)'
end as StubPosition ,
case when (T2.M_RATE_TYPE0  = 1) and  (T1.M_BROKEN = 5)  then ' '
		 when  (T2.M_BROK_COUP0 =0 ) then 'Short coupon'   
		 when  (T2.M_BROK_COUP0 =1 ) then 'Long coupon' 
		 when  (T2.M_BROK_COUP0 =3 ) then 'Full coupon' 
		 when (T2.M_BROK_COUP0 = 4) then 'Conditional'  
end as Coupon ,
case when (T2.M_RATE_TYPE0  = 0) then ' ' 
		 when  (T2.M_BROK_IND0  =0 ) then 'Current index'  
		 when  (T2.M_BROK_IND0  = 1 ) then 'Closest index'  
		 when  (T2.M_BROK_IND0  = 2) then 'Next index'
		 when  (T2.M_BROK_IND0  = 3) then 'Previous index'  
		 when  (T2.M_BROK_IND0  = 4) then 'Interpolated' 
end as StubPeriodRate,
case when (T2.M_RATE_TYPE0  = 0) then ' ' 
	 when (T2.M_RATE_TYPE0  = 1) and  (T1.M_BROKEN <> 5 )  then ' '
	 when (T2.M_BROK_COUP1 =0 ) then 'Short coupon'   
	 when (T2.M_BROK_COUP1 =1 ) then 'Long coupon' 
	 when (T2.M_BROK_COUP1 =3 ) then 'Full coupon' 
	 when (T2.M_BROK_COUP1 = 4) then 'Conditional'  
end as CouponInArrears ,
case  when (T2.M_RATE_TYPE0  = 0) then ' ' 
      when (T2.M_RATE_TYPE0  = 1) and  ((T1.M_BROKEN =0) or (T1.M_BROKEN = 1) ) then ' '
      when  (T2.M_BROK_IND1  =0 ) then 'Current index'  
      when  (T2.M_BROK_IND1  = 1 ) then 'Closest index'  
     when  (T2.M_BROK_IND1  = 2) then 'Next index'
     when  (T2.M_BROK_IND1  = 3) then 'Previous index'  
     when  (T2.M_BROK_IND1  = 4) then 'Interpolated' 
end as StubRateInArrears,
case when (T2.M_CONVERT0 = 0 ) then  'No' when (T2.M_CONVERT0= 1) then 'Yes' end as RateConversion,
case when (T2.M_INDEXED0 = 0 ) then  'No' when (T2.M_INDEXED0 = 1) then 'Yes' end as Indexed,
case when (T2.M_GRNTEED0= 0 ) then  'No' when (T2.M_GRNTEED0 = 1) then 'Yes' end as Guaranteed,
case when (T2.M_ECP_TYPE0 = 0) then 'Driving schedule'
when (T2.M_ECP_TYPE0 = 1) then 'Equal to'
when  (T2.M_ECP_TYPE0 = 2) then 'Deduced from'
end as CalculationStartSchedule1,
case when (T2.M_ECP_TYPE0=0) then ' '
when (T2.M_ECP_UNDRL0 = -1) then ' '
when (T2.M_ECP_UNDRL0= 0) then 'Payment schedule'
when (T2.M_ECP_UNDRL0= 7) then 'Calculation end schedule'
when (T2.M_ECP_UNDRL0 = 8) then 'Delivery schedule'
end as CalculationStartSchedule2,
CAST(T2.M_ECP0 AS VARCHAR2(25)) as CalculationStartSchedule3,
case when (T2.M_ECPE_TYPE0 = 1) then 'Equal to'
when (T2.M_ECPE_TYPE0 = 2) then 'Deduced from'
end as CalculationEndSchedule1,
case when (T2.M_ECPE_UNDR0 = -1) then ' ' 
when (T2.M_ECPE_UNDR0 = 0) then 'Payment schedule'
when (T2.M_ECPE_UNDR0 = 1) then 'Calculation start schedule'
when (T2.M_ECPE_UNDR0 = 8) then 'Delivery schedule'
end as CalculationEndSchedule2, 
CAST(T2.M_ECPE0 AS VARCHAR2(25)) as CalculationEndSchedule3, 
case when (T2.M_EP_TYPE0 = 0) then 'Driving schedule' 
when (T2.M_EP_TYPE0 = 1) then 'Equal to'
when  (T2.M_EP_TYPE0 = 2) then 'Deduced from'
end as PaymentSchedule1,  
case when (T2.M_EP_UNDRL0 = -1) then ' '
when (T2.M_EP_TYPE0=0) then ' ' 
when (T2.M_EP_UNDRL0 = 1) then 'Calculation start schedule'
when (T2.M_EP_UNDRL0= 7) then 'Calculation end schedule'
when (T2.M_EP_UNDRL0 = 8) then 'Delivery schedule'
end as PaymentSchedule2,
CAST(T2.M_EP0 AS VARCHAR2(20)) as PaymentSchedule3,
T2.M_EP_FREQ0 as PaymentFrequency,
case when (T2.M_EI_TYPE0 = 0) then 'Driving schedule'
when (T2.M_EI_TYPE0 = 1) then 'Equal to'
when (T2.M_EI_TYPE0 = 2) then 'Deduced from'
end as FixingSchedule1,
case when ((T2.M_EI_UNDRL0 = -1) or (T2.M_EI_UNDRL0 = 0))  then ' '
when (T2.M_EI_TYPE0 =0) then ' '
when (T2.M_EI_UNDRL0= 1) then 'Calculation start schedule'
when (T2.M_EI_UNDRL0 = 7) then 'Calculation end schedule'
when (T2.M_EI_UNDRL0 = 0) then 'Payment schedule'
end as FixingSchedule2,
T2.M_EI0 as FixingSchedule3,
T2.M_EI_FREQ0 as FixingFrequency,
case when (T2.M_SIMP_SCH0 = 0) then 'No' else 'Yes' end as SinglePeriod,	
case when (T2.M_ACC_METH0 = 0 ) then 'Use interest convention'  
when (T2.M_ACC_METH0 = 1 ) then 'Specific convention'
when (T2.M_ACC_METH0 = 2 ) then 'External'  
when (T2.M_ACC_METH0 = 3 ) then 'Prorate interest'
end as AccrualMethod, 
CAST(T2.M_ACC_CONV0 AS VARCHAR2(20)) as AccrualConvention,
case when (T2.M_ACC_ROUND0 = 0) then 'None' 
when (T2.M_ACC_ROUND0 = 1) then 'Nearest' 
when (T2.M_ACC_ROUND0 = 2) then 'By default' 
when (T2.M_ACC_ROUND0 = 3) then 'By excess' 
end as AccrualRoundingRule,
case when (T2.M_ACC_ROUND0 = 0) then 'IRRELEVANT' else to_char(T2.M_ACC_DEC0) end as AccrualDecimals, 
case when (T2.M_ACC_RMODE0 =0 ) then 'Standard' 
when (T2.M_ACC_RMODE0 =1) then 'Ex-dividend' 
end as AccrualRoundingMode,
case when (T2.M_YLD_CALC0 = 0 ) then 'AIBD' 
when (T2.M_YLD_CALC0 = 1) then 'Specific convention'
when (T2.M_YLD_CALC0 = 2 ) then 'Moosmuller'
when (T2.M_YLD_CALC0 = 3 ) then 'Braess-Fangmeyer'
when (T2.M_YLD_CALC0 = 4) then 'Simple yield'
when (T2.M_YLD_CALC0 = 5 ) then 'Discount margin'
when (T2.M_YLD_CALC0 = 6) then 'Btp'
when (T2.M_YLD_CALC0 = 7) then 'Perpetual'
when (T2.M_YLD_CALC0 = 8) then 'Sobretasa'
when (T2.M_YLD_CALC0 = 9 ) then 'Stripped yield'
when (T2.M_YLD_CALC0 = 10) then 'Linear Sobretasa'
when (T2.M_YLD_CALC0 = 11) then 'CPI'
when (T2.M_YLD_CALC0 = 12) then 'LFT'
when (T2.M_YLD_CALC0 = 50) then 'External'
else ' '
end as YielCalculation, 
T2.M_YLD_CONV0 as YielConvention, 
case when (T2.M_YLD_SCHED0 = 0) then 'Anniversary schedule' 
when (T2.M_YLD_SCHED0 = 1) then 'Payment schedule' 
end as  YieldSchedule,
case when ( T2.M_YLD_FREQ0 = 0) then 'at coupon frequency (standard)' 
when ( T2.M_YLD_FREQ0 = 1) then 'Annual compounding'
end as YieldFrequency, 		
case when ( T2.M_GC_ACC0 = 0) then 'Standard' 
when ( T2.M_GC_ACC0 = 1) then 'Specific convention' 
end as GrossToCleanAccrual,
CAST(T2.M_GC_ACCCNV0 AS VARCHAR2(25)) as GrossToCleanConvention,
case when ( T2.M_ALT_YL0 = 0 ) then 'No' 
when ( T2.M_ALT_YL0 = 1) then 'During last period'
when ( T2.M_ALT_YL0 = 2 ) then 'During last year'
when ( T2.M_ALT_YL0 = 3 ) then 'During last period + ExDiv'
end as AlternateYield ,
CAST(T2.M_ALT_YLCNV0 AS VARCHAR2(25)) as AlternateYieldConvention,
case when (T2.M_FINAL_CAP0 =  1) then 'Yes' when (T2.M_FINAL_CAP0 = 2) then 'No' end as FinalCapitalExchange ,	
case when (T2.M_INTER_CAP0 = 1) then 'Yes' when (T2.M_INTER_CAP0 = 2) then 'No' end as IntermediateCapitalExchange,	
case when (T2.M_MRG_MODE0= 0) then 'Additive' else 'Multiplicative' end as MarginMode, 
case when (T2.M_RETINT0 = 0) then 'Return (P2-P1)/P1' when (T2.M_RETINT0 = 1) then 'Spread (P2-P1)' end as ReturnType,
case when (T20.M_TYPE is NULL) then ' '
when (T20.M_TYPE=0) then 'Interest flows'
when (T20.M_TYPE=1) then 'Fixings'
when (T20.M_TYPE=8) then 'Strikes'
when (T20.M_TYPE=2) then 'Margins'
when (T20.M_TYPE=3) then 'Interest rates'
when (T20.M_TYPE=4) then 'Initial capital'
when (T20.M_TYPE=5) then 'Intermediate capital'
when (T20.M_TYPE=6) then 'Final capital'
when (T20.M_TYPE=7) then 'Outstanding capital'
when (T20.M_TYPE=9) then 'Dividends'
when (T20.M_TYPE=10) then 'Tax Credit'
when (T20.M_TYPE=12) then 'Recovery nominal'
when (T20.M_TYPE=13) then 'Cap strikes'
end as IndexationListTypes,
case when (T4.M_RAT_TYPE is NULL) then ' ' 
when (T4.M_RAT_TYPE=0) then 'Floating'
when (T4.M_RAT_TYPE=1) then 'Fixed'
when (T4.M_RAT_TYPE=2) then 'Optional'
end as IndexationType,
case when (T4.M_IND_NAT is NULL) then ' ' 
when (T4.M_IND_NAT=0) then 'Rate'
when (T4.M_IND_NAT=1) then 'Equity price'
when (T4.M_IND_NAT=2) then 'Bond price'
when (T4.M_IND_NAT=3) then 'Inflation'
when (T4.M_IND_NAT=4) then 'FX Spot'
when (T4.M_IND_NAT=5) then 'Pool Factor'
when (T4.M_IND_NAT=6) then 'Generic Index'
when (T4.M_IND_NAT=7) then 'Formula'
when (T4.M_IND_NAT=8) then 'Commodity'
end as IndexationNature,
-------
case when (T4.M_INDX_NAT is NULL) then ' '
else to_char(T4.M_IND_NAT)
end as IndexNature,
-------
case when (T4.M_RETINRP is NULL) then ' '
when (T4.M_RETINRP=0) then 'Inflation'
when (T4.M_RETINRP=1) then 'Linear'
end as ReturnInterpolation,
-------
case when (T4.M_RSHIFT is NULL) then ' '
else T4.M_RSHIFT
end as ReturnFixingLag,
-------
case when (T5.M_IND_LAB is NULL) then ' ' else T5.M_IND_LAB end as IndexLabel,
case when (T4.M_I_FORMULA is NULL) then ' ' else to_char(T4.M_I_FORMULA) end as IndexFormula,
case when (T4.M_OPERAND is NULL) then ' ' 
when (T4.M_OPERAND=0) then 'Factor (xP)' 
when (T4.M_OPERAND=1) then 'Spread (+P)' 
when (T4.M_OPERAND=2) then 'Increase (x(1+P))' 
when (T4.M_OPERAND=3) then 'Replace (=P)' 
end as Operand,
-------
case when (T4.M_FORMULA is NULL) then ' ' 
when (T4.M_FORMULA=0) then 'Plain index (P) '
when (T4.M_FORMULA=1) then 'Period Return (P=(P2-P1)/P1)'
when (T4.M_FORMULA=2) then 'Period Ratio (P=P2/P1)'
when (T4.M_FORMULA=3) then 'Initial Return (P=(P2-P0)/P0)'
when (T4.M_FORMULA=4) then 'Initial ratio (P=P2/P0)'
when (T4.M_FORMULA=5) then 'Inverse (P=(1/P))'
else ' '
end as Formula,
-------
case when (T4.M_SCHED_TYPE is NULL) then ' ' 
when (T4.M_SCHED_TYPE=0) then 'Equal To'
when (T4.M_SCHED_TYPE=1) then 'Shifted from'
end as ScheduleType,
-------
case when (T4.M_OPTION is NULL) then ' ' 
when (T4.M_OPTION=0) then 'No'
when (T4.M_OPTION=1) then 'Max'
when (T4.M_OPTION=2) then 'Min'
end as IndexationOption,
-------
case when (T4.M_UND_SCHED is NULL) then ' ' 
when (T4.M_UND_SCHED=0) then 'Payment schedule'
when (T4.M_UND_SCHED=1) then 'Calculation schedule'
when (T4.M_UND_SCHED=2) then 'Reset schedule'
end as UnderlyingSchedule,
-------
case when (T4.M_FREQ is NULL) then ' ' else to_char(T4.M_FREQ) end as FrequencyRatio,
case when (T4.M_DATE_POS is NULL) then ' ' 
when (T4.M_DATE_POS=0) then 'Unchecked'
when (T4.M_DATE_POS=1) then 'Checked'
end as UpFront,
-------
case when (T4.M_FACTOR is NULL) then ' ' else to_char(T4.M_FACTOR) end as IndexationFactor,
case when (T4.M_P_FACTOR is NULL) then ' ' else to_char(T4.M_P_FACTOR) end as PriceFactor,
case when (T4.M_REPL is NULL) then ' ' 
when (T4.M_REPL=0) then 'Unchecked'
when (T4.M_REPL=1) then 'Checked'
end as Replacement,
-------
case when (T4.M_RND_RL0 is NULL) then ' ' 
when (T4.M_RND_RL0=0) then 'None'
when (T4.M_RND_RL0=1) then 'Nearest'
when (T4.M_RND_RL0=2) then 'By default'
when (T4.M_RND_RL0=3) then 'By excess'
end as IndexationRoundingRule,
-------
case when (T4.M_RND_RLD0 is NULL) then ' ' else to_char(T4.M_RND_RLD0) end as IndexationRoundingDecimals,
-------
case when (T4.M_RND_RL1 is NULL) then ' ' 
when (T4.M_RND_RL1=0) then 'None'
when (T4.M_RND_RL1=1) then 'Nearest'
when (T4.M_RND_RL1=2) then 'By default'
when (T4.M_RND_RL1=3) then 'By excess'
end as IndexationPostRoundingRule,
-------
case when (T4.M_RND_RLD1 is NULL) then ' ' else to_char(T4.M_RND_RLD1) end as IndexationPostRndDec,
case when (T4.M_P_MARGIN is NULL) then ' ' else to_char(T4.M_P_MARGIN) end as PriceMargin
-------
-------
from RT_INSGN_DBF T1, RT_LNGN_DBF T2
-------
left outer join RT_INDEX_DBF T3 on T2.M_INDEX0=T3.M_INDEX
left outer join RT_LNDXGL_DBF T20 left outer join RT_LNDXG_DBF T4 on T20.M_REF_INDEXATION_TEMPL=T4.M_REFERENCE on T2.M_REFERENCE=T20.M_REF_LOAN_GENERATOR
left outer join RT_INDEX_DBF T5 on T4.M_INDEX=T5.M_INDEX
left outer join RT_INDEX_DBF T6 on T2.M_INDEX0=T6.M_INDEX
 -------
where T1.M_GEN_NUM = T2.M_GEN_NUM
and  T1.M_INSTR_TYPE = 1
and T1.M_CREAT_MODE=0
and T1.M_INSTR like '%*%'
-------
order by M_INSTR;
quit;
