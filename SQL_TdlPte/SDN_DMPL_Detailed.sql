select
sdn.M_MX_REF_JOB JOB,
rtrim(sdn.M_TP_PFOLIO) PFL,
sdn.M_TRN_GRP GRP, sdn.M_TRN_TYPE TYP,
-- rec.M_CNT_TYPO TYPO,
rtrim(sdn.M_INSTRUMENT) INS,
sdn.M_C_CUR_PL PL_CUR,
rtrim(sdn.M_PL_KEY1) PL_KEY,
rtrim(sdn.M_TP_CMCMAT) MAT,
to_char(sdn.M_TP_DTEEXP,'YYYYMMDD') EXP,
to_char(sdn.M_TP_DTEFLWL,'YYYYMMDD') FLWLST,
to_char(sdn.M_TP_DTEPMT,'YYYYMMDD') CG_STL,
sdn.M_FX_SP0EXP SP0EXP,
sdn.M_PL_GEPL2 PL_GE,
sdn.M_PL_NEPL2 PL_NE,
sdn.M_PL_PC_FIN2 PL_PC,
sdn.M_PL_FP_FIN2 PL_FP,
sdn.M_PL_MV_FIN2 PL_MV,
sdn.M_PL_FE_FIN2 PL_FE,
sdn.M_TP_FEE0 TP_FE0,
to_char(sdn.M_TP_FEEDAT0,'YYYYMMDD') TP_FEDAT0,
rtrim(sdn.M_TP_FEESRC0) TP_FESRC0,
sdn.M_TP_FEE1 TP_FE1,
to_char(sdn.M_TP_FEEDAT1,'YYYYMMDD') TP_FEDAT1,
rtrim(sdn.M_TP_FEESRC1) TP_FESRC1,
sdn.M_TP_FEE2 TP_FE2,
to_char(sdn.M_TP_FEEDAT2,'YYYYMMDD') TP_FEDAT2,
rtrim(sdn.M_TP_FEESRC2) TP_FESRC2,
greatest(
to_char(sdn.M_TP_DTETRN,'YYYYMMDD'),
coalesce(to_char(sdn.M_TP_FEEDAT0,'YYYYMMDD'),'0'), 
coalesce(to_char(sdn.M_TP_FEEDAT1,'YYYYMMDD'),'0')) FE_STL,
sdn.M_FX_SP0FEE SP0FEE,
sdn.M_PL_FE_FIN2 + (sdn.M_TP_FEE0 + sdn.M_TP_FEE1 + sdn.M_TP_FEE2) CHK_FE,
(sdn.M_TP_FEEDAT0 - sdn.M_TP_DTETRN) CHK_FEDAT,
sdn.M_NB TRN,
rtrim(sdn.M_TP_GID) GID,
to_char(sdn.M_TP_DTETRN,'YYYYMMDD') TRNDAT,
to_char(sdn.M_TP_DTESYS,'YYYYMMDD') SYSDAT

from SDN_PL_REP sdn
where sdn.M_MX_REF_JOB = (:JOB) 
and to_char(sdn.M_TP_DTEEXP,'YYYYMMDD') <= (:EXP)
-- and sdn.M_TRN_GRP = 'FUT'
-- and rtrim(sdn.M_TP_PFOLIO) <> rtrim(coalesce(sdn.M_TP_FEESRC0, sdn.M_TP_FEESRC1, sdn.M_TP_FEESRC2))
-- and rtrim(sdn.M_TP_PFOLIO) = (:PFL)
-- and rtrim(sdn.M_INSTRUMENT) = (:INS)
-- and to_char(sdn.M_TP_DTEEXP,'YYYYMMDD') = (:EXP)
-- and sdn.M_PL_FE_FIN2 <> 0
and substr(sdn.M_TP_GID,1,3) not in ('BLN')

order by PFL, INS, EXP, GRP

