select 	
rtrim(fut.M_LABEL) LABEL, rtrim(fut.M_DESC) DESCRIPTION,  
case fut.M_LISTED 
when  1 then 'Future'
when 64 then 'Option' end CNT_TYP,
rtrim(qotf.M_LABEL) QUOTE,
qot.M_CURR CUR, to_number(rtrim(fut.M_COMMENT3)) PRC_FCT, rtrim(uniq.M_LABEL) UNIT_QUOT,
fut.M_QTY LOT,
rtrim(pub.M_LABEL) as PUBLICATION, rtrim(qot.M_TRAD_SMB) as SPAN,
rtrim(fut.M_REALTIME) as TT, rtrim(fut.M_COMMENT0) as PFOLIO
from CM_FUT_DBF fut
left join CMC_QUOT_DBF qotf on fut.M_QUOT_FWD = qotf.M_REFERENCE
left join RT_INSGN_DBF ins on fut.M_CM_INSTR = ins.M_GEN_NUM
left join CM_FMAT_DBF fmat on fut.M_FUT_MAT = fmat.M_REFERENCE
left join CMC_QUOT_DBF qot on fut.M_QUOT_SET = qot.M_SET
left join CM_UNIT_DBF uniq on qot.M_UNIT = uniq.M_REFERENCE
left join CM_UNIT_DBF unid on qot.M_QTY_UNIT = unid.M_REFERENCE
left join CM_MKT_DBF pub on qot.M_PUBLI= pub.M_REFERENCE 
left join CMC_MGEN_DBF mgen on fut.M_CM_INSTR = mgen.M_REFERENCE
left join RT_INDEX_DBF ind on mgen.M_INDEX = ind.M_INDEX
left join CM_ASSET_DBF ass on fut.M_ASSET = ass.M_REFERENCE
left join CM_ATYPE_DBF atp on ass.M_TYPE = atp.M_REFERENCE
where fut.M_LISTED = 1 or fut.M_LISTED = 64
order by LABEL, CNT_TYP