select 
ind.M_INDUID INDUID,
ind.M_INDTYP INDTYP,
ind.M_ASSLAB ASSLAB,
ind.M_INDLAB INDLAB,
eai.EAIQOT   EAIQOT,
rtrim(eai.NAME) EAIDES

from VIW_ICMALL_DBF ind
left join XTR_EAI_DBF eai on ind.M_EAI = eai.EAIQOT
left join CM_INDEX_DBF icm on ind.M_ICMUID = icm.M_REFERENCE

where 1 = 1
--and rtrim(eai.NAME) is null
and ind.M_INDTYP = 'Spot'
and icm.M_COMMENT4 <> 'OOS'

order by INDLAB


