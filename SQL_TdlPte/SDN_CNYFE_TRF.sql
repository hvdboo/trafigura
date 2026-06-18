select 
STL SYSDAT,
'I' TRN_IE,
'I' CTP_IE,
'mx.sellDown' SRC,
' ' TRN, 
' ' CNT, 
' ' CVS, 
' ' PCK,
-- GID
'SDN_CNYFE_TRF:'||trim(PL_KEY) GID,
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
STL CFST1, 
STL CLST1, 
' ' CFST2, 
' ' CLST2,
STL STL, 
to_char(EXP,'YYYYMMDD') EXP,
SP0FEE STK,
-- Direction
case 
when PL_FE < 0  then 'P'
when PL_FE >= 0 then 'R' else null end as BS,
' ' LOTSIZ,
-- Flow amount
abs(round(PL_FE/SP0FEE,4)) NOM1,
' ' NOM2, 
PL_FE QTY,
' ' CAPQTY, 
' ' DLVQTY,
round(1/SP0FEE,12) PRC1,
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
rtrim(sdn.M_PL_KEY1) PL_KEY,
sdn.M_TP_DTEEXP EXP,
-- sdn.M_FX_SP0EXP SP0,
greatest(
to_char(sdn.M_TP_DTETRN,'YYYYMMDD'),
coalesce(to_char(sdn.M_TP_FEEDAT0,'YYYYMMDD'),'0'), 
coalesce(to_char(sdn.M_TP_FEEDAT1,'YYYYMMDD'),'0')) STL,
sdn.M_FX_SP0FEE SP0FEE,
sum(sdn.M_PL_FE_FIN2) PL_FE,
count(*) OCC
-- to_char(csh.M_TP_DTEEXP,'YYYY-MM-DD'), csh.M_NB

from MUREX_DM_OWNER.SDN_PL_REP sdn
left join MUREX_MX_OWNER.RTGSDPB_DBF pflAsgB on rtrim(sdn.M_TP_PFOLIO) = rtrim(pflAsgB.M_PORTFOLIO)

where sdn.M_FX_SP0FEE <> 0
-- and M_MX_REF_JOB = (:JOB)

group by
sdn.M_TP_PFOLIO,
rtrim(pflAsgB.M_SDPTF),
-- sdn.M_TRN_GRP,
-- sdn.M_TRN_TYPE,
-- rec.M_CNT_TYPO,
sdn.M_INSTRUMENT,
sdn.M_C_CUR_PL,
sdn.M_PL_KEY1,
sdn.M_TP_DTEEXP,
greatest(
to_char(sdn.M_TP_DTETRN,'YYYYMMDD'),
coalesce(to_char(sdn.M_TP_FEEDAT0,'YYYYMMDD'),'0'), 
coalesce(to_char(sdn.M_TP_FEEDAT1,'YYYYMMDD'),'0')),
sdn.M_FX_SP0FEE

-- order by PFL, INS, EXP

)

where PL_FE <> 0 
and SP0FEE <> 0
and STL >= (:STL_FST) 
and STL <= (:STL_LST)
order by PFL, INS, EXP, STL
