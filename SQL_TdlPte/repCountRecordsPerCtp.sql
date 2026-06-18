select M_MX_REF_JOB, M_TP_CNTRP, count(*)
from TRAF_TDLPTE_REP
group by M_MX_REF_JOB, M_TP_CNTRP

      