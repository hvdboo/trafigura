
select 
rtrim(itm.M_SNS) CONTXT,
rtrim(M_MEM_ID) LAB,
rtrim(itm.M_LABEL) DES,
case itm.M_TYPE
when 0 then 'String'
when 1 then 'Date'
when 2 then 'Time'
when 3 then 'Integer'
when 4 then 'Double' else null end RESTYP,
rtrim(vsh.M_OWNER) OWNER,
rtrim(vis.M_USER) USR,
rtrim(vis.M_DESK) DSK,
rtrim(vis.M_GROUP) GRP,
frm.M_BUFNB FRMSEQ,
rtrim(frm.M_BUFFER) FRMSCR,
itm.M_REF REFUID 

from VWR_ITMFM_DBF itm
left join VWR_VISH_DBF vsh on (itm.M_REF = vsh.M_REF and vsh.M_TYPE = 10)
left join VWR_VIS_DBF vis on vsh.M_HDR_REF = vis.M_HDR_REF
left join FRM_FILE_DBF frm on itm.M_FRM_REF = frm.M_GROUP

where 1 = 1
and rtrim(itm.M_SNS) = 'Simulation'
--and rtrim(itm.M_LABEL) = 'Acc section desc'

order by LAB, FRMSEQ

