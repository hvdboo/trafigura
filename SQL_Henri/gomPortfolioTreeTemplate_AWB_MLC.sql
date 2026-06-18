select 
case when t0.M_TRE_GROUP='MUB' then '<P&L CONTROL>' else rtrim(p0.M_LABEL) end as TREE_MLC, 
rtrim(t1.M_LABEL) MLC_1, rtrim(t2.M_LABEL) MLC_2, rtrim(t3.M_LABEL) MLC_3, 
'#' ,
-- rtrim(pfl.M_LABEL) PFL_LAB, 
rtrim(pfl.M_DSP_LABEL) PFL_DSP, rtrim(pfl.M_DESC) PFL_DES, 
-- rtrim(udf.M_NAT_PTF) PFL_NAT, 
'#' , 
case when o1.M_TRE_GROUP='MUB' then '<P&L CONTROL>' else rtrim(o1.M_LABEL) end as TREE_FO, 
rtrim(o1.M_LABEL) FO_1, rtrim(o2.M_LABEL) FO_2, rtrim(o3.M_LABEL) FO_3,
rtrim(o4.M_LABEL) FO_4, rtrim(o5.M_LABEL) FO_5, rtrim(o6.M_LABEL) FO_6
from MUB#MUB_TREE_DBF t0 
left join MUB#MUB_TPL_DBF  p0 on t0.M_TRE_GROUP=cast(p0.M_REFERENCE as char(1))
left join MUB#MUB_TREE_DBF t1 on (t0.M_REF = t1.M_FATHER_R and t0.M_HEIGHT = 0 and t0.M_TRE_GROUP = t1.M_TRE_GROUP) 
left join MUB#MUB_TREE_DBF t2 on (t1.M_REF = t2.M_FATHER_R and t1.M_HEIGHT = 1 and t1.M_TRE_GROUP = t2.M_TRE_GROUP) 
left join MUB#MUB_TREE_DBF t3 on (t2.M_REF = t3.M_FATHER_R and t2.M_HEIGHT = 2 and t2.M_TRE_GROUP = t3.M_TRE_GROUP) 
left join TRN_PFLD_DBF pfl on rtrim(t3.M_LABEL) = rtrim(pfl.M_LABEL)
left join TABLE#DATA#PORTFOLI_DBF udf on rtrim(pfl.M_LABEL) = rtrim(udf.M_LABEL)
left join MUB#MUB_TREE_DBF o7 on rtrim(pfl.M_LABEL) = rtrim(o7.M_LABEL)
left join MUB#MUB_TREE_DBF o6 on (o7.M_FATHER_R = o6.M_REF and o6.M_HEIGHT = 6 and o7.M_TRE_GROUP = o6.M_TRE_GROUP)
left join MUB#MUB_TREE_DBF o5 on (o6.M_FATHER_R = o5.M_REF and o5.M_HEIGHT = 5 and o6.M_TRE_GROUP = o5.M_TRE_GROUP)
left join MUB#MUB_TREE_DBF o4 on (o5.M_FATHER_R = o4.M_REF and o4.M_HEIGHT = 4 and o5.M_TRE_GROUP = o4.M_TRE_GROUP)
left join MUB#MUB_TREE_DBF o3 on (o4.M_FATHER_R = o3.M_REF and o3.M_HEIGHT = 3 and o4.M_TRE_GROUP = o3.M_TRE_GROUP)
left join MUB#MUB_TREE_DBF o2 on (o3.M_FATHER_R = o2.M_REF and o2.M_HEIGHT = 2 and o3.M_TRE_GROUP = o2.M_TRE_GROUP)
left join MUB#MUB_TREE_DBF o1 on (o2.M_FATHER_R = o1.M_REF and o1.M_HEIGHT = 1 and o2.M_TRE_GROUP = o1.M_TRE_GROUP)
left join MUB#MUB_TPL_DBF  po on o1.M_TRE_GROUP=cast(po.M_REFERENCE as char(1))
where t0.M_HEIGHT=0 and t0.M_TRE_GROUP='4' -- and rtrim(o1.M_TRE_GROUP)='MUB'
order by p0.M_REFERENCE, MLC_1, MLC_2, MLC_3
