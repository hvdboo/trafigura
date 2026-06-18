select distinct
rtrim(nav.M_NAV_LABEL) NAVTPL,
-- rtrim(nav.M_GRP_LABEL) GRP,
rtrim(nav.M_PATH) NAVPATH,
rtrim(nav.M_AISU) NAVRGT
from NAV_AUD_REP nav
where 
nav.M_REF_DATA = 35
and rtrim(nav.M_NAV_LABEL) in (
'NAV_MX_ACC_ALL',
'NAV_MX_BO_ALL',
'NAV_MX_CONFIG',
'NAV_MX_DD_ALL',
'NAV_MX_DD_T',
'NAV_MX_FO_EOD',
'NAV_MX_FO_T',
'NAV_MX_FOALL',
'NAV_MX_HOUSEKEEP',
'NAV_MX_MO',
'NAV_MX_MO_EOD',
'NAV_MX_TECH_ALL')
and rtrim(nav.M_GRP_LABEL) in (
'ACC_ALL',
'BO_ALL_T',
'CONFIG',
'DD_ALL',
'DD_EMEA',
'FO_ALL',
'FO_EOD',
'FO_EMEA',
'HOUSEKEEP',
'MO',
'MO_EOD',
'TECH_ALL')
order by NAVTPL, NAVPATH
