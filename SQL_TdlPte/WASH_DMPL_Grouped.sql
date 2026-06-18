select
rtrim(sdn.M_TP_PFOLIO) PFL,
-- sdn.M_TRN_GRP GRP, sdn.M_TRN_TYPE TYP,
-- rec.M_CNT_TYPO TYPO,
rtrim(sdn.M_INSTRUMENT) INS,
sdn.M_TP_DTEEXP EXP,
sdn.M_FX_SP0EXP SP0,
sum(sdn.M_PL_GEPL2) PL_GE,
sum(sdn.M_PL_PC_FIN2) PL_PC,
sum(sdn.M_PL_FP_FIN2) PL_FP,
sum(sdn.M_PL_MV_FIN2) PL_MV,
sum(sdn.M_PL_FE_FIN2) PL_FE,
count(*) OCC
-- to_char(csh.M_TP_DTEEXP,'YYYY-MM-DD'), csh.M_NB

from SDN_PL_REP sdn

where sdn.M_MX_REF_JOB = 135322 
-- and to_char(rec.M_TP_DTEPMT,'YYYYMMDD') > ?
-- and to_char(rec.M_TP_DTEPMT,'YYYYMMDD') <=?

group by
sdn.M_TP_PFOLIO,
-- sdn.M_TRN_GRP,
-- sdn.M_TRN_TYPE,
-- rec.M_CNT_TYPO,
sdn.M_INSTRUMENT,
sdn.M_TP_DTEEXP,
sdn.M_FX_SP0EXP

order by PFL, INS, EXP

