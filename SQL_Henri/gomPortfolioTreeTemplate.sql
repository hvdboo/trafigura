select 
case
when t0.M_TRE_GROUP='MUB' then '<P&L CONTROL>' else p0.M_LABEL end TREE, 
rtrim(t0.M_LABEL) ROOT, 
rtrim(t1.M_LABEL) PC, 
rtrim(t2.M_LABEL) ES, 
rtrim(t3.M_LABEL) CE, 
rtrim(t4.M_LABEL) MASTER, 
rtrim(t5.M_LABEL) CATEGORY, 
rtrim(t6.M_LABEL) OWNER, 
rtrim(t7.M_LABEL) PFL, '' X,
-- rtrim(pfl.M_LABEL) as M_PFL_LAB, 
rtrim(pfl.M_DSP_LABEL) as PFL_DSP, rtrim(pfl.M_DESC) as PFL_DES, 
rtrim(pfl.M_ENTITY) as PFL_ENT, 
rtrim(ctpo.M_DSP_LABEL) as PFL_PROC
from MUB#MUB_TREE_DBF t0 
left join MUB#MUB_TREE_DBF t1 on (t0.M_REF=t1.M_FATHER_R and t0.M_HEIGHT=0 and t0.M_TRE_GROUP=t1.M_TRE_GROUP) 
left join MUB#MUB_TREE_DBF t2 on (t1.M_REF=t2.M_FATHER_R and t1.M_HEIGHT=1 and t1.M_TRE_GROUP=t2.M_TRE_GROUP) 
left join MUB#MUB_TREE_DBF t3 on (t2.M_REF=t3.M_FATHER_R and t2.M_HEIGHT=2 and t2.M_TRE_GROUP=t3.M_TRE_GROUP) 
left join MUB#MUB_TREE_DBF t4 on (t3.M_REF=t4.M_FATHER_R and t3.M_HEIGHT=3 and t3.M_TRE_GROUP=t4.M_TRE_GROUP) 
left join MUB#MUB_TREE_DBF t5 on (t4.M_REF=t5.M_FATHER_R and t4.M_HEIGHT=4 and t4.M_TRE_GROUP=t5.M_TRE_GROUP) 
left join MUB#MUB_TREE_DBF t6 on (t5.M_REF=t6.M_FATHER_R and t5.M_HEIGHT=5 and t5.M_TRE_GROUP=t6.M_TRE_GROUP) 
left join MUB#MUB_TREE_DBF t7 on (t6.M_REF=t7.M_FATHER_R and t6.M_HEIGHT=6 and t6.M_TRE_GROUP=t7.M_TRE_GROUP)
--left join MUB#MUB_TREE_DBF t8 on (t7.M_REF=t8.M_FATHER_R and t7.M_HEIGHT=7 and t7.M_TRE_GROUP=t8.M_TRE_GROUP) 
left join MUB#MUB_TPL_DBF p0 on t0.M_TRE_GROUP=cast(p0.M_REFERENCE as char(1)) 
left join TRN_PFLD_DBF pfl on t7.M_D_DATA2 = pfl.M_REF
-- left join TABLE#DATA#PORTFOLI_DBF udf on rtrim(pfl.M_LABEL) = rtrim(udf.M_LABEL)
left join TRN_CPDF_DBF ctpo on pfl.M_PROC_AREA = ctpo.M_ID
left join TRN_CPDF_DBF ctps on pfl.M_SERVICER  = ctps.M_ID
left join TRD_SEC_DBF trs on pfl.M_TRDSECTION = trs.M_ID
where t0.M_HEIGHT=0
order by p0.M_REFERENCE, t0.M_LABEL, t1.M_LABEL, t2.M_LABEL, t3.M_LABEL, t4.M_LABEL, t5.M_LABEL, t6.M_LABEL, t7.M_LABEL