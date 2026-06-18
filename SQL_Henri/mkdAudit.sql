select aud.*

from MPAUD_BD_DBF aud
left join TRN_PC_DBF pc on 1 = 1

where 1 = 1
and aud.M_PL_DATE = pc.M_DATE
-- and to_char(aud.M_PL_DATE,'YYYYMMDD') = '20221006'
and rtrim(aud.M_PARAMALIAS) = 'RT'