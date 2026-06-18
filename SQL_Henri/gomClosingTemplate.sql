select tmpl.M_LABEL LABEL, tmpl.M_DESC DESCRIPTION,
flt.M_LABEL ACCEPT, rgt.M_LABEL RIGHTS
from EM_CFGT_DBF tmpl
left join EM_FLT_DBF flt on tmpl.M_CLOSE_DOWN = flt.M_REFERENCE
left join EM_RGT_DBF rgt on tmpl.M_RIGHTS = rgt.M_REFERENCE