select 
rtrim(fxc.M_TYPE)   TYP, 
rtrim(fxc.M_LABEL)  CONTRACT, 
rtrim(fxc.M_MARKET) MARKET,
rtrim(mkt.M_NAME)   MKTDES,
fxc.M_BASE      BASE, 
fxc.M_UNDERLNG  UNDERL,
fxc.M_QUOTMODE0 QOTMODE, 
case fxc.M_CRSS_SWP
when 0 then 'No'
when 1 then 'Fix BAS disc'
when 2 then 'Fix UND disc' else null end CRSW_MOD,
-- rtrim(cat.M_LABEL) CAT,
case fxc.M_FXD_SETTL
when 0 then 'Delivery'
when 1 then 'Cash' else null end STL_MOD,
fxc.M_SETTL_CUR  STL_CUR,
fxc.M_CNT_ACTIVE ACTIV,
rtrim(M_CALENDAR0) SPOTDLV_CAL, 
rtrim(M_CALENDAR1) DATVAL_CAL,
rtrim(M_SP_SCHED0) FWD_SHF, 
rtrim(M_SP_SCHED1) BCK_SHF,
fxc.M_SPOT_FF0 SPTFCT_UB, 
fxc.M_SWAP_FF0 SWPFCT_UB,
fxc.M_SPOT_FF1 SPTFCT_BU, 
fxc.M_SWAP_FF1 SWPFCT_BU

from FX_CNT_DBF fxc
left join FXCAT_CNT_DBF cat on fxc.M_CATEGORY = cat.M_REFERENCE
left join MARKET_DBF mkt on rtrim(fxc.M_MARKET) = rtrim(mkt.M_LABEL)

where rtrim(fxc.M_TYPE) = 'OTC'

order by fxc.M_TYPE desc, fxc.M_LABEL