select 
case arc.M_GRP_TYPE
when  0 then rtrim(arc.M_GRP_DESC)
when  2 then rtrim(sec.M_SE_D_LABEL)
when  3 then rtrim(cmfut.M_LABEL)||' ('||rtrim(cmfqot.M_LABEL)||')'
when  4 then rtrim(cmipub.M_LABEL)
when  5 then rtrim(arc.M_GRP_DESC)
when  6 then rtrim(arc.M_GRP_DESC)
when  7 then rtrim(cmfut.M_LABEL)||' ('||rtrim(cmfqot.M_LABEL)||')'
when  8 then rtrim(cmfut.M_LABEL)||' ('||rtrim(cmfqot.M_LABEL)||')'
when  9 then rtrim(arc.M_GRP_DESC)
when 10 then rtrim(eqo.M_SE_MKT_OPT)
when 11 then rtrim(arc.M_GRP_CATEG) else rtrim(arc.M_GRP_DESC) end GRP,
/*
rtrim(arc.M_GRP_DESC),
case arc.M_GRP_TYPE
when  0 then 'Index'
when  2 then 'Security future'
when  3 then 'Commodity future'
when  4 then 'Commodity index'
when  5 then 'Pool factor'
when  6 then 'Based on deliverable'
when  7 then 'Commodity cleared asian'
when  8 then 'Commodity option on future'
when  9 then 'Equity cutoff'
when 10 then 'Security listed option'
when 11 then 'FX listed option' else null end TYP,
rtrim(sec.M_SE_CATE) FUT,
*/
case arc.M_GRP_TYPE
when  0 then rtrim(arc.M_GRP_CATEG)
when  2 then rtrim(arc.M_GRP_CATEG)
when  3 then rtrim(cmfpub.M_LABEL)
when  4 then rtrim(cmipub.M_LABEL)
when  5 then rtrim(arc.M_GRP_CATEG)
when  6 then rtrim(arc.M_GRP_CATEG)
when  7 then rtrim(cmfpub.M_LABEL)
when  8 then rtrim(cmfpub.M_LABEL)
when  9 then rtrim(arc.M_GRP_CATEG)
when 10 then rtrim(arc.M_GRP_CATEG)
when 11 then rtrim(arc.M_GRP_CATEG) else null end CAT,
/*
rtrim(sec.M_SE_GROUP) SEC_GRP, rtrim(sec.M_SE_TYPE) SEC_TYP, rtrim(sec.M_SE_CATE) SEC_CAT,
case arc.M_PRICE
when 0 then 'Published rates'
when 1 then 'Market prices'
when 2 then 'Multi column'
when 3 then 'Option multi column'
when 4 then 'Security listed options'
when 5 then 'FX listed options'
when 6 then 'Memory FX spot' else null end FMT,
case arc.M_GRP_NAT
when 0 then 'Standard' 
when 1 then 'Time serie'
when 2 then 'External' else null end NAT,
*/ 
case arc.M_GRP_TYPE
when  0 then to_char(arc.M_SERIES)
when  3 then rtrim(cmfhsr.M_LABEL)
when  4 then rtrim(cmihsr.M_LABEL)
when  5 then rtrim(eqhsr.M_LABEL)
when  7 then rtrim(cmfhsr.M_LABEL)
when  8 then rtrim(cmfhsr.M_LABEL)
when  9 then rtrim(eqhsr.M_LABEL) else null end HSR,
trim(cal.M_LABEL) CAL, --rtrim(cal.M_DESC), 
case arc.M_FREQUENCY 
when 0 then 'Daily'
when 1 then 'Workingdays'
when 2 then 'Weekly'
when 3 then 'Monthly' else null end FRQ,
rtrim(arc.M_SHIFTER) SHF,
case arc.M_ROUND_RUL
when 0 then 'None'
when 1 then 'Nearest'
when 2 then 'By default'
when 3 then 'By excess ' 
when 5 then 'Nearest 5th'
when 6 then 'By excess 5th' 
when 7 then 'By default 5th' else null end RND_RUL,
arc.M_DECIMALS RND_DEC, 
arc.M_NULLFIX NULFIX,
arc.M_STAMPED TMS,
rtrim(arc.M_HISFILE) H_FIL, 
case arc.M_GRP_TYPE
when  0 then arc.M_SERIES
when  3 then cmfhsr.M_SERIE
when  4 then cmihsr.M_SERIE
when  5 then eqhsr.M_SERIE
when  7 then cmfhsr.M_SERIE
when  8 then cmfhsr.M_SERIE
when  9 then eqhsr.M_SERIE else null end H_SER
from ${FIN_schema}RT_GROUP_DBF arc
left join ${FIN_schema}CAL_DEF_DBF cal on arc.M_CALENDAR = cal.M_LABEL
left join ${FIN_schema}CM_FUT_DBF cmfut on trim(substr(arc.M_GRP_DESC,1,10)) = to_char(cmfut.M_REFERENCE) and arc.M_GRP_TYPE in (3, 7, 8)
left join ${FIN_schema}CMC_QUOT_DBF cmfqot on trim(substr(arc.M_GRP_DESC,11,11)) = to_char(cmfqot.M_REFERENCE) and arc.M_GRP_TYPE in (3, 7, 8)
left join ${FIN_schema}CM_MKT_DBF cmfpub on cmfqot.M_PUBLI = cmfpub.M_REFERENCE 
left join ${FIN_schema}CM_MKTSR_DBF cmfhsr on cmfpub.M_REFERENCE = cmfhsr.M_REFERENCE
left join ${FIN_schema}CM_MKT_DBF cmipub on trim(substr(arc.M_GRP_CATEG,1,10)) = to_char(cmipub.M_REFERENCE) and arc.M_GRP_TYPE = 4
left join ${FIN_schema}CM_MKTSR_DBF cmihsr on cmipub.M_REFERENCE = cmihsr.M_REFERENCE
left join ${FIN_schema}SE_MKT2_DBF eqo on trim(substr(arc.M_GRP_CATEG,1,10)) = to_char(eqo.M_SE_OPT_IN) and arc.M_GRP_TYPE = 10
left join ${FIN_schema}CM_MKTSR_DBF eqhsr on arc.M_SERIES = eqhsr.M_REFERENCE and M_PRICE = 2
left join ${FIN_schema}SE_HEAD_DBF sec on trim(substr(arc.M_GRP_DESC,length(rtrim(arc.M_GRP_CATEG))+1,20)) = trim(sec.M_SE_LABEL)
where arc.M_GRP_TYPE in (2) 
and rtrim(sec.M_SE_CATE) = 'Equity'
order by GRP, arc.M_GRP_TYPE, HSR
