--------------
-- Transfer --
--------------

select
'Trade Number'          COL01_A,
'TT Order Number'       COL02_B,
'Account'               COL03_C,
'Buy/Sell'              COL04_D,
'Exchange'              COL05_E,
'Commodity'             COL06_F,
'Currency'              COL07_G,
'Trade Type'            COL08_H,
'Carry Leg'             COL09_I,
'Expiry Date'           COL10_J,
'Lots'                  COL11_K,
'Price'                 COL12_L,
'Put/Call'              COL13_M,
'Strike Price'          COL14_N,
'Trade Date'            COL15_O,
'Trade Time'            COL16_P,
'Sub-account'           COL17_Q,
'Trader'                COL18_R,
'Carry Type'            COL19_S
from TRN_PC_DBF where 1 = 1

union all

select
null            COL01_A,
null            COL02_B,
'MACQXXX'       COL03_C,
case when NOM > 0 then 'B' when NOM < 0 then 'S' else 'X' end  COL04_D,
PUB             COL05_E,
INS             COL06_F,
'USD'           COL07_G,
'F'             COL08_H,
to_char(0,'9')  COL09_I,
EXP             COL10_J,
to_char(ABS(NOM),'9999') COL11_K,
to_char(PRC,'99999.999') COL12_L,
null            COL13_M,
to_char(0,'9')  COL14_N,
SYSDAT          COL15_O,
'00:00'         COL16_P,
null            COL17_Q,
case PFL
when 'BKEX IMA PTEI'   then 'TRADER10'
when 'BKEX TRE PTEI'   then 'TRADER20'
when 'BKPR CLHAP PTED' then 'TRADER30'
when 'DFEX MSI PTEI'   then 'TRADER40'
/*
case INS 
when 'FRT BCI - EEX'      then 'TRADER41'
when 'FRT BCI - EEX'      then 'TRADER41'
when 'FRT BPI - EEX'      then 'TRADER43'
when 'FRT BSI - EEX'      then 'TRADER44'
when 'FRT CS TCA 5 - EEX' then 'TRADER45'
*/
when 'MCEX XX- PTEI'   then 'TRADER50' 
/*
case INS 
when 'FRT BCI - EEX'      then 'TRADER51'
when 'FRT BPI - EEX'      then 'TRADER52'
when 'FRT BSI - EEX'      then 'TRADER53'
when 'FRT CS TCA 5 - EEX' then 'TRADER54'
when 'FRT S TCA 10 - EEX' then 'TRADER55'
*/
else null end   COL18_R,
null            COL19_S

from 

(
select 
max(to_char(pc.M_DATE,'YYYYMMDD')) SYSDAT,
max((case when trn.M_COMMENT_BS ='B' then rtrim(trn.M_BPFOLIO) else rtrim(trn.M_SPFOLIO) end)) PFL,
max(rtrim(typo.M_LABEL)) TYPO,
-- Transfer: switch to target instrument
'EEX FUTURE' PUB,
max(case fut.M_LABEL
when 'FRT BCI - LCH' then 'FRT BCI - EEX'
when 'FRT BCI - SGX' then 'FRT BCI - EEX'
when 'FRT BPI - SGX' then 'FRT BPI - EEX'
when 'FRT BSI - LCH' then 'FRT BSI - EEX'
when 'FRT BSI - SGX' then 'FRT BSI - EEX'
when 'FRT C7 - LCH'  then 'FRT C7 - EEX'
when 'FRT CS TCA 5 - LCH' then 'FRT CS TCA 5 - EEX'
when 'FRT CS TCA 5 - SGX' then 'FRT CS TCA 5 - EEX'
when 'FRT S TCA 10 - LCH' then 'FRT S TCA 10 - EEX' else null end) INS,
max(rtrim(trn.M_BRW_ODPL)) MAT,
to_char(fmat.M_QT_END,'YYYYMMDD') EXP,
-- Transfer: keep buy/sell
max(case trn.M_COMMENT_BS
when 'B' then 'Buy' 
when 'S' then 'Sell' else null end) DIR,
sum((case trn.M_COMMENT_BS when 'B' then 1 else -1 end) * trn.M_BRW_NOM1) NOM,
max(case fut.M_LABEL
when 'FRT BCI - LCH' then round(hb9.M_P288,4)
when 'FRT BCI - SGX' then round(hb1.M_P128,4)
when 'FRT BPI - SGX' then round(hb2.M_P128,4)
when 'FRT BSI - LCH' then round(hb3.M_P288,4)
when 'FRT BSI - SGX' then round(hb4.M_P128,4)
when 'FRT C7 - LCH'  then round(hb5.M_P288,4)
when 'FRT CS TCA 5 - LCH' then round(hb6.M_P288,4)
when 'FRT CS TCA 5 - SGX' then round(hb7.M_P128,4)
when 'FRT S TCA 10 - LCH' then round(hb8.M_P288,4) else null end) PRC, 
count(*) OCC

from TRN_HDR_DBF trn
left join TRN_PC_DBF pc on 1 = 1
left join HDREXT_VW_DBF ext on trn.M_NB = ext.M_TNB
left join TRN_PLIN_DBF plin on trn.M_INSTRUMENT = plin.M_REFERENCE
left join CMT_PLKEY1_DBF plkey on trim(trn.M_PL_KEY1) = to_char(plkey.M_REFERENCE)
left join CM_ASSET_DBF ass on plkey.M_ASSET = ass.M_REFERENCE
left join CONTRACT_DBF cnt on trn.M_CONTRACT = cnt.M_REFERENCE
left join TYPOLOGY_DBF typo on cnt.M_TYPOLOGY = typo.M_REFERENCE
left join TRN_CPDF_DBF ble on trn.M_BLENTITY = ble.M_ID
left join TRN_CPDF_DBF sle on trn.M_SLENTITY = sle.M_ID
left join TRN_CPDF_DBF ctp on trn.M_COUNTRPART = ctp.M_ID
left join CTP_TYPES_DBF ctyp on (ctp.M_ID = ctyp.M_CTN and ctyp.M_REF = 16)
left join SRC_MOD_DBF src on cnt.M_SRC_MODULE = src.M_REFERENCE
left join CM_FUT_DBF fut on rtrim(plin.M_DSP_LABEL) = rtrim(fut.M_LABEL)
left join CMC_QUOT_DBF qotf on fut.M_QUOT_FWD = qotf.M_REFERENCE
left join CM_MKT_DBF pub on qotf.M_PUBLI= pub.M_REFERENCE
left join CM_UNIT_DBF uniq on qotf.M_UNIT = uniq.M_REFERENCE
left join RT_GROUP_DBF grp on (to_char(fut.M_REFERENCE) = trim(substr(grp.M_GRP_DESC,1,10)) and to_char(qotf.M_REFERENCE) = trim(substr(grp.M_GRP_DESC,11,15)) and rtrim(grp.M_HISFILE)<>'409263')
left join CM_MKTSR_DBF hsr on pub.M_REFERENCE = hsr.M_REFERENCE
left join RT_INDEX_DBF indmkt on trn.M_MKT_INDEX = indmkt.M_INDEX
left join CM_FMAT1_DBF fmat on indmkt.M_COM_MAT = fmat.M_REFERENCE
left join H155192_H1S hh1 on (fmat.M_REFERENCE = hh1.M_KEY0 and fut.M_REFERENCE = 528)
left join H155283_H1S hh2 on (fmat.M_REFERENCE = hh2.M_KEY0 and fut.M_REFERENCE = 530)
left join H158000_H1S hh3 on (fmat.M_REFERENCE = hh3.M_KEY0 and fut.M_REFERENCE = 463)
left join H155295_H1S hh4 on (fmat.M_REFERENCE = hh4.M_KEY0 and fut.M_REFERENCE = 531)
left join H158057_H1S hh5 on (fmat.M_REFERENCE = hh5.M_KEY0 and fut.M_REFERENCE = 513)
left join H386210_H1S hh6 on (fmat.M_REFERENCE = hh6.M_KEY0 and fut.M_REFERENCE = 560)
left join H386217_H1S hh7 on (fmat.M_REFERENCE = hh7.M_KEY0 and fut.M_REFERENCE = 563)
left join H011572_H1S hh8 on (fmat.M_REFERENCE = hh8.M_KEY0 and fut.M_REFERENCE = 565)
left join H516727_H1S hh9 on (fmat.M_REFERENCE = hh9.M_KEY0 and fut.M_REFERENCE = 460)
left join B155192_HBS hb1 on (hh1.M_KEYID = hb1.M_KEYID and pc.M_DATE-1 = hb1.M_DATE)
left join B155283_HBS hb2 on (hh2.M_KEYID = hb2.M_KEYID and pc.M_DATE-1 = hb2.M_DATE)
left join B158000_HBS hb3 on (hh3.M_KEYID = hb3.M_KEYID and pc.M_DATE-1 = hb3.M_DATE)
left join B155295_HBS hb4 on (hh4.M_KEYID = hb4.M_KEYID and pc.M_DATE-1 = hb4.M_DATE)
left join B158057_HBS hb5 on (hh5.M_KEYID = hb5.M_KEYID and pc.M_DATE-1 = hb5.M_DATE)
left join B386210_HBS hb6 on (hh6.M_KEYID = hb6.M_KEYID and pc.M_DATE-1 = hb6.M_DATE)
left join B386217_HBS hb7 on (hh7.M_KEYID = hb7.M_KEYID and pc.M_DATE-1 = hb7.M_DATE)
left join B011572_HBS hb8 on (hh8.M_KEYID = hb8.M_KEYID and pc.M_DATE-1 = hb8.M_DATE)
left join B516727_HBS hb9 on (hh9.M_KEYID = hb9.M_KEYID and pc.M_DATE-1 = hb9.M_DATE)

where 
trn.M_NB in
(
10743871,
10743874,
10743875,
10743876,
10743877,
10743878,
10743880,
10743882,
10743884,
10743885,
10743886,
10743890,
10743891,
10743892,
10743893,
10743894,
10743897,
10743898,
10743899,
10743901,
10743902,
10743903,
10743905,
10743906,
10743907,
10743908,
10743909,
10743912,
10743913,
10743914,
10743915,
10743917,
10743919,
10743920,
10743921,
10743922,
10743926,
10743927,
10743928,
10743930,
10743931,
10743933,
10743934,
10743936,
10743937,
10743938,
10743939,
10743941,
10743957,
10743959,
10743960,
10743964,
10743965,
10743966,
10743969,
10743972,
10743974,
10743975,
10743978,
10743979,
10744096,
10744097,
10744099,
10744104,
10744105,
10744109,
10744110,
10744113,
10744115,
10744116,
10744117,
10744122,
10744125,
10744127,
10744132,
10744134,
10744136,
10744141,
10744142,
10744144,
10744149,
10744151,
10744153,
10744155,
10744156,
10744157,
10744158,
10744161,
10744163,
10744165,
10744167,
10744169,
10744173,
10744174,
10744175,
10744180,
10744182,
10744183,
10744184,
10744187,
10744189,
10744191,
10744196,
10744198,
10744203,
10744204,
10744205,
10744207,
10744208,
10744211,
10744212,
10744215,
10744216,
10744218,
10744219,
10744221,
10744223,
10744224,
10744225,
10744227,
10744229,
10744231,
10744234,
10744235,
10744238,
10744239,
10744241,
10744242,
10744245,
10744247,
10744248,
10744249,
10744251,
10744254,
10744255,
10744256,
10744258,
10744261,
10744262,
10744264,
10744265,
10744267,
10744268,
10744269,
10744272,
10744273,
10744275,
10744278,
10744280,
10744282,
10744283,
10744285,
10744286,
10744287,
10744288,
10744290,
10744294,
10744295,
10744297,
10744299,
10744301,
10744302,
10744304,
10744305,
10744310,
10744311,
10744313,
10744316,
10744317,
10744319,
10744320,
10744323,
10744326,
10744328,
10744329,
10744331,
10744335,
10744336,
10744338,
10744339,
10744363,
10744364,
10744365,
10744366,
10744367,
10744368,
10744369,
10744370,
10744371,
10744372,
10744373,
10744375,
10744629,
10744637,
10744651,
10744655,
10744659,
10744663,
10744677,
10744678,
10744694,
10744698,
10744708,
10744712,
10744716,
10744727,
10744734,
10744742,
10744753,
10744754,
10744765,
10744770,
10744772,
10744776,
10744790,
10744795,
10744800,
10744801,
10744802,
10744803,
10744804,
10744805,
10744806,
10744807,
10744809,
10744810,
10744812,
10744813,
11012469,
11012474,
11012479,
11012484,
11012489,
11012494,
11012499,
11012504,
11012509,
11012514,
11012519,
11012524
)

group by 
(case when trn.M_COMMENT_BS ='B' then rtrim(trn.M_BPFOLIO) else rtrim(trn.M_SPFOLIO) end),
rtrim(typo.M_LABEL),
case fut.M_LABEL
when 'FRT BCI - SGX' then 'FRT BCI - EEX'
when 'FRT BPI - SGX' then 'FRT BPI - EEX'
when 'FRT BSI - LCH' then 'FRT BSI - EEX'
when 'FRT BSI - SGX' then 'FRT BSI - EEX'
when 'FRT C7 - LCH'  then 'FRT C7 - EEX'
when 'FRT CS TCA 5 - LCH' then 'FRT CS TCA 5 - EEX'
when 'FRT CS TCA 5 - SGX' then 'FRT CS TCA 5 - EEX'
when 'FRT S TCA 10 - LCH' then 'FRT S TCA 10 - EEX' else null end,
to_char(fmat.M_QT_END,'YYYYMMDD')

order by PFL, INS, to_char(fmat.M_QT_END,'YYYYMMDD')

)