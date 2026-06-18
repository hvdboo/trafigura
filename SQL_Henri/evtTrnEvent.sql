select 
trn.M_CONTRACT CNT,
trn.M_NB TRN,
trn.M_TRN_FMLY FML, trn.M_TRN_GRP GRP, trn.M_TRN_TYPE TYP,
rtrim(pli.M_DSP_LABEL) PLI,
trn.M_MOP_LAST MOPLSTNUM,
rtrim(mop.M_EVT_CODE) MOPLSTCOD, 
rtrim(mop.M_EVT_DLABEL) MOPLSTLAB,
trn.M_OPT_MOPNB MOPLSTREF,
trn.M_OPT_NATURE,

evt.M_REFERENCE EVT,
evtimp.M_EVT_INTID,
rtrim(clatrn.M_NAME) TRNCLA,
rtrim(claevt.M_NAME) EVTCLA, 
rtrim(evttyp.M_EVT_DLABEL) EVTTYP,
rtrim(clatyp.M_NAME) TYPCLA,
rtrim(evt.M_COMMENT) CMT,
gen.M_NB GENTRN, 
gen.M_TRN_FMLY GENFML, gen.M_TRN_GRP GENGRP, gen.M_TRN_TYPE GENTYP,
rtrim(genpli.M_DSP_LABEL) GENPLI

from TRN_HDR_DBF trn
left join TRN_PLIN_DBF pli on rtrim(trn.M_INSTRUMENT) = rtrim(pli.M_REFERENCE)
left join EVT_MAP_DBF mop on trn.M_MOP_LAST = mop.M_EVT_ID
left join EVT_IMP_DBF evtimp on trn.M_OPT_MOPNB = evtimp.M_REFERENCE
left join EVT_EVENT_DBF evt on evtimp.M_EVT = evt.M_REFERENCE
left join EVT_MAP_DBF evttyp on evtimp.M_TYPE = evttyp.M_EVT_ID

left join CLASS_MAPPING_DBF claevt on evtimp.M_EVT_INTID = claevt.M_ID
left join CLASS_MAPPING_DBF clatrn on evtimp.M_BO_INTID = clatrn.M_ID
left join CLASS_MAPPING_DBF clatyp on evttyp.M_EVT_INTID = clatyp.M_ID
left join TRN_HDR_DBF gen on trn.M_NB = gen.M_CREATOR
left join TRN_PLIN_DBF genpli on rtrim(gen.M_INSTRUMENT) = rtrim(genpli.M_REFERENCE)


where 1 = 1
and trn.M_NB in (22846765, 23113116, 23124464, 25988423)
-- and trn.M_CONTRACT = 7904853
-- and trn.M_INSTRUMENT = '8592'
-- and trn.M_TRN_STATUS = 'DEAD'
-- and nvl(to_char(trn.M_OPT_FLWLST,'YYYY-MM-DD'),'N') = 'N' 
