select 
to_char(hb.M_DATE,'YYYY-MM-DD') MKTDAT, 
rtrim(pub.M_LABEL) ARC, 
-- rtrim(ind.M_IND_LAB) IND,
rtrim(cmi.M_LABEL) FUT,
rtrim(qot.M_LABEL) QOT,
rtrim(ind.M_UECF)  SHFT,
rtrim(substr(ind.M_IND_LAB,8,6)) MAT,
rtrim(hsr.M_LABEL) HSR,
case hsr.M_SERIE
when  12 then round(hb.M_P12 ,2)
when 102 then round(hb.M_P102,2)
when 103 then round(hb.M_P103,2)
when 172 then round(hb.M_P172,2) else null end HIS

from B469833_HBS hb
left join H469833_H1S hh on hb.M_KEYID = hh.M_KEYID
left join RT_INDEX_DBF ind on trim(hh.M_KEY0) = trim(ind.M_INDEX)
left join CM_INDEX_DBF cmi on ind.M_COM_FUT = cmi.M_REFERENCE
left join CMC_QUOT_DBF qot on ind.M_COM_QUOT = qot.M_REFERENCE
left join CM_MKT_DBF pub on qot.M_PUBLI = pub.M_REFERENCE
left join CM_MKTSR_DBF hsr on pub.M_REFERENCE = hsr.M_REFERENCE

where
to_char(hb.M_DATE,'YYYYMMDD') >= :DATFST and 
to_char(hb.M_DATE,'YYYYMMDD') <= :DATLST

order by FUT, SHFT, HSR
