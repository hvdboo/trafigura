select 	
rtrim(ctp.M_DSP_LABEL) as NAME, rtrim(ctp.M_NAME) as DESCR, 
rtrim(ctp.M_LEI) as LEI, 
rtrim(ctp.M_SFT) as SWIFT,
rtrim(typ.M_LABEL) TYP
-- ctp.M_ID ID
from TRN_CPDF_DBF ctp
left join CTP_TYPES_DBF ctyp on ctp.M_ID = ctyp.M_CTN 
left join PARTY_TYPE_DBF typ on ctyp.M_REF = typ.M_REFERENCE
left join TABLE#DATA#COUNTERP_DBF udf on ctp.M_LABEL = udf.M_LABEL
left join LEI_DBF lei on ctp.M_ID = lei.M_REFERENCE
where typ.M_REFERENCE = 16
order by ctp.M_DSP_LABEL