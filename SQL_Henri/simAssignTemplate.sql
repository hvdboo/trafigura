select ash.M_LABEL ASSGSET, 
case asb.M_CONTEXT
when 0 then ''
when 1 then 'Simulation'
when 2 then 'TC - Explain position'
else null end ENGINE,
case asb.M_SIMT
when 1 then 'Consolidated'
when 2 then 'Detailed'
when 3 then 'Market data'
else null end LOADER,
rtrim(asb.M_DESK) DESK, rtrim(asb.M_GROUP) GRP, rtrim(asb.M_USER) USR,
--rtrim(asb.M_LAYOUT) LAYOUT, rtrim(asb.M_INIT_VIEW) IVIEW, rtrim(asb.M_PRTF) PFOLIO,
rtrim(tmp.M_LABEL) TEMPLATE,
case asb.M_CONTEXT
when 1 then
case tmp.M_SCREEN
when   0 then 'Rate'
when   1 then 'Security'
when   2 then 'Fx'
when   3 then 'Credit'
when   4 then 'Commodity'
when   6 then 'Main'
when   8 then 'Main only'
when 100 then 'Inherited'
else null end 
else null end TMP_SCREEN,
rtrim(tmp.M_LAYOUT) TMP_LAYOUT,
case tmp.M_FDI
when 0 then 'Hidden'
when 1 then 'Visible'
else null end TMP_FDI,
case tmp.M_VIEWER
when 0 then 'Hidden'
when 1 then 'Visible'
else null end TMP_POS,
case tmp.M_BLOTTER
when 0 then 'Hidden'
when 1 then 'Visible'
else null end TMP_BLT,
case tmp.M_COMP_SCR
when 0 then 'Default'
when 1 then 'All screens'
else null end TMP_CMP
from RTGVWRB_DBF asb
left join RTGVWRH_DBF ash on asb.M__INDEX_ = ash.M__INDEX_
left join RSK_STG_DBF tmp on rtrim(asb.M_TEMPLATE) = rtrim(tmp.M_LABEL)
where ash.M_LABEL = 'DEFAULT' and asb.M_CONTEXT = 1
order by ash.M_LABEL, asb.M_CONTEXT, asb.M_SIMT, asb.M_DESK, asb.M_GROUP, asb.M_USER