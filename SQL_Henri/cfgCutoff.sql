select 
cit.M_COFFCODE CODE, rtrim(cit.M_LABEL) CITY,
rtrim(cit.M_COMMENT) DESCR,
rtrim(cit.M_SWIFT_LOC) SWIFT,
cit.M_COFFTIME GMTSHF,
(cit.M_CUTHOUR||':'||cit.M_CUTMIN) LOCTIM
from CITIES_DBF cit
order by CODE