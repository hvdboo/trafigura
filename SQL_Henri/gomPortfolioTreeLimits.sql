select 
case
when t7.M_TRE_GROUP='MUB' then '<P&L CONTROL>' else p0.M_LABEL end as M_TREE, 
--tre.M_HEIGHT, tre.M_LABEL M_NODE,
case when t7.M_HEIGHT = 2 then rtrim(t7.M_LABEL) else rtrim(t3.M_FATHER_L) end M_NODE2,
case when t7.M_HEIGHT = 3 then rtrim(t7.M_LABEL) else rtrim(t4.M_FATHER_L) end M_NODE3,
case when t7.M_HEIGHT = 4 then rtrim(t7.M_LABEL) else rtrim(t5.M_FATHER_L) end M_NODE4,
case when t7.M_HEIGHT = 5 then rtrim(t7.M_LABEL) else rtrim(t6.M_FATHER_L) end M_NODE5,
case when t7.M_HEIGHT = 6 then rtrim(t7.M_LABEL) else rtrim(t7.M_FATHER_L) end M_NODE6,
case when t7.M_HEIGHT = 7 then rtrim(t7.M_LABEL) else null end M_NODE7,
rtrim(pfl.M_LABEL) as M_PFL_LAB,  
t7.M_D_DATA1 as M_LIM_MTM, t7.M_D_DATA3 as M_LIM_VAT, t7.M_D_DATA4 as M_LIM_STR,
t7.M_REF as M_REF
from MUB#MUB_TREE_DBF t7 
left join MUB#MUB_TREE_DBF t6 on (t7.M_FATHER_R = t6.M_REF and t7.M_HEIGHT = 7)
left join MUB#MUB_TREE_DBF t5 on (t6.M_FATHER_R = t5.M_REF and t6.M_HEIGHT = 6) 
left join MUB#MUB_TREE_DBF t4 on (t5.M_FATHER_R = t4.M_REF and t5.M_HEIGHT = 5)
left join MUB#MUB_TREE_DBF t3 on (t4.M_FATHER_R = t3.M_REF and t4.M_HEIGHT = 4)
left join MUB#MUB_TPL_DBF p0 on t7.M_TRE_GROUP = cast(p0.M_REFERENCE as char(1)) 
left join TRN_PFLD_DBF pfl on t7.M_D_DATA2 = pfl.M_REF
left join TABLE#DATA#PORTFOLI_DBF udf on rtrim(pfl.M_LABEL) = rtrim(udf.M_LABEL)
--where tre.M_HEIGHT=7
order by p0.M_REFERENCE, t7.M_NODE_ID