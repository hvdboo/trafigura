select
rtrim(ctp.M_ID) CTP_ID,
rtrim(ctp.M_DSP_LABEL) CTP_LAB,
rtrim(ctp.M_NAME) CTP_NAME,
-- rtrim(typ.M_LABEL) CTP_TYP,
rtrim(ctp.M_ENTITY) ENTITY,
rtrim(cou.M_DESC) COUNTRY,
rtrim(ctp.M_LEI) LEI,
rtrim(jur.M_DESC) JURISDIC,
rtrim(sup.M_LABEL) SUPERVISOR,
rtrim(reg.M_LABEL) REGIME,
rtrim(rol.M_LABEL) ROL
-- UDF.M_INTRAGRP INTRAGRP,
 
from TRN_CPDF_DBF ctp 
left join CR_CTRY_DBF cou on ctp.M_COUNTRY = cou.M_REFERENCE
left join CTP_JUR_DBF lnkjur on ctp.M_ID = lnkjur.M_CTP_REF
left join JURISDICTION_DBF jur on lnkjur.M_JUR_REF = jur.M_REFERENCE
left join JUR_ROLE_DBF rol on jur.M_ROLE = rol.M_REFERENCE
left join JUR_REGIME_DBF reg on jur.M_REGIME = reg.M_REFERENCE
left join JUR_SUP_BODY_DBF sup on jur.M_SUP_BODY = sup.M_REFERENCE
left join TABLE#DATA#COUNTERP_DBF udf on (ctp.M_LABEL = udf.M_LABEL)
-- left join CTP_TYPES_DBF lnktyp on ctp.M_ID = lnktyp.M_CTN
-- left join PARTY_TYPE_DBF typ on lnktyp.M_REF = typ.M_REFERENCE