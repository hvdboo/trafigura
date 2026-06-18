select
TRNDAT as SYSDAT,
'I' TRN_IE,
'I' CTP_IE,
SRC,
' ' TRN, 
' ' CNT, 
' ' CVS, 
' ' PCK,
'PREWSH_OFF:'||to_char(TRN) GID,
LE, 
CE,
'MXMLUSER' USR,
PFL,
-- Switch CTP
coalesce(case when PFL = PFLINI then CTPINI else PFLINI end, PFLDST,'BKEX TRE PTEI') CTP,
LO, 
ASS, 
case TYPO
when 'Carry Average' then 'Swap COM'
when 'Carry Forward' then 'Forward COM' else TYPO end TYPO,
INS, 
INS as FUT, 
IND, 
UND, 
QOT, 
PUB, 
HSR,
HSR2,
CUR, 
UOM,
UOD, 
PHY,
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
RGT as CP,
-- Invert B/S (offset)
case BS 
when 'B' then 'S'
when 'S' then 'B' else null end as BS,
LOTSIZ,
NOM1, 
' ' NOM2, 
QTY, 
' ' CAPQTY, 
' ' DLVQTY,
PRC1, 
MRG1, 
' ' PRC2, 
' ' MRG2,
' ' FGTID, 
' ' FUTID, 
' ' INDID, 
' ' QOTID, 
' ' PUBID, 
' ' HSRID, 
' ' HISFIL, 
' ' MATSETID, 
' ' FMATID

from TRNEXC_GET 

order by to_number(trim(substr(GID,12,10)))

/*
review: 
-- 29-AUG-17
10311506
10312184
10312819
-- 17-OCT-17
10869060
10869045
-- JAN-18
11350275
*/
