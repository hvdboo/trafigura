select
dtm.M_MX_REF_JOB JOB,
rtrim(job.M_TAGDATA) TAG,
rtrim(cto.M_DSP_LABEL) LE,
rtrim(dtm.M_TP_PFOLIO) SPFL,
case rtrim(dtm.M_TP_PFOLIO)
when 'BKEX JDI PTEI'   	then 'BKEX JDI TICI'
when 'BKEX TRE PTEI'   	then 'BKEX TRE TICI'
when 'BKPR IOHAP PTED'	then 'BKPR IOHAP TICD'
when 'MCEX CHS PTEI'	then 'MCEX CHS TICI'
when 'MCEX NHA PTEI'	then 'MCEX NHA TICI'
when 'MCEX NSA PTEI'	then 'MCEX NSA TICI'
when 'MCEX SLI PTEI'	then 'MCEX SLI TICI'
when 'MCEX VLI PTEI'	then 'MCEX VLI TICI'
when 'MCEX VLI TDLI'	then 'MCEX ZLI TICI'
when 'MCEX ZLI PTEI'	then 'MCEX ZLI TICI'
when 'RMAR CHS PTEI'	then 'RMAR CHS TICI'
when 'RMAR MRI PTEI'	then 'RMAR MRI TICI'
when 'RMAR MRI TVTD'	then 'RMAR NHA TICI'
when 'RMAR NHA PTEI'	then 'RMAR NHA TICI'
when 'RMOT CHS PTEI'	then 'RMOT CHS TICI'
when 'RMOT MRI PTEI'	then 'RMTS CHS TICI'
when 'RMTS CHS PTEI'	then 'RMTS CHS TICI' else null end TPFL,
rtrim(dtm.M_TRN_FMLY) FML, rtrim(dtm.M_TRN_GRP) GRP, rtrim(dtm.M_TRN_TYPE) TYP,
rtrim(dtm.M_INSTRUMENT) INS,
dtm.M_C_CUR_PL PL_CUR,
dtm.M_TP_FXUND UND_CUR,
rtrim(dtm.M_TP_CMCMAT) MAT,
to_char(dtm.M_TP_DTEEXP,'YYYY-MM-DD') EXP,
dtm.M_TP_STRIKE STK,
rtrim(dtm.M_TP_CP) CP,
max(dtm.M_FX_CNVACC) FXCNV_HIS,
max(dtm.M_FX_CNVRP0) FXCNV_REP,
sum(case when dtm.M_TP_STATUS2 in ('LIVE','MKT_OP') then dtm.M_TP_LQTYS2 else null end) QTY_LIVE,
sum(case when dtm.M_TP_STATUS2 in ('LIVE','MKT_OP') then dtm.M_PL_NEPL2  else null end) NEPL_LIVE,
count(case when dtm.M_TP_STATUS2 in ('LIVE','MKT_OP') then 1 else null end) LIVE,
sum(case when dtm.M_TP_STATUS2 in ('DEAD') then dtm.M_TP_LQTYS2 else null end) QTY_DEAD, 
sum(case when dtm.M_TP_STATUS2 in ('DEAD') then dtm.M_PL_NEPL2  else null end) NEPL_CNY,
count(case when dtm.M_TP_STATUS2 in ('DEAD') then 1 else null end) DEAD,
-- round(sum(case when dtm.M_TP_STATUS2 in ('DEAD') then (dtm.M_PL_NEPL2 * (dtm.M_FX_CNVRP0 - dtm.M_FX_CNVACC)) else null end),2) PLDIFF_REPACC,
round(sum(dtm.M_PL_NEPL2 * (dtm.M_FX_CNVRP0 - dtm.M_FX_CNVACC)),2) PLDIFF_REPACC,
count(*) OCC

from MUREX_DM_OWNER.TRAF_TDLPTE_REP dtm
left join MUREX_MX_OWNER.ACT_JOBDAP_DBF job on dtm.M_MX_REF_JOB = job.M_IDJOB
-- left join MUREX_MX_OWNER.MPX_SPOT_DBF spt on (dtm.M_TP_FXUND = spt.M_NUM and dtm.M_TP_DTEEXP = M__DATE_ and spt.M__ALIAS_ = 'LANA MDS')
left join MUREX_MX_OWNER.TRN_PFLD_DBF pfl on dtm.M_TP_PFOLIO = pfl.M_LABEL
left join MUREX_MX_OWNER.TRN_CPDF_DBF cto on pfl.M_PROC_AREA = cto.M_ID

where
(
-- (dtm.M_MX_REF_JOB in (87568) and M_TP_FXUND in ('CNY', 'CNH')) or 
(dtm.M_MX_REF_JOB in (:JOB) and M_C_CUR_PL not in ('USD'))
)
-- and dtm.M_TP_STATUS2 = 'DEAD'
-- and to_char(dtm.M_TP_DTEEXP,'YYYY-MM-DD') < '2018-03-06'

group by
dtm.M_MX_REF_JOB,
rtrim(job.M_TAGDATA),
rtrim(cto.M_DSP_LABEL),
rtrim(dtm.M_TP_PFOLIO),
rtrim(dtm.M_TRN_FMLY), rtrim(dtm.M_TRN_GRP), rtrim(dtm.M_TRN_TYPE),
rtrim(dtm.M_INSTRUMENT),
dtm.M_C_CUR_PL,
dtm.M_TP_FXUND,
rtrim(dtm.M_TP_CMCMAT),
to_char(dtm.M_TP_DTEEXP,'YYYY-MM-DD'),
dtm.M_TP_STRIKE,
rtrim(dtm.M_TP_CP),
dtm.M_MP_SPOT2

order by SPFL, FML, GRP, TYP, INS, EXP
