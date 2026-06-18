select 
trn.PlutoID ID_PLU, trn.AspectID ID_ASP, trn.DealID  ID_DEAL,
'Pluto' STP_SRC,
convert(varchar,trn.TradeDate,102) TIM_L_DAT,
case trn.InternalAssigned
when 'true'  then 'I'
when 'false' then 'E' else null end TRN_IE,
case sign(trn.Quantity)
when  1 then 'B'
when -1 then 'S' else null end TRN_BS,
trn.GroupCompany PTY_A_TRAF, maporgn.T_VALC PTY_A_MX,
trn.Book PTY_A_PFL, trn.Trader PTY_A_TRD,
trn.Counterparty PTY_B_TRAF, maporgv.T_VALC PTY_B_MX,
'OTC' PRD_LO,
'COM¦SWAP¦' PRD_BOX,
'~Generator' PRD_INS,
case trn.FloatingFloating
when 'true'  then 'Flt-Flt'
when 'false' then 'Flt-Fix' else null end PRD_RSK,
convert(varchar,trn.StartDate,102) TRN_EFF,
case
when datediff(DAY, trn.StartDate,trn.EndDate) = 0 then '1d'
when datediff(DAY, trn.StartDate,trn.EndDate) in (29,30) then '1m' else 
convert(varchar,datediff(DAY, trn.StartDate,trn.EndDate))+'d' end  TRN_TEN,
convert(varchar,case when trn.EndDate > coalesce(trn.EndDateSecondLeg,'') then trn.EndDate else trn.EndDateSecondLeg end,102) TRN_EXP,
trn.Currency TRN_CUR,
mapuom.T_VALC TRN_UOM,
abs(trn.Quantity) TRN_QTY,
trn.FixedPrice TRN_STK,
trn.EAIQuote L01_IND_, mapqot1.T_VALC L01_IND_MX,
cur1.Symbol L01_CUR, mapuom1.T_VALC L01_UOM,
convert(varchar,trn.StartDate,102) L01_P01_CALF,
convert(varchar,trn.EndDate,102) L01_P01_CALL,
substring(trn.PricingFormulaSecondLeg,2,len(trn.PricingFormulaSecondLeg)-2) L02_IND_,
mapqot2.T_VALC L02_IND_MX,
cur2.Symbol L02_CUR, mapuom2.T_VALC L02_UOM,
convert(varchar,trn.StartDateSecondLeg,102) L02_P01_CALF,
convert(varchar,trn.EndDateSecondLeg,102) L02_P01_CALL,
trn.Broker PTY_C_LAB,
-- SUN Cost code
case trn.CommissionCostType
when 'C63' then 'Hedge Commissions - Swaps' else trn.CommissionCostType end FLW_TYP,
'USD' FLW_CUR,
trn.Commission FLW_AMT
from EAIArchive.dbo.tblPlutoSwaps trn
left join EAI.dbo.tblQuotes qot1 on trn.EAIQuoteID = qot1.ID
left join EAI.dbo.tblCurrencies cur1 on qot1.CurrencyID = cur1.ID
left join EAI.dbo.tblQuotes qot2 on substring(trn.PricingFormulaSecondLeg,2,len(trn.PricingFormulaSecondLeg)-2) = qot2.LongName
left join EAI.dbo.tblCurrencies cur2 on qot2.CurrencyID = cur2.ID
left join EAI.dbo.tblMapTrafMx maporgn on (trn.GroupCompanyID = maporgn.S_VALN and maporgn.LAB = 'org')
left join EAI.dbo.tblMapTrafMx maporgv on (trn.CounterpartyID = maporgv.S_VALN and maporgv.LAB = 'org')
left join EAI.dbo.tblMapTrafMx mapuom  on (trn.QuantityUOM = mapuom.S_VALC and mapuom.LAB = 'uom')
left join EAI.dbo.tblMapTrafMx mapqot1 on (trn.EAIQuoteID = mapqot1.S_VALN and mapqot1.LAB = 'qot')
left join EAI.dbo.tblMapTrafMx mapuom1 on (qot1.UnitID = mapuom1.S_VALN and mapuom1.LAB = 'uom')
left join EAI.dbo.tblMapTrafMx mapqot2 on (qot2.ID = mapqot2.S_VALN and mapqot2.LAB = 'qot')
left join EAI.dbo.tblMapTrafMx mapuom2 on (qot2.UnitID = mapuom2.S_VALN and mapuom2.LAB = 'uom')
where trn.TradeDate > '2016-05-31' 
order by PRD_INS, TRN_EXP