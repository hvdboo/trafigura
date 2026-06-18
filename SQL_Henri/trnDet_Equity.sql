select 
trn.M_NB TRN,
trn.M_TRN_GTYPE FGT,
trn.M_TRN_FMLY FML, trn.M_TRN_GRP GRP, trn.M_TRN_TYPE TYP,
rtrim(typo.M_LABEL) TYPO,
rtrim(pli.M_DSP_LABEL) PLI,
rtrim(trn.M_MKT_LABEL) SECMKT,
rtrim(seh.M_SE_D_LABEL) SEC,
rtrim(mat.M_LABEL) MAT,
to_char(trn.M_TRN_EXP,'YYYY-MM-DD') EXP,
rtrim(fut.M_FU_MARKET) UNDMKT,
rtrim(und.M_SE_D_LABEL) UND,
trn.M_BRW_RTE1 PRC,
secmkb.M_BID SEC_BID,
secmkb.M_ASK SEC_ASK,
-- undmkb.M_BID UND_BID,
-- undmkb.M_ASK UND_ASK
case trn.M_COMMENT_BS when 'B' then 'Buy' when 'S' then 'Sell' else null end DIR, 
trn.M_BRW_NOM1 NOM,
ser.M_SE_SEC_LS0 LOTSIZ,
(trn.M_BRW_NOM1 * ser.M_SE_SEC_LS0) QTY

from TRN_HDR_DBF trn
left join TRN_PC_DBF pc on 1 = 1
left join CONTRACT_DBF cnt on trn.M_CONTRACT = cnt.M_REFERENCE
left join TYPOLOGY_DBF typo on cnt.M_TYPOLOGY = typo.M_REFERENCE
left join TRN_PLIN_DBF pli on rtrim(trn.M_INSTRUMENT) = rtrim(pli.M_REFERENCE)
left join SE_HEAD_DBF seh on rtrim(trn.M_RSKSECTION) = rtrim(seh.M_SE_LABEL)
left join OM_MAT_DBF mat on rtrim(substr(trn.M_PL_KEY1,16,8)) = to_char(mat.M_CODE)
left join SE_ROOT_DBF ser on seh.M_SE_LABEL = ser.M_SE_LABEL 
left join SE_MKTOP_DBF mop on seh.M_SE_LABEL = mop.M_SE_LABEL
left join FU_FUT_DBF fut on mop.M_SE_INUM = fut.M_FU_INUM
left join SE_HEAD_DBF und on fut.M_FU_UNDERL = und.M_SE_LABEL
-- Market data
left join MPX_PRIC_DBF secmkh on rtrim(seh.M_SE_LABEL) = rtrim(secmkh.M_INSTRUM) and rtrim(secmkh.M__ALIAS_) = 'RT' and secmkh.M__DATE_ = pc.M_DATE
left join MPY_PRIC_DBF secmkb on secmkh.M__INDEX_ = secmkb.M__INDEX_ and mat.M_CODE = secmkb.M_MATCOD
left join MPX_PRIC_DBF undmkh on rtrim(und.M_SE_D_LABEL) = rtrim(undmkh.M_INSTRUM) and rtrim(undmkh.M__ALIAS_) = 'RT' and undmkh.M__DATE_ = pc.M_DATE
left join MPY_PRIC_DBF undmkb on undmkh.M__INDEX_ = undmkb.M__INDEX_

where 1 = 1
and M_TRN_FMLY = 'EQD' 
and M_TRN_STATUS <> 'DEAD'

order by EXP, TRN