select distinct
-- traf.ID, traf.GID, 
reppl.M_TP_GID MXGID, reppl.M_NB TRN,
rtrim(und.M_IND_LAB) UND, rtrim(cmf.M_LABEL) FUT,
-- reppl.M_TP_PFOLIO PFL, 
reppl.M_TP_BUY DIR,
traf.QTYTON TR_QTY,
reppl.M_TP_LQTYS2 MX_QTY,
to_char(traf.EXPIRY,'YYYYMMDD') TR_EXP,
-- to_char(traf.EXPIRY,'YYYYMMDD') MX_EXP,
to_char(traf.PROMPT,'YYYYMMDD') TR_PMPDAT,
-- to_char(bk0.M_XPRMPT,'YYYYMMDD') MX_PMPDAT,
traf.PNL TR_PNL, 
reppl.M_PL_NEPL2 PL_NEPL,
(traf.TRADE_AT * traf.QTYTON) TR_PRM,
-- reppl.M_PL_PC_FIN2 MX_PC_FIN,
reppl.M_PL_PC_NFI2 MX_PC_NFI,
-- reppl.M_PL_FP_FIN2 PL_FP_FIN,
traf.VALUETOT TR_VAL,
reppl.M_PL_MV_FIN2 MX_MV_FIN,

(traf.VALUETOT - reppl.M_PL_MV_FIN2) DIF_MV_TOT,
abs(round((((traf.VALUETOT - reppl.M_PL_MV_FIN2)/traf.VALUETOT)*100),2)) DIF_MV_PCT

from MUREX_MX_OWNER.TRAF_BPOTRN traf
left join MUREX_DM_OWNER.TRAF_TDLPTE_REP reppl on traf.GID = rtrim(reppl.M_TP_GID)
left join MUREX_MX_OWNER.RTBLOCK#RTBKSKL_DBF skl on reppl.M_NB = skl.M_INT_NB
left join MUREX_MX_OWNER.RTBLOCK#RTBK0_DBF bk0 on skl.M_BK_INT_N = bk0.M_INT_NB
left join MUREX_MX_OWNER.RTBLOCK#RTBK1_DBF bk1 on bk0.M_LINK = bk1.M_LINK
left join MUREX_MX_OWNER.TRN_HDR_DBF trn on reppl.M_NB = trn.M_NB
left join MUREX_MX_OWNER.CMT_PLKEY1_DBF plkey on trim(trn.M_PL_KEY1) = to_char(plkey.M_REFERENCE)
left join MUREX_MX_OWNER.RT_INDEX_DBF und on plkey.M_RT_UNDL = und.M_INDEX
left join MUREX_MX_OWNER.CM_INDEX_DBF cmi on plkey.M_UNDL = cmi.M_REFERENCE
left join MUREX_MX_OWNER.CM_FUT_DBF cmf on rtrim(cmi.M_LABEL) = rtrim(cmf.M_LABEL)  

where reppl.M_TP_BUY = 'B' and rtrim(cmf.M_LABEL) not in ('AG LBMA')

order by UND, MXGID