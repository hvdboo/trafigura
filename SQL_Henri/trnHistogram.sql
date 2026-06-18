select trn.M_TRN_FMLY FAMILY, trn.M_TRN_GRP GROUP_, trn.M_TRN_TYPE TYP, 
rtrim(plin.M_DSP_LABEL) INSTRUMENT, 
count(case when trn.M_TRN_STATUS = 'LIVE' then 1 else null end) LIVE, 
count(case when trn.M_TRN_STATUS = 'MKT_OP' then 1 else null end) MKT_OP,
count(case when trn.M_TRN_STATUS = 'DEAD' then 1 else null end) DEAD,
count(*) TRADES
from TRN_HDR_DBF trn
left join TRN_PLIN_DBF plin on trn.M_INSTRUMENT = plin.M_REFERENCE
--where trn.M_TRN_FMLY = 'COM' 
group by trn.M_TRN_FMLY, trn.M_TRN_GRP, trn.M_TRN_TYPE, plin.M_DSP_LABEL
order by trn.M_TRN_FMLY, trn.M_TRN_GRP, trn.M_TRN_TYPE, plin.M_DSP_LABEL