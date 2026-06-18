select 
typ.M_REFERENCE TYPID,
rtrim(typ.M_LABEL) TYP, 
rtrim(ctp.M_DSP_LABEL) PARTY, 
rtrim(ctp.M_NAME) DES

from CTP_TYPES_DBF ctyp
left join TRN_CPDF_DBF ctp on ctyp.M_CTN = ctp.M_ID
left join PARTY_TYPE_DBF typ on ctyp.M_REF = typ.M_REFERENCE
where ctp.M_STATUS < 2
order by TYP, PARTY