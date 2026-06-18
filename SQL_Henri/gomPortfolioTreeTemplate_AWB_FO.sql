select 
case
when t0.M_TRE_GROUP='MUB' then '<P&L CONTROL>' else p0.M_LABEL  end as TREE, 
rtrim(t0.M_LABEL) NODE0, rtrim(t1.M_LABEL) NODE1, rtrim(t2.M_LABEL) NODE2, rtrim(t3.M_LABEL) NODE3, 
rtrim(t4.M_LABEL) NODE4, rtrim(t5.M_LABEL) NODE5, rtrim(t6.M_LABEL) NODE6, rtrim(t7.M_LABEL) NODE7,
' ',
rtrim(pfl.M_LABEL) PFL_LAB, rtrim(pfl.M_DSP_LABEL) PFL_DSP, rtrim(pfl.M_DESC) PFL_DES, 
rtrim(pfl.M_ENTITY) PFL_ENT, pfl.M_ACCCUR PFL_CUR,
rtrim(udf.M_NAT_PTF) PFL_NAT
from ${FIN_schema}MUB#MUB_TREE_DBF t0 
left join ${FIN_schema}MUB#MUB_TREE_DBF t1 on (t0.M_REF=t1.M_FATHER_R and t0.M_HEIGHT=0 and t0.M_TRE_GROUP=t1.M_TRE_GROUP) 
left join ${FIN_schema}MUB#MUB_TREE_DBF t2 on (t1.M_REF=t2.M_FATHER_R and t1.M_HEIGHT=1 and t1.M_TRE_GROUP=t2.M_TRE_GROUP) 
left join ${FIN_schema}MUB#MUB_TREE_DBF t3 on (t2.M_REF=t3.M_FATHER_R and t2.M_HEIGHT=2 and t2.M_TRE_GROUP=t3.M_TRE_GROUP) 
left join ${FIN_schema}MUB#MUB_TREE_DBF t4 on (t3.M_REF=t4.M_FATHER_R and t3.M_HEIGHT=3 and t3.M_TRE_GROUP=t4.M_TRE_GROUP) 
left join ${FIN_schema}MUB#MUB_TREE_DBF t5 on (t4.M_REF=t5.M_FATHER_R and t4.M_HEIGHT=4 and t4.M_TRE_GROUP=t5.M_TRE_GROUP) 
left join ${FIN_schema}MUB#MUB_TREE_DBF t6 on (t5.M_REF=t6.M_FATHER_R and t5.M_HEIGHT=5 and t5.M_TRE_GROUP=t6.M_TRE_GROUP) 
left join ${FIN_schema}MUB#MUB_TREE_DBF t7 on (t6.M_REF=t7.M_FATHER_R and t6.M_HEIGHT=6 and t6.M_TRE_GROUP=t7.M_TRE_GROUP)
left join ${FIN_schema}MUB#MUB_TREE_DBF t8 on (t7.M_REF=t8.M_FATHER_R and t7.M_HEIGHT=7 and t7.M_TRE_GROUP=t8.M_TRE_GROUP) 
left join ${FIN_schema}MUB#MUB_TPL_DBF p0 on t0.M_TRE_GROUP=cast(p0.M_REFERENCE as char(1)) 
left join ${FIN_schema}TRN_PFLD_DBF pfl on rtrim(t7.M_LABEL) = rtrim(pfl.M_LABEL)
left join ${FIN_schema}TABLE#DATA#PORTFOLI_DBF udf on rtrim(pfl.M_LABEL) = rtrim(udf.M_LABEL)
where t0.M_HEIGHT=0 and t0.M_TRE_GROUP='MUB'
order by p0.M_REFERENCE, NODE0, NODE1, NODE2, NODE3, NODE4, NODE5, NODE6, NODE7
