select 
dtm.M_NB TRN,
rtrim(dtm.M_TP_PFOLIO) SPFL,
rtrim(dtm.M_TP_GID) GID,
rtrim(dtm.M_TRN_FMLY) FML, rtrim(dtm.M_TRN_GRP) GRP, rtrim(dtm.M_TRN_TYPE) TYP,
rtrim(dtm.M_INSTRUMENT) INS,
dtm.M_C_CUR_PL PL_CUR,
rtrim(dtm.M_TP_CMCMAT) MAT,
to_char(dtm.M_TP_DTEEXP,'YYYY-MM-DD') EXP,
dtm.M_TP_STATUS2,
dtm.M_PL_GEPL2 GEPL,
dtm.M_PL_CSNF2,
dtm.M_PL_FE2,
dtm.M_PL_NEPL2 NEPL,
dtm.M_TP_DTETRN DATTRN,
dtm.M_TP_DTESYS DATSYS

from MUREX_DM_OWNER.TDLPTE_PNL_REP dtm

where
dtm.M_MX_REF_JOB = (:JOB) 
-- and rtrim(dtm.M_TP_PFOLIO) = (:PFL) 
-- and rtrim(dtm.M_INSTRUMENT) = (:INS)
-- and to_char(dtm.M_TP_DTEEXP,'YYYY-MM-DD') = to_char(:EXP,'YYYY-MM-DD')
and substr(dtm.M_TP_GID,1,3) not in ('BLN', 'PRW')
