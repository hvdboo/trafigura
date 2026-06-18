select 
rtrim(usg.M_LABEL) LAB, 
rtrim(usg.M_DESC)  DES,
usg.M_REFERENCE    REF

from USAGE_DBF usg
order by LAB

