select 
loan.M_NB TRN,
loan.M_CUSTOM CUS,
loan.M_NB_MODIF NBMOD,
ins.M_GEN_NUM GENNUM,
rtrim(ins.M_INSTR) INSLAB,
ins.M_CREAT_MODE INSCREA,
tmp.M_GEN_NUM TMPNUM,
rtrim(tmp.M_INSTR) TMPLAB

from RT_LOAN_DBF loan
left join TRN_HDR_DBF trn on loan.M_NB = trn.M_NB
left join RT_INSGN_DBF ins on loan.M_GEN_NUM = ins.M_GEN_NUM
left join RT_INSGN_DBF tmp on ins.M_TEMPL_NUM = tmp.M_GEN_NUM

where 1 = 1
and trn.M_TRN_GTYPE = 1
and trn.M_TRN_STATUS <> 'DEAD'