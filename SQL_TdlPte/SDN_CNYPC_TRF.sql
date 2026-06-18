select 
to_char(EXP,'YYYYMMDD') SYSDAT,
'I' TRN_IE,
'I' CTP_IE,
'mx.sellDown' SRC,
' ' TRN, 
' ' CNT, 
' ' CVS, 
' ' PCK,
-- GID
'SDN_CNYPC_TRF' GID,
' ' LE, 
' ' CE,
'MXMLUSER' USR,
-- Parties
PFL PFL,
CTP CTP,
' ' LO, 
' ' ASS, 
'SCF SDN' TYPO,
INS INS, 
' ' FUT, 
' ' IND, 
' ' UND, 
' ' QOT, 
' ' PUB, 
' ' HSR,
' ' HSR2,
-- Currency
'USD' CUR, 
' ' UOM,
' ' UOD, 
' ' PHY,
' ' MAT, 
' ' FUTMAT, 
' ' OPTMAT,
to_char(EXP,'YYYYMMDD') CFST1, 
to_char(EXP,'YYYYMMDD') CLST1, 
' ' CFST2, 
' ' CLST2,
to_char(EXP,'YYYYMMDD') STL, 
to_char(EXP,'YYYYMMDD') EXP,
SP0EXP STK,
-- Direction
case 
when PL_PC < 0  then 'P'
when PL_PC >= 0 then 'R' else null end as BS,
' ' LOTSIZ,
-- Flow amount
abs(round(PL_PC/SP0EXP,4)) NOM1,
' ' NOM2, 
PL_PC QTY,
' ' CAPQTY, 
' ' DLVQTY,
round(1/SP0EXP,12) PRC1,
' ' MRG1, 
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

from

(
select
rtrim(sdn.M_TP_PFOLIO) PFL,
rtrim(pflAsgB.M_SDPTF) CTP,
-- sdn.M_TRN_GRP GRP, sdn.M_TRN_TYPE TYP,
-- rec.M_CNT_TYPO TYPO,
rtrim(sdn.M_INSTRUMENT) INS,
rtrim(sdn.M_C_CUR_PL) CUR,
-- rtrim(sdn.M_PL_KEY1) PL_KEY,
sdn.M_TP_DTEEXP EXP,
sdn.M_FX_SP0EXP SP0EXP,
sum(sdn.M_PL_GEPL2) PL_GE,
sum(sdn.M_PL_PC_FIN2) PL_PC,
sum(sdn.M_PL_FP_FIN2) PL_FP,
sum(sdn.M_PL_MV_FIN2) PL_MV,
sum(sdn.M_PL_FE_FIN2) PL_FE,
count(*) OCC
-- to_char(csh.M_TP_DTEEXP,'YYYY-MM-DD'), csh.M_NB

from MUREX_DM_OWNER.SDN_PL_REP sdn
left join MUREX_MX_OWNER.RTGSDPB_DBF pflAsgB on rtrim(sdn.M_TP_PFOLIO) = rtrim(pflAsgB.M_PORTFOLIO)

where  
substr(sdn.M_TP_GID,8,2) <> 'FE'
and M_TP_STATUS2 = 'DEAD'
-- and to_char(sdn.M_TP_DTEEXP,'YYYYMMDD') >= (:EXP)
-- and M_MX_REF_JOB = (:JOB)

group by
sdn.M_TP_PFOLIO,
rtrim(pflAsgB.M_SDPTF),
-- sdn.M_TRN_GRP,
-- sdn.M_TRN_TYPE,
-- rec.M_CNT_TYPO,
sdn.M_INSTRUMENT,
sdn.M_C_CUR_PL,
-- sdn.M_PL_KEY1,
sdn.M_TP_DTEEXP,
sdn.M_FX_SP0EXP

-- order by PFL, INS, EXP

)

where PL_PC <> 0
-- and PFL in ('RMOT PBPAP TICD','RMTS CUPAP TICD','RMTS PBPAP TICD')

order by PFL, INS, EXP