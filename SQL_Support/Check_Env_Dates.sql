Select a.TYPE , a.LABEL , a.M_DATE  M_DATE
from (
   Select 'FOD' as TYPE, trim(M_LABEL) as LABEL, M_DATE from MUREX_MX_OWNER.TRN_DSKD_DBF
   union all
   select 'PC' as TYPE, trim(M_LABEL) as LABEL, M_DATE from MUREX_MX_OWNER.TRN_PC_DBF
   union all
   select 'REP' as TYPE, ' ' as LABEL, M_DATE_REP from  MUREX_MX_OWNER.PROCESS#PS_DATE_DBF R
   union all
   select 'PLCC' as TYPE, trim(M_LABEL) as LABEL, M_DATE from MUREX_MX_OWNER.TRN_PLCC_DBF
   union all
   select 'CE' as TYPE, trim(M_LABEL) as LABEL, M_PCG_DATE from MUREX_MX_OWNER.TRN_ENTD_DBF
   union all
   select 'ACC' as TYPE, trim(M_LABEL) as LABEL , M_ACC_DATE from MUREX_MX_OWNER.TRN_ENTD_DBF
) a order by M_Date asc;