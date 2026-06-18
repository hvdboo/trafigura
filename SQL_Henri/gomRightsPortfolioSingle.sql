select 
rtrim(rgt.M_PTF_LABEL) PFL,
rtrim(grp.M_LABEL) GRP,
case 
when rgt.M_PTF_RGT = 0 then 'Read/Write'
when rgt.M_PTF_RGT = 1 then 'Read Only'
when rgt.M_PTF_RGT = 2 then 'Deny'
else 'Write Only' end PFLRGT

from GRP_SPTF_DBF rgt
left join TRN_GRPD_DBF grp on rgt.M_GRP_REF = grp.M_REFERENCE
left join TRN_PFLD_DBF pfl on rgt.M_PTF_REF = pfl.M_REF

where 1=1
and grp.M_LABEL = 'FO_EMEA'
--and pfl.M_LABEL = 'RMAR NHA PTEI'
