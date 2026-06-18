select
PFL SPFL,
case PFL
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
when 'RMOT CHS PTEI'	then 'RMAR CHS TICI'
when 'RMOT MRI PTEI'	then 'RMTS CHS TICI'
when 'RMTS CHS PTEI'	then 'RMAR CHS TICI' else null end TPFL,
FML, GRP, TYP, 
INS, PL_CUR, 
rtrim(fmat.M_LABEL) MATLAB,
to_char(fmat.M_QT_END,'YYYY-MM-DD') MATDAT,
EXP,
QTY_LIVE, NEPL_LIVE,
QTY_DEAD, NEPL_DEAD,
case INS
when 'AL SHFE' then hb_AL.M_P376
when 'CU SHFE' then hb_CU.M_P376
when 'NI SHFE' then hb_NI.M_P376
when 'PB SHFE' then hb_PB.M_P376
when 'ZN SHFE' then hb_ZN.M_P376
when 'HC SHFE' then hb_HC.M_P376
when 'RB SHFE' then hb_RB.M_P376
when 'COAL TH ZCE' then hb_CT.M_P646
when 'COKE DCE' then hb_CK.M_P645
when 'FE ORE DCE' then hb_IO.M_P645 
else null end HIS,
fut.M_QTY LOTSIZ,
floor(
NEPL_DEAD/
((case INS 
when 'AL SHFE' then hb_AL.M_P376
when 'CU SHFE' then hb_CU.M_P376
when 'NI SHFE' then hb_NI.M_P376
when 'PB SHFE' then hb_PB.M_P376
when 'ZN SHFE' then hb_ZN.M_P376
when 'HC SHFE' then hb_HC.M_P376
when 'RB SHFE' then hb_RB.M_P376
when 'COAL TH ZCE' then hb_CT.M_P646
when 'COKE DCE' then hb_CK.M_P645
when 'FE ORE DCE' then hb_IO.M_P645 else null end)*fut.M_QTY)) MAGLOT,
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
)

left join CM_FUT_DBF fut on INS = rtrim(fut.M_LABEL)
left join CM_FMAT1_DBF fmat on fut.M_FUT_MAT = fmat.M_FMAT_ID and EXP = to_char(fmat.M_ST_START,'YYYY-MM-DD')
left join H799862_H1S hh_AL on (fmat.M_REFERENCE = hh_AL.M_KEY0 and INS = 'AL SHFE')
left join B799862_HBS hb_AL on (hh_AL.M_KEYID = hb_AL.M_KEYID and fmat.M_QT_END = hb_AL.M_DATE)
left join H799871_H1S hh_CU on (fmat.M_REFERENCE = hh_CU.M_KEY0 and INS = 'CU SHFE')
left join B799871_HBS hb_CU on (hh_CU.M_KEYID = hb_CU.M_KEYID and fmat.M_QT_END = hb_CU.M_DATE)
left join H799886_H1S hh_NI on (fmat.M_REFERENCE = hh_NI.M_KEY0 and INS = 'NI SHFE')
left join B799886_HBS hb_NI on (hh_NI.M_KEYID = hb_NI.M_KEYID and fmat.M_QT_END = hb_NI.M_DATE)
left join H799891_H1S hh_PB on (fmat.M_REFERENCE = hh_PB.M_KEY0 and INS = 'PB SHFE')
left join B799891_HBS hb_PB on (hh_PB.M_KEYID = hb_PB.M_KEYID and fmat.M_QT_END = hb_PB.M_DATE)
left join H799900_H1S hh_ZN on (fmat.M_REFERENCE = hh_ZN.M_KEY0 and INS = 'ZN SHFE')
left join B799900_HBS hb_ZN on (hh_ZN.M_KEYID = hb_ZN.M_KEYID and fmat.M_QT_END = hb_ZN.M_DATE)
left join H042607_H1S hh_HC on (fmat.M_REFERENCE = hh_HC.M_KEY0 and INS = 'HC SHFE')
left join B042607_HBS hb_HC on (hh_HC.M_KEYID = hb_HC.M_KEYID and fmat.M_QT_END = hb_HC.M_DATE)
left join H799893_H1S hh_RB on (fmat.M_REFERENCE = hh_RB.M_KEY0 and INS = 'RB SHFE')
left join B799893_HBS hb_RB on (hh_RB.M_KEYID = hb_RB.M_KEYID and fmat.M_QT_END = hb_RB.M_DATE)
left join H550174_H1S hh_CT on (fmat.M_REFERENCE = hh_CT.M_KEY0 and INS = 'COAL TH ZCE')
left join B550174_HBS hb_CT on (hh_CT.M_KEYID = hb_CT.M_KEYID and fmat.M_QT_END = hb_CT.M_DATE)
left join H550177_H1S hh_CK on (fmat.M_REFERENCE = hh_CK.M_KEY0 and INS = 'COKE DCE')
left join B550177_HBS hb_CK on (hh_CK.M_KEYID = hb_CK.M_KEYID and fmat.M_QT_END = hb_CK.M_DATE)
left join H799876_H1S hh_IO on (fmat.M_REFERENCE = hh_IO.M_KEY0 and INS = 'FE ORE DCE')
left join B799876_HBS hb_IO on (hh_IO.M_KEYID = hb_IO.M_KEYID and fmat.M_QT_END = hb_IO.M_DATE)

where 
LE <> 'TTS' 
and PL_CUR = 'CNY'
and (NEPL_LIVE <> 0 or NEPL_DEAD <> 0)

order by SPFL, FML, GRP, TYP, INS, EXP
