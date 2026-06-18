select 
rtrim(loctyp.M_LABEL) TYP,
rtrim(loc.M_LABEL) LAB, 
rtrim(loc.M_DESC)  DES, 
rtrim(tmz.M_LABEL) TMZ,
rtrim(loc.M_C_LAT) LAT,
rtrim(loc.M_C_LON) LON,
rtrim(lar.M_LABEL) AREA,
rtrim(lfr.M_LABEL) R_FROM,
rtrim(lto.M_LABEL) R_TO,
loc.M_REFERENCE REF

from CM_LOCAT_DBF loc
left join CM_LTYPE_DBF loctyp on loc.M_TYPE = loctyp.M_REFERENCE  
left join DAT_TZONE_DBF tmz on loc.M_TIME_ZONE = tmz.M_REFERENCE
left join TRN_CPDF_DBF own on loc.M_OWNER = own.M_ID
left join TRN_CPDF_DBF ops on loc.M_HOLDER = ops.M_ID
left join CM_LOCAT_DBF lar on loc.M_AREA = lar.M_REFERENCE
left join CM_LOCAT_DBF lfr on loc.M_FROM = lfr.M_REFERENCE
left join CM_LOCAT_DBF lto on loc.M_TO = lto.M_REFERENCE

order by TYP, LAB