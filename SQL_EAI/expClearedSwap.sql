select 
trn.PlutoID ID_PLU, trn.AspectID ID_ASP, trn.DealID  ID_DEAL,
'Pluto' STP_SRC,
convert(varchar,trn.TradeDate,102) TIM_L_DAT,
'E' TRN_IE,
case sign(trn.Quantity)
when  1 then 'B'
when -1 then 'S' else null end TRN_BS,
trn.GroupCompany PTY_A_TRAF, maporgn.T_VALC PTY_A_MX,
trn.Book PTY_A_PFL, trn.Trader PTY_A_TRD,
trn.Counterparty PTY_B_LAB, maporgv.T_VALC PTY_B_MX,
'LST' PRD_LO,
'COM¦SWAP¦CLR¦' PRD_BOX,
trn.EAIQuote PRD_INS, 
qot.Longname PRD_RSK, mapqot.T_VALC L01_IND_MX,
convert(varchar,trn.StartDate,102) TRN_EFF,
case
when datediff(DAY, trn.StartDate,trn.EndDate) = 0 then '1d'
when datediff(DAY, trn.StartDate,trn.EndDate) in (29,30) then '1m' 
else convert(varchar,datediff(DAY, trn.StartDate,trn.EndDate))+'d' end TRN_TEN,
convert(varchar,trn.EndDate,102) TRN_EXP,
cur.Symbol TRN_CUR, mapuom.T_VALC TRN_UOM,
abs(trn.Quantity) TRN_QTY,
trn.FixedPrice TRN_STK,
trn.Broker PTY_C_LAB,
case trn.CommissionCostType
when 'C61' then 'Hedge Commissions - Futures' else trn.CommissionCostType end FLW_TYP,
'USD' FLW_CUR,
trn.Commission FLW_AMT
from EAIArchive.dbo.tblPlutoClearPortSwaps trn
left join EAI.dbo.tblQuotes qot on trn.EAIQuoteID = qot.ID
left join EAI.dbo.tblCurrencies cur on qot.CurrencyID = cur.ID
left join EAI.dbo.tblUnits uom on qot.UnitID = uom.ID
left join EAI.dbo.tblMapTrafMx maporgn on (trn.GroupCompanyID = maporgn.S_VALN and maporgn.LAB = 'org')
left join EAI.dbo.tblMapTrafMx maporgv on (trn.CounterpartyID = maporgv.S_VALN and maporgv.LAB = 'org')
left join EAI.dbo.tblMapTrafMx mapqot on (trn.EAIQuoteID = mapqot.S_VALN and mapqot.LAB = 'qot')
left join EAI.dbo.tblMapTrafMx mapuom on (qot.UnitID = mapuom.S_VALN and mapuom.LAB = 'uom')
where trn.TradeDate > '2016-05-31' 
order by PRD_INS, TRN_EXP