select distinct
rtrim(flt.M_LABEL) FLT_LAB,
rtrim(flt.M_DESC) FLT_DES,
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

rtrim(flt.M_OWNER) RGT_OWN, rtrim(flt.M_GROUP) RGT_GRP, 
case flt.M_VISIBILITY
when 'E' then 'Everybody' 
when 'G' then 'Group'
when 'O' then 'Owner' else null end RGT_VIZ,
case flt.M_UPDATE_RGT
when 'E' then 'Everybody' 
when 'G' then 'Group'
when 'O' then 'Owner' else null end RGT_URG, 
case pfl.M_CH_TYPE
when  0 then 'Counterpart'
when  1 then 'Instrument'
when  2 then 'Portfolio'
when  3 then 'Table Scanned'
when  4 then 'Transaction Type'
when  5 then 'Market Data Set'
when  6 then 'Deal Number'
when  7 then 'Entity'
when  8 then 'Classification'
when  9 then 'Typology'
when 10 then 'Tags' else null end PFL_TYP,
case 
when pfl.M_CH_TYPE in (1) then rtrim(plin.M_DSP_LABEL)
when pfl.M_CH_TYPE in (2,3,4,7) then rtrim(pfl.M_CH_VALUE)
when pfl.M_CH_TYPE in (9) then rtrim(typo.M_LABEL) 
else null end PFL_ITM

from DAPFILTER_DBF flt
left join DAPFLT_DAT_DBF dat on flt.M_FILTER_REF = dat.M_FILTER_REF
left join DAPFLT_CH_DBF pfl on flt.M_FILTER_REF = pfl.M_FILTER_REF
left join TRN_PLIN_DBF plin on (pfl.M_CH_VALUE = to_char(plin.M_ID) and pfl.M_CH_TYPE = 1)
left join CSF_REQUEST_DBF typqry on (pfl.M_CH_ID = typqry.M_REFERENCE and pfl.M_CH_TYPE = 9)
left join TYPOLOGY_DBF typo on typqry.M_NODE_REF = typo.M_REFERENCE
 
-- where flt.M_FILTER_REF in (31, 174, 175)
order by FLT_LAB, PFL_TYP, PFL_ITM