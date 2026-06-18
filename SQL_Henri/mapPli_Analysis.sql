-- PLI to MAS
select
pli.M_PLIUID, pli.M_BDYUID, mas.MXPLIUID, 
pli.M_PLIBDYLAB, mas.MXINSLABEL, case when mas.MXINSLABEL != pli.M_PLIBDYLAB then 'Diff' else null end DIF_PLILAB,
pli.M_PLUTO, mas.PLUTO1, case when mas.PLUTO1 != pli.M_PLUTO then 'Diff' else null end DIF_PLUTO

from VIW_PLI_DBF pli
left join XTR_MASTER_DBF mas on pli.M_PLIUID = mas.MXPLIUID

where pli.M_COMASS in ('OIL')

-- MAS to PLI
select
pli.M_PLIUID, pli.M_BDYUID, mas.MXPLIUID, 
pli.M_PLIBDYLAB, mas.MXINSLABEL, case when mas.MXINSLABEL != pli.M_PLIBDYLAB then 'Diff' else null end DIF_PLILAB

from XTR_MASTER_DBF mas
left join VIW_PLI_DBF pli on mas.MXPLIUID = pli.M_PLIUID


-- Checks
select * 
from TRN_PLIN_DBF pli
where rtrim(pli.M_DSP_LABEL) in
(
'RF RIN D4 2025_OTC',
'RF RIN D4 2026_OTC',
'RF RIN D6 2025_OTC',
'RF RIN D6 2026_OTC'
) 
--where M_ID = '33125'

select *
from XTR_MASTER_DBF mas
where mas.MXINSLABEL in
(
'RF RIN D4 2025_OTC',
'RF RIN D4 2026_OTC',
'RF RIN D6 2025_OTC',
'RF RIN D6 2026_OTC'

)

select * 
from XTR_PLUTO_DBF plu
where plu.PRO_REF = 'DTDBRNTBAL'


select *
from XTR_EAI_DBF eai

