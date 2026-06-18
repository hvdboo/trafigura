select 
FML, GRP, TYP, INS, IND, UND,
FIXF, FIXL, EXP,
PFL, CTP, TRN_S, STAT,
PL_GE_D, 
PL_PCNF_D, PL_FPNF_D, PL_MVNF_D,
PL_FIN_D,  PL_PVE_D, 
PL_FENF_D,
(PL_GE_D - ROUND(PL_PVE_D,2)) EFF

from

(
select 
src.M_TRN_FMLY FML, src.M_TRN_GRP GRP, src.M_TRN_TYPE TYP,
rtrim(src.M_INSTRUMENT) INS,
rtrim(src.M_TP_CMILAB0) IND,
rtrim(src.M_TP_CMULAB0) UND,
to_char(src.M_TP_DTEFST,'YYYY-MM-DD') FIXF,to_char(src.M_TP_DTELST,'YYYY-MM-DD') FIXL,
to_char(src.M_TP_DTEEXP,'YYYY-MM-DD') EXP,
rtrim(src.M_TP_PFOLIO) PFL, rtrim(src.M_TP_CNTRP) CTP,
src.M_NB TRN_S, tgt.M_NB TRN_T,
src.M_TP_STATUS2 STAT,
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
)

where PL_GE_D <> 0
order by UND, IND, FML, GRP, TYP, FIXF, TRN_S