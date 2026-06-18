select 
rtrim(fxc.M_TYPE)    TYP, 
rtrim(fxc.M_LABEL)   CONTRACT, 
rtrim(fxc.M_MARKET)  MARKET,
rtrim(mkt.M_NAME)    MKTDES,
rtrim(fxc.M_OTC_CNT) UNDCNT,
fxc.M_CNTSIZE0       LOTSIZ,
fxc.M_UNDERLNG       UND,
fxc.M_BASE           BAS,
-- rtrim(cat.M_LABEL) CAT,
case fxc.M_CASH_SETTL
when 0 then 'Delivery'
when 1 then 'Cash' else null end STLMOD,
rtrim(M_CALENDAR0) CAL, 
rtrim(M_MATSET)    MATSET,
rtrim(fxc.M_QUOTMODE0) QOTMOD, 
fxc.M_SPOT_FF0 SPTFCT_UB, 
fxc.M_SWAP_FF0 SWPFCT_UB,
fxc.M_SPOT_FF1 SPTFCT_BU, 
fxc.M_SWAP_FF1 SWPFCT_BU,
fxc.M_CNT_ACTIVE ACTIV

from FX_CNT_DBF fxc
left join FXCAT_CNT_DBF cat on fxc.M_CATEGORY = cat.M_REFERENCE
left join MARKET_DBF mkt on rtrim(fxc.M_MARKET) = rtrim(mkt.M_LABEL)

where rtrim(fxc.M_TYPE) = 'OMFUT'

order by fxc.M_TYPE desc, fxc.M_LABEL