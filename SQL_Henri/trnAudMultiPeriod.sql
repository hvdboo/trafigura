select rtrim(M_TRN_GRP) GRP, M_NB TRN, rtrim(M_BRW_ODPL) TEN
from TRN_HDR_DBF
where M_TRN_GTYPE in (130, 131)
and M_TRN_STATUS <> 'DEAD'
and trim(M_BRW_ODPL) in
(
'12m','12M','14m','16m','2m','30M','3m','4m','6m','7m','9m'
)
order by GRP, TRN