select 
to_char(pc.M_DATE,'YYYY-MM-DD') SYSDAT,
to_char(asgh.M__DATE_,'YYYY-MM-DD') MKDDAT,
rtrim(fys.M_LABEL) PRODUCT, rtrim(qly.M_LABEL) QUALITY, 
rtrim(loc.M_LABEL) LOCATION, 
-- lar.M_LABEL REGION, lto.M_LABEL MARCHE,
rtrim(trm.M_LABEL) TERM, rtrim(asgb.M_CURRENCY) CUR,
asgb.M_INDEX IND,
rtrim(ind.M_IND_LAB) SPOT
from ASGPRDB_DBF asgb
left join TRN_PC_DBF pc on 1 = 1
left join ASGPRDH_DBF asgh on asgb.M__INDEX_ = asgh.M__INDEX_
left join CM_PHYS_DBF fys on asgb.M_PRODUCT = fys.M_REFERENCE
left join CM_QUALITY_DBF qly on asgb.M_QUALITY = qly.M_REFERENCE
left join CM_LOCAT_DBF loc on asgb.M_LOCATION = loc.M_REFERENCE
left join CM_LOCAT_DBF lar on loc.M_AREA = lar.M_REFERENCE
left join CM_LOCAT_DBF lto on loc.M_TO = lto.M_REFERENCE
left join CMC_DLV_TRM_DBF trm on asgb.M_DLV_TERM = trm.M_REFERENCE
left join RT_INDEX_DBF ind on asgb.M_INDEX = ind.M_INDEX
left join CM_MKTSR_DBF hsr on asgb.M_SERIE = hsr.M_SERIE

-- where asgh.M__DATE_ = pc.M_DATE

order by PRODUCT, QUALITY, LOCATION, TERM, CUR, MKDDAT