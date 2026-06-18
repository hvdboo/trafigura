select 
to_char(pc.M_DATE,'YYYY-MM-DD') SYSDAT,
case when trn.M_BINTERNAL = trn.M_SINTERNAL then 'I' else 'E' end TRN_IE,
coalesce(rtrim(ble.M_DSP_LABEL),rtrim(sle.M_DSP_LABEL)) ENT,
(case when trn.M_COMMENT_BS ='B' then rtrim(trn.M_BPFOLIO) else rtrim(trn.M_SPFOLIO) end) PFL,
case when ctyp.M_REF = 16 then 'I' else 'E' end CTP_IE, 
case when trn.M_BINTERNAL = trn.M_SINTERNAL 
then coalesce(rtrim(ble.M_DSP_LABEL),rtrim(sle.M_DSP_LABEL))
else rtrim(ctp.M_DSP_LABEL) end CTP,
case when trn.M_TRN_GTYPE in (49, 76, 100, 101, 136, 146) then 'LST' else 'OTC' end LO, 
case trn.M_TRN_GTYPE
when   1 then 'IR Swap'
when   2 then 'IR CurSwap'
when   5 then 'IR Swaption'
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
--- trn.M_TRN_GTYPE FGTN, trn.M_TRN_FMLY FML, trn.M_TRN_GRP GRP, trn.M_TRN_TYPE TYP, 
rtrim(plin.M_DSP_LABEL) PLIN, 
rtrim(trn.M_BRW_ODPL) MAT, 
to_char(trn.M_TRN_EXP,'YYYY-MM-DD') EXP,
trn.M_BRW_STRK STK,
trn.M_BRW_CP RGT,
sum(trn.M_BRW_NOM1 * (case trn.M_BRW_PR1 when 'P' then -1 else 1 end)) NOMINAL,
round(sum(trn.M_BRW_RTE1 * trn.M_BRW_NOM1)/sum(trn.M_BRW_NOM1),4) PRC,
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
where 
coalesce(ble.M_DSP_LABEL,sle.M_DSP_LABEL) = 'TDL'
and trn.M_BINTERNAL <> trn.M_SINTERNAL
and coalesce(ctyp.M_REF,0) = 0
and trn.M_TRN_GTYPE in (49, 76, 100, 101, 136, 146)
and trn.M_TRN_STATUS in ('LIVE','MKT_OP')
group by 
pc.M_DATE,
(case when trn.M_BINTERNAL=trn.M_SINTERNAL then 'I' else 'E' end), 
coalesce(rtrim(ble.M_DSP_LABEL),rtrim(sle.M_DSP_LABEL)),
(case when trn.M_COMMENT_BS ='B' then rtrim(trn.M_BPFOLIO) else rtrim(trn.M_SPFOLIO) end),
ctyp.M_REF,
(case when trn.M_BINTERNAL = trn.M_SINTERNAL then coalesce(rtrim(ble.M_DSP_LABEL),rtrim(sle.M_DSP_LABEL)) else rtrim(ctp.M_DSP_LABEL) end),
trn.M_TRN_GTYPE,
-- trn.M_TRN_FMLY, trn.M_TRN_GRP, trn.M_TRN_TYPE, 
plin.M_DSP_LABEL,
trn.M_BRW_ODPL, trn.M_TRN_EXP, trn.M_BRW_STRK, trn.M_BRW_CP
order by TRN_IE, ENT, PFL, CTP_IE, CTP, LO, FGT, PLIN, EXP