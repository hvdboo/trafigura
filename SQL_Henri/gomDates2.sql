
select a.TYP, a.LAB, a.M_DATE
from
(
select 'FOD'  TYP, trim(M_LABEL) LAB, M_DATE from TRN_DSKD_DBF
union all
select 'PC'   TYP, trim(M_LABEL) LAB, M_DATE from TRN_PC_DBF
union all
select 'REP'  TYP, '' LAB           , M_DATE_REP from PROCESS#PS_DATE_DBF
union all
select 'PLCC' TYP, trim(M_LABEL) LAB, M_DATE from TRN_PLCC_DBF
union all
select 'CE'   TYP, trim(M_LABEL) LAB, M_PCG_DATE from TRN_ENTD_DBF
union all
select 'ACC'  TYP, trim(M_LABEL) LAB, M_ACC_DATE from TRN_ENTD_DBF
) a

order by a.M_DATE ASC;
