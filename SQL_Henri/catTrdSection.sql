select 
rtrim (sec.M_LABEL) LAB, 
rtrim(sec.M_DESC) DES

from TRD_SEC_DBF sec

order by sec.M_LABEL
