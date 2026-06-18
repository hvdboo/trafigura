select 
rtrim(mdlset.M_LABEL) ASGSET,
case asghdr.M__LINK_
when 2 then 'Static'
when 3 then ''
when 35 then 'Historized' else null end FRQ,
to_char(asghdr.M__DATE_,'YYYY-MM-DD') DAT,
rtrim(asgbdy.M_INST)   PAYOFF,
rtrim(ass.M_LABEL)  ASSET,
rtrim(asgbdy.M_MDL)    MODEL,
rtrim(gmpgrp.M_LABEL)  CONFIG

from COMMDL_RTGH_DBF asghdr
left join TRN_PC_DBF pc on 1 = 1
left join COM_MDL_GSET_DBF mdlset on rtrim(asghdr.M_LABEL) = rtrim(mdlset.M_LABEL)
left join COMMDL_RTGB_DBF asgbdy on asghdr.M__INDEX_ = asgbdy.M__INDEX_
left join CM_ASSET_DBF ass on asgbdy.M_ASSET = ass.M_REFERENCE
left join GMP_GRDF_DBF gmpgrp on rtrim(asgbdy.M_CONFIG) = rtrim(gmpgrp.M_LABEL)

where 1 = 1
-- and asghdr.M__INDEX_ = 19655
and rtrim(asghdr.M_LABEL) = 'COM_MDL_ASG_1'
and (to_char(asghdr.M__DATE_,'YYYY-MM-DD') is null or to_char(asghdr.M__DATE_,'YYYY-MM-DD') = to_char(pc.M_DATE,'YYYY-MM-DD'))

order by PAYOFF, MODEL