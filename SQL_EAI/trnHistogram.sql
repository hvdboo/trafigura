-- Oil Futures
select 
'Oil FUT' TRNTYP,
plufut.EAIQuote QOT,
case when plufut.InternalDealID IS NULL then 'E' else 'I' end IE,
plufut.BOOK BOOK, plufut.Counterparty CTP,
count(plufut.AspectID) OCC
from EAIArchive.dbo.tblPlutoFutures plufut
where plufut.TradeDate > '2017-01-01'
and plufut.IsDeleted = 0
group by
plufut.EAIQuote,
case when plufut.InternalDealID IS NULL then 'E' else 'I' end,
plufut.BOOK, plufut.Counterparty

union

-- Coal Futures
select 
'Coal FUT' TRNTYP,
plucoal.EAIQuote QOT,
case when plucoal.InternalDealID IS NULL then 'E' else 'I' end IE,
plucoal.BOOK BOOK, plucoal.Counterparty CTP,
count(plucoal.AspectID) OCC
from EAIArchive.dbo.tblPlutoCoalFutures plucoal
where plucoal.TradeDate > '2017-01-01'
and plucoal.IsDeleted = 0
group by
plucoal.EAIQuote,
case when plucoal.InternalDealID IS NULL then 'E' else 'I' end,
plucoal.BOOK, plucoal.Counterparty

union

-- Freight Futures
select 
'Freight FUT' TRNTYP,
pluffa.EAIQuote QOT,
case when pluffa.InternalDealID IS NULL then 'E' else 'I' end IE,
pluffa.BOOK BOOK, pluffa.Counterparty CTP,
count(pluffa.AspectID) OCC
from EAIArchive.dbo.tblPlutoFFAs pluffa
where pluffa.TradeDate > '2017-01-01'
and pluffa.IsDeleted = 0
group by
pluffa.EAIQuote,
case when pluffa.InternalDealID IS NULL then 'E' else 'I' end,
pluffa.BOOK, pluffa.Counterparty

union

-- Cleared Swaps
select 
'Clr SWP' TRNTYP,
plucls.EAIQuote QOT,
'E' IE,
plucls.BOOK BOOK, plucls.Counterparty CTP,
count(plucls.AspectID) OCC
from EAIArchive.dbo.tblPlutoClearportSwaps plucls
where plucls.TradeDate > '2017-01-01'
and plucls.IsDeleted = 0
group by
plucls.EAIQuote,
plucls.BOOK, plucls.Counterparty

union

-- ET Options
select 
'Lst OPT' TRNTYP,
plueto.EAIQuote QOT,
'E' IE,
plueto.BOOK BOOK, plueto.Counterparty CTP,
count(plueto.AspectID) OCC
from EAIArchive.dbo.tblPlutoETOptions plueto
where plueto.TradeDate > '2017-01-01'
and plueto.IsDeleted = 0
group by
plueto.EAIQuote,
plueto.BOOK, plueto.Counterparty

union

-- Swaps
select 
'Otc SWP' TRNTYP,
pluswp.EAIQuote QOT,
case when pluswp.InternalDealID IS NULL then 'E' else 'I' end IE,
pluswp.BOOK BOOK, pluswp.Counterparty CTP,
count(pluswp.AspectID) OCC
from EAIArchive.dbo.tblPlutoSwaps pluswp
where pluswp.TradeDate > '2017-01-01'
and pluswp.IsDeleted = 0
group by
pluswp.EAIQuote,
case when pluswp.InternalDealID IS NULL then 'E' else 'I' end,
pluswp.BOOK, pluswp.Counterparty

-- Options
select 
'Otc OPT' TRNTYP,
pluopt.EAIQuote QOT,
'E' IE,
pluopt.BOOK BOOK, pluopt.Counterparty CTP,
count(pluopt.AspectID) OCC
from EAIArchive.dbo.tblPlutoOTCOptions pluopt
where pluopt.TradeDate > '2017-01-01'
and pluopt.IsDeleted = 0
group by
pluopt.EAIQuote,
pluopt.BOOK, pluopt.Counterparty
