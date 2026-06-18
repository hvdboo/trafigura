select 
rtrim (agrcat.M_LABEL) LAB, 
rtrim(agrcat.M_DESC)   DES

from COLL_AGR_CAT_DBF agrcat

order by LAB
