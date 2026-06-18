select
tdlpte.SYSDAT,
tdlpte.TRN_IE, 
tdlpte.CTP_IE, 
case when tdlpte.SRC = 'TRT' then 'TRT' else 'mx' end SRC,
tdlpte.TRN, 
tdlpte.CNT, 
tdlpte.CVS, 
tdlpte.PCK,
'TDLPTE_TRF:'||to_char(tdlpte.TRN) GID,
'PTE' LE, 
tdlpte.CE, 
case when tdlpte.USR = 'RICHARD.E0' then 'MXMLUSER' else tdlpte.USR end USR,
-- Switch portfolio
/*
case 
when (ASS = 'FRT' and substr(PFL,1,2) = 'DF') then 
case FGTID 
when 100 then 'DFOT MSI TMPI' 
when 146 then 'DFOP MSI TMPI' end
else mappfl.PFLTGT end as PFL,
*/
mappfl.PFLTGT PFL,
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
tdlpte.BS,
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
left join TRAF_PFLMAP mappfl on tdlpte.PFL = mappfl.PFLSRC

-- where tdlpte.LO = 'OTC'
-- and tdlpte.CTP = 'WESTPAC BANKING CORPORATION'

order by CTP, FGT, INS, EXP, STK

