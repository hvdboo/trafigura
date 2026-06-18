set colsep '#';
SET TERMOUT OFF;
SPOOL &1;
set linesize 5320;
set pagesize 2048;
select T1.M_INSTR as SwapGenerator,
T1.M_INSTR_DESC as Description,
--------
	case	when (T2.M_AMORT0 = 0) then 'None' 
		when (T2.M_AMORT0 = 1) then 'Linear (rate)'
		when (T2.M_AMORT0 = 2) then 'Constant'
		when (T2.M_AMORT0 = 3) then 'Constant annuities'
		when (T2.M_AMORT0 = 4) then 'Constant number of shares'
		when (T2.M_AMORT0 = 5) then 'Coupon reinvestment'
		when (T2.M_AMORT0 = 6) then 'Constant annuities (r)'
		when (T2.M_AMORT0 = 7) then 'Linear (amount)'
		when (T2.M_AMORT0 = 8) then 'Dividends reinvestment (in new shares)'
	end as DfltAmort,
--------
	T1.M_NB_PHASE as NumPhases,T1.M_NB_LEG as NumLegs,
-------
	case	when (T1.M_FLAGS =1) or (T1.M_FLAGS =513) or (T1.M_FLAGS =16385) or (T1.M_FLAGS =16897) then 'Common set across legs' 
		when (T1.M_FLAGS =2 ) or (T1.M_FLAGS =0 ) or (T1.M_FLAGS =514) then 'Independent sets across legs' 
		when (T1.M_FLAGS =4 ) or (T1.M_FLAGS =516) then 'Common set, different freq.' 
		when (T1.M_FLAGS =8 ) or (T1.M_FLAGS =520) then 'Independant sets common capital'
	end as Schedules,
	case	when ((T1.M_FLAGS =2 ) or (T1.M_FLAGS =0 )) and (T1.M_LEG_AMORT =0) then 'Common definition across legs'
		when ((T1.M_FLAGS =2 ) or (T1.M_FLAGS =0 )) and (T1.M_LEG_AMORT =1) then 'Independent definition across legs'
	else ' ' end as LegAmortiz, 
	case	when (T1.M_BROKEN = 0) then 'Up front' 
		when (T1.M_BROKEN = 1) then 'In arrears'
		when (T1.M_BROKEN = 3) then 'Both ends (Backward)'
		when (T1.M_BROKEN = 5) then 'Both ends (Forward)'
	end as StubPeriod,
	case when (T1.M_LEG_PROF = 0) then 'Independant Profiles Across Legs'
		when (T1.M_LEG_PROF = 1) then 'Common Profiles Across Legs'
	end as VolumeProfiles,
	case	when (T1.M_EVAL_MODE = 0) then 'Default'
		when (T1.M_EVAL_MODE = 1) then 'MTM'
		when (T1.M_EVAL_MODE = 2) then 'Accrual'
	end as EvalMode,
--------
	case when  floor(T1.M_FLAGS / 512) = (floor(T1.M_FLAGS / (512*2)) * 2) then 'UNCHECKED' else 'CHECKED' end as IgnoreDiscounting,
--------
	case when (T1.M_DLV_COND = 0) then 'IndependantDeliveryConditions'
		when (T1.M_DLV_COND = 1) then 'CommonDeliveryConditions'
	end as DeliveryConditions,
	CAST(T1.M_FCPCUTOFF AS VARCHAR2(25)) as FutureCashProceedCutOff,
--------
	case when (T1.M_SETTL_MOD= 0) then 'Inherited from currency' else 'Specific delay' end as SettleMode,
	case when T1.M_SETTL_MOD= 0 then ' ' else T1.M_SETTL end as SettleShift,
	case when (T1.M_RAT_DISP= 1) then 'Floating-Fixed'
		when (T1.M_RAT_DISP= 2) then 'Fixed-Fixed'
		when (T1.M_RAT_DISP= 4) then 'Floating-Floating'
	end as GenType,
	case when (T2.M_SETTLE0 = 0) then 'CashSettled'
		when (T2.M_SETTLE0 = 1) then 'PhysicalDelivery'
	end as Exercise,
--------
	case when (T3.M_CATEGORY=8 and T3.M_RESET=3) then T3.M_IND_LAB 
when ( T3.M_CATEGORY<>8 or T3.M_RESET NOT IN (0,3,4,6)) then 'NewBskElem'
else ' ' end as comAvgIndex,
case when (T3.M_CATEGORY=8 and T3.M_RESET=6) then T3.M_IND_LAB 
when ( T3.M_CATEGORY<>8 or T3.M_RESET NOT IN (0,3,4,6)) then 'NewBskElem'
else ' ' end as nearbiesIndex,
case when (T3.M_CATEGORY=8 and T3.M_RESET=4) then T3.M_IND_LAB
when ( T3.M_CATEGORY<>8 or T3.M_RESET NOT IN (0,3,4,6)) then 'NewBskElem'
else ' ' end as comBskIndex,
case when (T3.M_CATEGORY=8 and T3.M_RESET=0) then T3.M_IND_LAB
when ( T3.M_CATEGORY<>8 or T3.M_RESET NOT IN (0,3,4,6)) then 'NewBskElem'
else ' ' end as comSpotIndex,	 
--------
	case when (T8.M_LABEL is NULL or T2.M_USE_PROF0 = 0) then ' ' else T8.M_LABEL end as VolumeProfile,
	case when (T2.M_LEV_MODE0 = 0) then 'Inherited'
		when (T2.M_LEV_MODE0 = 1) then 'Accrual sens accrual'
		when (T2.M_LEV_MODE0 = 2) then 'Accrual sens MTM'
	end as Evaluation,
	case when (T11.M_LABEL is null) then ' ' else T11.M_LABEL end as Formula,
--------
	case when (T2.M_DLVTP0 = 0) then 'Currency'
		when (T2.M_DLVTP0 = 1) then 'Commodity'
		when (T2.M_DLVTP0 = 2) then 'Bond'
		when (T2.M_DLVTP0 = 3) then 'Equity'
	end as InstrTypLeg1,
	case when T2.M_DLVTP0 = 0 then T2.M_CURRENCY0 else ' ' end as CurrLeg1,
	case when T16.M_LABEL is null then ' ' else T16.M_LABEL end as ComLeg1,
	T2.M_START0 as StDelayLeg1,
	T2.M_PAY_CLN0 as PayCalLeg1,
	T2.M_FIX_CLN0 as FixCalLeg1,
--------
case	when (T2.M_ECP_TYPE0 = 0) then 'Driving schedule'
		when (T2.M_ECP_TYPE0 = 1) then 'Equal to'
		when (T2.M_ECP_TYPE0 = 2) then 'Deduced from'
	end as CalcStSch1Leg1,
	case	when (T2.M_ECP_UNDRL0 = -1) then ' '
		when (T2.M_ECP_UNDRL0 = 0) then 'Payment schedule' 
		when (T2.M_ECP_UNDRL0 = 2) then 'Fixing schedule'
		when (T2.M_ECP_UNDRL0= 7) then 'Calculation end schedule'
		when (T2.M_ECP_UNDRL0 = 8) then 'Delivery schedule'
	else ' ' end as CalcSt2Leg1,
--------
	T2.M_ECP0 as CalcSt3Leg1,
--------
	case	when (T2.M_ECPE_TYPE0 = 0) then 'Driving schedule'
		when (T2.M_ECPE_TYPE0 = 1) then 'Equal to'
		when (T2.M_ECPE_TYPE0 = 2) then 'Deduced from'
	end as CalcEndSch1Leg1,
--------
	case	when (T2.M_ECPE_UNDR0 = -1) then ' '
		when (T2.M_ECPE_UNDR0 = 0) then 'Payment schedule' 
		when (T2.M_ECPE_UNDR0= 1) then 'Calculation start schedule'
		when (T2.M_ECPE_UNDR0 = 2) then 'Fixing schedule'
		when (T2.M_ECPE_UNDR0 = 8) then 'Delivery schedule'
	end as CalcEndSch2Leg1,
	T2.M_ECPE0 as CalcEndSch3Leg1,
	case	when (T2.M_EP_TYPE0 = 0) then 'Driving schedule'
		when (T2.M_EP_TYPE0 = 1) then 'Equal to'
		when (T2.M_EP_TYPE0 = 2) then 'Deduced from'
	end as PaySch1Leg1,
--------
	case	when ((T2.M_EP_UNDRL0 = -1) or (T2.M_EP_UNDRL0 = 0)) then ' '
		when (T2.M_EP_UNDRL0= 1) then 'Calculation start schedule'
		when (T2.M_EP_UNDRL0 = 2) then 'Fixing schedule'
		when (T2.M_EP_UNDRL0 = 7) then 'Calculation end schedule'
		when (T2.M_EP_UNDRL0 = 8) then 'Delivery schedule'
	end as PaySch2Leg1,
	T2.M_EP0 as PaySc3Leg1,
	T2.M_EP_FREQ0 as PayFrqLeg1,
	case	when (T2.M_EI_TYPE0 = 0) then 'Driving schedule'
		when (T2.M_EI_TYPE0 = 1) then 'Equal to'
		when (T2.M_EI_TYPE0 = 2) then 'Deduced from'
	end as FixSch1Leg1,
	case	when (T2.M_EI_UNDRL0 = -1)   then ' '
		when (T2.M_EI_UNDRL0= 1) then 'Calculation start schedule'
		when (T2.M_EI_UNDRL0 = 7) then 'Calculation end schedule'
		when (T2.M_EI_UNDRL0 = 0) then 'Payment schedule'
	end as FixSch2Leg1,
	T2.M_EI0  as FixSch3Leg1 ,
	T2.M_EI_FREQ0 as FixFrqLeg1,
--------
	case when T2.M_DLV_TYPE0=1 then 'Equal to' 
     		when T2.M_DLV_TYPE0=4 then 'Manual Schedule'             
	end as DeliverySchedule,
--------
	case when T2.M_DLV_TYPE0=4 then ' '
	when T2.M_DLV_UNDR0=1 then 'Calculation start schedule' 
	when T2.M_DLV_UNDR0=7 then 'Calculation end schedule'
	when T2.M_DLV_UNDR0=2 then 'Fixing schedule'
	when T2.M_DLV_UNDR0=0 then 'Payment schedule'
	when T2.M_DLV_UNDR0=-1 then ' '
	end as DeliveryBis,
	case when (T7.M_LABEL is NULL) then ' '
	when T2.M_DLV_TYPE0=1 then ' '
	else T7.M_LABEL end as DeliverySubSchedule,
--------
	case 	when (T2.M_SIMP_SCH0 = 0) then 'No'
		when (T2.M_SIMP_SCH0 = 1) then 'Yes'
	end as SingPdLeg1,
--------
	case when (T2.M_FIXING0=0) then 'In advance'  when (T2.M_FIXING0=1) then 'In arrears' end as FixingLeg1 ,
	case when (T2.M_PAYMENT0 = 0 ) then 'In arrears' 
		when (T2.M_PAYMENT0 = 1 ) then 'Up front'
		when (T2.M_PAYMENT0 = 2 ) then 'Up front disc.'
	end as PaymentLeg1,
	case when T2.M_INDEXED0 = 0 then ' ' 
	when T5.M_IND_NAT = 7 then 'At Average'
	when T5.M_IND_NAT=4 and T5.M_FXG_TYP=0 then 'Fixed'
	when T5.M_IND_NAT=4 and T5.M_FXG_TYP=1 then 'Daily'
	else ' '
	end as QuantoType,
	case when (T3.M_RESET <> 3) then ' '
		when (T2.M_RTF_MODE0 = 0) then 'To main Index'
		when (T2.M_RTF_MODE0 = 2) then 'To underlying Index'
	end as RateFactorApplied,
	case when (T2.M_INDEXED0 = 0 ) then 'UNCHECKED' when (T2.M_INDEXED0 = 1 ) then 'CHECKED' end as IndexedLeg1,
	case when (T2.M_INDEXED0 = 0) then ' '
	when (T20.M_SIDE=0) then 'leg1'
	when (T20.M_SIDE=1) then 'leg2' else ' ' 
	end as IndexLeg,
--------
	case when (T2.M_INDEXED0 = 0) then ' ' 
	when (T20.M_TYPE is NULL) then ' '
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
	end as IndListTyp,
--------
	case when (T2.M_INDEXED0 = 0) then ' '
	when (T5.M_RAT_TYPE is NULL) then ' ' 
	when (T5.M_RAT_TYPE=0) then 'Floating'
	when (T5.M_RAT_TYPE=1) then 'Fixed'
	when (T5.M_RAT_TYPE=2) then 'Optional'
	end as IndType,
--------
	case when (T2.M_INDEXED0 = 0) then ' '
	when  T5.M_RAT_TYPE <> 0 then ' '
	when (T5.M_IND_NAT is NULL) then ' ' 
	when (T5.M_IND_NAT=0) then 'Rate'
	when (T5.M_IND_NAT=1) then 'Equity price'
	when (T5.M_IND_NAT=2) then 'Bond price'
	when (T5.M_IND_NAT=3) then 'Inflation'
	when (T5.M_IND_NAT=4) then 'FX Spot'
	when (T5.M_IND_NAT=5) then 'Pool Factor'
	when (T5.M_IND_NAT=6) then 'Generic Index'
	when (T5.M_IND_NAT=7) then 'Formula'
	when (T5.M_IND_NAT=8) then 'Commodity'
	end as IndNature,
	case when (T2.M_INDEXED0 = 0) then ' '
	when T6.M_IND_LAB is null then ' '
	when  T5.M_RAT_TYPE <> 0 then ' '
	else T6.M_IND_LAB end as IndexedLab,
--------
	case when (T2.M_INDEXED0 = 0) then ' '
	when (T5.M_RETINRP is null or T5.M_IND_NAT <> 3 or T5.M_RAT_TYPE <> 0 ) then ' '
	when (T5.M_RETINRP=0) then 'Piecewise'
	when (T5.M_RETINRP=1) then 'Linear'
	when (T5.M_RETINRP=2) then 'Log Linear'
	end as RetInterpol,
--------
	case when (T2.M_INDEXED0 = 0) then ' '
	when (T5.M_RSHIFT is NULL or T5.M_IND_NAT <> 3 or T5.M_RAT_TYPE <> 0 ) then ' '
	else T5.M_RSHIFT
	end as RetFixLag,
--------
	case when (T2.M_INDEXED0 = 0) then ' '
	when (T5.M_I_FORMULA is NULL) then ' ' else to_char(T5.M_I_FORMULA) end as IndFormula,
	case when T2.M_INDEXED0 = 0 then ' '
	when (T5.M_OPERAND is NULL) then ' ' 
	when (T5.M_OPERAND=0) then 'Factor (xP)' 
	when (T5.M_OPERAND=1) then 'Spread (+P)' 
	when (T5.M_OPERAND=2) then 'Increase (x(1+P))' 
	when (T5.M_OPERAND=3) then 'Replace (=P)' 
	end as Operand,
--------
	case when (T2.M_INDEXED0 = 0) then ' '
	when (T5.M_FORMULA is NULL) then ' ' 
	when (T5.M_FORMULA=0) then 'Plain index (P) '
	when (T5.M_FORMULA=1) then 'Period Return (P=(P2-P1)/P1)'
	when (T5.M_FORMULA=2) then 'Period Ratio (P=P2/P1)'
	when (T5.M_FORMULA=3) then 'Initial Return (P=(P2-P0)/P0)'
	when (T5.M_FORMULA=4) then 'Initial ratio (P=P2/P0)'
	when (T5.M_FORMULA=5) then 'Inverse (P=(1/P))'
	when (T5.M_FORMULA=6) then 'UserDefined'
	end as IndexedFormula,
--------
	case when (T2.M_INDEXED0 = 0) then ' '
	when T5.M_FORMULA <> 6 or T10.M_BUFFER is null then ' ' else T10.M_BUFFER end as UserFormula,
--------
	case when (T2.M_INDEXED0 = 0) then ' '
	when (T5.M_OPTION is NULL) then ' ' 
	when (T5.M_OPTION=0) then 'No'
	when (T5.M_OPTION=1) then 'Max'
	when (T5.M_OPTION=2) then 'Min'
	when (T5.M_OPTION=3) then 'Collar'
	end as IndOption,
--------
 	case when (T2.M_INDEXED0 = 0) then ' '
	when ((T5.M_OPTION = 0) or (T5.M_STRIKE is null)) then ' ' else to_char(T5.M_STRIKE) end as Strike_FloorStrike,
	case when T2.M_INDEXED0 = 0 then ' '
	when T5.M_OPTION <> 3 or T5.M_STRIKE  is null then ' ' else to_char(T5.M_SSTRIKE) end as CapStrike,
--------
	case when (T2.M_INDEXED0 = 0) then ' '
	when  (T5.M_CMP_MOD=0) then 'Single'
	when  (T5.M_CMP_MOD=1) then 'cumulative'
	else ' ' end as ComputationMode,
--------
	case when (T2.M_INDEXED0 = 0) then ' '
	when (T5.M_SCHED_TYPE is NULL) then ' ' 
	when (T5.M_SCHED_TYPE=0) then 'Equal To'
	when (T5.M_SCHED_TYPE=1) then 'Shifted from'
	end as SchedType, 
--------
	case when (T2.M_INDEXED0 = 0) then ' '
	when (T5.M_UND_SCHED is null) then ' ' 
	when (T5.M_UND_SCHED=0) then 'Payment schedule'
	when (T5.M_UND_SCHED=1) then 'Calculation schedule'
	when (T5.M_UND_SCHED=2) then 'Reset schedule'
	when (T5.M_UND_SCHED=9) then 'Trade Date'
	end as UndSched,
--------
	case when (T2.M_INDEXED0 = 0) then ' ' when (T5.M_SCHED_TYPE=1) then T5.M_SCHED0 else ' ' end as PorP2Shif,
	case when (T2.M_INDEXED0 = 0) then ' ' when (T5.M_SCHED_TYPE=1) then T5.M_SCHED1 else ' ' end as P0orP1Shif,
	case when (T2.M_INDEXED0 = 0) then ' ' when (T5.M_SCHED_TYPE=1) then T5.M_CALENDAR else ' ' end as Calend,
--------
	case when (T2.M_INDEXED0 = 0) then ' ' when (T5.M_FREQ is NULL) then ' ' else to_char(T5.M_FREQ) end as FreqRatio,
--------
	case when (T2.M_INDEXED0 = 0) then ' '
	when (T5.M_DATE_POS is null) then ' ' 
	when (T5.M_DATE_POS=0) then 'Unchecked'
	when (T5.M_DATE_POS=1) then 'Checked'
	end as UpFront,
--------
	case when (T2.M_INDEXED0 = 0) then ' ' when (T5.M_FACTOR is NULL) then ' ' else to_char(T5.M_FACTOR) end as IndFactor,
	case when (T2.M_INDEXED0 = 0) then ' ' when (T5.M_P_FACTOR is NULL) then ' ' else to_char(T5.M_P_FACTOR) end as PriceFactor,
	case when (T2.M_INDEXED0 = 0) then ' ' when (T5.M_REPL is NULL) then ' ' 
	when (T5.M_REPL=0) then 'Unchecked'
	when (T5.M_REPL=1) then 'Checked'
	end as Replacement,
--------
	case when (T2.M_INDEXED0 = 0) then ' '
	when (T5.M_RND_RL0 is NULL) then ' ' 
	when (T5.M_RND_RL0=0) then 'None'
	when (T5.M_RND_RL0=1) then 'Nearest'
	when (T5.M_RND_RL0=2) then 'By default'
	when (T5.M_RND_RL0=3) then 'By excess'
	end as IndeRdngRul,
--------
	case when (T2.M_INDEXED0 = 0) then ' '
	when (T5.M_RND_RLD0 is NULL) or T5.M_RND_RL0=0 then ' ' else to_char(T5.M_RND_RLD0) end as IndRdgDec,
--------
	case when (T2.M_INDEXED0 = 0) then ' '
	when (T5.M_RND_RL1 is NULL) then ' ' 
	when (T5.M_RND_RL1=0) then 'None'
	when (T5.M_RND_RL1=1) then 'Nearest'
	when (T5.M_RND_RL1=2) then 'By default'
	when (T5.M_RND_RL1=3) then 'By excess'
	end as IndPostRdngRul,
--------
	case when (T2.M_INDEXED0 = 0) then ' '
	when (T5.M_RND_RLD1 is NULL) or T5.M_RND_RL1=0 then ' ' else to_char(T5.M_RND_RLD1) end as IndPostRdngDec,
	case when T2.M_INDEXED0 = 0 then ' '
	when (T5.M_P_MARGIN is NULL) then ' ' else to_char(T5.M_P_MARGIN) end as PriceMargin,
--------
	case when (T2.M_CURRENCY0 = T2.M_INTRS_CUR0 and T2.M_CURRENCY0 = T2.M_INTRM_CUR0 and T2.M_CURRENCY0 = T2.M_FINAL_CUR0) then 'UNCHECKED' 
	else 'CHECKED' end as MultiCurrency,
	T2.M_CURRENCY0 as InitialCapital,
	T2.M_INTRS_CUR0 as InterestFlows,
	T2.M_INTRM_CUR0 as IntermediateCapital,
	T2.M_FINAL_CUR0 as FinalCapital,
--------
	case when  (T2.M_ROUND_RUL0 =0 ) then 'None' 
		when  (T2.M_ROUND_RUL0 =1) then 'Nearest'  
		when (T2.M_ROUND_RUL0 =2)  then 'By default'  
		when (T2.M_ROUND_RUL0 =3 ) then 'By excess' 
		when (T2.M_ROUND_RUL0 =4) then 'Currency' 
	end as RdngRulLeg1,
--------
	case when (T2.M_ROUND_RUL0 =1 or T2.M_ROUND_RUL0 =2 or T2.M_ROUND_RUL0 =3) then to_char(T2.M_DECIMALS0)
	else ' ' end as DecLeg1,
--------
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
	end  as StubRateLeg1,
	T2.M_BROK_COND0 as StubCondLeg1,
--------
	T2.M_RSHIFT0 as FixingLag,
--------
	case 	
	when (T2.M_MRG_MODE0= 0) then 'Additive' 	
	when (T2.M_MRG_MODE0= 1) then 'Multiplicative' 	
	when (T2.M_MRG_MODE0= 2) then 'In underlying' 
	end as MarginModeLeg1,
-------
	case when (T2.M_LNGN_FLGS0 = 257 or T2.M_LNGN_FLGS0 = 1281) then 'Average'
	when (T2.M_LNGN_FLGS0 = 1025 or T2.M_LNGN_FLGS0 = 1 or T2.M_LNGN_FLGS0 = 0) then 'Standard' 
	else 'TOBECHECKED'
	end as RateFormula,
	case when (T2.M_LNGN_FLGS0 = 1025 or T2.M_LNGN_FLGS0 = 1281) and T2.M_PROTZ0 = 0 then 'No'
	when (T2.M_LNGN_FLGS0 = 1025 or T2.M_LNGN_FLGS0 = 1281) and  T2.M_PROTZ0 = 1 then 'Yes'
	when (T2.M_LNGN_FLGS0 = 257 or T2.M_LNGN_FLGS0 = 1 or T2.M_LNGN_FLGS0 = 0) then 'Yes'
	else 'TOBECHECKED' end as DayCount,
-------
	case when (T2.M_INIT_CAP0 = 1 ) then 'CHECKED' else 'UNCHECKED' end as InitialExchange,
	case when (T2.M_INTER_CAP0 = 1 ) then 'CHECKED' else 'UNCHECKED' end as IntermediatePayment,
	case when (T2.M_FINAL_CAP0 = 1 ) then 'CHECKED' else 'UNCHECKED' end as FinalExchange,
-------	
	case when T1.M_RAT_DISP<> 4 then ' '
	when T2.M_SETTLE1 = 0 then 'CashSettled'
	when T2.M_SETTLE1 = 1 then 'PhysicalDelivery'
	end as ExerciseLeg2,
-------	
	case when T1.M_RAT_DISP<> 4 then ' '
	 when (T4.M_IND_LAB is null) then ' ' 
	else T4.M_IND_LAB end as IndLeg2,
-------
	case when (T8.M_LABEL is NULL or T2.M_USE_PROF1 = 0 or T1.M_LEG_PROF = 1) then ' ' else T9.M_LABEL end as VolumeProfileLeg2,
-------
	case when T2.M_LEV_MODE1 = 0 then 'Inherited'
		when T2.M_LEV_MODE1 = 1 then 'Accrual sens accrual'
		when T2.M_LEV_MODE1 = 2 then 'Accrual sens MTM'
	end as EvaluationLeg2,
	case when T12.M_LABEL is null or T4.M_IND_LAB is null or T1.M_RAT_DISP<> 4 then ' ' else T12.M_LABEL end as FormulaLeg2,
-------
 	case when (T2.M_DLVTP1 = 0) then 'Currency'
		when (T2.M_DLVTP1 = 1) then 'Commodity'
		when (T2.M_DLVTP1 = 2) then 'Bond'
		when (T2.M_DLVTP1 = 3) then 'Equity'
	end as InstrTypLeg2,
	case when T2.M_DLVTP1 = 0 then T2.M_CURRENCY1 else ' ' end as CurrencyLeg2,
	case when T17.M_LABEL is null then ' ' else T17.M_LABEL end as ComLeg2,
	case when ((T1.M_FLAGS =4 ) or (T1.M_FLAGS =516)) then T2.M_EXT_FREQ1 
	else ' ' end as FrequencyLeg2,
	case when  ((T1.M_FLAGS <> 8 ) and (T1.M_FLAGS <> 520)) then ' ' else T2.M_START1 end as StDelayLeg2,
	case when ((T1.M_FLAGS <> 8 ) and (T1.M_FLAGS <> 520))  then ' ' else T2.M_PAY_CLN1 end as PayCalLeg2,
	case when (T1.M_RAT_DISP <> 4 or ((T1.M_FLAGS <> 8 ) and (T1.M_FLAGS <> 520)))  then ' ' else T2.M_FIX_CLN1 end as FixCalLeg2,
-------
	case when  (T1.M_FLAGS <> 8 ) and (T1.M_FLAGS <> 520) then ' ' 
		when (T2.M_ECP_TYPE1 = 0) then 'Driving schedule'
		when (T2.M_ECP_TYPE1 = 1) then 'Equal to'
		when (T2.M_ECP_TYPE1 = 2) then 'Deduced from'
	end as CalcStSch1Leg2,
	case when ((T1.M_FLAGS <> 8 ) and (T1.M_FLAGS <> 520)) then ' ' 
		when (T2.M_ECP_UNDRL1 = -1) then ' '
		when (T2.M_ECP_UNDRL1 = 0) then 'Payment schedule' 
		when (T2.M_ECP_UNDRL1 = 2) then 'Fixing schedule'
		when (T2.M_ECP_UNDRL1= 7) then 'Calculation end schedule'
		when (T2.M_ECP_UNDRL1 = 8) then 'Delivery schedule'
	else ' ' end as CalcSt2Leg2,
-------
	case when ((T1.M_FLAGS <> 8 ) and (T1.M_FLAGS <> 520)) then ' ' 
		else T2.M_ECP1 end as CalcSt3Leg2,
-------
	case when ((T1.M_FLAGS <> 8 ) and (T1.M_FLAGS <> 520)) then ' ' 
		when (T2.M_ECPE_TYPE1 = 0) then 'Driving schedule'
		when (T2.M_ECPE_TYPE1 = 1) then 'Equal to'
		when (T2.M_ECPE_TYPE1 = 2) then 'Deduced from'
	end as CalcEndSch1Leg2,
-------
	case when (T1.M_FLAGS <> 8 ) and (T1.M_FLAGS <> 520) then ' ' 
		when (T2.M_ECPE_UNDR1 = -1) then ' '
		when (T2.M_ECPE_UNDR1 = 0) then 'Payment schedule' 
		when (T2.M_ECPE_UNDR1= 1) then 'Calculation start schedule'
		when (T2.M_ECPE_UNDR1 = 2) then 'Fixing schedule'
		when (T2.M_ECPE_UNDR1 = 8) then 'Delivery schedule'
	end as CalcEndSch2Leg2,
	case when (T1.M_FLAGS <> 8 ) and (T1.M_FLAGS <> 520) then ' ' 
		else T2.M_ECPE0 end as CalcEndSch3Leg2,
	case	when (T1.M_FLAGS <> 8 ) and (T1.M_FLAGS <> 520) then ' ' 
		when (T2.M_EP_TYPE1 = 0) then 'Driving schedule'
		when (T2.M_EP_TYPE1 = 1) then 'Equal to'
		when (T2.M_EP_TYPE1 = 2) then 'Deduced from'
	end as PaySch1Leg2,
-------
	case	when (T1.M_FLAGS <> 8 ) and (T1.M_FLAGS <> 520) then ' ' 
		when ((T2.M_EP_UNDRL1 = -1) or (T2.M_EP_UNDRL1 = 0))then ' '
		when (T2.M_EP_UNDRL1= 1) then 'Calculation start schedule'
		when (T2.M_EP_UNDRL1 = 2) then 'Fixing schedule'
		when (T2.M_EP_UNDRL1 = 7) then 'Calculation end schedule'
		when (T2.M_EP_UNDRL1 = 8) then 'Delivery schedule'
	end as PaySch2Leg2,
	case  when(T1.M_FLAGS <> 8 ) and (T1.M_FLAGS <> 520) then ' ' 
	else T2.M_EP1 end as PaySc3Leg2,
	case when(T1.M_FLAGS <> 8 ) and (T1.M_FLAGS <> 520) then ' ' 
		else to_char(T2.M_EP_FREQ1) end as PayFrqLeg2,
	case  when(T1.M_FLAGS <> 8 ) and (T1.M_FLAGS <> 520) then ' ' 
		when (T2.M_EI_TYPE1 = 0) then 'Driving schedule'
		when (T2.M_EI_TYPE1 = 1) then 'Equal to'
		when (T2.M_EI_TYPE1 = 2) then 'Deduced from'
	end as FixSch1Leg2,
	case	when(T1.M_FLAGS <> 8 ) and (T1.M_FLAGS <> 520) then ' ' 
		when (T2.M_EI_UNDRL1 = -1)   then ' '
		when (T2.M_EI_UNDRL1= 1) then 'Calculation start schedule'
		when (T2.M_EI_UNDRL1 = 7) then 'Calculation end schedule'
		when (T2.M_EI_UNDRL1 = 0) then 'Payment schedule'
	end as FixSch2Leg2,
	case when (T1.M_FLAGS <> 8 ) and (T1.M_FLAGS <> 520) then ' ' 
	else T2.M_EI1 end as FixSch3Leg2,
	case when (T1.M_FLAGS <> 8 ) and (T1.M_FLAGS <> 520) then ' ' 
	else to_char(T2.M_EI_FREQ1) end as FixFrqLeg2,	
-------
	case  when(T1.M_FLAGS <> 8 ) and (T1.M_FLAGS <> 520) then ' ' 
		when T2.M_DLV_TYPE1=1 then 'Equal to' 
     		when T2.M_DLV_TYPE1=4 then 'Manual Schedule'             
	end as DeliveryScheduleLeg2,     
-------	
	case when(T1.M_FLAGS <> 8 ) and (T1.M_FLAGS <> 520) then ' ' 
		when (T15.M_LABEL is NULL) then ' ' else T15.M_LABEL end as DeliverySubScheduleLeg2,
-------
	case when (T1.M_FLAGS <> 8 ) and (T1.M_FLAGS <> 520) then ' ' 
		when (T2.M_SIMP_SCH1 = 0) then 'No'
		when (T2.M_SIMP_SCH1 = 1) then 'Yes'
	end as SingPdLeg2,
-------
	case when (T1.M_RAT_DISP <> 4) then ' '
		when (T2.M_FIXING1=0) then 'In advance'  
		when (T2.M_FIXING1=1) then 'In arrears' 
	end as FixLeg2,
	case when (T2.M_PAYMENT1 = 0 ) then 'In arrears' 
		when (T2.M_PAYMENT1 = 1 ) then 'Up front'  
		when (T2.M_PAYMENT1 = 2 ) then 'Up front disc.'
	end as PayLeg2,
	case when (T4.M_RESET <> 3) or (T1.M_RAT_DISP <> 4) then ' '
		when T2.M_RTF_MODE1 = 0 then 'To main Index'
		when T2.M_RTF_MODE1 = 2 then 'To underlying Index'
	end as RateFactorAppliedLeg2,
	case when (T2.M_INDEXED1 = 0 ) then 'UNCHECKED' when (T2.M_INDEXED1 = 1 ) then 'CHECKED' end as IndexedLeg2,
	case when (T2.M_CURRENCY1 = T2.M_INTRS_CUR1 and T2.M_CURRENCY1 = T2.M_INTRM_CUR1 and T2.M_CURRENCY1 = T2.M_FINAL_CUR1) then 'UNCHECKED' 
	else 'CHECKED' end as MultiCurrencyLeg2,
	T2.M_CURRENCY1 as InitialCapitalLeg2,
	T2.M_INTRS_CUR1 as InterestFlowsLeg2,
	T2.M_INTRM_CUR1 as IntermediateCapitalLeg2,
	T2.M_FINAL_CUR1 as FinalCapitalLeg2,
-------
	case when  (T2.M_ROUND_RUL1 =0 ) then 'None' when  (T2.M_ROUND_RUL1 =1) then 'Nearest'  
		when (T2.M_ROUND_RUL1 =2)  then 'By default'  when (T2.M_ROUND_RUL1 =3 ) then 'By excess' 
		when (T2.M_ROUND_RUL1 =4) then 'Currency' 
	end as RdngRulLeg2,
	case when (T2.M_ROUND_RUL1 =1 or T2.M_ROUND_RUL1 =2 or T2.M_ROUND_RUL1 =3) then to_char(T2.M_DECIMALS1)
	else ' ' end as DecLeg2,
-------
	case when (T2.M_BROK_COUP1= 0) then 'Short Coupon'
		when (T2.M_BROK_COUP1= 1) then 'Long Coupon'
		when (T2.M_BROK_COUP1= 3) then 'Full Coupon'
		when (T2.M_BROK_COUP1= 4) then 'Conditional'
	end as CoupLeg2,
	case when (T2.M_BROK_IND1=0) then 'Current Index'
		when (T2.M_BROK_IND1=1) then 'Closest Index'
		when (T2.M_BROK_IND1=2) then 'Next Index'
		when (T2.M_BROK_IND1=3) then 'Previous Index'
		when (T2.M_BROK_IND1=4) then 'Interpolated'
	end  as StubPerRate2,
	T2.M_BROK_COND1 as StubCond2,
	case when (T1.M_RAT_DISP <> 4) then ' '
	when (T2.M_MRG_MODE1= 0) then 'Additive' 	
	when (T2.M_MRG_MODE1= 1) then 'Multiplicative' 	
	when (T2.M_MRG_MODE1= 2) then 'In underlying' 
	end as MarginModeLeg2,
	case when (T1.M_RAT_DISP <> 4) then ' '
	when (T2.M_LNGN_FLGS1 = 257 or T2.M_LNGN_FLGS1 = 1281) then 'Average'
	when (T2.M_LNGN_FLGS1 = 1025 or T2.M_LNGN_FLGS1 = 1 or T2.M_LNGN_FLGS0 = 0) then 'Standard' 
	else 'TOBECHECKED'
	end as RateFormulaLeg2,
	case when ((T2.M_LNGN_FLGS1 = 1025 or T2.M_LNGN_FLGS1 = 1281) and T2.M_PROTZ1 = 0) then 'No'
	when ((T2.M_LNGN_FLGS1 = 1025 or T2.M_LNGN_FLGS1 = 1281) and  T2.M_PROTZ1 = 1) then 'Yes'
	when ((T2.M_LNGN_FLGS1 = 257 or T2.M_LNGN_FLGS1 = 1) or T2.M_LNGN_FLGS0 = 0) then 'Yes'
	else 'TOBECHECKED' end as DayCountLeg2,
-------
	case when (T2.M_INIT_CAP1 = 1 ) then 'CHECKED' else 'UNCHECKED' end as InitialExchangeLeg2,
	case when (T2.M_INTER_CAP1 = 1 ) then 'CHECKED' else 'UNCHECKED' end as IntermediatePaymentLeg2,
	case when (T2.M_FINAL_CAP1 = 1 ) then 'CHECKED' else 'UNCHECKED' end as FinalExchangeLeg2,
        case when floor(T1.M_FLAGS / 16384) = (floor(T1.M_FLAGS / (16384*2)) * 2) then 'No' else 'Yes' end as Generic
-------
from RT_INSGN_DBF T1, RT_LNGN_DBF T2 
-------
left outer join RT_INDEX_DBF  T3 on T2.M_INDEX0 = T3.M_INDEX
left outer join RT_INDEX_DBF  T4 on T2.M_INDEX1 = T4.M_INDEX
left outer join RT_LNDXGL_DBF T20 left outer join RT_LNDXG_DBF T5 on T20.M_REF_INDEXATION_TEMPL=T5.M_REFERENCE on T2.M_REFERENCE=T20.M_REF_LOAN_GENERATOR
left outer join RT_INDEX_DBF T6 on T5.M_INDEX=T6.M_INDEX
left outer join DLV_SCHED_DBF T7 on T7.M_REFERENCE=T2.M_DLV_SUB0
left outer join CM_PROFH_DBF T8 on T8.M_REFERENCE=T2.M_PROFILE0
left outer join CM_PROFH_DBF T9 on T9.M_REFERENCE=T2.M_PROFILE1
left outer join FRM_FILE_DBF T10 on T10.M_GROUP=T5.M_FOR_ID
left outer join CM_MKTSR_DBF T11 on rtrim(TRIM(LEADING 'P' from T2.M_FORMULA0))=to_char(T11.M_SERIE)
left outer join CM_MKTSR_DBF T12 on rtrim(TRIM(LEADING 'P' from T2.M_FORMULA1)) = to_char(T12.M_SERIE)
left outer join DLV_SCHED_DBF T15 on T15.M_REFERENCE=T2.M_DLV_SUB1
left outer join CM_PHYS_DBF T16 on T2.M_DLVID0=T16.M_REFERENCE
left outer join CM_PHYS_DBF T17 on T2.M_DLVID1=T17.M_REFERENCE
-------
where	T1.M_GEN_NUM = T2.M_GEN_NUM
and 	T1.M_INSTR_TYPE = 13
and	T1.M_CREAT_MODE = 0
order by T1.M_INSTR,T6.M_IND_LAB;
quit;
SPOOL OFF;