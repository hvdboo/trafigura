SELECT 
STL SYSDAT,
'I' TRN_IE,
'I' CTP_IE,
'mx.sellDown' SRC,
' ' TRN,
' ' CNT,
' ' CVS,
' ' PCK,
'SDN_CNYFE_TRF:'||substr(STL,5,4) GID,
' ' LE,
' ' CE,
'MXMLUSER' USR,
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
STL EXP,
SP0 STK,
CASE
WHEN NET_PL < 0  THEN 'P'
WHEN NET_PL >= 0 THEN 'R'
ELSE NULL END AS BS,
' ' LOTSIZ,
ABS(ROUND(NET_PL/SP0,4)) NOM1,
' ' NOM2,
NET_PL QTY,
' ' CAPQTY,
' ' DLVQTY,
round(1/SP0,12) PRC1,
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
FROM
(
select
rtrim(sdn.M_TP_PFOLIO) PFL,
rtrim(pflAsgB.M_SDPTF) CTP,
rtrim(sdn.M_INSTRUMENT) INS,
rtrim(sdn.M_C_CUR_PL) CUR,
greatest(to_char(sdn.M_TP_DTETRN,'YYYYMMDD'), coalesce(to_char(sdn.M_TP_FEEDAT0,'YYYYMMDD'),'0'), coalesce(to_char(sdn.M_TP_FEEDAT1,'YYYYMMDD'),'0')) STL,
sum(sdn.M_PL_FE_FIN2) PL_FE,
sum(case when (rtrim(sdn.M_CNT_TYPO) = 'SCF SDN' and rtrim(substr(sdn.M_TP_GID,8,6)) = 'FE_OFF') then sdn.M_PL_CSNF2 else 0 end) PL_SDN,
(
sum(case when (rtrim(sdn.M_CNT_TYPO) = 'SCF SDN' and rtrim(substr(sdn.M_TP_GID,8,6)) = 'FE_OFF') then sdn.M_PL_CSNF2 else 0 end) +    
sum(sdn.M_PL_FE_FIN2)
) NET_PL,
sum(case when sdn.M_FX_SP0FEE > 1 then sdn.M_FX_SP0FEE else 0 end)/
sum(case when sdn.M_FX_SP0FEE > 1 then 1 else null end) SP0,
count(*) OCC

from MUREX_DM_OWNER.SDN_PL_REP sdn
left join MUREX_DM_OWNER.SDN_PFLASG_REP pflAsgB on rtrim(sdn.M_TP_PFOLIO) = rtrim(pflAsgB.M_PORTFOLIO)

group by
sdn.M_TP_PFOLIO,
rtrim(pflAsgB.M_SDPTF),
sdn.M_INSTRUMENT,
sdn.M_C_CUR_PL,
greatest(TO_CHAR(sdn.M_TP_DTETRN,'YYYYMMDD'), coalesce(to_char(sdn.M_TP_FEEDAT0,'YYYYMMDD'),'0'), coalesce(to_char(sdn.M_TP_FEEDAT1,'YYYYMMDD'),'0'))
)

WHERE NET_PL <> 0
and PFL in ('MCEX HTE TICI', 'MCEX VLI TICI')
-- and INS in ('FE ORE DCE')
AND STL >= '20190901'
AND STL <= '20190930'
ORDER BY PFL, INS, STL