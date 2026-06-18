select '1' DIRN, 'Murex report' DIR, t10.M_CREATION CREATION, t10.M_DESC DESCRIPTION,
case t10.M_CLASS_TYPE
when  0 then 'Transaction'
when  1 then 'Accounting'
when  2 then 'Copy creation'
when  3 then 'External'
when  5 then 'Definition report'
when  6 then 'Accounting report' 
when  7 then 'Cash balances' 
when  8 then 'Sim.view' 
when  9 then 'PL Variance'
when 10 then 'Java plugin'  
when 11 then 'Data dictionary' 
when 12 then 'Theta analysis' 
when 13 then 'Value at Risk' 
when 14 then 'PL entry, Simulation' 
when 15 then 'PL entry, Generator' 
when 16 then 'Deliverable, cash vostro' 
when 17 then 'Deliverable, cash nostro' else ' ' end CLASS_TYPE,
t10.M_CLASS CLASS, t10.M_CODE CLASS_MODE, 
case t10.M_CLASS_TYPE
when 8 then t10.M_VIEW else t10.M_DBFALIAS end UND,
t10.M_F_CNSVIEW CNS_FLG, t11.M_FLD_LABEL CNS_FLD, t10.M_F_CNSXFLT CNS_FLT
from DYNDBF1#TRN_DYND_DBF t10
left join DYNDBF1#TRN_DYNF_DBF t11 on t10.M_CREATION = t11.M_CREATION and t11.M_FLD_FSORT = 1
-- where substr(t10.M_DESC,1,4) = 'EDFM'

union all

select '2' DIRN, 'User report' DIR, t20.M_CREATION CREATION, t20.M_DESC DESCRIPTION,
case t20.M_CLASS_TYPE
when  0 then 'Transaction'
when  1 then 'Accounting'
when  2 then 'Copy creation'
when  3 then 'External'
when  5 then 'Definition report'
when  6 then 'Accounting report' 
when  7 then 'Cash balances' 
when  8 then 'Sim.view' 
when  9 then 'PL Variance'
when 10 then 'Java plugin'  
when 11 then 'Data dictionary' 
when 12 then 'Theta analysis' 
when 13 then 'Value at Risk' 
when 14 then 'PL entry, Simulation' 
when 15 then 'PL entry, Generator' 
when 16 then 'Deliverable, cash vostro' 
when 17 then 'Deliverable, cash nostro' else ' ' end CLASS_TYPE,
t20.M_CLASS CLASS, t20.M_CODE CLASS_MODE, 
case t20.M_CLASS_TYPE
when 8 then t20.M_VIEW else t20.M_DBFALIAS end UND,
t20.M_F_CNSVIEW CNS_FLG, t21.M_FLD_LABEL CNS_FLD, t20.M_F_CNSXFLT CNS_FLT
from DYNDBF2#TRN_DYND_DBF t20
left join DYNDBF2#TRN_DYNF_DBF t21 on t20.M_CREATION = t21.M_CREATION and t21.M_FLD_FSORT = 1
-- where substr(t20.M_DESC,1,4) = 'EDFM'

union all

select '3' DIRN,'Murex additional' DIR, t30.M_CREATION CREATION, t30.M_DESC DESCRIPTION,
case t30.M_CLASS_TYPE
when  0 then 'Transaction'
when  1 then 'Accounting'
when  2 then 'Copy creation'
when  3 then 'External'
when  5 then 'Definition report'
when  6 then 'Accounting report' 
when  7 then 'Cash balances' 
when  8 then 'Sim.view' 
when  9 then 'PL Variance'
when 10 then 'Java plugin'  
when 11 then 'Data dictionary' 
when 12 then 'Theta analysis' 
when 13 then 'Value at Risk' 
when 14 then 'PL entry, Simulation' 
when 15 then 'PL entry, Generator' 
when 16 then 'Deliverable, cash vostro' 
when 17 then 'Deliverable, cash nostro' else ' ' end CLASS_TYPE,
t30.M_CLASS CLASS, t30.M_CODE CLASS_MODE, 
case t30.M_CLASS_TYPE
when 8 then t30.M_VIEW else t30.M_DBFALIAS end UND,
t30.M_F_CNSVIEW CNS_FLG, t31.M_FLD_LABEL CNS_FLD, t30.M_F_CNSXFLT CNS_FLT
from DYNDBF3#TRN_DYND_DBF t30
left join DYNDBF3#TRN_DYNF_DBF t31 on t30.M_CREATION = t31.M_CREATION and t31.M_FLD_FSORT = 1
-- where substr(t30.M_DESC,1,4) = 'EDFM'

union all

select '4' DIRN,'User additional' DIR, t40.M_CREATION CREATION, t40.M_DESC DESCRIPTION,
case t40.M_CLASS_TYPE
when  0 then 'Transaction'
when  1 then 'Accounting'
when  2 then 'Copy creation'
when  3 then 'External'
when  5 then 'Definition report'
when  6 then 'Accounting report' 
when  7 then 'Cash balances' 
when  8 then 'Sim.view' 
when  9 then 'PL Variance'
when 10 then 'Java plugin'  
when 11 then 'Data dictionary' 
when 12 then 'Theta analysis'
when 13 then 'Value at Risk'
when 14 then 'PL entry, Simulation' 
when 15 then 'PL entry, Generator' 
when 16 then 'Deliverable, cash vostro' 
when 17 then 'Deliverable, cash nostro' else ' ' end CLASS_TYPE,
t40.M_CLASS CLASS, t40.M_CODE CLASS_MODE, 
case t40.M_CLASS_TYPE
when 8 then t40.M_VIEW else t40.M_DBFALIAS end UND,
t40.M_F_CNSVIEW CNS_FLG, t41.M_FLD_LABEL CNS_FLD, t40.M_F_CNSXFLT CNS_FLT
from DYNDBF4#TRN_DYND_DBF t40
left join DYNDBF4#TRN_DYNF_DBF t41 on t40.M_CREATION = t41.M_CREATION and t41.M_FLD_FSORT = 1
-- where substr(t40.M_DESC,1,4) = 'EDFM'

order by DIRN, CREATION