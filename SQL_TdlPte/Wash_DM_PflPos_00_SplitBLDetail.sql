select distinct
dtm.M_MX_REF_JOB JOB,
rtrim(job.M_TAGDATA) TAG,
dtm.M_NB TRN,
dtm.M_PACKAGE PCK,
rtrim(dtm.M_TP_PFOLIO) PFL,
rtrim(dtm.M_TP_ENTITY) CE,
rtrim(cto.M_DSP_LABEL) LE,
blpfl.M_BL PFL_BL,
case dtm.M_TP_PFOLIO
when 'BKAR IOPAP TICI' then 'BKAR IOPAP PTEI'
when 'BKEX TRE TICD'   then 'BKEX TRE PTEI'
when 'BKPR IOHAP TICD' then 'BKPR IOHAP PTED'
when 'COAR CUPAP TICD' then 'COAR CUPAP TVTD'
when 'COAR PBPAP TICD' then 'COAR PBPAP TVTD'
when 'COPR CUHAP TICD' then 'COPR CUHAP TVTD'
when 'COPR PBHAP TICD' then 'COPR PBHAP TVTD'
when 'MCEX CHS TICI'   then 'MCEX CHS PTEI'
when 'MCEX CWU TICI'   then 'MCEX CWU PTEI'
when 'MCEX NHA TICI'   then 'MCEX NHA PTEI'
when 'MCEX NSA TICI'   then 'MCEX NSA PTEI'
when 'MCEX SLI TICI'   then 'MCEX SLI PTEI'
when 'MCEX VLI TICI'   then 'MCEX VLI PTEI'
when 'MCEX ZLI TICI'   then 'MCEX ZLI PTEI'
when 'RMAR AGPAP TICD' then 'RMAR AGPAP TVTD'
when 'RMAR CHS TICI'   then 'RMAR CHS PTEI'
when 'RMAR MB- TICD'   then 'RMAR MB- PTEI'
when 'RMAR MRI TICI'   then 'RMAR MRI PTEI'
when 'RMAR NHA TICI'   then 'RMAR NHA TVTD'
when 'RMPR NIHAP TICD' then 'RMPR NIHAP PTED' else null end PFL_TGT,
-- dtm.M_TP_BUY,
-- dtm.M_H_QUANTITY,
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
-- dtm.M_FX_CNVACC FXCNV_HIS,
-- dtm.M_FX_CNVRP0 FXCNV_REP,
-- case when dtm.M_TP_STATUS2 in ('LIVE','MKT_OP') then dtm.M_TP_LQTYS2 else null end QTY_LIVE,
-- round(case when dtm.M_TP_STATUS2 in ('LIVE','MKT_OP') then dtm.M_PL_NEPL2  else null end,0) NEPL_LIVE,
-- case when dtm.M_TP_STATUS2 in ('DEAD') then dtm.M_TP_LQTYS2 else null end QTY_DEAD, 
round(case when dtm.M_TP_STATUS2 in ('DEAD') then dtm.M_PL_GEPL2  else null end,2) GEPL_DEAD,
round(case when dtm.M_TP_STATUS2 in ('DEAD') then dtm.M_PL_NEPL2  else null end,2) NEPL_DEAD,
-- round(sum(case when dtm.M_TP_STATUS2 in ('DEAD') then (dtm.M_PL_NEPL2 * (dtm.M_FX_CNVRP0 - dtm.M_FX_CNVACC)) else null end),2) PLDIFF_REPACC,
round(dtm.M_PL_NEPL2 * (dtm.M_FX_CNVRP0 - dtm.M_FX_CNVACC),2) PLDIFF_REPACC

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
-- and blpfl.M_BL <> blpflini.M_BL
and dtm.M_NB in
(

 9869902,
 9869905,
 9968045,
10355070,
10355298,
10355461,
10355473,
10456042,
11005621,
11005656,
11005693,
11005988,
11022099,
11077680,
11077685,
11077690,
11102820,
11293204,
11365863,
11365866,
11365875,
11365878,
11372891,
11372894,
11372903,
11372906,
11373278,
11373281,
11373290,
11373293,
11768210,
11768213,
11768216,
11768219,
11768222,
11768225,
11768228,
11768231,
11768234,
11768237,
11768240,
11768243,
11768246,
11768249,
11768252,
11768255,
11768258,
11768261,
11769802,
11770019,
11770021,
11770229,
11770232,
11770241
)




order by PFL, FML, GRP, TYP, INS, EXP
