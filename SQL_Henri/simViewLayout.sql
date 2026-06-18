select
rtrim(lay.M_L_NAME) LAY, 
--lay.M_ID L,
/*
case sc0.M_LAY_TYPE
when 0 then null
when 41 then 'AllDesktops'
when 42 then 'Toolbar'
when 43 then 'Toolbar Container'
when 44 then 'Desktop'                        
when 47 then 'GridBag'
when 48 then 'HorizontalSplit'
when 54 then 'Tabbed'        
when 56 then 'VerticalSplit' 
when 66 then 'ActionToolbar'
when 67 then 'ViewerToolbarContainer' else null end SCRTYP,
*/
-- rtrim(sc4.M_LABEL) TAB4,
-- rtrim(sc3.M_LABEL) TAB3,
rtrim(sc2.M_LABEL) TAB2,
rtrim(sc1.M_LABEL) TAB1,
-- sc1.M_UNIQUEID,
rtrim(sc0.M_LABEL) TAB0,
rtrim(viw.M_DSP_TITLE) VIWTIT,
rtrim(viw.M_CFG_LBL) VIW, 
rtrim(act.M_ACT_LBL) ACT,
rtrim(avw.M_V_NAME) AVW,
sc0.M_LIST_ID S,
viw.M_CFG_REF V

from MDL_SCREEN_DBF sc0
left join MDL_LAYH_DBF lay on sc0.M_LIST_ID = lay.M_SCRLST_R
left join MDL_SCREEN_DBF sc1 on sc0.M_FATHERID = sc1.M_UNIQUEID
left join MDL_SCREEN_DBF sc2 on sc1.M_FATHERID = sc2.M_UNIQUEID
left join MDL_SCREEN_DBF sc3 on sc2.M_FATHERID = sc3.M_UNIQUEID
left join MDL_SCREEN_DBF sc4 on sc3.M_FATHERID = sc4.M_UNIQUEID
left join VWR_CFGS_DBF viw on sc0.M_OBJECT_R = viw.M_CFG_REF
left join VWR_ACT_DBF act on (viw.M_ACT_REF = act.M_ACT_LRF and act.M_ACT_ASTRID = 'View')
left join VWR_NAVLNKEX_DBF avw on act.M_ACT_REF = avw.M_VIEW_ACT_REF

where lay.M_ID in (
269,
274,
320,
321,
358
)
and rtrim(viw.M_CFG_LBL) is not null
-- where lay.M_SNS = 'Simulation'

order by LAY, TAB2, TAB1, TAB0, VIW
