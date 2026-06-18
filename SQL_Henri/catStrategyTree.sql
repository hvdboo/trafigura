select 
rtrim(tre.M_LABEL) TREE,
case nod4.M_OBJ_CLASS 
when 'MTpFC44943' then rtrim(fol4.M_LABEL) 
when 'MUkLf74143' then rtrim(stg4.M_LABEL) else null end LEV4,
case nod3.M_OBJ_CLASS 
when 'MTpFC44943' then rtrim(fol3.M_LABEL) 
when 'MUkLf74143' then rtrim(stg3.M_LABEL) else null end LEV3,
case nod2.M_OBJ_CLASS
when 'MTpFC44943' then rtrim(fol2.M_LABEL)
when 'MUkLf74143' then rtrim(stg2.M_LABEL) else null end LEV2,
case nod1.M_OBJ_CLASS
when 'MTpFC44943' then rtrim(fol1.M_LABEL)
when 'MUkLf74143' then rtrim(stg1.M_LABEL) else null end LEV1,
case nod0.M_OBJ_CLASS
when 'MTpFC44943' then rtrim(fol0.M_LABEL)
when 'MUkLf74143' then rtrim(stg0.M_LABEL) else null end LEV0

from CSF_NODE_DBF nod0
left join CSF_TREE_DBF tre on nod0.M_TREE = tre.M_REFERENCE
left join TRN_STGT_DBF stgtre on tre.M_REFERENCE = stgtre.M_TREE
left join CLASS_MAPPING_DBF clt on tre.M_NODE_CLASS = clt.M_ID
left join CLASS_MAPPING_DBF cln on nod0.M_OBJ_CLASS = cln.M_ID
left join CSF_NODE_DBF nod1 on nod0.M_FATHER_ID = nod1.M_ID
left join CSF_NODE_DBF nod2 on nod1.M_FATHER_ID = nod2.M_ID
left join CSF_NODE_DBF nod3 on nod2.M_FATHER_ID = nod3.M_ID
left join CSF_NODE_DBF nod4 on nod3.M_FATHER_ID = nod4.M_ID
left join CSF_FOLDER_DBF fol0 on (nod0.M_OBJ_REF = fol0.M_REFERENCE and nod0.M_OBJ_CLASS = 'MTpFC44943')
left join CSF_FOLDER_DBF fol1 on (nod1.M_OBJ_REF = fol1.M_REFERENCE and nod1.M_OBJ_CLASS = 'MTpFC44943')
left join CSF_FOLDER_DBF fol2 on (nod2.M_OBJ_REF = fol2.M_REFERENCE and nod2.M_OBJ_CLASS = 'MTpFC44943')
left join CSF_FOLDER_DBF fol3 on (nod3.M_OBJ_REF = fol3.M_REFERENCE and nod3.M_OBJ_CLASS = 'MTpFC44943')
left join CSF_FOLDER_DBF fol4 on (nod4.M_OBJ_REF = fol4.M_REFERENCE and nod4.M_OBJ_CLASS = 'MTpFC44943')
left join TRN_STGW_DBF stw0 on (nod0.M_OBJ_REF = stw0.M_REFERENCE and nod0.M_OBJ_CLASS = 'MUkLf74143' and stgtre.M_REFERENCE = stw0.M_STG_TREE)
left join TRN_STGW_DBF stw1 on (nod1.M_OBJ_REF = stw1.M_REFERENCE and nod1.M_OBJ_CLASS = 'MUkLf74143' and stgtre.M_REFERENCE = stw1.M_STG_TREE)
left join TRN_STGW_DBF stw2 on (nod2.M_OBJ_REF = stw2.M_REFERENCE and nod2.M_OBJ_CLASS = 'MUkLf74143' and stgtre.M_REFERENCE = stw2.M_STG_TREE)
left join TRN_STGW_DBF stw3 on (nod3.M_OBJ_REF = stw3.M_REFERENCE and nod3.M_OBJ_CLASS = 'MUkLf74143' and stgtre.M_REFERENCE = stw3.M_STG_TREE)
left join TRN_STGW_DBF stw4 on (nod4.M_OBJ_REF = stw4.M_REFERENCE and nod4.M_OBJ_CLASS = 'MUkLf74143' and stgtre.M_REFERENCE = stw4.M_STG_TREE)
left join TRN_STGD_DBF stg0 on stw0.M_STRATEGY = stg0.M_REFERENCE
left join TRN_STGD_DBF stg1 on stw1.M_STRATEGY = stg1.M_REFERENCE
left join TRN_STGD_DBF stg2 on stw2.M_STRATEGY = stg2.M_REFERENCE
left join TRN_STGD_DBF stg3 on stw3.M_STRATEGY = stg3.M_REFERENCE
left join TRN_STGD_DBF stg4 on stw4.M_STRATEGY = stg4.M_REFERENCE

where tre.M_NODE_CLASS in ('MUkLf74143')

order by TREE, LEV4, LEV3, LEV2, LEV1, LEV0
