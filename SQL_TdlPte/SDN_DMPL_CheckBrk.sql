select
sdn.M_NB TRN_SDN, brk.M_NB TRN_BRK,
rtrim(sdn.M_TP_PFOLIO) PFL_SDN, rtrim(pfl.M_LABEL) PFL_BRK,
to_char(sdn.M_TP_DTEEXP,'YYYYMMDD') EXP, 
to_char(sdn.M_TP_DTETRN,'YYYYMMDD') TRN,
to_char(brk.M_VALUE_DATE,'YYYYMMDD') STL,
(sdn.M_TP_DTETRN - brk.M_VALUE_DATE) DTE_DIFF,
sdn.M_PL_FE_FIN2 PL_FE, brk.M_FEE BRK,
(abs(sdn.M_PL_FE_FIN2) - abs(brk.M_FEE)) BRK_DIFF

from MUREX_DM_OWNER.SDN_PL_REP sdn
left join MUREX_MX_OWNER.TRN_BROKER_DBF brk on sdn.M_NB = brk.M_NB
left join MUREX_MX_OWNER.TRN_PFLD_DBF pfl on brk.M_SRC_PFOLIO = pfl.M_REF

where sdn.M_PL_FE_FIN2 <> 0
and brk.M_FEE <> 0
