set colsep '#';
SET TERMOUT OFF;
SPOOL &1;
set linesize 2850;
set pagesize 2048;
select 	T1.M_INSTR as FRAGenerator,T1.M_INSTR_DESC as Desciption,T1.M_NB_PHASE as NumberPhases,T1.M_NB_LEG as NumberLegs,
case when (T2.M_AMORT0 = 0) then 'None' 
when (T2.M_AMORT0 = 1) then 'Linear (rate)'
when (T2.M_AMORT0 = 2) then 'Constant'
when (T2.M_AMORT0 = 3) then 'Constant annuities'
when (T2.M_AMORT0 = 4) then 'Constant number of shares'
when (T2.M_AMORT0 = 5) then 'Coupon reinvestment'
when (T2.M_AMORT0 = 6) then 'Constant annuities (r)'
when (T2.M_AMORT0 = 7) then 'Linear (amount)'
when (T2.M_AMORT0 = 8) then 'Dividends reinvestment (in new shares)'
end as DefaultAmortizing,
case when (T1.M_BUY_SIGN=0 ) then 'Pay fixed'
when (T1.M_BUY_SIGN=1) then 'Receive fixed'
end as BuySign,
case when (T1.M_FLAGS =1 ) then 'Common set across legs' 
when (T1.M_FLAGS =2 ) or (T1.M_FLAGS =0 ) then 'Independent sets across legs' 
when (T1.M_FLAGS =4 ) then 'Common set, different freq.' end as Schedules,
case when ((T1.M_FLAGS =2 ) or (T1.M_FLAGS =0 )) and (T1.M_LEG_AMORT =0) then 'Common definition across legs'
when ((T1.M_FLAGS =2 ) or (T1.M_FLAGS =0 )) and (T1.M_LEG_AMORT =1) then 'Independent definition across legs'
else ' ' end as LegAmortizing, 
case when (T1.M_BROKEN = 0) then 'Up front' 
when (T1.M_BROKEN = 1) then 'In arrears'
when (T1.M_BROKEN = 3) then 'Both ends (Backward)'
when (T1.M_BROKEN = 5) then 'Both ends (Forward)'
end as StubPeriod,
case when (T1.M_EVAL_MODE = 0) then 'Default'
when (T1.M_EVAL_MODE = 1) then 'MTM'
when (T1.M_EVAL_MODE = 2) then 'Accrual'
end as EvaluationMode,
case when (T2.M_SETTLE0=0 ) then 'Cash settled'
when (T2.M_SETTLE0=1) then 'Physical Delivery' end as Exercise,
-------
case when (T2.M_INIT_CAP0 = 1 ) then 'CHECKED' else 'UNCHECKED' end as InitialCapital,
case when (T2.M_INTER_CAP0 = 1 ) then 'CHECKED' else 'UNCHECKED' end as IntermediateCapital,
case when (T2.M_FINAL_CAP0 = 1 ) then 'CHECKED' else 'UNCHECKED' end as FinalCapital,
case when (T1.M_RAT_DISP= 1) then 'Fixed-Floating'
when (T1.M_RAT_DISP= 2) then 'Fixed-Fixed'
when (T1.M_RAT_DISP= 4) then 'Floating-Floating'
end as Type,
case when (T1.M_SETTL_MOD= 0) then 'Inherited from currency' else 'Specific delay' end as SettlementMode,
CAST(T1.M_SETTL AS VARCHAR2(20)) as SettlementShifter,
case when (T3.M_IND_LAB is null ) then ' ' else T3.M_IND_LAB end as IndexLeg1, 
case when (T8.M_LABEL is NULL) then ' ' else T8.M_LABEL end as VolumeProfile,
case when (T2.M_FINALTP0 = 0) then 'Currency' 
when (T2.M_FINALTP0 = 1) then 'Commodity'
when (T2.M_FINALTP0 = 2) then 'Bond'
when (T2.M_FINALTP0 = 3) then 'Equity' 
end as InstrumentTypeLeg1,
T2.M_CURRENCY0 as CurrencyLeg1,CAST(T2.M_EXT_FREQ0 AS VARCHAR2(15)) as FrequencyLeg1,
case when (M_RAT_DISP =1 and (M_FLAGS=1 or M_FLAGS=4 )) then T2.M_START1 else T2.M_START0 end as StartDelayLeg1,
case when (M_RAT_DISP =1 and (M_FLAGS=1 or M_FLAGS=4 )) then CAST(T2.M_PAY_CLN1 AS VARCHAR2(20)) else CAST(T2.M_PAY_CLN0 AS VARCHAR2(20)) end as PaymentCalendarLeg1,
case when (M_RAT_DISP =1 and (M_FLAGS=1 or M_FLAGS=4 )) then CAST(T2.M_FIX_CLN1 AS VARCHAR2(20)) else CAST(T2.M_FIX_CLN0 AS VARCHAR2(20)) end as FixingCalendarLeg1,
case when (T2.M_FIXING0=0) then 'In advance'  when (T2.M_FIXING0=1) then 'In arrears' end as FixingLeg1 ,
case when (T2.M_PAYMENT0 = 0 ) then 'In arrears' 
when (T2.M_PAYMENT0 = 1 ) then 'Up front'
when (T2.M_PAYMENT0 = 2 ) then 'Up front disc.' end as PaymentLeg1,
case when ((T2.M_PAYMENT0 = 2) and (M_DISC_RATE0 = 0)) then 'Floating rate'
		when (T2.M_PAYMENT0 = 2 and M_DISC_RATE0 =1) then 'Fixed rate'
		when (T2.M_PAYMENT0 = 2 and M_DISC_RATE0 =2) then 'specific index'
		when (T2.M_PAYMENT0 = 2 and M_DISC_RATE0 =3) then 'Current leg'
		when (T2.M_PAYMENT0 = 2 and M_DISC_RATE0 =4) then 'Specific leg'
		when (T2.M_PAYMENT0 = 2 and M_DISC_RATE0 =5) then 'Fixing' else ' ' end as DiscountingRateLeg1,
case when (T2.M_PAYMENT0 = 2 and M_DISC_RATE0 =2) then M_DISC_IND0 else ' ' end as DiscountingIndex1,
case when (T2.M_PAYMENT0 = 2 and M_DISC_RATE0 =4) then M_DISC_LEG0 else null end as DiscountingLeg1,
CAST(T2.M_RATE_CONV0 AS VARCHAR2(20)) as RateConventionLeg1,
case when (T2.M_CONVERT0= 0 ) then 'UNCHECKED' when (T2.M_CONVERT0= 1 ) then 'CHECKED' end as RateConversionLeg1,
case when (T2.M_INDEXED0 = 0 ) then 'UNCHECKED' when (T2.M_INDEXED0 = 1 ) then 'CHECKED' end as IndexedLeg1,
case when  (T2.M_ROUND_RUL0 =0 ) then 'None' 
when  (T2.M_ROUND_RUL0 =1) then 'Nearest'  
when (T2.M_ROUND_RUL0 =2)  then 'By default' 
when (T2.M_ROUND_RUL0 =3 ) then 'By excess' 
when (T2.M_ROUND_RUL0 =4) then 'Currency' end as RoundingRuleLeg1,
T2.M_DECIMALS0 as DecimalsLeg1,
case when (T2.M_MRG_MODE0= 0) then 'Additive' else 'Multiplicative' end as MarginModeLeg1,
case when (T2.M_BROK_COUP0= 0) then 'Short Coupon'
when (T2.M_BROK_COUP0= 1) then 'Long Coupon'
when (T2.M_BROK_COUP0= 3) then 'Full Coupon'
when (T2.M_BROK_COUP0= 4) then 'Conditional'
end as CouponLeg1,
case when (T2.M_BROK_IND0=0) then 'Current Index'
when (T2.M_BROK_IND0=1) then 'Closest Index'
when (T2.M_BROK_IND0=2) then 'Next Index'
when (T2.M_BROK_IND0=3) then 'Previous Index'
when (T2.M_BROK_IND0=4) then 'Interpolated'
end  as StubPeriodRateLeg1,
CAST(T2.M_BROK_COND0 AS VARCHAR2(20)) as StubConditionLeg1,
case when (M_RAT_DISP =1 and (M_FLAGS=1 or M_FLAGS=4 )) then ' '
when (M_RAT_DISP =1 and (M_FLAGS=0 or M_FLAGS=2 )) and (T2.M_ECP_TYPE1 = 0) then 'Driving schedule'
when (M_RAT_DISP =1 and (M_FLAGS=0 or M_FLAGS=2 )) and (T2.M_ECP_TYPE1 = 1) then 'Equal to'
when (M_RAT_DISP =1 and (M_FLAGS=0 or M_FLAGS=2 )) and (T2.M_ECP_TYPE1 = 2) then 'Deduced from'
when ( M_RAT_DISP <>1 or (M_FLAGS<>1 and M_FLAGS<>4 )) and (T2.M_ECP_TYPE0 = 0) then 'Driving schedule'
when ( M_RAT_DISP <>1 or (M_FLAGS<>1 and M_FLAGS<>4 )) and (T2.M_ECP_TYPE0 = 1) then 'Equal to'
when ( M_RAT_DISP <>1 or (M_FLAGS<>1 and M_FLAGS<>4 )) and (T2.M_ECP_TYPE0 = 2) then 'Deduced from'
end as CalcStartSched1Leg1,
case when (M_RAT_DISP =1 and (M_FLAGS=1 or M_FLAGS=4 )) then ' '	
when (M_RAT_DISP =1 and (M_FLAGS=0 or M_FLAGS=2 )) and (T2.M_ECP_UNDRL1  = -1) then ' '
when (M_RAT_DISP =1 and (M_FLAGS=0 or M_FLAGS=2 )) and (T2.M_ECP_UNDRL1 = 0) then 'Payment schedule' 
when (M_RAT_DISP =1 and (M_FLAGS=0 or M_FLAGS=2 )) and (T2.M_ECP_UNDRL1 = 2) then 'Fixing schedule'
when (M_RAT_DISP =1 and (M_FLAGS=0 or M_FLAGS=2 )) and (T2.M_ECP_UNDRL1 = 7) then 'Calculation end schedule'
when (M_RAT_DISP =1 and (M_FLAGS=0 or M_FLAGS=2 )) and (T2.M_ECP_UNDRL1 = 8) then 'Delivery schedule'
when ( M_RAT_DISP <>1 or (M_FLAGS<>1 and M_FLAGS<>4 )) and (T2.M_ECP_UNDRL0 = -1) then ' '
when ( M_RAT_DISP <>1 or (M_FLAGS<>1 and M_FLAGS<>4 )) and (T2.M_ECP_UNDRL0 = 0) then 'Payment schedule'
when ( M_RAT_DISP <>1 or (M_FLAGS<>1 and M_FLAGS<>4 )) and (T2.M_ECP_UNDRL0 = 2) then 'Fixing schedule'
when ( M_RAT_DISP <>1 or (M_FLAGS<>1 and M_FLAGS<>4 )) and (T2.M_ECP_UNDRL0= 7) then 'Calculation end schedule'
when ( M_RAT_DISP <>1 or (M_FLAGS<>1 and M_FLAGS<>4 )) and (T2.M_ECP_UNDRL0 = 8) then 'Delivery schedule'
end as CalcStart2Leg1,
case when (M_RAT_DISP =1 and (M_FLAGS=1 or M_FLAGS=4 ))  then T2.M_ECP1 else T2.M_ECP0 end as CalcStart3Leg1,
case when (M_RAT_DISP =1 and (M_FLAGS=1 or M_FLAGS=4 )) then ' ' 
when (M_RAT_DISP =1 and (M_FLAGS=0 or M_FLAGS=2 )) and (T2.M_ECPE_TYPE1 = 0) then 'Driving schedule'
when (M_RAT_DISP =1 and (M_FLAGS=0 or M_FLAGS=2 )) and (T2.M_ECPE_TYPE1= 1) then 'Equal to'
when (M_RAT_DISP =1 and (M_FLAGS=0 or M_FLAGS=2 )) and (T2.M_ECPE_TYPE1 = 2) then 'Deduced from'
when ( M_RAT_DISP <>1 or (M_FLAGS<>1 and M_FLAGS<>4 )) and (T2.M_ECPE_TYPE0 = 0) then 'Driving schedule'
when ( M_RAT_DISP <>1 or (M_FLAGS<>1 and M_FLAGS<>4 )) and (T2.M_ECPE_TYPE0 = 1) then 'Equal to'
when ( M_RAT_DISP <>1 or (M_FLAGS<>1 and M_FLAGS<>4 )) and (T2.M_ECPE_TYPE0 = 2) then 'Deduced from'
end as CalcEndSched1Leg1,
case when (M_RAT_DISP =1 and (M_FLAGS=1 or M_FLAGS=4 )) then ' '
when (M_RAT_DISP =1 and (M_FLAGS=0 or M_FLAGS=2 )) and (T2.M_ECPE_UNDR1 = -1) then ' '
when (M_RAT_DISP =1 and (M_FLAGS=0 or M_FLAGS=2 )) and (T2.M_ECPE_UNDR1 = 0) then 'Payment schedule' 
when (M_RAT_DISP =1 and (M_FLAGS=0 or M_FLAGS=2 )) and (T2.M_ECPE_UNDR1 = 1) then 'Calculation start schedule'
when (M_RAT_DISP =1 and (M_FLAGS=0 or M_FLAGS=2 )) and (T2.M_ECPE_UNDR1 = 2) then 'Fixing schedule'
when (M_RAT_DISP =1 and (M_FLAGS=0 or M_FLAGS=2 )) and (T2.M_ECPE_UNDR1 = 8) then 'Delivery schedule'
when ( M_RAT_DISP <>1 or (M_FLAGS<>1 and M_FLAGS<>4 )) and (T2.M_ECPE_UNDR0 = -1) then ' '
when ( M_RAT_DISP <>1 or (M_FLAGS<>1 and M_FLAGS<>4 )) and (T2.M_ECPE_UNDR0 = 0) then 'Payment schedule' 
when ( M_RAT_DISP <>1 or (M_FLAGS<>1 and M_FLAGS<>4 )) and (T2.M_ECPE_UNDR0= 1) then 'Calculation start schedule'
when ( M_RAT_DISP <>1 or (M_FLAGS<>1 and M_FLAGS<>4 )) and (T2.M_ECPE_UNDR0 = 2) then 'Fixing schedule'
when ( M_RAT_DISP <>1 or (M_FLAGS<>1 and M_FLAGS<>4 )) and (T2.M_ECPE_UNDR0 = 8) then 'Delivery schedule'
end as CalcEndSched2Leg1,
case when (M_RAT_DISP =1 and (M_FLAGS=1 or M_FLAGS=4 )) then CAST(T2.M_ECPE1 AS VARCHAR2(20)) else CAST(T2.M_ECPE0 AS VARCHAR2(20)) end as CalcEndSched3Leg1,
case when (M_RAT_DISP =1 and (M_FLAGS=1 or M_FLAGS=4 )) then ' '
when (M_RAT_DISP =1 and (M_FLAGS=0 or M_FLAGS=2 )) and (T2.M_EP_TYPE1 = 0) then 'Driving schedule'
when (M_RAT_DISP =1 and (M_FLAGS=0 or M_FLAGS=2 )) and (T2.M_EP_TYPE1= 1) then 'Equal to'
when (M_RAT_DISP =1 and (M_FLAGS=0 or M_FLAGS=2 )) and (T2.M_EP_TYPE1= 2) then 'Deduced from'
when ( M_RAT_DISP <>1 or (M_FLAGS<>1 and M_FLAGS<>4 )) and (T2.M_EP_TYPE0 = 0) then 'Driving schedule'
when ( M_RAT_DISP <>1 or (M_FLAGS<>1 and M_FLAGS<>4 )) and (T2.M_EP_TYPE0 = 1) then 'Equal to'
when ( M_RAT_DISP <>1 or (M_FLAGS<>1 and M_FLAGS<>4 )) and (T2.M_EP_TYPE0 = 2) then 'Deduced from'
end as PaymentSchedule1Leg1,
case when (M_RAT_DISP =1 and (M_FLAGS=1 or M_FLAGS=4 )) then ' '
when (M_RAT_DISP =1 and (M_FLAGS=0 or M_FLAGS=2 )) and ((T2.M_EP_UNDRL1 = -1) or (T2.M_EP_UNDRL1 = 0)) then ' '
when (M_RAT_DISP =1 and (M_FLAGS=0 or M_FLAGS=2 )) and (T2.M_EP_UNDRL1 = 1) then 'Calculation start schedule'
when (M_RAT_DISP =1 and (M_FLAGS=0 or M_FLAGS=2 )) and (T2.M_EP_UNDRL1 = 2) then 'Fixing schedule'
when (M_RAT_DISP =1 and (M_FLAGS=0 or M_FLAGS=2 )) and (T2.M_EP_UNDRL1 = 7) then 'Calculation end schedule'
when (M_RAT_DISP =1 and (M_FLAGS=0 or M_FLAGS=2 )) and (T2.M_EP_UNDRL1 = 8) then 'Delivery schedule'
when ( M_RAT_DISP <>1 or (M_FLAGS<>1 and M_FLAGS<>4 )) and ((T2.M_EP_UNDRL0 = -1) or (T2.M_EP_UNDRL0 = 0))then ' '
when ( M_RAT_DISP <>1 or (M_FLAGS<>1 and M_FLAGS<>4 )) and (T2.M_EP_UNDRL0= 1) then 'Calculation start schedule'
when ( M_RAT_DISP <>1 or (M_FLAGS<>1 and M_FLAGS<>4 )) and (T2.M_EP_UNDRL0 = 2) then 'Fixing schedule'
when ( M_RAT_DISP <>1 or (M_FLAGS<>1 and M_FLAGS<>4 )) and (T2.M_EP_UNDRL0 = 7) then 'Calculation end schedule'
when ( M_RAT_DISP <>1 or (M_FLAGS<>1 and M_FLAGS<>4 )) and (T2.M_EP_UNDRL0 = 8) then 'Delivery schedule'
end as PaymentSchedule2Leg1,
case when (M_RAT_DISP =1 and (M_FLAGS=1 or M_FLAGS=4 )) then CAST(T2.M_EP1 AS VARCHAR2(20)) else CAST(T2.M_EP0 AS VARCHAR2(20)) end as PaymentSchedule3Leg1,
case when (M_RAT_DISP =1 and (M_FLAGS=1 or M_FLAGS=4 )) then T2.M_EP_FREQ1 else T2.M_EP_FREQ0 end as PaymentFrequencyLeg1,
case when ((M_RAT_DISP =1) or (M_RAT_DISP =2))  then ' '
when ( M_RAT_DISP <>1 or (M_FLAGS<>1 and M_FLAGS<>4 )) and (T2.M_EI_TYPE0 = 0) then 'Driving schedule'
when ( M_RAT_DISP <>1 or (M_FLAGS<>1 and M_FLAGS<>4 )) and (T2.M_EI_TYPE0 = 1) then 'Equal to'
when ( M_RAT_DISP <>1 or (M_FLAGS<>1 and M_FLAGS<>4 )) and (T2.M_EI_TYPE0 = 2) then 'Deduced from'
end as FixingSchedule1Leg1,
case when ((M_RAT_DISP =1) or (M_RAT_DISP =2))  then ' '
when (( M_RAT_DISP <>1 or (M_FLAGS<>1 and M_FLAGS<>4 )) and (T2.M_EI_UNDRL0 = -1)) then ' '
when ( M_RAT_DISP <>1 or (M_FLAGS<>1 and M_FLAGS<>4 )) and (T2.M_EI_UNDRL0= 1) then 'Calculation start schedule'
when ( M_RAT_DISP <>1 or (M_FLAGS<>1 and M_FLAGS<>4 )) and (T2.M_EI_UNDRL0 = 7) then 'Calculation end schedule'
when ( M_RAT_DISP <>1 or (M_FLAGS<>1 and M_FLAGS<>4 )) and (T2.M_EI_UNDRL0 = 0) then 'Payment schedule'
end as FixingSchedule2Leg1,
case when (M_RAT_DISP =1 and (M_FLAGS=1 or M_FLAGS=4 )) then CAST(T2.M_EI1 AS VARCHAR2(20)) else CAST(T2.M_EI0 AS VARCHAR2(20)) end as FixingSchedule3Leg1 ,
case when (M_RAT_DISP =1 and (M_FLAGS=1 or M_FLAGS=4 )) then T2.M_EI_FREQ1 else T2.M_EI_FREQ0 end as FixingFrequencyLeg1,
case when (M_RAT_DISP =1 and (M_FLAGS=1 or M_FLAGS=4 )) then ' '	
when (M_RAT_DISP =1 and (M_FLAGS=0 or M_FLAGS=2 )) and (T2.M_SIMP_SCH1 = 0) then 'No'
when (M_RAT_DISP =1 and (M_FLAGS=0 or M_FLAGS=2 )) and (T2.M_SIMP_SCH1 = 1) then 'Yes'
when (M_RAT_DISP <>1 or (M_FLAGS<>1 and M_FLAGS<>4 ))and  (T2.M_SIMP_SCH0 = 0) then 'No'
when (M_RAT_DISP <>1 or (M_FLAGS<>1 and M_FLAGS<>4 )) and (T2.M_SIMP_SCH0 = 1) then 'Yes'
end as SinglePeriodLeg1,
case when (T2.M_RETINT0 = 0) then 'Return (P2-P1)/P1' when (T2.M_RETINT0 = 1) then 'Spread (P2-P1)' end as ReturnTypeLeg1,
case when (T4.M_IND_LAB is null) then ' ' else T4.M_IND_LAB end as IndexLeg2,
case when (T2.M_FINALTP1 = 0) then 'Currency'
when (T2.M_FINALTP1 = 1) then 'Commodity'
when (T2.M_FINALTP1 = 2) then 'Bond'
when (T2.M_FINALTP1 = 3) then 'Equity' 
end as InstrumentTypeLeg2,
T2.M_CURRENCY1 as CurrencyLeg2, CAST(T2.M_EXT_FREQ1 AS VARCHAR2(15)) as FrequencyLeg2,
case when (M_RAT_DISP =1 and (M_FLAGS=1 or M_FLAGS=4 )) then T2.M_START0 else T2.M_START1 end as StartDelayLeg2,
case when (M_RAT_DISP =1 and (M_FLAGS=1 or M_FLAGS=4 )) then CAST(T2.M_PAY_CLN0 AS VARCHAR2(20)) else CAST(T2.M_PAY_CLN1 AS VARCHAR2(20)) end as PaymentCalendarLeg2,
case when (M_RAT_DISP =1 and (M_FLAGS=1 or M_FLAGS=4 )) then CAST(T2.M_FIX_CLN0 AS VARCHAR2(20)) else CAST(T2.M_FIX_CLN1 AS VARCHAR2(20)) end as FixingCalendarLeg2,
case when (T2.M_FIXING1=0) then 'In advance'  when (T2.M_FIXING1=1) then 'In arrears' end as FixingLeg2 ,
case when (T2.M_PAYMENT1 = 0 ) then 'In arrears' 
when (T2.M_PAYMENT1 = 1 ) then 'Up front'  
when (T2.M_PAYMENT1 = 2 ) then 'Up front disc.'
end as PaymentLeg2,
case when (T2.M_PAYMENT1 = 2 and M_DISC_RATE1 =0) then 'Floating rate'
		when (T2.M_PAYMENT1 = 2 and M_DISC_RATE1 =1) then 'Fixed rate'
		when (T2.M_PAYMENT1 = 2 and M_DISC_RATE1 =2) then 'specific index'
		when (T2.M_PAYMENT1 = 2 and M_DISC_RATE1 =3) then 'Current leg'
		when (T2.M_PAYMENT1 = 2 and M_DISC_RATE1 =4) then 'Specific leg'
		when (T2.M_PAYMENT1 = 2 and M_DISC_RATE1 =5) then 'Fixing' else ' ' end as DiscountingRateLeg2,
case when (T2.M_PAYMENT1 = 2 and M_DISC_RATE1 =2) then M_DISC_IND1 else ' ' end as DiscountingIndex2,
case when (T2.M_PAYMENT1 = 2 and M_DISC_RATE1 =4) then M_DISC_LEG1 else null end as DiscountingLeg2,
CAST(T2.M_RATE_CONV1 AS VARCHAR2(20)) as RateConventionLeg2,
case when (T2.M_CONVERT1= 0 ) then 'UNCHECKED' when (T2.M_CONVERT1= 1 ) then 'CHECKED' end as RateConversionLeg2,
case when (T2.M_INDEXED1 = 0 ) then 'UNCHECKED' when (T2.M_INDEXED1 = 1 ) then 'CHECKED' end as IndexedLeg2,
case when  (T2.M_ROUND_RUL1 =0 ) then 'None' when  (T2.M_ROUND_RUL1 =1) then 'Nearest'
when (T2.M_ROUND_RUL1 =2)  then 'By default'  when (T2.M_ROUND_RUL1 =3 ) then 'By excess' 
when (T2.M_ROUND_RUL1 =4) then 'Currency' 
end as RoundingRuleLeg2,
T2.M_DECIMALS1 as DecimalsLeg2,
case when (T2.M_MRG_MODE1= 0) then 'Additive' else 'Multiplicative' end as MarginModeLeg2,
case when (T2.M_BROK_COUP1= 0) then 'Short Coupon'
when (T2.M_BROK_COUP1= 1) then 'Long Coupon'
when (T2.M_BROK_COUP1= 3) then 'Full Coupon'
when (T2.M_BROK_COUP1= 4) then 'Conditional'
end as CouponLeg2,
case when (T2.M_BROK_IND1=0) then 'Current Index'
when (T2.M_BROK_IND1=1) then 'Closest Index'
when (T2.M_BROK_IND1=2) then 'Next Index'
when (T2.M_BROK_IND1=3) then 'Previous Index'
when (T2.M_BROK_IND1=4) then 'Interpolated'
end  as StubPeriodRateLeg2,
CAST(T2.M_BROK_COND1 AS VARCHAR2(20)) as StubConditionLeg2,
case when (M_RAT_DISP =1 and (M_FLAGS=1 or M_FLAGS=4 )) and (T2.M_ECP_TYPE0 = 0) then 'Driving schedule'
when (M_RAT_DISP =1 and (M_FLAGS=1 or M_FLAGS=4 )) and (T2.M_ECP_TYPE0 = 1) then 'Equal to'
when (M_RAT_DISP =1 and (M_FLAGS=1 or M_FLAGS=4 )) and (T2.M_ECP_TYPE0 = 2) then 'Deduced from'	
when ( M_RAT_DISP <>1 and (M_FLAGS=1 or M_FLAGS=4 )) then ' '
when ( M_RAT_DISP <>1 or (M_FLAGS<>1 and M_FLAGS<>4 )) and (T2.M_ECP_TYPE1 = 0) then 'Driving schedule'
when ( M_RAT_DISP <>1 or (M_FLAGS<>1 and M_FLAGS<>4 )) and (T2.M_ECP_TYPE1 = 1) then 'Equal to'
when ( M_RAT_DISP <>1 or (M_FLAGS<>1 and M_FLAGS<>4 )) and (T2.M_ECP_TYPE1 = 2) then 'Deduced from'
end as CalcStartSched1Leg2,
case when (M_RAT_DISP =1 and (M_FLAGS=1 or M_FLAGS=4 )) and ((T2.M_ECP_UNDRL0  = -1) or  (T2.M_ECP_UNDRL0  = 0)) then ' '
when (M_RAT_DISP =1 and (M_FLAGS=1 or M_FLAGS=4 )) and (T2.M_ECP_UNDRL0 = 0) then 'Payment schedule' 
when (M_RAT_DISP =1 and (M_FLAGS=1 or M_FLAGS=4 )) and (T2.M_ECP_UNDRL0 = 2) then 'Fixing schedule'
when (M_RAT_DISP =1 and (M_FLAGS=1 or M_FLAGS=4 )) and (T2.M_ECP_UNDRL0 = 7) then 'Calculation end schedule'
when (M_RAT_DISP =1 and (M_FLAGS=1 or M_FLAGS=4 )) and (T2.M_ECP_UNDRL0 = 8) then 'Delivery schedule'
when ( M_RAT_DISP <>1 and (M_FLAGS=1 or M_FLAGS=4 )) then ' '
when ( M_RAT_DISP <>1 or (M_FLAGS<>1 and M_FLAGS<>4 )) and ((T2.M_ECP_UNDRL1 = -1) or (T2.M_ECP_UNDRL1 = 0)) then ' '
when ( M_RAT_DISP <>1 or (M_FLAGS<>1 and M_FLAGS<>4 )) and (T2.M_ECP_UNDRL1 = 0) then 'Payment schedule' 
when ( M_RAT_DISP <>1 or (M_FLAGS<>1 and M_FLAGS<>4 )) and (T2.M_ECP_UNDRL1 = 2) then 'Fixing schedule'
when ( M_RAT_DISP <>1 or (M_FLAGS<>1 and M_FLAGS<>4 )) and (T2.M_ECP_UNDRL1= 7) then 'Calculation end schedule'
when ( M_RAT_DISP <>1 or (M_FLAGS<>1 and M_FLAGS<>4 )) and (T2.M_ECP_UNDRL1 = 8) then 'Delivery schedule'
end as CalcStartSched2Leg2,
case when (M_RAT_DISP =1 and (M_FLAGS=1 or M_FLAGS=4 )) then CAST(T2.M_ECP0 AS VARCHAR2(20)) else CAST(T2.M_ECP1 AS VARCHAR2(20)) end as CalcStartSched3Leg2,
case when (M_RAT_DISP =1 and (M_FLAGS=1 or M_FLAGS=4 )) and (T2.M_ECPE_TYPE0 = 0) then 'Driving schedule'
when (M_RAT_DISP =1 and (M_FLAGS=1 or M_FLAGS=4 )) and (T2.M_ECPE_TYPE0= 1) then 'Equal to'
when (M_RAT_DISP =1 and (M_FLAGS=1 or M_FLAGS=4 )) and (T2.M_ECPE_TYPE0 = 2) then 'Deduced from'
when ( M_RAT_DISP <>1 and (M_FLAGS=1 or M_FLAGS=4 )) then ' '
when ( M_RAT_DISP <>1 or (M_FLAGS<>1 and M_FLAGS<>4 )) and (T2.M_ECPE_TYPE1 = 0) then 'Driving schedule'
when ( M_RAT_DISP <>1 or (M_FLAGS<>1 and M_FLAGS<>4 )) and (T2.M_ECPE_TYPE1 = 1) then 'Equal to'
when ( M_RAT_DISP <>1 or (M_FLAGS<>1 and M_FLAGS<>4 )) and (T2.M_ECPE_TYPE1 = 2) then 'Deduced from'
end as CalcEndSched1Leg2,
case when (M_RAT_DISP =1 and (M_FLAGS=1 or M_FLAGS=4 )) and (T2.M_ECPE_UNDR0 = -1) then ' '
when (M_RAT_DISP =1 and (M_FLAGS=1 or M_FLAGS=4 )) and (T2.M_ECPE_UNDR0 = 0) then 'Payment schedule' 
when (M_RAT_DISP =1 and (M_FLAGS=1 or M_FLAGS=4 )) and (T2.M_ECPE_UNDR0 = 1) then 'Calculation start schedule'
when (M_RAT_DISP =1 and (M_FLAGS=1 or M_FLAGS=4 )) and (T2.M_ECPE_UNDR0 = 2) then 'Fixing schedule'
when (M_RAT_DISP =1 and (M_FLAGS=1 or M_FLAGS=4 )) and (T2.M_ECPE_UNDR0 = 8) then 'Delivery schedule'
when ( M_RAT_DISP <>1 and (M_FLAGS=1 or M_FLAGS=4 )) then ' '
when ( M_RAT_DISP <>1 or (M_FLAGS<>1 and M_FLAGS<>4 )) and (T2.M_ECPE_UNDR1 = -1) then ' '
when ( M_RAT_DISP <>1 or (M_FLAGS<>1 and M_FLAGS<>4 )) and (T2.M_ECPE_UNDR1 = 0) then 'Payment schedule' 
when ( M_RAT_DISP <>1 or (M_FLAGS<>1 and M_FLAGS<>4 )) and (T2.M_ECPE_UNDR1= 1) then 'Calculation start schedule'
when ( M_RAT_DISP <>1 or (M_FLAGS<>1 and M_FLAGS<>4 )) and (T2.M_ECPE_UNDR1 = 2) then 'Fixing schedule'
when ( M_RAT_DISP <>1 or (M_FLAGS<>1 and M_FLAGS<>4 )) and (T2.M_ECPE_UNDR1 = 8) then 'Delivery schedule'
end as CalcEndSched2Leg2,
case when (M_RAT_DISP =1 and (M_FLAGS=1 or M_FLAGS=4 )) then CAST(T2.M_ECPE0 AS VARCHAR2(20)) else CAST(T2.M_ECPE1 AS VARCHAR2(20)) end as CalcEndSched3Leg2,
case when (M_RAT_DISP =1 and (M_FLAGS=1 or M_FLAGS=4 )) and (T2.M_EP_TYPE0 = 0) then 'Driving schedule'
when (M_RAT_DISP =1 and (M_FLAGS=1 or M_FLAGS=4 )) and (T2.M_EP_TYPE0= 1) then 'Equal to'
when (M_RAT_DISP =1 and (M_FLAGS=1 or M_FLAGS=4 )) and (T2.M_EP_TYPE0= 2) then 'Deduced from'
when ( M_RAT_DISP <>1 and (M_FLAGS=1 or M_FLAGS=4 )) then ' '
when ( M_RAT_DISP <>1 or (M_FLAGS<>1 and M_FLAGS<>4 )) and (T2.M_EP_TYPE1 = 0) then 'Driving schedule'
when ( M_RAT_DISP <>1 or (M_FLAGS<>1 and M_FLAGS<>4 )) and (T2.M_EP_TYPE1 = 1) then 'Equal to'
when ( M_RAT_DISP <>1 or (M_FLAGS<>1 and M_FLAGS<>4 )) and (T2.M_EP_TYPE1 = 2) then 'Deduced from'
end as PaymentSchedule1Leg2,
case when (M_RAT_DISP =1 and (M_FLAGS=1 or M_FLAGS=4 )) and ((T2.M_EP_UNDRL0 = -1) or (T2.M_EP_UNDRL0 = 0)) then ' '
when (M_RAT_DISP =1 and (M_FLAGS=1 or M_FLAGS=4 )) and (T2.M_EP_UNDRL0 = 1) then 'Calculation start schedule'
when (M_RAT_DISP =1 and (M_FLAGS=1 or M_FLAGS=4 )) and (T2.M_EP_UNDRL0 = 2) then 'Fixing schedule'
when (M_RAT_DISP =1 and (M_FLAGS=1 or M_FLAGS=4 )) and (T2.M_EP_UNDRL0 = 7) then 'Calculation end schedule'
when (M_RAT_DISP =1 and (M_FLAGS=1 or M_FLAGS=4 )) and (T2.M_EP_UNDRL0 = 8) then 'Delivery schedule'
when ( M_RAT_DISP <>1 and (M_FLAGS=1 or M_FLAGS=4 )) then ' '
when ( M_RAT_DISP <>1 or (M_FLAGS<>1 and M_FLAGS<>4 )) and ((T2.M_EP_UNDRL1 = -1) or (T2.M_EP_UNDRL1 = 0)) then ' '
when ( M_RAT_DISP <>1 or (M_FLAGS<>1 and M_FLAGS<>4 )) and (T2.M_EP_UNDRL1= 1) then 'Calculation start schedule'
when ( M_RAT_DISP <>1 or (M_FLAGS<>1 and M_FLAGS<>4 )) and (T2.M_EP_UNDRL1 = 2) then 'Fixing schedule'
when ( M_RAT_DISP <>1 or (M_FLAGS<>1 and M_FLAGS<>4 )) and (T2.M_EP_UNDRL1 = 7) then 'Calculation end schedule'
when ( M_RAT_DISP <>1 or (M_FLAGS<>1 and M_FLAGS<>4 )) and (T2.M_EP_UNDRL1 = 8) then 'Delivery schedule'
end as PaymentSchedule2Leg2,
case when (M_RAT_DISP =1 and (M_FLAGS=1 or M_FLAGS=4 )) then CAST(T2.M_EP0 AS VARCHAR2(20)) else CAST(T2.M_EP1 AS VARCHAR2(20)) end as  PaymentSchedule3Leg2,
case when (M_RAT_DISP =1 and (M_FLAGS=1 or M_FLAGS=4 )) then T2.M_EP_FREQ0 else T2.M_EP_FREQ1 end as PaymentFrequencyLeg2 ,
case when (M_RAT_DISP =1 and (M_FLAGS=1 or M_FLAGS=4 )) and (T2.M_EI_TYPE0 = 0) then 'Driving schedule'
when (M_RAT_DISP =1 and (M_FLAGS=1 or M_FLAGS=4 )) and (T2.M_EI_TYPE0= 1) then 'Equal to'
when (M_RAT_DISP =1 and (M_FLAGS=1 or M_FLAGS=4 )) and (T2.M_EI_TYPE0= 2) then 'Deduced from'
when (M_RAT_DISP = 2) then ' '
when ( M_RAT_DISP <>1 and (M_FLAGS=1 or M_FLAGS=4 )) then ' '
when ( M_RAT_DISP <>1 or (M_FLAGS<>1 and M_FLAGS<>4 )) and (T2.M_EI_TYPE1 = 0) then 'Driving schedule'
when ( M_RAT_DISP <>1 or (M_FLAGS<>1 and M_FLAGS<>4 )) and (T2.M_EI_TYPE1 = 1) then 'Equal to'
when ( M_RAT_DISP <>1 or (M_FLAGS<>1 and M_FLAGS<>4 )) and (T2.M_EI_TYPE1 = 2) then 'Deduced from'
end as FixingSchedule1Leg2,
case when ((M_RAT_DISP =1 and (M_FLAGS=1 or M_FLAGS=4 )) and (T2.M_EI_UNDRL0 = -1))   then ' '
when ((M_RAT_DISP =1 and (M_FLAGS=1 or M_FLAGS=4 )) and (T2.M_EI_UNDRL0 = 0))  then 'Payment schedule'
when (M_RAT_DISP =1 and (M_FLAGS=1 or M_FLAGS=4 )) and (T2.M_EI_UNDRL0 = 1) then 'Calculation start schedule'
when (M_RAT_DISP =1 and (M_FLAGS=1 or M_FLAGS=4 )) and (T2.M_EI_UNDRL0 = 7) then 'Calculation end schedule'
when (M_RAT_DISP =1 and (M_FLAGS=1 or M_FLAGS=4 )) and (T2.M_EI_UNDRL0 = 8) then 'Delivery schedule'
when (M_RAT_DISP =2) then ' '
when ( M_RAT_DISP <>1 and (M_FLAGS=1 or M_FLAGS=4 )) then ' '
when (( M_RAT_DISP <>1 or (M_FLAGS<>1 and M_FLAGS<>4 )) and (T2.M_EI_UNDRL1 = -1) )  then ' '
when ( M_RAT_DISP <>1 or (M_FLAGS<>1 and M_FLAGS<>4 )) and (T2.M_EI_UNDRL1= 0) then 'Payment schedule'
when ( M_RAT_DISP <>1 or (M_FLAGS<>1 and M_FLAGS<>4 )) and (T2.M_EI_UNDRL1= 1) then 'Calculation start schedule'
when ( M_RAT_DISP <>1 or (M_FLAGS<>1 and M_FLAGS<>4 )) and (T2.M_EI_UNDRL1 = 7) then 'Calculation end schedule'
when ( M_RAT_DISP <>1 or (M_FLAGS<>1 and M_FLAGS<>4 )) and (T2.M_EI_UNDRL1 = 8) then 'Delivery schedule'
end as FixingSchedule2Leg2,
case when (M_RAT_DISP =1 and (M_FLAGS=1 or M_FLAGS=4 )) then CAST(T2.M_EI0 AS VARCHAR2(20)) else CAST(T2.M_EI1 AS VARCHAR2(20)) end as FixingSchedule3Leg2, 
case when (M_RAT_DISP =1 and (M_FLAGS=1 or M_FLAGS=4 )) then T2.M_EI_FREQ0 else T2.M_EI_FREQ1 end as FixingFrequencyLeg2,	
case when (M_RAT_DISP =1 and (M_FLAGS=1 or M_FLAGS=4 )) and (T2.M_SIMP_SCH0 = 0) then 'No'
when (M_RAT_DISP =1 and (M_FLAGS=1 or M_FLAGS=4 )) and (T2.M_SIMP_SCH0 = 1) then 'Yes'
when ( M_RAT_DISP <>1 and (M_FLAGS=1 or M_FLAGS=4 )) then ' '
when ( M_RAT_DISP <>1 or (M_FLAGS<>1 and M_FLAGS<>4 )) and (T2.M_SIMP_SCH1 = 0) then 'No'
when ( M_RAT_DISP <>1 or (M_FLAGS<>1 and M_FLAGS<>4 )) and (T2.M_SIMP_SCH1 = 1) then 'Yes'
end as SinglePeriodLeg2,
case when (T2.M_RETINT1 = 0) then 'Return (P2-P1)/P1' when (T2.M_RETINT1 = 1) then 'Spread (P2-P1)' end as ReturnTypeLeg2
-------
from RT_INSGN_DBF T1, RT_LNGN_DBF T2
left outer join RT_INDEX_DBF  T3 on T2.M_INDEX0 = T3.M_INDEX
left outer join RT_INDEX_DBF  T4 on T2.M_INDEX1 = T4.M_INDEX
left outer join CM_PROFH_DBF T8 on T8.M_REFERENCE=T2.M_PROFILE0
where T1.M_GEN_NUM = T2.M_GEN_NUM
and T1.M_INSTR_TYPE = 4
and T1.M_CREAT_MODE = 0
order by T1.M_INSTR;
-------
quit;
SPOOL OFF;