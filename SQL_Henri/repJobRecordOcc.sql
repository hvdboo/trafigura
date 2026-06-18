select 
dapjob.M_IDJOB DAPJOB, 
to_char(dapjob.M_DATE,'YYYY-MM-DD') GENDAT, 
rtrim(dapjob.M_TAGDATA) TAG,
rtrim(job.M_OWNER) OWNER,
job.M_REF_DATA REFDATA,
dyn.M_OUTPUTTBL REPTBL,
count(*) OCC

from MUREX_DM_OWNER.TRAF_PL_GREEK_REP rep
left join MUREX_MX_OWNER.ACT_JOBDAP_DBF dapjob on rep.M_MX_REF_JOB = dapjob.M_IDJOB
left join MUREX_MX_OWNER.ACT_JOB_DBF job on dapjob.M_IDJOB = job.M_IDJOB 
left join MUREX_DM_OWNER.DYN_AUDIT_REP dyn on job.M_REF_DATA = dyn.M_REF_DATA

group by 
dapjob.M_IDJOB, 
to_char(dapjob.M_DATE,'YYYY-MM-DD'), 
rtrim(dapjob.M_TAGDATA),
rtrim(job.M_OWNER),
job.M_REF_DATA,
dyn.M_OUTPUTTBL

order by DAPJOB desc