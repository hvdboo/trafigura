-- FX Fixings
-- BFIX - London 13:00 (HG000058), COL0 ='Fixing'
select 
to_char(hb.M_DATE,'YYYY-MM-DD') MKTDAT, 
rtrim(fxa.M_DESC) ARC,
rtrim(hh.M_KEY0) IND, 
ind.M_REFERENCE INDREF,
round(hb.M_COL0,6) HSR0, null HSR1, null HSR2
from BG000058_HBS hb
left join HG000058_H1S hh on hb.M_KEYID = hh.M_KEYID
left join FX_ARCGR_DBF fxa on 'HG000058' = fxa.M_HIS_FILE
left join RT_INDEX_DBF ind on 'HG000058.HIS' = ind.M_HISFILE and substr(hh.M_KEY0,1,3) = ind.M_CURR1 and substr(hh.M_KEY0,5,3) = ind.M_CURR2
where 
hb.M_DATE >= :DATFST and 
hb.M_DATE <= :DATLST

union

-- BFIX - London 14:00 (HG000057), COL0 ='Fixing'
select 
to_char(hb.M_DATE,'YYYY-MM-DD') MKTDAT, 
rtrim(fxa.M_DESC) ARC,
rtrim(hh.M_KEY0) IND, 
ind.M_REFERENCE INDREF,
round(hb.M_COL0,6) HSR0, null HSR1, null HSR2
from BG000057_HBS hb
left join HG000057_H1S hh on hb.M_KEYID = hh.M_KEYID
left join FX_ARCGR_DBF fxa on 'HG000057' = fxa.M_HIS_FILE
left join RT_INDEX_DBF ind on 'HG000057.HIS' = ind.M_HISFILE and substr(hh.M_KEY0,1,3) = ind.M_CURR1 and substr(hh.M_KEY0,5,3) = ind.M_CURR2
where 
hb.M_DATE >= :DATFST and 
hb.M_DATE <= :DATLST

union

-- COM FX FIXINGS (HG000001), COL0 ='Fixing', COL1 = 'ECB'
select 
to_char(hb.M_DATE,'YYYY-MM-DD') MKTDAT, 
rtrim(fxa.M_DESC) ARC,
rtrim(hh.M_KEY0) IND, 
ind.M_REFERENCE INDREF,
round(hb.M_COL0,6) HSR0, hb.M_COL1 HSR1, null HSR2
from BG000001_HBS hb
left join HG000001_H1S hh on hb.M_KEYID = hh.M_KEYID
left join FX_ARCGR_DBF fxa on 'HG000001' = fxa.M_HIS_FILE
left join RT_INDEX_DBF ind on '000001' = ind.M_HISFILE and substr(hh.M_KEY0,1,3) = ind.M_CURR1 and substr(hh.M_KEY0,5,3) = ind.M_CURR2
where 
hb.M_DATE >= :DATFST and 
hb.M_DATE <= :DATLST

union 

-- MTLE (HG000050), COL0 ='Fixing'
select 
to_char(hb.M_DATE,'YYYY-MM-DD') MKTDAT, 
rtrim(fxa.M_DESC) ARC,
rtrim(hh.M_KEY0) IND, 
ind.M_REFERENCE INDREF,
round(hb.M_COL0,6) HSR0, null HSR1, null HSR2
from BG000050_HBS hb
left join HG000050_H1S hh on hb.M_KEYID = hh.M_KEYID
left join FX_ARCGR_DBF fxa on 'HG000050' = fxa.M_HIS_FILE
left join RT_INDEX_DBF ind on 'HG000050.HIS' = ind.M_HISFILE and substr(hh.M_KEY0,1,3) = ind.M_CURR1 and substr(hh.M_KEY0,5,3) = ind.M_CURR2
where 
hb.M_DATE >= :DATFST and 
hb.M_DATE <= :DATLST

union

-- WMR - London 13:00 (HG000059), COL0 ='Fixing'
select 
to_char(hb.M_DATE,'YYYY-MM-DD') MKTDAT, 
rtrim(fxa.M_DESC) ARC,
rtrim(hh.M_KEY0) IND, 
ind.M_REFERENCE INDREF,
round(hb.M_COL0,6) HSR0, null HSR1, null HSR2
from BG000059_HBS hb
left join HG000059_H1S hh on hb.M_KEYID = hh.M_KEYID
left join FX_ARCGR_DBF fxa on 'HG000059' = fxa.M_HIS_FILE
left join RT_INDEX_DBF ind on 'HG000059.HIS' = ind.M_HISFILE and substr(hh.M_KEY0,1,3) = ind.M_CURR1 and substr(hh.M_KEY0,5,3) = ind.M_CURR2
where 
hb.M_DATE >= :DATFST and 
hb.M_DATE <= :DATLST

union

-- WMR - London 14:00 (HG000055), COL0 ='Fixing'
select 
to_char(hb.M_DATE,'YYYY-MM-DD') MKTDAT, 
rtrim(fxa.M_DESC) ARC,
rtrim(hh.M_KEY0) IND, 
ind.M_REFERENCE INDREF,
round(hb.M_COL0,6) HSR0, null HSR1, null HSR2
from BG000055_HBS hb
left join HG000055_H1S hh on hb.M_KEYID = hh.M_KEYID
left join FX_ARCGR_DBF fxa on 'HG000055' = fxa.M_HIS_FILE
left join RT_INDEX_DBF ind on 'HG000055.HIS' = ind.M_HISFILE and substr(hh.M_KEY0,1,3) = ind.M_CURR1 and substr(hh.M_KEY0,5,3) = ind.M_CURR2
where 
hb.M_DATE >= :DATFST and 
hb.M_DATE <= :DATLST

union

-- COM Spot Fixings
-- BALTIC, FRT BCI USD/DAY.CSZ (B839978_HBS), P158 = 'CLOSING'
select 
to_char(hb.M_DATE,'YYYY-MM-DD') MKTDAT, 
rtrim(pub.M_LABEL) ARC, 
rtrim(ind.M_IND_LAB) IND, 
ind.M_REFERENCE INDREF,
round(hb.M_P158,6) HSR0, null HSR1, null HSR2
from B839978_HBS hb
left join H839978_H1S hh on hb.M_KEYID = hh.M_KEYID
left join RT_INDEX_DBF ind on trim(hh.M_KEY0) = trim(ind.M_INDEX)
left join CMC_QUOT_DBF qot on ind.M_COM_QUOT = qot.M_REFERENCE
left join CM_MKT_DBF pub on qot.M_PUBLI = pub.M_REFERENCE
where 
trim(hh.M_KEY0) = '937    1155' and
hb.M_DATE >= :DATFST and 
hb.M_DATE <= :DATLST

union

-- BALTIC, FRT BPI USD/DAY.PMX (B839978_HBS), P158 = 'CLOSING'
select 
to_char(hb.M_DATE,'YYYY-MM-DD') MKTDAT, 
rtrim(pub.M_LABEL) ARC, 
rtrim(ind.M_IND_LAB) IND, 
ind.M_REFERENCE INDREF,
round(hb.M_P158,6) HSR0, null HSR1, null HSR2
from B839978_HBS hb
left join H839978_H1S hh on hb.M_KEYID = hh.M_KEYID
left join RT_INDEX_DBF ind on trim(hh.M_KEY0) = trim(ind.M_INDEX)
left join CMC_QUOT_DBF qot on ind.M_COM_QUOT = qot.M_REFERENCE
left join CM_MKT_DBF pub on qot.M_PUBLI = pub.M_REFERENCE
where 
trim(hh.M_KEY0) = '1150    1920' and
hb.M_DATE >= :DATFST and 
hb.M_DATE <= :DATLST

union

-- BALTIC, FRT BSI USD/DAY.SMX (B839978_HBS), P158 = 'CLOSING'
select 
to_char(hb.M_DATE,'YYYY-MM-DD') MKTDAT, 
rtrim(pub.M_LABEL) ARC, 
rtrim(ind.M_IND_LAB) IND, 
ind.M_REFERENCE INDREF,
round(hb.M_P158,6) HSR0, null HSR1, null HSR2
from B839978_HBS hb
left join H839978_H1S hh on hb.M_KEYID = hh.M_KEYID
left join RT_INDEX_DBF ind on trim(hh.M_KEY0) = trim(ind.M_INDEX)
left join CMC_QUOT_DBF qot on ind.M_COM_QUOT = qot.M_REFERENCE
left join CM_MKT_DBF pub on qot.M_PUBLI = pub.M_REFERENCE
where 
trim(hh.M_KEY0) = '1152    1924' and
hb.M_DATE >= :DATFST and 
hb.M_DATE <= :DATLST

union

-- BALTIC, FRT CS TCA 5 USD/DAY.CSZ (B839978_HBS), P158 = 'CLOSING'
select 
to_char(hb.M_DATE,'YYYY-MM-DD') MKTDAT, 
rtrim(pub.M_LABEL) ARC, 
rtrim(ind.M_IND_LAB) IND, 
ind.M_REFERENCE INDREF,
round(hb.M_P158,6) HSR0, null HSR1, null HSR2
from B839978_HBS hb
left join H839978_H1S hh on hb.M_KEYID = hh.M_KEYID
left join RT_INDEX_DBF ind on trim(hh.M_KEY0) = trim(ind.M_INDEX)
left join CMC_QUOT_DBF qot on ind.M_COM_QUOT = qot.M_REFERENCE
left join CM_MKT_DBF pub on qot.M_PUBLI = pub.M_REFERENCE
where 
trim(hh.M_KEY0) = '1224    2081' and
hb.M_DATE >= :DATFST and 
hb.M_DATE <= :DATLST

union

-- BALTIC, FRT CS TCA 5 USD/DAY.CSZ (B839978_HBS), P158 = 'CLOSING'
select 
to_char(hb.M_DATE,'YYYY-MM-DD') MKTDAT, 
rtrim(pub.M_LABEL) ARC, 
rtrim(ind.M_IND_LAB) IND,
ind.M_REFERENCE INDREF, 
round(hb.M_P158,6) HSR0, null HSR1, null HSR2
from B839978_HBS hb
left join H839978_H1S hh on hb.M_KEYID = hh.M_KEYID
left join RT_INDEX_DBF ind on trim(hh.M_KEY0) = trim(ind.M_INDEX)
left join CMC_QUOT_DBF qot on ind.M_COM_QUOT = qot.M_REFERENCE
left join CM_MKT_DBF pub on qot.M_PUBLI = pub.M_REFERENCE
where 
trim(hh.M_KEY0) = '1224    2081' and
hb.M_DATE >= :DATFST and 
hb.M_DATE <= :DATLST

union

-- BALTIC, FRT S TCA 10 USD/DAY.SMX (B839978_HBS), P158 = 'CLOSING'
select 
to_char(hb.M_DATE,'YYYY-MM-DD') MKTDAT, 
rtrim(pub.M_LABEL) ARC, 
rtrim(ind.M_IND_LAB) IND,
ind.M_REFERENCE INDREF, 
round(hb.M_P158,6) HSR0, null HSR1, null HSR2
from B839978_HBS hb
left join H839978_H1S hh on hb.M_KEYID = hh.M_KEYID
left join RT_INDEX_DBF ind on trim(hh.M_KEY0) = trim(ind.M_INDEX)
left join CMC_QUOT_DBF qot on ind.M_COM_QUOT = qot.M_REFERENCE
left join CM_MKT_DBF pub on qot.M_PUBLI = pub.M_REFERENCE
where 
trim(hh.M_KEY0) = '1227    2097' and
hb.M_DATE >= :DATFST and 
hb.M_DATE <= :DATLST

union

-- LBMA, AU LBMA (B840046_HBS), P137 = 'AM', P371 = 'MEAN', P373 = 'PM'
select 
to_char(hb.M_DATE,'YYYY-MM-DD') MKTDAT, 
rtrim(pub.M_LABEL) ARC, 
-- rtrim(ind.M_INDEX) IND,
rtrim(ind.M_IND_LAB) IND, 
ind.M_REFERENCE INDREF,
round(hb.M_P137,6) HSR0, round(hb.M_P373,6) HSR1, round(hb.M_P371,6) HSR2
from B840046_HBS hb
left join H840046_H1S hh on hb.M_KEYID = hh.M_KEYID
left join RT_INDEX_DBF ind on trim(hh.M_KEY0) = trim(ind.M_INDEX)
left join CMC_QUOT_DBF qot on ind.M_COM_QUOT = qot.M_REFERENCE
left join CM_MKT_DBF pub on qot.M_PUBLI = pub.M_REFERENCE
where 
trim(hh.M_KEY0) = '571     728' and
hb.M_DATE >= :DATFST and 
hb.M_DATE <= :DATLST

union

-- LBMA SILVER, AG LBMA (B179446_HBS), P179 = 'NOON'
select 
to_char(hb.M_DATE,'YYYY-MM-DD') MKTDAT, 
rtrim(pub.M_LABEL) ARC,
rtrim(ind.M_IND_LAB) IND, 
ind.M_REFERENCE INDREF,
round(hb.M_P179,6) HSR0, null HSR1, null HSR2
from B179446_HBS hb
left join H179446_H1S hh on hb.M_KEYID = hh.M_KEYID
left join RT_INDEX_DBF ind on trim(hh.M_KEY0) = trim(ind.M_INDEX)
left join CMC_QUOT_DBF qot on ind.M_COM_QUOT = qot.M_REFERENCE
left join CM_MKT_DBF pub on qot.M_PUBLI = pub.M_REFERENCE
where 
trim(hh.M_KEY0) = '570     727' and
hb.M_DATE >= :DATFST and 
hb.M_DATE <= :DATLST

union

-- METAL BULLETIN, AL MB USD/MT (B840359_HBS), P642 = 'HIGH', P643 = 'LOW', P644 = 'MEAN'
select 
to_char(hb.M_DATE,'YYYY-MM-DD') MKTDAT, 
rtrim(pub.M_LABEL) ARC,
rtrim(ind.M_IND_LAB) IND, 
ind.M_REFERENCE INDREF,
round(hb.M_P642,6) HSR0, round(hb.M_P643,6) HSR1, round(hb.M_P644,6) HSR2
from B840359_HBS hb
left join H840359_H1S hh on hb.M_KEYID = hh.M_KEYID
left join RT_INDEX_DBF ind on trim(hh.M_KEY0) = trim(ind.M_INDEX)
left join CMC_QUOT_DBF qot on ind.M_COM_QUOT = qot.M_REFERENCE
left join CM_MKT_DBF pub on qot.M_PUBLI = pub.M_REFERENCE
where 
trim(hh.M_KEY0) = '1204    2030' and
hb.M_DATE >= :DATFST and 
hb.M_DATE <= :DATLST

union

-- PLATTS APAG.MKS, HSFO380 SGP C USD/MT (B840429_HBS), P152 = 'HIGH', P119 = 'LOW', P89 = 'MEAN'
select 
to_char(hb.M_DATE,'YYYY-MM-DD') MKTDAT, 
rtrim(pub.M_LABEL) ARC,
rtrim(ind.M_IND_LAB) IND,
ind.M_REFERENCE INDREF, 
round(hb.M_P152,6) HSR0, round(hb.M_P119,6) HSR1, round(hb.M_P89,6) HSR2
from B840429_HBS hb
left join H840429_H1S hh on hb.M_KEYID = hh.M_KEYID
left join RT_INDEX_DBF ind on trim(hh.M_KEY0) = trim(ind.M_INDEX)
left join CMC_QUOT_DBF qot on ind.M_COM_QUOT = qot.M_REFERENCE
left join CM_MKT_DBF pub on qot.M_PUBLI = pub.M_REFERENCE
where 
trim(hh.M_KEY0) = '306     302' and
hb.M_DATE >= :DATFST and 
hb.M_DATE <= :DATLST

union

-- PLATTS EU.MKS, F35 RDAM FB USD/MT (B840453_HBS), P148 = 'HIGH', P115 = 'LOW', P63 = 'MEAN'
select 
to_char(hb.M_DATE,'YYYY-MM-DD') MKTDAT, 
rtrim(pub.M_LABEL) ARC,
rtrim(ind.M_IND_LAB) IND,
ind.M_REFERENCE INDREF, 
round(hb.M_P148,6) HSR0, round(hb.M_P115,6) HSR1, round(hb.M_P63,6) HSR2
from B840453_HBS hb
left join H840453_H1S hh on hb.M_KEYID = hh.M_KEYID
left join RT_INDEX_DBF ind on trim(hh.M_KEY0) = trim(ind.M_INDEX)
left join CMC_QUOT_DBF qot on ind.M_COM_QUOT = qot.M_REFERENCE
left join CM_MKT_DBF pub on qot.M_PUBLI = pub.M_REFERENCE
where 
trim(hh.M_KEY0) = '127     164' and
hb.M_DATE >= :DATFST and 
hb.M_DATE <= :DATLST

union

-- PLATTS MT, AL FOB CME USD/MT (B838469_HBS), P168 = 'HIGH', P169 = 'LOW', P167 = 'MEAN'
select 
to_char(hb.M_DATE,'YYYY-MM-DD') MKTDAT, 
rtrim(pub.M_LABEL) ARC,
rtrim(ind.M_IND_LAB) IND,
ind.M_REFERENCE INDREF,
round(hb.M_P168,6) HSR0, round(hb.M_P169,6) HSR1, round(hb.M_P167,6) HSR2
from B838469_HBS hb
left join H838469_H1S hh on hb.M_KEYID = hh.M_KEYID
left join RT_INDEX_DBF ind on trim(hh.M_KEY0) = trim(ind.M_INDEX)
left join CMC_QUOT_DBF qot on ind.M_COM_QUOT = qot.M_REFERENCE
left join CM_MKT_DBF pub on qot.M_PUBLI = pub.M_REFERENCE
where 
trim(hh.M_KEY0) = '1221    2077' and
hb.M_DATE >= :DATFST and 
hb.M_DATE <= :DATLST

union

-- PLATTS MT, AL JP PRM USD/MT (B838469_HBS), P168 = 'HIGH', P169 = 'LOW', P167 = 'MEAN'
select 
to_char(hb.M_DATE,'YYYY-MM-DD') MKTDAT, 
rtrim(pub.M_LABEL) ARC,
rtrim(ind.M_IND_LAB) IND,
ind.M_REFERENCE INDREF,
round(hb.M_P168,6) HSR0, round(hb.M_P169,6) HSR1, round(hb.M_P167,6) HSR2
from B838469_HBS hb
left join H838469_H1S hh on hb.M_KEYID = hh.M_KEYID
left join RT_INDEX_DBF ind on trim(hh.M_KEY0) = trim(ind.M_INDEX)
left join CMC_QUOT_DBF qot on ind.M_COM_QUOT = qot.M_REFERENCE
left join CM_MKT_DBF pub on qot.M_PUBLI = pub.M_REFERENCE
where 
trim(hh.M_KEY0) = '1205    2032' and
hb.M_DATE >= :DATFST and 
hb.M_DATE <= :DATLST

union

-- PLATTS MT, AL MW USD/LB (B838469_HBS), P168 = 'HIGH', P169 = 'LOW', P167 = 'MEAN'
select 
to_char(hb.M_DATE,'YYYY-MM-DD') MKTDAT, 
rtrim(pub.M_LABEL) ARC,
rtrim(ind.M_IND_LAB) IND,
ind.M_REFERENCE INDREF, 
round(hb.M_P168,6) HSR0, round(hb.M_P169,6) HSR1, round(hb.M_P167,6) HSR2
from B838469_HBS hb
left join H838469_H1S hh on hb.M_KEYID = hh.M_KEYID
left join RT_INDEX_DBF ind on trim(hh.M_KEY0) = trim(ind.M_INDEX)
left join CMC_QUOT_DBF qot on ind.M_COM_QUOT = qot.M_REFERENCE
left join CM_MKT_DBF pub on qot.M_PUBLI = pub.M_REFERENCE
where 
trim(hh.M_KEY0) = '1219    2064' and
hb.M_DATE >= :DATFST and 
hb.M_DATE <= :DATLST

union

-- PLATTS MT, FE LP SGX USD/DMTU (B838469_HBS), P168 = 'HIGH', P169 = 'LOW', P167 = 'MEAN'
select 
to_char(hb.M_DATE,'YYYY-MM-DD') MKTDAT, 
rtrim(pub.M_LABEL) ARC,
rtrim(ind.M_IND_LAB) IND,
ind.M_REFERENCE INDREF, 
round(hb.M_P168,6) HSR0, round(hb.M_P169,6) HSR1, round(hb.M_P167,6) HSR2
from B838469_HBS hb
left join H838469_H1S hh on hb.M_KEYID = hh.M_KEYID
left join RT_INDEX_DBF ind on trim(hh.M_KEY0) = trim(ind.M_INDEX)
left join CMC_QUOT_DBF qot on ind.M_COM_QUOT = qot.M_REFERENCE
left join CM_MKT_DBF pub on qot.M_PUBLI = pub.M_REFERENCE
where 
trim(hh.M_KEY0) = '1206    2034' and
hb.M_DATE >= :DATFST and 
hb.M_DATE <= :DATLST

union

-- TSI, COAL AUST FOB TSI USD/MT (B030874_HBS), P361 = 'HIGH', P362 = 'LOW', P363 = 'MEAN'
select 
to_char(hb.M_DATE,'YYYY-MM-DD') MKTDAT, 
rtrim(pub.M_LABEL) ARC,
rtrim(ind.M_IND_LAB) IND,
ind.M_REFERENCE INDREF, 
round(hb.M_P361,6) HSR0, round(hb.M_P362,6) HSR1, round(hb.M_P363,6) HSR2
from B030874_HBS hb
left join H030874_H1S hh on hb.M_KEYID = hh.M_KEYID
left join RT_INDEX_DBF ind on trim(hh.M_KEY0) = trim(ind.M_INDEX)
left join CMC_QUOT_DBF qot on ind.M_COM_QUOT = qot.M_REFERENCE
left join CM_MKT_DBF pub on qot.M_PUBLI = pub.M_REFERENCE
where 
trim(hh.M_KEY0) = '1230    2109' and
hb.M_DATE >= :DATFST and 
hb.M_DATE <= :DATLST

union

-- TSI, FE 62 TSI USD/MT (B030874_HBS), P361 = 'HIGH', P362 = 'LOW', P363 = 'MEAN'
select 
to_char(hb.M_DATE,'YYYY-MM-DD') MKTDAT, 
rtrim(pub.M_LABEL) ARC,
rtrim(ind.M_IND_LAB) IND,
ind.M_REFERENCE INDREF, 
round(hb.M_P361,6) HSR0, round(hb.M_P362,6) HSR1, round(hb.M_P363,6) HSR2
from B030874_HBS hb
left join H030874_H1S hh on hb.M_KEYID = hh.M_KEYID
left join RT_INDEX_DBF ind on trim(hh.M_KEY0) = trim(ind.M_INDEX)
left join CMC_QUOT_DBF qot on ind.M_COM_QUOT = qot.M_REFERENCE
left join CM_MKT_DBF pub on qot.M_PUBLI = pub.M_REFERENCE
where 
trim(hh.M_KEY0) = '1142    1889' and
hb.M_DATE >= :DATFST and 
hb.M_DATE <= :DATLST

union

-- Time series
-- LME NBY, AL LME CASH, P102 = 'Settlement'
select
to_char(hb.M_FIX_DATE,'YYYY-MM-DD') MKTDAT, 
rtrim(pub.M_LABEL) ARC,
rtrim(ind.M_IND_LAB) IND,
ind.M_REFERENCE INDREF, 
round(hb.M_VALUE,6) HSR0, null HSR1, null HSR2
from HS790525_DBF hb
left join RT_INDEX_DBF ind on rtrim(hb.M_INDEX) = rtrim(ind.M_INDEX)
left join CMC_QUOT_DBF qot on ind.M_COM_QUOT = qot.M_REFERENCE
left join CM_MKT_DBF pub on qot.M_PUBLI = pub.M_REFERENCE
where 
rtrim(hb.M_INDEX) = '1454' and 
hb.M_FORMULA = 'P102' and 
hb.M_FIX_DATE >= :DATFST and 
hb.M_FIX_DATE <= :DATLST

union

-- LME NBY, AL LME CASH, P103 = 'Ring2_Bid'
select
to_char(hb.M_FIX_DATE,'YYYY-MM-DD') MKTDAT, 
rtrim(pub.M_LABEL) ARC,
rtrim(ind.M_IND_LAB) IND,
ind.M_REFERENCE INDREF, 
round(hb.M_VALUE,6) HSR0, null HSR1, null HSR2
from HS790525_DBF hb
left join RT_INDEX_DBF ind on rtrim(hb.M_INDEX) = rtrim(ind.M_INDEX)
left join CMC_QUOT_DBF qot on ind.M_COM_QUOT = qot.M_REFERENCE
left join CM_MKT_DBF pub on qot.M_PUBLI = pub.M_REFERENCE
where 
rtrim(hb.M_INDEX) = '1454' and 
hb.M_FORMULA = 'P103' and 
hb.M_FIX_DATE >= :DATFST and 
hb.M_FIX_DATE <= :DATLST

union

-- LME NBY, AL LME 3M, P102 = 'Settlement'
select
to_char(hb.M_FIX_DATE,'YYYY-MM-DD') MKTDAT, 
rtrim(pub.M_LABEL) ARC,
rtrim(ind.M_IND_LAB) IND,
ind.M_REFERENCE INDREF, 
round(hb.M_VALUE,6) HSR0, null HSR1, null HSR2
from HS790525_DBF hb
left join RT_INDEX_DBF ind on rtrim(hb.M_INDEX) = rtrim(ind.M_INDEX)
left join CMC_QUOT_DBF qot on ind.M_COM_QUOT = qot.M_REFERENCE
left join CM_MKT_DBF pub on qot.M_PUBLI = pub.M_REFERENCE
where 
rtrim(hb.M_INDEX) = '1453' and 
hb.M_FORMULA = 'P102' and 
hb.M_FIX_DATE >= :DATFST and 
hb.M_FIX_DATE <= :DATLST

union

-- LME NBY, AL LME 3M, P103 = 'Ring2_Bid'
select
to_char(hb.M_FIX_DATE,'YYYY-MM-DD') MKTDAT, 
rtrim(pub.M_LABEL) ARC,
rtrim(ind.M_IND_LAB) IND,
ind.M_REFERENCE INDREF, 
round(hb.M_VALUE,6) HSR0, null HSR1, null HSR2
from HS790525_DBF hb
left join RT_INDEX_DBF ind on rtrim(hb.M_INDEX) = rtrim(ind.M_INDEX)
left join CMC_QUOT_DBF qot on ind.M_COM_QUOT = qot.M_REFERENCE
left join CM_MKT_DBF pub on qot.M_PUBLI = pub.M_REFERENCE
where 
rtrim(hb.M_INDEX) = '1453' and 
hb.M_FORMULA = 'P103' and 
hb.M_FIX_DATE >= :DATFST and 
hb.M_FIX_DATE <= :DATLST

union

-- LME NBY, CU LME CASH, P102 = 'Settlement'
select
to_char(hb.M_FIX_DATE,'YYYY-MM-DD') MKTDAT, 
rtrim(pub.M_LABEL) ARC,
rtrim(ind.M_IND_LAB) IND,
ind.M_REFERENCE INDREF, 
round(hb.M_VALUE,6) HSR0, null HSR1, null HSR2
from HS790525_DBF hb
left join RT_INDEX_DBF ind on rtrim(hb.M_INDEX) = rtrim(ind.M_INDEX)
left join CMC_QUOT_DBF qot on ind.M_COM_QUOT = qot.M_REFERENCE
left join CM_MKT_DBF pub on qot.M_PUBLI = pub.M_REFERENCE
where 
rtrim(hb.M_INDEX) = '1637' and 
hb.M_FORMULA = 'P102' and 
hb.M_FIX_DATE >= :DATFST and 
hb.M_FIX_DATE <= :DATLST

union

-- LME NBY, CU LME CASH, P103 = 'Ring2_Bid'
select
to_char(hb.M_FIX_DATE,'YYYY-MM-DD') MKTDAT, 
rtrim(pub.M_LABEL) ARC,
rtrim(ind.M_IND_LAB) IND,
ind.M_REFERENCE INDREF, 
round(hb.M_VALUE,6) HSR0, null HSR1, null HSR2
from HS790525_DBF hb
left join RT_INDEX_DBF ind on rtrim(hb.M_INDEX) = rtrim(ind.M_INDEX)
left join CMC_QUOT_DBF qot on ind.M_COM_QUOT = qot.M_REFERENCE
left join CM_MKT_DBF pub on qot.M_PUBLI = pub.M_REFERENCE
where 
rtrim(hb.M_INDEX) = '1637' and 
hb.M_FORMULA = 'P103' and 
hb.M_FIX_DATE >= :DATFST and 
hb.M_FIX_DATE <= :DATLST

union

-- LME NBY, CU LME 3M, P102 = 'Settlement'
select
to_char(hb.M_FIX_DATE,'YYYY-MM-DD') MKTDAT, 
rtrim(pub.M_LABEL) ARC,
rtrim(ind.M_IND_LAB) IND,
ind.M_REFERENCE INDREF, 
round(hb.M_VALUE,6) HSR0, null HSR1, null HSR2
from HS790525_DBF hb
left join RT_INDEX_DBF ind on rtrim(hb.M_INDEX) = rtrim(ind.M_INDEX)
left join CMC_QUOT_DBF qot on ind.M_COM_QUOT = qot.M_REFERENCE
left join CM_MKT_DBF pub on qot.M_PUBLI = pub.M_REFERENCE
where 
rtrim(hb.M_INDEX) = '1636' and 
hb.M_FORMULA = 'P102' and 
hb.M_FIX_DATE >= :DATFST and 
hb.M_FIX_DATE <= :DATLST

union

-- LME NBY, CU LME 3M, P103 = 'Ring2_Bid'
select
to_char(hb.M_FIX_DATE,'YYYY-MM-DD') MKTDAT, 
rtrim(pub.M_LABEL) ARC,
rtrim(ind.M_IND_LAB) IND,
ind.M_REFERENCE INDREF, 
round(hb.M_VALUE,6) HSR0, null HSR1, null HSR2
from HS790525_DBF hb
left join RT_INDEX_DBF ind on rtrim(hb.M_INDEX) = rtrim(ind.M_INDEX)
left join CMC_QUOT_DBF qot on ind.M_COM_QUOT = qot.M_REFERENCE
left join CM_MKT_DBF pub on qot.M_PUBLI = pub.M_REFERENCE
where 
rtrim(hb.M_INDEX) = '1636' and 
hb.M_FORMULA = 'P103' and 
hb.M_FIX_DATE >= :DATFST and 
hb.M_FIX_DATE <= :DATLST

union

-- LME NBY, NI LME CASH, P102 = 'Settlement'
select
to_char(hb.M_FIX_DATE,'YYYY-MM-DD') MKTDAT, 
rtrim(pub.M_LABEL) ARC,
rtrim(ind.M_IND_LAB) IND,
ind.M_REFERENCE INDREF, 
round(hb.M_VALUE,6) HSR0, null HSR1, null HSR2
from HS790525_DBF hb
left join RT_INDEX_DBF ind on rtrim(hb.M_INDEX) = rtrim(ind.M_INDEX)
left join CMC_QUOT_DBF qot on ind.M_COM_QUOT = qot.M_REFERENCE
left join CM_MKT_DBF pub on qot.M_PUBLI = pub.M_REFERENCE
where 
rtrim(hb.M_INDEX) = '6054' and 
hb.M_FORMULA = 'P102' and 
hb.M_FIX_DATE >= :DATFST and 
hb.M_FIX_DATE <= :DATLST

union

-- LME NBY, NI LME CASH, P103 = 'Ring2_Bid'
select
to_char(hb.M_FIX_DATE,'YYYY-MM-DD') MKTDAT, 
rtrim(pub.M_LABEL) ARC,
rtrim(ind.M_IND_LAB) IND,
ind.M_REFERENCE INDREF, 
round(hb.M_VALUE,6) HSR0, null HSR1, null HSR2
from HS790525_DBF hb
left join RT_INDEX_DBF ind on rtrim(hb.M_INDEX) = rtrim(ind.M_INDEX)
left join CMC_QUOT_DBF qot on ind.M_COM_QUOT = qot.M_REFERENCE
left join CM_MKT_DBF pub on qot.M_PUBLI = pub.M_REFERENCE
where 
rtrim(hb.M_INDEX) = '6054' and 
hb.M_FORMULA = 'P103' and 
hb.M_FIX_DATE >= :DATFST and 
hb.M_FIX_DATE <= :DATLST

union

-- LME NBY, NI LME 3M, P102 = 'Settlement'
select
to_char(hb.M_FIX_DATE,'YYYY-MM-DD') MKTDAT, 
rtrim(pub.M_LABEL) ARC,
rtrim(ind.M_IND_LAB) IND,
ind.M_REFERENCE INDREF, 
round(hb.M_VALUE,6) HSR0, null HSR1, null HSR2
from HS790525_DBF hb
left join RT_INDEX_DBF ind on rtrim(hb.M_INDEX) = rtrim(ind.M_INDEX)
left join CMC_QUOT_DBF qot on ind.M_COM_QUOT = qot.M_REFERENCE
left join CM_MKT_DBF pub on qot.M_PUBLI = pub.M_REFERENCE
where 
rtrim(hb.M_INDEX) = '6087' and 
hb.M_FORMULA = 'P102' and 
hb.M_FIX_DATE >= :DATFST and 
hb.M_FIX_DATE <= :DATLST

union

-- LME NBY, NI LME 3M, P103 = 'Ring2_Bid'
select
to_char(hb.M_FIX_DATE,'YYYY-MM-DD') MKTDAT, 
rtrim(pub.M_LABEL) ARC,
rtrim(ind.M_IND_LAB) IND,
ind.M_REFERENCE INDREF, 
round(hb.M_VALUE,6) HSR0, null HSR1, null HSR2
from HS790525_DBF hb
left join RT_INDEX_DBF ind on rtrim(hb.M_INDEX) = rtrim(ind.M_INDEX)
left join CMC_QUOT_DBF qot on ind.M_COM_QUOT = qot.M_REFERENCE
left join CM_MKT_DBF pub on qot.M_PUBLI = pub.M_REFERENCE
where 
rtrim(hb.M_INDEX) = '6087' and 
hb.M_FORMULA = 'P103' and 
hb.M_FIX_DATE >= :DATFST and 
hb.M_FIX_DATE <= :DATLST

union 

-- LME NBY, PB LME CASH, P102 = 'Settlement'
select
to_char(hb.M_FIX_DATE,'YYYY-MM-DD') MKTDAT, 
rtrim(pub.M_LABEL) ARC,
rtrim(ind.M_IND_LAB) IND,
ind.M_REFERENCE INDREF, 
round(hb.M_VALUE,6) HSR0, null HSR1, null HSR2
from HS790525_DBF hb
left join RT_INDEX_DBF ind on rtrim(hb.M_INDEX) = rtrim(ind.M_INDEX)
left join CMC_QUOT_DBF qot on ind.M_COM_QUOT = qot.M_REFERENCE
left join CM_MKT_DBF pub on qot.M_PUBLI = pub.M_REFERENCE
where 
rtrim(hb.M_INDEX) = '6061' and 
hb.M_FORMULA = 'P102' and 
hb.M_FIX_DATE >= :DATFST and 
hb.M_FIX_DATE <= :DATLST

union

-- LME NBY, PB LME CASH, P103 = 'Ring2_Bid'
select
to_char(hb.M_FIX_DATE,'YYYY-MM-DD') MKTDAT, 
rtrim(pub.M_LABEL) ARC,
rtrim(ind.M_IND_LAB) IND,
ind.M_REFERENCE INDREF, 
round(hb.M_VALUE,6) HSR0, null HSR1, null HSR2
from HS790525_DBF hb
left join RT_INDEX_DBF ind on rtrim(hb.M_INDEX) = rtrim(ind.M_INDEX)
left join CMC_QUOT_DBF qot on ind.M_COM_QUOT = qot.M_REFERENCE
left join CM_MKT_DBF pub on qot.M_PUBLI = pub.M_REFERENCE
where 
rtrim(hb.M_INDEX) = '6061' and 
hb.M_FORMULA = 'P103' and 
hb.M_FIX_DATE >= :DATFST and 
hb.M_FIX_DATE <= :DATLST

union

-- LME NBY, PB LME 3M, P102 = 'Settlement'
select
to_char(hb.M_FIX_DATE,'YYYY-MM-DD') MKTDAT, 
rtrim(pub.M_LABEL) ARC,
rtrim(ind.M_IND_LAB) IND,
ind.M_REFERENCE INDREF, 
round(hb.M_VALUE,6) HSR0, null HSR1, null HSR2
from HS790525_DBF hb
left join RT_INDEX_DBF ind on rtrim(hb.M_INDEX) = rtrim(ind.M_INDEX)
left join CMC_QUOT_DBF qot on ind.M_COM_QUOT = qot.M_REFERENCE
left join CM_MKT_DBF pub on qot.M_PUBLI = pub.M_REFERENCE
where 
rtrim(hb.M_INDEX) = '6097' and 
hb.M_FORMULA = 'P102' and 
hb.M_FIX_DATE >= :DATFST and 
hb.M_FIX_DATE <= :DATLST

union

-- LME NBY, PB LME 3M, P103 = 'Ring2_Bid'
select
to_char(hb.M_FIX_DATE,'YYYY-MM-DD') MKTDAT, 
rtrim(pub.M_LABEL) ARC,
rtrim(ind.M_IND_LAB) IND,
ind.M_REFERENCE INDREF, 
round(hb.M_VALUE,6) HSR0, null HSR1, null HSR2
from HS790525_DBF hb
left join RT_INDEX_DBF ind on rtrim(hb.M_INDEX) = rtrim(ind.M_INDEX)
left join CMC_QUOT_DBF qot on ind.M_COM_QUOT = qot.M_REFERENCE
left join CM_MKT_DBF pub on qot.M_PUBLI = pub.M_REFERENCE
where 
rtrim(hb.M_INDEX) = '6097' and 
hb.M_FORMULA = 'P103' and 
hb.M_FIX_DATE >= :DATFST and 
hb.M_FIX_DATE <= :DATLST

union

-- LME NBY, SN LME CASH, P102 = 'Settlement'
select
to_char(hb.M_FIX_DATE,'YYYY-MM-DD') MKTDAT, 
rtrim(pub.M_LABEL) ARC,
rtrim(ind.M_IND_LAB) IND,
ind.M_REFERENCE INDREF, 
round(hb.M_VALUE,6) HSR0, null HSR1, null HSR2
from HS790525_DBF hb
left join RT_INDEX_DBF ind on rtrim(hb.M_INDEX) = rtrim(ind.M_INDEX)
left join CMC_QUOT_DBF qot on ind.M_COM_QUOT = qot.M_REFERENCE
left join CM_MKT_DBF pub on qot.M_PUBLI = pub.M_REFERENCE
where 
rtrim(hb.M_INDEX) = '6059' and 
hb.M_FORMULA = 'P102' and 
hb.M_FIX_DATE >= :DATFST and 
hb.M_FIX_DATE <= :DATLST

union

-- LME NBY, SN LME CASH, P103 = 'Ring2_Bid'
select
to_char(hb.M_FIX_DATE,'YYYY-MM-DD') MKTDAT, 
rtrim(pub.M_LABEL) ARC,
rtrim(ind.M_IND_LAB) IND,
ind.M_REFERENCE INDREF, 
round(hb.M_VALUE,6) HSR0, null HSR1, null HSR2
from HS790525_DBF hb
left join RT_INDEX_DBF ind on rtrim(hb.M_INDEX) = rtrim(ind.M_INDEX)
left join CMC_QUOT_DBF qot on ind.M_COM_QUOT = qot.M_REFERENCE
left join CM_MKT_DBF pub on qot.M_PUBLI = pub.M_REFERENCE
where 
rtrim(hb.M_INDEX) = '6059' and 
hb.M_FORMULA = 'P103' and 
hb.M_FIX_DATE >= :DATFST and 
hb.M_FIX_DATE <= :DATLST

union

-- LME NBY, SN LME 3M, P102 = 'Settlement'
select
to_char(hb.M_FIX_DATE,'YYYY-MM-DD') MKTDAT, 
rtrim(pub.M_LABEL) ARC,
rtrim(ind.M_IND_LAB) IND,
ind.M_REFERENCE INDREF, 
round(hb.M_VALUE,6) HSR0, null HSR1, null HSR2
from HS790525_DBF hb
left join RT_INDEX_DBF ind on rtrim(hb.M_INDEX) = rtrim(ind.M_INDEX)
left join CMC_QUOT_DBF qot on ind.M_COM_QUOT = qot.M_REFERENCE
left join CM_MKT_DBF pub on qot.M_PUBLI = pub.M_REFERENCE
where 
rtrim(hb.M_INDEX) = '6085' and 
hb.M_FORMULA = 'P102' and 
hb.M_FIX_DATE >= :DATFST and 
hb.M_FIX_DATE <= :DATLST

union

-- LME NBY, CU LME 3M, P103 = 'Ring2_Bid'
select
to_char(hb.M_FIX_DATE,'YYYY-MM-DD') MKTDAT, 
rtrim(pub.M_LABEL) ARC,
rtrim(ind.M_IND_LAB) IND,
ind.M_REFERENCE INDREF, 
round(hb.M_VALUE,6) HSR0, null HSR1, null HSR2
from HS790525_DBF hb
left join RT_INDEX_DBF ind on rtrim(hb.M_INDEX) = rtrim(ind.M_INDEX)
left join CMC_QUOT_DBF qot on ind.M_COM_QUOT = qot.M_REFERENCE
left join CM_MKT_DBF pub on qot.M_PUBLI = pub.M_REFERENCE
where 
rtrim(hb.M_INDEX) = '6085' and 
hb.M_FORMULA = 'P103' and 
hb.M_FIX_DATE >= :DATFST and 
hb.M_FIX_DATE <= :DATLST

union

-- LME NBY, ZN LME CASH, P102 = 'Settlement'
select
to_char(hb.M_FIX_DATE,'YYYY-MM-DD') MKTDAT, 
rtrim(pub.M_LABEL) ARC,
rtrim(ind.M_IND_LAB) IND,
ind.M_REFERENCE INDREF, 
round(hb.M_VALUE,6) HSR0, null HSR1, null HSR2
from HS790525_DBF hb
left join RT_INDEX_DBF ind on rtrim(hb.M_INDEX) = rtrim(ind.M_INDEX)
left join CMC_QUOT_DBF qot on ind.M_COM_QUOT = qot.M_REFERENCE
left join CM_MKT_DBF pub on qot.M_PUBLI = pub.M_REFERENCE
where 
rtrim(hb.M_INDEX) = '6064' and 
hb.M_FORMULA = 'P102' and 
hb.M_FIX_DATE >= :DATFST and 
hb.M_FIX_DATE <= :DATLST

union

-- LME NBY, ZN LME CASH, P103 = 'Ring2_Bid'
select
to_char(hb.M_FIX_DATE,'YYYY-MM-DD') MKTDAT, 
rtrim(pub.M_LABEL) ARC,
rtrim(ind.M_IND_LAB) IND,
ind.M_REFERENCE INDREF, 
round(hb.M_VALUE,6) HSR0, null HSR1, null HSR2
from HS790525_DBF hb
left join RT_INDEX_DBF ind on rtrim(hb.M_INDEX) = rtrim(ind.M_INDEX)
left join CMC_QUOT_DBF qot on ind.M_COM_QUOT = qot.M_REFERENCE
left join CM_MKT_DBF pub on qot.M_PUBLI = pub.M_REFERENCE
where 
rtrim(hb.M_INDEX) = '6064' and 
hb.M_FORMULA = 'P103' and 
hb.M_FIX_DATE >= :DATFST and 
hb.M_FIX_DATE <= :DATLST

union

-- LME NBY, ZN LME 3M, P102 = 'Settlement'
select
to_char(hb.M_FIX_DATE,'YYYY-MM-DD') MKTDAT, 
rtrim(pub.M_LABEL) ARC,
rtrim(ind.M_IND_LAB) IND,
ind.M_REFERENCE INDREF, 
round(hb.M_VALUE,6) HSR0, null HSR1, null HSR2
from HS790525_DBF hb
left join RT_INDEX_DBF ind on rtrim(hb.M_INDEX) = rtrim(ind.M_INDEX)
left join CMC_QUOT_DBF qot on ind.M_COM_QUOT = qot.M_REFERENCE
left join CM_MKT_DBF pub on qot.M_PUBLI = pub.M_REFERENCE
where 
rtrim(hb.M_INDEX) = '6104' and 
hb.M_FORMULA = 'P102' and 
hb.M_FIX_DATE >= :DATFST and 
hb.M_FIX_DATE <= :DATLST

union

-- LME NBY, ZN LME 3M, P103 = 'Ring2_Bid'
select
to_char(hb.M_FIX_DATE,'YYYY-MM-DD') MKTDAT, 
rtrim(pub.M_LABEL) ARC,
rtrim(ind.M_IND_LAB) IND,
ind.M_REFERENCE INDREF, 
round(hb.M_VALUE,6) HSR0, null HSR1, null HSR2
from HS790525_DBF hb
left join RT_INDEX_DBF ind on rtrim(hb.M_INDEX) = rtrim(ind.M_INDEX)
left join CMC_QUOT_DBF qot on ind.M_COM_QUOT = qot.M_REFERENCE
left join CM_MKT_DBF pub on qot.M_PUBLI = pub.M_REFERENCE
where 
rtrim(hb.M_INDEX) = '6104' and 
hb.M_FORMULA = 'P103' and 
hb.M_FIX_DATE >= :DATFST and 
hb.M_FIX_DATE <= :DATLST

order by MKTDAT, ARC, IND
