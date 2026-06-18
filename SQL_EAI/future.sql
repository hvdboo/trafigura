--EAI
select * from tblTrades where PlutoID = convert(char,13895678)

select * from tblTrades where PlutoID = 'S713309'
select * from tblStrategies where ID = 238478


-- Pluto
select * from tblExchangeInstrument where fut_ref = 13895678 
select * from tblFuturesData where FutureID = 13895678

select * from tblswaps where swp_Contract = 'S713309'
select * from tblSwapsAudit where swp_Contract = 'S713309'
select * from tblDeals where DealID = 179669
select * from tblTradesHeader where TradeID = 179669