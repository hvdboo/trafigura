select
dtm.M_MX_REF_JOB JOB,
rtrim(job.M_TAGDATA) TAG,
to_char(pc.M_DATE,'YYYY-MM-DD') SYSDAT,
rtrim(cto.M_DSP_LABEL) LE,
rtrim(dtm.M_TP_PFOLIO) SPFL,
rtrim(udf.M_OWNER) PFOWN,
rtrim(dtm.M_TRN_FMLY) FML, rtrim(dtm.M_TRN_GRP) GRP, rtrim(dtm.M_TRN_TYPE) TYP,
rtrim(dtm.M_INSTRUMENT) INS,
dtm.M_C_CUR_PL PL_CUR,
rtrim(dtm.M_PL_KEY1) PL_KEY,
-- dtm.M_TP_FXUND UND_CUR,
rtrim(dtm.M_TP_CMCMAT) MAT,
to_char(dtm.M_TP_DTEEXP,'YYYY-MM-DD') EXP,
dtm.M_TP_STRIKE STK,
rtrim(dtm.M_TP_CP) CP,
sum(dtm.M_PL_GEPL2) PL_GE,
sum(dtm.M_PL_CSNF2) PL_PC,
sum(dtm.M_PL_FE2) PL_FE,
sum(dtm.M_PL_NEPL2) PL_NE,
max(dtm.M_FX_CV0EXP) FXCNV_HIS,
max(dtm.M_FX_CV0REP) FXCNV_REP,
-- sum(case when dtm.M_TP_STATUS2 in ('LIVE','MKT_OP') then dtm.M_TP_LQTYS2 else null end) QTY_LIVE,
-- sum(case when dtm.M_TP_STATUS2 in ('LIVE','MKT_OP') then dtm.M_PL_NEPL2  else null end) NEPL_LIVE,
-- count(case when dtm.M_TP_STATUS2 in ('LIVE','MKT_OP') then 1 else null end) OCC_LIVE,
-- sum(case when dtm.M_TP_STATUS2 in ('DEAD') then dtm.M_TP_LQTYS2 else null end) QTY_DEAD, 
-- sum(case when dtm.M_TP_STATUS2 in ('DEAD') then dtm.M_PL_GEPL2  else null end) GEPL_DEAD,
-- sum(case when dtm.M_TP_STATUS2 in ('DEAD') then dtm.M_PL_NEPL2  else null end) NEPL_DEAD,
-- count(case when dtm.M_TP_STATUS2 in ('DEAD') then 1 else null end) OCC_DEAD,
count(*) OCC,
-- round(sum(case when dtm.M_TP_STATUS2 in ('DEAD') then (dtm.M_PL_NEPL2 * (dtm.M_FX_CNVRP0 - dtm.M_FX_CNVACC)) else null end),2) PLDIFF_REPACC,
round(sum(dtm.M_PL_NEPL2 * (dtm.M_FX_CV0REP - dtm.M_FX_CV0EXP)),2) PLDIFF_REPACC

from MUREX_DM_OWNER.SDN_PL_REP dtm
left join MUREX_MX_OWNER.TRN_PC_DBF pc on 1 = 1
left join MUREX_MX_OWNER.ACT_JOBDAP_DBF job on dtm.M_MX_REF_JOB = job.M_IDJOB
-- left join MUREX_MX_OWNER.MPX_SPOT_DBF spt on (dtm.M_TP_FXUND = spt.M_NUM and dtm.M_TP_DTEEXP = M__DATE_ and spt.M__ALIAS_ = 'LANA MDS')
left join MUREX_MX_OWNER.TRN_PFLD_DBF pfl on dtm.M_TP_PFOLIO = pfl.M_LABEL
left join MUREX_MX_OWNER.TRN_CPDF_DBF cto on pfl.M_PROC_AREA = cto.M_ID
left join TABLE#DATA#PORTFOLI_DBF udf on rtrim(pfl.M_LABEL) = rtrim(udf.M_LABEL)

where
dtm.M_MX_REF_JOB in (:JOB)
-- and M_C_CUR_PL not in ('USD')
-- and M_TP_FXUND in ('CNY', 'CNH')
and dtm.M_TP_STATUS2 = 'DEAD'
-- and dtm.M_TP_DTEEXP > (:EXP)
and substr(dtm.M_TP_GID,1,3) not in ('BLN')

group by
dtm.M_MX_REF_JOB,
rtrim(job.M_TAGDATA),
pc.M_DATE,
rtrim(cto.M_DSP_LABEL),
rtrim(dtm.M_TP_PFOLIO),
rtrim(udf.M_OWNER),
rtrim(dtm.M_TRN_FMLY), rtrim(dtm.M_TRN_GRP), rtrim(dtm.M_TRN_TYPE),
rtrim(dtm.M_INSTRUMENT),
dtm.M_C_CUR_PL,
dtm.M_TP_FXUND,
rtrim(dtm.M_PL_KEY1),
rtrim(dtm.M_TP_CMCMAT),
dtm.M_TP_DTEEXP,
dtm.M_TP_STRIKE,
rtrim(dtm.M_TP_CP),
dtm.M_MP_SPOT2

order by FML, GRP, TYP, INS, EXP, SPFL
