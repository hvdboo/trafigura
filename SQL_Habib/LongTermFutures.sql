set colsep '#';
SET TERMOUT OFF;
SPOOL &1;
set linesize 520;
set pagesize 2048;
select  T1.M_SE_D_LABEL as LongFuture,T1.M_SE_I_CODE as InternalCode, T1.M_SE_CODE as SecurityCode, T1.M_SE_F_NAME as FullName,
	T1.M_SE_RTF0 as RealTimeCode,CAST(T2.M_SE_CUR AS VARCHAR2(10)) as Currency, T5.M_INSTR as BondGenerator ,T4.M_FU_RATE as Rate,  T4.M_FU_LEN as Length,
	case when (T4.M_FU_MARG_F= 7) then to_char(T4.M_FU_START_D, 'DD MON YY') else ' ' end as NotionalBondStartDate,
	T2.M_SE_MARKET as Market,T2.M_SE_TCQ_L as Quotation,  T2.M_SE_SEC_LS0 as LotSize, CAST(T2.M_SE_MAT_SET AS VARCHAR2(15)) as MaturitySet , 
	case when (T4.M_FU_CASH_DL = 0) then 'Cash' when ( T4.M_FU_CASH_DL = 1)  then 'Delivery' end as Settlement,
 	case when (T4.M_FU_MARG =  0) then 'No' when (T4.M_FU_MARG =  1) then 'Yes' end as Margining,
	case when (T4.M_FU_MARG_FQ= 0) then 'Daily' when (T4.M_FU_MARG_FQ=1) then 'Maturity Set' end as MarginingFrequency , 
	case when (T4.M_FU_MARG_F= 0) then 'Price' when (T4.M_FU_MARG_F= 2) then 'Notional bond price'
	when (T4.M_FU_MARG_F= 7) then 'Underlying bond price'
	end as MarginingRef,
 	CAST(T4.M_FU_MARG_MS AS VARCHAR2(20)) as MarginingMaturitySet  
-------
from SE_HEAD_DBF  T1 , SE_ROOT_DBF T2, SE_MKTOP_DBF T3 , FU_FUT_DBF T4, RT_INSGN_DBF T5	
-------
where	T4.M_FU_BD_GEN = T5.M_GEN_NUM
and 	T3.M_SE_INUM   = T4.M_FU_INUM
and	T3.M_SE_LABEL  = T2.M_SE_LABEL
and 	T2.M_SE_LABEL  = T1.M_SE_LABEL
and 	T1.M_SE_GROUP  = 'Future'
and 	T1.M_SE_TYPE   = 'Plain'
and 	T1.M_SE_CATE   = 'Bond' 
-------
order by T1.M_SE_D_LABEL;
quit;
SPOOL OFF;