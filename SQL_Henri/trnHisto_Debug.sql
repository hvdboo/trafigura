select 
case loan.M_GEN_NUM
when 4331 then 'Swap'
when 3982 then 'Unpriced'
when 4339 then 'FX Avg' else null end TYPO,
loan.M_NB TRN, 
to_char(loan.M_START_DAT0,'YYYYMMDD') DAT_FST, loan.M_MAT_LAB TEN,
trn.M_TRN_STATUS STAT, 
case trn.M_MOP_LAST
when  0 then ''
when  7 then 'Cancel'
when 50 then 'Fixing'
when 57 then 'Execution' else null end EVT_LST

from RT_LOAN_DBF loan
left join TRN_HDR_DBF trn on loan.M_NB = trn.M_NB
where 
M_GEN_NUM in (3982, 4331, 4339)
and to_char(loan.M_START_DAT0,'YYYYMMDD') > '20190331'
and to_char(loan.M_START_DAT0,'YYYYMMDD') < '20190501'

order by TYPO, EVT_LST, TRN