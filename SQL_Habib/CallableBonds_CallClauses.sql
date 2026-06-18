set colsep '#';
SET TERMOUT OFF;
SPOOL &1;
set linesize 1004;
set pagesize 2048;
select T1.M_SE_D_LABEL as Label ,  
case when (T7.M_BD_TG_MT = 1 ) then 'Call' else 'None' end as ClausesType,
case when (T7.M_BD_TG_MT = 1)  then (case when (T6.M_BD_TGS_CMW = 0) then 'UNCHECKED' else 'CHECKED' end)
else 'Not applicable' end  as MakeWholeCall,
case when (T6.M_BD_TGS_CTT = 0) then 'UNCHECKED' else 'CHECKED' end as TriggerFunctionOfTime,
case when (T6.M_BD_TGS_CDM = 0) then 'Business' else 'Calendar' end as DateMode,
case when (T7.M_BD_TG_BD  is null) then ' ' else to_char(T7.M_BD_TG_BD,'DD MON YY' ) end as StartDate,
case when (T7.M_BD_TG_ED  is null) 	 then ' ' else to_char(T7.M_BD_TG_ED,'DD MON YY') end as EndDate,
case when (T7.M_BD_TG_TY = 0) then 'Price'
	when (T7.M_BD_TG_TY = 1) then 'Yield'
	else 'error' end as RepaymentType, T7.M_BD_TG_FPA0 as Repayment,
case when (T7.M_BD_TG_MOD = 0) then 'Equity Spot' when (T7.M_BD_TG_MOD = 1) then 'No' when (T7.M_BD_TG_MOD = 2) then 'Outstanding Amount' end as TriggerMode,
case when ((T7.M_BD_TG_MT = 1) and (T7.M_BD_TG_MOD = 0)) then (case when (T7.M_BD_TG_LT =0 ) then 'Abs' when (T7.M_BD_TG_LT =1 ) then '%Re' when (T7.M_BD_TG_LT =2 ) then '% of initial CP' when (T7.M_BD_TG_LT =3 ) then '% of current CP' end) else 'Not applicable' end as TriggerExpression,
case when (T7.M_BD_TG_MOD = 0) then to_char(T7.M_BD_TG_LE) else 'Trigger Mode != Equity Spot' end as TriggerValueT1,
case when (T6.M_BD_TGS_CTT = 1) then to_char(T7.M_BD_TG_ELE) else 'Trigger Value is not a function of Time' end as TriggerValueT2,
case when ((T7.M_BD_TG_MT = 1) and (T7.M_BD_TG_MOD = 0))  then (case when (T7.M_BD_TG_OT = 0) then 'Hard'	when (T7.M_BD_TG_OT = 1) then 'Consecutive' when (T7.M_BD_TG_OT = 2) then 'Any' end)
	else 'Not applicable' end as ObservationType,
case when ((T7.M_BD_TG_MT = 1) and (T7.M_BD_TG_MOD = 0) and (T7.M_BD_TG_OT in (1,2))) then to_char(T7.M_BD_TG_NOD)
else 'Not applicable' end as NumberOfDays,
case when ((T7.M_BD_TG_MT = 1) and (T7.M_BD_TG_MOD = 0) and (T7.M_BD_TG_OT =2)) then to_char(T7.M_BD_TG_OOF)
else 'Not applicable' end as OutOf,
case when (T7.M_BD_TG_MAT = 0) then 'None' 
	when (T7.M_BD_TG_MAT= 2) then 'Start date' 
	when (T7.M_BD_TG_MAT= 1) then 'End date'
	else 'Not applicable'  end as Maturity,
T7.M_BD_TG_CD as NoticePeriod,
case when (T7.M_BD_TG_LND  is null) then ' ' else to_char(T7.M_BD_TG_LND,'DD MON YY') end as LastNoticeDate,	
case when (T7.M_BD_TG_AP = 0) then 'No'
	when (T7.M_BD_TG_AP = 1) then 'Yes'
	else ' ' end  as AccrualsPaid,
case when (T7.M_BD_TG_CF = 0) then 'No'
	when (T7.M_BD_TG_CF = 1) then 'Yes' else ' ' end as CouponForfeit,
case when (T6.M_BD_TGS_CMW = 1 ) then to_char(T7.M_BD_TG_MP) else 'Makewhole is not on call' end as MakeWholePremium, 
case when (T6.M_BD_TGS_CMW = 1 ) then to_char(T7.M_BD_TG_MF) else 'Makewhole is not on call' end as MakeWholeFloor,
T7.M_BD_TG_FCS as MinimumOutstanding
from SE_HEAD_DBF  T1, SE_ROOT_DBF T2, TRN_CPDF_DBF T3, SE_MKTOP_DBF T4, RT_SEN_DBF T5, BD_BOND_DBF  T6, BD_TRIG_DBF T7, RT_LNSEC_DBF T8, RT_INSGN_DBF T9, SE_TRDC_DBF T10,  SE_TRDS_DBF T11,  RT_LNGN_DBF T12, SE_SRNDR_DBF T13
where T1.M_SE_LABEL	= T2.M_SE_LABEL	
and  T7.M_BD_TG_MT     =   1 
and	T1.M_SE_GROUP	= 'Bond'
and T1.M_SE_TYPE	= 'Callable' 
and	T1.M_SE_LABEL	= T4.M_SE_LABEL 
and	T6.M_BD_INUM	= T4.M_SE_INUM 
and T9.M_GEN_NUM 	= T6.M_BD_GEN 
and	T2.M_SE_TRDCL 	= T10.M_SE_TRDCL 
and	T10.M_SE_TCS_L	= T11.M_SE_TCS_L 
and T1.M_SE_ISS    = T3.M_LABEL (+)
and T4.M_SE_INUM   = T8.M_NB (+)
and T4.M_SE_INUM   = T7.M_BD_INUM  
and T1.M_SE_SEN    = T5.M_REFERENCE	(+)
and	T9.M_GEN_NUM    = T12.M_GEN_NUM
and T2.M_SE_RND_R = T13.M_REFERENCE (+)
-------
and case when T8.M_IDENTITY is null then 0 else T8.M_IDENTITY end in
(select min(M_IDENTITY) from RT_LNSEC_DBF group by M_NB UNION select 0 from DUAL)
-----------
order by  T1.M_SE_D_LABEL;	
quit;
SPOOL OFF;