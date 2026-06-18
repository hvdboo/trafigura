drop view TRNEXT_POS_VW02;

create view TRNEXT_POS_VW02  
(
PCDAT,
TRNDAT,
SRC,
TRN,
CNT,
CVS,
PCK,
GID,
TRN_IE,
CTP_IE,
LE, 
CE,
USR,
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
CUR, 
UOM,
UOD, 
MAT, 
FUTMAT, 
OPTMAT,
CFST1,
CLST1,
CFST2,
CLST2,
STL,
EXP,
STK,
RGT,
PRC1,
MRG1,
PRC2,
MRG2,
DIR, 
LS,
LOTSIZ,
NOM1,
NOM2,
QTY,
OCC
)

as 

( 
select 
src.PCDAT PCDAT,
src.PCDAT TRNDAT,
'mx' SRC,
null TRN,
null CNT,
null CVS,
null PCK,
-- Set GID
'IMP:CU_REASG' GID,
'I' TRN_IE,
'I' CTP_IE,
src.LE,
src.CE,
'MXMLUSER' USR,
-- Reassign from Source to Target portfolio
src.PFL PFL,
case src.PFL
when 'MCEX BWR PTEI' then 'MCEX BLE PTEI' 
when 'RMOP BWR PTEI' then 'RMOP BLE PTEI'
when 'RMOT BWR PTEI' then 'RMOT BLE PTEI'
when 'RMTS BWR PTEI' then 'RMOP BLE PTEI'
when 'RMAR BWR PTEI' then 'MCEX BLE PTEI' else null end CTP,
src.LO, 
src.ASS, 
src.FML,
src.GRP,
src.TYP, 
src.TYPO,
src.INS, 
src.PHY, 
src.IND1, 
src.QOT1, 
src.PUB1,
src.UND1, 
src.HSR1,
src.IND2, 
src.QOT2, 
src.PUB2,
src.UND2,
src.HSR2,
src.CUR, 
src.UOM,
src.UOD, 
src.MAT, 
src.FUTMAT, 
src.OPTMAT,
src.CFST1,
src.CLST1,
src.CFST2,
src.CLST2,
src.STL,
src.EXP,
src.STK, 
src.RGT,
round(src.PRC1,4) PRC1,
null MRG1, 
round(src.PRC2,4) PRC2,
null MRG2,
-- Set Direction, Offset hence invert
case when src.NOM1 > 0 then 'S' when src.NOM1 < 0 then 'B' else 'X' end DIR,
'X' LS,
1 LOTSIZ,
abs(src.NOM1) NOM1, 
abs(src.NOM2) NOM2,
1 QTY, 
OCC

from TRNEXT_POS_VW01 src

where src.NOM1 <> 0
and src.PFL in 
(
'MCEX BWR PTEI', 'RMOP BWR PTEI'
)

);


