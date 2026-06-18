select 
to_char(futprc.M_DATE_RF,'YYYYMMDD') DATINS,
to_char(futprc.M__DATE_,'YYYYMMDD') DATSYS,
rtrim(futprc.M__ALIAS_) MDS,
rtrim(fut.M_LABEL) FUT,
omat.M_LABEL MAT,
to_char(omat.M_MATURITY,'YYYYMMDD') QOTLST,
futprc.M_STRIKE STK,
case futprc.M_CALL when 1 then 'Call' when 0 then 'Put' end RGT,
round(futprc.M_PRC_RF0,futqot.M_PRC_DEC) PRCBID,
round(futprc.M_PRC_RF1,futqot.M_PRC_DEC) PRCASK,
futprc.M_SELECTED SEL

from CMK_FUTP_DBF futprc
left join TRN_PC_DBF pc on  1 = 1
left join CM_FUT_DBF fut on futprc.M_FUTURE = fut.M_REFERENCE
left join CMC_QUOT_DBF futqot on fut.M_QUOT_FWD = futqot.M_REFERENCE
left join CM_FMAT1_DBF fmat on (futprc.M_MAT_CODE = fmat.M_REFERENCE and fut.M_LISTED in (1, 2, 16))
left join CM_OMAT1_DBF omat on (futprc.M_MAT_CODE = omat.M_REFERENCE and fut.M_LISTED in (32, 64))

where 1 = 1
and fut.M_LISTED in (32, 64)
and futprc.M__DATE_ = pc.M_DATE
and rtrim(futprc.M__ALIAS_) = 'LANA MDS'
-- and M_INSTR_GEN = 611

order by DATSYS, MDS, FUT, QOTLST, STK, RGT
