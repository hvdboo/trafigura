select 
xo.M_CFG_REF VIEW_ID, 
rtrim(xo.M_CFG_LBL) VIEW_LABEL, 
rtrim(a.M_OWNER) VIEW_OWNER,
DUPL_COUNT.CNT VIEWS_WITH_THIS_LABEL
--, b.M_USER --, b.M_DESK, b.M_GROUP, b.M_RIGHTS

from VWR_CFGS_DBF xo
left join VWR_VISH_DBF a on a.M_HDR_REF = xo.M_VIS_REF
left join 
(
select upper(rtrim(b.M_CFG_LBL)) LBL, count(*) as CNT
from VWR_CFGS_DBF b 
where b.M_CFG_SNS = 'Simulation'
group by upper(rtrim(b.M_CFG_LBL))
) DUPL_COUNT 

on COALESCE(DUPL_COUNT.LBL, 'NULL_LABEL_VALUE') = UPPER(COALESCE(RTRIM(xo.M_CFG_LBL), 'NULL_LABEL_VALUE'))
where 
xo.M_CFG_SNS = 'Simulation' --only simulation views