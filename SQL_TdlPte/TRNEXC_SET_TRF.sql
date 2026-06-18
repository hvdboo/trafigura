select
TRNDAT as SYSDAT,
'I' TRN_IE, 
'I' CTP_IE, 
SRC,
' ' TRN, 
' ' CNT, 
' ' CVS, 
' ' PCK,
'PREWSH_TRF:'||to_char(TRN) GID,
LE, 
CE,
'MXMLUSER' USR,
-- Switch PFL to what it had to be
-- USD Pre-Wash
/*
case PFL 
when 'BKAR IOPAP TICI' then 'BKAR IOPAP PTEI'
when 'BKEX TRE TICD'   then 'BKEX TRE PTEI'
when 'BKPR IOHAP TICD' then 'BKPR IOHAP PTED'
when 'COAR CUPAP TICD' then 'COAR CUPAP TVTD'
when 'COAR PBPAP TICD' then 'COAR PBPAP TVTD'
when 'COPR CUHAP TICD' then 'COPR CUHAP TVTD'
when 'COPR PBHAP TICD' then 'COPR PBHAP TVTD'
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
when 'RMPR NIHAP TICD' then 'RMPR NIHAP PTED' else null end PFL, 
*/
-- CNY Pre-Wash
case PFL 
when 'BKEX JDI PTEI'	then 'BKEX JDI TICI'   -- (DRN - DRN)
when 'BKEX TRE PTEI'	then 'BKEX TRE TICI'   -- (DRN - DRN)
when 'BKPR IOHAP PTED'	then 'BKPR IOHAP TICD' -- (BLK - BLK) 
when 'COIR PTEI'	then 'COIR TICI'       -- (DRN - ?)
when 'COTS PBPAP TVTD'	then 'COTS PBPAP TICD' -- (DRN - DRN) 
when 'MCEX APE PTEI'	then 'Flat'            -- (DRN - ...)
when 'MCEX CHS PTEI'	then 'MCEX CHS TICI'   -- (DRN - DRN)
when 'MCEX NHA PTEI'	then 'MCEX NHA TICI'   -- (DRN - DRN)
when 'MCEX NSA PTEI'	then 'MCEX NSA TICI'   -- (DRN - DRN)
when 'MCEX SLI PTEI'	then 'MCEX SLI TICI'   -- (DRN - DRN)
when 'MCEX VLI PTEI'	then 'MCEX VLI TICI'   -- (DRN - DRN)
when 'MCEX ZLI PTEI'	then 'MCEX ZLI TICI'   -- (DRN - DRN)
when 'MCIR PTEI'	then 'MCIR TICI'       -- (DRN - DRN)
when 'RMAR CHS PTEI'	then 'RMAR CHS TICI'   -- (DRN - DRN)
when 'RMAR MRI PTEI'	then 'RMAR MRI TICI'   -- (DRN - DRN)
when 'RMAR NHA PTEI'	then 'RMAR NHA TICI'   -- (DRN - DRN)
when 'RMAR NHA TVTD'	then 'RMAR NHA TICI'   -- (DRN - DRN)
when 'RMIR NTTI'	then 'RMIR TICI'       -- (DRN - ?)
when 'RMIR PTEI'	then 'RMIR TICI'       -- (DRN - ?)
when 'RMOP NSA TDLI'	then 'RMOP NSA TICI'   -- (DRN - DRN)
when 'RMOT CHS PTEI'	then 'RMAR CHS TICI'   -- (DRN - DRN)
when 'RMOT MRI PTEI'	then 'RMOT MRI TICI'   -- (DRN - DRN)
when 'RMTS CHS PTEI'	then 'RMAR CHS TICI'   -- (DRN - DRN)
when 'RMTS CUPAP TVTD'	then 'RMTS CUPAP TICD' -- (DRN - DRN)  
when 'RMTS ZNPAM CMXD'	then 'Flat'            -- (DRN - ...)
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

from TRNEXC_GET

order by to_number(trim(substr(GID,12,10)))