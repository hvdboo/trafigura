select 
to_char(pc.M_DATE,'YYYY-MM-DD') SYSDAT,
case when trn.M_COMMENT_BS = 'B' then rtrim(trn.M_BENTITY) else rtrim(trn.M_SENTITY) end CE,
case when trn.M_COMMENT_BS = 'B' then rtrim(buyple.M_DSP_LABEL) else rtrim(selple.M_DSP_LABEL) end PFL_LE,
case when trn.M_COMMENT_BS = 'B' then rtrim(buytle.M_DSP_LABEL) else rtrim(seltle.M_DSP_LABEL) end TRN_LE,
-- case when trn.M_BINTERNAL = trn.M_SINTERNAL then 'I' else 'E' end IE,
case when trn.M_COMMENT_BS = 'B' then rtrim(trn.M_BPFOLIO) else rtrim(trn.M_SPFOLIO) end PFL,
-- coalesce(rtrim(spfl.M_LABEL),rtrim(dpfl.M_LABEL)) PFL2,
trn.M_PL_INSCUR CUR,
/*
case when trn.M_TRN_FMLY = 'CURR' then trn.M_BRW_NOMU1 else null end UND_CUR,

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
left join TRN_PFLD_DBF buypfl on trn.M_BPFOLIO = buypfl.M_LABEL
left join TRN_PFLD_DBF selpfl on trn.M_SPFOLIO = selpfl.M_LABEL
left join TRN_PFLD_DBF srcpfl on trn.M_SRC_PFOLIO = srcpfl.M_REF
left join TRN_PFLD_DBF dstpfl on trn.M_DST_PFOLIO = dstpfl.M_REF
left join TRN_CPDF_DBF buyple on buypfl.M_PROC_AREA = buyple.M_ID
left join TRN_CPDF_DBF selple on selpfl.M_PROC_AREA = selple.M_ID
left join TRN_CPDF_DBF buytle on trn.M_BLENTITY = buytle.M_ID
left join TRN_CPDF_DBF seltle on trn.M_SLENTITY = seltle.M_ID
left join TRN_CPDF_DBF ctp on trn.M_COUNTRPART = ctp.M_ID

left join CTP_TYPES_DBF ctyp on (ctp.M_ID = ctyp.M_CTN and ctyp.M_REF = 16)
left join TRN_PLIN_DBF plin on trn.M_INSTRUMENT = plin.M_REFERENCE


where 
(rtrim(trn.M_TRN_FMLY) = 'COM' and trn.M_PL_INSCUR <> 'USD') 
-- or (rtrim(trn.M_TRN_FMLY) = 'CURR' and trn.M_BRW_NOMU1 <> 'USD')
-- and trn.M_TRN_EXP <= pc.M_DATE

group by 
to_char(pc.M_DATE,'YYYY-MM-DD'),
case when trn.M_COMMENT_BS = 'B' then rtrim(trn.M_BENTITY) else rtrim(trn.M_SENTITY) end,
case when trn.M_COMMENT_BS = 'B' then rtrim(buyple.M_DSP_LABEL) else rtrim(selple.M_DSP_LABEL) end,
case when trn.M_COMMENT_BS = 'B' then rtrim(buytle.M_DSP_LABEL) else rtrim(seltle.M_DSP_LABEL) end,
-- case when trn.M_BINTERNAL = trn.M_SINTERNAL then 'I' else 'E' end,
case when trn.M_COMMENT_BS = 'B' then rtrim(trn.M_BPFOLIO) else rtrim(trn.M_SPFOLIO) end,
trn.M_PL_INSCUR
/*
case when trn.M_TRN_FMLY = 'CURR' then trn.M_BRW_NOMU1 else null end,
(case when trn.M_BINTERNAL=trn.M_SINTERNAL then 'I' else 'E' end), 
coalesce(rtrim(ble.M_DSP_LABEL),rtrim(sle.M_DSP_LABEL)),
ctyp.M_REF,
(case when trn.M_BINTERNAL = trn.M_SINTERNAL then coalesce(rtrim(ble.M_DSP_LABEL),rtrim(sle.M_DSP_LABEL)) else rtrim(ctp.M_DSP_LABEL) end),
*/

order by CE, PFL_LE, TRN_LE, CUR, PFL