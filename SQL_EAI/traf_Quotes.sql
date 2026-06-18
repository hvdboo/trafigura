update traf_quotes qot set qot.CMP_MRK = 
(select distinct
asp.mdmMrk
from traf_aspect asp where qot.Q_LONG = asp.AspectName)
