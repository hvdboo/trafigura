/* 
== PFL
RMPR AGHAP HAID, 3166
RMPR AGHAP LYKD, 3110
RMPR AGHAP TTHD, 2116
RMTS AGPAP HAID, 3138
RMTS AGPAP TTHD, 2117

Aluminium (RM), 2211, 58
Silver (RM)   , 2216, 63

== Consumption ==

select rtrim(M_BSECTION), count(*)
from TRN_HDR_DBF
where 1 = 1
and rtrim(M_BSECTION) = '2211' 
and rtrim(M_BPFOLIO) in
(
'RMPR AGHAP HAID',
'RMPR AGHAP LYKD',
'RMPR AGHAP TTHD',
'RMTS AGPAP HAID',
'RMTS AGPAP TTHD'
)
group by M_BSECTION;

select rtrim(M_SSECTION), count(*)
from TRN_HDR_DBF
where 1 = 1
and rtrim(M_SSECTION) = '2211' 
and rtrim(M_SPFOLIO) in
(
'RMPR AGHAP HAID',
'RMPR AGHAP LYKD',
'RMPR AGHAP TTHD',
'RMTS AGPAP HAID',
'RMTS AGPAP TTHD'
)
group by M_SSECTION;

select rtrim(M_ACC_SECT), COUNT(*)
from DLV_CASH_DBF 
where 1 = 1
and rtrim(M_ACC_SECT) = '2211'
and rtrim(M_PORTFOLIO) in (3166, 3110, 2116, 3138, 2117)
group by M_ACC_SECT;

select M_ACC_SEC, count(*)
from ACG_ENTRY_DBF
where 1 = 1 
and rtrim(M_ACC_SEC) = 58
and 
group by M_ACC_SEC

select M_NB, rtrim(M_BSECTION), rtrim(M_SSECTION)
from TRN_HDR_DBF
where 1 = 1
and (rtrim(M_SSECTION) = '2211' or rtrim(M_BSECTION) = '2211')
and (rtrim(M_BPFOLIO) in
(
'RMPR AGHAP HAID',
'RMPR AGHAP LYKD',
'RMPR AGHAP TTHD',
'RMTS AGPAP HAID',
'RMTS AGPAP TTHD'
)

or

rtrim(M_SPFOLIO) in
(
'RMPR AGHAP HAID',
'RMPR AGHAP LYKD',
'RMPR AGHAP TTHD',
'RMTS AGPAP HAID',
'RMTS AGPAP TTHD'
)
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
where M_NB_TRN = 44462035;


== Clean-up ==
*/
-- ACC
update ACG_ENTRY_DBF set M_ACC_SEC = 63 
where 1 = 1 
and M_ACC_SEC = 58
and -- will have to happen manually base on above queries

-- CASH
update DLV_CASH_DBF set M_ACC_SECT = '2216' 
where 1 = 1 
and rtrim(M_ACC_SECT) = '2211'
and rtrim(M_PORTFOLIO) in (3166, 3110, 2116, 3138, 2117);

-- HDR, BSECTION
update TRN_HDR_DBF set M_BSECTION = '2216' 
where 1 = 1 
and rtrim(M_BSECTION) = '2211'
and rtrim(M_BPFOLIO) in
(
'RMPR AGHAP HAID',
'RMPR AGHAP LYKD',
'RMPR AGHAP TTHD',
'RMTS AGPAP HAID',
'RMTS AGPAP TTHD'
);

-- HDR, SSECTION
update TRN_HDR_DBF set M_SSECTION = '2216'
where 1 = 1 
and rtrim(M_SSECTION) = '2211'
and rtrim(M_SPFOLIO) in
(
'RMPR AGHAP HAID',
'RMPR AGHAP LYKD',
'RMPR AGHAP TTHD',
'RMTS AGPAP HAID',
'RMTS AGPAP TTHD'
);







