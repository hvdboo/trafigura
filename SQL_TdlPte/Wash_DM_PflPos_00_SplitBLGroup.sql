select
dtm.M_MX_REF_JOB JOB,
rtrim(job.M_TAGDATA) TAG,
rtrim(cto.M_DSP_LABEL) LE,
rtrim(dtm.M_TP_PFOLIO) PFL, blpfl.M_BL PFL_BL,
rtrim(dtm.M_TP_CNTRP) CTP, blctp.M_BL CTP_BL,
rtrim(pflini.M_CHAR_VAL) PFLINI, blpflini.M_BL PFLINI_BL,
rtrim(ctpini.M_CHAR_VAL) CTPINI, blctpini.M_BL CTPINI_BL,
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
round(sum(case when dtm.M_TP_STATUS2 in ('LIVE','MKT_OP') then dtm.M_PL_NEPL2  else null end),0) NEPL_LIVE,
count(case when dtm.M_TP_STATUS2 in ('LIVE','MKT_OP') then 1 else null end) LIVE,
sum(case when dtm.M_TP_STATUS2 in ('DEAD') then dtm.M_TP_LQTYS2 else null end) QTY_DEAD, 
round(sum(case when dtm.M_TP_STATUS2 in ('DEAD') then dtm.M_PL_NEPL2  else null end),0) NEPL_DEAD,
count(case when dtm.M_TP_STATUS2 in ('DEAD') then 1 else null end) DEAD,
-- round(sum(case when dtm.M_TP_STATUS2 in ('DEAD') then (dtm.M_PL_NEPL2 * (dtm.M_FX_CNVRP0 - dtm.M_FX_CNVACC)) else null end),2) PLDIFF_REPACC,
round(sum(dtm.M_PL_NEPL2 * (dtm.M_FX_CNVRP0 - dtm.M_FX_CNVACC)),2) PLDIFF_REPACC,
count(*) OCC

from MUREX_DM_OWNER.TRAF_TDLPTE_REP dtm
left join MUREX_MX_OWNER.ACT_JOBDAP_DBF job on dtm.M_MX_REF_JOB = job.M_IDJOB
-- left join MUREX_MX_OWNER.MPX_SPOT_DBF spt on (dtm.M_TP_FXUND = spt.M_NUM and dtm.M_TP_DTEEXP = M__DATE_ and spt.M__ALIAS_ = 'LANA MDS')
left join MUREX_MX_OWNER.TRN_PFLD_DBF pfl on dtm.M_TP_PFOLIO = pfl.M_LABEL
left join MUREX_MX_OWNER.TRN_CPDF_DBF cto on pfl.M_PROC_AREA = cto.M_ID
left join MUREX_MX_OWNER.TRN_EXT_DBF ext on dtm.M_NB = ext.M_TRADE_REF
left join MUREX_MX_OWNER.TABLE#DATA#DEALCOM_DBF udf on ext.M_UDF_REF = udf.M_NB
left join MUREX_MX_OWNER.NP_IDATA_DBF pflini on (dtm.M_NB = pflini.M_SNAP_ID and rtrim(pflini.M_LABEL) = 'Portfolio (input)')
left join MUREX_MX_OWNER.NP_IDATA_DBF ctpini on (dtm.M_NB = ctpini.M_SNAP_ID and rtrim(ctpini.M_LABEL) = 'Counterpart (input)')
left join MUREX_DM_OWNER.ACC_BL_MAP_REP blpfl on rtrim(dtm.M_TP_PFOLIO) = blpfl.M_PTF
left join MUREX_DM_OWNER.ACC_BL_MAP_REP blctp on rtrim(dtm.M_TP_CNTRP) = blctp.M_PTF
left join MUREX_DM_OWNER.ACC_BL_MAP_REP blpflini on rtrim(pflini.M_CHAR_VAL) = blpflini.M_PTF
left join MUREX_DM_OWNER.ACC_BL_MAP_REP blctpini on rtrim(ctpini.M_CHAR_VAL) = blctpini.M_PTF

where
(
-- (dtm.M_MX_REF_JOB in (87568) and M_TP_FXUND in ('CNY', 'CNH')) or 
(dtm.M_MX_REF_JOB in (:JOB) and M_C_CUR_PL in (:CUR))
)
-- and dtm.M_TP_STATUS2 = 'DEAD'
-- and to_char(dtm.M_TP_DTEEXP,'YYYY-MM-DD') < '2018-03-06'
and substr(dtm.M_TP_GID,1,3) <> 'BLN'

group by
dtm.M_MX_REF_JOB,
rtrim(job.M_TAGDATA),
rtrim(cto.M_DSP_LABEL),
rtrim(dtm.M_TP_PFOLIO),  blpfl.M_BL,
rtrim(dtm.M_TP_CNTRP),   blctp.M_BL,
rtrim(pflini.M_CHAR_VAL), blpflini.M_BL,
rtrim(ctpini.M_CHAR_VAL), blctpini.M_BL,
rtrim(dtm.M_TRN_FMLY), rtrim(dtm.M_TRN_GRP), rtrim(dtm.M_TRN_TYPE),
rtrim(dtm.M_INSTRUMENT),
dtm.M_C_CUR_PL,
dtm.M_TP_FXUND,
rtrim(dtm.M_TP_CMCMAT),
to_char(dtm.M_TP_DTEEXP,'YYYY-MM-DD'),
dtm.M_TP_STRIKE,
rtrim(dtm.M_TP_CP)

order by PFL, FML, GRP, TYP, INS, EXP
