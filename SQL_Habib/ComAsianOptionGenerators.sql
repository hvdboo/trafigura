set colsep '#';
SET TERMOUT OFF;
SPOOL &1;
set linesize 2600;
set pagesize 2048;
select T1.M_INSTR as COMCapFloorGenerator, T1.M_INSTR_DESC as Description ,T1.M_NB_PHASE as Phases ,T3.M_IND_LAB as IndexLabel, 
case when (T4.M_IND_LAB is null ) then ' ' else T4.M_IND_LAB end as UnderlyingIndex,
case when (T8.M_LABEL is null or T2.M_USE_PROF0 = 0) then ' ' else T8.M_LABEL end as VolumeProfile,
-------
case when T11.M_LABEL is null then ' ' else T11.M_LABEL end as Formula,
-------
T2.M_CURRENCY0 as PaymentCurrency,T2.M_START0 as StartDelay, 
CAST(T2.M_PAY_CLN0 AS VARCHAR2(15)) as PaymentCalendar, CAST(T2.M_FIX_CLN0 AS VARCHAR2(15)) as Fixingcalendar,
case when (T1.M_BROKEN =0 ) then 'Up front'
	when (T1.M_BROKEN =1 ) then 'In arrears' 
	when (T1.M_BROKEN=3 ) then 'Both ends (backward)'
	when (T1.M_BROKEN = 5) then 'Both ends (forward)'
	when (T1.M_BROKEN = 2) then 'None' 
end as StubPeriod,
case when (T2.M_BROK_COUP0 =0 ) then 'Short coupon'   
	when (T2.M_BROK_COUP0 =1 ) then 'Long coupon' 
	when (T2.M_BROK_COUP0 =3 ) then 'Full coupon' 
	when (T2.M_BROK_COUP0 = 4) then 'Conditional' 
end as Coupon ,
case when  (T2.M_BROK_IND0  =0 ) then 'Current index'  
	when (T2.M_BROK_IND0  = 1 ) then 'Closest index'  
	when (T2.M_BROK_IND0  = 2) then 'Next index'
	when (T2.M_BROK_IND0  = 3) then 'Previous index'  
	when (T2.M_BROK_IND0  = 4) then 'Interpolated' 
end as StubPeriodRate,
T2.M_BROK_COND0 as StubCondLeg1,
case when T2.M_FIXING0=0 then 'In advance' 
	when T2.M_FIXING0=1 then 'In arrears' 
end as Fixing ,
case when T2.M_PAYMENT0=0 then 'In arrears' 
	when T2.M_PAYMENT0=1 then 'Up front'
	when T2.M_PAYMENT0=2 then 'Up front disc.'
end as Payment,
case when (T2.M_ROUND_RUL0 = 0) then 'None' 
	when (T2.M_ROUND_RUL0 = 1) then 'Nearest' 
	when (T2.M_ROUND_RUL0 = 2) then 'By default' 
	when (T2.M_ROUND_RUL0 = 3) then 'By excess' 
end as RoundingRule,
case when (T2.M_ROUND_RUL0 =1 or T2.M_ROUND_RUL0 =2 or T2.M_ROUND_RUL0 =3) then to_char(T2.M_DECIMALS0)
	else ' ' end as Dec,
case when T2.M_ECP_TYPE0=0 then 'DrivingSchedule'
	when T2.M_ECP_TYPE0=1 then 'EqualTo'
	when T2.M_ECP_TYPE0=2 then 'DeducedFrom'
end as CalculationStartSchedule,
case when T2.M_ECP_UNDRL0=-1 then ' '
	when T2.M_ECP_UNDRL0=7 then 'CalculationEndSchedule'
	when T2.M_ECP_UNDRL0=0 then 'Payment Schedule'
	when T2.M_ECP_UNDRL0=2 then 'Fixing Schedule'
	when T2.M_ECP_UNDRL0=8 then 'Delivery Schedule'
end as CalculationStartBis, 
CAST(T2.M_ECP0 AS VARCHAR2(20)) as ScheduleGenerator,
case when T2.M_ECPE_TYPE0=0 then 'DrivingSchedule'
	when T2.M_ECPE_TYPE0=1 then 'EqualTo'
	when T2.M_ECPE_TYPE0=2 then 'DeducedFrom'
end as CalculationEndSchedule,
case when T2.M_ECPE_UNDR0=1 then 'CalculationStartSchedule' 
	when T2.M_ECPE_UNDR0=2 then 'Fixing Schedule'
	when T2.M_ECPE_UNDR0=8 then 'Delivery Schedule'
	when T2.M_ECPE_UNDR0=0 then 'Payment Schedule'
	when T2.M_ECPE_UNDR0=-1 then ' '         
end as CalculationEndBis,
CAST(T2.M_ECPE0 AS VARCHAR2(20)) as CalcEndDeduction,
case when T2.M_EP_TYPE0=0 then 'DrivingSchedule'
	when T2.M_EP_TYPE0=1 then 'Equal to'
	when T2.M_EP_TYPE0=2 then 'Deduced from'
end as PaymentSchedule,
case when T2.M_EP_UNDRL0=1 then 'CalculationStartSchedule' 
	when T2.M_EP_UNDRL0=7 then 'CalculationEndSchedule' 
	when T2.M_EP_UNDRL0=2 then 'Fixing Schedule' 
	when T2.M_EP_UNDRL0=8 then 'Delivery Schedule'
	when T2.M_EP_UNDRL0=-1 then ' '       
end as PaymentBis,
T2.M_EP0 as PayDeduction,T2.M_EP_FREQ0 as PaymentFreq,
case when T2.M_EI_TYPE0=0 then 'DrivingSchedule'
	when T2.M_EI_TYPE0=1 then 'Equal to'
	when T2.M_EI_TYPE0=2 then 'Deduced from'
end as FixingSchedule,
case when T2.M_EI_UNDRL0=1 then 'CalculationStartSchedule' 
	when T2.M_EI_UNDRL0=7 then 'CalculationEndSchedule'
	when T2.M_EI_UNDRL0=0 then 'Payment Schedule'
	when T2.M_EI_UNDRL0=8 then 'Delivery Schedule'
	when T2.M_EI_UNDRL0=-1 then ' '        
end as FixingBis,
T2.M_EI0 as FixDeduction,T2.M_EI_FREQ0 as FixingFreq,
case when T2.M_DLV_TYPE0=1 then 'Equal to' 
	when T2.M_DLV_TYPE0=4 then 'Manual Schedule'            
end as DeliverySchedule, 
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
-------
case when T2.M_SIMP_SCH0=0 then 'No' 
when T2.M_SIMP_SCH0=1 then 'Yes' end as SinglePeriod ,
-------
case when (T2.M_CURRENCY0 = T2.M_INTRS_CUR0 and T2.M_CURRENCY0 = T2.M_INTRM_CUR0 and T2.M_CURRENCY0 = T2.M_FINAL_CUR0) then 'UNCHECKED' 
else 'CHECKED' end as MultiCurrency,
T2.M_CURRENCY0 as InitialCapital,
T2.M_INTRS_CUR0 as InterestFlows,
T2.M_INTRM_CUR0 as IntermediateCapital,
T2.M_FINAL_CUR0 as FinalCapital,
-------
case when (T2.M_INDEXED0 = 0 ) then 'UNCHECKED' when (T2.M_INDEXED0 = 1 ) then 'CHECKED' end as Indexed,
-------
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
end as IndListTyp,
-------
case when (T5.M_RAT_TYPE is NULL) then ' ' 
when (T5.M_RAT_TYPE=0) then 'Floating'
when (T5.M_RAT_TYPE=1) then 'Fixed'
when (T5.M_RAT_TYPE=2) then 'Optional'
end as IndType,
-------
case when  T5.M_RAT_TYPE <> 0 then ' '
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
case when T6.M_IND_LAB is null then ' '
	when  T5.M_RAT_TYPE <> 0 then ' '
else T6.M_IND_LAB end as IndexedLab,
-------
case when (T5.M_RETINRP is null or T5.M_IND_NAT <> 3 or T5.M_RAT_TYPE <> 0 ) then ' '
when (T5.M_RETINRP=0) then 'Piecewise'
when (T5.M_RETINRP=1) then 'Linear'
when (T5.M_RETINRP=2) then 'Log Linear'
end as RetInterpol,
-------
case when (T5.M_RSHIFT is NULL or T5.M_IND_NAT <> 3 or T5.M_RAT_TYPE <> 0 ) then ' '
else T5.M_RSHIFT
end as RetFixLag,
-------
case when (T5.M_I_FORMULA is NULL) then ' ' else to_char(T5.M_I_FORMULA) end as IndFormula,
case when (T5.M_OPERAND is NULL) then ' ' 
when (T5.M_OPERAND=0) then 'Factor (xP)' 
when (T5.M_OPERAND=1) then 'Spread (+P)' 
when (T5.M_OPERAND=2) then 'Increase (x(1+P))' 
when (T5.M_OPERAND=3) then 'Replace (=P)' 
end as Operand,
-------
case when (T5.M_FORMULA is NULL) then ' ' 
when (T5.M_FORMULA=0) then 'Plain index (P) '
when (T5.M_FORMULA=1) then 'Period Return (P=(P2-P1)/P1)'
when (T5.M_FORMULA=2) then 'Period Ratio (P=P2/P1)'
when (T5.M_FORMULA=3) then 'Initial Return (P=(P2-P0)/P0)'
when (T5.M_FORMULA=4) then 'Initial ratio (P=P2/P0)'
when (T5.M_FORMULA=5) then 'Inverse (P=(1/P))'
when (T5.M_FORMULA=6) then 'UserDefined'
end as IndexedFormula,
-------
case when T5.M_FORMULA <> 6 or T10.M_BUFFER is null then ' ' else T10.M_BUFFER end as UserFormula,
-------
case when (T5.M_OPTION is NULL) then ' ' 
when (T5.M_OPTION=0) then 'No'
when (T5.M_OPTION=1) then 'Max'
when (T5.M_OPTION=2) then 'Min'
when (T5.M_OPTION=3) then 'Collar'
end as IndOption,
-------
case when T5.M_OPTION = 0 or T5.M_STRIKE is null then ' ' else to_char(T5.M_STRIKE) end as Strike_FloorStrike,
case when T5.M_OPTION <> 3 or T5.M_STRIKE  is null then ' ' else to_char(T5.M_SSTRIKE) end as CapStrike,
-------
case when  (T5.M_CMP_MOD=0) then 'Single'
	when  (T5.M_CMP_MOD=1) then 'cumulative'
 else ' ' end as ComputationMode,
-------
case when (T5.M_SCHED_TYPE is NULL) then ' ' 
when (T5.M_SCHED_TYPE=0) then 'Equal To'
when (T5.M_SCHED_TYPE=1) then 'Shifted from'
end as SchedType, 
-------
case when (T5.M_UND_SCHED is null) then ' ' 
when (T5.M_UND_SCHED=0) then 'Payment schedule'
when (T5.M_UND_SCHED=1) then 'Calculation schedule'
when (T5.M_UND_SCHED=2) then 'Reset schedule'
when (T5.M_UND_SCHED=9) then 'Trade Date'
end as UndSched,
-------
case when (T5.M_SCHED_TYPE=1) then T5.M_SCHED0 else ' ' end as PorP2Shif,
case when (T5.M_SCHED_TYPE=1) then T5.M_SCHED1 else ' ' end as P0orP1Shif,
case when (T5.M_SCHED_TYPE=1) then T5.M_CALENDAR else ' ' end as Calend,
-------
case when (T5.M_FREQ is NULL) then ' ' else to_char(T5.M_FREQ) end as FreqRatio,
-------
case when (T5.M_DATE_POS is null) then ' ' 
when (T5.M_DATE_POS=0) then 'Unchecked'
when (T5.M_DATE_POS=1) then 'Checked'
end as UpFront,
-------
case when (T5.M_FACTOR is NULL) then ' ' else to_char(T5.M_FACTOR) end as IndFactor,
case when (T5.M_P_FACTOR is NULL) then ' ' else to_char(T5.M_P_FACTOR) end as PriceFactor,
case when (T5.M_REPL is NULL) then ' ' 
when (T5.M_REPL=0) then 'Unchecked'
when (T5.M_REPL=1) then 'Checked'
end as Replacement,
-------
case when (T5.M_RND_RL0 is NULL) then ' ' 
when (T5.M_RND_RL0=0) then 'None'
when (T5.M_RND_RL0=1) then 'Nearest'
when (T5.M_RND_RL0=2) then 'By default'
when (T5.M_RND_RL0=3) then 'By excess'
end as IndeRdngRul,
-------
case when (T5.M_RND_RLD0 is NULL) or T5.M_RND_RL0=0 then ' ' else to_char(T5.M_RND_RLD0) end as IndRdgDec,
-------
case when (T5.M_RND_RL1 is NULL) then ' ' 
when (T5.M_RND_RL1=0) then 'None'
when (T5.M_RND_RL1=1) then 'Nearest'
when (T5.M_RND_RL1=2) then 'By default'
when (T5.M_RND_RL1=3) then 'By excess'
end as IndPostRdngRul,
-------
case when (T5.M_RND_RLD1 is NULL) or T5.M_RND_RL1=0 then ' ' else to_char(T5.M_RND_RLD1) end as IndPostRdngDec,
case when (T5.M_P_MARGIN is NULL) then ' ' else to_char(T5.M_P_MARGIN) end as PriceMargin
-------
from RT_INSGN_DBF T1, RT_LNGN_DBF T2
left outer join RT_INDEX_DBF  T3 on T2.M_INDEX0 = T3.M_INDEX
left outer join RT_INDEX_DBF T4 on T3.M_UNDRL= T4.M_INDEX
left outer join RT_LNDXGL_DBF T20 left outer join RT_LNDXG_DBF T5 on T20.M_REF_INDEXATION_TEMPL=T5.M_REFERENCE on T2.M_REFERENCE=T20.M_REF_LOAN_GENERATOR
left outer join RT_INDEX_DBF T6 on T5.M_INDEX=T6.M_INDEX
left outer join DLV_SCHED_DBF T7 on T7.M_REFERENCE=T2.M_DLV_SUB0
left outer join CM_PROFH_DBF T8 on T8.M_REFERENCE=T2.M_PROFILE0
left outer join FRM_FILE_DBF T10 on T10.M_GROUP=T5.M_FOR_ID
left outer join CM_MKTSR_DBF T11 on rtrim(TRIM(LEADING 'P' from T2.M_FORMULA0))=to_char(T11.M_SERIE)
left outer join CM_MKTSR_DBF T12 on rtrim(TRIM(LEADING 'P' from T2.M_FORMULA1)) = to_char(T12.M_SERIE)
where T1.M_GEN_NUM = T2.M_GEN_NUM
and T1.M_CREAT_MODE=0 
and T1.M_INSTR_TYPE=12        
order by T1.M_INSTR;
quit;
SPOOL OFF;