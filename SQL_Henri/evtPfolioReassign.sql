select 
tgt.M_NB TGT_TRN, tgt.M_CONTRACT TGT_CNT,
rtrim(tgt.M_TRN_STATUS) TGT_STAT,
(rtrim(tgt.M_TRN_FMLY)||'|'||rtrim(tgt.M_TRN_GRP)||'|'||rtrim(tgt.M_TRN_TYPE)) FGT,
rtrim(plin.M_DSP_LABEL) PLIN,
rtrim(ctp.M_DSP_LABEL) CTP,
case when tgt.M_COMMENT_BS = 'B' then rtrim(tbe.M_DSP_LABEL) else rtrim(tse.M_DSP_LABEL) end TGT_LE,
case when tgt.M_COMMENT_BS = 'B' then rtrim(tgt.M_BPFOLIO) else rtrim(tgt.M_SPFOLIO) end TGT_PFL,
'#',
case when src.M_COMMENT_BS = 'B' then rtrim(src.M_BPFOLIO) else rtrim(src.M_SPFOLIO) end SRC_PFL,
case when src.M_COMMENT_BS = 'B' then rtrim(sbe.M_DSP_LABEL) else rtrim(sse.M_DSP_LABEL) end SRC_LE,
src.M_TRN_STATUS SRC_STAT,
src.M_CONTRACT SRC_CNT,
src.M_NB SRC_TRN, 
'#',
rtrim(cla.M_NAME) EVT_CLA, rtrim(srcmod.M_DESC) EVT_SRCMOD, to_char(evt.M_DATE,'YYYY-MM-DD') EVT_DAT
from TRN_HDR_DBF tgt
left join TRN_PLIN_DBF plin on tgt.M_INSTRUMENT = plin.M_REFERENCE
left join TRN_CPDF_DBF tbe on tgt.M_BLENTITY = tbe.M_ID
left join TRN_CPDF_DBF tse on tgt.M_SLENTITY = tse.M_ID
left join TRN_HDR_DBF src on tgt.M_CREATOR = src.M_NB
left join TRN_CPDF_DBF sbe on src.M_BLENTITY = sbe.M_ID
left join TRN_CPDF_DBF sse on src.M_SLENTITY = sse.M_ID
left join TRN_EXT_DBF tex on tgt.M_NB = tex.M_TRADE_REF
left join EVT_EVENT_DBF evt on tex.M_EVT_REF = evt.M_REFERENCE
left join CLASS_MAPPING_DBF cla on evt.M__INTID_ = cla.M_ID
left join SRC_MOD_DBF srcmod on evt.M_SRC_MODULE = srcmod.M_REFERENCE
left join TRN_CPDF_DBF ctp on tgt.M_COUNTRPART = ctp.M_ID
where 
rtrim(ctp.M_DSP_LABEL) in (&CTP)
-- and tgt.M_BPFOLIO = 'MCEX APE PTEI' or tgt.M_SPFOLIO = 'MCEX APE PTEI'
and rtrim(srcmod.M_DESC) = 'MX - BULK PTF RES'
and rtrim(tgt.M_TRN_STATUS) = 'MKT_OP'
and to_char(evt.M_DATE,'YYYY-MM-DD') = '2017-05-05'