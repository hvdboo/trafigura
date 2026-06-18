select 
cur.M_LABEL LAB, 
rtrim(cur.M_FULL_NAME) DES, 
cur.M_ISO_CODE ISO, 
rtrim(cur.M_AREA)  AREA, 
rtrim(cat.M_LABEL) CAT, 
-- case cur.M_MAJOR when 0 then null when 1 then 'Y' else null end MAJOR,
case cur.M_REMODE
when 0 then 'Rate'
when 1 then 'Swap points' else null end RATEMOD,
rtrim(his.M_GRP_DESC) FLOATREF,
rtrim(cur.M_STCONV) ST_CONV, 
rtrim(cur.M_LTCONV) LT_CONV, 
rtrim(cur.M_LT_SCHED)  LT_SCH, 
rtrim(cur.M_SP_SCHED0) SPT_SCH,
rtrim(cur.M_HOLCLN0) CAL, 
rtrim(cal.M_DESC) CALENDAR,
case cur.M_PRECISION 
when  0 then '1/10'
when  1 then '1/100'
when  2 then '1/1000'
when  3 then '1'
when  4 then '10'
when  5 then '100'
when  6 then '1000'
when  7 then '1000'
when  8 then '1(trunc)'
when  9 then 'round 1/10 + 1 (trunc)'
when 10 then 'round 1/100 + 1 (trunc)'
when 11 then 'round 1/1000 + 1 (trunc)' else null end FLW_PRC,
case cur.M_FRNDRULE
when 0 then 'None'
when 1 then 'Nearest'
when 2 then 'By default'
when 3 then 'By excess' else null end FLW_RND,
to_char(cur.M_RATE_FT_S)||':'||to_char(cur.M_RATE_FT_D) PRC_CNV

from FX_CURR_DBF cur
left join CAL_DEF_DBF cal on cur.M_HOLCLN0 = cal.M_LABEL
left join FXCAT_CUR_DBF cat on cur.M_CATEGORY = cat.M_REFERENCE
left join RT_GROUP_DBF his on rtrim(cur.M_HISFILE) = rtrim(his.M_HISFILE)

order by cur.M_LABEL