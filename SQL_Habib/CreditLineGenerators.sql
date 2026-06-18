set colsep '#';
SET TERMOUT OFF;
SPOOL &1;
set linesize 3810;
set pagesize 2048;
select 	T1.M_INSTR as SwapGenerator,T1.M_INSTR_DESC as Description,T1.M_NB_PHASE as NumPhases,T1.M_NB_LEG as NumLegs, 
-------------------------------
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
	case	when (T1.M_FLAGS =1 ) then 'Common set across legs' 
		when (T1.M_FLAGS =2 ) or (T1.M_FLAGS =0 ) then 'Independent sets across legs' 
		when (T1.M_FLAGS =4 ) then 'Common set, different freq.' 
                when (T1.M_FLAGS =8 ) then 'Independent sets common capitals'
	end as Schedules,
	case	when ((T1.M_FLAGS =2 ) or (T1.M_FLAGS =0 )) and (T1.M_LEG_AMORT =0) then 'Common definition across legs'
		when ((T1.M_FLAGS =2 ) or (T1.M_FLAGS =0 )) and (T1.M_LEG_AMORT =1) then 'Independent definition across legs'
	else ' ' end as LegAmortiz, 
	case	when (T1.M_BROKEN = 0) then 'Up front' 
		when (T1.M_BROKEN = 1) then 'In arrears'
		when (T1.M_BROKEN = 3) then 'Both ends (Backward)'
		when (T1.M_BROKEN = 5) then 'Both ends (Forward)'
	end as StubPeriod,
	case	when (T1.M_EVAL_MODE = 0) then 'Default'
		when (T1.M_EVAL_MODE = 1) then 'MTM'
		when (T1.M_EVAL_MODE = 2) then 'Accrual'
	end as EvalMode,
	case when (T2.M_INIT_CAP0 = 1 ) then 'CHECKED' else 'UNCHECKED' end as InitialCapital,
	case when (T2.M_INTER_CAP0 = 1 ) then 'CHECKED' else 'UNCHECKED' end as IntermediateCapital,
	case when (T2.M_FINAL_CAP0 = 1 ) then 'CHECKED' else 'UNCHECKED' end as FinalCapital,
	case when (T1.M_RAT_DISP= 1) then 'Fixed-Floating'
		when (T1.M_RAT_DISP= 2) then 'Fixed-Fixed'
       
		when (T1.M_RAT_DISP= 4) then 'Floating-Floating'
	end as GenType,
	case when (T1.M_SETTL_MOD= 0) then 'Inherited from currency' else 'Specific delay' end as SettleMode,
	T1.M_SETTL as SettleShift,
	case when  (T1.M_RAT_DISP=2 or T2.M_RATE_TYPE0=0) then ' ' 
     else to_char(T3.M_IND_LAB) end as IndexLeg1, 
	case when (T2.M_FINALTP0 = 0) then 'Currency'
		when (T2.M_FINALTP0 = 1) then 'Commodity'
		when (T2.M_FINALTP0 = 2) then 'Bond'
		when (T2.M_FINALTP0 = 3) then 'Equity'
	end as InstrTypLeg1,
	T2.M_CURRENCY0 as CurrLeg1,
        case when (T1.M_RAT_DISP= 1) then ' '  else to_char(T2.M_EXT_FREQ0) end as FreqLeg1,
	case when (M_RAT_DISP =1 and (T1.M_FLAGS=1 or T1.M_FLAGS=4 )) then ' ' else to_char(T2.M_START0)  end as StDelayLeg1,
	case when (M_RAT_DISP =1 and (T1.M_FLAGS=1 or T1.M_FLAGS=4 )) then ' ' else to_char(T2.M_PAY_CLN0)  end as PayCalLeg1,
	case when (M_RAT_DISP = 2 or M_RATE_TYPE0=0)  then ' ' else to_char(T2.M_FIX_CLN0) end as FixCalLeg1,
	case     
	        when (M_RAT_DISP=2 or M_RATE_TYPE0=0) then ' ' 
	         when (M_RAT_DISP in (1,3,4)) and (T2.M_FIXING0=0) then 'In advance'  
             when (M_RAT_DISP in (1,3,4)) and (T2.M_FIXING0=1) then 'In arrears' else ' ' end as FixingLeg1 ,
	case when (T2.M_PAYMENT0 = 0 ) then 'In arrears' 
		when (T2.M_PAYMENT0 = 1 ) then 'Up front'
		when (T2.M_PAYMENT0 = 2 ) then 'Up front disc.'
	end as PaymentLeg1,
	T2.M_RATE_CONV0 as RatConvLeg1,
	case when (T2.M_CONVERT0= 0 ) then 'UNCHECKED' when (T2.M_CONVERT0= 1 ) then 'CHECKED' end as RtConversion1,
	case when (T2.M_INDEXED0 = 0 ) then 'UNCHECKED' when (T2.M_INDEXED0 = 1 ) then 'CHECKED' end as IndexedLeg1,
	case when  (T2.M_ROUND_RUL0 =0 ) then 'None' when  (T2.M_ROUND_RUL0 =1) then 'Nearest'  
		when (T2.M_ROUND_RUL0 =2)  then 'By default'  when (T2.M_ROUND_RUL0 =3 ) then 'By excess' 
		when (T2.M_ROUND_RUL0 =4) then 'Currency' 
	end as RdngRulLeg1,
	 case when (T2.M_ROUND_RUL0 =0 )  then ' ' else to_char(T2.M_DECIMALS0) end as DecLeg1,
	case when (T2.M_BROK_COUP0= 0) then 'Short Coupon'
		when (T2.M_BROK_COUP0= 1) then 'Long Coupon'
		when (T2.M_BROK_COUP0= 3) then 'Full Coupon'
		when (T2.M_BROK_COUP0= 4) then 'Conditional'
	end as CouponLeg1,
	case
        when (M_RAT_DISP=2 or T2.M_RATE_TYPE0=0) then ' '    
	    when (M_RAT_DISP in (1,3,4)) and (T2.M_BROK_IND0=0) then 'Current Index'
		when (M_RAT_DISP in (1,3,4)) and(T2.M_BROK_IND0=1) then 'Closest Index'
		when (M_RAT_DISP in (1,3,4)) and(T2.M_BROK_IND0=2) then 'Next Index'
		when (M_RAT_DISP in (1,3,4)) and(T2.M_BROK_IND0=3) then 'Previous Index'
		when (M_RAT_DISP in (1,3,4)) and(T2.M_BROK_IND0=4) then 'Interpolated'
	else ' ' end  as StubRateLeg1,
	T2.M_BROK_COND0 as StubCondLeg1,
	case	when (M_RAT_DISP =1 and (T1.M_FLAGS=1 or T1.M_FLAGS=4 )) then ' '
		when (M_RAT_DISP =1 and (T1.M_FLAGS=0 or T1.M_FLAGS=2 )) and (T2.M_ECP_TYPE1 = 0) then 'Driving schedule'
		when (M_RAT_DISP =1 and (T1.M_FLAGS=0 or T1.M_FLAGS=2 )) and (T2.M_ECP_TYPE1 = 1) then 'Equal to'
		when (M_RAT_DISP =1 and (T1.M_FLAGS=0 or T1.M_FLAGS=2 )) and (T2.M_ECP_TYPE1 = 2) then 'Deduced from'
		when ( M_RAT_DISP <>1 or (T1.M_FLAGS<>1 and T1.M_FLAGS<>4 ))and  (T2.M_ECP_TYPE0 = 0) then 'Driving schedule'
		when ( M_RAT_DISP <>1 or (T1.M_FLAGS<>1 and T1.M_FLAGS<>4 )) and (T2.M_ECP_TYPE0 = 1) then 'Equal to'
		when ( M_RAT_DISP <>1 or (T1.M_FLAGS<>1 and T1.M_FLAGS<>4 )) and (T2.M_ECP_TYPE0 = 2) then 'Deduced from'
	end as CalcStSch1Leg1,
	case	when ( M_RAT_DISP <>1 or (T1.M_FLAGS<>1 and T1.M_FLAGS<>4 )) and  (T2.M_ECP_TYPE0 = 0) then ' ' 
		when (M_RAT_DISP =1 and (T1.M_FLAGS=1 or T1.M_FLAGS=4 )) then ' '
		when (M_RAT_DISP =1 and (T1.M_FLAGS=0 or T1.M_FLAGS=2 )) and (T2.M_ECP_UNDRL1  = -1) then ' '
		when (M_RAT_DISP =1 and (T1.M_FLAGS=0 or T1.M_FLAGS=2 )) and ((T2.M_ECP_UNDRL1 = 0) and (T2.M_ECP_TYPE1 <>0)) then 'Payment schedule' 
		when (M_RAT_DISP =1 and (T1.M_FLAGS=0 or T1.M_FLAGS=2 )) and (T2.M_ECP_UNDRL1 = 2) then 'Fixing schedule'
		when (M_RAT_DISP =1 and (T1.M_FLAGS=0 or T1.M_FLAGS=2 )) and (T2.M_ECP_UNDRL1 = 7) then 'Calculation end schedule'
		when (M_RAT_DISP =1 and (T1.M_FLAGS=0 or T1.M_FLAGS=2 )) and (T2.M_ECP_UNDRL1 = 8) then 'Delivery schedule'
		when ( M_RAT_DISP <>1 or (T1.M_FLAGS<>1 and T1.M_FLAGS<>4 )) and (T2.M_ECP_UNDRL0 = -1) then ' '
		when ( M_RAT_DISP <>1 or (T1.M_FLAGS<>1 and T1.M_FLAGS<>4 )) and (T2.M_ECP_UNDRL0 = 0) then 'Payment schedule' 
		when ( M_RAT_DISP <>1 or (T1.M_FLAGS<>1 and T1.M_FLAGS<>4 )) and (T2.M_ECP_UNDRL0 = 2) then 'Fixing schedule'
		when ( M_RAT_DISP <>1 or (T1.M_FLAGS<>1 and T1.M_FLAGS<>4 )) and (T2.M_ECP_UNDRL0= 7) then 'Calculation end schedule'
		when ( M_RAT_DISP <>1 or (T1.M_FLAGS<>1 and T1.M_FLAGS<>4 )) and (T2.M_ECP_UNDRL0 = 8) then 'Delivery schedule'
	else ' ' end as CalcSt2Leg1,
	case 	when (M_RAT_DISP =1) and (T1.M_FLAGS=1 or T1.M_FLAGS=4 ) or (T2.M_ECP_TYPE0 = 1) then ' '
                     when  (T1.M_FLAGS=1 or T1.M_FLAGS=4 ) and (T2.M_ECP_TYPE1 = 1)  then ' ' else to_char(T2.M_ECP0) end as CalcSt3Leg1,
	case	when (M_RAT_DISP =1 and (T1.M_FLAGS=1 or T1.M_FLAGS=4 )) then ' '													
		when (M_RAT_DISP =1 and (T1.M_FLAGS=0 or T1.M_FLAGS=2 )) and (T2.M_ECPE_TYPE1 = 0) then 'Driving schedule'
		when (M_RAT_DISP =1 and (T1.M_FLAGS=0 or T1.M_FLAGS=2 )) and (T2.M_ECPE_TYPE1= 1) then 'Equal to'
		when (M_RAT_DISP =1 and (T1.M_FLAGS=0 or T1.M_FLAGS=2 )) and (T2.M_ECPE_TYPE1 = 2) then 'Deduced from'
		when ( M_RAT_DISP <>1 or (T1.M_FLAGS<>1 and T1.M_FLAGS<>4 ))and  (T2.M_ECPE_TYPE0 = 0) then 'Driving schedule'
		when ( M_RAT_DISP <>1 or (T1.M_FLAGS<>1 and T1.M_FLAGS<>4 )) and (T2.M_ECPE_TYPE0 = 1) then 'Equal to'
		when ( M_RAT_DISP <>1 or (T1.M_FLAGS<>1 and T1.M_FLAGS<>4 )) and (T2.M_ECPE_TYPE0 = 2) then 'Deduced from'
	end as CalcEndSch1Leg1,
	case	when (M_RAT_DISP =1 and (T1.M_FLAGS=1 or T1.M_FLAGS=4 )) then ' '
		when (M_RAT_DISP =1 and (T1.M_FLAGS=0 or T1.M_FLAGS=2 )) and (T2.M_ECPE_UNDR1 = -1) then ' '
		when (M_RAT_DISP =1 and (T1.M_FLAGS=0 or T1.M_FLAGS=2 )) and (T2.M_ECPE_UNDR1 = 0) then 'Payment schedule' 
		when (M_RAT_DISP =1 and (T1.M_FLAGS=0 or T1.M_FLAGS=2 )) and (T2.M_ECPE_UNDR1 = 1) then 'Calculation start schedule'
		when (M_RAT_DISP =1 and (T1.M_FLAGS=0 or T1.M_FLAGS=2 )) and (T2.M_ECPE_UNDR1 = 2) then 'Fixing schedule'
		when (M_RAT_DISP =1 and (T1.M_FLAGS=0 or T1.M_FLAGS=2 )) and (T2.M_ECPE_UNDR1 = 8) then 'Delivery schedule'
		when ( M_RAT_DISP <>1 or (T1.M_FLAGS<>1 and T1.M_FLAGS<>4 )) and (T2.M_ECPE_UNDR0 = -1) then ' '
		when ( M_RAT_DISP <>1 or (T1.M_FLAGS<>1 and T1.M_FLAGS<>4 )) and (T2.M_ECPE_UNDR0 = 0) then 'Payment schedule' 
		when ( M_RAT_DISP <>1 or (T1.M_FLAGS<>1 and T1.M_FLAGS<>4 )) and (T2.M_ECPE_UNDR0= 1) then 'Calculation start schedule'
		when ( M_RAT_DISP <>1 or (T1.M_FLAGS<>1 and T1.M_FLAGS<>4 )) and (T2.M_ECPE_UNDR0 = 2) then 'Fixing schedule'
		when ( M_RAT_DISP <>1 or (T1.M_FLAGS<>1 and T1.M_FLAGS<>4 )) and (T2.M_ECPE_UNDR0 = 8) then 'Delivery schedule'
	end as CalcEndSch2Leg1,
	case	when (M_RAT_DISP =1 and (T1.M_FLAGS=1 or T1.M_FLAGS=4 ) or T2.M_ECPE_TYPE0 = 1) then ' '
                 when (T1.M_FLAGS=1 or T1.M_FLAGS=4 ) and  (T2.M_ECPE_TYPE1 = 1) then ' ' else  to_char(T2.M_ECPE0) end CalcEndSch3Leg1,
	case when M_RAT_DISP=1 and T1.M_FLAGS in (1, 65537, 131073, 4, 65540, 131076) and (T4.M_CATEGORY in (0, 8)) then ' '
		when M_RAT_DISP=1  and T1.M_FLAGS in (1, 65537, 131073, 4, 65540, 131076) and (T4.M_CATEGORY not in (0,8)) and (T2.M_EP_TYPE0 = 0) then 'Driving schedule' 
		when M_RAT_DISP=1  and T1.M_FLAGS in (1, 65537, 131073, 4, 65540, 131076) and (T4.M_CATEGORY not in (0,8))  and (T2.M_EP_TYPE0 = 1) then 'Equal to'
		when M_RAT_DISP=1  and T1.M_FLAGS in (1, 65537, 131073, 4, 65540, 131076) and (T4.M_CATEGORY not in (0,8))  and (T2.M_EP_TYPE0 = 2) then 'Deduced from'		
		when M_RAT_DISP =1 and T1.M_FLAGS in (0, 2, 65538, 131074, 8, 65544, 131080)  and (T2.M_EP_TYPE0 = 0) then 'Driving schedule'
		when M_RAT_DISP =1 and T1.M_FLAGS in (0, 2, 65538, 131074, 8, 65544, 131080)  and (T2.M_EP_TYPE0= 1) then 'Equal to'
		when M_RAT_DISP =1 and T1.M_FLAGS in (0, 2, 65538, 131074, 8, 65544, 131080)  and (T2.M_EP_TYPE0= 2) then 'Deduced from'
		when (M_RAT_DISP =2) and (T2.M_EP_TYPE0= 0)  then 'Driving schedule'
		when (M_RAT_DISP =2) and (T2.M_EP_TYPE0= 1)  then 'Equal to'
		when (M_RAT_DISP =2) and (T2.M_EP_TYPE0= 2)  then 'Deduced from'
		when M_RAT_DISP=4 and T1.M_FLAGS in (1, 65537, 131073, 4, 65540, 131076) and (T4.M_CATEGORY in (0, 8)) and (T3.M_CATEGORY not in (0, 8)) then ' '
		when (M_RAT_DISP =4) and (T4.M_CATEGORY not in (0, 8) or T3.M_CATEGORY in (0, 8)) and (T2.M_EP_TYPE0= 0)  then 'Driving schedule'
		when (M_RAT_DISP =4) and (T4.M_CATEGORY not in (0, 8) or T3.M_CATEGORY in (0, 8)) and (T2.M_EP_TYPE0= 1)  then 'Equal to'
		when (M_RAT_DISP =4) and (T4.M_CATEGORY not in (0, 8) or T3.M_CATEGORY in (0, 8)) and (T2.M_EP_TYPE0= 2)  then 'Deduced from'
	end as PaySch1Leg1,
	case	when (M_RAT_DISP =1 and (T1.M_FLAGS=1 or T1.M_FLAGS=4 )) then ' '
		when ( M_RAT_DISP <>1 or (T1.M_FLAGS<>1 and T1.M_FLAGS<>4 )) and  (T2.M_EP_TYPE0 = 0) then ' '
		when (M_RAT_DISP =1 and (T1.M_FLAGS=0 or T1.M_FLAGS=2 )) and ((T2.M_EP_UNDRL1 = -1) or (T2.M_EP_UNDRL1 = 0)) then ' '
		when (M_RAT_DISP =1 and (T1.M_FLAGS=0 or T1.M_FLAGS=2 )) and (T2.M_EP_UNDRL1 = 1) then 'Calculation start schedule'
		when (M_RAT_DISP =1 and (T1.M_FLAGS=0 or T1.M_FLAGS=2 )) and (T2.M_EP_UNDRL1 = 2) then 'Fixing schedule'
		when (M_RAT_DISP =1 and (T1.M_FLAGS=0 or T1.M_FLAGS=2 )) and (T2.M_EP_UNDRL1 = 7) then 'Calculation end schedule'
		when (M_RAT_DISP =1 and (T1.M_FLAGS=0 or T1.M_FLAGS=2 )) and (T2.M_EP_UNDRL1 = 8) then 'Delivery schedule'
		when ( M_RAT_DISP <>1 or (T1.M_FLAGS<>1 and T1.M_FLAGS<>4 )) and ((T2.M_EP_UNDRL0 = -1) or (T2.M_EP_UNDRL0 = 0))then ' '
		when ( M_RAT_DISP <>1 or (T1.M_FLAGS<>1 and T1.M_FLAGS<>4 )) and (T2.M_EP_UNDRL0= 1) then 'Calculation start schedule'
		when ( M_RAT_DISP <>1 or (T1.M_FLAGS<>1 and T1.M_FLAGS<>4 )) and (T2.M_EP_UNDRL0 = 2) then 'Fixing schedule'
		when ( M_RAT_DISP <>1 or (T1.M_FLAGS<>1 and T1.M_FLAGS<>4 )) and (T2.M_EP_UNDRL0 = 7) then 'Calculation end schedule'
		when ( M_RAT_DISP <>1 or (T1.M_FLAGS<>1 and T1.M_FLAGS<>4 )) and (T2.M_EP_UNDRL0 = 8) then 'Delivery schedule'
	end as PaySch2Leg1,
	case when ((M_RAT_DISP =1 and T1.M_FLAGS in (1, 65537, 131073, 4, 65540, 131076) and (T4.M_CATEGORY in (0, 8))) or T2.M_EP_TYPE0 =1) then ' '
		when M_RAT_DISP=1  and T1.M_FLAGS in (1, 65537, 131073, 4, 65540, 131076) and (T4.M_CATEGORY not in (0,8)) and (T2.M_EP_TYPE0 <> 1)then to_char(T2.M_EP0)
		when M_RAT_DISP=1 and T1.M_FLAGS in (0, 2, 65538, 131074, 8, 65544, 131080) and (T2.M_EP_TYPE0 <> 1)then to_char(T2.M_EP0) 
		when M_RAT_DISP=2 and T2.M_EP_TYPE0 <> 1 then to_char(T2.M_EP0)
		when M_RAT_DISP=4 and T1.M_FLAGS in (1, 65537, 131073, 4, 65540, 131076) and (T4.M_CATEGORY in (0, 8)) and (T3.M_CATEGORY not in (0, 8)) then ' ' 
		when M_RAT_DISP=4 and (T4.M_CATEGORY not in (0, 8) or T3.M_CATEGORY in (0, 8)) and (T2.M_EP_TYPE0 <> 1)then to_char(T2.M_EP0) 
	end as PaySc3Leg1,
	case	when (M_RAT_DISP =1 and (T1.M_FLAGS=1 or T1.M_FLAGS=4 ) or T2.M_EP_FREQ0 in (-1,-2)) then ' '
                 when  (T1.M_FLAGS=1 or T1.M_FLAGS=4 )  and (T2.M_EP_FREQ1 in (-1,-2)) then ' ' else to_char(T2.M_EP_FREQ0) end as PayFrqLeg1,
------------------------
-----------------------
	case	when ((M_RAT_DISP =2)) or ((M_RATE_TYPE0=0))  then ' '														
		when ( M_RAT_DISP <>2  or (T1.M_FLAGS<>1 and T1.M_FLAGS<>4 ))and  (T2.M_EI_TYPE0 = 0) then 'Driving schedule'
		when ( M_RAT_DISP <>2 or (T1.M_FLAGS<>1 and T1.M_FLAGS<>4 )) and (T2.M_EI_TYPE0 = 1) then 'Equal to'
		when ( M_RAT_DISP <>2 or (T1.M_FLAGS<>1 and T1.M_FLAGS<>4 )) and (T2.M_EI_TYPE0 = 2) then 'Deduced from'
        when ( M_RAT_DISP <>2 or (T1.M_FLAGS<>1 and T1.M_FLAGS<>4 )) and (T2.M_EI_TYPE0 = 2) then 'Copy of'
	end as FixSch1Leg1,
	case	when ( M_RAT_DISP=2 or (T1.M_FLAGS<>1 and T1.M_FLAGS<>4 )) and  (T2.M_EI_TYPE0 = 0) then ' '
		when ((M_RAT_DISP =2) or (M_RATE_TYPE0=0))  then ' '
		when (( M_RAT_DISP <>1 or (T1.M_FLAGS<>1 and T1.M_FLAGS<>4 )) and (T2.M_EI_UNDRL0 = -1))   then ' '
		when ( M_RAT_DISP <>1 or (T1.M_FLAGS<>1 and T1.M_FLAGS<>4 )) and (T2.M_EI_UNDRL0= 1) then 'Calculation start schedule'
		when ( M_RAT_DISP <>1 or (T1.M_FLAGS<>1 and T1.M_FLAGS<>4 )) and (T2.M_EI_UNDRL0 = 7) then 'Calculation end schedule' 
		when ( M_RAT_DISP <>1 or (T1.M_FLAGS<>1 and T1.M_FLAGS<>4 )) and (T2.M_EI_UNDRL0 = 0) then 'Payment schedule'
	end as FixSch2Leg1,
case when M_RAT_DISP = 2 or M_RATE_TYPE0=0  then ' '
		when (M_RAT_DISP = 1 and (T1.M_FLAGS=1 or T1.M_FLAGS=4 ) or (T2.M_EI_TYPE0 = 1)) then ' '
                   when (T1.M_FLAGS=1 or T1.M_FLAGS=4 ) and (T2.M_EI_TYPE1 = 1) then ' '  else to_char(T2.M_EI0) end as FixSch3Leg1,
	case
       when M_RAT_DISP = 2 or M_RATE_TYPE0=0  then ' ' 
       when (M_RAT_DISP =1 and (T1.M_FLAGS=1 or T1.M_FLAGS=4 ) or T2.M_EI_FREQ0 in (-1,-2)) then ' '
                   when (T1.M_FLAGS=1 or T1.M_FLAGS=4 ) and (T2.M_EI_FREQ1 in (-1,-2)) then ' '	else to_char(T2.M_EI_FREQ0) end as FixFrqLeg1,	
-------------------------------
----------------------------------					
case when M_RAT_DISP=1 and T1.M_FLAGS in (1, 65537, 131073, 4, 65540, 131076) and (T4.M_CATEGORY in (0, 8)) then ' '
	 when M_RAT_DISP=1 and (T4.M_CATEGORY not in (0,8) or T1.M_FLAGS in (0, 2, 65538, 131074, 8, 65544, 131080)) and (T2.M_SIMP_SCH0 = 0) then 'No'
	 when M_RAT_DISP=1 and (T4.M_CATEGORY not in (0,8) or T1.M_FLAGS in (0, 2, 65538, 131074, 8, 65544, 131080)) and (T2.M_SIMP_SCH0 = 1) then 'Yes'
	 when M_RAT_DISP=2 and (T2.M_SIMP_SCH0 = 0) then 'No'
	 when M_RAT_DISP=2 and (T2.M_SIMP_SCH0 = 1) then 'Yes'
	 when M_RAT_DISP=4 and T1.M_FLAGS in (1, 65537, 131073, 4, 65540, 131076) and (T4.M_CATEGORY in (0, 8)) and (T3.M_CATEGORY not in (0, 8)) then ' '
	 when M_RAT_DISP=4 and T4.M_CATEGORY not in (0,8) or (T3.M_CATEGORY in (0, 8) or T1.M_FLAGS in (0, 2, 65538, 131074, 8, 65544, 131080)) and (T2.M_SIMP_SCH0 = 0) then 'No'
	 when M_RAT_DISP=4 and T4.M_CATEGORY not in (0,8) or (T3.M_CATEGORY in (0, 8) or T1.M_FLAGS in (0, 2, 65538, 131074, 8, 65544, 131080)) and (T2.M_SIMP_SCH0 = 1) then 'Yes'
	end as SingPdLeg1,
--------------------------
----------------------------					
case 
     when (M_RAT_DISP=2 or T2.M_RATE_TYPE0=0) then ' '
     when (T2.M_MRG_MODE0= 0) and  (M_RAT_DISP in (1,3,4))   then 'Additive' 
          when (T2.M_MRG_MODE0= 1) and  (M_RAT_DISP in (1,3,4))   then 'Multiplicative' else ' '  end as MarginMode,		
case when (T2.M_RETINT0 = 0) then 'Return (P2-P1)/P1' when (T2.M_RETINT0 = 1) then 'Spread (P2-P1)' end as ReturnType,
------------------------
---------------------------
case  when (T2.M_INDEXED0 = 0) and (T2.M_INDEXED1 = 0) then ' ' 
 when (T5.M_LEG=0)   then 'leg1'
when (T5.M_LEG=1) then 'leg2' else ' ' end as IndexLeg,

case when (T5.M_TYPE is NULL) then ' '
         when (T2.M_INDEXED0 = 0) and (T2.M_INDEXED1 = 0) then ' ' 
	when (T5.M_TYPE=0) then 'Interest flows'
	when (T5.M_TYPE=1) then 'Fixings'
	when (T5.M_TYPE=8) then 'Strikes'
	when (T5.M_TYPE=2) then 'Margins'
	when (T5.M_TYPE=3) then 'Interest rates'
	when (T5.M_TYPE=4) then 'Initial capital'
	when (T5.M_TYPE=5) then 'Intermediate capital'
	when (T5.M_TYPE=6) then 'Final capital'
	when (T5.M_TYPE=7) then 'Outstanding capital'
	when (T5.M_TYPE=9) then 'Dividends'
	when (T5.M_TYPE=10) then 'Tax Credit'
	when (T5.M_TYPE=12) then 'Recovery nominal'
	when (T5.M_TYPE=13) then 'Cap strikes'
end as IndListTyp,
------------------------
-----------------------
--------------------------
case when (T5.M_RAT_TYPE is NULL) then ' ' 
 when (T2.M_INDEXED0 = 0) and (T2.M_INDEXED1 = 0) then ' ' 
when (T5.M_RAT_TYPE=0) then 'Floating'
when (T5.M_RAT_TYPE=1) then 'Fixed'
when (T5.M_RAT_TYPE=2) then 'Optional'
end as IndType,
case when (T5.M_IND_NAT is NULL) then ' ' 
 when (T2.M_INDEXED0 = 0) and (T2.M_INDEXED1 = 0) then ' ' 
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
------------------
case when (T5.M_RETINRP is NULL) then ' '
 when (T2.M_INDEXED0 = 0) and (T2.M_INDEXED1 = 0) then ' ' 
when (T5.M_RETINRP=0) then 'Inflation'
when (T5.M_RETINRP=1) then 'Linear'
end as RetInterpol,
----------------
case when (T5.M_RSHIFT is NULL) then ' '
else T5.M_RSHIFT
end as RetFixLag,
----------------------
------------------
case when (T5.M_I_FORMULA is NULL) then ' ' else to_char(T5.M_I_FORMULA) end as IndFormula,
case when (T5.M_OPERAND is NULL) then ' ' 
 when (T2.M_INDEXED0 = 0) and (T2.M_INDEXED1 = 0) then ' ' 
when (T5.M_OPERAND=0) then 'Factor (xP)' 
when (T5.M_OPERAND=1) then 'Spread (+P)' 
when (T5.M_OPERAND=2) then 'Increase (x(1+P))' 
when (T5.M_OPERAND=3) then 'Replace (=P)' 
end as Operand,
---------------------
case when (T5.M_FORMULA is NULL) then ' ' 
 when (T2.M_INDEXED0 = 0) and (T2.M_INDEXED1 = 0) then ' ' 
when (T5.M_FORMULA=0) then 'Plain index (P) '
when (T5.M_FORMULA=1) then 'Period Return (P=(P2-P1)/P1)'
when (T5.M_FORMULA=2) then 'Period Ratio (P=P2/P1)'
when (T5.M_FORMULA=3) then 'Initial Return (P=(P2-P0)/P0)'
when (T5.M_FORMULA=4) then 'Initial ratio (P=P2/P0)'
when (T5.M_FORMULA=5) then 'Inverse (P=(1/P))'
end as Formula,
--------------
case when (T5.M_SCHED_TYPE is NULL) then ' ' 
 when (T2.M_INDEXED0 = 0) and (T2.M_INDEXED1 = 0) then ' ' 
when (T5.M_SCHED_TYPE=0) then 'Equal To'
when (T5.M_SCHED_TYPE=1) then 'Shifted from'
end as SchedType, 

case when (T5.M_OPTION is NULL) then ' ' 
 when (T2.M_INDEXED0 = 0) and (T2.M_INDEXED1 = 0) then ' ' 
when (T5.M_OPTION=0) then 'No'
when (T5.M_OPTION=1) then 'Max'
when (T5.M_OPTION=2) then 'Min'
end as IndOption,
-----------------
case when (T5.M_UND_SCHED is NULL) then ' ' 
 when (T2.M_INDEXED0 = 0) and (T2.M_INDEXED1 = 0) then ' ' 
when (T5.M_UND_SCHED=0) then 'Payment schedule'
when (T5.M_UND_SCHED=1) then 'Calculation schedule'
when (T5.M_UND_SCHED=2) then 'Reset schedule'
end as UndSched,
---------------------
-----------------------
case when (T5.M_SCHED_TYPE=1) then T5.M_SCHED0 else ' ' end as PorP2Shif,
case when (T5.M_SCHED_TYPE=1) then T5.M_SCHED1 else ' ' end as P0orP1Shif,
case when (T5.M_SCHED_TYPE=1) then T5.M_CALENDAR else ' ' end as Calend,
case when ((T5.M_SCHED_TYPE=1) and (T5.M_CMP_MOD=0)) then 'Single'
	when ((T5.M_SCHED_TYPE=1) and (T5.M_CMP_MOD=1)) then 'cumulative'
 	else ' ' end as CompuMode,
------------------
------------------
case when (T5.M_FREQ is NULL) then ' ' 
when (T2.M_INDEXED0 = 0) and (T2.M_INDEXED1 = 0) then ' ' 
else to_char(T5.M_FREQ) end as FreqRatio,
case when (T5.M_DATE_POS is NULL) then ' ' 
 when (T2.M_INDEXED0 = 0) and (T2.M_INDEXED1 = 0) then ' ' 
when (T5.M_DATE_POS=0) then 'Unchecked'
when (T5.M_DATE_POS=1) then 'Checked'
end as UpFront,
----------------------
case when (T5.M_FACTOR is NULL) then ' '
 when (T2.M_INDEXED0 = 0) and (T2.M_INDEXED1 = 0) then ' ' 
 else to_char(T5.M_FACTOR) end as IndFactor,
case when (T5.M_P_FACTOR is NULL) then ' ' 
 when (T2.M_INDEXED0 = 0) and (T2.M_INDEXED1 = 0) then ' ' 
else to_char(T5.M_P_FACTOR) end as PriceFactor,
case when (T5.M_REPL is NULL) then ' ' 
 when (T2.M_INDEXED0 = 0) and (T2.M_INDEXED1 = 0) then ' ' 
when (T5.M_REPL=0) then 'Unchecked'
when (T5.M_REPL=1) then 'Checked'
end as Replacement,
------------------
case when (T5.M_RND_RL0 is NULL) then ' ' 
when (T2.M_INDEXED0 = 0) and (T2.M_INDEXED1 = 0) then ' ' 
when (T5.M_RND_RL0=0) then 'None'
when (T5.M_RND_RL0=1) then 'Nearest'
when (T5.M_RND_RL0=2) then 'By default'
when (T5.M_RND_RL0=3) then 'By excess'
end as IndeRdngRul,
-----------------
case when (T5.M_RND_RL0=0) or (T5.M_RND_RL0 is NULL)  then ' '
when (T2.M_INDEXED0 = 0) and (T2.M_INDEXED1 = 0) then ' ' 
 else to_char(T5.M_RND_RLD0) end as IndRdgDec,
-------------------
case when (T5.M_RND_RL1 is NULL) then ' ' 
when (T2.M_INDEXED0 = 0) and (T2.M_INDEXED1 = 0) then ' ' 
when (T5.M_RND_RL1=0) then 'None'
when (T5.M_RND_RL1=1) then 'Nearest'
when (T5.M_RND_RL1=2) then 'By default'
when (T5.M_RND_RL1=3) then 'By excess'
end as IndPostRdngRul,
--------------------
case when (T5.M_RND_RL1=0) or (T5.M_RND_RL1 is NULL) then ' ' 
when (T2.M_INDEXED0 = 0) and (T2.M_INDEXED1 = 0) then ' ' 
else to_char(T5.M_RND_RLD1) end as IndPostRdngDec,
case when (T5.M_P_MARGIN is NULL) then ' ' 
when (T2.M_INDEXED0 = 0) and (T2.M_INDEXED1 = 0) then ' ' else to_char(T5.M_P_MARGIN) end as PriceMargin,
--------------
----------------
--------------------
	case when (T2.M_RETINT0 = 0) then 'Return (P2-P1)/P1' when (T2.M_RETINT0 = 1) then 'Spread (P2-P1)' end as RetTypLeg1,
	case when (T1.M_RAT_DISP in (2) or T2.M_INDEX1=' ') then ' ' else T4.M_IND_LAB end as IndLeg,
 	case when (T2.M_FINALTP1 = 0) then 'Currency'
		when (T2.M_FINALTP1 = 1) then 'Commodity'
		when (T2.M_FINALTP1 = 2) then 'Bond'
		when (T2.M_FINALTP1 = 3) then 'Equity'
	end as InstrTypLeg2,
	T2.M_CURRENCY1 as CurrencyLeg2,
	
	case when (T1.M_RAT_DISP= 4 and T1.M_FLAGS =4) then T2.M_EXT_FREQ1 else ' ' end as FrequencyLeg2,
	
	
	case when (M_RAT_DISP <>1 and (T1.M_FLAGS=1 or T1.M_FLAGS=4 )) then  ' '  
                 when (M_RAT_DISP = 1 and (T1.M_FLAGS=1 or T1.M_FLAGS=4 )) then T2.M_START0 else to_char(T2.M_START1) end as StDelayLeg2, 
	case when (M_RAT_DISP <> 1 and (T1.M_FLAGS=1 or T1.M_FLAGS=4 )) then ' ' 
                 when  (M_RAT_DISP = 1 and (T1.M_FLAGS=1 or T1.M_FLAGS=4 )) then T2.M_PAY_CLN0 else to_char(T2.M_PAY_CLN1)  end as PayCalLeg2,
	case when (M_RAT_DISP in (2) or T2.M_INDEX1=' ' or M_RATE_TYPE1=0)  then ' ' 
       else  to_char(T2.M_FIX_CLN1) end as FixCalLeg2,
	case
      when (M_RAT_DISP=2 or T2.M_RATE_TYPE1=0) then ' ' 	
	  when (M_RAT_DISP in (1,3,4))  and (T2.M_FIXING1=0) then 'In advance'  
                 when  (M_RAT_DISP in (1,3,4)) and (T2.M_FIXING1=1) then 'In arrears' else ' ' end as FixLeg2 ,
	case when (T2.M_PAYMENT1 = 0 ) then 'In arrears' 
		when (T2.M_PAYMENT1 = 1 ) then 'Up front'  
		when (T2.M_PAYMENT1 = 2 ) then 'Up front disc.'
	end as PayLeg2,
	T2.M_RATE_CONV1 as RatConvLeg2,
	case when (T2.M_CONVERT1= 0 ) then 'UNCHECKED' when (T2.M_CONVERT1= 1 ) then 'CHECKED' end as RtConversion2,
	case when (T2.M_INDEXED1 = 0 ) then 'UNCHECKED' when (T2.M_INDEXED1 = 1 ) then 'CHECKED' end as IndLeg2,
	case when  (T2.M_ROUND_RUL1 =0 ) then 'None' when  (T2.M_ROUND_RUL1 =1) then 'Nearest'  
		when (T2.M_ROUND_RUL1 =2)  then 'By default'  when (T2.M_ROUND_RUL1 =3 ) then 'By excess' 
		when (T2.M_ROUND_RUL1 =4) then 'Currency' 
	end as RdngRulLeg2,
	case when (T2.M_ROUND_RUL1 =0 )  then ' ' else to_char(T2.M_DECIMALS1) end as DecLeg2,
	case 
	    when (M_RAT_DISP=2 or T2.M_RATE_TYPE1=0) then ' '
	     when (T2.M_MRG_MODE1= 0) and (M_RAT_DISP in (1,3,4))  then 'Additive' 
                when  (T2.M_MRG_MODE1= 1) and (M_RAT_DISP in (1,3,4)) then   'Multiplicative' else ' ' end as MargMode2,
	case when (T2.M_BROK_COUP1= 0) then 'Short Coupon'
		when (T2.M_BROK_COUP1= 1) then 'Long Coupon'
		when (T2.M_BROK_COUP1= 3) then 'Full Coupon'
		when (T2.M_BROK_COUP1= 4) then 'Conditional'
	end as CoupLeg2,
	case    
	     when (M_RAT_DISP=2 or T2.M_RATE_TYPE1=0) then ' ' 
	    when (M_RAT_DISP in (1,3,4)) and (T2.M_BROK_IND1=0) then 'Current Index'
		when (M_RAT_DISP in (1,3,4)) and(T2.M_BROK_IND1=1) then 'Closest Index'
		when (M_RAT_DISP in (1,3,4)) and(T2.M_BROK_IND1=2) then 'Next Index'
		when (M_RAT_DISP in (1,3,4)) and(T2.M_BROK_IND1=3) then 'Previous Index'
		when (M_RAT_DISP in (1,3,4)) and(T2.M_BROK_IND1=4) then 'Interpolated'
	else ' '
	end  as StubPerRate2,
	T2.M_BROK_COND1 as StubCond2,
	case when (M_RAT_DISP =1 and (T1.M_FLAGS=1 or T1.M_FLAGS=4 )) and (T2.M_ECP_TYPE0 = 0) then 'Driving schedule'
		when (M_RAT_DISP =1 and (T1.M_FLAGS=1 or T1.M_FLAGS=4 )) and (T2.M_ECP_TYPE0 = 1) then 'Equal to'
		when (M_RAT_DISP =1 and (T1.M_FLAGS=1 or T1.M_FLAGS=4 )) and (T2.M_ECP_TYPE0 = 2) then 'Deduced from'
		when ( M_RAT_DISP <>1 and (T1.M_FLAGS=1 or T1.M_FLAGS=4 )) then ' '
		when ( M_RAT_DISP <>1 or (T1.M_FLAGS<>1 and T1.M_FLAGS<>4 )) and  (T2.M_ECP_TYPE1 = 0) then 'Driving schedule'
		when ( M_RAT_DISP <>1 or (T1.M_FLAGS<>1 and T1.M_FLAGS<>4 )) and (T2.M_ECP_TYPE1 = 1) then 'Equal to'
		when ( M_RAT_DISP <>1 or (T1.M_FLAGS<>1 and T1.M_FLAGS<>4 )) and (T2.M_ECP_TYPE1 = 2) then 'Deduced from'
	end as CalcStSchd1Leg2,
---------------
	case when (M_RAT_DISP =1 and (T1.M_FLAGS=1 or T1.M_FLAGS=4 )) and (T2.M_ECP_UNDRL0  = -1) then ' '
		when (M_RAT_DISP =1 and (T1.M_FLAGS=1 or T1.M_FLAGS=4 )) and (T2.M_ECP_TYPE0 = 0) then ' '
		when (M_RAT_DISP =1 and (T1.M_FLAGS=1 or T1.M_FLAGS=4 )) and (T2.M_ECP_UNDRL0 = 0) then 'Payment schedule' 
		when (M_RAT_DISP =1 and (T1.M_FLAGS=1 or T1.M_FLAGS=4 )) and (T2.M_ECP_UNDRL0 = 2) then 'Fixing schedule'
		when (M_RAT_DISP =1 and (T1.M_FLAGS=1 or T1.M_FLAGS=4 )) and (T2.M_ECP_UNDRL0 = 7) then 'Calculation end schedule'
		when (M_RAT_DISP =1 and (T1.M_FLAGS=1 or T1.M_FLAGS=4 )) and (T2.M_ECP_UNDRL0 = 8) then 'Delivery schedule'
		when ( M_RAT_DISP <>1 and (T1.M_FLAGS=1 or T1.M_FLAGS=4 )) then ' '
		when ( M_RAT_DISP <>1 or (T1.M_FLAGS<>1 and T1.M_FLAGS<>4 )) and (T2.M_ECP_UNDRL1 = -1) then ' '
		when ( M_RAT_DISP <>1 or (T1.M_FLAGS<>1 and T1.M_FLAGS<>4 )) and (T2.M_ECP_TYPE1 = 0) then ' '
		when ( M_RAT_DISP <>1 or (T1.M_FLAGS<>1 and T1.M_FLAGS<>4 )) and (T2.M_ECP_UNDRL1 = 0) then 'Payment schedule' 
		when ( M_RAT_DISP <>1 or (T1.M_FLAGS<>1 and T1.M_FLAGS<>4 )) and (T2.M_ECP_UNDRL1 = 2) then 'Fixing schedule'
		when ( M_RAT_DISP <>1 or (T1.M_FLAGS<>1 and T1.M_FLAGS<>4 )) and (T2.M_ECP_UNDRL1= 7) then 'Calculation end schedule'
		when ( M_RAT_DISP <>1 or (T1.M_FLAGS<>1 and T1.M_FLAGS<>4 )) and (T2.M_ECP_UNDRL1 = 8) then 'Delivery schedule'
	end as CalcStSchd2Leg2,
	case	when (M_RAT_DISP <>1 and (T1.M_FLAGS=1 or T1.M_FLAGS=4 ) or T2.M_ECP_TYPE1 =1) then ' '  
                 when  (M_RAT_DISP =1) and  (T1.M_FLAGS=1 or T1.M_FLAGS=4 )  then T2.M_ECP0 else to_char(T2.M_ECP1) end as CalcStSchd3Leg2,
	case	when (M_RAT_DISP =1 and (T1.M_FLAGS=1 or T1.M_FLAGS=4 )) and (T2.M_ECPE_TYPE0 = 0) then 'Driving schedule'
		when (M_RAT_DISP =1 and (T1.M_FLAGS=1 or T1.M_FLAGS=4 )) and (T2.M_ECPE_TYPE0= 1) then 'Equal to'
		when (M_RAT_DISP =1 and (T1.M_FLAGS=1 or T1.M_FLAGS=4 )) and (T2.M_ECPE_TYPE0 = 2) then 'Deduced from'
		when ( M_RAT_DISP <>1 and (T1.M_FLAGS=1 or T1.M_FLAGS=4 )) then ' '
		when ( M_RAT_DISP <>1 or (T1.M_FLAGS<>1 and T1.M_FLAGS<>4 ))and  (T2.M_ECPE_TYPE1 = 0) then 'Driving schedule'
		when ( M_RAT_DISP <>1 or (T1.M_FLAGS<>1 and T1.M_FLAGS<>4 )) and (T2.M_ECPE_TYPE1 = 1) then 'Equal to'
		when ( M_RAT_DISP <>1 or (T1.M_FLAGS<>1 and T1.M_FLAGS<>4 )) and (T2.M_ECPE_TYPE1 = 2) then 'Deduced from'
	end as CalcEndSchd1Leg2,
	case	when ( M_RAT_DISP <>1 or (T1.M_FLAGS<>1 and T1.M_FLAGS<>4 ))and  (T2.M_ECPE_TYPE1 = 0) then ' '
		when (M_RAT_DISP =1 and (T1.M_FLAGS=1 or T1.M_FLAGS=4 )) and (T2.M_ECPE_UNDR0 = -1) then ' '
		when (M_RAT_DISP =1 and (T1.M_FLAGS=1 or T1.M_FLAGS=4 )) and (T2.M_ECPE_UNDR0 = 0) then 'Payment schedule' 
		when (M_RAT_DISP =1 and (T1.M_FLAGS=1 or T1.M_FLAGS=4 )) and (T2.M_ECPE_UNDR0 = 1) then 'Calculation start schedule'
		when (M_RAT_DISP =1 and (T1.M_FLAGS=1 or T1.M_FLAGS=4 )) and (T2.M_ECPE_UNDR0 = 2) then 'Fixing schedule'
		when (M_RAT_DISP =1 and (T1.M_FLAGS=1 or T1.M_FLAGS=4 )) and (T2.M_ECPE_UNDR0 = 8) then 'Delivery schedule'
		when ( M_RAT_DISP <>1 and (T1.M_FLAGS=1 or T1.M_FLAGS=4 )) then ' '
		when ( M_RAT_DISP <>1 or (T1.M_FLAGS<>1 and T1.M_FLAGS<>4 )) and (T2.M_ECPE_UNDR1 = -1) then ' '
		when ( M_RAT_DISP <>1 or (T1.M_FLAGS<>1 and T1.M_FLAGS<>4 )) and (T2.M_ECPE_UNDR1 = 0) then 'Payment schedule' 
		when ( M_RAT_DISP <>1 or (T1.M_FLAGS<>1 and T1.M_FLAGS<>4 )) and (T2.M_ECPE_UNDR1= 1) then 'Calculation start schedule'
		when ( M_RAT_DISP <>1 or (T1.M_FLAGS<>1 and T1.M_FLAGS<>4 )) and (T2.M_ECPE_UNDR1 = 2) then 'Fixing schedule'
		when ( M_RAT_DISP <>1 or (T1.M_FLAGS<>1 and T1.M_FLAGS<>4 )) and (T2.M_ECPE_UNDR1 = 8) then 'Delivery schedule'
	end as CalcEndSchd2Leg2,
	case	when (M_RAT_DISP <> 1 and (T1.M_FLAGS=1 or T1.M_FLAGS=4 ) or T2.M_ECPE_TYPE1 = 1) then ' ' 
                 when (T1.M_FLAGS=1 or T1.M_FLAGS=4 ) and (T2.M_ECPE_TYPE0 = 1)  then ' ' else to_char(T2.M_ECPE1) end as CalcEndSchd3Leg2,
 	case when M_RAT_DISP=1 and T1.M_FLAGS in (1, 65537, 131073, 4, 65540, 131076) and (T4.M_CATEGORY not in (0, 8)) then ' '	
		when M_RAT_DISP=1 and T1.M_FLAGS in (1, 65537, 131073, 4, 65540, 131076) and (T4.M_CATEGORY in (0,8)) and (T2.M_EP_TYPE0 = 0) then 'Driving schedule'
		when M_RAT_DISP=1 and T1.M_FLAGS in (1, 65537, 131073, 4, 65540, 131076) and (T4.M_CATEGORY in (0,8)) and (T2.M_EP_TYPE0= 1) then 'Equal to'
		when M_RAT_DISP=1 and T1.M_FLAGS in (1, 65537, 131073, 4, 65540, 131076) and (T4.M_CATEGORY in (0,8)) and (T2.M_EP_TYPE0= 2) then 'Deduced from'
		when M_RAT_DISP=1 and T1.M_FLAGS in (0, 2, 65538, 131074, 8, 65544, 131080) and (T2.M_EP_TYPE1 = 0) then 'Driving schedule'
		when M_RAT_DISP=1 and T1.M_FLAGS in (0, 2, 65538, 131074, 8, 65544, 131080)  and (T2.M_EP_TYPE1= 1) then 'Equal to'
		when M_RAT_DISP=1 and T1.M_FLAGS in (0, 2, 65538, 131074, 8, 65544, 131080)  and (T2.M_EP_TYPE1= 2) then 'Deduced from'
		when M_RAT_DISP=2 and T1.M_FLAGS in (1, 65537, 131073, 4, 65540, 131076) then ' '
		when M_RAT_DISP <>1 and T1.M_FLAGS in (0, 2, 65538, 131074, 8, 65544, 131080)  and (T2.M_EP_TYPE1 = 0) then 'Driving schedule'
		when M_RAT_DISP <>1 and T1.M_FLAGS in (0, 2, 65538, 131074, 8, 65544, 131080)  and (T2.M_EP_TYPE1= 1) then 'Equal to'
		when M_RAT_DISP <>1 and T1.M_FLAGS in (0, 2, 65538, 131074, 8, 65544, 131080)  and (T2.M_EP_TYPE1= 2) then 'Deduced from'
		when M_RAT_DISP=4 and T1.M_FLAGS in (1, 65537, 131073, 4, 65540, 131076) and (T4.M_CATEGORY not in (0,8) or T3.M_CATEGORY in (0,8)) then ' '
		when (M_RAT_DISP =4) and T1.M_FLAGS in (1, 65537, 131073, 4, 65540, 131076) and (T4.M_CATEGORY in (0,8)) and (T3.M_CATEGORY not in (0,8)) and (T2.M_EP_TYPE0= 0) then 'Driving schedule'
		when (M_RAT_DISP =4) and T1.M_FLAGS in (1, 65537, 131073, 4, 65540, 131076) and (T4.M_CATEGORY in (0,8)) and (T3.M_CATEGORY not in (0,8)) and (T2.M_EP_TYPE0= 1) then 'Equal to'
		when (M_RAT_DISP =4) and T1.M_FLAGS in (1, 65537, 131073, 4, 65540, 131076) and (T4.M_CATEGORY in (0,8)) and (T3.M_CATEGORY not in (0,8)) and (T2.M_EP_TYPE0= 2) then 'Deduced from'
	end as PaySchd1Leg2,
	case	when ( M_RAT_DISP <>1 or (T1.M_FLAGS<>1 and T1.M_FLAGS<>4 )) and  (T2.M_EP_TYPE1 = 0) then ' '
		when (M_RAT_DISP =1 and (T1.M_FLAGS=1 or T1.M_FLAGS=4 )) and ((T2.M_EP_UNDRL0 = -1) or (T2.M_EP_UNDRL0 = 0)) then ' '
		when (M_RAT_DISP =1 and (T1.M_FLAGS=1 or T1.M_FLAGS=4 )) and (T2.M_EP_UNDRL0 = 1) then 'Calculation start schedule'
		when (M_RAT_DISP =1 and (T1.M_FLAGS=1 or T1.M_FLAGS=4 )) and (T2.M_EP_UNDRL0 = 2) then 'Fixing schedule'
		when (M_RAT_DISP =1 and (T1.M_FLAGS=1 or T1.M_FLAGS=4 )) and (T2.M_EP_UNDRL0 = 7) then 'Calculation end schedule'
		when (M_RAT_DISP =1 and (T1.M_FLAGS=1 or T1.M_FLAGS=4 )) and (T2.M_EP_UNDRL0 = 8) then 'Delivery schedule'
		when ( M_RAT_DISP <>1 and (T1.M_FLAGS=1 or T1.M_FLAGS=4 )) then ' '
		when ( M_RAT_DISP <>1 or (T1.M_FLAGS<>1 and T1.M_FLAGS<>4 )) and ((T2.M_EP_UNDRL1 = -1) or (T2.M_EP_UNDRL1 = 0)) then ' '
		when ( M_RAT_DISP <>1 or (T1.M_FLAGS<>1 and T1.M_FLAGS<>4 )) and (T2.M_EP_UNDRL1= 1) then 'Calculation start schedule'
		when ( M_RAT_DISP <>1 or (T1.M_FLAGS<>1 and T1.M_FLAGS<>4 )) and (T2.M_EP_UNDRL1 = 2) then 'Fixing schedule'
		when ( M_RAT_DISP <>1 or (T1.M_FLAGS<>1 and T1.M_FLAGS<>4 )) and (T2.M_EP_UNDRL1 = 7) then 'Calculation end schedule'
		when ( M_RAT_DISP <>1 or (T1.M_FLAGS<>1 and T1.M_FLAGS<>4 )) and (T2.M_EP_UNDRL1 = 8) then 'Delivery schedule'
	end as PaySchd2Leg2,
    case when ((M_RAT_DISP =1 and T1.M_FLAGS in (1, 65537, 131073, 4, 65540, 131076) and (T4.M_CATEGORY in (0, 8))) or T2.M_EP_TYPE1 =1) then ' '
		when M_RAT_DISP=1  and T1.M_FLAGS in (1, 65537, 131073, 4, 65540, 131076) and (T4.M_CATEGORY not in (0,8)) and (T2.M_EP_TYPE1 <> 1)then to_char(T2.M_EP1)
		when M_RAT_DISP=1 and T1.M_FLAGS in (0, 2, 65538, 131074, 8, 65544, 131080) and (T2.M_EP_TYPE1 <> 1)then to_char(T2.M_EP1) 
		when M_RAT_DISP=2 and T2.M_EP_TYPE1 <> 1 then to_char(T2.M_EP1)
		when M_RAT_DISP=4 and T1.M_FLAGS in (1, 65537, 131073, 4, 65540, 131076) and (T4.M_CATEGORY in (0, 8)) and (T3.M_CATEGORY not in (0, 8)) then ' ' 
		when M_RAT_DISP=4 and (T4.M_CATEGORY not in (0, 8) or T3.M_CATEGORY in (0, 8)) and (T2.M_EP_TYPE1 <> 1)then to_char(T2.M_EP1) 
	end as PaySchd3Leg2,
case when (T1.M_FLAGS in (1,4) and T1.M_RAT_DISP= 1 ) then to_char(T2.M_EP_FREQ0) when (M_RAT_DISP <>1 and (T1.M_FLAGS in (1,4)) or T2.M_EP_FREQ1 in (-1,-2)) then ' ' else to_char(T2.M_EP_FREQ1) end as PayFrqLeg2 , 
----------------
----------------	
    case	when ((M_RAT_DISP =2)) or ((M_RATE_TYPE1=0))  then ' '														
		when ( M_RAT_DISP <>2  or (T1.M_FLAGS<>1 and T1.M_FLAGS<>4 ))and  (T2.M_EI_TYPE1 = 0) then 'Driving schedule'
		when ( M_RAT_DISP <>2 or (T1.M_FLAGS<>1 and T1.M_FLAGS<>4 )) and (T2.M_EI_TYPE1 = 1) then 'Equal to'
		when ( M_RAT_DISP <>2 or (T1.M_FLAGS<>1 and T1.M_FLAGS<>4 )) and (T2.M_EI_TYPE1 = 2) then 'Deduced from'
        when ( M_RAT_DISP <>2 or (T1.M_FLAGS<>1 and T1.M_FLAGS<>4 )) and (T2.M_EI_TYPE1 = 2) then 'Copy of'
	end as FixSchd1Leg2,
	case	when ( M_RAT_DISP=2 or (T1.M_FLAGS<>1 and T1.M_FLAGS<>4 )) and  (T2.M_EI_TYPE1 = 0) then ' '
		when ((M_RAT_DISP =2) or (M_RATE_TYPE1=0))  then ' '
		when (( M_RAT_DISP <>1 or (T1.M_FLAGS<>1 and T1.M_FLAGS<>4 )) and (T2.M_EI_UNDRL1 = -1))   then ' '
		when ( M_RAT_DISP <>1 or (T1.M_FLAGS<>1 and T1.M_FLAGS<>4 )) and (T2.M_EI_UNDRL1= 1) then 'Calculation start schedule'
		when ( M_RAT_DISP <>1 or (T1.M_FLAGS<>1 and T1.M_FLAGS<>4 )) and (T2.M_EI_UNDRL1 = 7) then 'Calculation end schedule' 
		when ( M_RAT_DISP <>1 or (T1.M_FLAGS<>1 and T1.M_FLAGS<>4 )) and (T2.M_EI_UNDRL1 = 0) then 'Payment schedule'
	end as FixSchd2Leg2,
case  
when M_RAT_DISP = 2 or M_RATE_TYPE1=0  then ' '
		when (M_RAT_DISP = 1 and (T1.M_FLAGS=1 or T1.M_FLAGS=4 ) or (T2.M_EI_TYPE1 = 1)) then ' '
                   when (T1.M_FLAGS=1 or T1.M_FLAGS=4 ) and (T2.M_EI_TYPE1 = 1) then ' '  else to_char(T2.M_EI1) end as FixSchd3Leg2,
-----------	
case	 
when M_RAT_DISP = 2 or M_RATE_TYPE1=0  then ' '
when (M_RAT_DISP <>2 and (T1.M_FLAGS in (1,4))) then to_char(T2.M_EI_FREQ0)
	when (M_RAT_DISP <>1 and (T1.M_FLAGS=1 or T1.M_FLAGS=4 ) or T2.M_EI_FREQ1 in (-1,-2)) then ' '	else to_char(T2.M_EI_FREQ1) end as FixFrqLeg2,
case when M_RAT_DISP=1 and T1.M_FLAGS in (1, 65537, 131073, 4, 65540, 131076) and (T4.M_CATEGORY not in (0, 8)) then ' '	
		when M_RAT_DISP=1  and (T4.M_CATEGORY in (0,8) and T1.M_FLAGS in (1, 65537, 131073, 4, 65540, 131076)) and (T2.M_SIMP_SCH0 = 0) then 'No'
		when M_RAT_DISP=1  and (T4.M_CATEGORY in (0,8) and T1.M_FLAGS in (1, 65537, 131073, 4, 65540, 131076)) and (T2.M_SIMP_SCH0 = 1) then 'Yes'
		when M_RAT_DISP=1  and (T1.M_FLAGS in (0, 2, 65538, 131074, 8, 65544, 131080)) and (T2.M_SIMP_SCH1 = 0) then 'No'
		when M_RAT_DISP=1  and (T1.M_FLAGS in (0, 2, 65538, 131074, 8, 65544, 131080)) and (T2.M_SIMP_SCH1 = 1) then 'Yes'
		when M_RAT_DISP=2  and T1.M_FLAGS in (1, 65537, 131073, 4, 65540, 131076) then ' '
		when M_RAT_DISP=2  and T1.M_FLAGS in (0, 2, 65538, 131074, 8, 65544, 131080) and (T2.M_SIMP_SCH1 = 0) then 'No'
		when M_RAT_DISP=2  and T1.M_FLAGS in (0, 2, 65538, 131074, 8, 65544, 131080) and (T2.M_SIMP_SCH1 = 1) then 'Yes'
		when M_RAT_DISP=4  and T1.M_FLAGS in (1, 65537, 131073, 4, 65540, 131076) and (T4.M_CATEGORY not in (0, 8) or T3.M_CATEGORY in (0, 8))then ' '
		when M_RAT_DISP=4  and T1.M_FLAGS in (0, 2, 65538, 131074, 8, 65544, 131080) and (T2.M_SIMP_SCH1 = 0) then 'No'
		when M_RAT_DISP=4  and T1.M_FLAGS in (0, 2, 65538, 131074, 8, 65544, 131080) and (T2.M_SIMP_SCH1 = 1) then 'Yes'
		when M_RAT_DISP=4  and T1.M_FLAGS in (1, 65537, 131073, 4, 65540, 131076) and (T4.M_CATEGORY in (0, 8) and T3.M_CATEGORY not in (0, 8)) and (T2.M_SIMP_SCH0 = 0) then 'No'
		when M_RAT_DISP=4  and T1.M_FLAGS in (1, 65537, 131073, 4, 65540, 131076) and (T4.M_CATEGORY in (0, 8) and T3.M_CATEGORY not in (0, 8)) and (T2.M_SIMP_SCH0 = 1) then 'Yes'
	end as SingPerLeg2,																		
	case	when (T2.M_RETINT1 = 0) then 'Return (P2-P1)/P1' when (T2.M_RETINT1 = 1) then 'Spread (P2-P1)' end as RetTypLeg2
-------------
--------------	
from RT_INSGN_DBF T1, RT_LNGN_DBF T2
----------
left outer join RT_INDEX_DBF  T3 on T2.M_INDEX0 = T3.M_INDEX
left outer join RT_INDEX_DBF  T4 on T2.M_INDEX1 = T4.M_INDEX
left outer join RT_LNDXG_DBF T5 on T2.M_GEN_NUM=T5.M_GEN_NUM
left outer join RT_INDEX_DBF T6 on T5.M_INDEX=T6.M_INDEX
-----------
-------------
where	T1.M_GEN_NUM = T2.M_GEN_NUM
and 	T1.M_INSTR_TYPE = 29
and	T1.M_CREAT_MODE = 0
and	T1.M_INSTR <> ' '																				
order by T1.M_INSTR, 50, 51;
quit;
