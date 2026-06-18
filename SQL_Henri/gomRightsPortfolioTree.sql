select 
case 
when grp.M_BO_FO = 0 then rtrim(dsk.M_LABEL)
when grp.M_BO_FO = 1 then rtrim(plc.M_LABEL)
when grp.M_BO_FO = 2 then rtrim(prc.M_LABEL) else '' end CENTER,
rtrim(rgt.M_GROUP) GRP_LAB,
rtrim(grp.M_DESC) GRP_DESC,
rtrim(pfltpl.M_LABEL) PFL_TPL,
(
rtrim(t4.M_LABEL) || ' > ' || 
rtrim(t3.M_LABEL) || ' > ' ||
rtrim(t2.M_LABEL) || ' > ' || 
rtrim(t1.M_LABEL) || ' > ' || 
rtrim(t0.M_LABEL)
) PFL_TREE,
case rgt.M_ACCESS
when 0 then 'Read Write'
when 1 then 'Read only'
when 2 then 'Deny'
when 4 then 'Write only' end RIGHTS

from MUB#GRP_RGT1_DBF rgt
left join TRN_GRPD_DBF grp on rgt.M_GROUP = grp.M_LABEL
left join TRN_DSKDL_DBF dskl on (grp.M_FODS = dskl.M_CTN and dskl.M_REF <> 0)
left join TRN_DSKD_DBF dsk on dskl.M_REF = dsk.M_REFERENCE
left join TRN_PLCC_DBF plc on grp.M_PLCC = plc.M_REFERENCE
left join TRN_PC_DBF prc on grp.M_PC = prc.M_REFERENCE
left join MUB#MUB_TPL_DBF pfltpl on grp.M_MUB_TMPL = pfltpl.M_REFERENCE
left join MUB#MUB_TREE_DBF t0 on (rgt.M_NODE_REF = t0.M_REF and t0.M_TRE_GROUP = pfltpl.M_TRE_GROUP)
left join MUB#MUB_TREE_DBF t1 on (t0.M_FATHER_R = t1.M_REF and t1.M_HEIGHT < t0.M_HEIGHT and t1.M_TRE_GROUP = pfltpl.M_TRE_GROUP) 
left join MUB#MUB_TREE_DBF t2 on (t1.M_FATHER_R = t2.M_REF and t2.M_HEIGHT < t1.M_HEIGHT and t2.M_TRE_GROUP = pfltpl.M_TRE_GROUP) 
left join MUB#MUB_TREE_DBF t3 on (t2.M_FATHER_R = t3.M_REF and t3.M_HEIGHT < t2.M_HEIGHT and t3.M_TRE_GROUP = pfltpl.M_TRE_GROUP)
left join MUB#MUB_TREE_DBF t4 on (t3.M_FATHER_R = t4.M_REF and t4.M_HEIGHT < t3.M_HEIGHT and t4.M_TRE_GROUP = pfltpl.M_TRE_GROUP)
--where substr(grp.M_DESC,1,4) = 'TRAF'

order by CENTER, GRP_LAB