update TRN_PFLD_DBF
set M_COMMENT0 = '20250728_Void'
where rtrim(M_LABEL) not in

(
select distinct
case when trn.M_COMMENT_BS = 'B' then rtrim(trn.M_BPFOLIO) else rtrim(trn.M_SPFOLIO) end PFLLAB

from TRN_HDR_DBF trn
left join TRN_PC_DBF pc on 1 = 1
left join TRN_PFLD_DBF bpfl on rtrim(trn.M_BPFOLIO) = rtrim(bpfl.M_LABEL)
left join TRN_PFLD_DBF spfl on rtrim(trn.M_SPFOLIO) = rtrim(spfl.M_LABEL)
left join TRN_CPDF_DBF ble on trn.M_BLENTITY = ble.M_ID
left join TRN_CPDF_DBF sle on trn.M_SLENTITY = sle.M_ID
left join TRN_CPDF_DBF ctp on trn.M_COUNTRPART = ctp.M_ID
left join CTP_TYPES_DBF ctyp on (ctp.M_ID = ctyp.M_CTN and ctyp.M_REF = 16)
left join CONTRACT_DBF cnt on trn.M_CONTRACT = cnt.M_REFERENCE

where 
trn.M_PURPOSE <> 'MeHzv70053'
and trn.M_MOP_LAST not in (6,7)

group by
to_char(pc.M_DATE,'YYYY-MM-DD'),
case when trn.M_COMMENT_BS = 'B' then rtrim(ble.M_DSP_LABEL) else rtrim(sle.M_DSP_LABEL) end,
case when trn.M_COMMENT_BS = 'B' then rtrim(trn.M_BPFOLIO) else rtrim(trn.M_SPFOLIO) end,
case when trn.M_COMMENT_BS = 'B' then rtrim(bpfl.M_COMMENT0) else rtrim(spfl.M_COMMENT0) end,
case when trn.M_COMMENT_BS = 'B' then bpfl.M_REF else spfl.M_REF end
)


