set colsep '#';
SET TERMOUT OFF;
SPOOL &1;
set linesize 461;
set pagesize 2048;
select T1.M_LABEL as CreditBasketName , 
-----
case when T1.M_B_MAT is null then ' ' else to_char(T1.M_B_MAT) end as IndexMaturity, 
T1.M_B_IND_F as IndexFactor,
case when T9.M_LABEL is null then ' '
else T9.M_LABEL end as TrancheLabel,
case when T9.M_ATTACH is null then ' '
else to_char(T9.M_ATTACH) end as AttachPoint,
case when T9.M_ATTACH is null then ' '
else to_char(T9.M_DETACH) end as DetachPoint,
-----
case when ( T1.M_B_MAT is NULL) then ' ' else to_char(T1.M_B_MAT) end as Maturity, 
case when (T1.M_B_TYPE=0) then 'Relative'
	when (T1.M_B_TYPE=1) then 'Absolute'
end as BasketType,
case when (T7.M_TYPE=0) then 'Bond'
	when (T7.M_TYPE=1) then 'Issuer'
	when (T7.M_TYPE=2) then 'Basket'
end as Type,  
case when ( T3.M_SE_D_LABEL is NULL) then ' ' else T3.M_SE_D_LABEL end as SecurityName,  
T7.M_MARKET as Market, 
case when (T1.M_B_TYPE=0) then T2.M_WEIGHT
	when (T1.M_B_TYPE=1) then T2.M_NOMINAL
end as WeightNominal, 
case when T10.M_LABEL is null or T7.M_TYPE=0 then ' '
	else T10.M_LABEL end as Seniority, 
case  when ( T4.M_DSP_LABEL is NULL or T7.M_TYPE=0 ) then ' ' else T4.M_DSP_LABEL end as Issuer,  
-----
case when (T6.M_DFLT_DEF2 is NULL) then ' ' else T6.M_DFLT_DEF2 end as DefaultDetails    
-----
from CR_BSKH_DBF T1, CR_BSKB_DBF T2 , SE_HEAD_DBF T3, TRN_CPDF_DBF T4,CR_BSK_DD_DBF T5, CR_DD_DBF T6, CR_ENTITY_DBF T7,
CR_TR_LST_DBF T8, CR_TRANCHE_DBF T9, RT_SEN_DBF T10
-----
where T1.M__INDEX_=T2.M__INDEX_  
and T1.M_B_NATURE=0  
and T7.M_SECURITY = T3.M_SE_LABEL  (+)
and T7.M_ISSUER = T4.M_LABEL (+)
and T7.M_B_ENT_UID = T5.M_B_ENT_UID
and T5.M_DFLTD_UID =T6.M_UID (+)
and T2.M_B_ENT_UID = T7.M_B_ENT_UID (+)
and T1.M_TR_SET = T8.M_CTN (+)
and T8.M_REF = T9.M_UID (+)
and  T1.M__INDEX_ = T5.M_BSK_UID
and T7.M_SENIORITY = T10.M_REFERENCE (+)
-----
and T5.M_DFLT_UID=0
-----
order by T1.M_LABEL,T9.M_LABEL, T4.M_DSP_LABEL, T3.M_SE_D_LABEL;
quit;
