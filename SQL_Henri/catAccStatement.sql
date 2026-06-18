select 
rtrim(tre.M_LABEL)  CAT,
rtrim (nod.M_LABEL) LAB, 
rtrim(nod.M_DESC)   DES

from HEDGE#STAT_TMPLL_DBF tremap
left join HEDGE#STAT_TMPL_DBF tre on tremap.M_CTN = tre.M_STAT_CAT
left join HEDGE#STAT_CAT_DBF  nod on tremap.M_REF = nod.M_REFERENCE

where rtrim(tre.M_LABEL) = 'TRAF'

order by CAT, LAB
