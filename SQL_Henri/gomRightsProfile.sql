select pfl.M_LABEL PROFILE, 
pfr.M_STATUS STATUS, 
case pfr.M_ACTION
when 0 then cla.M_DESC
else
(case pfr.M_ACTION
when  1 then 'Insert'
when  2 then 'Modify'
when 32 then 'Access' else null end) end EVENT
from STP_RGH_TPL_PFLR_DBF pfr
left join STP_RGH_TPL_PFL_DBF pfl on pfr.M_TPL = pfl.M_REFERENCE
left join CLASS_MAPPING_DBF cla on pfr.M_EVT_CID = cla.M_ID
order by PROFILE, STATUS, EVENT