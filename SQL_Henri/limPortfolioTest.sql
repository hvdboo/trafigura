select 
case
when t7.M_TRE_GROUP='MUB' then '<P&L CONTROL>' else tpl.M_LABEL end as M_TREE,
case t7.M_HEIGHT 
when 3 then rtrim(t7.M_LABEL) 
when 4 then rtrim(t43.M_LABEL)
when 5 then rtrim(t543.M_LABEL)
when 6 then rtrim(t6543.M_LABEL)
when 7 then rtrim(t76543.M_LABEL) else '.' end as M_NODE3,
case t7.M_HEIGHT 
when 4 then rtrim(t7.M_LABEL)
when 5 then rtrim(t54.M_LABEL)
when 6 then rtrim(t654.M_LABEL)
when 7 then rtrim(t7654.M_LABEL) else '.' end as M_NODE4,
case t7.M_HEIGHT 
when 5 then rtrim(t7.M_LABEL)
when 6 then rtrim(t65.M_LABEL)
when 7 then rtrim(t765.M_LABEL) else '.' end as M_NODE5,
case t7.M_HEIGHT 
when 6 then rtrim(t7.M_LABEL)
when 7 then rtrim(t76.M_LABEL) else '.' end as M_NODE6,
case t7.M_HEIGHT 
when 7 then rtrim(t7.M_LABEL) else '.' end as M_NODE7,
case 
when pfl.M_LABEL like '%CL%'  then 'Client'
when pfl.M_LABEL like '%CP%'  then 'Counterpart'
when pfl.M_LABEL like '%SP%'  then 'House'
when pfl.M_LABEL like '%TST%' then 'Test' 
else null end as M_PFL_NAT, 
rtrim(pfl.M_LABEL) as M_PFL_LAB, 
rtrim(t7.M_LABEL) as M_NOD_LAB, t7.M_REF as M_NOD_REF,
t7.M_D_DATA1 as M_LIM_MTM, t7.M_D_DATA3 as M_LIM_VAR, t7.M_D_DATA4 as M_LIM_STR
from MUB#MUB_TREE_DBF t7 
left join MUB#MUB_TPL_DBF tpl on t7.M_TRE_GROUP = cast(tpl.M_REFERENCE as char(1))
left join MUB#MUB_TREE_DBF t76    on (t7.M_FATHER_R    = t76.M_REF    and t7.M_HEIGHT    = 7)
left join MUB#MUB_TREE_DBF t765   on (t76.M_FATHER_R   = t765.M_REF   and t76.M_HEIGHT   = 6) 
left join MUB#MUB_TREE_DBF t7654  on (t765.M_FATHER_R  = t7654.M_REF  and t765.M_HEIGHT  = 5)
left join MUB#MUB_TREE_DBF t76543 on (t7654.M_FATHER_R = t76543.M_REF and t7654.M_HEIGHT = 4)
left join MUB#MUB_TREE_DBF t65    on (t7.M_FATHER_R    = t65.M_REF    and t7.M_HEIGHT    = 6) 
left join MUB#MUB_TREE_DBF t654   on (t65.M_FATHER_R   = t654.M_REF   and t65.M_HEIGHT   = 5)
left join MUB#MUB_TREE_DBF t6543  on (t654.M_FATHER_R  = t6543.M_REF  and t654.M_HEIGHT  = 4)
left join MUB#MUB_TREE_DBF t54    on (t7.M_FATHER_R    = t54.M_REF    and t7.M_HEIGHT    = 5)
left join MUB#MUB_TREE_DBF t543   on (t54.M_FATHER_R   = t543.M_REF   and t54.M_HEIGHT   = 4)
left join MUB#MUB_TREE_DBF t43    on (t7.M_FATHER_R    = t43.M_REF    and t7.M_HEIGHT    = 4)
left join TRN_PFLD_DBF pfl on t7.M_D_DATA2 = pfl.M_REF
left join TABLE#DATA#PORTFOLI_DBF udf on rtrim(pfl.M_LABEL) = rtrim(udf.M_LABEL)
where t7.M_HEIGHT > 2
order by M_TREE, M_NODE3, M_NODE4, M_NODE5, M_NODE6, M_NODE7 asc