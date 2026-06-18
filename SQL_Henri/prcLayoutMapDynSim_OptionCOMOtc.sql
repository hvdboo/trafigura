select 
trim(pat.M_REG_DESC) REG, 
trim(patObj.M_LABEL) PATTERN,
trim(layObj.M_LABEL) LAYOUT, 
pos.M_XCOORD X,
coalesce(max(trim(fmt.M_TITLE)),max(case when pos.M_LEGID = 0 then trim(buzp.TITLE) else trim(buzl.TITLE) end),max(trim(udf.M_TITLE))) TITLE,
coalesce(max(trim(npd.M_LABEL)),' ') LEG,
max(case when pos.M_YCOORD = 0 and pos.M_INDEX = 0 then rtrim(pos.M_LABEL) else null end) COL0,
max(case when pos.M_YCOORD = 1 and pos.M_INDEX = 0 then rtrim(pos.M_LABEL) else null end) COL1a,
max(case when pos.M_YCOORD = 1 and pos.M_INDEX = 1 then rtrim(pos.M_LABEL) else null end) COL1b,
max(case when pos.M_YCOORD = 1 and pos.M_INDEX = 2 then rtrim(pos.M_LABEL) else null end) COL1c,
' ',
max(case when pos.M_YCOORD = 0 and pos.M_INDEX = 0 then rtrim(mapDyn.T_COL) else null end) DYNPL0,
max(case when pos.M_YCOORD = 1 and pos.M_INDEX = 0 then rtrim(mapDyn.T_COL) else null end) DYNPL1a,
max(case when pos.M_YCOORD = 1 and pos.M_INDEX = 1 then rtrim(mapDyn.T_COL) else null end) DYNPL1b,
max(case when pos.M_YCOORD = 1 and pos.M_INDEX = 2 then rtrim(mapDyn.T_COL) else null end) DYNPL1c,
' ',
max(case when pos.M_YCOORD = 0 and pos.M_INDEX = 0 then rtrim(mapSim.T_COL) else null end) SIM0,
max(case when pos.M_YCOORD = 1 and pos.M_INDEX = 0 then rtrim(mapSim.T_COL) else null end) SIMa,
max(case when pos.M_YCOORD = 1 and pos.M_INDEX = 1 then rtrim(mapSim.T_COL) else null end) SIM1b,
max(case when pos.M_YCOORD = 1 and pos.M_INDEX = 2 then rtrim(mapSim.T_COL) else null end) SIM1c
from NP_POS_DBF pos 
left join NPD_PAT_DBF pat on (pos.M_STRATID = pat.M_PRF_ID and pat.M_PAT_TYPE = 0)
left join DCF_OBJ_DBF patObj on (pat.M_PAT_ID = patObj.M_ITEM_ID and patObj.M_CATEG = 1)
left join NPD_PAT_DBF layPat on (pos.M_STRATID = layPat.M_PRF_ID and layPat.M_PAT_TYPE = 1)
left join DCF_OBJ_DBF layObj on (layPat.M_PAT_ID = layObj.M_ITEM_ID and layObj.M_CATEG = 1)
left join NPD_BDY_DBF leg on pos.M_LEGID = leg.M_LEG_ID
left join TRAF_REG regl on leg.M_REG_ID = regl.CLASS_INST
left join TRAF_REG regp on rtrim(pat.M_REG_DESC) = rtrim(regp.LAB)
left join DCF_OBJ_DBF npd on leg.M_PAT_ID = npd.M_ITEM_ID
left join TRAF_BUZOBJ buzl on (trim(pos.M_LABEL) = buzl.FLD and leg.M_REG_ID = buzl.TYP)
left join TRAF_BUZOBJ buzp on (trim(pos.M_LABEL) = buzp.FLD and regp.CLASS_INST = buzp.TYP)
left join NP_FMT_DBF fmt on (pos.M_STRATID = fmt.M_STRATID and pos.M_FMTID = fmt.M_FMTID)
left join NP_UDF_DBF udf on (pos.M_LEGID = udf.M_STRATID and pos.M_LABEL = udf.M_LABEL)
left join TRAF_MAPDIC mapDyn on (mapDyn.TYP = 1 and (rtrim(pos.M_LABEL) = rtrim(mapDyn.S_COL) and (mapDyn.S_TBL = '103' or  mapDyn.S_TBL = '0')))
left join TRAF_MAPDIC mapSim on (mapSim.TYP = 2 and (rtrim(pos.M_LABEL) = rtrim(mapSim.S_COL) and (mapSim.S_TBL = '103' or  mapSim.S_TBL = '0')))
where pos.M_STRATID in (96)
group by pat.M_REG_DESC, patObj.M_LABEL, layObj.M_LABEL, pos.M_XCOORD
order by pat.M_REG_DESC, patObj.M_LABEL, layObj.M_LABEL, pos.M_XCOORD