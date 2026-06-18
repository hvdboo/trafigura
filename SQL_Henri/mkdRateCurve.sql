select 
case rtc.M_EVALUATION
when 0 then 'Rate curve'
when 1 then 'Credit curve'
when 2 then 'Commodities'
when 3 then 'Hedge'
when 4 then 'Credit hedge'
when 5 then 'Inflation'
when 6 then 'Correlation' else null end NAT,
cur.M_LABEL CUR, 
rtrim(rtc.M_DLABEL) CRV,
rtrim(usr.M_LABEL) USR
-- rtc.M_LABEL, rtc.M_REFERENCE
from RT_CT_DBF rtc
left join FX_CURR_DBF cur on rtc.M_CURRENCY = cur.M_LABEL
left join MX_USER_DBF usr on rtc.M_USERID = usr.M_REFERENCE
where rtc.M_EVALUATION = 0
order by NAT, CUR, CRV