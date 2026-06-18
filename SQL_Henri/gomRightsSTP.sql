select 
grp.M_LABEL U_GROUP, 
case 
when grp.M_BO_FO = 0 then dsk.M_LABEL
when grp.M_BO_FO = 1 then plc.M_LABEL
when grp.M_BO_FO = 2 then prc.M_LABEL else '' end CENTER,
pc.M_LABEL PC, wfl.M_LABEL PROC_TMPL,
/*ass.M_STP_RIGHTS,*/ 
tpl.M_LABEL RGHT_TMPL
from GRP_STP_DBF ass
left join TRN_GRPD_DBF grp on ass.M_GRP_REF = grp.M_REFERENCE
left join TRN_DSKDL_DBF dskl on (grp.M_FODS = dskl.M_CTN and dskl.M_REF <> 0)
left join TRN_DSKD_DBF dsk on dskl.M_REF = dsk.M_REFERENCE
left join TRN_PLCC_DBF plc on grp.M_PLCC = plc.M_REFERENCE
left join TRN_PC_DBF prc on grp.M_PC = prc.M_REFERENCE
left join TRN_PC_DBF pc on ass.M_PC_REF = pc.M_REFERENCE
left join WF_TPL_DBF wfl on pc.M_STP_TPL = wfl.M_REFERENCE
left join STP_RGH_TPL_GBL_DBF tpl on ass.M_RIGHT_DATA = tpl.M_REFERENCE 
--where grp.M_LABEL <> null and grp.M_LABEL <>'FO_COM'
order by CENTER, U_GROUP