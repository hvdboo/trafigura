select 
rtrim(arc.M_DESC) ARC, 
rtrim(his.M_CALENDAR) CAL, 
case his.M_FREQUENCY
when 0 then 'Daily'
when 1 then 'Free' end FRQ,
rtrim(his.M_HIS_FILE) HIS,
rtrim(arc.M_CONTRACT) CNT, 
rtrim(arc.M_QUOTATION) QOT, arc.M_FORM_FACT FF,
his.M_COL_NUM COLS,
max(case when col.M_INDEX = 0 then rtrim(col.M_COLUMN) else null end) COL0,
max(case when col.M_INDEX = 1 then rtrim(col.M_COLUMN) else null end) COL1

from FX_ARCCT_DBF arc
left join FX_ARCGR_DBF his on rtrim(arc.M_DESC) = rtrim(his.M_DESC)
left join FX_ARCCL_DBF col on his.M_COL_LINK = col.M_LINK

group by 
rtrim(arc.M_DESC), 
rtrim(his.M_CALENDAR), 
case his.M_FREQUENCY
when 0 then 'Daily'
when 1 then 'Free' end,
rtrim(his.M_HIS_FILE),
rtrim(arc.M_CONTRACT), 
rtrim(arc.M_QUOTATION), 
arc.M_FORM_FACT,
his.M_COL_NUM

order by ARC, CNT
