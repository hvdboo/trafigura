select 
rtrim(fxs.M__ALIAS_) MDS,
to_char(fxs.M__DATE_,'YYYY-MM-DD') DAT,
fxs.M_NUM NUM, fxs.M_DEN DEN, fxs.M_REF_QUOT QOT,
fxs.M_SPOT_RF_B BID, fxs.M_SPOT_RF_A ASK
from MPX_SPOT_DBF fxs
where to_char(fxs.M__DATE_,'YYYY-MM-DD') = '2019-04-30'
and rtrim(fxs.M__ALIAS_) = 'LANA MDS'
and fxs.M_REF_QUOT = 'USD-ARO'