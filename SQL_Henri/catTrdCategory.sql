select 
rtrim(M_FAMILY) FML,
rtrim(M_GROUP)  GRP,
rtrim(M_TYPE)   TYP,
rtrim(M_LABEL)  LAB,
rtrim(M_DESC)   DES

from TRN_TYPO_DBF
order by FML, GRP, TYP, LAB

