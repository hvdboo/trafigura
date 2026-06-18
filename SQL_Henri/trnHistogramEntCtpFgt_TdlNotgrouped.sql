select 
trn.M_NB,
case when trn.M_BINTERNAL=trn.M_SINTERNAL then 'I' else 'E' end IE,
coalesce(rtrim(ble.M_DSP_LABEL),rtrim(sle.M_DSP_LABEL)) ENT,
rtrim(ctp.M_DSP_LABEL) CTP,
case trn.M_TRN_GTYPE
when   1 then 'IR Swap'
when   2 then 'IR CurSwap'
when   5 then 'IR Swaption'
when  49 then 'IR Short Fut'
when  76 then 'FX Future'
when  77 then 'FX Spot'
when  84 then 'FX Opt.Smp'
when  90 then 'Simple Cash'
when 100 then 'CM Future'
when 101 then 'CM Opt.Fut LST'
when 102 then 'CM Forward'
when 103 then 'CM Opt.Fwd'
when 113 then 'CM Opt.Smp'
when 130 then 'CM Swap'
when 131 then 'CM Asian'
when 134 then 'CM Spot'
when 146 then 'CM Asn.Clr'
when 154 then 'CM Physical' else null end FGT,
--- trn.M_TRN_GTYPE FGTN, trn.M_TRN_FMLY FML, trn.M_TRN_GRP GRP, trn.M_TRN_TYPE TYP, 
-- rtrim(plin.M_DSP_LABEL) INSTRUMENT, 
trn.M_TRN_STATUS

from TRN_HDR_DBF trn
left join TRN_PLIN_DBF plin on trn.M_INSTRUMENT = plin.M_REFERENCE
left join TRN_PFLD_DBF bpf on trn.M_BPFOLIO = ble.M_ID
left join TRN_PFLD_DBF spf on trn.M_SPFOLIO = sle.M_ID
left join TRN_CPDF_DBF ctp on trn.M_COUNTRPART = ctp.M_ID
--where trn.M_TRN_FMLY = 'COM' 
where coalesce(rtrim(ble.M_DSP_LABEL),rtrim(sle.M_DSP_LABEL)) = 'TDL'

order by IE, ENT, CTP, FGT