select 
rtrim(lut.M_LABEL) LUT, 
rtrim(hdr.M_LABEL) FOLDER,
rtrim(tbl.M_DGPTYPE) TYP,
rtrim(tbl.M_DGMODEL) MODEL, 
'>' TGT,
rtrim(tbl.M_DGMXLABEL) MX_LABEL,
rtrim(tbl.M_DGPUBLICAT) PUB,
rtrim(tbl.M_DGQLABEL) QUOTE,
rtrim(tbl.M_DGSEP) SEP,
rtrim(tbl.M_DGTENOR) TENOR,
rtrim(tbl.M_DGPROFILE) PROFIL,
rtrim(tbl.M_DGMATFOR) MATFRM,
rtrim(tbl.M_DGGENERAT) GEN,
rtrim(tbl.M_DGDIVIDE) DIV,
rtrim(tbl.M_DGFOLDER) FOLDER,
rtrim(tbl.M_DGCMPSITE) COMPO,
rtrim(tbl.M_DGPUBDATE) PUBDAT

from UDTB237_DBF tbl
left join UDTH237_DBF hdr on tbl.M__INDEX_ = hdr.M__INDEX_
left join RTG_TYP_DBF lut on lut.M_HEADER = 'UDTH237'
