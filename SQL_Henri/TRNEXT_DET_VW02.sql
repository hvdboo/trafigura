drop view MUREX_MX_OWNER.TRNEXT_DET_VW02;
create view MUREX_MX_OWNER.TRNEXT_DET_VW02
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
USRGRP,
USR,
PFL,
CTP,
STGSRC,
STGDST,
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
PRM,
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
CAPQTY,
DLVQTY,
/*
FEE0_TYP,
FEE0_PFL,
FEE0_CTP,
FEE0_COD,
FEE0_CUR,
FEE0_AMT,
FEE0_STL,
FEE0_CMT,
*/
FEE1_TYP,
FEE1_PFL,
FEE1_CTP,
FEE1_COD,
FEE1_CUR,
FEE1_AMT,
FEE1_STL,
FEE1_CMT,
FEE2_TYP,
FEE2_PFL,
FEE2_CTP,
FEE2_COD,
FEE2_CUR,
FEE2_AMT,
FEE2_STL,
FEE2_CMT,
FEE3_TYP,
FEE3_PFL,
FEE3_CTP,
FEE3_COD,
FEE3_CUR,
FEE3_AMT,
FEE3_STL,
FEE3_CMT
)
as
(
select
src.PCDAT,
-- Reassign transaction date
/* src.TRNDAT */
src.PCDAT,
'mx' SRC,
src.TRN,
src.CNT,
src.CVS,
src.PCK,
-- GID convention
concat('IMP:OFF_',to_char(src.TRN)) GID,
src.TRN_IE,
src.CTP_IE,
src.LE,
src.CE,
-- Group and User convention
src.USRGRP,
'MXMLUSER' USR,
-- Offset, PFL and CTP remain. Direction will be inverted.
src.PFL,
src.CTP,
src.STGSRC,
src.STGDST,
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
-- Adapt premium
src.PRM,
-- Adapt price, leg1
/* src.PRC1, */
case src.INS
when 'FRT CS TCA 5 - NFX' then
        case src.MAT
        when 'JUL-20' then 11900.00
        when 'AUG-20' then 11900.00
        when 'SEP-20' then 11900.00
        when 'OCT-20' then 11900.00
        when 'NOV-20' then 11900.00
        when 'DEC-20' then 11900.00
        else 0 end 
else 0 end PRC1,
src.MRG1,
-- Adapt price, leg2
/* src.PRC2, */
case src.INS
when 'FRT CS TCA 5 - NFX' then
        case src.MAT
        when 'JUL-20' then 11900.00
        when 'AUG-20' then 11900.00
        when 'SEP-20' then 11900.00
        when 'OCT-20' then 11900.00
        when 'NOV-20' then 11900.00
        when 'DEC-20' then 11900.00
        else 0 end 
else 0 end PRC2,
src.MRG2,
-- Offset positions, Invert direction
case src.DIR
when 'B' then 'S'
when 'S' then 'B' else null end DIR,
src.LS*-1 LS,
src.LOTSIZ,
src.NOM1,
src.NOM2,
src.QTY,
src.CAPQTY,
src.DLVQTY,
-- src.FEE0_TYP,
-- src.FEE0_PFL,
-- src.FEE0_CTP,
-- src.FEE0_COD,
-- src.FEE0_CUR,
-- src.FEE0_AMT,
-- src.FEE0_STL,
-- src.FEE0_CMT,
src.FEE1_TYP,
src.FEE1_PFL,
src.FEE1_CTP,
src.FEE1_COD,
src.FEE1_CUR,
src.FEE1_AMT,
src.FEE1_STL,
src.FEE1_CMT,
src.FEE2_TYP,
src.FEE2_PFL,
src.FEE2_CTP,
src.FEE2_COD,
src.FEE2_CUR,
src.FEE2_AMT,
src.FEE2_STL,
src.FEE2_CMT,
src.FEE3_TYP,
src.FEE3_PFL,
src.FEE3_CTP,
src.FEE3_COD,
src.FEE3_CUR,
src.FEE3_AMT,
src.FEE3_STL,
src.FEE3_CMT

from MUREX_MX_OWNER.TRNEXT_DET_VW01 src
);