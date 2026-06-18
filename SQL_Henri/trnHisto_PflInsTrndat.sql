select 
to_char(pc.M_DATE,'YYYY-MM-DD') REPDAT,
to_char(trn.M_TRN_DATE,'YYYY-MM') TRNMTH,
case when trn.M_BINTERNAL = trn.M_SINTERNAL then 'I' else 'E' end TRN_IE,
case when ctyp.M_REF = 16 then 'I' else 'E' end CTP_IE,
coalesce(rtrim(ble.M_DSP_LABEL),rtrim(sle.M_DSP_LABEL)) LE,
case when trn.M_COMMENT_BS = 'B' then rtrim(trn.M_BPFOLIO) else rtrim(trn.M_SPFOLIO) end PFL,
rtrim(typo.M_LABEL) TYPO,
rtrim(plin.M_DSP_LABEL) INS,
rtrim(trn.M_BRW_ODPL) MAT,
to_char(trn.M_TRN_EXP,'YYYY-MM-DD') EXP,
rtrim(trn.M_COMMENT_BS) DIR,
sum(trn.M_BRW_NOM1) NOM_TOT, 
sum(trn.M_BRW_NOM1*cmfut.M_QTY) QTY_TOT,
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

where 
trn.M_PURPOSE <> 'MeHzv70053'
and trn.M_MOP_LAST not in (6,7)
and to_char(trn.M_TRN_DATE,'YYYY-MM-DD') > '2017-06-24' 
and trn.M_TRN_GTYPE in (100, 101, 102, 103)
and trn.M_INSTRUMENT in
(
'1231',
'1234',
'1290',
'1291',
'1292',
'1301',
'1302',
'1303',
'4842',
'5157',
'5158',
'5159',
'5406',
'5761',
'5762',
'5764',
'5765',
'5766',
'5767',
'8592',
'8596',
'8598',
'8602',
'8606',
'8610',
'8612',
'8614',
'8618',
'8619',
'8624',
'8625',
'8633',
'8682',
'9017',
'9019',
'9021',
'9022',
'9023',
'9024',
'9025',
'9026',
'9421',
'14441',
'15059',
'20647',
'21085'
)

group by
to_char(pc.M_DATE,'YYYY-MM-DD'),
to_char(trn.M_TRN_DATE,'YYYY-MM'),
case when trn.M_BINTERNAL = trn.M_SINTERNAL then 'I' else 'E' end,
case when ctyp.M_REF = 16 then 'I' else 'E' end,
coalesce(rtrim(ble.M_DSP_LABEL),rtrim(sle.M_DSP_LABEL)),
case when trn.M_COMMENT_BS = 'B' then rtrim(trn.M_BPFOLIO) else rtrim(trn.M_SPFOLIO) end,
rtrim(typo.M_LABEL),
rtrim(plin.M_DSP_LABEL),
rtrim(trn.M_BRW_ODPL),
to_char(trn.M_TRN_EXP,'YYYY-MM-DD'),
rtrim(trn.M_COMMENT_BS)

order by TRNMTH, PFL, TYPO, INS, EXP
