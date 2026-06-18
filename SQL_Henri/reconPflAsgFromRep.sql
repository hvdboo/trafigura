select 
tgt.M_MX_REF_JOB T_JOB, src.M_MX_REF_JOB S_JOB,
imptgt.M_EVT EVT,
tgt.M_NB T_TRN, src.M_NB S_TRN,
tgt.M_TP_IQTYS T_QTY, src.M_TP_IQTYS S_QTY, (tgt.M_TP_IQTYS-src.M_TP_IQTYS) D_QTY,
tgt.M_PL_GEPL2 T_PL_GEPL, src.M_PL_GEPL2 S_PL_GE, (tgt.M_PL_GEPL2-src.M_PL_GEPL2) D_PL_GEPL,

tgt.M_PL_PC_NFI2 T_PL_PC_NFI, src.M_PL_PC_NFI2 S_PL_PC_NFI, (tgt.M_PL_PC_NFI2 - src.M_PL_PC_NFI2) D_PL_PC_NFI,
tgt.M_PL_FP_NFI2 T_PL_FP_NFI, src.M_PL_FP_NFI2 S_PL_FP_NFI, (tgt.M_PL_FP_NFI2 - src.M_PL_FP_NFI2) D_PL_FP_NFI,
tgt.M_PL_NFMV2   T_PL_MV_NFI, src.M_PL_NFMV2   S_PL_MV_NFI, (tgt.M_PL_NFMV2   - src.M_PL_NFMV2)   D_PL_MV_NFI

from MUREX_DM_OWNER.TRAF_PL_PFLASG_REP tgt
-- left join MUREX_MX_OWNER.EVT_IMP_DBF imptgt on (tgt.M_EVTIMP_IMP = imptgt.M_REFERENCE)
left join MUREX_MX_OWNER.EVT_IMP_DBF imptgt on (tgt.M_NB = imptgt.M_BO and trim(imptgt.M__INTID_) = '1.494')
left join MUREX_MX_OWNER.EVT_IMP_DBF impsrc on (imptgt.M_EVT = impsrc.M_EVT and trim(impsrc.M__INTID_) = '1.370')
left join MUREX_DM_OWNER.TRAF_PL_PFLASG_REP src on (impsrc.M_BO = src.M_NB and src.M_MX_REF_JOB = 360)
where tgt.M_MX_REF_JOB = 362
and tgt.M_NB = 9628705