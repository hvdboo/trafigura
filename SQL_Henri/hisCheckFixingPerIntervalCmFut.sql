select 
to_char(hb.M_DATE,'YYYY-MM-DD') MKTDAT, 
rtrim(pub.M_LABEL) ARC, 
rtrim(cmfut.M_LABEL) FUT, 
rtrim(cmfqot.M_LABEL) QOT,
rtrim(matset.M_LABEL) MATSET,
rtrim(mat.M_LABEL) MAT,
rtrim(hsr.M_LABEL) HSR,
round(hb.M_P12,6) HSR0, null HSR1, null HSR2

from B799868_HBS hb
left join H799868_H1S hh on hb.M_KEYID = hh.M_KEYID
left join CM_FMAT1_DBF mat on trim(hh.M_KEY0) = to_char(mat.M_REFERENCE)
left join CM_FMAT_DBF matset on mat.M_FMAT_ID = matset.M_REFERENCE
left join RT_GROUP_DBF arc on '799868' = rtrim(arc.M_HISFILE)
left join CM_FUT_DBF cmfut on trim(substr(arc.M_GRP_DESC,1,10)) = to_char(cmfut.M_REFERENCE) and arc.M_GRP_TYPE in (3, 7, 8)
left join CMC_QUOT_DBF cmfqot on trim(substr(arc.M_GRP_DESC,11,11)) = to_char(cmfqot.M_REFERENCE) and arc.M_GRP_TYPE in (3, 7, 8)
left join CM_MKT_DBF pub on cmfqot.M_PUBLI = pub.M_REFERENCE
left join CM_MKTSR_DBF hsr on (pub.M_REFERENCE = hsr.M_REFERENCE and hsr.M_SERIE = 12) 

where
hb.M_DATE >= :DATFST and 
hb.M_DATE <= :DATLST