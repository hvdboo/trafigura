select 
loan.M_NB TRN,
hdr.M_TRN_GTYPE FGT,
hdr.M_TRN_FMLY FML,
hdr.M_TRN_GRP GRP,
hdr.M_TRN_TYPE TYP,
case loan.M_LISTED
when 1 then 'LST'
when 2 then 'OTC' else null end LO,
-- loan.M_GEN_NAT NAT,
case loan.M_GEN_NAT
when  0 then 'Template'
when  1 then 'Currency swap'
when  2 then 'Index'
when  3 then 'Index issued from currency'
when  4 then 'Generator/currency'
when  5 then 'Generator/index'
when  6 then 'Bond/currency'
when  7 then 'Bond/index'
when  8 then 'Generic'
when  9 then 'Commodity future fixed'
when 10 then 'Commodity future future'
when 11 then 'Future index'
when 12 then 'COM Spot' else null end GENNAT,
loan.M_INSTR_TYPE,
case loan.M_INSTR_TYPE
when  0 then 'Swap'
when  1 then 'Bond'
when  2 then 'Caps/Floors'
when  3 then 'Loan'
when  4 then 'FRA'
when  7 then 'Asset swap'
when  8 then 'Call deposit'
when  9 then 'CDS'
when 12 then 'COM Asian'
when 13 then 'COM Swap'
when 14 then 'TRS'
when 15 then 'Inflation swap'
when 16 then 'RTRS'
when 17 then 'COM Future, OFut'
when 18 then 'COM Fut'
when 19 then 'EDS'
when 20 then 'COM Spot'
when 21 then 'Fin repo'
when 22 then 'Fin BSB'
when 23 then 'Fin stock loan'
when 24 then 'Fin contract for difference'
when 27 then 'COM Physical'
when 28 then 'COM Opt.Smp'
when 30 then 'COM Forward, OFwd' else null end INSTYP,
case loan.M_EXR_MODE
when 0 then 'Delivery'
when 1 then 'Cash settlement'
when 2 then 'Cash ZC'
when 3 then 'Cash Unadjusted'
when 4 then 'Cash Adjusted' else null end EXRMOD,
case loan.M_OPT_TYPE
when 0 then 'European'
when 1 then 'American'
when 2 then 'Bermuda' else null end EXRSTY,
-- Leg 0
case loan.M_LN_PAYREC0
when 0 then 'Pay'
when 1 then 'Receive' else null end PR0,
rtrim(ind0.M_IND_LAB) IND0,
rtrim(hsr0.M_LABEL) HSR0,
to_char(loan.M_START_DAT0,'YYYY-MM-DD') FXGF0,
to_char(loan.M_MATURITY0,'YYYY-MM-DD') FXGL0,
loan.M_RATE_MARG0 MRG0,
-- Leg 1
case loan.M_LN_PAYREC1
when 0 then 'Pay'
when 1 then 'Receive' else null end PR1,
rtrim(ind1.M_IND_LAB) IND1,
rtrim(hsr1.M_LABEL) HSR1,
to_char(loan.M_START_DAT1,'YYYY-MM-DD') FXGF1,
to_char(loan.M_MATURITY1,'YYYY-MM-DD') FXGL1,
loan.M_RATE_MARG1 RT1, 
-- TAS
case loan.M_REFER
when 4096 then 'TAS' else null end TASFLG,
loan.M_SALE_MARG1 TASMRG,
-- QTY
loan.M_REF_CAP0 NOM,
loan.M_INITPRIC0 LOTSIZ,
loan.M_PRINCIPAL0 QTY, 
-- Conso
loan.M_CSGEN_REF CNSGEN

from RT_LOAN_DBF loan
left join TRN_HDR_DBF hdr on loan.M_NB = hdr.M_NB
left join RT_INDEX_DBF ind0 on loan.M_GEN_IND = ind0.M_INDEX
left join CM_MKTSR_DBF hsr0 on to_number(trim(substr(loan.M_GEN_FRM,2,6))) = hsr0.M_SERIE
left join RT_INDEX_DBF ind1 on loan.M_GEN_IND2 = ind1.M_INDEX
left join CM_MKTSR_DBF hsr1 on to_number(trim(substr(loan.M_GEN_FRM2,2,6))) = hsr1.M_SERIE
left join FRT_CSGEN_DBF csgen on loan.M_CSGEN_REF = csgen.M_FIN_ID

where 1 = 1
and hdr.M_NB in (13181651, 13181652)

