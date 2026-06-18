select 
src.M_NB TRN_S, tgt.M_NB TRN_T,
(tgt.M_PL_GEPL2 - src.M_PL_GEPL2) PL_GE_D,
(tgt.M_PL_PC_NFI2 - src.M_PL_PC_NFI2) PL_PCNF_D,
(tgt.M_PL_FP_NFI2 - src.M_PL_FP_NFI2) PL_FPNF_D,
(tgt.M_PL_MV_NFI2 - src.M_PL_MV_NFI2) PL_MVNF_D,
(tgt.M_PL_CSFI2 - src.M_PL_CSFI2) PL_FIN_D,
(tgt.M_PL_FTFI2 - src.M_PL_FTFI2) PL_PVE_D,
(tgt.M_PL_FE_NFI2 - src.M_PL_FE_NFI2) PL_FENF_D
from REC_PL_REP src 
left join REC_PL_REP tgt on (src.M_NB = tgt.M_NB and src.M_TP_PFOLIO = tgt.M_TP_PFOLIO and tgt.M_MX_REF_JOB = (:JOB_TGT))
where src.M_MX_REF_JOB = (:JOB_SRC)
