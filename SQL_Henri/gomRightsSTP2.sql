
select
GRP.M_LABEL     as UserGroup,
tpl.M_LABEL     as GlobalTemplate,
tplbo.M_TYPE    as BusObjType,
tplbo.M_LABEL   as BusObjTemplate,
tplbo.M_TREE    as BusObjTypologyLink,
tree.M_LABEL    as GroupingTemplate,
nodes.M_LABEL   as TypologyGroup
 
from      TRN_GRPD_DBF GRP -- USER GROUPS
left join GRP_STP_DBF STP           on GRP.M_REFERENCE=STP.M_GRP_REF --USER GROUP TO STP MAPPING
left join STP_RGH_TPL_GBL_DBF tpl   on tpl.M_REFERENCE = STP.M_RIGHT_DATA -- Global rights templates
left join STP_RGH_GBL2BO_DBF glb2bo on glb2bo.M_CTN = tpl.M_REFERENCE -- Links global template to BO template
left join STP_RGH_TPL_BO_DBF tplbo  on tplbo.M_REFERENCE = glb2bo.M_REF -- BO template
left join STP_RGH_TPL_PFL_DBF pfl   on pfl.M_REFERENCE = tplbo.M_PROFILE -- Links the BO object to the typology tree nodes
left join STP_RGH_TREE_DBF tree     on tree.M_REFERENCE = tplbo.M_TREE -- Typology group
left join STP_RGH_NODE_DBF nodes    on nodes.M_TREE = tree.M_REFERENCE -- Rights profile of the typology group
left join STP_RGH_NOD_PFL_DBF nodpf on tplbo.M_REFERENCE = nodpf.M_BO and nodpf.M_PFL = pfl.M_REFERENCE --Link typology profile nodes to the profiles
where GRP.M_LABEL like 'FO%'
and tplbo.M_TYPE in( 1,3) -- Contract/package and contract/package events
and nodes.M_TYPE = 1 -- Folder
order by 1,2
