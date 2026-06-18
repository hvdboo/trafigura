select
scop.TRN,
-- SCOPE
scop.PFL PFL_SCP,
scop.BS DIR_SCP,
scop.CTP CTP_SCP,
-- OFFSET
offs.PFL PFL_OFF,
case offs.BS 
when 'B' then 'S'
when 'S' then 'B' else null end as DIR_OFF,
case when offs.PFL = offs.PFLINI then offs.CTPINI else offs.PFLINI end CTP_OFF,
-- TRANSFER
case trnf.PFL 
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
when 'RMPR NIHAP TICD' then 'RMPR NIHAP PTED' else null end PFL_TRF,
trnf.BS DIR_TRF,
case when trnf.PFL = trnf.PFLINI then trnf.CTPINI else trnf.PFLINI end CTP_TRF


from TRNEXC_GET scop
left join TRNEXC_GET offs on scop.TRN = offs.TRN
left join TRNEXC_GET trnf on scop.TRN = trnf.TRN

order by scop.TRN
