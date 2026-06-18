select 
rtrim(M_BPFOLIO) PFLB, rtrim(M_SPFOLIO) PFLS,
trn.M_TRN_GRP GRP, trn.M_TRN_TYPE TYP,
rtrim(trn.M_INSTRUMENT) INS, rtrim(plin.M_DSP_LABEL) PLIN,
rtrim(trn.M_BRW_ODPL) MAT, to_char(trn.M_TRN_EXP,'YYYY-MM-DD') EXP,
trn.M_COMMENT_BS BS, trn.M_BRW_NOM1 NOM, 
case trn.M_COMMENT_BS
when 'B' then  1 * trn.M_BRW_NOM1
when 'S' then -1 * trn.M_BRW_NOM1
else 0 end NOMSGN,
trn.M_NB

from TRN_HDR_DBF trn
left join TRN_PFLD_DBF pfs on trn.M_SRC_PFOLIO = pfs.M_REF
left join TRN_PFLD_DBF pfd on trn.M_DST_PFOLIO = pfd.M_REF
left join TRN_CPDF_DBF les on pfs.M_PROC_AREA = les.M_ID
left join TRN_CPDF_DBF led on pfd.M_PROC_AREA = led.M_ID
left join TABLE#DATA#PORTFOLI_DBF uds on rtrim(pfs.M_LABEL) = rtrim(uds.M_LABEL)
left join TABLE#DATA#PORTFOLI_DBF udd on rtrim(pfd.M_LABEL) = rtrim(udd.M_LABEL)
left join TRN_PLIN_DBF plin on rtrim(trn.M_INSTRUMENT) = rtrim(plin.M_REFERENCE)

where 
rtrim(trn.M_PURPOSE) <> 'MeHzv70053'
and 
(
(rtrim(les.M_DSP_LABEL) in ('NTT', 'TNJ', 'TTS', 'TTY') and rtrim(uds.M_STRATEGY_C) not in ('OD','PR','SD')) or
(rtrim(led.M_DSP_LABEL) in ('NTT', 'TNJ', 'TTS', 'TTY') and rtrim(udd.M_STRATEGY_C) not in ('OD','PR','SD'))
)
and trn.M_TRN_FMLY = 'COM'
and trn.M_TRN_STATUS = 'DEAD'
and trn.M_PL_INSCUR = 'CNY'
and to_char(trn.M_TRN_EXP,'YYYYMMDD') >  ?
and to_char(trn.M_TRN_EXP,'YYYYMMDD') <= ?

order by GRP, TYP, EXP