select 
case ofut.M_LISTED
when  1 then 'Future'
when  2 then 'Forward'
when 16 then 'Cleared Swap'
when 32 then 'Cleared Asian'
when 64 then 'Listed option' end NATURE,
rtrim(ofut.M_LABEL) LABEL, rtrim(ofut.M_DESC) DESCRIPTION,  
rtrim(fut.M_LABEL) INSTRUMENT,
case ofut.M_OSPRD_TYP
when 0 then 'Simple'
when 1 then 'Product spread' 
when 2 then 'Time spread' end as NATURE,
case ofut.M_PRC_EVAL	
when 0 then 'Marked to market'
when 1 then 'Theoretical' end as EVALUATION,
case fut.M_MCALL_SYS	
when 1 then 'Yes'
when 0 then 'No' end as MC,
case fut.M_IGN_DISC
when 0 then 'No'
when 1 then 'Yes' end IGN_DISC,
case fut.M_NETTING_ALLOWED
when 0 then 'No'
when 1 then 'Yes' end NETTING,
case ofut.M_OSTYLE	
when 0 then 'European' 
when 1 then 'American' end as OPT_STYLE,
case ofut.M_EXR_MODE
when 0 then 'Cash settlement' 
when 1 then 'Delivery' end as EXERCISE,
case ofut.M_OEXR_STYLE	
when 0 then 'European' 
when 1 then 'American' end as EXR_STYLE,
ofut.M_OCUTOFF as CUTOFF,
ofut.M_QTY LOTSIZE,
rtrim(fmat.M_LABEL) FUT_MATSET,
rtrim(omat.M_LABEL) OPT_MATSET,
case ofut.M_OP_OTCZDAT 	
when 0 then 'Trade date'
when 1 then 'Maturity date' end as PRM_STL, 
ofut.M_OPREM_OTC PRM_SHIFT, 
'Exercise date' CSH_STL,
ofut.M_ODELIV_OTC as CSH_SHIFT,
rtrim(qotf.M_LABEL) FWD_QUOTE,
rtrim(qot.M_LABEL) QUOT, rtrim(pub.M_LABEL) PUBLICATION, rtrim(qot.M_TRAD_SMB) SYMBOL, 
qot.M_CURR CUR, round(qot.M_PRC_FACT,3) PRC_FCT,  rtrim(unq.M_LABEL) UNIT, rtrim(und.M_LABEL) UNIT_DLV,
rtrim(atp.M_LABEL) ATYP, rtrim(ass.M_LABEL) ASSET
--ofut.M_REFERENCE O_REF, qot.M_REFERENCE Q_REF

from CM_FUT_DBF ofut
left join CM_FUT_DBF fut on ofut.M_CM_INSTR = fut.M_REFERENCE
left join CMC_QUOT_DBF qotf on ofut.M_QUOT_FWD = qotf.M_REFERENCE
left join CM_FMAT_DBF fmat on ofut.M_FUT_MAT = fmat.M_REFERENCE
left join CM_OMAT_DBF omat on ofut.M_OPT_MAT = omat.M_REFERENCE
left join CMC_QUOT_DBF qot on ofut.M_QUOT_SET = qot.M_SET
left join CM_MKT_DBF pub on qot.M_PUBLI = pub.M_REFERENCE
left join CM_UNIT_DBF unq on qot.M_UNIT = unq.M_REFERENCE
left join CM_UNIT_DBF und on qot.M_QTY_UNIT = und.M_REFERENCE
left join CMC_MGEN_DBF ins on ofut.M_CM_INSTR = ins.M_REFERENCE
left join RT_INDEX_DBF ind on ins.M_INDEX = ind.M_INDEX
left join CM_ASSET_DBF ass on ofut.M_ASSET = ass.M_REFERENCE
left join CM_ATYPE_DBF atp on ass.M_TYPE = atp.M_REFERENCE

where ofut.M_LISTED = 64
order by ofut.M_LABEL, qot.M_LABEL