select 
to_char(futprc.M_DATE_RF,'YYYYMMDD') DATINS,
to_char(futprc.M__DATE_,'YYYYMMDD')  DATSYS,
rtrim(futprc.M__ALIAS_) MDS,
rtrim(fut.M_LABEL) FUT,
fmat.M_LABEL MATLAB,
-- fmat.M_BLK_TYPE,
case fmat.M_BLK_TYPE
when -1 then 'Floating'
when  0 then 'Open'
when  1 then 'Day'
when  2 then 'Week'
when  3 then 'Month'
when  4 then 'Quarter'
when  5 then 'Season'
when  6 then 'Year'
when  7 then 'Week-end'
when  8 then 'Weekdays'
when  9 then 'Balmo' 
when 15 then 'Month 2nd BD'
else '' end MATTEN,
to_char(fmat.M_QT_END,'YYYY-MM-DD')   QOTLST,
to_char(fmat.M_ST_START,'YYYY-MM-DD') DLVFST,
to_char(fmat.M_ST_END,'YYYY-MM-DD')   DLVLST,
round(futprc.M_PRC_RF0,futqot.M_PRC_DEC) PRCBID,
round(futprc.M_PRC_RF1,futqot.M_PRC_DEC) PRCASK,
futprc.M_SELECTED SEL

from CMK_FUTP_DBF futprc
left join TRN_PC_DBF pc on  1 = 1
left join CM_FUT_DBF fut on futprc.M_FUTURE = fut.M_REFERENCE
left join CMC_QUOT_DBF futqot on fut.M_QUOT_FWD = futqot.M_REFERENCE
left join CM_FMAT1_DBF fmat on (futprc.M_MAT_CODE = fmat.M_REFERENCE and fut.M_LISTED in ( 1, 16))
left join CM_OMAT1_DBF omat on (futprc.M_MAT_CODE = omat.M_REFERENCE and fut.M_LISTED in (32, 64))

where 1 = 1
and fut.M_LISTED in (1, 2, 16)
and futprc.M__DATE_ = pc.M_DATE
--and fmat.M_ST_END < futprc.M__DATE_ + 96
--and to_char(fmat.M_ST_END,'YYYY-MM-DD') in ('2026-01-13' ,'2026-04-09') --Cash, 3M
and futprc.M__ALIAS_ = 'RT'
-- and fmat.M_BLK_TYPE in (3)
and fut.M_REFERENCE in 
(
1435
)
  

order by DATSYS, MDS, FUT, DLVLST
