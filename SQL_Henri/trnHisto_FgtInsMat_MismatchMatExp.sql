select 
to_char(pc.M_DATE,'YYYY-MM-DD') SYSDAT,
trn.M_TRN_FMLY FML, trn.M_TRN_GRP GRP, trn.M_TRN_TYPE TYP, 
-- trn.M_TRN_GTYPE FGTN,
rtrim(plin.M_DSP_LABEL) INSTRUMENT, 
trn.M_PL_INSCUR PL_CUR,
rtrim(trn.M_BRW_ODPL) TRN_MAT,
to_char(trn.M_TRN_EXP,'YYYY-MM-DD') TRN_EXP,
-- plk.M_FUT_MAT,
rtrim(mat.M_LABEL) MAT_LAB,
to_char(mat.M_QT_END,'YYYY-MM-DD') QOTL,
to_char(mat.M_ST_START,'YYYY-MM-DD') DLVF,
to_char(mat.M_ST_END,'YYYY-MM-DD') DLVL,
rtrim(matset.M_LABEL) MATSET

from TRN_HDR_DBF trn
left join TRN_PC_DBF pc on 1 = 1
left join TRN_PLIN_DBF plin on trn.M_INSTRUMENT = plin.M_REFERENCE
left join CMT_PLKEY1_DBF plk on trim(M_PL_KEY1) = to_char(plk.M_REFERENCE)
left join CM_FMAT1_DBF mat on plk.M_FUT_MAT = mat.M_REFERENCE
left join CM_FMAT_DBF matset on mat.M_FMAT_ID = matset.M_REFERENCE
left join CM_FUT_DBF fut on matset.M_REFERENCE = fut.M_FUT_MAT 

where 
trn.M_TRN_GTYPE in (100, 101, 102, 103, 113, 136, 146, 154) 
-- and trn.M_TRN_STATUS <> 'DEAD'
-- and rtrim(plin.M_DSP_LABEL) = 'CO CSSE'
-- and to_char(trn.M_TRN_EXP,'YYYY-MM-DD') <> to_char(mat.M_ST_START,'YYYY-MM-DD')
and to_char(trn.M_TRN_EXP,'YYYY-MM-DD') > '2013-12-20'
and to_char(trn.M_TRN_EXP,'YYYY-MM-DD') < '2013-12-30'

order by FML, GRP, TYP, INSTRUMENT, TRN_EXP, TRN_MAT