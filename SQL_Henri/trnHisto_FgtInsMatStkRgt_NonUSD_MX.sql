select 

to_char(pc.M_DATE,'YYYY-MM-DD') SYSDAT,
trn.M_TRN_FMLY FML, trn.M_TRN_GRP GRP, trn.M_TRN_TYPE TYP, 
-- trn.M_TRN_GTYPE FGTN,
rtrim(plin.M_DSP_LABEL) INSTRUMENT, 
trn.M_PL_INSCUR PL_CUR,
case when trn.M_TRN_FMLY = 'CURR' then trn.M_BRW_NOMU1 else null end UND_CUR,
rtrim(trn.M_BRW_ODPL) MAT,
to_char(trn.M_TRN_EXP,'YYYY-MM-DD') EXP,
trn.M_BRW_STRK STK,
rtrim(trn.M_BRW_CP) CP,
-- case when trn.M_COMMENT_BS = 'B' then rtrim(trn.M_BPFOLIO) else rtrim(trn.M_SPFOLIO) end PFL,
/*
case when trn.M_BINTERNAL = trn.M_SINTERNAL then 'I' else 'E' end TRN_IE,
coalesce(rtrim(ble.M_DSP_LABEL),rtrim(sle.M_DSP_LABEL)) ENT,
case when ctyp.M_REF = 16 then 'I' else 'E' end CTP_IE,
case when trn.M_BINTERNAL = trn.M_SINTERNAL 
then coalesce(rtrim(ble.M_DSP_LABEL),rtrim(sle.M_DSP_LABEL))
else rtrim(ctp.M_DSP_LABEL) end CTP,
*/
count(case when trn.M_TRN_STATUS in ('LIVE','MKT_OP') then 1 else null end) LIVE, 
-- count(case when trn.M_TRN_STATUS = 'MKT_OP' then 1 else null end) MKT_OP,
count(case when trn.M_TRN_STATUS = 'DEAD' then 1 else null end) DEAD,
count(*) OCC

from TRN_HDR_DBF trn
left join TRN_PC_DBF pc on 1 = 1
left join TRN_CPDF_DBF ble on trn.M_BLENTITY = ble.M_ID
left join TRN_CPDF_DBF sle on trn.M_SLENTITY = sle.M_ID
left join TRN_CPDF_DBF ctp on trn.M_COUNTRPART = ctp.M_ID
left join CTP_TYPES_DBF ctyp on (ctp.M_ID = ctyp.M_CTN and ctyp.M_REF = 16)
left join TRN_PLIN_DBF plin on trn.M_INSTRUMENT = plin.M_REFERENCE
left join RT_INSGN_DBF gen on (rtrim(plin.M_LABEL) = to_char(gen.M_GEN_NUM) and plin.M_FAMILY in (2,512))
left join RT_INDEX_DBF ind on (plin.M_LABEL = ind.M_INDEX and plin.M_FAMILY = 256)
left join CM_FUT_DBF cmfut on (rtrim(substr(plin.M_LABEL,9,10)) = to_char(cmfut.M_REFERENCE) and plin.M_FAMILY in (32,16384))

where 
(rtrim(trn.M_TRN_FMLY) = 'COM' and trn.M_PL_INSCUR <> 'USD') 
-- or (rtrim(trn.M_TRN_FMLY) = 'CURR' and trn.M_BRW_NOMU1 <> 'USD')
and trn.M_TRN_EXP <= pc.M_DATE

group by 
pc.M_DATE,
trn.M_TRN_FMLY, trn.M_TRN_GRP, trn.M_TRN_TYPE, 
rtrim(plin.M_DSP_LABEL), 
trn.M_PL_INSCUR, 
case when trn.M_TRN_FMLY = 'CURR' then trn.M_BRW_NOMU1 else null end,
rtrim(trn.M_BRW_ODPL),
to_char(trn.M_TRN_EXP,'YYYY-MM-DD'),
trn.M_BRW_STRK,
rtrim(trn.M_BRW_CP)
-- case when trn.M_COMMENT_BS = 'B' then rtrim(trn.M_BPFOLIO) else rtrim(trn.M_SPFOLIO) end
/*
(case when trn.M_BINTERNAL=trn.M_SINTERNAL then 'I' else 'E' end), 
coalesce(rtrim(ble.M_DSP_LABEL),rtrim(sle.M_DSP_LABEL)),
ctyp.M_REF,
(case when trn.M_BINTERNAL = trn.M_SINTERNAL then coalesce(rtrim(ble.M_DSP_LABEL),rtrim(sle.M_DSP_LABEL)) else rtrim(ctp.M_DSP_LABEL) end),
*/

order by FML, GRP, TYP, INSTRUMENT, EXP, MAT, STK, CP