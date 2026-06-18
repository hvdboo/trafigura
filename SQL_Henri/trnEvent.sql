select
max(case coalesce(mape.STR, null) when mape.STR then str.LAB else null end) STRUCTURE,
max(case coalesce(mape.STR, null) when mape.STR then rtrim(plin.M_DSP_LABEL) else null end) INSTRUMENT,
null X,
max(case mape.EVT when  1 then 'x' else null end) Insert_,
max(case mape.EVT when  2 then 'x' else null end) Amend,
max(case mape.EVT when  3 then 'x' else null end) Cancel_,
max(case mape.EVT when  4 then 'x' else null end) CancelReinsert,
max(case mape.EVT when  5 then 'x' else null end) CancelReissue,
max(case mape.EVT when  6 then 'x' else null end) Unwind,
max(case mape.EVT when  7 then 'x' else null end) Refresh,
max(case mape.EVT when  8 then 'x' else null end) Restructure,
max(case mape.EVT when  9 then 'x' else null end) Fixing,
max(case mape.EVT when 10 then 'x' else null end) FixingTAS,
max(case mape.EVT when 11 then 'x' else null end) Exercise,
max(case mape.EVT when 12 then 'x' else null end) Expiry,
max(case mape.EVT when 13 then 'x' else null end) Netting,
max(case mape.EVT when 14 then 'x' else null end) FlowAmend,
max(case mape.EVT when 15 then 'x' else null end) AddFlowAmend,
max(case mape.EVT when 16 then 'x' else null end) CtpAmend,
max(case mape.EVT when 17 then 'x' else null end) CtpAssign,
max(case mape.EVT when 18 then 'x' else null end) PflAssign
from EDFM_MAPSTREVT mape
left join EDFM_STR str on mape.STR  = str.ID
left join EDFM_EVT evt on mape.EVT = evt.ID
left join TRN_PLIN_DBF plin on str.INS = plin.M_ID
group by mape.STR
order by mape.STR
