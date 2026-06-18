select 
pldgrp.VALDAT SYSDAT,
pldgrp.VALDAT TRNDAT,
'mx' SRC,
null TRN,
null CNT,
null CVS,
null PCK,
'BWR_TRF:'||to_char(ROWNUM,'000') GID,
'I' TRN_IE,
'I' CTP_IE,
pldgrp.LE LE,
pldgrp.CE CE,
'DD_ALL' USRGRP,
'MXMLUSER' USR,
pldgrp.PFL PFL,
case rtrim(pldgrp.PFL)
when 'MCEX BWR PTEI' then 'MCEX ACL PTEI' 
when 'RMOP BWR PTEI' then 'RMOP ACL PTEI'
else null end CTP,
pldgrp.ASS ASS,
'O' LO,
pldgrp.TYPO TYPO,
pldgrp.INS INS,
pldgrp.PHY PHY,
pldgrp.QOT0 QOT1,
pldgrp.UND0 UND1,
pldgrp.PUB0 PUB1,
pldgrp.HSR0 HSR1,
pldgrp.IND1 IND2,
-- pldgrp.QOT1 QOT2,
-- pldgrp.UND1 UND2,
-- pldgrp.PUB1 PUB2,
pldgrp.HSR1 HSR2,
pldgrp.CUR CUR,
pldgrp.UOQ UOM,
pldgrp.UOD UOD,
-- pldgrp.UOV UOM,
pldgrp.LOTSIZ LOTSIZ,
pldgrp.MAT MAT,
pldgrp.FUTMAT FUTMAT,
pldgrp.OPTMAT OPTMAT,
pldgrp.CFST0 CFST1,
pldgrp.CLST0 CLST1,
pldgrp.CFST1 CFST2,
pldgrp.CLST1 CLST2,
null STL,
pldgrp.EXP EXP,
pldgrp.STK STK,
pldgrp.RGT RGT,
case pldgrp.DIR
when 'B' then 'S'
when 'S' then 'B' else null end DIR,
pldgrp.NOM0 NOM1,
pldgrp.NOM1 NOM2,
abs(pldgrp.QTYSGN) QTY,
pldgrp.RTE0 PRC1,
pldgrp.MRG0 MRG1,
pldgrp.RTE1 PRC2,
pldgrp.MRG1 MRG2,
pldgrp.OCC OCC

from TRNEXT_PLD_VW02 pldgrp

where 1 = 1
and pldgrp.QTYSGN <> 0

-- Forward
-- and pldgrp.TYPO = 'Forward COM'
-- and pldgrp.PHY in ('LEAD','ZINC')

-- Swap
-- and pldgrp.TYPO = 'Swap COM'
-- and pldgrp.CLST0 > 20210208

-- Asian
and pldgrp.TYPO = 'Asian Option COM'

-- Unpriced Avg
-- and pldgrp.TYPO = 'Unpriced Average'

-- Spot
-- and pldgrp.TYPO in ('Spot COM' , 'Spot Forward COM')

-- Option
-- and pldgrp.TYPO in ('Option on Forward')
-- and pldgrp.CLST0 > 20210208

order by PFL, ASS, PHY, INS, TYPO, INS, CLST1, STK, RGT
