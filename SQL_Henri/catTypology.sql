select 
rtrim(cat.M_LABEL) CAT,
case 
when typo.M_TYPOTYPE=0 then '  '
when typo.M_TYPOTYPE=1 then 'Component'
when typo.M_TYPOTYPE=2 then 'Contract'
when typo.M_TYPOTYPE=3 then 'Package' 
when typo.M_TYPOTYPE=4 then 'Event' else ' 'end TYP, 
rtrim (typo.M_LABEL) LAB, 
rtrim(typo.M_DESC) DES, 
case typo.M_STATUS
when 0 then 'Active'
when 1 then 'Inactive' 
when 2 then 'Suspended' end STA,
typo.M_REFERENCE REF

from TYPOLOGY_DBF typo
left join CATEGORY_DBF cat on typo.M_CATEGORY = cat.M_REFERENCE

where typo.M_STATUS = 0 
--and typo.M_CATEGORY in (1001, 1002, 1006, 1009, 1020) 
order by cat.M_LABEL, typo.M_TYPOTYPE, typo.M_LABEL
