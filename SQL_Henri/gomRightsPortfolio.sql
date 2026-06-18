select distinct
rgt.M_GROUP U_GROUP,
case 
when grp.M_BO_FO = 0 then 'DESK'
when grp.M_BO_FO = 1 then 'PLCC'
when grp.M_BO_FO = 2 then 'PC' else '' end GOM_TYP,
case 
when grp.M_BO_FO = 0 then dsk.M_LABEL
when grp.M_BO_FO = 1 then plc.M_LABEL
when grp.M_BO_FO = 2 then prc.M_LABEL else '' end GOM_LAB,
rtrim(tu2.M_LABEL) TRE_U2, 
rtrim(tu1.M_LABEL) TRE_U1, 
rtrim(t0.M_LABEL)  TRE_N0,
rtrim(td1.M_LABEL)  TRE_D1,
rtrim(td2.M_LABEL)  TRE_D2,
rtrim(td3.M_LABEL)  TRE_D3,
rtrim(td4.M_LABEL)  TRE_D4,
rtrim(td5.M_LABEL)  TRE_D5,
case rgt.M_ACCESS
when 0 then 'Read Write'
when 1 then 'Read only'
when 2 then 'Deny'
when 4 then 'Write only' end DFL_RGT,
rtrim(rgtpfl.M_GROUP) GTP,
case rgtpfl.M_ACCESS
when 0 then 'Read Write'
when 1 then 'Read only'
when 2 then 'Deny'
when 4 then 'Write only' else 'Default' end PFL_RGT

from MUB#GRP_RGT1_DBF rgt
left join TRN_GRPD_DBF grp on rgt.M_GROUP = grp.M_LABEL
left join TRN_DSKDL_DBF dskl on (grp.M_FODS = dskl.M_CTN and dskl.M_REF <> 0)
left join TRN_DSKD_DBF dsk on dskl.M_REF = dsk.M_REFERENCE
left join TRN_PLCC_DBF plc on grp.M_PLCC = plc.M_REFERENCE
left join TRN_PC_DBF prc on grp.M_PC = prc.M_REFERENCE
left join MUB#MUB_TREE_DBF t0 on rgt.M_NODE_REF = t0.M_REF
left join MUB#MUB_TREE_DBF tu1 on (t0.M_FATHER_R  = tu1.M_REF and tu1.M_HEIGHT < t0.M_HEIGHT) 
left join MUB#MUB_TREE_DBF tu2 on (tu1.M_FATHER_R = tu2.M_REF and tu2.M_HEIGHT < tu1.M_HEIGHT) 
left join MUB#MUB_TREE_DBF tu3 on (tu2.M_FATHER_R = tu3.M_REF and tu3.M_HEIGHT < tu2.M_HEIGHT)
left join MUB#MUB_TREE_DBF tu4 on (tu3.M_FATHER_R = tu4.M_REF and tu4.M_HEIGHT < tu3.M_HEIGHT)
left join MUB#MUB_TREE_DBF td1 on (t0.M_REF  = td1.M_FATHER_R and t0.M_TRE_GROUP  = td1.M_TRE_GROUP) 
left join MUB#MUB_TREE_DBF td2 on (td1.M_REF = td2.M_FATHER_R and td1.M_TRE_GROUP = td2.M_TRE_GROUP) 
left join MUB#MUB_TREE_DBF td3 on (td2.M_REF = td3.M_FATHER_R and td2.M_TRE_GROUP = td3.M_TRE_GROUP) 
left join MUB#MUB_TREE_DBF td4 on (td3.M_REF = td4.M_FATHER_R and td3.M_TRE_GROUP = td4.M_TRE_GROUP) 
left join MUB#MUB_TREE_DBF td5 on (td4.M_REF = td5.M_FATHER_R and td4.M_TRE_GROUP = td5.M_TRE_GROUP)
left join TRN_PFLD_DBF pfl4 on rtrim(td4.M_LABEL) = rtrim(pfl4.M_LABEL) and td4.M_HEIGHT = 7
left join TRN_PFLD_DBF pfl5 on rtrim(td5.M_LABEL) = rtrim(pfl5.M_LABEL) and td5.M_HEIGHT = 7
left join MUB#GRP_RGT2_DBF rgtpfl on ( rtrim(td5.M_LABEL) = rtrim(rgtpfl.M_PFOLIO) )

where td4.M_HEIGHT = 7 or td5.M_HEIGHT = 7
order by U_GROUP, GOM_TYP, GOM_LAB, TRE_N0, TRE_D1, TRE_D2, TRE_D3, TRE_D4, TRE_D5