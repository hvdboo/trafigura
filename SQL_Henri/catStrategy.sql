select 
rtrim(M_LABEL) LAB, 
rtrim(M_DESC) DES,
rtrim(M_COMMENT0) CMT

from TRN_STGD_DBF
order by LAB

