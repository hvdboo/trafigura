select tre.M_LABEL TREE, tre.M_DESC DESCRIPTION,
case par.M_TYPE
when 1 then par.M_LABEL
when 2 then typp.M_LABEL else ' ' end PARENT,
case nod.M_TYPE
when 1 then nod.M_LABEL
when 2 then typn.M_LABEL else ' ' end NODE
from STP_RGH_NODE_DBF nod
left join STP_RGH_TREE_DBF tre on nod.M_TREE = tre.M_REFERENCE
left join STP_RGH_NODE_DBF par on nod.M_PARENT = par.M_REFERENCE
left join TYPOLOGY_DBF typp on par.M_TYPO_REF = typp.M_REFERENCE
left join TYPOLOGY_DBF typn on nod.M_TYPO_REF = typn.M_REFERENCE
where nod.M_PARENT <> 0
order by TREE, PARENT, NODE