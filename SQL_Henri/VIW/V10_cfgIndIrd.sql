select
case ind.M_CATEGORY
when 0 then 'Rate'
when 1 then 'Equity'
when 2 then 'Bond'
when 3 then 'Inflation'
when 4 then 'Forex'
when 8 then 'Commodity'
when 9 then 'Com FWD' else null end INDCAT,
rtrim(ind.M_IND_LAB)  INDLAB,
rtrim(ind.M_IND_DESC) INDDES,
rtrim(ind.M_CURRENCY) CUR,
rtrim(grp.M_GRP_DESC) ARC,
case ind.M_RESET
when  0 then 'Published'  --'Manual'
when  1 then 'Automatic'
when  2 then 'Compounding'
when  3 then 'Mean'
when  4 then 'Basket'
when  5 then 'Start_End'
when  6 then 'Nearby'
when  7 then 'FxImplied'
when  8 then 'StubFxImplied'
when 10 then 'InflationLpi' else null end FORMULA,
case ind.M_ESTIM_MODE
when 0 then 'Current index'
when 1 then 'Underlying indices'
when 2 then 'Interpolated' else null end ESTIM,
case ind.M_RAT_NAT
when 0 then 'Standard rate'
when 1 then 'Swap rate' else null end NATURE,
rtrim(ind.M_START)      START_SHF,
rtrim(ind.M_RAT_PERIOD) RT_PER,
rtrim(ind.M_RAT_FREQ)   RT_FRQ,
rtrim(ind.M_RATE_CONV)  RT_CNV,
rtrim(crv.M_DLABEL)     EST_RATCRV,
-- Schedule Calc.start
case ind.M_ECP_TYPE 
when 0 then 'Driving schedule'
when 1 then 'Equal to'
when 2 then 'Deduced from'
when 6 then 'Copy of' else null end CLCSTA_TYP,
case ind.M_ECP_TYPE 
when 0 then null
else case ind.M_ECP_UNDRL
when 0 then 'Payment schedule'
when 1 then 'Calc.start schedule'
when 2 then 'Fixing schedule'
when 7 then 'Calc.end schedule' else null end end CLCSTA_UND,
rtrim(ind.M_ECP) CLCSTA_FRM,
-- Schedule Calc.end
case ind.M_ECPE_TYPE 
when 0 then 'Driving schedule'
when 1 then 'Equal to'
when 2 then 'Deduced from'
when 6 then 'Copy of' else null end CLCEND_TYP,
case ind.M_ECPE_TYPE
when 0 then null
else case ind.M_ECPE_UNDR
when 0 then 'Payment schedule'
when 1 then 'Calc.start schedule'
when 2 then 'Fixing schedule'
when 7 then 'Calc.end schedule' else null end end CLCEND_UND,
rtrim(ind.M_ECPE) CLCEND_FRM,
-- Schedule Fixing
case ind.M_EI_TYPE 
when 0 then 'Driving schedule'
when 1 then 'Equal to'
when 2 then 'Deduced from'
when 6 then 'Copy of' else null end FIX_TYP,
case ind.M_EI_TYPE
when 0 then null
else case ind.M_EI_UNDRL
when 0 then 'Payment schedule'
when 1 then 'Calc.start schedule'
when 2 then 'Fixing schedule'
when 7 then 'Calc.end schedule' else null end end FIX_UND,
rtrim(ind.M_EI) FIX_FRM,
-- Schedule Payment
case ind.M_EP_TYPE 
when 0 then 'Driving schedule'
when 1 then 'Equal to'
when 2 then 'Deduced from'
when 6 then 'Copy of' else null end PAY_TYP,
case ind.M_EP_TYPE
when 0 then null
else case ind.M_EP_UNDRL
when 0 then 'Payment schedule'
when 1 then 'Calc.start schedule'
when 2 then 'Fixing schedule'
when 7 then 'Calc.end schedule' else null end end PAY_UND,
rtrim(ind.M_EP) PAY_FRM,
case ind.M_COMP_MODE
when 0 then 'Current index'
when 1 then 'Underlying index' else null end COMPMOD,
rtrim(und.M_IND_LAB)   UND,
rtrim(ind.M_URAT_CONV) UNDRTECNV,
rtrim(ind.M_UEI)       FIXSCH,
rtrim(ind.M_UECF)      CMPSCH,
case ind.M_BROKEN
when 0 then 'Up front'
when 1 then 'In arrears'
when 2 then 'None'
when 3 then 'Both sides'
when 4 then 'Both sides forward' else null end STUB,
case ind.M_F_SHIFT
when 0 then 'No shift'
when 1 then 'Shift'
when 2 then 'Specific date' else null end FSTSHF_MOD,
case ind.M_U_LSHIFT
when 0 then 'First'
when 1 then 'Last' else null end FSTSHF_ON,
rtrim(ind.M_F_SHIFTER) FSTSHF_SHF,
to_char(ind.M_F_SPECIFICDATE,'YYYY-MM-DD')  FSTSHF_SPEDAT,
ind.M_F_SPECIFICVALUE FSTSHF_SPEVAL,
case ind.M_L_SHIFT
when 0 then 'No shift'
when 1 then 'Shift' else null end LSTSHF_MOD,
case ind.M_U_FSHIFT
when 0 then 'Last'
when 1 then 'First' else null end LSTSHF_ON,
rtrim(ind.M_L_SHIFTER) LSTSHF_SHF,
case ind.M_FIXING
when 0 then 'In advance'
when 1 then 'In arrears' else null end FIXMOD,
case ind.M_LOK_PER
when 0 then 'No'
when 1 then 'Yes' else null end CUTOFF,
rtrim(ind.M_LOK_PER_SH) CUTSHF,
case ind.M_PUB_DATE_RULE
when 0 then 'None'
when 1 then 'Capped to shifted payment date' else null end PUBDAT_RUL,
rtrim(ind.M_PUB_RULE_SH) PUBDAT_SHF,
rtrim(ind.M_HISFILE)     HIS,
to_char(ind.M_LOG_DELETE_EFFECTIVE,'YYYY-MM-DD') LOGDEL,
ind.M_REFERENCE          INDUID

from RT_INDEX_DBF ind
left join RT_GROUP_DBF grp on rtrim(ind.M_HISFILE) = rtrim(grp.M_HISFILE)
left join RT_CT_DBF    crv on ind.M_RT_CRV = crv.M_LABEL
left join RT_INDEX_DBF und  on rtrim(ind.M_UNDRL) = rtrim(und.M_INDEX)

where 1 = 1
and ind.M_CATEGORY in (0)
--and ind.M_REFERENCE in (40563, 40410, 40411)