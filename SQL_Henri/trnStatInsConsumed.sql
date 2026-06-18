select 
trn.M_INSTRUMENT INS, 
rtrim(plin.M_FMLY_LBL) PLINFML,
rtrim(plin.M_LABEL) PLINLAB, rtrim(plin.M_DSP_LABEL) PLINDES,
count(*)

from MUREX_MX_OWNER.TRN_HDR_DBF trn
left join MUREX_MX_OWNER.TRN_PLIN_DBF plin on trn.M_INSTRUMENT = plin.M_REFERENCE
group by 
trn.M_INSTRUMENT, 
rtrim(plin.M_FMLY_LBL),
rtrim(plin.M_LABEL), rtrim(plin.M_DSP_LABEL)

order by PLINFML, PLINDES