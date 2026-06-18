select 
-- opt.M_SE_PTYPE UND,
-- opt.M_SE_GROUP GRP, opt.M_SE_TYPE TYP, opt.M_SE_CATE CAT,
case trc.M_SE_LST_M_C
when 0 then 'Equity'
when 2 then 'Future'
when 3 then 'Cash' else null end UND,
rtrim(opt.M_SE_MARKET) MKT,
rtrim(opt.M_SE_MKT_OPT) CNT, 
rtrim(opt.M_SE_DESC) DES, 
case trc.M_SE_OPT_T
when 0 then 'LST'
when 1 then 'OTC' else null end TYP,
case trc.M_SE_OPT_ST
when 0 then 'American'
when 1 then 'European' else null end STYL,
case trc.M_SE_OPT_SE
when 0 then 'Delivery'
when 1 then 'Cash' else null end STL,
case trc.M_SE_PAR_O
when 0 then 'No'
when 1 then 'Yes' else null end PARITY,
case trc.M_SE_MARG_F
when 0 then 'No'
when 1 then 'Yes' else null end MARGIN,
trc.M_SE_OPT_LS0 LOT,
rtrim(trc.M_SE_LST_MAT) MATSET,
rtrim(trc.M_SE_IDCT) IDCLOSE,
case M_SE_KQUOF
when 0 then 'Inherited'
when 1 then 
case M_SE_KQUO
when 0 then 'Price'
when 1 then 'Yield.conv'
when 2 then 'Cnv.yield'
when 6 then 'Non-cnv.yield' else null end end STKQUOT,
case M_SE_KQUO
when 2 then 
case M_SE_KYT
when 0 then 'Coupon freq'
when 1 then 'Annual'
when 2 then 'Simple' else null end else null end YLDTYP, 
case M_SE_KQUO
when 2 then 
case M_SE_KYC
when 0 then 'Fwd'
when 1 then 'Spot'
when 2 then 'Exr' else null end else null end YLDCNV,
M_SE_STR_STP STKSTEP,
rtrim(trc.M_SE_PR_PA) PRMSTL,
case M_SE_PQUO
when 0 then 'Price'
when 1 then 'Yield'
when 2 then 'Pct' else null end PRMQUOT,
case M_SE_PNOT
when 0 then 'Std'
when 1 then '8th'
when 2 then '16th' 
when 3 then '32h'
when 4 then '64th' 
when 5 then '128th'
when 6 then '256th'
when 131 then '32sp' else null end PRMNOT,
M_SE_PDEC PRMDEC,
case M_SE_PROUND
when 0 then 'None'
when 1 then 'Nearest'
when 2 then 'By default'
when 3 then 'By excess' else null end PRMRND,
case M_SE_CRNDM
when 0 then 'Unitary Premium'
when 1 then 'Total Settlement' else null end CSHMOD,
case M_SE_CROUND
when 0 then 'None'
when 1 then 'Nearest'
when 2 then 'By default'
when 3 then 'By excess' else null end CSHRUL,
M_SE_CDEC CSHDEC,
case M_SE_SRNDM
when 0 then 'None'
when 1 then 'Currency' else null end STLRND,
opt.M_SE_OPT_IN ID
from ${FIN_schema}SE_MKT2_DBF opt
left join ${FIN_schema}SE_TRDO_DBF trc on opt.M_SE_OPT_IN = trc.M_SE_TCO_L
where opt.M_SE_PTYPE = 'EQD'
order by 
opt.M_SE_PTYPE, opt.M_SE_GROUP, opt.M_SE_TYPE, opt.M_SE_CATE,
opt.M_SE_MARKET, M_SE_MKT_OPT
