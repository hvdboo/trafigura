select
rtrim(flthdr.M_SCR_LIB) LIB,
rtrim(flthdr.M_SCREEN) OBJ,
rtrim(flthdr.M_LABEL) LAB,
rtrim(flthdr.M_GROUP) GRP,
case
when grp.M_BO_FO = 0 then 'FO'
when grp.M_BO_FO = 1 then 'MO'
when grp.M_BO_FO = 2 and grp.M_ACTIVITY = 'E' then 'BO'
when grp.M_BO_FO = 2 and grp.M_ACTIVITY = 'C' then 'CFG' else null end GRPTYP,
rtrim(flthdr.M_USER_NAME) USR,
case flthdr.M_RGT_GROUP
when 0 then '___'
when 1 then 'A__'
when 2 then '_D_'
when 3 then 'AD_'
when 4 then '__U'
when 5 then 'A_U'
when 6 then '_DU'
when 7 then 'ADU' else null end RGTGRP,
case flthdr.M_RGT_EVBDY
when 0 then '___'
when 1 then 'A__'
when 2 then '_D_'
when 3 then 'AD_'
when 4 then '__U'
when 5 then 'A_U'
when 6 then '_DU'
when 7 then 'ADU' else null end RGTALL,

rtrim(fltbdy.M_FMLA_TEXT) DEF,
rtrim(flthdr.M_ID) ID,
rtrim(fltbdy.M_INDEX) SEQ

from SFVFLTS_DBF fltbdy
left join SFVFLTM_DBF flthdr on fltbdy.M_ID = flthdr.M_ID
left join TRN_GRPD_DBF grp on rtrim(flthdr.M_GROUP) = rtrim(grp.M_LABEL)

where rtrim(flthdr.M_SCREEN) in ('TRN_HDR.XDB', 'TRN_HDR.DBF')
order by OBJ, LAB, SEQ

