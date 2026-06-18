select 
-- sh.M_SE_GROUP GRP, sh.M_SE_TYPE TYP, sh.M_SE_CATE CAT,
rtrim(sr.M_SE_MARKET) MKT, coalesce(rtrim(sr.M_SE_CUR),rtrim(sm1.M_SE_CUR)) CUR,
rtrim(sh.M_SE_D_LABEL) SEC, rtrim(sh.M_SE_F_NAME) NAME, rtrim(sh.M_SE_CODE) CODE, 
case bsk.M_SE_B_W
when 0 then 'User defined'
when 1 then 'Listed Capital'
when 2 then 'List of assets'
when 3 then 'Proxy hedge' else null end BSKTYP,
case bsk.M_SE_B_SF
when 0 then 'Index weighting'
when 1 then 'Constant weighting'
when 2 then 'Percentage weighting' else null end SPTFRM,
case bsk.M_SE_FX_RULE
when 0 then 'Std/Composite'
when 1 then 'Quanto' else null end MCRUL,
case bsk.M_SE_B_SW
when 0 then 'No'
when 1 then 'Yes' else null end ADJCOE,
bsk.M_SE_B_II ININDX, bsk.M_SE_B_IC INICAP, bsk.M_SE_B_K ADJFCT,
bc.M_SE_BSK_NUM ORD, rtrim(bcs.M_SE_D_LABEL) BCOMP
from ${FIN_schema}SE_ROOT_DBF sr
left join ${FIN_schema}SE_HEAD_DBF sh on sr.M_SE_LABEL = sh.M_SE_LABEL
left join ${FIN_schema}SE_MKT1_DBF sm1 on sr.M_SE_MARKET = sm1.M_SE_MARKET 
left join ${FIN_schema}SE_MKTOP_DBF smo on sh.M_SE_LABEL = smo.M_SE_LABEL
left join ${FIN_schema}SE_BK_DBF bsk on smo.M_SE_INUM = bsk.M_SE_INUM
left join ${FIN_schema}SE_BKC_DBF bc on bsk.M_SE_INUM = bc.M_SE_INUM 
left join ${FIN_schema}SE_HEAD_DBF bcs on bc.M_SE_BSK_COM = bcs.M_SE_LABEL
--left join TABLE#DATA#SECURITI_DBF udf on sh.M_SE_LABEL = udf.M_SE_LABEL
where sh.M_SE_GROUP = 'Basket' and sh.M_SE_TYPE = 'Std'
order by sr.M_SE_MARKET, sh.M_SE_D_LABEL
