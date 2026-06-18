select 
trim(pat.M_REG_DESC) REG, 
trim(patObj.M_LABEL) PATTERN,
trim(layObj.M_LABEL) LAYOUT, 
pos.M_XCOORD SEQ,
coalesce(max(trim(fmt.M_TITLE)),max(case when pos.M_LEGID = 0 then trim(buzp.M_BUZTIT) else trim(buzl.M_BUZTIT) end),max(trim(udf.M_TITLE))) TITLE,
coalesce(max(trim(npd.M_LABEL)),' ') LEG,
-- max(case when pos.M_YCOORD = 0 and pos.M_INDEX = 0 then rtrim(pos.M_LABEL) else null end) COL0,
max(case when pos.M_YCOORD = 1 and pos.M_INDEX = 0 then rtrim(pos.M_LABEL) else null end) COL1a,
max(case when pos.M_YCOORD = 1 and pos.M_INDEX = 1 then rtrim(pos.M_LABEL) else null end) COL1b,
-- max(case when pos.M_YCOORD = 1 and pos.M_INDEX = 2 then rtrim(pos.M_LABEL) else null end) COL1c,
-- MxML
-- max(case when pos.M_YCOORD = 0 and pos.M_INDEX = 0 then concat(rtrim(mapMxml.M_TGTCOL),rtrim(mapMxml.M_TGTVALC)) else null end) MXML0,
max(case when pos.M_YCOORD = 1 and pos.M_INDEX = 0 then concat(rtrim(mapMxml.M_TGTCOL),rtrim(mapMxml.M_TGTVALC)) else null end) MXML1a,
max(case when pos.M_YCOORD = 1 and pos.M_INDEX = 1 then concat(rtrim(mapMxml.M_TGTCOL),rtrim(mapMxml.M_TGTVALC)) else null end) MXML1b
-- max(case when pos.M_YCOORD = 1 and pos.M_INDEX = 2 then concat(rtrim(mapMxml.M_TGTCOL),rtrim(mapMxml.M_TGTVALC)) else null end) MXML1c

from MUREX_MX_OWNER.NP_POS_DBF pos 
left join MUREX_MX_OWNER.NPD_PAT_DBF pat on (pos.M_STRATID = pat.M_PRF_ID and pat.M_PAT_TYPE = 0)
left join MUREX_MX_OWNER.DCF_OBJ_DBF patObj on (pat.M_PAT_ID = patObj.M_ITEM_ID and patObj.M_CATEG = 1)
left join MUREX_MX_OWNER.NPD_PAT_DBF layPat on (pos.M_STRATID = layPat.M_PRF_ID and layPat.M_PAT_TYPE = 1)
left join MUREX_MX_OWNER.DCF_OBJ_DBF layObj on (layPat.M_PAT_ID = layObj.M_ITEM_ID and layObj.M_CATEG = 1)
left join MUREX_MX_OWNER.NPD_BDY_DBF leg on pos.M_LEGID = leg.M_LEG_ID
left join MUREX_MX_OWNER.UDTB279_DBF regl on leg.M_REG_ID = regl.M_REG_FGT
left join MUREX_MX_OWNER.UDTB279_DBF regp on rtrim(pat.M_REG_DESC) = rtrim(regp.M_REG_DES)
left join MUREX_MX_OWNER.DCF_OBJ_DBF npd on leg.M_PAT_ID = npd.M_ITEM_ID
left join MUREX_MX_OWNER.UDTB293_DBF buzl on (trim(pos.M_LABEL) = buzl.M_BUZFLD and leg.M_REG_ID = buzl.M_BUZCLA)
left join MUREX_MX_OWNER.UDTB293_DBF buzp on (trim(pos.M_LABEL) = buzp.M_BUZFLD and regp.M_REG_FGT = buzp.M_BUZCLA)
left join MUREX_MX_OWNER.NP_FMT_DBF fmt on (pos.M_STRATID = fmt.M_STRATID and pos.M_FMTID = fmt.M_FMTID)
left join MUREX_MX_OWNER.NP_UDF_DBF udf on (pos.M_LEGID = udf.M_STRATID and pos.M_LABEL = udf.M_LABEL)
left join MUREX_MX_OWNER.UDTB291_DBF mapMxml on (mapMxml.M__INDEX_ = 7988809 and (rtrim(pos.M_LABEL) = rtrim(mapMxml.M_SRCCOL) and (mapMxml.M_SRCTBL = '146' or  mapMxml.M_SRCTBL = '0')))

where pos.M_STRATID in (2340431)
group by pat.M_REG_DESC, patObj.M_LABEL, layObj.M_LABEL, pos.M_XCOORD
order by pat.M_REG_DESC, patObj.M_LABEL, layObj.M_LABEL, pos.M_XCOORD