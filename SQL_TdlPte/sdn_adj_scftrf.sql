SELECT 
to_char(EXP,'YYYYMMDD') SYSDAT,
'I' TRN_IE,
'I' CTP_IE,
'mx.sellDown' SRC,
' ' TRN, 
' ' CNT, 
' ' CVS, 
' ' PCK,
'SDN_CNYCA_TRF' GID,
' ' LE, 
' ' CE,
'MXMLUSER' USR,
PFL PFL,
CTP CTP,
' ' LO, 
' ' ASS, 
'SCF SDN' TYPO,
'USD' INS, 
' ' FUT, 
' ' IND, 
' ' UND, 
' ' QOT, 
' ' PUB, 
' ' HSR,
' ' HSR2,
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
CASE 
WHEN PL_PC < 0  THEN 'P'
WHEN PL_PC >= 0 THEN 'R' ELSE NULL END BS,
' ' LOTSIZ,
ABS(round(PL_PC/SP0EXP,4)) NOM1,
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
' ' FMATID,
ASG1 PLASG1,
ASG2 PLASG2

FROM
(
select
rtrim(sdn.M_TP_PFOLIO) PFL,
rtrim(pflAsgB.M_SDPTF) CTP,
rtrim(sdn.M_INSTRUMENT) INS,
rtrim(sdn.M_C_CUR_PL) CUR,
rtrim(udf.M_PL_ASSIG) ASG1,
rtrim(udf.M_PL_ASSIG2) ASG2,
sdn.M_TP_DTEEXP EXP,
sdn.M_FX_SP0EXP SP0EXP,
sum(sdn.M_PL_GEPL2) PL_GE,
sum(sdn.M_PL_PC_FIN2) PL_PC,
sum(sdn.M_PL_FP_FIN2) PL_FP,
sum(sdn.M_PL_MV_FIN2) PL_MV,
sum(sdn.M_PL_FE_FIN2) PL_FE,
count(*) OCC

from MUREX_DM_OWNER.SDN_PL_REP sdn
left join MUREX_DM_OWNER.SDN_PFLASG_REP pflAsgB on rtrim(sdn.M_TP_PFOLIO) = rtrim(pflAsgB.M_PORTFOLIO)
left join MUREX_MX_OWNER.TRN_EXT_DBF ext on (sdn.M_NB = ext.M_TRADE_REF and sdn.M_CNT_VS2 = ext.M_VERSION)
left join MUREX_MX_OWNER.TABLE#DATA#DEALSCF_DBF udf on ext.M_UDF_REF = udf.M_NB

where 
rtrim(sdn.M_TRN_GRP) = 'SCF' 
and rtrim(sdn.M_CNT_TYPO) <>'SCF SDN'
-- and to_char(sdn.M_TP_DTEEXP,'YYYYMMDD') >=@Expiry:D

group by
sdn.M_TP_PFOLIO,
rtrim(pflAsgB.M_SDPTF),
sdn.M_INSTRUMENT,
sdn.M_C_CUR_PL,
udf.M_PL_ASSIG,
udf.M_PL_ASSIG2,
sdn.M_TP_DTEEXP,
sdn.M_FX_SP0EXP
)
WHERE PL_PC <> 0
ORDER BY STL, PFL, INS