select distinct
rtrim(pfl.M_LABEL) PFL_LAB, 
max(rtrim(pfl.M_DESC)) PFL_DES,
max(case when rtrim(tre.M_TRE_GROUP) = 'MUB' then 'x' else null end) PL_CONTROL,
max(case when rtrim(tre.M_TRE_GROUP) = '3'   then 'x' else null end) MLC

from TRN_PFLD_DBF pfl
left join MUB#MUB_TREE_DBF tre on rtrim(pfl.M_LABEL) = rtrim(tre.M_LABEL)
left join MUB#MUB_TPL_DBF  tpl on rtrim(tre.M_TRE_GROUP) = rtrim(tre.M_TRE_GROUP)

group by pfl.M_LABEL, tpl.M_LABEL
order by PFL_LAB