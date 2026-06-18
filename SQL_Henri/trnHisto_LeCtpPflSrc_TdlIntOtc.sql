select 
to_char(pc.M_DATE,'YYYY-MM-DD') SYSDAT,
case when trn.M_BINTERNAL = trn.M_SINTERNAL then 'I' else 'E' end TRN_IE,
case when trn.M_BINTERNAL = trn.M_SINTERNAL or ctyp.M_REF = 16 then 'I' else 'E' end CTP_IE, 
rtrim(src.M_LABEL) SRC,
coalesce(rtrim(ble.M_DSP_LABEL),rtrim(sle.M_DSP_LABEL)) LE,
case when trn.M_BINTERNAL = trn.M_SINTERNAL 
then coalesce(rtrim(ble.M_DSP_LABEL),rtrim(sle.M_DSP_LABEL))
else rtrim(ctp.M_DSP_LABEL) end CTP,
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
*/
case when trn.M_COMMENT_BS ='B' then rtrim(trn.M_BPFOLIO) else rtrim(trn.M_SPFOLIO) end PFL,
rtrim(trn.M_TRN_FMLY) ASSET,
rtrim(typo.M_LABEL) TYPO,
rtrim(plin.M_DSP_LABEL) INSTRUMENT,
case when trn.M_TRN_FMLY ='COM' then rtrim(trn.M_BRW_ODPL) else null end MAT, 
to_char(trn.M_TRN_EXP,'YYYY-MM-DD') EXP,
case when trn.M_TRN_GTYPE in(5, 84, 101, 103, 113, 131, 146) then trn.M_BRW_STRK else null end STK,
rtrim(trn.M_BRW_CP) CP,
sum((case trn.M_COMMENT_BS when 'B' then  1 else -1 end) * trn.M_BRW_NOM1) NOM1,
-- sum((case trn.M_COMMENT_BS when 'B' then -1 else  1 end) * (case when trn.M_TRN_FMLY in ('CURR') then trn.M_BRW_NOM2 else 0 end)) NOM2,
sum((case trn.M_COMMENT_BS when 'B' then -1 else  1 end) * (case when rtrim(typo.M_LABEL) in ('Outright','NDF','Xccy Swap','Vanilla Option FXD') then trn.M_BRW_NOM2 else 0 end)) NOM2,
-- sum(trn.M_BRW_RTE1*trn.M_BRW_NOM1)/sum(trn.M_BRW_NOM1) PRC1,
-- sum(trn.M_BRW_RTE2*trn.M_BRW_NOM1)/sum(trn.M_BRW_NOM1) PRC2,
-- count(case when trn.M_TRN_STATUS = 'LIVE' then 1 else null end) LIVE, 
-- count(case when trn.M_TRN_STATUS = 'MKT_OP' then 1 else null end) MKT_OP,
-- count(case when trn.M_TRN_STATUS = 'DEAD' then 1 else null end) DEAD,
count(*) TRADES

from TRN_HDR_DBF trn
left join TRN_PC_DBF pc on 1 = 1
left join TRN_PLIN_DBF plin on trn.M_INSTRUMENT = plin.M_REFERENCE
left join TRN_CPDF_DBF ble on trn.M_BLENTITY = ble.M_ID
left join TRN_CPDF_DBF sle on trn.M_SLENTITY = sle.M_ID
left join TRN_CPDF_DBF ctp on trn.M_COUNTRPART = ctp.M_ID
left join CTP_TYPES_DBF ctyp on (ctp.M_ID = ctyp.M_CTN and ctyp.M_REF = 16)
left join CONTRACT_DBF cnt on trn.M_CONTRACT = cnt.M_REFERENCE
left join TYPOLOGY_DBF typo on cnt.M_TYPOLOGY = typo.M_REFERENCE
left join SRC_MOD_DBF src on cnt.M_SRC_MODULE = src.M_REFERENCE

where 
coalesce(ble.M_DSP_LABEL,sle.M_DSP_LABEL) in ('TDL')
and ((trn.M_BINTERNAL = trn.M_SINTERNAL) or (coalesce(ctyp.M_REF,0) = 16))
and trn.M_TRN_GTYPE not in (49, 76, 100, 101, 136, 146)
and rtrim(src.M_LABEL) = 'TRT'
and trn.M_TRN_STATUS <> 'DEAD'

group by 
pc.M_DATE,
(case when trn.M_BINTERNAL=trn.M_SINTERNAL then 'I' else 'E' end),
(case when trn.M_BINTERNAL = trn.M_SINTERNAL or ctyp.M_REF = 16 then 'I' else 'E' end),
src.M_LABEL,
coalesce(rtrim(ble.M_DSP_LABEL),rtrim(sle.M_DSP_LABEL)),
(case when trn.M_BINTERNAL = trn.M_SINTERNAL then coalesce(rtrim(ble.M_DSP_LABEL),rtrim(sle.M_DSP_LABEL)) else rtrim(ctp.M_DSP_LABEL) end),
-- trn.M_TRN_GTYPE, 
(case when trn.M_COMMENT_BS ='B' then rtrim(trn.M_BPFOLIO) else rtrim(trn.M_SPFOLIO) end),
trn.M_TRN_FMLY,
typo.M_LABEL,
plin.M_DSP_LABEL,
case when trn.M_TRN_FMLY ='COM' then rtrim(trn.M_BRW_ODPL) else null end,
to_char(trn.M_TRN_EXP,'YYYY-MM-DD'),
case when trn.M_TRN_GTYPE in(5, 84, 101, 103, 113, 131, 146) then trn.M_BRW_STRK else null end,
rtrim(trn.M_BRW_CP)

order by LE, TRN_IE, CTP_IE, CTP, PFL, ASSET, TYPO, INSTRUMENT, EXP, STK