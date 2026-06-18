select
rtrim(srv.M_LABEL) SRVLAB, rtrim(srv.M_DESC) SRVDES,
rtrim(load.M_LABEL) LOADLAB, rtrim(load.M_DESC) LOADDES,
rtrim(qry.M_LABEL) QRY, 
qry.M_FORMULA,
M_FORMATTER FMT

from SERVICE_DBF srv
left join DATA_LOADERS_DBF loads on srv.M_LOADER = loads.M_CTN
left join DATA_LOADER_DBF load on loads.M_REF = load.M_REFERENCE
left join SQL_QRY_DBF qry on rtrim(load.M_QUERY) = rtrim(qry.M_LABEL)
order by srv.M_LABEL