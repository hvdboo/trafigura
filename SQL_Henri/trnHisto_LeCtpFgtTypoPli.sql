select 
--trn.M_NB TRN,
case when trn.M_BINTERNAL = trn.M_SINTERNAL then 'I' else 'E' end TRN_IE,
case 
when trn.M_BINTERNAL = trn.M_SINTERNAL then 'I'
when trn.M_BINTERNAL <> trn.M_SINTERNAL then case when ctyp.M_REF = 16 then 'I' else 'E' end 
end CTP_IE,
coalesce(rtrim(ble.M_DSP_LABEL),rtrim(sle.M_DSP_LABEL)) LE,
case when trn.M_COMMENT_BS ='B' then rtrim(trn.M_BPFOLIO) else rtrim(trn.M_SPFOLIO) end PFL,
case when trn.M_BINTERNAL = trn.M_SINTERNAL 
then coalesce(rtrim(ble.M_DSP_LABEL),rtrim(sle.M_DSP_LABEL))
else rtrim(ctp.M_DSP_LABEL) end CTP,
trn.M_TRN_GTYPE FGT, 
trn.M_TRN_FMLY  FML, 
trn.M_TRN_GRP   GRP, 
trn.M_TRN_TYPE  TYP,
rtrim(typo.M_LABEL) TYPO,
rtrim(plin.M_DSP_LABEL) PLIN

from TRN_HDR_DBF trn
left join TRN_PC_DBF pc on 1 = 1
left join TRN_PLIN_DBF plin on trn.M_INSTRUMENT = plin.M_REFERENCE
left join CONTRACT_DBF cnt on trn.M_CONTRACT = cnt.M_REFERENCE
left join TYPOLOGY_DBF typo on cnt.M_TYPOLOGY = typo.M_REFERENCE
left join TRN_CPDF_DBF ble on trn.M_BLENTITY = ble.M_ID
left join TRN_CPDF_DBF sle on trn.M_SLENTITY = sle.M_ID
left join TRN_CPDF_DBF ctp on trn.M_COUNTRPART = ctp.M_ID
left join CTP_TYPES_DBF ctyp on (ctp.M_ID = ctyp.M_CTN and ctyp.M_REF = 16)

where rtrim(trn.M_BSECTION) = '1112' or rtrim(trn.M_SSECTION) = '1112'

group by 
(case when trn.M_BINTERNAL=trn.M_SINTERNAL then 'I' else 'E' end),
(case 
when trn.M_BINTERNAL = trn.M_SINTERNAL then 'I'
when trn.M_BINTERNAL <> trn.M_SINTERNAL then case when ctyp.M_REF = 16 then 'I' else 'E' end end),
coalesce(rtrim(ble.M_DSP_LABEL),rtrim(sle.M_DSP_LABEL)),
(case when trn.M_COMMENT_BS ='B' then rtrim(trn.M_BPFOLIO) else rtrim(trn.M_SPFOLIO) end),
(case when trn.M_BINTERNAL = trn.M_SINTERNAL then coalesce(rtrim(ble.M_DSP_LABEL),rtrim(sle.M_DSP_LABEL)) else rtrim(ctp.M_DSP_LABEL) end),
trn.M_TRN_GTYPE,
trn.M_TRN_FMLY, 
trn.M_TRN_GRP, 
trn.M_TRN_TYPE,
rtrim(typo.M_LABEL),
plin.M_DSP_LABEL