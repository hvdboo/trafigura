select
TRNDAT as SYSDAT,
'I' TRN_IE, 
CTP_IE, 
SRC,
' ' TRN, 
' ' CNT, 
' ' CVS, 
' ' PCK,
'PRW_CNY_TRF:'||to_char(TRN) GID,
LE, 
CE,
'MXMLUSER' USR,
-- Switch PFL to what it had to be
-- CNY Pre-Wash
case PFL 
when 'BKEX JDI PTEI'	then 'BKEX JDI TICI'   -- (DRN - DRN)
when 'BKEX TRE PTEI'	then 'BKEX TRE TICI'   -- (DRN - DRN)
when 'BKPR IOHAP PTED'	then 'BKPR IOHAP TICD' -- (BLK - BLK) 
when 'COIR PTEI'	then 'COIR TICI'       -- (DRN - ?)
when 'COTS PBPAP TVTD'	then 'COTS PBPAP TICD' -- (DRN - DRN) 
when 'MCEX APE PTEI'	then 'Flat'            -- (DRN - ...)
when 'MCEX CHS PTEI'	then 'MCEX CHS TICI'   -- (DRN - DRN)
when 'MCEX CWU PTEI'	then 'MCEX CWU TICI'
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
when 'RMOT CUPEM PTEI'  then 'RMOT CUPAP TICD'
when 'RMOT MRI PTEI'	then 'RMOT MRI TICI'   -- (DRN - DRN)
when 'RMPR CUHAP TVTD'  then 'RMPR CUHAP TICD'
when 'RMTS CHS PTEI'	then 'RMAR CHS TICI'   -- (DRN - DRN)
when 'RMTS CUPAP TVTD'	then 'RMTS CUPAP TICD' -- (DRN - DRN)  
when 'RMTS ZNPAM CMXD'	then 'Flat'            -- (DRN - ...)
else null end PFL,
-- Keep Offset Counterpart
case 
when TRN_IE = 'I' then
case CTP 
when 'BKEX JDI PTEI'	then 'BKEX JDI TICI' 
when 'BKEX TRE PTEI'	then 'BKEX TRE TICI'
when 'BKPR IOHAP PTED'	then 'BKPR IOHAP TICD'
when 'COIR PTEI'	then 'COIR TICI'
when 'COTS PBPAP TVTD'	then 'COTS PBPAP TICD'
when 'MCEX APE PTEI'	then 'MCEX APE TICI'
when 'MCEX CHS PTEI'	then 'MCEX CHS TICI'
when 'MCEX NHA PTEI'	then 'MCEX NHA TICI'
when 'MCEX NSA PTEI'	then 'MCEX NSA TICI'
when 'MCEX SLI PTEI'	then 'MCEX SLI TICI'
when 'MCEX VLI PTEI'	then 'MCEX VLI TICI'
when 'MCEX ZLI PTEI'	then 'MCEX ZLI TICI'
when 'MCIR PTEI'	then 'MCIR TICI'
when 'RMAR CHS PTEI'	then 'RMAR CHS TICI'
when 'RMAR MRI PTEI'	then 'RMAR MRI TICI'
when 'RMAR NHA PTEI'	then 'RMAR NHA TICI'
when 'RMAR NHA TVTD'	then 'RMAR NHA TICI'
when 'RMIR NTTI'	then 'RMIR TICI'
when 'RMIR PTEI'	then 'RMIR TICI'
when 'RMOP NSA TDLI'	then 'RMOP NSA TICI'
when 'RMOT CHS PTEI'	then 'RMAR CHS TICI'
when 'RMOT CUPEM PTEI'  then 'RMOT CUPAP TICD'
when 'RMOT MRI PTEI'	then 'RMOT MRI TICI'
when 'RMPR CUHAP TVTD'  then 'RMPR CUHAP TICD'
when 'RMTS CHS PTEI'	then 'RMAR CHS TICI'
when 'RMTS CUPAP TVTD'	then 'RMTS CUPAP TICD'
when 'RMTS ZNPAM CMXD'	then 'Flat'
else null end
else
coalesce(case when PFL = PFLINI then CTPINI else PFLINI end, PFLDST,'BKEX TRE PTEI') 
end CTP,
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

order by to_number(trim(substr(GID,13,10)))

/*
review: 
-- SYSDAT 20171017
10915067
*/