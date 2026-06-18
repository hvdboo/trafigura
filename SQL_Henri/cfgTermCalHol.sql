select 
rtrim(cal.M_LABEL) CAL,  rtrim(cal.M_DESC) CALDESC,
to_char(hol.M_DATE,'YYYY-MM-DD') HOLDAT,
case when hol.M_GENERAL = 1 then 'Yearly' else null end OCC,
rtrim(hol.M_COMMENT) HOLCMT

from CAL_HOL_DBF hol
left join CAL_DEF_DBF cal on hol.M_CAL_LABEL = cal.M_LABEL
left join TRN_PC_DBF pc on 1 = 1

where 1 = 1
and rtrim(cal.M_LABEL) in ('PLY','SIB')
and (hol.M_GENERAL = 1 or (hol.M_GENERAL = 0 and to_char(hol.M_DATE,'YYYY-MM-DD') > '2016-12-31'))
--and hol.M_DATE > pc.M_DATE - to_dsinterval('365 00:00:00')

order by HOLDAT, CAL