/* 
== Guilty Accounting sections ==

select * from TRN_ACSC_DBF

REF| LABEL| DESC => Target
12 | 1112 | Bitumen          => 1130 ( 25, Other (Oil)) or 1412 (114, Puma Bitumen)                                                                                             
13 | 1113 | Chemicals (Oil)  => 1121 (127, Petchem)
50 | 2112 | Chemical (Conc)  => 1121 (127, Petchem)
94 | 2912 | Impala Colombia  => 2914 ( 96, Impala Colombia)

== Consumption ==

select rtrim(M_BSECTION), count(*)
from TRN_HDR_DBF
where rtrim(M_BSECTION) = '2912'
group by M_BSECTION

select rtrim(M_SSECTION), count(*)
from TRN_HDR_DBF
where rtrim(M_SSECTION) = '2912'
group by M_SSECTION

select rtrim(M_ACC_SECT), COUNT(*)
from DLV_CASH_DBF 
where rtrim(M_ACC_SECT) = '2912'
group by M_ACC_SECT

select M_ACC_SEC, count(*)
from ACG_ENTRY_DBF
where rtrim(M_ACC_SEC) = 94
group by M_ACC_SEC

== Clean-up ==
*/

update ACG_ENTRY_DBF set M_ACC_SEC = 96 where M_ACC_SEC = 94;
update DLV_CASH_DBF  set M_ACC_SECT = '2914' where rtrim(M_ACC_SECT) = '2912';
update TRN_HDR_DBF   set M_BSECTION = '2914' where rtrim(M_BSECTION) = '2912';
update TRN_HDR_DBF   set M_SSECTION = '2914' where rtrim(M_SSECTION) = '2912'; 