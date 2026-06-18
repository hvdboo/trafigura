select 
job.M_IDJOB JOB, to_char(job.M_DATE,'YYYY-MM-DD') JOBDAT,
to_char(floor(job.M_TIME/3600),'FM09')||':'||to_char(floor(mod(job.M_TIME,3600)/60),'FM09')||':'||to_char(mod(mod(job.M_TIME,3600),60),'FM09') JOBSTART,
to_char(floor(job.M_ENDTIME/3600),'FM09')||':'||to_char(floor(mod(job.M_ENDTIME,3600)/60),'FM09')||':'||to_char(mod(mod(job.M_ENDTIME,3600),60),'FM09') JOBEND,
job.M_PID JOBPID, 
rtrim(job.M_GROUP) JOBGRP, rtrim(job.M_OWNER) JOBOWN, 
job.M_STATUS JOBSTAT,
rtrim(job.M_CTX) TYP,
-- rtrim(job.M_BATCH) BATCH,
-- rtrim(jobdap.M_TAGDATA) TAG,
-- job.M_REF_SET REFSET,
rtrim(refset.M_LABEL) REFSET,
rtrim(refset.M_TAGDATA) REFTAG,
rtrim(refset.M_FLTTEMP) REFFLT,
rtrim(bat.M_LABEL) BAT,
rtrim(aud.M_OUTPUTTBL) TBL,
rtrim(aud.M_TABLEDYN) DYN,
job.M_REF_DATA REFDATA,
to_char(refkey.M_DATEGEN,'YYYY-MM-DD') REFDATLOG,
to_char(refkey.M_DATESYS,'YYYY-MM-DD') REFDATSYS


from MUREX_MX_OWNER.ACT_JOB_DBF job
left join MUREX_MX_OWNER.ACT_JOBDAP_DBF jobdap on job.M_IDJOB = jobdap.M_IDJOB
left join MUREX_MX_OWNER.ACT_SET_DBF refset on job.M_REF_SET = refset.M_REF
left join MUREX_MX_OWNER.ACT_KEY_DBF refkey on job.M_REF_DATA = refkey.M_REF
left join MUREX_MX_OWNER.ACT_SETREP_DBF setrep on refset.M_REF = setrep.M_REFSET
left join MUREX_MX_OWNER.ACT_BAT_DBF bat on setrep.M_REFBAT = bat.M_REF
left join MUREX_DM_OWNER.DYN_AUDIT_REP aud on job.M_IDJOB = aud.M_IDJOB

where 1 = 1 
and job.M_IDJOB in (2631755)
-- and job.M_REF_DATA in (78)
-- and to_char(job.M_DATE,'YYYY-MM-DD') = '2021-07-02'

order by JOB

