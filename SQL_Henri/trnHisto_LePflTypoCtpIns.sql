select 
to_char(pc.M_DATE,'YYYY-MM-DD') REPDAT,
case when trn.M_BINTERNAL = trn.M_SINTERNAL then 'I' else 'E' end TRN_IE,
case when ctyp.M_REF = 16 then 'I' else 'E' end CTP_IE,
coalesce(rtrim(ble.M_DSP_LABEL),rtrim(sle.M_DSP_LABEL)) LE,
case when trn.M_COMMENT_BS = 'B' then rtrim(trn.M_BPFOLIO) else rtrim(trn.M_SPFOLIO) end PFL,
case when trn.M_BINTERNAL = trn.M_SINTERNAL 
then coalesce(rtrim(ble.M_DSP_LABEL),rtrim(sle.M_DSP_LABEL))
else rtrim(ctp.M_DSP_LABEL) end CTP,
rtrim(trn.M_TRN_FMLY) FML, rtrim(trn.M_TRN_GRP) GRP,  rtrim(trn.M_TRN_TYPE) TYP,
rtrim(typo.M_LABEL) TYPO,
rtrim(plin.M_DSP_LABEL) INS,
-- to_char(trn.M_TRN_EXP,'YYYY-MM-DD') EXP,
count(*) OCC

from TRN_HDR_DBF trn
left join TRN_PC_DBF pc on 1 = 1
left join TRN_CPDF_DBF ble on trn.M_BLENTITY = ble.M_ID
left join TRN_CPDF_DBF sle on trn.M_SLENTITY = sle.M_ID
left join TRN_CPDF_DBF ctp on trn.M_COUNTRPART = ctp.M_ID
left join CTP_TYPES_DBF ctyp on (ctp.M_ID = ctyp.M_CTN and ctyp.M_REF = 16)
left join CONTRACT_DBF cnt on trn.M_CONTRACT = cnt.M_REFERENCE
left join TYPOLOGY_DBF typo on cnt.M_TYPOLOGY = typo.M_REFERENCE
left join TRN_PLIN_DBF plin on trn.M_INSTRUMENT = plin.M_REFERENCE
left join CM_FUT_DBF cmfut on (rtrim(substr(plin.M_LABEL,9,10)) = to_char(cmfut.M_REFERENCE) and plin.M_FAMILY in (32,16384))

where 1 = 1
and trn.M_PURPOSE <> 'MeHzv70053'
and trn.M_TRN_GTYPE in (1, 2, 76, 77, 84)
and trn.M_MOP_LAST not in (6,7)
-- and to_char(trn.M_TRN_DATE,'YYYY-MM-DD') > '2017-06-24' 

group by
to_char(pc.M_DATE,'YYYY-MM-DD'),
case when trn.M_BINTERNAL = trn.M_SINTERNAL then 'I' else 'E' end,
case when ctyp.M_REF = 16 then 'I' else 'E' end,
coalesce(rtrim(ble.M_DSP_LABEL),rtrim(sle.M_DSP_LABEL)),
case when trn.M_COMMENT_BS = 'B' then rtrim(trn.M_BPFOLIO) else rtrim(trn.M_SPFOLIO) end,
case when trn.M_BINTERNAL = trn.M_SINTERNAL 
then coalesce(rtrim(ble.M_DSP_LABEL),rtrim(sle.M_DSP_LABEL))
else rtrim(ctp.M_DSP_LABEL) end,
rtrim(trn.M_TRN_FMLY), rtrim(trn.M_TRN_GRP),  rtrim(trn.M_TRN_TYPE),
rtrim(typo.M_LABEL),
rtrim(plin.M_DSP_LABEL)
--to_char(trn.M_TRN_EXP,'YYYY-MM-DD'),

order by FML, GRP, TYP, TYPO, INS, PFL
