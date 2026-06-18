select
evt.M_REFERENCE EVTREF,
rtrim(claevt.M_NAME) EVTCLA,
rtrim(clatyp.M_NAME) TYPCLA,
rtrim(evttyp.M_EVT_DLABEL) EVTTYP,
rtrim(evt.M_COMMENT) EVTCMT,
trnsrc.M_TRN_FMLY FML,
trnsrc.M_TRN_GRP GRP, 
trnsrc.M_TRN_TYPE TYP,
trnsrc.M_MOP_LAST,
trnsrc.M_OPT_NATURE,
trnsrc.M_CONTRACT SRC_CNT,
trnsrc.M_NB SRC_TRN,
trnsrc.M_BPFOLIO SRC_PFLB,
trnsrc.M_SPFOLIO SRC_PFLS,
trntgt.M_CONTRACT TGT_CNT,
trntgt.M_NB TGT_TRN,
trntgt.M_BPFOLIO TGT_PFLB,
trntgt.M_SPFOLIO TGT_PFLS

from EVT_IMP_DBF evtimp 
left join EVT_EVENT_DBF evt on evtimp.M_EVT = evt.M_REFERENCE
left join TRN_HDR_DBF trnsrc on evtimp.M_REFERENCE = trnsrc.M_OPT_MOPNB
left join TRN_PLIN_DBF plin on rtrim(trnsrc.M_INSTRUMENT) = rtrim(plin.M_REFERENCE)
left join EVT_MAP_DBF evttyp on evtimp.M_TYPE = evttyp.M_EVT_ID
left join CLASS_MAPPING_DBF claevt on evtimp.M_EVT_INTID = claevt.M_ID
left join CLASS_MAPPING_DBF clatrn on evtimp.M_BO_INTID = clatrn.M_ID
left join CLASS_MAPPING_DBF clatyp on evttyp.M_EVT_INTID = clatyp.M_ID
left join TRN_HDR_DBF trntgt on trnsrc.M_NB =  trntgt.M_CREATOR 

where 1 = 1
-- and evtimp.M_DATE >= (:DATFST)
-- and evtimp.M_DATE <= (:DATLST)
and trnsrc.M_CONTRACT in 
(
8004055
)
