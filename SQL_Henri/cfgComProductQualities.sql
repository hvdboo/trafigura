select 
rtrim(ast.M_LABEL) ASSTYP,
rtrim(ass.M_LABEL) ASSLAB,
rtrim(ass.M_DESC) ASSDES,
rtrim(typ.M_LABEL) PHYTYP,
rtrim(phy.M_LABEL) PHYLAB,
rtrim(phy.M_DESC) PHYDES,
rtrim(qly.M_LABEL) QLYLAB,
rtrim(qly.M_DESC) QLYDES,
rtrim(qlydft.M_LABEL) QLYDFT,
rtrim(udf.M_SRDGUID) SRD,
rtrim(frm.M_LABEL) FRM, rtrim(trm.M_LABEL) TRM

from CM_QUALITY_DBF qly
left join CM_QUALMAP_PHYS_DBF qlymap on qly.M_REFERENCE = qlymap.M_QUAL_REF
left join CM_PHYS_DBF phy on qlymap.M_PHYS_REF = phy.M_REFERENCE
left join CM_PTYPE_DBF typ on phy.M_TYPE = typ.M_REFERENCE
left join TABLE#DATA#PRODUCTS_DBF udf on phy.M_REFERENCE = udf.M_REFERENCE
left join CM_ASSET_DBF ass on substr(udf.M_ASSET,1,4) = substr(ass.M_LABEL,1,4)
left join CM_ATYPE_DBF ast on ass.M_TYPE = ast.M_REFERENCE
left join CM_QUALITY_DBF qlydft on phy.M_DEF_QUAL = qlydft.M_REFERENCE 
left join CM_FORM_DBF frm on phy.M_DEF_FORM = frm.M_REFERENCE
left join CMC_DLV_TRM_DBF trm on phy.M_DEF_DLV_TERM = trm.M_REFERENCE

order by ASSTYP, ASSLAB, PHYTYP, PHYLAB, QLYLAB