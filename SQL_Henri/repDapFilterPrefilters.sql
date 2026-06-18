select distinct
rtrim(flt.M_LABEL) FLT_LAB,
case flt.M_CLASS 
when -1 then 'Invalid'
when  0 then 'Undefined'
when  1 then 'Trn_RPPL'
when  3 then 'Trn_RPCS'
when  4 then 'Trn_RPS1'
when  5 then 'Trn_PLVR'
when  6 then 'Trn_RPDT'
when  7 then 'Trn_RPXG'
when  8 then 'Trn_RPSV'
when  9 then 'Trn_RPHB'
when 10 then 'Trn_RPRT'
when 11 then 'Trn_RPFX'
when 12 then 'Trn_RPMK'
when 13 then 'Trn_RPMV'
when 14 then 'Trn_RPCD'
when 15 then 'Trn_RPXV'
when 16 then 'Trn_RPOK'
when 17 then 'Report'
when 18 then 'Accounting'
when 19 then 'Payment'
when 20 then 'CopyCreation'
when 21 then 'External'
when 22 then 'AccountingReporting'
when 23 then 'Trn_SIMUL'
when 24 then 'Trn_PLVAR'
when 25 then 'Trn_JavaPlugin'
when 26 then 'Trn_DataDctEngine'
when 27 then 'Trn_SQL'
when 28 then 'Trn_THETA_ANALYSIS'
when 29 then 'Trn_VAR'
when 30 then 'Trn_SIMUL_PLE'
when 31 then 'Trn_PLVAR_PLE'
when 32 then 'DlvCash'
when 33 then 'Trn_ODREngine'
when 35 then 'NavigationTemplates'
when 36 then 'Trn_PFL_SIMUL'
when 37 then 'LRBRequest'
when 39 then 'STPRightsAudit'
when 40 then 'RiskMatrix'
when 41 then 'ClassificationTree'
when 42 then 'CashPositionStatements'
when 43 then 'SecuritiesPositionStatements'
when 44 then 'LiquidationPositionStatements'
when 46 then 'HedgeConfig'
when 47 then 'HedgeTrade'
when 48 then 'HedgeEffectiveness'
when 49 then 'HedgeMeasurement'
when 50 then 'Trn_VAR_DATASOURCE'
when 51 then 'MarketRiskAggregation'
when 52 then 'LiquidationContributorsStatements'
when 53 then 'Order'
when 54 then 'Livebook'
when 55 then 'Hedge' else null end FLT_CLA,
case flt.M_BUILTON
when 0 then 'Detailed'
when 1 then 'Consolidated'
when 2 then 'Stored Results' else null end BUILT,
case flt.M_LATETRAD
when 0 then 'Default'
when 1 then 'Yes'
when 2 then 'No' else null end LATTRD,
case 
when pre.M_CH_TYPE =  0 then 10
when pre.M_CH_TYPE =  1 then 5
when pre.M_CH_TYPE =  2 then 3
when pre.M_CH_TYPE =  3 then 1
when pre.M_CH_TYPE =  4 then 4
when pre.M_CH_TYPE =  5 then 20
when pre.M_CH_TYPE =  6 then 21
when pre.M_CH_TYPE =  7 then 2
when pre.M_CH_TYPE =  8 then 6
when pre.M_CH_TYPE =  9 then 7
when pre.M_CH_TYPE = 10 then 8 else null end PRE_ORD,
case 
when pre.M_CH_TYPE =  0 then 'Counterpart'
when pre.M_CH_TYPE =  1 then 'Instrument'
when pre.M_CH_TYPE =  2 then 'Portfolio'
when pre.M_CH_TYPE =  3 then 'Table Scanned'
when pre.M_CH_TYPE =  4 then 'Transaction Type'
when pre.M_CH_TYPE =  5 then 'Market Data Set'
when pre.M_CH_TYPE =  6 then 'Deal Number'
when pre.M_CH_TYPE =  7 then 'Entity'
when pre.M_CH_TYPE =  8 then 'Classification'
when pre.M_CH_TYPE =  9 then 'Typology'
when pre.M_CH_TYPE = 10 then 'Tags' else null end PRE_TYP,
null EXP_NDX,
case 
when pre.M_CH_TYPE in (0) then rtrim(ctp.M_DSP_LABEL)
when pre.M_CH_TYPE in (1) then rtrim(plin.M_DSP_LABEL)
when pre.M_CH_TYPE in (2,3,4,7) then rtrim(pre.M_CH_VALUE)
when pre.M_CH_TYPE in (8) then null
when pre.M_CH_TYPE in (9) then rtrim(typo.M_LABEL)
when pre.M_CH_TYPE in (10) then rtrim(tagitm.M_LABEL) else null end PRE_ITM,
flt.M_FILTER_REF FLTREF

from DAPFILTER_DBF flt
left join DAPFLT_CH_DBF pre on flt.M_FILTER_REF = pre.M_FILTER_REF
left join TRN_CPDF_DBF ctp on pre.M_CH_VALUE = to_char(ctp.M_ID) 
left join TRN_PLIN_DBF plin on (pre.M_CH_VALUE = to_char(plin.M_ID) and pre.M_CH_TYPE = 1)
left join CSF_REQUEST_DBF typqry on (pre.M_CH_ID = typqry.M_REFERENCE and pre.M_CH_TYPE = 9)
left join TYPOLOGY_DBF typo on typqry.M_NODE_REF = typo.M_REFERENCE
left join TRN_TAG_DYN_DBF taglst on (pre.M_CH_ID = taglst.M_REFERENCE and pre.M_CH_TYPE = 10)
left join TRN_TAG_DBF tagitm on taglst.M_TAG_REFERENCE = tagitm.M_REFERENCE
/*
where flt.M_FILTER_REF in (
(
2 , 63, 65, 66, 67, 68, 69, 70, 71, 72, 73, 79, 
80, 81, 82, 83, 84, 89, 90, 91, 93, 99,
100, 101, 102, 104, 105, 107, 108, 109, 110, 111, 116,
121, 136, 148, 158, 159, 160, 162, 163, 164, 165, 166
)
*/

union

select distinct
rtrim(flt.M_LABEL) FLT_LAB,
case flt.M_CLASS 
when -1 then 'Invalid'
when  0 then 'Undefined'
when  1 then 'Trn_RPPL'
when  3 then 'Trn_RPCS'
when  4 then 'Trn_RPS1'
when  5 then 'Trn_PLVR'
when  6 then 'Trn_RPDT'
when  7 then 'Trn_RPXG'
when  8 then 'Trn_RPSV'
when  9 then 'Trn_RPHB'
when 10 then 'Trn_RPRT'
when 11 then 'Trn_RPFX'
when 12 then 'Trn_RPMK'
when 13 then 'Trn_RPMV'
when 14 then 'Trn_RPCD'
when 15 then 'Trn_RPXV'
when 16 then 'Trn_RPOK'
when 17 then 'Report'
when 18 then 'Accounting'
when 19 then 'Payment'
when 20 then 'CopyCreation'
when 21 then 'External'
when 22 then 'AccountingReporting'
when 23 then 'Trn_SIMUL'
when 24 then 'Trn_PLVAR'
when 25 then 'Trn_JavaPlugin'
when 26 then 'Trn_DataDctEngine'
when 27 then 'Trn_SQL'
when 28 then 'Trn_THETA_ANALYSIS'
when 29 then 'Trn_VAR'
when 30 then 'Trn_SIMUL_PLE'
when 31 then 'Trn_PLVAR_PLE'
when 32 then 'DlvCash'
when 33 then 'Trn_ODREngine'
when 35 then 'NavigationTemplates'
when 36 then 'Trn_PFL_SIMUL'
when 37 then 'LRBRequest'
when 39 then 'STPRightsAudit'
when 40 then 'RiskMatrix'
when 41 then 'ClassificationTree'
when 42 then 'CashPositionStatements'
when 43 then 'SecuritiesPositionStatements'
when 44 then 'LiquidationPositionStatements'
when 46 then 'HedgeConfig'
when 47 then 'HedgeTrade'
when 48 then 'HedgeEffectiveness'
when 49 then 'HedgeMeasurement'
when 50 then 'Trn_VAR_DATASOURCE'
when 51 then 'MarketRiskAggregation'
when 52 then 'LiquidationContributorsStatements'
when 53 then 'Order'
when 54 then 'Livebook'
when 55 then 'Hedge' else null end FLT_CLA,
case flt.M_BUILTON
when 0 then 'Detailed'
when 1 then 'Consolidated'
when 2 then 'Stored Results' else null end BUILT,
case flt.M_LATETRAD
when 0 then 'Default'
when 1 then 'Yes'
when 2 then 'No' else null end LATTRD,
case 
when exp.M_EXP_TYPE = 1 then 11
when exp.M_EXP_TYPE = 2 then 9 else null end PRE_TYP,
case 
when exp.M_EXP_TYPE = 1 then 'Exp.Excl'
when exp.M_EXP_TYPE = 2 then 'Expression' else null end PRE_TYP,
exp.M_EXP_IND EXP_NDX,
case 
when exp.M_EXP_TYPE in (1,2) then rtrim(exp.M_EXP_VAL) else null end PRE_ITM,
flt.M_FILTER_REF FLTREF

from DAPFILTER_DBF flt
left join DAPFLT_EXP_DBF exp on flt.M_FILTER_REF = exp.M_FILTER_REF

/*
where flt.M_FILTER_REF in 
(
2 , 63, 65, 66, 67, 68, 69, 70, 71, 72, 73, 79, 
80, 81, 82, 83, 84, 89, 90, 91, 93, 99,
100, 101, 102, 104, 105, 107, 108, 109, 110, 111, 116,
121, 136, 148, 158, 159, 160, 162, 163, 164, 165, 166
)
*/

order by FLT_LAB, PRE_ORD, PRE_TYP, EXP_NDX, PRE_ITM