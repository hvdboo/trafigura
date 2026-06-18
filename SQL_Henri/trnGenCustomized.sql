select 
ndx.M_REFERENCE NDX, 
ndxtpl.M_REFERENCE NDXTPL,
rtrim(ndxind.M_IND_LAB)  NDXIND,
rtrim(ndxind.M_FX_GROUP) NDXPUB,
rtrim(ndxind.M_COL_CODE) NDXHSR,
rtrim(ndxind.M_HISFILE) NDXHIS,
ndx.M_FACTOR NDXFCT, ndx.M_MARGIN NDXMRG, 
ndx.M_P_FACTOR PRCFCT, ndx.M_P_MARGIN PRCMRG,
loan.M_NB TRN, 
rtrim(insf.M_INSTR_DESC) INS,
to_char(trn.M_TRN_EXP,'YYYY-MM-DD') EXP,
gen.M_GEN_NUM GEN, ins.M_CREAT_MODE, ins.M_TEMPL_NUM

from RT_INDEXATION_DBF ndx
left join RT_LN_INDEXATION_DBF lnndx on ndx.M_REFERENCE = lnndx.M_REF_INDEXATION
left join RT_LNDXG_DBF ndxtpl on ndx.M_REF_INDEXATION_TEMPL = ndxtpl.M_REFERENCE
left join RT_INDEX_DBF ndxind on rtrim(ndxtpl.M_INDEX) = rtrim(ndxind.M_INDEX)
left join FX_ARCCT_DBF ndxarc on ( 
rtrim(ndxind.M_FX_GROUP) = rtrim(ndxarc.M_DESC) and
ndxind.M_CURR1 = substr(ndxarc.M_QUOTATION,1,3) and
ndxind.M_CURR2 = substr(ndxarc.M_QUOTATION,5,3))
left join RT_LOAN_DBF loan on lnndx.M_NB = loan.M_NB
left join TRN_HDR_DBF trn on loan.M_NB = trn.M_NB
left join RT_LNGN_DBF gen on loan.M_GEN_NUM = gen.M_GEN_NUM
left join RT_INSGN_DBF ins on gen.M_GEN_NUM = ins.M_GEN_NUM
left join RT_INSGN_DBF insf on ins.M_TEMPL_NUM = insf.M_GEN_NUM

-- where rtrim(ndxind.M_IND_LAB) = 'EUR/USD ECB'
