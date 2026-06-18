select distinct
tfgper.ID, 
tfgtrn.GID, tfgper.PER_ID,
trn.M_GID MXGID, trn.M_NB TRN,
rtrim(ind.M_IND_LAB) IND,
rtrim(und.M_IND_LAB) UND, 
rtrim(cmf.M_LABEL) FUT,
plrep.M_TP_PFOLIO PFL, plrep.M_TP_BUY DIR,
tfgtrn.CP, trn.M_BRW_CP,
-- Expiry --
to_char(tfgtrn.EXPIRY,'YYYY-MM-DD') TR_EXP,
to_char(bk0.M_XEXPIRY,'YYYY-MM-DD') MX_EXP,
(tfgtrn.EXPIRY - bk0.M_XEXPIRY) DIF_EXP,
-- Prompt --
to_char(tfgtrn.PROMPT,'YYYY-MM-DD') TR_PMPDAT,
-- to_char(bk0.M_XPRMPT,'YYYY-MM-DD') MX_PMPDAT,
(tfgtrn.PROMPT - bk0.M_XPRMPT) DIF_PMPDAT,
-- Windows --
-- tfgper.ID PER,
-- bk1.M_IDENTITY,
to_char(tfgper.PER_FST,'YYYY-MM-DD') TR_PERFST, 
to_char(bk1.M_XPSTART,'YYYY-MM-DD') MX_PERFST,
(tfgper.PER_FST - bk1.M_XPSTART) DIF_PERFST,
to_char(tfgper.PER_LST,'YYYY-MM-DD') TR_PERLST,
to_char(bk1.M_XPEND,'YYYY-MM-DD') MX_PERLST,
(tfgper.PER_LST - bk1.M_XPEND) DIF_PERLST,
-- Quantity --
tfgtrn.QTYLOT TR_NOM,
trn.M_BRW_NOM1 MX_NOM,
(tfgtrn.QTYTON - trn.M_BRW_NOM1) DIF_NOM,
-- Premium --
tfgtrn.TRADE_AT TR_PRM,
round(loan.M_STL_PRM,2) MX_PRM,
(tfgtrn.TRADE_AT - round(loan.M_STL_PRM,2)) DIF_PRM,
-- Prompt price --
-- tfgtrn.PROMPTPRC TR_PMPPRC,
-- round (pmpprc.RATE,2) MX_PMPPRC,
-- (tfgtrn.PROMPTPRC - round (pmpprc.RATE,2)) DIF_PMPPRC,
-- round(crv1.M_PRC_RF1,2) MX_PMPPRC,
-- Window price --
-- tfgtrn.WDWOPTPRC TR_OPTPRC,
-- round(perprc.RATE,2) MX_PERPRC,
-- (tfgtrn.WDWOPTPRC - perprc.RATE) DIF_PERPRC,
-- Vol bump --
round(tfgtrn.VOLBUMP,4) TR_VOLBMP,
round(bk0.M_XVSHIFT,4) MX_VOLBMP,
round((tfgtrn.VOLBUMP - bk0.M_XVSHIFT),4) DIFFBMP

from MUREX_MX_OWNER.TRAF_BPOPER tfgper
left join MUREX_MX_OWNER.TRAF_BPOTRN tfgtrn on tfgper.GID = tfgtrn.GID
left join MUREX_MX_OWNER.TRN_HDR_DBF trn on tfgtrn.GID = rtrim(trn.M_GID)
left join MUREX_MX_OWNER.RTBLOCK#RTBKSKL_DBF skl on trn.M_NB = skl.M_INT_NB
left join MUREX_MX_OWNER.RTBLOCK#RTBK0_DBF bk0 on skl.M_BK_INT_N = bk0.M_INT_NB
left join MUREX_MX_OWNER.RTBLOCK#RTBK1_DBF bk1 on (bk0.M_LINK = bk1.M_LINK and tfgper.PER_FST = bk1.M_XPSTART)
left join MUREX_MX_OWNER.RT_LOAN_DBF loan on trn.M_NB = loan.M_NB
left join MUREX_MX_OWNER.CMT_PLKEY1_DBF plkey on trim(trn.M_PL_KEY1) = to_char(plkey.M_REFERENCE)
left join MUREX_MX_OWNER.RT_INDEX_DBF ind on plkey.M_INDEX = ind.M_INDEX
left join MUREX_MX_OWNER.RT_INDEX_DBF und on plkey.M_RT_UNDL = und.M_INDEX
left join MUREX_MX_OWNER.CM_INDEX_DBF cmi on plkey.M_UNDL = cmi.M_REFERENCE
left join MUREX_MX_OWNER.CM_FUT_DBF cmf on rtrim(cmi.M_LABEL) = rtrim(cmf.M_LABEL)
/*
left join CM_FMAT1_DBF pilsht on (to_char(bk0.M_XPRMPT,'YYYYMMDD') = to_char(pilsht.M_ST_END,'YYYYMMDD') and cmf.M_FUT_MAT = pilsht.M_FMAT_ID)
left join CM_FMAT1_DBF pillgt on (to_char(bk0.M_XPRMPT,'YYYYMM') = to_char(pillgt.M_ST_END,'YYYYMM') and cmf.M_FUT_MAT = pillgt.M_FMAT_ID)
left join CMK_FUTP_DBF crv1 on (cmf.M_REFERENCE = crv1.M_FUTURE 
and pilsht.M_REFERENCE = crv1.M_MAT_CODE 
and to_char(crv1.M__DATE_,'YYYYMMDD')='20171127' and crv1.M__ALIAS_ ='RT')
*/
-- left join TRAF_BPOPRC pmpprc on to_char(tfgtrn.PROMPTDAT,'YYYYMMDD') = to_char(pmpprc.LST,'YYYYMMDD') and pmpprc.IND = rtrim(und.M_IND_LAB)
-- left join TRAF_BPOPRC perprc on to_char(bk1.M_XPSTART,'YYYYMMDD') = to_char(perprc.FST,'YYYYMMDD') and to_char(bk1.M_XPEND,'YYYYMMDD') = to_char(perprc.LST,'YYYYMMDD') and perprc.IND = rtrim(ind.M_IND_LAB)
left join MUREX_DM_OWNER.TRAF_TDLPTE_REP plrep on tfgtrn.GID = rtrim(plrep.M_TP_GID)

where trn.M_TRN_STATUS <> 'DEAD'
--and plrep.M_TP_BUY = 'B'
/*
and trn.M_BPFOLIO in 
(
'RMOP APE PTEI',
'RMOP BLE PTEI',
'RMOP BWR PTEI',
'RMOP NSA PTEI',
'RMOP NSA TICI',
'RMOT JBA PTEI' 
)

group by 
traf.ID, traf.GID, 
plrep.M_TP_GID, plrep.M_NB,
rtrim(und.M_IND_LAB), rtrim(cmf.M_LABEL),
plrep.M_TP_PFOLIO, mx.M_TP_BUY
*/

order by tfgtrn.GID, tfgper.PER_ID