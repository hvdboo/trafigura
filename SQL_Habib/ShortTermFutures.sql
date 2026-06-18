set colsep '#';
SET TERMOUT OFF;
SPOOL &1;
set linesize 800;
set pagesize 2048;
select	T1.M_SE_D_LABEL as ShortFuture,T1.M_SE_I_CODE as InternalCode, T1.M_SE_F_NAME as FullName, 
	case when (T4.M_FU_MODE= 0) then 'Generic' 
		when (T4.M_FU_MODE= 1) then 'Generator driven' 
when (T4.M_FU_MODE= 2) then 'Generator driven (leg npv)'
	end as FutureMode, 
	case when (T5.M_INSTR is null ) then ' ' else T5.M_INSTR end as Generator,
	CAST(T2.M_SE_CUR AS VARCHAR2(10)) as Currency,T6.M_IND_LAB as UnderlyingIndex ,T2.M_SE_MARKET as Market,T2.M_SE_TCQ_L as Quotation,
	 T2.M_SE_MAT_SET as Maturities ,CAST(T4.M_FU_MARG_MS AS VARCHAR2(25)) as MarginingMaturitySet,
	T4.M_FU_TICK as TickSize,
	case when (T4.M_FU_DBASE0 = 0) then 'Equal to' 
		when (T4.M_FU_DBASE0 = 1) then 'Deduced from' 
	end as StartDate1 ,
	case when (T4.M_FU_DREF0= 0) then 'Expiry date' 
		when (T4.M_FU_DREF0= 1) then 'Value date' 
when (T4.M_FU_DREF0= 3) then 'System date'
	end as StartDate2, 
	CAST(T4.M_FU_SHIFTR0 AS VARCHAR2(20)) as StartDateShifter, 
	case	when (T4.M_FU_DBASE1 = 0) then 'Equal to' 
		when (T4.M_FU_DBASE1 = 1) then 'Deduced from' 
	end as MaturityDate1 ,
	case when (T4.M_FU_DREF1= 0) then 'Expiry date' 
		when (T4.M_FU_DREF1= 1) then 'Value date'
		when (T4.M_FU_DREF1= 2) then 'Start date'
	end as MaturityDate2, 
	CAST(T4.M_FU_SHIFTR1 AS VARCHAR2(20)) as MaturityDateShifter,
	T4.M_FU_PERIOD as PaymentPeriod, T4.M_FU_RT_CONV as RateConvention ,T2.M_SE_SEC_LS0 as Nominal , 
	case when (T4.M_FU_MARG = 0) then 'None' 
		when (T4.M_FU_MARG = 1) then 'Formula basis' 
		when (T4.M_FU_MARG = 2) then 'Tick basis'  
	end as Margining,
	case when (T4.M_FU_MARG_FQ = 0) then 'Daily' 
		when (T4.M_FU_MARG_FQ = 1) then 'Maturity set' 
		when (T4.M_FU_MARG_FQ = 2) then 'Monthly'  
	end as Margining2,  
	case when (T4.M_FU_MARG_F  = 0) then 'Price' 
		when (T4.M_FU_MARG_F  = 1) then 'Price/(1+ X DT)' 
		when (T4.M_FU_MARG_F = 3) then 'DI rate'
		when (T4.M_FU_MARG_F = 4) then 'DDI rate'  
	end as MarginBasedOn,
case 	when (T4.M_FU_MCFINAN=0) then 'No'
	when (T4.M_FU_MCFINAN=1) then 'Yes'
	end as Financing,
case when (T4.M_FU_CFRNDR=0) then 'None'
when (T4.M_FU_CFRNDR=1) then 'Nearest'
when (T4.M_FU_CFRNDR=2) then 'By default'
when (T4.M_FU_CFRNDR=3) then 'By excess'
end as CorrRndRule, T4.M_FU_CFRNDD as CorrRndDec, 
-------
case when (T4.M_FU_RFRNDR=0) then 'None'
when (T4.M_FU_RFRNDR=1) then 'Nearest'
when (T4.M_FU_RFRNDR=2) then 'By default'
when (T4.M_FU_RFRNDR=3) then 'By excess'
end as RollRndRul, T4.M_FU_RFRNDD as RollRndDec
-------
from SE_HEAD_DBF  T1 , SE_ROOT_DBF T2, SE_MKTOP_DBF T3 , FU_FUT_DBF T4
left outer join RT_INSGN_DBF T5 on T5.M_GEN_NUM = T4.M_FU_GEN
left outer join RT_INDEX_DBF T6 on T4.M_FU_UNDERL = T6.M_INDEX
where T3.M_SE_INUM = T4.M_FU_INUM
and T3.M_SE_LABEL = T2.M_SE_LABEL
and T2.M_SE_LABEL =T1.M_SE_LABEL
and  T1.M_SE_GROUP = 'Future'
and T1.M_SE_TYPE ='Plain'
and T1.M_SE_CATE ='Rate'
-------
order by T1.M_SE_D_LABEL;
quit;
SPOOL OFF;