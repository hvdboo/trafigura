-- Check PFL definition
select M_LAB
from VIW_PFL_DBF
where M_RMDCOD = '2912'

-- Check occurences
select 
trn.M_NB TRN,
rtrim(trn.M_BSECTION) BSEC,
rtrim(trn.M_SSECTION) SSEC

from TRN_HDR_DBF trn
where rtrim(trn.M_BSECTION) = '2912' or rtrim(trn.M_SSECTION) = '2912';

-- Update table 
update TRN_HDR_DBF set M_BSECTION = '2914' where M_BSECTION = '2912';
update TRN_HDR_DBF set M_SSECTION = '2914' where M_SSECTION = '2912';

-- Check update
select distinct M_BSECTION from TRN_HDR_DBF;
select distinct M_SSECTION from TRN_HDR_DBF;