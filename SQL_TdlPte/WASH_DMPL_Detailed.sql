select
rtrim(sdn.M_TP_PFOLIO) PFL,
sdn.M_TRN_GRP GRP, sdn.M_TRN_TYPE TYP,
-- rec.M_CNT_TYPO TYPO,
rtrim(sdn.M_INSTRUMENT) INS,
to_char(sdn.M_TP_DTEEXP,'YYYYMMDD') EXP,
sdn.M_FX_SP0EXP SP0,
sdn.M_PL_GEPL2 PL_GE,
sdn.M_PL_PC_FIN2 PL_PC,
sdn.M_PL_FP_FIN2 PL_FP,
sdn.M_PL_MV_FIN2 PL_MV,
sdn.M_PL_FE_FIN2 PL_FE,
sdn.M_NB TRN,
to_char(sdn.M_TP_DTETRN,'YYYYMMDD') TRNDAT,
to_char(sdn.M_TP_DTESYS,'YYYYMMDD') SYSDAT

from SDN_PL_REP sdn

where sdn.M_MX_REF_JOB = 135322
-- and rtrim(sdn.M_TP_PFOLIO) = (:PFL)
-- and rtrim(sdn.M_INSTRUMENT) = (:INS)
-- and to_char(sdn.M_TP_DTEEXP,'YYYYMMDD') = (:EXP)
and sdn.M_PL_FE_FIN2 <> 0

order by PFL, INS, EXP, GRP

