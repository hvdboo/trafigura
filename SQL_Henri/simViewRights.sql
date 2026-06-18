select 
rtrim(viw.M_CFG_LBL) VIW, 
rgh.M_TYPE,
rtrim(rgh.M_OWNER) OWNR, 
rtrim(rgb.M_USER) USR, rtrim(rgb.M_DESK) DSK, rtrim(rgb.M_GROUP) GRP, 
case rgb.M_RIGHTS
when  0 then ''
when  2 then 'Read'
when  4 then 'Modify'
when  6 then 'Read,Modify'
when 10 then 'Read,Delete'
when 14 then 'Read,Modify,Delete'
when 30 then '' else null end RGT,
rgb.M_RIGHTS RGTN

from VWR_CFGS_DBF viw
left join VWR_VISH_DBF rgh on viw.M_VIS_REF = rgh.M_HDR_REF 
left join VWR_VIS_DBF rgb on rgh.M_HDR_REF = rgb.M_HDR_REF

where viw.M_CFG_LBL <> ' '
order by viw.M_CFG_LBL, rgb.M_DESK, rgb.M_GROUP