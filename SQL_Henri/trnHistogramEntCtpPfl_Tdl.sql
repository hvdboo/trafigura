select 
to_char(pc.M_DATE,'YYYY-MM-DD') SYSDAT,
case when trn.M_BINTERNAL = trn.M_SINTERNAL then 'I' else 'E' end TRN_IE,
coalesce(rtrim(ble.M_DSP_LABEL),rtrim(sle.M_DSP_LABEL)) ENT,
case when trn.M_COMMENT_BS = 'B' then rtrim(trn.M_BPFOLIO) else rtrim(trn.M_SPFOLIO) end PFL, 
case when ctyp.M_REF = 16 then 'I' else 'E' end CTP_IE,
case when trn.M_BINTERNAL = trn.M_SINTERNAL 
then coalesce(rtrim(ble.M_DSP_LABEL),rtrim(sle.M_DSP_LABEL))
else rtrim(ctp.M_DSP_LABEL) end CTP,
case when trn.M_BINTERNAL = trn.M_SINTERNAL then 
case when trn.M_COMMENT_BS = 'B' then rtrim(trn.M_SPFOLIO) else rtrim(trn.M_BPFOLIO) end else '' end PFLO, 
count(case when trn.M_TRN_STATUS = 'LIVE' then 1 else null end) LIVE, 
count(case when trn.M_TRN_STATUS = 'MKT_OP' then 1 else null end) MKT_OP,
count(case when trn.M_TRN_STATUS = 'DEAD' then 1 else null end) DEAD,
count(*) TRADES
from TRN_HDR_DBF trn
left join TRN_PC_DBF pc on 1 = 1
left join TRN_PLIN_DBF plin on trn.M_INSTRUMENT = plin.M_REFERENCE
left join TRN_CPDF_DBF ble on trn.M_BLENTITY = ble.M_ID
left join TRN_CPDF_DBF sle on trn.M_SLENTITY = sle.M_ID
left join TRN_CPDF_DBF ctp on trn.M_COUNTRPART = ctp.M_ID
left join CTP_TYPES_DBF ctyp on (ctp.M_ID = ctyp.M_CTN and ctyp.M_REF = 16)
where coalesce(ble.M_DSP_LABEL,sle.M_DSP_LABEL) = 'TDL'
group by 
pc.M_DATE,
(case when trn.M_BINTERNAL=trn.M_SINTERNAL then 'I' else 'E' end), 
coalesce(rtrim(ble.M_DSP_LABEL),rtrim(sle.M_DSP_LABEL)),
(case when trn.M_COMMENT_BS = 'B' then rtrim(trn.M_BPFOLIO) else rtrim(trn.M_SPFOLIO) end),
ctyp.M_REF,
(case when trn.M_BINTERNAL = trn.M_SINTERNAL then coalesce(rtrim(ble.M_DSP_LABEL),rtrim(sle.M_DSP_LABEL)) else rtrim(ctp.M_DSP_LABEL) end),
(case when trn.M_BINTERNAL = trn.M_SINTERNAL then case when trn.M_COMMENT_BS = 'B' then rtrim(trn.M_SPFOLIO) else rtrim(trn.M_BPFOLIO) end else '' end)  
order by TRN_IE, ENT, PFL, CTP_IE, CTP, PFLO