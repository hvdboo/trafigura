select
rtrim(viwhdr.M_SCR_LIB) LIB,
rtrim(viwhdr.M_SCREEN)  OBJ,
rtrim(viwhdr.M_LABEL)   VIWLAB,
rtrim(viwhdr.M_GROUP)   GRP,
case
when grp.M_BO_FO = 0 then 'FO'
when grp.M_BO_FO = 1 then 'MO'
when grp.M_BO_FO = 2 and grp.M_ACTIVITY = 'E' then 'BO'
when grp.M_BO_FO = 2 and grp.M_ACTIVITY = 'C' then 'CFG' else null end GRPTYP,
rtrim(viwhdr.M_USER_NAME) USR,
case viwhdr.M_RGT_GROUP
when 0 then '___'
when 1 then 'A__'
when 2 then '_D_'
when 3 then 'AD_'
when 4 then '__U'
when 5 then 'A_U'
when 6 then '_DU'
when 7 then 'ADU' else null end RGTGRP,
case viwhdr.M_RGT_EVBDY
when 0 then '___'
when 1 then 'A__'
when 2 then '_D_'
when 3 then 'AD_'
when 4 then '__U'
when 5 then 'A_U'
when 6 then '_DU'
when 7 then 'ADU' else null end RGTALL,
rtrim(viwbdy.M_FLD_LABEL) FLDLAB,
viwbdy.M_WIDTH     FLDSIZ,
viwbdy.M_NB_OF_DEC FLDDEC,
viwbdy.M_AMERICAN  FLDAME,
case viwbdy.M_ALIGNMENT
when 0 then 'Left'
when 1 then 'Right'
when 2 then 'Center' else null end FLDALG

from SFVVIEWS_DBF viwbdy
left join SFVVIEWM_DBF viwhdr on viwbdy.M_ID = viwhdr.M_ID
left join TRN_GRPD_DBF grp on rtrim(viwhdr.M_GROUP) = rtrim(grp.M_LABEL)

where rtrim(viwhdr.M_SCREEN) in ('TRN_HDR.XDB')

order by viwhdr.M_SCR_LIB, viwhdr.M_SCREEN, viwhdr.M_LABEL, viwbdy.M_INDEX