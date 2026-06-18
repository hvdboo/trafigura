select 
'Commodity future' UNIT, 
cmfut.M__ALIAS_ MDS, substr(max(cmfut.M__DATE_),1,10) DAT
from CMK_FUTP_DBF cmfut
group by cmfut.M__ALIAS_

union

select 
'FX Spot' UNIT, 
fxs.M__ALIAS_ MDS, substr(max(fxs.M__DATE_),1,10) DAT
from MPX_PRIC_DBF fxs
group by fxs.M__ALIAS_

union

select 
'Rates' UNIT, 
ir.M__ALIAS_ MDS, substr(max(ir.M__DATE_),1,10) DAT
from MPX_PRIC_DBF ir
group by ir.M__ALIAS_