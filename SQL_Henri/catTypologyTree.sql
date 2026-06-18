select 
--nod0.M_TREE,
case nod1.M_OBJ_CLASS
when 'MTpFC44943' then rtrim(fol1.M_LABEL)
when '1.504' then rtrim(typ1.M_LABEL) else null end LEV1,
case nod0.M_OBJ_CLASS
when 'MTpFC44943' then rtrim(fol0.M_LABEL)
when '1.504' then rtrim(typ0.M_LABEL) else null end LEV0, 
case typ0.M_STATUS
when 0 then 'Active'
when 1 then 'Inactive' 
when 2 then 'Suspended' end STATUS

from CSF_NODE_DBF nod0
left join CSF_TREE_DBF tre on nod0.M_TREE = tre.M_REFERENCE
left join CLASS_MAPPING_DBF clt on tre.M_NODE_CLASS = clt.M_ID
left join CLASS_MAPPING_DBF cln on nod0.M_OBJ_CLASS = cln.M_ID
left join CSF_NODE_DBF nod1 on nod0.M_FATHER_ID = nod1.M_ID
left join CSF_FOLDER_DBF fol0 on (nod0.M_OBJ_REF = fol0.M_REFERENCE and nod0.M_OBJ_CLASS = 'MTpFC44943')
left join CSF_FOLDER_DBF fol1 on (nod1.M_OBJ_REF = fol1.M_REFERENCE and nod1.M_OBJ_CLASS = 'MTpFC44943')
left join TYPOLOGY_DBF typ0 on (nod0.M_OBJ_REF = typ0.M_REFERENCE and nod0.M_OBJ_CLASS = '1.504')
left join TYPOLOGY_DBF typ1 on (nod1.M_OBJ_REF = typ1.M_REFERENCE and nod1.M_OBJ_CLASS = '1.504')

where nod0.M_TREE = 6 and fol1.M_LABEL <> 'Typologies'
order by LEV1, LEV0