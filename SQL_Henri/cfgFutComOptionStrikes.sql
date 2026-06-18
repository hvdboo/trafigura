
select distinct
rtrim(fut.M_LABEL) OPT,
rtrim(stkset.M_LABEL) STKSET,
stkval.M_STK_VAL STK

from CM_STK_DBF stkval
left join CM_STKSET_DBF stkset on stkval.M_NB = stkset.M_STKS
left join CMC_QUOT_DBF qot on stkset.M_REFERENCE = qot.M_STRIKES
left join CM_FUT_DBF fut on qot.M_REFERENCE = fut.M_QUOT_FWD

order by OPT, STK