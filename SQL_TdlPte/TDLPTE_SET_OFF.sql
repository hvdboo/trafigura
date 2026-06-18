select
tdlpte.SYSDAT,
tdlpte.TRN_IE, 
tdlpte.CTP_IE, 
case when tdlpte.SRC in ('TRT','ECN','TH') then tdlpte.SRC else 'mx' end SRC,
tdlpte.TRN, 
tdlpte.CNT, 
tdlpte.CVS, 
tdlpte.PCK,
'TDLPTE_OFF:'||to_char(tdlpte.TRN) GID,
tdlpte.LE, 
tdlpte.CE,
case when tdlpte.USR = 'RICHARD.E0' then 'MXMLUSER' else tdlpte.USR end USR,
case when tdlpte.SRC in ('TRT','ECN','TH') then PFL else 
case when substr(PFLP,3,2) = 'IR' then PFL else coalesce(PFLP,PFL) end end PFL,
tdlpte.CTP,
tdlpte.LO, 
tdlpte.ASS, 
tdlpte.FGT, 
tdlpte.TYPO,
tdlpte.INS, 
tdlpte.FUT, 
tdlpte.IND, 
tdlpte.UND, 
tdlpte.QOT, 
tdlpte.PUB, 
tdlpte.HSR, 
tdlpte.HSR2,
tdlpte.CUR, 
tdlpte.UOM,
tdlpte.UOD,
tdlpte.PHY,
tdlpte.MAT, 
tdlpte.FUTMAT, 
tdlpte.OPTMAT,
tdlpte.CFST1, 
tdlpte.CLST1, 
tdlpte.CFST2, 
tdlpte.CLST2,
tdlpte.STL, 
tdlpte.EXP,
tdlpte.STK, 
tdlpte.CP,
-- Switch BS
case tdlpte.BS
when 'B' then 'S'
when 'S' then 'B'
else null end as BS,
tdlpte.LOTSIZ,
tdlpte.NOM1,
tdlpte.NOM2, 
tdlpte.QTY, 
tdlpte.CAPQTY, 
tdlpte.DLVQTY,
case when FGTID in (84,101,103,113,131,146) then 0 else tdlpte.PRC1 end PRC1, 
tdlpte.MRG1, 
tdlpte.PRC2, 
tdlpte.MRG2,
tdlpte.FGTID, 
tdlpte.FUTID, 
tdlpte.INDID, 
tdlpte.QOTID, 
tdlpte.PUBID, 
tdlpte.HSRID, 
tdlpte.HISFIL, 
tdlpte.MATSETID, 
tdlpte.FMATID

from TDLPTE_VW03 tdlpte
-- from TRAF_TDLPTE tdlpte

-- where tdlpte.LO = 'LST'
-- and tdlpte.LO = 'OTC'
-- and tdlpte.CTP = 'WESTPAC BANKING CORPORATION'
-- where tdlpte.SRC not in ('ECN','TH') and tdlpte.FGTID <> 154
-- where tdlpte.USR = 'ROSHAN.SH0'

order by CTP, FGT, INS, EXP, STK

