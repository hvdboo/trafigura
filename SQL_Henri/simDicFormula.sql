select
vsh.M_REF, vsh.M_TYPE TYPN,
case vsh.M_TYPE
when  1 then 'View'
when  3 then 'Layout'
when  5 then 'Category tree'
when  7 then 'Filter'
when  8 then 'Default by group'
when  9 then 'Datadct loader'
when 10 then 'Item formula'
when 11 then 'View formatter'
when 12 then 'Undefined' else to_char(vsh.M_TYPE) end TYPL,
rtrim(dic.M_OBJ_DESC) OBJ,
rtrim(vsh.M_OWNER) OWNER, 
rtrim(vis.M_USER) USR,
rtrim(vis.M_DESK) DSK,
rtrim(vis.M_GROUP) GRP,
rtrim(ctxi.M_CTXTI_LBL) CTX,
ctxl.M_CTXTL_REF, ctxi.M_CTXTI_REF
from VWR_VISH_DBF vsh
left join VWR_VIS_DBF vis on vsh.M_HDR_REF = vis.M_HDR_REF
left join VWR_CTXTL_DBF ctxl on vsh.M_CTXTL_REF = ctxl.M_CTXTL_REF
left join VWR_CTXTI_DBF ctxi on ctxl.M_CTXTL_REF = ctxi.M_CTXTL_REF
left join VWR_DCT_DBF dic on (vis.M_HDR_REF = dic.M_OBJ_REF and dic.M_OBJ_ORD=1)
-- where vsh.M_HDR_REF = 13050
-- where vsh.M_TYPE = 7