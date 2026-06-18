/* 
== PFL
RMPR CUHAP NIND, 3212

Iron Ore    , 2313, 72
Copper (RM) , 2213, 60

== Consumption ==

select rtrim(M_BSECTION), count(*)
from TRN_HDR_DBF
where 1 = 1
and rtrim(M_BSECTION) = '2313' 
and rtrim(M_BPFOLIO)  = 'RMPR CUHAP NIND'
group by M_BSECTION;

select rtrim(M_SSECTION), count(*)
from TRN_HDR_DBF
where 1 = 1
and rtrim(M_SSECTION) = '2313' 
and rtrim(M_SPFOLIO)  = 'RMPR CUHAP NIND'
group by M_SSECTION;

select rtrim(M_ACC_SECT), COUNT(*)
from DLV_CASH_DBF 
where 1 = 1
and rtrim(M_ACC_SECT) = '2313'
and rtrim(M_PORTFOLIO) in (3212)
group by M_ACC_SECT;

select M_ACC_SEC, count(*)
from ACG_ENTRY_DBF
where 1 = 1 
and rtrim(M_ACC_SEC) = 72
group by M_ACC_SEC

select M_NB, rtrim(M_BSECTION), rtrim(M_SSECTION)
from TRN_HDR_DBF
where 1 = 1
and (rtrim(M_SSECTION) = '2313' or rtrim(M_BSECTION) = '2313')
and (
rtrim(M_BPFOLIO) = 'RMPR CUHAP NIND' or 
rtrim(M_SPFOLIO) = 'RMPR CUHAP NIND'
);

select
acc.M_NB      ACC,
acc.M_NB_BS   ACCDIR,
acc.M_ACC_SEC ACCSEC,
trn.M_NB      TRN,
trn.M_COMMENT_BS TRNDIR,
trn.M_BPFOLIO    PFLBUY,
trn.M_BSECTION   SECBUY,
trn.M_SPFOLIO    PFLSEL,
trn.M_SSECTION   SECSEL

from ACG_ENTRY_DBF acc
left join TRN_HDR_DBF trn on acc.M_NB_TRN = trn.M_NB
where M_NB_TRN in
(
44462035,
44535011,
44567759,
44690670,
44725949,
44725833,
45350178,
49818461,
49819941
)


== Clean-up ==
*/
-- ACC
-- will have to happen manually base on above queries
update ACG_ENTRY_DBF set M_ACC_SEC = 60 
where 1 = 1
and M_ACC_SEC = 72
and M_NB in
(

)
-- CASH
update DLV_CASH_DBF set M_ACC_SECT = '2213' 
where 1 = 1 
and rtrim(M_ACC_SECT) = '2313'
and rtrim(M_PORTFOLIO) in (3212);

-- HDR, BSECTION
update TRN_HDR_DBF set M_BSECTION = '2213' 
where 1 = 1 
and rtrim(M_BSECTION) = '2313'
and rtrim(M_BPFOLIO)  = 'RMPR CUHAP NIND';

-- HDR, SSECTION
update TRN_HDR_DBF set M_SSECTION = '2213'
where 1 = 1 
and rtrim(M_SSECTION) = '2313'
and rtrim(M_SPFOLIO)  = 'RMPR CUHAP NIND';
