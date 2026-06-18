select srv.M_LABEL SERVICE,
col.M_LABEL COLLECTOR, vwr.M_CFG_LBL FORMAT,
lod.M_LABEL LOADER, lod.M_DESC DESCRIPTION, 
case lod.M_M_REF
when 2241 then 'Credit.Curves'
when 2242 then 'Forex.Spots'
when 2243 then 'Rates.Curves'
when 3684 then 'Commodities.Curves'
when 3685 then 'Commodities.Smile'
when 3686 then 'Commodities.Volatilities'
when 3688 then 'Commodities.Future prices'
when 4829 then 'Commodities.Index prices' else '' end CLASS, 
lod.M_QUERY QUERY, qry.M_FORMULA SQL_
from DATA_LOADER_COLL_DBF col
left join DATA_LOADERS_DBF ctn on col.M_LOADER = ctn.M_CTN
left join DATA_LOADER_DBF lod on ctn.M_REF = lod.M_REFERENCE
left join SQL_QRY_DBF qry on lod.M_QUERY = qry.M_LABEL
left join SERVICE_DBF srv on col.M_LOADER = srv.M_LOADER
left join VWR_CFGS_DBF vwr on srv.M_FORMATTER = vwr.M_CFG_REF
