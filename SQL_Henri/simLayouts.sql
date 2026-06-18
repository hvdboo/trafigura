select rtrim(vwl.M_CFG_LBL) LYT_LABEL, 
--vwv.M_CFG_SNS,
--scr.M_OBJECT_R, scr.M_LAY_TYPE, rtrim(scr.M_LABEL) SCR_LABEL, 
rtrim(vwv.M_CFG_LBL) VW_LABEL, rtrim(vwv.M_VIEW_DESC) VW_DESC
from MDL_LAYH_DBF lyt
left join MDL_SCREEN_DBF scr on lyt.M_SCRLST_R = scr.M_LIST_ID
left join VWR_CFGS_DBF vwl on lyt.M_ID = vwl.M_LMG_REF
left join VWR_CFGS_DBF vwv on scr.M_OBJECT_R = vwv.M_CFG_REF
--where lyt.M_SNS = 'Simulation' and (scr.M_OBJECT_R > 0 and scr.M_LAY_TYPE <> 66)
where vwv.M_CFG_SNS = 'Simulation'
order by LYT_LABEL, VW_LABEL