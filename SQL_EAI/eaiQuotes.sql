select
qot.ID, 
prd.Name PROD,
ins.Name INST, qot.LongName Q_LONG,
qot.CanonicalName Q_CANON, qot.VendorLongName Q_VENDOR,
pubs.Name PUBS, pubc.Name PUBC, fcal.CalendarCode CALCOD, fcal.CalendarName CAL,
cur.Symbol CUR, uom.Name UOM, qot.DefaultPrecision PRC,
qot.ConversionFactor CNV, qot.Lotsize LOT,
und.LongName U_LongName
from tblQuotes qot
left join tblProductCategories prd on qot.ProductCategoryID = prd.ID
left join tblProductGrade qly on qot.ProductID = qly.ID
left join tblInstrumentTypes ins on qot.InstrumentTypeID = ins.ID
left join tblMarkets pubc on qot.MarketFolderID = pubc.ID
left join tblMarkets pubs on pubc.ParentID = pubs.ID
left join tblCalendars cal on qot.CalendarID = cal.ID
left join tblFCCalendars fcal on cal.FCCalendarID = fcal.ID
left join tblCurrencies cur on qot.CurrencyID = cur.ID
left join tblUnits uom on qot.UnitID = uom.ID
left join tblQuotes und on qot.UnderlyingFutureID = und.ID
order by prd.Name, ins.Name, qot.LongName