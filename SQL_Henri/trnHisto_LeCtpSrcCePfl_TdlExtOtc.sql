select 
to_char(pc.M_DATE,'YYYY-MM-DD') SYSDAT,
coalesce(rtrim(ble.M_DSP_LABEL),rtrim(sle.M_DSP_LABEL)) LE,
case when trn.M_BINTERNAL = trn.M_SINTERNAL then 'I' else 'E' end TRN_IE,
case when ctyp.M_REF = 16 then 'I' else 'E' end CTP_IE, 
case when trn.M_BINTERNAL = trn.M_SINTERNAL 
then coalesce(rtrim(ble.M_DSP_LABEL),rtrim(sle.M_DSP_LABEL))
else rtrim(ctp.M_DSP_LABEL) end CTP,
(case when rtrim(src.M_LABEL) = 'TRT' then 'TRT' else 'Other' end) SRC,
-- (case when cnt.M_PACK_REF > 0 then 'PKG' else 'NPK' end) PCK,
-- (case when trn.M_COMMENT_BS ='B' then rtrim(trn.M_BENTITY) else rtrim(trn.M_SENTITY) end) CE,
-- (case when trn.M_COMMENT_BS ='B' then rtrim(trn.M_BPFOLIO) else rtrim(trn.M_SPFOLIO) end) PFL,
/*
case when trn.M_TRN_GTYPE in (49, 76, 100, 101, 136, 146) then 'LST' else 'OTC' end LO,
case trn.M_TRN_GTYPE
when   1 then 'IR Swap'
when   2 then 'IR CurSwap'
when   5 then 'IR Swaption'
when  47 then 'Equity futures'
when  49 then 'IR Short Fut'
when  76 then 'FX Future'
when  77 then 'FX Spot'
when  84 then 'FX Opt.Smp'
when  90 then 'Simple Cash'
when  92 then 'Forex-Swap'
when 100 then 'CM Future'
when 101 then 'CM Opt.Fut LST'
when 102 then 'CM Forward'
when 103 then 'CM Opt.Fwd'
when 113 then 'CM Opt.Smp'
when 130 then 'CM Swap'
when 131 then 'CM Asian'
when 134 then 'CM Spot'
when 136 then 'CM Clr.Swap'
when 146 then 'CM Clr.Asian'
when 154 then 'CM Physical' else null end FGT,
rtrim(plin.M_DSP_LABEL) INSTRUMENT, 
*/
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
left join CONTRACT_DBF cnt on trn.M_CONTRACT = cnt.M_REFERENCE
left join SRC_MOD_DBF src on cnt.M_SRC_MODULE = src.M_REFERENCE
where 
coalesce(ble.M_DSP_LABEL,sle.M_DSP_LABEL) = 'TDL'
and trn.M_BINTERNAL <> trn.M_SINTERNAL
and coalesce(ctyp.M_REF,0) = 0
and trn.M_TRN_GTYPE not in (49, 76, 100, 101, 136, 146)
and trn.M_TRN_STATUS <> 'DEAD'
and rtrim(src.M_LABEL) <> 'TRT'
group by 
pc.M_DATE,
coalesce(rtrim(ble.M_DSP_LABEL),rtrim(sle.M_DSP_LABEL)),
(case when trn.M_BINTERNAL=trn.M_SINTERNAL then 'I' else 'E' end), 
ctyp.M_REF,
(case when trn.M_BINTERNAL = trn.M_SINTERNAL then coalesce(rtrim(ble.M_DSP_LABEL),rtrim(sle.M_DSP_LABEL)) else rtrim(ctp.M_DSP_LABEL) end),
(case when rtrim(src.M_LABEL) = 'TRT' then 'TRT' else 'Other' end)
(case when cnt.M_PACK_REF > 0 then 'PKG' else 'NPK' end),
-- (case when trn.M_COMMENT_BS ='B' then rtrim(trn.M_BENTITY) else rtrim(trn.M_SENTITY) end),
-- (case when trn.M_COMMENT_BS ='B' then rtrim(trn.M_BPFOLIO) else rtrim(trn.M_SPFOLIO) end)
-- trn.M_TRN_GTYPE, plin.M_DSP_LABEL
order by TRN_IE, LE, CTP_IE, CTP, SRC