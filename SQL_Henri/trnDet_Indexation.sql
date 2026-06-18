select
loan.M_NB TRN,
rtrim(ins.M_INSTR) INS,
rtrim(ind0.M_IND_LAB) IND0,
rtrim(gen.M_CURRENCY0) CUR0,
rtrim(indx.M_IND_LAB) NDX,
rtrim(indx.M_CURR1)||'/'||rtrim(indx.M_CURR2) NDXFX,
ndx.M_FACTOR NDXFCT, ndx.M_MARGIN NDXMRG,
loan.M_RATE_MARG0 MRG0,
rtrim(ind1.M_IND_LAB) IND1,
rtrim(gen.M_CURRENCY1) CUR1,
loan.M_RATE_MARG1 MRG1

from RT_LOAN_DBF loan
left join RT_INSGN_DBF ins on loan.M_GEN_NUM = ins.M_GEN_NUM
left join RT_LNGN_DBF gen on loan.M_GEN_NUM = gen.M_GEN_NUM
left join RT_INDEX_DBF ind0 on gen.M_INDEX0 = ind0.M_INDEX
left join RT_INDEX_DBF ind1 on gen.M_INDEX1 = ind1.M_INDEX
left join RT_LN_INDEXATION_DBF lnx on loan.M_NB = lnx.M_NB
left join RT_INDEXATION_DBF ndx on lnx.M_REF_INDEXATION = ndx.M_REFERENCE
left join RT_LNDXG_DBF tmx on ndx.M_REF_INDEXATION_TEMPL = tmx.M_REFERENCE
left join RT_INDEX_DBF indx on tmx.M_INDEX = indx.M_INDEX

where loan.M_NB = 14077680