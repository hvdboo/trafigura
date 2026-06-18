select 
kud.ID SEQ,
rep.M_NB TRD,
rep.M_TP_GID GID,
to_char(rep.M_TP_DTETRN,'YYYY-MM-DD') TRDDAT_MX,
to_char(kud.TRDDAT,'YYYY-MM-DD') TRDDAT_MX,
(rep.M_TP_DTETRN - kud.TRDDAT) TRDDAT_DIF,
rtrim(rep.M_INSTRUMENT) INS,
-- Dates
to_char(bk0.M_XPRMPT,'YYYY-MM-DD') PMPDAT_MX,
to_char(kud.PRMPT,'YYYY-MM-DD') PMPDAT_KU,
(bk0.M_XPRMPT - kud.PRMPT) PMPDAT_DIF,
to_char(bk0.M_XEXPIRY,'YYYY-MM-DD') EXPDAT_MX,
to_char(kud.EXPIRY,'YYYY-MM-DD') EXPDAT_KU,
(bk0.M_XEXPIRY - kud.EXPIRY) EXPDAT_DIF,
-- Shifters
trim(bk0.M_XPSHIFT) PSH_MX,
kud.PSHIFT PSH_KU,
(bk0.M_XPSHIFT - kud.PSHIFT) PSH_DIF,
trim(bk0.M_XVSHIFT) VSH_MX, 
kud.VSHIFT VSH_KU,  
(bk0.M_XVSHIFT - kud.VSHIFT) VSH_DIF,
rep.M_TP_CP RGT,
rep.M_TP_DIR DIR,
rep.M_TP_NOM NOM,
-- QTY
rep.M_TP_LQTY2 QTY_MX,
kud.QTY QTY_KU,
(rep.M_TP_LQTY2 - kud.QTY) QTY_DIF,
-- PRM
to_char(rep.M_TP_DTEPMT,'YYYY-MM-DD') PRMDAT_MX,
to_char(kud.DATPRM,'YYYY-MM-DD') PRMDAT_KU,
(rep.M_TP_DTEPMT - kud.DATPRM) PRMDAT_DIF,
rep.M_TP_PRICE PRMRTE_MX,
kud.PRMRTE PRMRTE_KU,
(rep.M_TP_PRICE - kud.PRMRTE) PRMRTE_DIF,
round(rep.M_PL_CSNF2, 2) PRMAMT_MX,
round(kud.PRMAMT,2) PRMAMT_KU,
(abs(rep.M_PL_CSNF2) - kud.PRMAMT) PRMAMT_DIF,
-- Parties
rep.M_TP_PFOLIO PFLSRC,
rep.M_TP_CNTRP  PFLDST,
kud.CTP CTP

from MUREX_DM_OWNER.CHECK_PL_REP rep
left join MUREX_DM_OWNER.KUDUTRD kud on rtrim(rep.M_TP_GID) = rtrim(kud.FLXID)
left join MUREX_MX_OWNER.RTBLOCK#RTBKSKL_DBF bks on rep.M_NB = bks.M_INT_NB
left join MUREX_MX_OWNER.RTBLOCK#RTBK0_DBF bk0 on bks.M_BK_INT_N = bk0.M_INT_NB

where 1 = 1
and rep.M_TP_DIR = 'B'
and kud.QTY > 0

order by SEQ, INS, GID