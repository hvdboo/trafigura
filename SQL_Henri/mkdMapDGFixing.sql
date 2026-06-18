select 
rtrim(lut.M_DGMXLABEL) MXLAB,
rtrim(lut.M_DGQLABEL) MXQOT,
case 
when rtrim(substr(lut.M_DGPTYPE,1,8)) = 'COM_SIND' then rtrim(icmqot.M_TRAD_SMB)
when rtrim(lut.M_DGPTYPE) in ('COM_ADJFUT_FIXING','COM_FUT_FIXING','COM_FUT_TFXG','COM_FUTLO_FIXING','COM_FUTTAM_FIXING') then rtrim(fcmqot.M_TRAD_SMB)
else null end MXSYM,
rtrim(lut.M_MATURITY) MAT,
rtrim(lut.M_DGPRICECOL) MXHSR,
rtrim(lut.M_DGPUBLICAT) MXPUB,
rtrim(lut.M_DGARCHGRP) MXARC,
rtrim(lut.M_DGPTYPE) DGTYP, 
rtrim(lut.M_DGMODEL) MODEL,
rtrim(lut.M_DGSEP) DGSEP,
rtrim(lut.M_DGDIVIDE) DGDIV,
rtrim(lut.M_DGMATFOR) MATFMT,
rtrim(lut.M_DGFORMULA) DGFRM,
rtrim(lut.M_DGFOLDER) DGFLD,
rtrim(lut.M_DGCMPSITE) DGCOMPO,
rtrim(lut.M_DGPUBDATE) DGPUBDAT

from UDTB274_DBF lut
left join CM_INDEX_DBF icm on rtrim(lut.M_DGMXLABEL) = rtrim(icm.M_LABEL)
left join CMC_QUOT_DBF icmqot on icm.M_QUOT_FWD = icmqot.M_REFERENCE
left join CM_FUT_DBF fcm on rtrim(lut.M_DGMXLABEL) = rtrim(fcm.M_LABEL)
left join CMC_QUOT_DBF fcmqot on fcm.M_QUOT_FWD = fcmqot.M_REFERENCE

order by DGTYP, MXLAB, MXQOT, MAT
