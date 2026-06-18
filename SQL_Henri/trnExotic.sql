select 
loan.M_NB as M_NB, 
case loan.M_INSTR_TYPE
when 12 then 'COM Asian'
when 13 then 'COM Swap' 
when 17 then 'COM Option on Future' 
when 18 then 'COM Future'
when 28 then 'COM Simple Option' 
when 30 then 'COM Option on Forward'
else null end as M_INS_TYP,
rtrim(typo.M_LABEL) as M_CMP_TYPO,
rtrim(plin.M_DSP_LABEL) M_INSTRUMENT,
loan.M_LEG0 as M_LEG0,
loan.M_REF_CAP0 as M_CAPITAL,
case loan.M_INSTR_TYPE
when 12 then loan.M_LN_STRIKE0
when 28 then loan.M_INS_STRIKE else null end as M_STRIKE,
rtrim(lni0.M_IND_LAB) as M_RAT_IND0, 
loan.M_RATE_FACT0 as M_RAT_FCT0, 
loan.M_RATE_MARG0 as M_RAT_MRG0,
case loan.M_INSTR_TYPE
when 12 then loan.M_CAP_FRAC0
when 13 then loan.M_CAP_FRAC0
when 28 then loan.M_DIG_RATE 
when 30 then loan.M_DIG_RATE else null end as M_DIG_RATE,
case when rng0.M_RNG_SCYN = 0 then 'Daily' else rtrim(rng0.M_RNG_SCH) end as M_RNG_SCH,
case when rng0.M_RNG_SCYN = 0 then  
case rng0.M_RNG_SCHED when 0 then 'Days' when 1 then 'Business days' else null end 
else rtrim(rng0.M_RNG_CAL) end as M_RNG_CAL,
case rng0.M_RNG_APPLYT when 0 then 'Coupon' when 1 then 'Rate' else null end as M_RNG_APPLY,
rtrim(rgi0.M_IND_LAB) as M_RNG_IND, 
rng0.M_RNG_RFACT as M_RNG_FCT, 
case rng0.M_RNG_TYPE
when  0 then 'above(>)'
when  1 then 'below(<)'
when  2 then 'between (> and <)'
when  3 then 'above (>=)'
when  4 then 'below (<=)'
when  5 then 'between (>= and <=)'
when  6 then 'between (> and <=)'
when  7 then 'between (>= and <)'
when  8 then 'outside (< or >)'
when  9 then 'outside (<= or >=)'
when 10 then 'outside (< or >=)'
when 11 then 'outside (<= or >)' else null end as M_RNG_BOUND,
rng0.M_RNG_RATE0 as M_RNG_STK,
case exo.M_INS_BAR_TP
when  0 then 'None'
when  1 then 'Up and in (>=)'
when  2 then 'Up and out (>=)'
when  3 then 'Down and in (<=)'
when  4 then 'Down and out (<=)'
when  5 then 'Up and in (>)'
when  6 then 'Up and out (>)'
when  7 then 'Down and in (<)'
when  8 then 'Down and out (<)'
when  9 then 'Double out'
when 10 then 'Double in' else null end as M_BAR_TYP,
exo.M_INS_BARR as M_BAR_STK1, exo.M_INS_SECBAR as M_BAR_STK2,
case exo.M_EXR_BAR_CM
when 0 then 'Discrete'
when 1 then 'Continuous' else null end as M_BAR_OBS,
case loan.M_INSTR_TYPE
when 12 then
case exo.M_INS_BAR_SC
when 0 then 'Cap/floor (daily checking)'
when 1 then 'Period (daily checking)'
when 2 then 'Period (on reset date)'
when 3 then 'Cap/floor (on reset date)'
when 4 then 'Cap/floor (continuous checking)'
when 5 then 'Period (continuous checking)' else null end 
when 30 then
case exo.M_INS_BAR_SC
when 1 then 'European'
when 2 then 'American' else null end end as M_BAR_KILL,
exo.M_K_REBATE as M_BAR_REBATE,
case exo.M_K_RB_PAYDAT
when 0 then 'Maturity'
when 1 then 'Knock time' else null end as M_BAR_REBSTL,
case fws0.M_FWDSTARTSTYLE
when 0 then 'One date per period'
when 1 then 'Ratio'
when 2 then 'Average by period' else null end as M_FWS_TYP,
fws0.M_FWDSTARTDATE as M_FWS_DAT,
fws0.M_FWDSTARTFAC as M_FWS_FCT,
case loan.M_INSTR_TYPE
when 12 then null
when 30 then null
else
case exo.M_EXO_RTRN_TYPE
when -1 then 'No return'
when  0 then 'Return (P2-P1)/P1'
when  1 then 'Spread (P2-P1)'
when  2 then 'Initial return (P2-P0)/P0'
when  3 then 'Initial spread (P2-P0)'
when  4 then 'Ratio P2/P1'
when  5 then 'Initial ratio P2/P0'
when  6 then 'Plain rate' else null end end as M_RAT_RET,
exr.M_EXR_NB as M_OPT_EXR
from RT_LOAN_DBF loan
left join RT_LNGN_DBF  lng  on loan.M_GEN_NUM = lng.M_GEN_NUM
left join RT_INDEX_DBF lni0 on rtrim(lng.M_INDEX0) = trim(lni0.M_INDEX)
left join RT_INDEX_DBF lni1 on rtrim(lng.M_INDEX1) = trim(lni1.M_INDEX)
left join RT_RANGE_DBF rng0 on (loan.M_NB = rng0.M_RNG_NB and loan.M_LEG0 = rng0.M_RNG_LEG)
left join RT_INDEX_DBF rgi0 on rtrim(rng0.M_RNG_INDEX) = rtrim(rgi0.M_INDEX)
left join RT_LN_INEXO_LIST_DBF exl on loan.M_NB = exl.M_NB
left join RT_INEXO_DBF exo on exl.M_REF_INEXO = exo.M_REFERENCE
left join RT_EX_BLOCK_DBF exr on exo.M_EXR_BLK = exr.M_EXR_NB
left join RT_EXOT_DBF fws0 on (loan.M_NB = fws0.M_EXOT_NB and loan.M_LEG0 = fws0.M_EXOT_LEG)
left join TRN_HDR_DBF trn on loan.M_NB = trn.M_NB
left join TRN_PLIN_DBF plin on rtrim(trn.M_INSTRUMENT) = rtrim(plin.M_REFERENCE)
left join TYPOLOGY_DBF typo on trn.M_TYPOLOGY = typo.M_REFERENCE 
--where loan.M_INSTR_TYPE in (12, 13, 28,30)
where loan.M_NB = 114552