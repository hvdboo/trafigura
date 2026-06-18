select 
grp.M_LABEL U_GROUP, 
case
when grp.M_BO_FO = 0 then 'Front-office'
when grp.M_BO_FO = 1 then 'P&L Control'
when grp.M_BO_FO = 2 then 'Processing' else '' end TYPE,
case 
when grp.M_BO_FO = 0 then dsk.M_LABEL
when grp.M_BO_FO = 1 then plc.M_LABEL
when grp.M_BO_FO = 2 then prc.M_LABEL else '' end CENTER,
stp.M_LABEL OSP
from TRN_GRPD_DBF grp
left join TRN_DSKDL_DBF dskl on (grp.M_FODS = dskl.M_CTN and dskl.M_REF <> 0)
left join TRN_DSKD_DBF dsk on dskl.M_REF = dsk.M_REFERENCE
left join TRN_PLCC_DBF plc on grp.M_PLCC = plc.M_REFERENCE
left join TRN_PC_DBF prc on grp.M_PC = prc.M_REFERENCE
left join WF_ALL_DBF stp on grp.M_STP_ALLOC = stp.M_LABEL
where grp.M_LABEL <> 'FO_COM'
order by TYPE, CENTER, U_GROUP