select 
--nod0.M_TREE,
rtrim(tre.M_LABEL)  TREE,
rtrim(fol1.M_LABEL) LEVLAB1,
rtrim(fol0.M_LABEL) LEVLAB0,
rtrim(fol0.M_DESC)  LEVDES0

from CSF_NODE_DBF nod0
left join CSF_TREE_DBF tre on nod0.M_TREE = tre.M_REFERENCE
left join CLASS_MAPPING_DBF clt on tre.M_NODE_CLASS = clt.M_ID
left join CLASS_MAPPING_DBF cln on nod0.M_OBJ_CLASS = cln.M_ID
left join CSF_NODE_DBF nod1 on nod0.M_FATHER_ID = nod1.M_ID
left join CSF_FOLDER_DBF fol0 on (nod0.M_OBJ_REF = fol0.M_REFERENCE and nod0.M_OBJ_CLASS = 'MTpFC44943')
left join CSF_FOLDER_DBF fol1 on (nod1.M_OBJ_REF = fol1.M_REFERENCE and nod1.M_OBJ_CLASS = 'MTpFC44943')
-- MTpFC44943 => mxSystemClassificationIFOLDER

where nod0.M_TREE = 102 and nod0.M_FATHER_ID > 0
order by LEVLAB1, LEVLAB0
