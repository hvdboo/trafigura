select
PFL SPFL,
case PFL
when 'BKPR IOHAP TICD' then 'BKPR IOHAP PTED'
when 'MCEX CHS TICI'   then 'MCEX CHS PTEI'
when 'MCEX CWU TICI'   then 'MCEX CWU PTEI'
when 'MCEX NSA TICI'   then 'MCEX NSA PTEI'
when 'MCEX SLI TICI'   then 'MCEX SLI PTEI'
when 'MCEX VLI TICI'   then 'MCEX VLI PTEI'
when 'MCEX ZLI TICI'   then 'MCEX ZLI PTEI'
when 'RMAR AGPAP TICD' then 'RMAR AGPAP TVTD'
when 'RMAR CHS TICI'   then 'RMAR CHS PTEI' else null end TPFL,
FML, GRP, TYP, 
INS, PL_CUR, 
rtrim(fmat.M_LABEL) MATLAB,
to_char(fmat.M_QT_END,'YYYY-MM-DD') MATDAT,
EXP,
QTY_LIVE, NEPL_LIVE,
QTY_DEAD, NEPL_DEAD,
case INS
when 'AL LME FWD' then round(hb_AL.M_VALUE,4)
when 'CU LME FWD' then round(hb_CU.M_VALUE,4)
when 'PB LME FWD' then round(hb_PB.M_VALUE,4)
when 'ZN LME FWD' then round(hb_ZN.M_VALUE,4)
when 'AG LBMA USD/OZ.TR' then round(hb_AG.M_P179,4)
else null end HIS,
case when pos.GRP = 'FWD' then fut.M_QTY else 1 end LOTSIZ,
floor(
NEPL_DEAD/
((case INS 
when 'AL LME FWD' then hb_AL.M_VALUE
when 'CU LME FWD' then hb_CU.M_VALUE
when 'PB LME FWD' then hb_PB.M_VALUE
when 'ZN LME FWD' then hb_ZN.M_VALUE 
when 'AG LBMA USD/OZ.TR' then hb_AG.M_P179 else null end)
*(case when pos.GRP = 'FWD' then fut.M_QTY else 1 end))) MAGLOT,
case when NEPL_DEAD > 0 then 'S' else 'B' end OFFS,
case when NEPL_DEAD > 0 then 'B' else 'S' end TRF

from

(
select
dtm.M_MX_REF_JOB JOB,
rtrim(job.M_TAGDATA) TAG,
rtrim(cto.M_DSP_LABEL) LE,
rtrim(dtm.M_TP_PFOLIO) PFL,
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
count(case when dtm.M_TP_STATUS2 in ('LIVE','MKT_OP') then 1 else null end) OCC_LIVE,
sum(case when dtm.M_TP_STATUS2 in ('DEAD') then dtm.M_TP_LQTYS2 else null end) QTY_DEAD, 
sum(case when dtm.M_TP_STATUS2 in ('DEAD') then dtm.M_PL_NEPL2  else null end) NEPL_DEAD,
count(case when dtm.M_TP_STATUS2 in ('DEAD') then 1 else null end) OCC_DEAD,
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
(dtm.M_MX_REF_JOB in (:JOB) and M_C_CUR_PL in (:CUR))
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
) pos

left join CM_FUT_DBF fut on INS = rtrim(fut.M_LABEL)
left join CM_FMAT1_DBF fmat on fut.M_FUT_MAT = fmat.M_FMAT_ID and EXP = to_char(fmat.M_ST_START,'YYYY-MM-DD')
left join HS790525_DBF hb_AL on (pos.EXP = to_char(hb_AL.M_FIX_DATE,'YYYY-MM-DD') and rtrim(hb_AL.M_INDEX) = '1454' and hb_AL.M_FORMULA = 'P102')
left join HS790525_DBF hb_CU on (pos.EXP = to_char(hb_CU.M_FIX_DATE,'YYYY-MM-DD') and rtrim(hb_CU.M_INDEX) = '1637' and hb_CU.M_FORMULA = 'P102')
left join HS790525_DBF hb_PB on (pos.EXP = to_char(hb_PB.M_FIX_DATE,'YYYY-MM-DD') and rtrim(hb_PB.M_INDEX) = '6061' and hb_PB.M_FORMULA = 'P102')
left join HS790525_DBF hb_ZN on (pos.EXP = to_char(hb_ZN.M_FIX_DATE,'YYYY-MM-DD') and rtrim(hb_ZN.M_INDEX) = '6064' and hb_ZN.M_FORMULA = 'P102')
left join B179446_HBS hb_AG on pos.EXP = to_char(hb_AG.M_DATE,'YYYY-MM-DD') 

where 
(NEPL_LIVE <> 0 or NEPL_DEAD <> 0)

order by SPFL, FML, GRP, TYP, INS, EXP
