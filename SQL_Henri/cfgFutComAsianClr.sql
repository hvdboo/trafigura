select 	
case fut.M_LISTED
when  1 then 'Future'
when  2 then 'Forward'
when 16 then 'Cleared Swap'
when 32 then 'Cleared Asian'
when 64 then 'Listed option' end NATURE,
rtrim(fut.M_LABEL) LABEL, rtrim(fut.M_DESC) DESCRIPTION, 
case fut.M_INS_MODE
when 0 then 'Custom'
when 1 then 'Simple' end as CFG_MOD,
case fut.M_INS_MODE
when 0 then rtrim(ins.M_INSTR)
when 1 then rtrim(ind.M_IND_LAB) end INSTRUMENT,
case fut.M_PRC_EVAL
when 0 then 'Marked to market'
when 1 then 'Theoretical' end as EVAL,
case fut.M_MCALL_SYS	
when 0 then 'No'
when 1 then 'Yes' end MC,
case fut.M_IGN_DISC
when 0 then 'No'
when 1 then 'Yes' end IGN_DISC,
case fut.M_NETTING_ALLOWED
when 0 then 'No'
when 1 then 'Yes' end NETTING,
'Asian' STYLE,
case fut.M_EXR_MODE
when 0 then 'Cash settlement' 
when 1 then 'Delivery' else null end EXR_MOD,
rtrim(futg.M_LABEL) EXR_FUT,
fut.M_QTY LOTSIZE, 
rtrim(fmat.M_LABEL) as MAT_SET,
case fut.M_OP_OTCZDAT 	
when 0 then 'Trade date'
when 1 then 'Maturity date' else null end as PRM_DAT, 
rtrim(fut.M_OPREM_OTC) PRM_SHIFT, 
case fut.M_OPTION_SETTL_FLOW_DATE 	
when 0 then 'Exercise date' else null end as STL_DAT,
rtrim(fut.M_ODELIV_OTC) STL_SHIFT, 


rtrim(qotf.M_LABEL) FWD_QUOTE,
rtrim(qot.M_LABEL) QUOTATION,
rtrim(pub.M_LABEL) PUBLICATION, rtrim(qot.M_TRAD_SMB) SYMBOL,
qot.M_CURR CUR,  
rtrim(uniq.M_LABEL) UNIT, rtrim(unid.M_LABEL) UNIT_DLV,
rtrim(ast.M_LABEL) ATYPE, rtrim(ass.M_LABEL) ASSET
from CM_FUT_DBF fut
left join CM_ASSET_DBF ass on fut.M_ASSET = ass.M_REFERENCE
left join CM_ATYPE_DBF ast on ass.M_TYPE = ast.M_REFERENCE
left join CMC_QUOT_DBF qotf on fut.M_QUOT_FWD = qotf.M_REFERENCE 
left join RT_INSGN_DBF ins on fut.M_CM_INSTR = ins.M_GEN_NUM
left join CM_FMAT_DBF fmat on fut.M_FUT_MAT = fmat.M_REFERENCE
left join CMC_QUOT_DBF qot on fut.M_QUOT_SET = qot.M_SET
left join CM_UNIT_DBF uniq on qot.M_UNIT = uniq.M_REFERENCE
left join CM_UNIT_DBF unid on qot.M_QTY_UNIT = unid.M_REFERENCE
left join CM_MKT_DBF pub on qot.M_PUBLI = pub.M_REFERENCE 
left join CM_OMAT_DBF omat on fut.M_OPT_MAT = omat.M_REFERENCE
left join CMC_MGEN_DBF mgen on fut.M_CM_INSTR = mgen.M_REFERENCE
left join RT_INDEX_DBF ind on mgen.M_INDEX = ind.M_INDEX
left join CMC_QUOT_DBF indqot on ind.M_COM_QUOT = indqot.M_REFERENCE
left join RT_INDEX_DBF und on ind.M_UNDRL=und.M_INDEX
left join CMC_QUOT_DBF undqot on und.M_COM_QUOT = undqot.M_REFERENCE
left join CM_FUT_DBF futg on fut.M_EXERCIZE_GENERATED_FUTURE = futg.M_REFERENCE

where 
fut.M_LISTED = 32
-- and fut.M_REFERENCE in (571, 448)

order by fut.M_LABEL, qot.M_LABEL