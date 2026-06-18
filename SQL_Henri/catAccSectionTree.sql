select 
--nod0.M_TREE,
--rtrim(substr(fol3.M_LABEL, 4,40)) ASSET,
rtrim(substr(fol2.M_LABEL, 1,40)) DIVISION,
rtrim(substr(fol1.M_LABEL, 1,40)) STREAM,
rtrim(accsec.M_DESC)  MSTDSK,
rtrim(accsec.M_LABEL) ORACLE,
rtrim(udf.M_BZL)      BUSINESSLINE,
udf.M_SEQ SEQ

from CSF_NODE_DBF nod0
left join CSF_TREE_DBF tre on nod0.M_TREE = tre.M_REFERENCE
left join CLASS_MAPPING_DBF clt on tre.M_NODE_CLASS = clt.M_ID
left join CLASS_MAPPING_DBF cln on nod0.M_OBJ_CLASS = cln.M_ID
left join CSF_NODE_DBF nod1 on nod0.M_FATHER_ID = nod1.M_ID
left join CSF_NODE_DBF nod2 on nod1.M_FATHER_ID = nod2.M_ID
left join CSF_NODE_DBF nod3 on nod2.M_FATHER_ID = nod3.M_ID
left join CSF_FOLDER_DBF fol0 on (nod0.M_OBJ_REF = fol0.M_REFERENCE and nod0.M_OBJ_CLASS = 'MTpFC44943')
left join CSF_FOLDER_DBF fol1 on (nod1.M_OBJ_REF = fol1.M_REFERENCE and nod1.M_OBJ_CLASS = 'MTpFC44943')
left join CSF_FOLDER_DBF fol2 on (nod2.M_OBJ_REF = fol2.M_REFERENCE and nod2.M_OBJ_CLASS = 'MTpFC44943')
left join CSF_FOLDER_DBF fol3 on (nod3.M_OBJ_REF = fol3.M_REFERENCE and nod3.M_OBJ_CLASS = 'MTpFC44943')
left join TRN_ACSC_DBF accsec on (nod0.M_OBJ_REF = accsec.M_REFERENCE and nod0.M_OBJ_CLASS = 'MDkZb35207')
left join TABLE#DATA#ACCSECTI_DBF udf on rtrim(accsec.M_LABEL) = rtrim(udf.M_LABEL)

where 1 = 1
and nod0.M_TREE = 110
and nod0.M_OBJ_CLASS = 'MDkZb35207'

order by udf.M_SEQ