select 
imp.M_EVT EVT, rtrim(evttyp.M_EVT_DLABEL) EVT_LAB, rtrim(evt.M_COMMENT) EVT_CMT,
-- imp.M_REFERENCE IMP, imp.M__INTID_,
rtrim(substr(imptyp.M_NAME,11,30)) IMP_LAB, 
rtrim(imp.M_SOURCE) IMP_PFL,
coalesce(src.M_MX_REF_JOB, tgt.M_MX_REF_JOB) JOB_ID,
coalesce(rtrim(srcjob.M_TAGDATA), rtrim(tgtjob.M_TAGDATA)) JOB_LAB,
imp.M_BO TRN, 
coalesce(src.M_CONTRACT, tgt.M_CONTRACT) CNT,
-- flw.M_REFERENCE FLW_REF,
coalesce(src.M_PL_PC_FIN2,tgt.M_PL_PC_FIN2) PL_PC_FIN,
coalesce(src.M_PL_FP_FIN2,tgt.M_PL_FP_FIN2) PL_FP_FIN,
coalesce(round(src.M_PL_FMV2,2),round(tgt.M_PL_FMV2,2)) PL_MV_FIN,
coalesce(src.M_PL_GEPL2,tgt.M_PL_GEPL2) PL_GEPL,
round(flw.M_AMOUNT,2) FLW_AMT,
rtrim(pfls.M_LABEL) FLW_REC,
coalesce(rtrim(ctp.M_DSP_LABEL),rtrim(pfld.M_LABEL)) FLW_PAY,
coalesce(rtrim(src.M_CNT_TYPO),rtrim(tgt.M_CNT_TYPO)) TYPO,
coalesce(rtrim(src.M_INSTRUMENT),rtrim(tgt.M_INSTRUMENT)) PLIN,
coalesce(rtrim(src.M_TP_DTEEXP),rtrim(tgt.M_TP_DTEEXP)) EXP,
coalesce(rtrim(src.M_TP_STRIKE),rtrim(tgt.M_TP_STRIKE)) STK,
coalesce(rtrim(src.M_TP_CP),rtrim(tgt.M_TP_CP)) CP,
coalesce(rtrim(src.M_TP_PRICE),rtrim(tgt.M_TP_PRICE)) PRC,
coalesce(src.M_TP_IQTYS, tgt.M_TP_IQTYS) QTY_INI_S
from MUREX_MX_OWNER.EVT_IMP_DBF imp
left join MUREX_MX_OWNER.EVT_EVENT_DBF evt on imp.M_EVT = evt.M_REFERENCE
left join MUREX_MX_OWNER.EVT_MAP_DBF evttyp on evt.M__INTID_ = evttyp.M_EVT_INTID
left join MUREX_MX_OWNER.CLASS_MAPPING_DBF imptyp on imp.M__INTID_ = imptyp.M_ID
left join MUREX_DM_OWNER.TRAF_PL_PFLASG_REP src on (imp.M_BO = src.M_NB and src.M_MX_REF_JOB = ?)
left join MUREX_DM_OWNER.TRAF_PL_PFLASG_REP tgt on (imp.M_BO = tgt.M_NB and tgt.M_MX_REF_JOB = ?)
left join MUREX_MX_OWNER.ACT_JOBDAP_DBF srcjob on src.M_MX_REF_JOB = srcjob.M_IDJOB
left join MUREX_MX_OWNER.ACT_JOBDAP_DBF tgtjob on tgt.M_MX_REF_JOB = tgtjob.M_IDJOB
left join MUREX_MX_OWNER.TRN_HDRF_DBF flw on imp.M_BO = flw.M_NB
left join MUREX_MX_OWNER.TRN_PFLD_DBF pfls on flw.M_SRC_PFOLIO = pfls.M_REF
left join MUREX_MX_OWNER.TRN_PFLD_DBF pfld on flw.M_DST_PFOLIO = pfld.M_REF 
left join MUREX_MX_OWNER.TRN_CPDF_DBF ctp on flw.M_CNTRP = ctp.M_ID 
where rtrim(evt.M_COMMENT) = ?