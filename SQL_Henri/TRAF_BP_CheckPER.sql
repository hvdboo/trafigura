select 
kud.ID SEQ,
rep.M_NB TRD,
rep.M_TP_GID GID,
rtrim(rep.M_INSTRUMENT) INS,
-- Dates
per.PER PER,
to_char(bk1.M_XPSTART,'YYYY-MM-DD') FST_MX,
to_char(bk1.M_XPEND,'YYYY-MM-DD') LST_MX,
to_char(per.FST,'YYYY-MM-DD') FST_KU,
to_char(per.LST,'YYYY-MM-DD') LST_KU,
(bk1.M_XPSTART - per.FST) FST_DIF,
(bk1.M_XPEND - per.LST) LST_DIF

from MUREX_DM_OWNER.CHECK_PL_REP rep
left join MUREX_MX_OWNER.RTBLOCK#RTBKSKL_DBF bks on rep.M_NB = bks.M_INT_NB
left join MUREX_MX_OWNER.RTBLOCK#RTBK0_DBF bk0 on bks.M_BK_INT_N = bk0.M_INT_NB
left join MUREX_MX_OWNER.RTBLOCK#RTBK1_DBF bk1 on bk0.M_LINK = bk1.M_LINK
left join MUREX_DM_OWNER.KUDUTRD kud on rtrim(rep.M_TP_GID) = rtrim(kud.FLXID)
left join MUREX_DM_OWNER.KUDUPER per on (rtrim(rep.M_TP_GID) = rtrim(per.FLXID) and per.FST = bk1.M_XPSTART)

where 1 = 1
and rtrim(rep.M_CNT_TYPO) = 'Back Pricing'
and rep.M_TP_DIR = 'B'
and kud.QTY > 0

order by SEQ, INS, GID, PER