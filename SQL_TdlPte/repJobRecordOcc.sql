select 
job.M_IDJOB JOB, rtrim(job.M_TAGDATA) TAG, count(*) OCC
from MUREX_DM_OWNER.TRAF_TDLPTE_REP rep
left join MUREX_MX_OWNER.ACT_JOBDAP_DBF job on rep.M_MX_REF_JOB = job.M_IDJOB 
group by job.M_IDJOB, job.M_TAGDATA 
order by JOB desc