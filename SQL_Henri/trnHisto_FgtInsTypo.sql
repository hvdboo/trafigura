select 
rtrim(trn.M_TRN_FMLY) FML,
rtrim(trn.M_TRN_GRP)  GRP,
rtrim(trn.M_TRN_TYPE) TYP,
rtrim(trn.M_TRN_GTYPE) GTYP,
rtrim(typo.M_LABEL) TYPO,
rtrim(trn.M_INSTRUMENT) INS_REF,
case plin.M_FAMILY
when     1 then 'Security'
when     2 then 
    case gen.M_INSTR_TYPE
    when  0 then 'IR Swap'
    when  1 then 'IR Bond'
    when  2 then 'IR Cap/Floor'
    when  3 then 'IR Loan'
    when  4 then 'IR FRA'
    when  7 then 'IR Asset swap'
    when  8 then 'FIN Call depo'
    when  9 then 'CR CDS'
    when 12 then 'CM Asian'
    when 13 then 'CM Swap'
    when 14 then 'CR TRS'
    when 15 then 'IR Inflation swap'
    when 16 then 'CR RTRS'
    when 17 then 'CM Opt.Fut'
    when 18 then 'CM Fut'
    when 19 then 'EDS'
    when 20 then 'CM Opt.Index'
    when 21 then 'FIN Repo'
    when 22 then 'FIN BSB'
    when 23 then 'FIN STO'
    when 26 then 'IR Return swap' 
    when 27 then 'CM Phys.Fwd'
    when 29 then 'FIN Credit line' else null end
when     4 then 'CR Reference entity'
when    16 then 'FX Forex'
when    32 then 
    case cmfut.M_LISTED
    when  1 then 'CM Future'
    when  2 then 'CM Forward'
    when 16 then 'CM Clr.Swap'
    when 32 then 'CM Clr.Asian'
    when 64 then 'CM Option LST' else null end
when    64 then 'FX Currency'
when   256 then 
    case ind.M_CATEGORY
    when 0 then 'RT Index'
    when 1 then 'EQ Index'
    when 2 then 'Bond'
    when 3 then 'Inflation Index'
    when 4 then 'FX Index'
    when 5 then 'Mortgage Index'
    when 6 then 'Generic Index'
    when 7 then 'Formula Index'
    when 8 then 'CM Spot Index'
    when 9 then 'CM Fwd. Index' else null end
when   512 then 'CM Asian'
when  2048 then 'CM Physical'
when 16384 then 
    case cmfut.M_LISTED
    when  1 then 'CM Future'
    when  2 then 'CM Forward'
    when 16 then 'CM Clr.Swap'
    when 32 then 'CM Clr.Asian'
    when 64 then 'CM Option LST' else null end
else null end INS_FML,
rtrim(plin.M_DSP_LABEL) INS_LAB,
count(*) OCC

from TRN_HDR_DBF trn
left join TRN_PLIN_DBF plin on trn.M_INSTRUMENT = plin.M_REFERENCE
left join CONTRACT_DBF cnt on trn.M_CONTRACT = cnt.M_REFERENCE
left join TYPOLOGY_DBF typo on cnt.M_TYPOLOGY = typo.M_REFERENCE
left join RT_INSGN_DBF gen on (rtrim(plin.M_LABEL) = to_char(gen.M_GEN_NUM) and plin.M_FAMILY in (2,512))
left join RT_INDEX_DBF ind on (plin.M_LABEL = ind.M_INDEX and plin.M_FAMILY = 256)
left join CM_FUT_DBF cmfut on (rtrim(substr(plin.M_LABEL,9,10)) = to_char(cmfut.M_REFERENCE) and plin.M_FAMILY in (32,16384))

where 
trn.M_TRN_GTYPE in (101,103,113,131)
-- and trn.M_TRN_FMLY = 'COM' 
-- and trn.M_TRN_GRP <> 'FUT'
-- trn.M_MOP_LAST not in (6,7)
--and (trim(trn.M_BPFOLIO) = 'MCEX APE TDLI' or trim(trn.M_SPFOLIO) = 'MCEX APE TDLI')

group by
trn.M_TRN_FMLY,
trn.M_TRN_GRP,
trn.M_TRN_TYPE,
trn.M_TRN_GTYPE,
typo.M_LABEL,
trn.M_INSTRUMENT,
case plin.M_FAMILY
when     1 then 'Security'
when     2 then 
    case gen.M_INSTR_TYPE
    when  0 then 'IR Swap'
    when  1 then 'IR Bond'
    when  2 then 'IR Cap/Floor'
    when  3 then 'IR Loan'
    when  4 then 'IR FRA'
    when  7 then 'IR Asset swap'
    when  8 then 'FIN Call depo'
    when  9 then 'CR CDS'
    when 12 then 'CM Asian'
    when 13 then 'CM Swap'
    when 14 then 'CR TRS'
    when 15 then 'IR Inflation swap'
    when 16 then 'CR RTRS'
    when 17 then 'CM Opt.Fut'
    when 18 then 'CM Fut'
    when 19 then 'EDS'
    when 20 then 'CM Opt.Index'
    when 21 then 'FIN Repo'
    when 22 then 'FIN BSB'
    when 23 then 'FIN STO'
    when 26 then 'IR Return swap' 
    when 27 then 'CM Phys.Fwd'
    when 29 then 'FIN Credit line' else null end
when     4 then 'CR Reference entity'
when    16 then 'FX Forex'
when    32 then 
    case cmfut.M_LISTED
    when  1 then 'CM Future'
    when  2 then 'CM Forward'
    when 16 then 'CM Clr.Swap'
    when 32 then 'CM Clr.Asian'
    when 64 then 'CM Option LST' else null end
when    64 then 'FX Currency'
when   256 then 
    case ind.M_CATEGORY
    when 0 then 'RT Index'
    when 1 then 'EQ Index'
    when 2 then 'Bond'
    when 3 then 'Inflation Index'
    when 4 then 'FX Index'
    when 5 then 'Mortgage Index'
    when 6 then 'Generic Index'
    when 7 then 'Formula Index'
    when 8 then 'CM Spot Index'
    when 9 then 'CM Fwd. Index' else null end
when   512 then 'CM Asian'
when  2048 then 'CM Physical'
when 16384 then 
    case cmfut.M_LISTED
    when  1 then 'CM Future'
    when  2 then 'CM Forward'
    when 16 then 'CM Clr.Swap'
    when 32 then 'CM Clr.Asian'
    when 64 then 'CM Option LST' else null end
else null end,
rtrim(plin.M_DSP_LABEL), rtrim(plin.M_DESC)

order by FML, GRP, TYP, INS_LAB
