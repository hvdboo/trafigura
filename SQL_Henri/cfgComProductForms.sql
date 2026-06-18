select 
rtrim(ast.M_LABEL) ASSTYP,
rtrim(ass.M_LABEL) ASSLAB,
rtrim(ass.M_DESC) ASSDES,
rtrim(typ.M_LABEL) PHYTYP,
rtrim(phy.M_LABEL) PHYLAB,
-- rtrim(phy.M_DESC) PHYDES,
rtrim(frm.M_LABEL) FRMLAB,
rtrim(frm.M_DESC) FRMDES,
rtrim(qlydft.M_LABEL) QLYDFT,
rtrim(frmdft.M_LABEL) FRMDFT, 
rtrim(trm.M_LABEL) TRMDFT,
rtrim(udf.M_SRDGUID) SRD

from CM_FORM_DBF frm
left join CM_FORMMAP_PHYS_DBF frmmap on frm.M_REFERENCE = frmmap.M_FORM_REF
left join CM_PHYS_DBF phy on frmmap.M_PHYS_REF = phy.M_REFERENCE
left join CM_PTYPE_DBF typ on phy.M_TYPE = typ.M_REFERENCE
left join TABLE#DATA#PRODUCTS_DBF udf on phy.M_REFERENCE = udf.M_REFERENCE
left join CM_ASSET_DBF ass on substr(udf.M_ASSET,1,4) = substr(ass.M_LABEL,1,4)
left join CM_ATYPE_DBF ast on ass.M_TYPE = ast.M_REFERENCE
left join CM_QUALITY_DBF qlydft on phy.M_DEF_QUAL = qlydft.M_REFERENCE 
left join CM_FORM_DBF frmdft on phy.M_DEF_FORM = frmdft.M_REFERENCE
left join CMC_DLV_TRM_DBF trm on phy.M_DEF_DLV_TERM = trm.M_REFERENCE

order by ASSTYP, ASSLAB, PHYTYP, PHYLAB, FRMLAB