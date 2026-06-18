select
rtrim(sdn.M_TP_PFOLIO) PFL,
-- sdn.M_TRN_GRP GRP, sdn.M_TRN_TYPE TYP,
-- rec.M_CNT_TYPO TYPO,
rtrim(sdn.M_INSTRUMENT) INS,
-- sdn.M_TP_DTEEXP EXP,
greatest(
to_char(sdn.M_TP_DTETRN,'YYYYMMDD'),
coalesce(to_char(sdn.M_TP_FEEDAT0,'YYYYMMDD'),'0'), 
coalesce(to_char(sdn.M_TP_FEEDAT1,'YYYYMMDD'),'0')) STL,
-- case M_CNT_TYPO when 'SCF SDN' then substr(sdn.M_TP_GID,8,2) else '' end GID,
-- sdn.M_FX_SP0FEE SP0,
sum(sdn.M_PL_GEPL2) PL_GE,
-- sum(sdn.M_PL_NEPL2) PL_NE,
-- sum(sdn.M_PL_GEPL2 - sdn.M_PL_NEPL2) DIF_GN,
-- sum(sdn.M_PL_PC_FIN2) PL_PC,
-- sum(sdn.M_PL_FP_FIN2) PL_FP,
-- sum(sdn.M_PL_MV_FIN2) PL_MV,
sum(sdn.M_PL_FE_FIN2) PL_FE,
sum(case when substr(sdn.M_TP_GID,8,2) = 'FE' then sdn.M_PL_GEPL2 else sdn.M_PL_FE_FIN2 end) FEE, 
count(*) OCC

from SDN_PL_REP sdn

where sdn.M_MX_REF_JOB in (:JOB1) 
-- and to_char(rec.M_TP_DTEPMT,'YYYYMMDD') > ?
-- and to_char(rec.M_TP_DTEPMT,'YYYYMMDD') <=?

group by
sdn.M_TP_PFOLIO,
-- sdn.M_TRN_GRP,
-- sdn.M_TRN_TYPE,
-- rec.M_CNT_TYPO,
sdn.M_INSTRUMENT,
-- sdn.M_TP_DTEEXP,
greatest(
to_char(sdn.M_TP_DTETRN,'YYYYMMDD'),
coalesce(to_char(sdn.M_TP_FEEDAT0,'YYYYMMDD'),'0'), 
coalesce(to_char(sdn.M_TP_FEEDAT1,'YYYYMMDD'),'0'))
-- case M_CNT_TYPO when 'SCF SDN' then substr(sdn.M_TP_GID,8,2) else '' end,
-- case when substr(sdn.M_TP_GID,8,2) = 'FE' then sdn.M_PL_GEPL2 else sdn.M_PL_FE_FIN2 end,
-- sdn.M_FX_SP0FEE

order by PFL, INS, STL
