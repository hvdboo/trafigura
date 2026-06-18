-- Oil Futures
select 
'Oil FUT' TRNTYP,
plufut.EAIQuote QOT, 
plufut.EAIQuoteID,
count(plufut.AspectID) OCC
from EAIArchive.dbo.tblPlutoFutures plufut
where plufut.TradeDate >= :DATBAS
and plufut.IsDeleted = 0
group by
plufut.EAIQuote
, plufut.EAIQuoteID

union

-- Coal Futures
select 
'Coal FUT' TRNTYP,
plucoal.EAIQuote QOT,
plucoal.EAIQuoteID,
count(plucoal.AspectID) OCC
from EAIArchive.dbo.tblPlutoCoalFutures plucoal
where plucoal.TradeDate >= :DATBAS
and plucoal.IsDeleted = 0
group by
plucoal.EAIQuote
,plucoal.EAIQuoteID

union

-- Freight Futures
select 
'Freight FUT' TRNTYP,
pluffa.EAIQuote QOT,
pluffa.EAIQuoteID,
count(pluffa.AspectID) OCC
from EAIArchive.dbo.tblPlutoFFAs pluffa
where pluffa.TradeDate >= :DATBAS
and pluffa.IsDeleted = 0
group by
pluffa.EAIQuote
,pluffa.EAIQuoteID

union

-- Cleared Swaps
select 
'Clr SWP' TRNTYP,
plucls.EAIQuote QOT,
plucls.EAIQuoteID,
count(plucls.AspectID) OCC
from EAIArchive.dbo.tblPlutoClearportSwaps plucls
where plucls.TradeDate >= :DATBAS
and plucls.IsDeleted = 0
group by
plucls.EAIQuote
,plucls.EAIQuoteID

union

-- ET Options
select 
'Lst OPT' TRNTYP,
plueto.EAIQuote QOT,
plueto.EAIQuoteID,
count(plueto.AspectID) OCC
from EAIArchive.dbo.tblPlutoETOptions plueto
where plueto.TradeDate >= :DATBAS
and plueto.IsDeleted = 0
group by
plueto.EAIQuote
,plueto.EAIQuoteID

union

-- Swaps
select 
'Otc SWP' TRNTYP,
pluswp.EAIQuote QOT,
pluswp.EAIQuoteID,
count(pluswp.AspectID) OCC
from EAIArchive.dbo.tblPlutoSwaps pluswp
where pluswp.TradeDate >= :DATBAS
and pluswp.IsDeleted = 0
group by
pluswp.EAIQuote
, pluswp.EAIQuoteID

union

-- Options
select 
'Otc OPT' TRNTYP,
pluopt.EAIQuote QOT,
pluopt.EAIQuoteID,
count(pluopt.AspectID) OCC
from EAIArchive.dbo.tblPlutoOTCOptions pluopt
where pluopt.TradeDate >= :DATBAS
and pluopt.IsDeleted = 0
group by
pluopt.EAIQuote
, pluopt.EAIQuoteID

order by TRNTYP, QOT