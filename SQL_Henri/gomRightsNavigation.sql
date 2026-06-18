select rtrim(grp.M_LABEL) GRP_LAB, rtrim(grp.M_DESC) GRP_DESC,
case 
when grp.M_BO_FO = 0 then dsk.M_LABEL
when grp.M_BO_FO = 1 then plc.M_LABEL
when grp.M_BO_FO = 2 then prc.M_LABEL else '' end CENTER,
rtrim(nav.M_LABEL) NAVIGATION
from NAV_GRP_DBF rgt
left join TRN_GRPD_DBF grp on rgt.M_GROUP_ID = grp.M_EXT_REF
left join TRN_DSKDL_DBF dskl on (grp.M_FODS = dskl.M_CTN and dskl.M_REF <> 0)
left join TRN_DSKD_DBF dsk on dskl.M_REF = dsk.M_REFERENCE
left join TRN_PLCC_DBF plc on grp.M_PLCC = plc.M_REFERENCE
left join TRN_PC_DBF prc on grp.M_PC = prc.M_REFERENCE
left join NAV_TMPL_DBF nav on rgt.M_NAVT_ID = nav.M_REFERENCE
--where grp.M_LABEL <> null --and grp.M_LABEL <> 'FO_COM'
where substr(grp.M_DESC,1,4) = 'TRAF'
order by  GRP_DESC, CENTER