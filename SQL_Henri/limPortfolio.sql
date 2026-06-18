select distinct 
'<P&L CONTROL>' as M_TREE,
case when t.M_HEIGHT >= 1 then rtrim(t1.M_LABEL) else '.' end as M_NODE1,
case when t.M_HEIGHT >= 2 then rtrim(t2.M_LABEL) else '.' end as M_NODE2,
case when t.M_HEIGHT >= 3 then rtrim(t3.M_LABEL) else '.' end as M_NODE3,
case when t.M_HEIGHT >= 4 then rtrim(t4.M_LABEL) else '.' end as M_NODE4,
case when t.M_HEIGHT >= 5 then rtrim(t5.M_LABEL) else '.' end as M_NODE5,
case when t.M_HEIGHT >= 6 then rtrim(t6.M_LABEL) else '.' end as M_NODE6,
case when t.M_HEIGHT >= 7 then rtrim(t7.M_LABEL) else '.' end as M_NODE7,
case 
when pfl.M_LABEL like '%CL%'  then 'Client'
when pfl.M_LABEL like '%CP%'  then 'Counterpart'
when pfl.M_LABEL like '%SP%'  then 'House'
when pfl.M_LABEL like '%TST%' then 'Test' 
else null end as M_PFL_NAT, 
rtrim(pfl.M_LABEL) as M_PFL_LAB,
rtrim(t.M_LABEL) as M_NODE_LAB, t.M_REF as M_NODE_REF,
t.M_D_DATA1 as M_LIM_MTM, t.M_D_DATA3 as M_LIM_VAR, t.M_D_DATA4 as M_LIM_STR
from MUB#MUB_TREE_DBF t
left outer join MUB#MUB_TREE_DBF t1 on (t1.M_FATHER_R = 0        and t1.M_HEIGHT = 1 and t1.M_TRE_GROUP = 'MUB' and t1.M_TRE_NAME = 'MUB')
left outer join MUB#MUB_TREE_DBF t2 on (t2.M_FATHER_R = t1.M_REF and t2.M_HEIGHT = 2 and t2.M_TRE_GROUP = 'MUB' and t2.M_TRE_NAME = 'MUB')
left outer join MUB#MUB_TREE_DBF t3 on (t3.M_FATHER_R = t2.M_REF and t3.M_HEIGHT = 3 and t3.M_TRE_GROUP = 'MUB' and t3.M_TRE_NAME = 'MUB')
left outer join MUB#MUB_TREE_DBF t4 on (t4.M_FATHER_R = t3.M_REF and t4.M_HEIGHT = 4 and t4.M_TRE_GROUP = 'MUB' and t4.M_TRE_NAME = 'MUB')
left outer join MUB#MUB_TREE_DBF t5 on (t5.M_FATHER_R = t4.M_REF and t5.M_HEIGHT = 5 and t5.M_TRE_GROUP = 'MUB' and t5.M_TRE_NAME = 'MUB')
left outer join MUB#MUB_TREE_DBF t6 on (t6.M_FATHER_R = t5.M_REF and t6.M_HEIGHT = 6 and t6.M_TRE_GROUP = 'MUB' and t6.M_TRE_NAME = 'MUB')
left outer join MUB#MUB_TREE_DBF t7 on (t7.M_FATHER_R = t6.M_REF and t7.M_HEIGHT = 7 and t7.M_TRE_GROUP = 'MUB' and t7.M_TRE_NAME = 'MUB')
left join TRN_PFLD_DBF pfl on t.M_D_DATA2 = pfl.M_REF
left join TABLE#DATA#PORTFOLI_DBF udf on rtrim(pfl.M_LABEL) = rtrim(udf.M_LABEL)
where t.M_TRE_GROUP='MUB' and t.M_TRE_NAME='MUB' and
case
when t.M_HEIGHT = 1 then t1.M_REF
when t.M_HEIGHT = 2 then t2.M_REF
when t.M_HEIGHT = 3 then t3.M_REF
when t.M_HEIGHT = 4 then t4.M_REF
when t.M_HEIGHT = 5 then t5.M_REF
when t.M_HEIGHT = 6 then t6.M_REF
when t.M_HEIGHT = 7 then t7.M_REF
end = t.M_REF
order by 1,2,3,4,5,6,7