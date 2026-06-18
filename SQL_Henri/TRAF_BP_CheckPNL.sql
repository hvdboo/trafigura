select 
kud.ID SEQ,
rep.M_NB TRD,
rep.M_TP_GID GID,
rep.M_TP_PFOLIO PFLSRC,
rtrim(rep.M_INSTRUMENT) INS,
-- Dates
to_char(bk0.M_XEXPIRY,'YYYY-MM-DD') EXP,
to_char(bk0.M_XPRMPT,'YYYY-MM-DD')  PMP,
-- to_char(rep.M_TP_DTELST,'YYYY-MM-DD') LST,
-- (bk0.M_XPRMPT-rep.M_TP_DTELST) TEST,
round(rep.M_MP_CMCRVLS,4) PMPFWD,
-- Shifters
trim(bk0.M_XPSHIFT) PSH,
trim(bk0.M_XVSHIFT) VSH,
rep.M_TP_CP RGT,
rep.M_TP_DIR DIR,
rep.M_TP_NOM NOM,
rep.M_TP_LQTY2 QTY,
rep.M_TP_PRICE PRM,
-- to_char(rep.M_VAL_DAT1,'YYYY-MM-DD') DAT1,
-- round(rep.M_PL_NFMV1, 2) PL_MV1,
-- round(rep.M_PL_CSNF1, 2) PL_CS1,
to_char(rep.M_VAL_DAT2,'YYYY-MM-DD') DAT2,
-- PL_MV
round(rep.M_PL_NFMV2, 2) PL_MV_MX,
-- PL_CS
round(rep.M_PL_CSNF2, 2) PL_CS_MX,
round(kud.PRMAMT,2) PL_CS_KU,
(abs(rep.M_PL_CSNF2) - kud.PRMAMT) PL_CS_DIF,
-- PL_ACC
round(rep.M_PL_ACC_N2,2) PL_ACC_MX,
round(sim.PNL_ABS,2) PL_SIM_MX,
round(rep.M_PL_GE2, 2) PL_GE_MX,
round(kud.PNL,2) PL_KU,
round((rep.M_PL_ACC_N2 - kud.PNL),2) PL_DIFABS,
round(((rep.M_PL_ACC_N2-kud.PNL)/kud.PNL)*100,2) PL_DIFPCT,
-- Greeks
round(sim.DELTA,4) DELTA_MX,
round(kud.DELTA,4) DELTA_KU,
round((sim.DELTA - kud.DELTA),4) DELTA_DIF,
round(sim.GAMMA,6) GAMMA_MX,
round(kud.GAMMA,6) GAMMA_KU,
round((sim.GAMMA - kud.GAMMA),6) GAMMA_DIF,
round(sim.VEGA,4) VEGA_MX,
round(kud.VEGA,4) VEGA_KU,
round((sim.VEGA - kud.VEGA),4) VEGA_DIF,
round(sim.THETA,4) THETA_MX,
round(kud.THETA,4) THETA_KU,
round((sim.THETA - kud.THETA),4) THETA_DIF

from MUREX_DM_OWNER.CHECK_PL_REP rep
left join MUREX_MX_OWNER.RTBLOCK#RTBKSKL_DBF bks on rep.M_NB = bks.M_INT_NB
left join MUREX_MX_OWNER.RTBLOCK#RTBK0_DBF bk0 on bks.M_BK_INT_N = bk0.M_INT_NB
left join MUREX_DM_OWNER.KUDUTRD kud on rtrim(rep.M_TP_GID) = rtrim(kud.FLXID)
left join MUREX_DM_OWNER.CHECK_SV_SIM sim on (rep.M_NB = sim.TRD and rtrim(rep.M_TP_PFOLIO) = rtrim(sim.PFL)) 

where 1 = 1
and rep.M_TP_DIR = 'B'
and kud.QTY > 0

order by SEQ, INS, GID