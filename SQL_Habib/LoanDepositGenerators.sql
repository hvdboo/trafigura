set colsep '#';
SET TERMOUT OFF;
SPOOL &1;
set linesize 1720;
set pagesize 2048;
select  T1.M_INSTR as LoanGenerator,T1.M_INSTR_DESC as Description,T1.M_NB_LEG as NbLegs,T1.M_NB_PHASE as NbPhases, 
case	when (T1.M_EVAL_MODE = 0) then 'Default'
		when (T1.M_EVAL_MODE = 1) then 'MTM'
		when (T1.M_EVAL_MODE = 2) then 'Accrual'
	end as EvaluationMode,
	case 	when (T2.M_RATE_TYPE0  = 0) then 'Fixed rate' when (T2.M_RATE_TYPE0= 1) then 'Floating rate' end as RateType,
	case when T3.M_IND_LAB is null then ' ' else T3.M_IND_LAB end as FloatingIndex,T2.M_START0 as StartDelay,
	T2.M_CURRENCY0 as PaymentCurrency, CAST(T2.M_PAY_CLN0 AS VARCHAR2(15)) as PaymentCalendar,
	case when (M_RAT_DISP in (1,2))  then ' ' else CAST(T2.M_FIX_CLN0 AS VARCHAR2(15)) end as FixCalLeg1,
	case	when ((T2.M_RATE_TYPE0= 1) and (T2.M_FIXING0 = 0 )) then 'In advance'
		when ((T2.M_RATE_TYPE0= 1) and (T2.M_FIXING0 = 1 )) then 'In arrears'
		else ' '  end  as Fixing,
	case	when (T2.M_PAYMENT0 = 0) then 'In arrears' when  (T2.M_PAYMENT0 = 1) then 'Up front' 	
	    	when (T2.M_PAYMENT0 = 2) then 'Up front disc.'end as Payment ,
	T2.M_RATE_CONV0 as RateConvention,
	case	when (T2.M_ROUND_RUL0 = 0) then 'None' when (T2.M_ROUND_RUL0 = 1) then 'Nearest' when (T2.M_ROUND_RUL0 = 2) then 'By default' 
		when (T2.M_ROUND_RUL0 = 3) then 'By excess' end as RoundingRule,
	T2.M_DECIMALS0 as Decimals,
	case	when (T2.M_AMORT0 = 0 ) then 'None'
		when (T2.M_AMORT0 = 1 ) then 'Linear (rate)'
		when (T2.M_AMORT0 = 2 ) then 'Constant'
		when (T2.M_AMORT0 = 3 ) then 'Constant annuities' 
		when (T2.M_AMORT0 = 4 ) then 'Constant number of shares' 
		when (T2.M_AMORT0 = 5) then 'Coupon reinvestment'
		when (T2.M_AMORT0 = 6 ) then 'Constant annuities (r)' 
		when (T2.M_AMORT0 = 7 ) then 'Linear (amount)' 
		when (T2.M_AMORT0 = 8 ) then 'Dividends reinvestment (in new shares)'
	end as Amortizing,
	case	when (T1.M_BROKEN =0 ) then 'Up front'
		when (T1.M_BROKEN =1 ) then 'In arrears' 
		when (T1.M_BROKEN=3 ) then 'Both ends (backward)'
		when (T1.M_BROKEN = 5) then 'Both ends (forward)' 
	end as StubPosition ,
	case	when (T2.M_BROK_COUP0 =0 ) then 'Short coupon'   
		when (T2.M_BROK_COUP0 =1 ) then 'Long coupon' 
		when (T2.M_BROK_COUP0 =3 ) then 'Full coupon' 
		when (T2.M_BROK_COUP0 = 4) then 'Conditional'  
	end as Coupon ,
	case	when  (T2.M_BROK_IND0  =0 ) then 'Current index'  
		when  (T2.M_BROK_IND0  = 1 ) then 'Closest index'  
		when  (T2.M_BROK_IND0  = 2) then 'Next index'
		when  (T2.M_BROK_IND0  = 3) then 'Previous index'  
		when  (T2.M_BROK_IND0  = 4) then 'Interpolated' 
	end as StubPeriodRate,
	case 	when (T2.M_CONVERT0 = 0 ) then  'No' when (T2.M_CONVERT0= 1) then 'Yes' end as RateConversion, 
	case 	when (T2.M_INDEXED0 = 0 ) then  'No' when (T2.M_INDEXED0 = 1) then 'Yes' end as Indexed, 
	case 	when (T2.M_GRNTEED0= 0 ) then  'No' when (T2.M_GRNTEED0 = 1) then 'Yes' end as Guaranteed, 
 -------
 -------
 /*------------------*/
case	when (M_RAT_DISP =1 and (M_FLAGS=1 or M_FLAGS=4 )) then ' '
		when (M_RAT_DISP =1 and (M_FLAGS=0 or M_FLAGS=2 )) and (T2.M_ECP_TYPE1 = 0) then 'Driving schedule'
		when (M_RAT_DISP =1 and (M_FLAGS=0 or M_FLAGS=2 )) and (T2.M_ECP_TYPE1 = 1) then 'Equal to'
		when (M_RAT_DISP =1 and (M_FLAGS=0 or M_FLAGS=2 )) and (T2.M_ECP_TYPE1 = 2) then 'Deduced from'
		when ( M_RAT_DISP <>1 or (M_FLAGS<>1 and M_FLAGS<>4 ))and  (T2.M_ECP_TYPE0 = 0) then 'Driving schedule'
		when ( M_RAT_DISP <>1 or (M_FLAGS<>1 and M_FLAGS<>4 )) and (T2.M_ECP_TYPE0 = 1) then 'Equal to'
		when ( M_RAT_DISP <>1 or (M_FLAGS<>1 and M_FLAGS<>4 )) and (T2.M_ECP_TYPE0 = 2) then 'Deduced from'
	end as CalcStSch1Leg1,
 -------
	case	when ( M_RAT_DISP <>1 or (M_FLAGS<>1 and M_FLAGS<>4 )) and  (T2.M_ECP_TYPE0 = 0) then ' ' 
		when (M_RAT_DISP =1 and (M_FLAGS=1 or M_FLAGS=4 )) then ' '
		when (M_RAT_DISP =1 and (M_FLAGS=0 or M_FLAGS=2 )) and (T2.M_ECP_UNDRL1  = -1) then ' '
		when (M_RAT_DISP =1 and (M_FLAGS=0 or M_FLAGS=2 )) and ((T2.M_ECP_UNDRL1 = 0) and (T2.M_ECP_TYPE1 <>0)) then 'Payment schedule' 
		when (M_RAT_DISP =1 and (M_FLAGS=0 or M_FLAGS=2 )) and (T2.M_ECP_UNDRL1 = 2) then 'Fixing schedule'
		when (M_RAT_DISP =1 and (M_FLAGS=0 or M_FLAGS=2 )) and (T2.M_ECP_UNDRL1 = 7) then 'Calculation end schedule'
		when (M_RAT_DISP =1 and (M_FLAGS=0 or M_FLAGS=2 )) and (T2.M_ECP_UNDRL1 = 8) then 'Delivery schedule'
		when ( M_RAT_DISP <>1 or (M_FLAGS<>1 and M_FLAGS<>4 )) and (T2.M_ECP_UNDRL0 = -1) then ' '
		when ( M_RAT_DISP <>1 or (M_FLAGS<>1 and M_FLAGS<>4 )) and (T2.M_ECP_UNDRL0 = 0) then 'Payment schedule' 
		when ( M_RAT_DISP <>1 or (M_FLAGS<>1 and M_FLAGS<>4 )) and (T2.M_ECP_UNDRL0 = 2) then 'Fixing schedule'
		when ( M_RAT_DISP <>1 or (M_FLAGS<>1 and M_FLAGS<>4 )) and (T2.M_ECP_UNDRL0= 7) then 'Calculation end schedule'
		when ( M_RAT_DISP <>1 or (M_FLAGS<>1 and M_FLAGS<>4 )) and (T2.M_ECP_UNDRL0 = 8) then 'Delivery schedule'
	else ' ' end as CalcSt2Leg1,
case 	when (M_RAT_DISP =1) and (M_FLAGS=1 or M_FLAGS=4 ) or (T2.M_ECP_TYPE0 = 1) then ' '
                     when  (M_FLAGS=1 or M_FLAGS=4 ) and (T2.M_ECP_TYPE1 = 1)  then ' '
	else CAST(T2.M_ECP0 AS VARCHAR2(25)) end as CalcSt3Leg1,
	case	when (M_RAT_DISP =1 and (M_FLAGS=1 or M_FLAGS=4 )) then ' '													
		when (M_RAT_DISP =1 and (M_FLAGS=0 or M_FLAGS=2 )) and (T2.M_ECPE_TYPE1 = 0) then 'Driving schedule'
		when (M_RAT_DISP =1 and (M_FLAGS=0 or M_FLAGS=2 )) and (T2.M_ECPE_TYPE1= 1) then 'Equal to'
		when (M_RAT_DISP =1 and (M_FLAGS=0 or M_FLAGS=2 )) and (T2.M_ECPE_TYPE1 = 2) then 'Deduced from'
		when ( M_RAT_DISP <>1 or (M_FLAGS<>1 and M_FLAGS<>4 ))and  (T2.M_ECPE_TYPE0 = 0) then 'Driving schedule'
		when ( M_RAT_DISP <>1 or (M_FLAGS<>1 and M_FLAGS<>4 )) and (T2.M_ECPE_TYPE0 = 1) then 'Equal to'
		when ( M_RAT_DISP <>1 or (M_FLAGS<>1 and M_FLAGS<>4 )) and (T2.M_ECPE_TYPE0 = 2) then 'Deduced from'
	end as CalcEndSch1Leg1,
	case	when (M_RAT_DISP =1 and (M_FLAGS=1 or M_FLAGS=4 )) then ' '
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
	end as CalcEndSch2Leg1,
	case	when (M_RAT_DISP =1 and (M_FLAGS=1 or M_FLAGS=4 ) or T2.M_ECPE_TYPE0 = 1) then ' '
	when (M_FLAGS=1 or M_FLAGS=4 ) and  (T2.M_ECPE_TYPE1 = 1) then ' ' else CAST(T2.M_ECPE0 AS VARCHAR2(25)) end as CalcEndSch3Leg1, 
	case	when (M_RAT_DISP =1 and (M_FLAGS=1 or M_FLAGS=4 )) then ' '
		when (M_RAT_DISP =1 and (M_FLAGS=0 or M_FLAGS=2 )) and (T2.M_EP_TYPE1 = 0) then 'Driving schedule'
		when (M_RAT_DISP =1 and (M_FLAGS=0 or M_FLAGS=2 )) and (T2.M_EP_TYPE1= 1) then 'Equal to'
		when (M_RAT_DISP =1 and (M_FLAGS=0 or M_FLAGS=2 )) and (T2.M_EP_TYPE1= 2) then 'Deduced from'
		when ( M_RAT_DISP <>1 or (M_FLAGS<>1 and M_FLAGS<>4 ))and  (T2.M_EP_TYPE0 = 0) then 'Driving schedule'
		when ( M_RAT_DISP <>1 or (M_FLAGS<>1 and M_FLAGS<>4 )) and (T2.M_EP_TYPE0 = 1) then 'Equal to'
		when ( M_RAT_DISP <>1 or (M_FLAGS<>1 and M_FLAGS<>4 )) and (T2.M_EP_TYPE0 = 2) then 'Deduced from'
	end as PaySch1Leg1,
	case	when (M_RAT_DISP =1 and (M_FLAGS=1 or M_FLAGS=4 )) then ' '
		when ( M_RAT_DISP <>1 or (M_FLAGS<>1 and M_FLAGS<>4 )) and  (T2.M_EP_TYPE0 = 0) then ' '
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
	end as PaySch2Leg1,
	case	 when (M_RAT_DISP =1 and (M_FLAGS=1 or M_FLAGS=4 ) or (T2.M_EP_TYPE0 = 1)) then ' '
                    when (M_FLAGS=1 or M_FLAGS=4 ) and (T2.M_EP_TYPE1 = 1) then ' ' else to_char(T2.M_EP0) end as PaySc3Leg1,
	case	when (M_RAT_DISP =1 and (M_FLAGS=1 or M_FLAGS=4 ) or T2.M_EP_FREQ0 in (-1,-2)) then ' '
                 when  (M_FLAGS=1 or M_FLAGS=4 )  and (T2.M_EP_FREQ1 in (-1,-2)) then ' ' else to_char(T2.M_EP_FREQ0) end as PayFrqLeg1,
	case	when ((M_RAT_DISP =1) or (M_RAT_DISP =2))  then ' '														
		when ( M_RAT_DISP <>1 or (M_FLAGS<>1 and M_FLAGS<>4 ))and  (T2.M_EI_TYPE0 = 0) then 'Driving schedule'
		when ( M_RAT_DISP <>1 or (M_FLAGS<>1 and M_FLAGS<>4 )) and (T2.M_EI_TYPE0 = 1) then 'Equal to'
		when ( M_RAT_DISP <>1 or (M_FLAGS<>1 and M_FLAGS<>4 )) and (T2.M_EI_TYPE0 = 2) then 'Deduced from'
	end as FixSch1Leg1,
	case	when ( M_RAT_DISP <>1 or (M_FLAGS<>1 and M_FLAGS<>4 )) and  (T2.M_EI_TYPE0 = 0) then ' '
		when ((M_RAT_DISP =1) or (M_RAT_DISP =2))  then ' '
		when (( M_RAT_DISP <>1 or (M_FLAGS<>1 and M_FLAGS<>4 )) and (T2.M_EI_UNDRL0 = -1))   then ' '
		when ( M_RAT_DISP <>1 or (M_FLAGS<>1 and M_FLAGS<>4 )) and (T2.M_EI_UNDRL0= 1) then 'Calculation start schedule'
		when ( M_RAT_DISP <>1 or (M_FLAGS<>1 and M_FLAGS<>4 )) and (T2.M_EI_UNDRL0 = 7) then 'Calculation end schedule' 
		when ( M_RAT_DISP <>1 or (M_FLAGS<>1 and M_FLAGS<>4 )) and (T2.M_EI_UNDRL0 = 0) then 'Payment schedule'
	end as FixSch2Leg1,
	case when (M_RAT_DISP =1 and (M_FLAGS=1 or M_FLAGS=4 ) or (T2.M_EP_TYPE0 <> 2)) then ' '
                   when (M_FLAGS=1 or M_FLAGS=4 ) and (T2.M_EP_TYPE1 = 1) then ' '  else to_char(T2.M_EI0) end as FixSch3Leg1 ,
	case when (M_RAT_DISP =1 and (M_FLAGS=1 or M_FLAGS=4 ) or T2.M_EI_FREQ0 in (-1,-2)) then ' '
                   when (M_FLAGS=1 or M_FLAGS=4 ) and (T2.M_EI_FREQ1 in (-1,-2)) then ' '	else to_char(T2.M_EI_FREQ0) end as FixFrqLeg1,						
	case when (M_RAT_DISP =1 and (M_FLAGS=1 or M_FLAGS=4 )) then ' '
		when (M_RAT_DISP =1 and (M_FLAGS=0 or M_FLAGS=2 )) and (T2.M_SIMP_SCH1 = 0) then 'No'
		when (M_RAT_DISP =1 and (M_FLAGS=0 or M_FLAGS=2 )) and (T2.M_SIMP_SCH1 = 1) then 'Yes'
		when (M_RAT_DISP <>1 or (M_FLAGS<>1 and M_FLAGS<>4 ))and  (T2.M_SIMP_SCH0 = 0) then 'No'
		when (M_RAT_DISP <>1 or (M_FLAGS<>1 and M_FLAGS<>4 )) and (T2.M_SIMP_SCH0 = 1) then 'Yes'
	end as SingPdLeg1,
 -------
/*------------------------*/
	case	when (T2.M_ACC_METH0 = 0 ) then 'Use interest convention'  
		when (T2.M_ACC_METH0 = 1 ) then 'Specific convention'
		when (T2.M_ACC_METH0 = 2 ) then 'External'  
		when (T2.M_ACC_METH0 = 3 ) then 'Prorate interest'
	end as AccrualMethod, 
	CAST(T2.M_ACC_CONV0 AS VARCHAR2(20)) as AccrualConvention,
	case	when (T2.M_ACC_ROUND0 = 0) then 'None' 
		when (T2.M_ACC_ROUND0 = 1) then 'Nearest' 
		when (T2.M_ACC_ROUND0 = 2) then 'By default' 
		when (T2.M_ACC_ROUND0 = 3) then 'By excess' 
	end as AccrualRoundingRule,
	T2.M_ACC_DEC0 as AccrualDecimals, 
	case	when (T2.M_ACC_RMODE0 =0 ) then 'Standard' 
		when (T2.M_ACC_RMODE0 =1) then 'Ex-dividend' 
	end as AccrualRoundingMode,
	case 	when (T2.M_YLD_CALC0 = 0 ) then 'AIBD' 
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
		when (T2.M_YLD_CALC0 = 50) then 'External'
	end as YielCalculation, 
	T2.M_YLD_CONV0 as YielConvention, 
	case 	when (T2.M_YLD_SCHED0 = 0) then 'Anniversary schedule' 
		when (T2.M_YLD_SCHED0 = 1) then 'Payment schedule' 
	end as  YieldSchedule,
	case 	when ( T2.M_YLD_FREQ0 = 0) then 'at coupon frequency (standard)'
		when ( T2.M_YLD_FREQ0 = 1) then 'Annual compounding'
	end as YieldFrequency,
	case	when ( T2.M_GC_ACC0 = 0) then 'Standard' when ( T2.M_GC_ACC0 = 1) then 'Specific convention' end as GrossToCleanAccrual ,
	case 	when ( T2.M_ALT_YL0 = 0 ) then 'No' 
		when ( T2.M_ALT_YL0 = 1) then 'During last period'
		when ( T2.M_ALT_YL0 = 2 ) then 'During last year'
		when ( T2.M_ALT_YL0 = 3 ) then 'During last period + ExDiv'
	end as AlternateYield ,
	CAST(T2.M_ALT_YLCNV0 AS VARCHAR2(25)) as AlternateYieldConvention,
	case 	when (T2.M_FINAL_CAP0 =  1) then 'Yes' when (T2.M_FINAL_CAP0 = 2) then 'No' end as FinalCapitalExchange ,	
	case 	when (T2.M_INTER_CAP0 = 1) then 'Yes' when (T2.M_INTER_CAP0 = 2) then 'No' end as IntermediateCapitalExchange,
	case	when (T2.M_RETINT0 = 0) then 'Return (P2-P1)/P1' when (T2.M_RETINT0 = 1) then 'Spread (P2-P1)' end as ReturnType
-------
from RT_INSGN_DBF T1, RT_LNGN_DBF T2
left outer join RT_INDEX_DBF  T3 on T2.M_INDEX0 = T3.M_INDEX
 -------
where	T1.M_GEN_NUM = T2.M_GEN_NUM
and 	T1.M_INSTR_TYPE = 3
and	T1.M_CREAT_MODE = 0
-------
order by T1.M_INSTR;
quit;
