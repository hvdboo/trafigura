select distinct
-- GroupCompany, GroupCompanyID
-- , Book
-- Counterparty
-- Broker
CommissionCostType
from tblPlutoFutures
order by CommissionCostType


select distinct
PlutoQuote, EAIQuote, EAIQuoteID
from tblPlutoFutures
-- where TradeDate > '2015-12-31'
order by EAIQuote


select max(TradeDate) from tblPlutoFutures

select * from tblAspectFutures where AspectID = 'IF14406623'

select * from tblPlutoSwaps where TradeDate > '2016-05-31'

select distinct InternalAssigned from tblPlutoSwaps