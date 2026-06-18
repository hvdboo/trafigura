set colsep '#';
SET TERMOUT OFF;
SPOOL &1;
set linesize 593;
set pagesize 2048;
select T1.M_LABEL as CreditIndexName, 
case when T7.M_INSTR is null then ' '
else T7.M_INSTR end as Generator,
case when T11.M_INSTR_TYPE = -10 then 'SCDO'
	when T11.M_INSTR_TYPE = -11 then 'Credit index'
end as BskGenInstrumentType,
case when T12.M_INSTR is null then ' '
else T12.M_INSTR end as BasketGenerator,
case when T8.M_DFLT_DEF2 is null then ' '
else T8.M_DFLT_DEF2 end as Default_details,
CAST(T1.M_B_STARTDAT AS VARCHAR2(15)) as IndexStartDate, 
case when ( T1.M_B_MAT is NULL) then ' ' else to_char(T1.M_B_MAT) end as IndexMaturity,  
T1.M_B_PREM as Premium,
T1.M_B_IND_F as IndexFactor,
------
case when T15.M_LABEL is null then ' '
else T15.M_LABEL end as TrancheLabel,
case when T15.M_ATTACH is null then ' '
else to_char(T15.M_ATTACH) end as AttachPoint,
case when T15.M_ATTACH is null then ' '
else to_char(T15.M_DETACH) end as DetachPoint,
------
case when (T1.M_B_TYPE=0) then 'Relative'
	when (T1.M_B_TYPE=1) then 'Absolute'
end as BasketType,
case when (T9.M_TYPE=0) then 'Bond'
	when (T9.M_TYPE=1) then 'Issuer'
	when (T9.M_TYPE=2) then 'Basket'
end as Type,
case when ( T3.M_SE_D_LABEL is NULL) then ' ' else T3.M_SE_D_LABEL end as SecurityName,
T9.M_MARKET as Market, 
case when T13.M_LABEL is null or T9.M_TYPE=0 then ' '
	else T13.M_LABEL end as Seniority,   
case when (T1.M_B_TYPE=0) then T2.M_WEIGHT
	when (T1.M_B_TYPE=1) then T2.M_NOMINAL
end as WeightNominal, 
case  when ( T4.M_DSP_LABEL is NULL or T9.M_TYPE=0 ) then ' '
	else T4.M_DSP_LABEL 
end as Issuer,  
case when (T6.M_DFLT_DEF2 is NULL) then ' ' 
else T6.M_DFLT_DEF2 
end as DefaultDetails
------
------
from CR_BSKH_DBF T1, CR_BSKB_DBF T2 , SE_HEAD_DBF T3 , TRN_CPDF_DBF T4, 
CR_BSK_DD_DBF T5, CR_DD_DBF T6 ,
RT_INSGN_DBF T7, CR_DD_DBF T8, CR_ENTITY_DBF T9,
CR_B_G_LST_DBF T10, CR_BSK_GEN_DBF T11, RT_INSGN_DBF T12,
RT_SEN_DBF T13, CR_TR_LST_DBF T14, CR_TRANCHE_DBF T15
------
where T1.M__INDEX_= T2.M__INDEX_  
and T1.M_B_NATURE=1  
and T9.M_SECURITY =T3.M_SE_LABEL (+)
and T9.M_ISSUER =T4.M_LABEL (+)  
and T2.M_B_ENT_UID =T5.M_B_ENT_UID
and T2.M_B_ENT_UID =T9.M_B_ENT_UID (+)
and T1.M_B_DD =T8.M_UID (+)
and T5.M_DFLTD_UID =T6.M_UID (+)
and T1.M_B_GEN =T7.M_GEN_NUM (+)
and  T1.M__INDEX_ = T5.M_BSK_UID
and T5.M_DFLT_UID=0
and T1.M_B_GEN_SET = T10.M_CTN (+)
and T10.M_REF = T11.M_REFERENCE (+)
and T11.M_GEN_NUMBER = T12.M_GEN_NUM (+)
and T9.M_SENIORITY = T13.M_REFERENCE (+)
and T1.M_TR_SET = T14.M_CTN (+)
and T14.M_REF = T15.M_UID (+)
------
order by T1.M_LABEL, T12.M_INSTR, T15.M_LABEL, T4.M_DSP_LABEL, T3.M_SE_D_LABEL; 
quit;
SPOOL OFF;