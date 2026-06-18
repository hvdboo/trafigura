select distinct
-- traf.ID, traf.GID, 
mx.M_TP_GID MXGID, mx.M_NB TRN,
rtrim(und.M_IND_LAB) UND, rtrim(cmf.M_LABEL) FUT,
-- mx.M_TP_PFOLIO PFL, 
mx.M_TP_BUY DIR,
to_char(traf.EXPIRY,'YYYYMMDD') TR_EXP,
-- to_char(traf.EXPIRY,'YYYYMMDD') MX_EXP,
to_char(traf.PROMPTDAT,'YYYYMMDD') TR_PMPDAT,
-- to_char(bk0.M_XPRMPT,'YYYYMMDD') MX_PMPDAT,
traf.DELTALOT TR_DELTA,
grk.DELTA_LOT MX_DELTA,
(traf.DELTALOT-grk.DELTA_LOT) DIF_DELTA,
traf.GAMMALOT TR_GAMMA,
grk.GAMMA_LOT MX_GAMMA,
traf.VEGALOT  TR_VEGA,
grk.VEGA_TOT  MX_VEGA,
traf.THETALOT TR_THETA,
grk.THETA_TOT MX_THETA
from MUREX_MX_OWNER.TRAF_BPO traf
left join MUREX_DM_OWNER.TRAF_TDLPTE_REP mx on traf.GID = rtrim(mx.M_TP_GID)
left join MUREX_MX_OWNER.RTBLOCK#RTBKSKL_DBF skl on mx.M_NB = skl.M_INT_NB
left join MUREX_MX_OWNER.RTBLOCK#RTBK0_DBF bk0 on skl.M_BK_INT_N = bk0.M_INT_NB
left join MUREX_MX_OWNER.RTBLOCK#RTBK1_DBF bk1 on bk0.M_LINK = bk1.M_LINK
left join TRN_HDR_DBF trn on mx.M_NB = trn.M_NB
left join CMT_PLKEY1_DBF plkey on trim(trn.M_PL_KEY1) = to_char(plkey.M_REFERENCE)
left join RT_INDEX_DBF und on plkey.M_RT_UNDL = und.M_INDEX
left join CM_INDEX_DBF cmi on plkey.M_UNDL = cmi.M_REFERENCE
left join CM_FUT_DBF cmf on rtrim(cmi.M_LABEL) = rtrim(cmf.M_LABEL)
left join TRAF_BPO_GRK grk on trn.M_NB = grk.TRN

where mx.M_TP_BUY = 'B' 
-- and abs(traf.DELTALOT-grk.DELTA_LOT) > 1

order by UND, MXGID