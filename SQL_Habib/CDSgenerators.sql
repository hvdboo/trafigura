set colsep '#';
SET TERMOUT OFF;
SPOOL &1;
set linesize 1870;
set pagesize 2048;
select  T1.M_INSTR  as CDSgenerator, T1.M_INSTR_DESC as Description,
case when (T2.M_RATE_TYPE0 = 0) then 'Fixed rate' 
	when (T2.M_RATE_TYPE0 = 1 ) then 'Floating rate' 
end as RateType, 
case when (T2.M_RATE_TYPE0  = 0) then ' ' else T4.M_IND_LAB end as FloatingIndex , 
CAST(T1.M_SING_CURR AS VARCHAR2(16)) as PaymentCurrency, T2.M_START0 as StartDelay,
case when (T1.M_SETTL_MOD = 0 ) then 'Inherited from currency' 
	when (T1.M_SETTL_MOD = 1 ) then 'Specific delay' 
end as SettlementDelay,
T1.M_SETTL as Settlement,
case when (T6.M_UPF_D_M = 0 ) then 'Inherited from currency' 
	when (T6.M_UPF_D_M = 1 ) then 'Specific delay' 
end as UpFrontPaymentDelay,
T6.M_UPF_D_G as UpFrontPayment,
CAST(T2.M_PAY_CLN0 AS VARCHAR2(16)) as PaymentCalendar,
case when (T2.M_RATE_TYPE0  = 0) then ' '
	else T2.M_FIX_CLN0 end as FixingCalendar,
case when (T2.M_RATE_TYPE0 = 1 ) and (T2.M_FIXING0 = 0 ) then 'In advance' 
	when (T2.M_RATE_TYPE0 = 1 ) and (T2.M_FIXING0 = 1) then 'In arrears' else ' ' 
end  as Fixing, 
-------
/*---------*/
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
                     else to_char(T2.M_ECP0) end as CalcSt3Leg1,
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
                 when (M_FLAGS=1 or M_FLAGS=4 ) and  (T2.M_ECPE_TYPE1 = 1) then ' ' else  to_char(T2.M_ECPE0) end as CalcEndSch3Leg1,
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
	case when (M_RAT_DISP =1 and (M_FLAGS=1 or M_FLAGS=4 ) or (T2.M_EP_TYPE0 = 1)) then ' '
                   when (M_FLAGS=1 or M_FLAGS=4 ) and (T2.M_EP_TYPE1 = 1) then ' '  else to_char(T2.M_EI0) end as FixSch3Leg1 ,
	case when (M_RAT_DISP =1 and (M_FLAGS=1 or M_FLAGS=4 ) or T2.M_EI_FREQ0 in (-1,-2)) then ' '
                   when (M_FLAGS=1 or M_FLAGS=4 ) and (T2.M_EI_FREQ1 in (-1,-2)) then ' '	else to_char(T2.M_EI_FREQ0) end as FixFrqLeg1,						
-------
-------
/*---------*/
case when T2.M_FOLW_FXNG0 = 0 then 'No (time series)'
	when T2.M_FOLW_FXNG0 = 1 then 'Yes (time series)'
	when T2.M_FOLW_FXNG0 = 2 then 'No (published)'
	when T2.M_FOLW_FXNG0 = 3 then 'Yes (published)'
end as CalculationsFollowFixings,
case when (T2.M_SIMP_SCH0 = 0) then 'No' else 'Yes' end as SinglePeriod,
case when (T2.M_PAYMENT0 = 0) then 'In arrears' when (T2.M_PAYMENT0 = 1) then 'Up front' 
	when (T2.M_PAYMENT0 = 2) then 'Up front disc.'  end as Payment,
T2.M_RATE_CONV0 as RateConvention, 
case when (T2.M_REVOLV0 = 0) then 'UNCHECKED'  when (T2.M_REVOLV0 = 1) then 'CHECKED'  end as Revolving,
case when (T2.M_ACC_METH0 = 0 ) then 'Use interest convention'  
	when (T2.M_ACC_METH0 = 1 ) then 'Specific convention'
	when (T2.M_ACC_METH0 = 2 ) then 'External'  
	when (T2.M_ACC_METH0 = 3 ) then 'Prorate interest'
end as AccrualMethod, 
CAST(T2.M_ACC_CONV0 AS VARCHAR2(18)) as AccrualConvention,
case when T2.M_CONVERT0 = 0 then 'No'
	when T2.M_CONVERT0 = 1 then 'Yes'
end as RateConversion,
case when T2.M_CONVERT0 = 0 then ' ' else T2.M_CAP_FACT0 end as ConvertFrom,
case when T2.M_CONVERT0 = 0 then ' ' else T2.M_IMP_RATE0 end as ConvertTo,
case when T2.M_CONVERT0 = 0 then ' ' 
	when T2.M_CVRT_PER0 = -20 then 'InterestCalculationPeriod'
	when T2.M_CVRT_PER0 = -21 then 'InstrumentTotalPeriod'
	when T2.M_CVRT_PER0 = -22 then 'TotalInterestPeriod'
else 	to_char( T2.M_CVRT_PER0) end as ConversionPeriod,
case when T2.M_CONVERT0 = 0 then ' ' 
	 when T2.M_RCRND_RL0=0 then 'None'
	when T2.M_RCRND_RL0=1 then 'Nearest'
	when T2.M_RCRND_RL0=2 then 'By default'
	when T2.M_RCRND_RL0=3 then 'By excess'
	when T2.M_RCRND_RL0=5 then 'Nearest 5th'
	when T2.M_RCRND_RL0=6 then 'By excess 5th'
	when T2.M_RCRND_RL0=7 then 'By default 5th'
end as ConvRoundingRule,
case when T2.M_CONVERT0 = 0 or T2.M_RCRND_RL0=0 then ' '  else to_char(T2.M_RC_DEC0) end as ConvDecimal,
case when (T2.M_ACC_ROUND0 = 0) then 'None' 
	when (T2.M_ACC_ROUND0 = 1) then 'Nearest' 
	when (T2.M_ACC_ROUND0 = 2) then 'By default' 
	when (T2.M_ACC_ROUND0 = 3) then 'By excess' 
end as AccrualRoundingRule,
T2.M_ACC_DEC0 as AccrualDecimals,
case when (T2.M_ROUND_RUL0 = 0) then 'None' 	
	when (T2.M_ROUND_RUL0 = 1) then 'Nearest' 
	when (T2.M_ROUND_RUL0 = 2) then 'By default' 
 	when (T2.M_ROUND_RUL0 = 3) then 'By excess'  
	when (T2.M_ROUND_RUL0 = 3) then 'Currency' 
end as RoundingRule, 
T2.M_DECIMALS0 as Decimals, 
case when (T1.M_BROKEN =0 ) then 'Up front'
	when (T1.M_BROKEN =1 ) then 'In arrears' 
	when (T1.M_BROKEN=3 ) then 'Both ends (backward)'
	when (T1.M_BROKEN = 5) then 'Both ends (forward)' 
end as StubPosition ,
case when (T2.M_BROK_COUP0 =0 ) then 'Short coupon'   
	when (T2.M_BROK_COUP0 =1 ) then 'Long coupon' 
	when (T2.M_BROK_COUP0 =3 ) then 'Full coupon' 
	when (T2.M_BROK_COUP0 = 4) then 'Conditional'  
end as Coupon ,
case when  (T2.M_BROK_IND0  =0 ) then 'Current index'
	when  (T2.M_BROK_IND0  = 1 ) then 'Closest index'  
	when  (T2.M_BROK_IND0  = 2) then 'Next index'
	when  (T2.M_BROK_IND0  = 3) then 'Previous index'  
	when  (T2.M_BROK_IND0  = 4) then 'Interpolated' 
end as StubPeriodRate,
case when (T2.M_BROK_COUP0 = 4) then T2.M_BROK_COND0 else ' ' end as BrokenCondition, 
case when (T2.M_AMORT0 = 0 ) then 'None'
	when (T2.M_AMORT0 = 1 ) then 'Linear '
	when (T2.M_AMORT0 = 2 ) then 'Constant'
	when (T2.M_AMORT0 = 3 ) then 'Constant annuities' 
	when (T2.M_AMORT0 = 5) then 'Coupon reinvestment'
end as Amortizing,
case when (T3.M_DFLT_DEF2 is null ) then ' ' else T3.M_DFLT_DEF2 end as DefaultDetails,
case when (T5.M_ISDA_VER = 0) then 'ISDA 99'   when (T5.M_ISDA_VER = 1) then 'ISDA 03' end as ISDAVersion,
case when (T5.M_DFLT_SETTL = 0) then 'Cash' 
	when (T5.M_DFLT_SETTL = 1) then 'Delivery' 
    when (T5.M_DFLT_SETTL = 2) then 'Cash or delivery' 
	when (T5.M_DFLT_SETTL = 3) then 'Auction' 
end as SettlementMethod,  	 
case when (T5.M_RECPAYMODE =0 ) then 'Paid on default date' when (T5.M_RECPAYMODE =1 ) then 'Paid at end of trade' end as Protection,
case when (T5.M_ACCPAYMODE = 0) then 'Not paid after default'
	when (T5.M_ACCPAYMODE = 1) then 'Paid on default date'
	when (T5.M_ACCPAYMODE = 2) then 'Continue till end of period'
	when (T5.M_ACCPAYMODE = 3) then 'Continue till end of trade'
end as Premium, 
case when (T5.M_DFLT_TYPE = 0) then 'Reference price-final price'
	 when (T5.M_DFLT_TYPE = 1) then 'Par- final price'   												 					
	 when (T5.M_DFLT_TYPE = 3) then 'Digital cash payment (rate)'
	 when (T5.M_DFLT_TYPE = 4) then 'Digital cash payment (amount)'
end as Payoff,
T5.M_DIGITAL_R as Rate, T5.M_DIGITAL_A as Amount,
case when T5.M_UPFRONT = 0 then 'Unchecked' when T5.M_UPFRONT = 1 then 'Checked' end as Upfront,
CAST(T1.M_FCPCUTOFF AS VARCHAR2(18)) as FutCashProcCutOff,
case when T6.M_COUPAD = 0 then 'Excluded'
	when T6.M_COUPAD = 1 then 'Included'
	when T6.M_COUPAD = 2 then 'Conditional'
	end as CoupPaymAfterDef,
case when T6.M_COUPAD = 2 then T6.M_COUPAD_CS else ' ' end as CoupPaymAfterDefShifter
-------
from RT_INSGN_DBF T1, CR_TEMPL_DBF T5, RT_LNGN_DBF T2
-------
left outer join RT_INDEX_DBF T4 on T2.M_INDEX0 = T4.M_INDEX
left outer join CR_DD_DBF T3 on T3.M_UID = T2.M_DFLT_TNB0
left outer join CR_STREAM_T_DBF T6 on T2.M_CR_STMPID0 = T6.M_REFERENCE
-------
where T1.M_INSTR_TYPE = 9 
and T1.M_GEN_NUM = T2.M_GEN_NUM
and T2.M_CR_TMPID0 = T5.M_REFERENCE
and T1.M_CREAT_MODE = 0
-------
order by T1.M_INSTR;
quit;
SPOOL OFF;