select
TRNDAT as SYSDAT,
'I' TRN_IE, 
CTP_IE, 
SRC,
' ' TRN, 
' ' CNT, 
' ' CVS, 
' ' PCK,
'PRW_USD_TRF:'||to_char(TRN) GID,
LE, 
CE,
'MXMLUSER' USR,
-- Switch PFL to what it had to be
-- USD Pre-Wash
case PFL 
when 'BKAR IOPAP TICI' then 'BKAR IOPAP PTEI'
when 'BKEX TRE TICD'   then 'BKEX TRE PTEI'
when 'BKPR IOHAP TICD' then 'BKPR IOHAP PTED'
when 'COAR CUPAP TICD' then 'COAR CUPAP TVTD'
when 'COAR PBPAP TICD' then 'COAR PBPAP TVTD'
when 'COPR CUHAP TICD' then 'COPR CUHAP TVTD'
when 'COPR PBHAP TICD' then 'COPR PBHAP TVTD'
when 'COPR ZNHAP TICD' then 'xxx'
when 'COPR ZNHAP TVTD' then 'xxx'
when 'MCEX CHS TICI'   then 'MCEX CHS PTEI'
when 'MCEX CWU TICI'   then 'MCEX CWU PTEI'
when 'MCEX NHA TICI'   then 'MCEX NHA PTEI'
when 'MCEX NSA TICI'   then 'MCEX NSA PTEI'
when 'MCEX SLI TICI'   then 'MCEX SLI PTEI'
when 'MCEX VLI TICI'   then 'MCEX VLI PTEI'
when 'MCEX ZLI TICI'   then 'MCEX ZLI PTEI'
when 'RMAR AGPAP TICD' then 'RMAR AGPAP TVTD'
when 'RMAR CHS TICI'   then 'RMAR CHS PTEI'
when 'RMAR MB- TICD'   then 'RMAR MB- PTEI'
when 'RMAR MRI TICI'   then 'RMAR MRI PTEI'
when 'RMAR NHA TICI'   then 'RMAR NHA TVTD'
when 'RMOT MRI TICI'   then 'RMOT MRI PTEI'
when 'RMPR NIHAP TICD' then 'RMPR NIHAP PTED' 
else null end PFL, 
-- Keep Offset Counterpart
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
-- Keep B/S (Transfer)
BS,
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

from TRNEXC
where TRN not in 
(
 9612927,
10084087,
10084090,
11289325,
11289326,
11322320,
11328868
)

order by to_number(trim(substr(GID,13,10)))

/*
review: 
-- CASH should become 29-AUG-17
10311506
10312184
10312819
-- CASH should become 11-OCT-17
10869045
10869060
-- CASH should become JAN-18
11350275
-- Remove trades
 9612927
10084087
10084090 
11289325
11289326
11322320
11328868
*/