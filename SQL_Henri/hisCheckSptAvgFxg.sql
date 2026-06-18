-- LBMA, AU LBMA (B840046_HBS), P137 = 'AM', P371 = 'MEAN', P373 = 'PM'
select 
to_char(hb.M_DATE,'YYYY-MM-DD') MKTDAT, 
rtrim(pub.M_LABEL) ARC, 
-- rtrim(ind.M_INDEX) IND,
rtrim(ind.M_IND_LAB) IND, 
-- ind.M_REFERENCE INDREF,
round(hb.M_P137,6) H_AM, round(hb.M_P373,6) H_PM, round(hb.M_P371,6) H_MEAN,
-- to_char(ha1.M_START_CALC,'YYYY-MM-DD') AVGFST, to_char(ha1.M_END_CALC,'YYYY-MM-DD') AVGLST, 
ha1.M_VALUE A_AM, ha2.M_VALUE A_PM, ha3.M_VALUE A_MEAN

from B840046_HBS hb
left join H840046_H1S hh on hb.M_KEYID = hh.M_KEYID
left join RT_INDEX_DBF ind on trim(hh.M_KEY0) = trim(ind.M_INDEX)
left join CMC_QUOT_DBF qot on ind.M_COM_QUOT = qot.M_REFERENCE
left join CM_MKT_DBF pub on qot.M_PUBLI = pub.M_REFERENCE
left join HS034217_DBF ha1 on (hb.M_DATE = ha1.M_START_CALC and hb.M_DATE = ha1.M_END_CALC and ha1.M_INDEX = '8778' and ha1.M_FORMULA = 'P137') 
left join HS034217_DBF ha2 on (hb.M_DATE = ha2.M_START_CALC and hb.M_DATE = ha2.M_END_CALC and ha2.M_INDEX = '8778' and ha2.M_FORMULA = 'P373')
left join HS034217_DBF ha3 on (hb.M_DATE = ha3.M_START_CALC and hb.M_DATE = ha3.M_END_CALC and ha3.M_INDEX = '8778' and ha3.M_FORMULA = 'P371') 

where 
trim(hh.M_KEY0) = '571     728' and
hb.M_DATE >= :DATFST and 
hb.M_DATE <= :DATLST

order by MKTDAT