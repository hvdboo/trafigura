select distinct
rtrim(flt.M_LABEL) FLT_LAB,
rtrim(flt.M_DESC)  FLT_DES,
rtrim(flt.M_OWNER) RGT_OWN, rtrim(flt.M_GROUP) RGT_GRP, 
case flt.M_VISIBILITY
when 'E' then 'Everybody' 
when 'G' then 'Group'
when 'O' then 'Owner' else null end RGT_VIZ,
case flt.M_UPDATE_RGT
when 'E' then 'Everybody' 
when 'G' then 'Group'
when 'O' then 'Owner' else null end RGT_URG, 
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
flt.M_OVR_DYNTBL OVRDYN,
dat.M_INDEX DAT_NDX,
rtrim(dat.M_DESC) DAT_DES,
case dat.M_TYPE
when  0 then 'No Selection'
when  1 then 'Contextual Today'
when  2 then 'Contextual Yesterday'
when  3 then 'Origin Monthly'
when  4 then 'Date minus N'
when  5 then 'Inception Date'
when  6 then 'System Date'
when  7 then 'User Defined Date'
when  8 then 'Accounting Date'
when  9 then 'Relative Previous'
when 10 then 'Relative Next'
when 11 then 'Origin Simulation'
when 12 then 'Origin Daily'
when 13 then 'Origin Yearly'
when 14 then 'Date plus N'
when 15 then 'Trading Date'
when 16 then 'Trading Yesterday'
when 17 then 'P&L Date'
when 18 then 'P&L Yesterday'
when 19 then 'Date Shifter'
when 23 then 'Reporting Date'
when 24 then 'Reporting Shifter Date' else null end DAT_TYP, 
case dat.M_TYPE
when  4 then to_char(dat.M_OFFSET)
when  7 then to_char(dat.M_VALUE)
when  9 then to_char(dat.M_OFFSET)
when 10 then to_char(dat.M_OFFSET)
when 14 then to_char(dat.M_OFFSET)
when 19 then rtrim(dat.M_SHIFTER)
when 24 then rtrim(dat.M_SHIFTER) else null end DAT_ADJ,
rtrim(mds.M_LABEL) DAT_MDS

from DAPFILTER_DBF flt
left join DAPFLT_DAT_DBF dat on flt.M_FILTER_REF = dat.M_FILTER_REF
left join TRN_MDS_DBF mds on dat.M_MKTDATA = mds.M_REFERENCE
-- where flt.M_FILTER_REF in (31, 169, 174, 175)
order by FLT_LAB, dat.M_INDEX