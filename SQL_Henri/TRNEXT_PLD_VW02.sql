drop view MUREX_MX_OWNER.TRNEXT_PLD_VW02;
create view MUREX_MX_OWNER.TRNEXT_PLD_VW02 
(
VALDAT,
-- 
LE,
CE,
PFL,
ASS,
TYPO,
INS,
QOT0,
UND0,
PUB0,
HSR0,
IND1,
QOT1,
UND1,
PUB1,
HSR1,
PHY,
CUR,
UOQ,
UOD,
UOV,
LOTSIZ,
MAT,
FUTMAT,
OPTMAT,
CFST0,
CLST0,
CFST1,
CLST1,
EXP,
STK,
RGT,
DIR,
NOM0,
NOM1,
QTYSGN,
RTE0, 
MRG0,
RTE1, 
MRG1,
OCC
)

as

(

select
-- Dates
to_char(pld.M_VAL_DAT2,'YYYYMMDD') VALDAT,
-- to_char(pld.M_TP_DTETRN,'YYYYMMDD') TRNDAT,
-- Identifiers
-- rtrim(pld.M_CNT_SRCMOD) SRC,
-- pld.M_NB TRN,
-- pld.M_CONTRACT CNT,
-- pld.M_CNT_VS2 CVS,
-- pld.M_PACKAGE PCK,
-- rtrim(pld.M_TP_GID) GID,
-- Parties
-- case pld.M_TP_INT when 'Y' then 'I' else 'E' end TRN_IE,
-- 'I' CTP_IE,
rtrim(pld.M_TP_LENTDSP) LE,
rtrim(pld.M_TP_ENTITY) CE,
-- 'DD_ALL' USRGRP,
-- 'MXMLUSER' USR,
rtrim(pld.M_TP_PFOLIO) PFL,
/*
case rtrim(pld.M_TP_PFOLIO)
when 'MCEX BWR PTEI' then 'MCEX ACL PTEI' 
when 'RMOP BWR PTEI' then 'RMOP ACL PTEI'
else null end CTP
*/
-- Product
(case pld.M_TRN_FMLY when 'COM' then rtrim(pld.M_TP_ASSET) else rtrim(pld.M_TRN_FMLY) end) ASS,
-- pld.M_TP_LSTOTC LO,
-- rtrim(pld.M_TRN_FMLY) FML,
-- rtrim(pld.M_TRN_GRP) GRP,
-- rtrim(pld.M_TRN_TYPE) TYP,
case rtrim(pld.M_CNT_TYPO)
when 'Future COM' then 'Forward COM'
when 'Carry Future' then 'Forward COM'
when 'Carry Forward' then 'Forward COM'
when 'Carry Bull' then 'Spot COM'
when 'Carry Average' then 'Swap COM'
when 'Arbitrage Average' then 'Swap COM'
when 'Option on Future COM' then 'Option on Forward'
else rtrim(pld.M_CNT_TYPO) end TYPO,
case rtrim(pld.M_INSTRUMENT)
when 'PB LME' then 'PB LME FWD'
when 'ZN LME' then 'ZN LME FWD'
when 'PB LME OPT' then 'PB LME FWD'
when 'ZN LME OPT' then 'ZN LME FWD'
else rtrim(pld.M_INSTRUMENT) end INS,
---- Index 1
-- rtrim(pld.M_TP_IND0) IND0,
rtrim(pld.M_TP_CMIQ0) QOT0,
rtrim(pld.M_TP_UND0) UND0,
rtrim(pld.M_TP_PUB0) PUB0,
rtrim(pld.M_TP_HSR0) HSR0,
---- Index 2
rtrim(pld.M_TP_IND1) IND1,
rtrim(pld.M_TP_CMIQ1) QOT1,
rtrim(pld.M_TP_UND1) UND1,
rtrim(pld.M_TP_PUB1) PUB1,
rtrim(pld.M_TP_HSR1) HSR1,
-- Physical
rtrim(pld.M_TP_CMDFYS0) PHY,
-- Quote
rtrim(pld.M_TP_COQ) CUR,
rtrim(pld.M_TP_UOQ) UOQ,
rtrim(pld.M_TP_UOD0) UOD,
rtrim(pld.M_TP_UOV0) UOV,
pld.M_TP_LOTSIZE LOTSIZ,
-- Tenor
case when pld.M_TRN_FMLY = 'COM' then 
case when (pld.M_TRN_GTYPE in (100,101,102,103) and rtrim(pld.M_TP_CMIPUB0) = 'LME') then 
case when pld.M_TP_DTEEXP = '10-FEB-21' then 'CASH' else
case when pld.M_TP_DTEEXP = '07-MAY-21' then '3M' else
case when to_date(pld.M_TP_DTEEXP) = next_day(trunc(to_date(pld.M_TP_DTEEXP,'DD-MON-YY'),'mm')-1,'Wednesday') + 14 then rtrim(substr(pld.M_TP_DTEEXP,4,6)) 
else rtrim(pld.M_TP_TEN) end end end
else case when pld.M_TRN_GTYPE in (154) then to_char(pld.M_TP_MAT,'YYYY-MM-DD') else rtrim(pld.M_TP_TEN) end end
else null end MAT,
case when pld.M_TRN_GTYPE in (100,101,102,103) then pld.M_TP_CMCMAT else null end FUTMAT, 
case when pld.M_TRN_GTYPE in (101,103) then pld.M_TP_CMCMAT else null end OPTMAT,
---- Trade dates
to_char(pld.M_TP_CMGDF0,'YYYYMMDD') CFST0,
to_char(pld.M_TP_CMGDL0,'YYYYMMDD') CLST0,
to_char(pld.M_TP_CMGDF1,'YYYYMMDD') CFST1,
to_char(pld.M_TP_CMGDL1,'YYYYMMDD') CLST1,
-- to_char(pld.M_TP_DTEPMT,'YYYYMMDD') STL,
to_char(pld.M_TP_DTEEXP,'YYYYMMDD') EXP,
-- Option
pld.M_TP_STRIKE STK,
case when pld.M_TP_OPT='O' then pld.M_TP_CP else null end RGT,
-- End of group by, grouped values
-- Direction
case 
when sum(pld.M_TP_QTY * pld.M_TP_LS) < 0 then 'S' else 'B' end DIR,
-- NOM, QTY
abs( (sum(pld.M_TP_QTY * pld.M_TP_LS)) / coalesce(pld.M_TP_LOTSIZE,1) ) NOM0,
0 NOM1,
sum(pld.M_TP_QTY * pld.M_TP_LS) QTYSGN,
-- Price @ Current market value
round(max(pld.M_TP_RTE02),4) RTE0,
sum(pld.M_TP_RTMMRG0) MRG0,
round(sum(pld.M_TP_RTE12*abs(pld.M_TP_QTY))/sum(abs(pld.M_TP_QTY)),4) RTE1,
sum(pld.M_TP_RTMMRG1) MRG1,
-- Occurence
count(*) OCC

from MUREX_DM_OWNER.CHECK_PL_REP pld
where M_TRN_FMLY = 'COM'

group by 
pld.M_VAL_DAT2,
-- case pld.M_TP_INT when 'Y' then 'I' else 'E' end,
pld.M_TP_LENTDSP,
pld.M_TP_ENTITY,
pld.M_TP_PFOLIO,
case pld.M_TRN_FMLY when 'COM' then rtrim(pld.M_TP_ASSET) else rtrim(pld.M_TRN_FMLY) end,
-- pld.M_TP_LSTOTC,
-- pld.M_TRN_FMLY,
-- pld.M_TRN_GRP,
-- pld.M_TRN_TYPE,
case rtrim(pld.M_CNT_TYPO)
when 'Future COM' then 'Forward COM'
when 'Carry Future' then 'Forward COM'
when 'Carry Forward' then 'Forward COM'
when 'Carry Bull' then 'Spot COM'
when 'Carry Average' then 'Swap COM'
when 'Arbitrage Average' then 'Swap COM'
when 'Option on Future COM' then 'Option on Forward'
else rtrim(pld.M_CNT_TYPO) end,
case rtrim(pld.M_INSTRUMENT)
when 'PB LME' then 'PB LME FWD'
when 'ZN LME' then 'ZN LME FWD'
when 'PB LME OPT' then 'PB LME FWD'
when 'ZN LME OPT' then 'ZN LME FWD'
else rtrim(pld.M_INSTRUMENT) end,
-- pld.M_TP_IND0,
pld.M_TP_CMIQ0,
pld.M_TP_UND0,
pld.M_TP_PUB0,
pld.M_TP_HSR0,
pld.M_TP_IND1,
pld.M_TP_CMIQ1,
pld.M_TP_UND1,
pld.M_TP_PUB1,
pld.M_TP_HSR1,
pld.M_TP_CMDFYS0,
pld.M_TP_COQ,
pld.M_TP_UOQ,
pld.M_TP_UOD0,
pld.M_TP_UOV0,
pld.M_TP_LOTSIZE,
case when pld.M_TRN_FMLY = 'COM' then 
case when (pld.M_TRN_GTYPE in (100,101,102,103) and rtrim(pld.M_TP_CMIPUB0) = 'LME') then 
case when pld.M_TP_DTEEXP = '10-FEB-21' then 'CASH' else
case when pld.M_TP_DTEEXP = '07-MAY-21' then '3M' else
case when to_date(pld.M_TP_DTEEXP) = next_day(trunc(to_date(pld.M_TP_DTEEXP,'DD-MON-YY'),'mm')-1,'Wednesday') + 14 then rtrim(substr(pld.M_TP_DTEEXP,4,6)) 
else rtrim(pld.M_TP_TEN) end end end
else case when pld.M_TRN_GTYPE in (154) then to_char(pld.M_TP_MAT,'YYYY-MM-DD') else rtrim(pld.M_TP_TEN) end end
else null end,
case when pld.M_TRN_GTYPE in (100,101,102,103) then pld.M_TP_CMCMAT else null end, 
case when pld.M_TRN_GTYPE in (101,103) then pld.M_TP_CMCMAT else null end,
pld.M_TP_CMGDF0,
pld.M_TP_CMGDL0,
pld.M_TP_CMGDF1,
pld.M_TP_CMGDL1,
-- pld.M_TP_DTEPMT,
pld.M_TP_DTEEXP,
pld.M_TP_STRIKE,
case when pld.M_TP_OPT='O' then pld.M_TP_CP else null end

)
