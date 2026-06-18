select typ.M_LABEL, rcol.M_CTITLE, col.M_TITLE 
from RTG_TYP_DBF typ,
RTG_RCOL_DBF rcol,
RTG_COL_DBF col
where 
m_typid = typ.M_ID and
rcol.M_COLID = col.M_ID 
and rcol.M_CTITLE <> col.M_TITLE