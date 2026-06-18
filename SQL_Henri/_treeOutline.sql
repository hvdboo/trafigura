update EDFM_TREB tre set tre.OUTL = (select 
par.OUTL||
case when tre.ORD < 10 then concat('0',to_char(tre.ORD)) else to_char(tre.ORD) end||
'.'
from EDFM_TREB par where tre.PAR = par.ID and tre.TRE = 7 and par.RNK = 0)
where exists (
select 1 from EDFM_TREB par where tre.PAR = par.ID and tre.TRE = 7 and par.RNK = 0);


update EDFM_TREB tre set tre.OUTL = trim(tre.OUTL);