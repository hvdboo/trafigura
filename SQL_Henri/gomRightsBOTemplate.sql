select gbl.M_LABEL GBL_TMPL, rgt.M_LABEL BO_TMPL, tre.M_LABEL TYPO_GROUP, 
nod.M_LABEL TYPO_NODE, pfl.M_LABEL RGTH_PROFILE
from STP_RGH_TPL_BO_DBF rgt
left join STP_RGH_TREE_DBF tre on rgt.M_TREE = tre.M_REFERENCE
left join STP_RGH_NOD_PFL_DBF ass on rgt.M_REFERENCE = ass.M_BO
left join STP_RGH_NODE_DBF nod on ass.M_NODE = nod.M_REFERENCE
left join STP_RGH_TPL_PFL_DBF pfl on ass.M_PFL = pfl.M_REFERENCE
left join STP_RGH_GBL2BO_DBF ctn on rgt.M_REFERENCE = ctn.M_REF
left join STP_RGH_TPL_GBL_DBF gbl on ctn.M_CTN = gbl.M_REFERENCE
order by GBL_TMPL, BO_TMPL, TYPO_GROUP, TYPO_NODE, RGTH_PROFILE
