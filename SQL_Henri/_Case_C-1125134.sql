
select 
trn.M_NB TRN, 
rtrim(plin.M_DSP_LABEL) PLIN,
rtrim(mat.M_LABEL) MAT,
to_char(mat.M_QT_END,'YYYY-MM-DD') QOTLST,
to_char(mat.M_ST_START,'YYYY-MM-DD') DLVFST,
to_char(mat.M_ST_END,'YYYY-MM-DD') DLVLST,
to_char(trn.M_TRN_EXP,'YYYY-MM-DD') EXP,
to_char(loan.M_MATURITY0,'YYYY-MM-DD') LOANMT0,
to_char(dlv.M_CALC_FST,'YYYY-MM-DD') CLCFST,
to_char(dlv.M_CALC_LST,'YYYY-MM-DD') CLCLST

from TRN_HDR_DBF trn
left join TRN_PLIN_DBF plin on rtrim(trn.M_INSTRUMENT) = rtrim(plin.M_REFERENCE)
left join CMT_PLKEY1_DBF plk on trim(trn.M_PL_KEY1) = to_char(plk.M_REFERENCE)
left join CM_FUT_DBF fut on plk.M_FUTURE = fut.M_REFERENCE
left join CMC_MGEN_DBF mgen on (fut.M_CM_INSTR = mgen.M_REFERENCE and fut.M_LISTED in (1,2,16,32) and fut.M_INS_MODE = 1)
left join RT_INDEX_DBF ind on mgen.M_INDEX = ind.M_INDEX
left join CM_FMAT1_DBF mat on plk.M_FUT_MAT = mat.M_REFERENCE
left join RT_LOAN_DBF loan on trn.M_NB = loan.M_NB
left join CMT_DLV_DBF dlv on trn.M_NB = dlv.M_NB

where 1 = 1
and trn.M_TRN_STATUS <>'DEAD'
and trn.M_TRN_GTYPE in (100, 102)
--and mat.M_QT_END <> loan.M_MATURITY0
and trn.M_TRN_EXP <> loan.M_MATURITY0
and fut.M_INS_MODE = 1
and ind.M_RESET = 0

