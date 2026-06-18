select
PCDAT,
PCDAT TRNDAT,
'mx' SRC,
null TRN,
null CNT,
null CVS,
null PCK,
'IMP:CU_REASG' GID,
TRN_IE,
'I' CTP_IE,
LE,
CE,
'MXMLUSER' USR,
PFL,
CTP,
LO,
ASS,
FML,
GRP,
TYP,
TYPO,
INS,
PHY,
-- Index 1
IND1,
QOT1,
PUB1,
UND1,
HSR1,
-- Index 2
IND2,
QOT2,
PUB2,
UND2,
HSR2,
-- Quote
CUR,
UOM,
UOD,
-- Tenor
MAT,
FUTMAT, 
OPTMAT,
-- Trade dates
CFST1,
CLST1,
CFST2,
CLST2,
STL,
EXP,
-- Option
STK,
RGT RGT,
-- Price
round(sum(RTE1*abs(NOM1))/sum(abs(NOM1)),4) PRC1,
sum(MRG1) MRG1,
round(sum(RTE1*abs(NOM1))/sum(abs(NOM1)),4) RTE1,
sum(MRG2) MRG2,
round(sum(RTE2*abs(NOM1))/sum(abs(NOM1)),4) RTE2,
-- Direction
case when sum(NOM1) > 0 then 'S' when sum(NOM1) < 0 then 'B' else 'X' end DIR,
null LS,
LOTSIZ,
-- Quantity
sum(abs(NOM1)) NOM1,
sum(abs(NOM2)) NOM2,
sum(QTY) QTY,
count(*) OCC

FROM
(
select
-- Dates
to_char(pld.M_VAL_DAT2,'YYYYMMDD') PCDAT,
-- to_char(pld.M_TP_DTETRN,'YYYYMMDD') TRNDAT,
-- Identifiers
-- rtrim(pld.M_CNT_SRCMOD) SRC,
-- pld.M_NB TRN,
-- pld.M_CONTRACT CNT,
-- pld.M_CNT_VS2 CVS,
-- pld.M_PACKAGE PCK,
-- rtrim(pld.M_TP_GID) GID,
-- Parties
'I' TRN_IE,
'I' CTP_IE,
rtrim(pld.M_TP_LENTDSP) LE,
rtrim(pld.M_TP_ENTITY) CE,
-- rtrim(M_TP_TRADER) USR,
rtrim(pld.M_TP_PFOLIO) PFL,
case rtrim(pld.M_TP_PFOLIO)
when 'MCEX BWR PTEI' then 'MCEX BLE PTEI' 
when 'RMOP BWR PTEI' then 'RMOP BLE PTEI'
when 'RMOT BWR PTEI' then 'RMOT BLE PTEI'
when 'RMTS BWR PTEI' then 'RMOP BLE PTEI'
when 'RMAR BWR PTEI' then 'MCEX BLE PTEI' else null end CTP,
-- Product
pld.M_TP_LSTOTC LO,
(case pld.M_TRN_FMLY when 'COM' then rtrim(pld.M_TP_ASSET) else rtrim(pld.M_TRN_FMLY) end) ASS,
rtrim(pld.M_TRN_FMLY) FML,
case pld.M_TRN_GTYPE when 100 then 'FWD' else rtrim(pld.M_TRN_GRP)  end GRP,
case pld.M_TRN_GTYPE when 101 then 'OTC' else rtrim(pld.M_TRN_TYPE) end TYP,
case rtrim(pld.M_CNT_TYPO)
when 'Future COM' then 'Forward COM'
when 'Option on Future COM' then 'Option on Forward'
when 'Arbitrage Average' then 'Swap COM'
when 'Carry Average' then 'Swap COM'
when 'Carry Forward' then 'Forward COM' else rtrim(pld.M_CNT_TYPO) end TYPO,
case when pld.M_TRN_GTYPE in (100) then rtrim(pld.M_INSTRUMENT)||' FWD' 
else rtrim(pld.M_INSTRUMENT) end INS,
rtrim(pld.M_TP_CMDFYS0) PHY,
-- Index 1
rtrim(pld.M_TP_CMILAB0) IND1,
rtrim(pld.M_TP_CMIQ0) QOT1,
rtrim(pld.M_TP_CMIPUB0) PUB1,
rtrim(pld.M_TP_CMULAB0) UND1,
rtrim(pld.M_TP_HSR0) HSR1,
-- Index 2
rtrim(pld.M_TP_CMILAB0) IND2,
rtrim(pld.M_TP_CMIQ0) QOT2,
rtrim(pld.M_TP_CMIPUB0) PUB2,
rtrim(pld.M_TP_CMULAB0) UND2,
rtrim(pld.M_TP_HSR0) HSR2,
-- Quote
case when pld.M_TRN_FMLY = 'COM' then pld.M_TP_CMIQC0 else pld.M_TP_FXBASE end CUR,
case when pld.M_TRN_FMLY = 'COM' then rtrim(pld.M_TP_CMIQU0) else pld.M_TP_FXUND end UOM,
case when pld.M_TRN_FMLY = 'COM' then rtrim(pld.M_TP_CMLDU0) else pld.M_TP_FXUND end UOD,
-- Tenor
case when pld.M_TRN_FMLY = 'COM' then 
case when (pld.M_TRN_GTYPE in (100,101,102,103) and rtrim(pld.M_TP_CMIPUB0) = 'LME') then 
case when pld.M_TP_DTEEXP = '05-JUL-19' then 'CASH' else
case when pld.M_TP_DTEEXP = '03-OCT-19' then '3M' else
case when to_date(pld.M_TP_DTEEXP) = next_day(trunc(to_date(pld.M_TP_DTEEXP,'DD-MON-YY'),'mm')-1,'Wednesday') + 14 then rtrim(substr(pld.M_TP_DTEEXP,4,6)) 
else rtrim(pld.M_TP_TEN) end end end
else case when pld.M_TRN_GTYPE in (154) then to_char(pld.M_TP_MAT,'YYYY-MM-DD') else rtrim(pld.M_TP_TEN) end end
else null end MAT,
case when pld.M_TRN_GTYPE in (100,101,102,103) then pld.M_TP_CMCMAT else null end FUTMAT, 
case when pld.M_TRN_GTYPE in (101,103) then pld.M_TP_CMCMAT else null end OPTMAT,
  ---- Trade dates
to_char(pld.M_TP_CMGDF0,'YYYYMMDD') CFST1,
to_char(pld.M_TP_CMGDL0,'YYYYMMDD') CLST1,
to_char(pld.M_TP_CMGDF1,'YYYYMMDD') CFST2,
to_char(pld.M_TP_CMGDL1,'YYYYMMDD') CLST2,
case when pld.M_TRN_GTYPE in (100,102) then to_char(pld.M_VAL_DAT2,'YYYYMMDD') else to_char(pld.M_TP_DTEPMT,'YYYYMMDD') end STL,
to_char(pld.M_TP_DTEEXP,'YYYYMMDD') EXP,
  -- Option
pld.M_TP_STRIKE STK,
case when pld.M_TP_OPT='O' then pld.M_TP_CP else null end RGT,
pld.M_TP_LOTSIZE LOTSIZ,

-- Price
pld.M_TP_PRICE PRC1,
pld.M_TP_RTMMRG0 MRG1,
pld.M_TP_RTE02 RTE1,
pld.M_TP_RTMMRG1 MRG2,
pld.M_TP_RTE12 RTE2,

-- NOM, QTY
-- pld.M_TP_NOM0 NOM0,
pld.M_TP_IQTYS NOM1,
pld.M_TP_NOM1 NOM2,
pld.M_TP_CMGQTY0 QTY
  
from MUREX_DM_OWNER.CHECK_PL_REP pld
where rtrim(pld.M_TP_CMDFYS0) = 'COPPER'
and rtrim(pld.M_TP_PFOLIO) in
(
'MCEX BWR PTEI',
'RMOP BWR PTEI',
'RMOT BWR PTEI',
'RMTS BWR PTEI',
'RMAR BWR PTEI'
)

/*
and rtrim(pld.M_TP_PFOLIO) = 'RMOP BWR PTEI'
and rtrim(pld.M_CNT_TYPO) = 'Asian Option COM'
*/

)

group by
PCDAT,
TRN_IE,
CTP_IE,
LE,
CE,
PFL,
CTP,
LO,
ASS,
FML,
GRP,
TYP,
TYPO,
INS,
PHY,
IND1,
QOT1,
PUB1,
UND1,
HSR1,
IND2,
QOT2,
PUB2,
UND2,
HSR2,
-- Quote
CUR,
UOM,
UOD,
-- Tenor
MAT,
FUTMAT, 
OPTMAT,
---- Trade dates
CFST1,
CLST1,
CFST2,
CLST2,
STL,
EXP,
-- Option
STK,
RGT,
LOTSIZ

order by PFL,TYPO,INS,EXP