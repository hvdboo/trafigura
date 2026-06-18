select 
rtrim(ast.M_LABEL) ASSTYP,
rtrim(ass.M_LABEL) ASSLAB,
rtrim(ass.M_DESC)  ASSDES,
rtrim(typ.M_LABEL) PHYTYP,
rtrim(phy.M_LABEL) PHYLAB,
rtrim(phy.M_DESC)  PHYDES,
rtrim(qly.M_LABEL) QLY, 
rtrim(frm.M_LABEL) FRM, 
rtrim(trm.M_LABEL) TRM,
case phy.M_GENSTOCK
when 0 then 'Closing'
when 1 then 'Spot' else null end PC_EVAL,
case phy.M_GENDLV
when 0 then 'None'
when 1 then 'Deliv' else null end DLV,
case phy.M_PRODUCT_DENOMINATION
when 0 then 'Net amount'
when 1 then 'Gross amount' else null end DENOM,
rtrim(udf.M_CLUSTER) CLUS,
rtrim(udf.M_RMDLAB)  RMD,
rtrim(udf.M_EMR_CM1) EMIRCL1,
rtrim(udf.M_EMR_CM2) EMIRCL2,
rtrim(udf.M_EMR_CM3) EMIRCL3,
rtrim(udf.M_SRDGUID)    SRDPHY,
rtrim(udf.M_SRD_MARKET) SRDMKT,
rtrim(udf.M_SRD_OPTAME) SRDPLI_OPA,
rtrim(udf.M_SRD_OPTEUR) SRDPLI_OPE,
rtrim(udf.M_SEQ) PHYSEQ,
phy.M_REFERENCE  PHYUID

from CM_PHYS_DBF phy
left join CM_PTYPE_DBF typ on phy.M_TYPE = typ.M_REFERENCE
left join TABLE#DATA#PRODUCTS_DBF udf on phy.M_REFERENCE = udf.M_REFERENCE
left join CM_ASSET_DBF ass on substr(udf.M_ASSET,1,4) = substr(ass.M_LABEL,1,4)
left join CM_ATYPE_DBF ast on ass.M_TYPE = ast.M_REFERENCE
left join CM_QUALITY_DBF qly on phy.M_DEF_QUAL = qly.M_REFERENCE 
left join CM_FORM_DBF frm on phy.M_DEF_FORM = frm.M_REFERENCE
left join CMC_DLV_TRM_DBF trm on phy.M_DEF_DLV_TERM = trm.M_REFERENCE

--order by ASSTYP, ASSLAB, PHYTYP, PHYLAB
order by PHYSEQ