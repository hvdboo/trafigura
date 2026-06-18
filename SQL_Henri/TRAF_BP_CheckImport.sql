select *
from
(
select 
kud.FLXID KUD,
rep.M_TP_GID GID,
rep.M_NB KUDTRD

from MUREX_DM_OWNER.KUDUTRD kud
left join MUREX_DM_OWNER.CHECK_PL_REP rep on rtrim(kud.FLXID) = rtrim(rep.M_TP_GID)
)

where coalesce(KUDTRD,1) = 1