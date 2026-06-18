select 
sh.M_SE_GROUP GRP, 
sh.M_SE_TYPE TYP, 
sh.M_SE_CATE CAT,
rtrim(sr.M_SE_MARKET) MKT,
rtrim(udfmkt.M_MIC) MIC,
rtrim(sh.M_SE_D_LABEL) SEC, 
rtrim(sh.M_SE_F_NAME) NAME, 
rtrim(sh.M_SE_RTF0) RIC,
coalesce(rtrim(sr.M_SE_CUR),rtrim(sm1.M_SE_CUR)) CUR,
rtrim(sec.M_SE_D_LABEL) UNDERLYING, rtrim(fut.M_FU_MARKET) UNDMKT,
sr.M_SE_SEC_LS0 LOT,
rtrim(mat.M_LABEL) MATSET,
rtrim(qot.M_SE_TCQ_L) QUOT,  
case fut.M_FU_CASH_DL 
when 0 then 'Cash'
when 1 then 'Dlv' else null end STL,
case fut.M_FU_MARG 
when 0 then 'N'
when 1 then 'Y' else null end MRG,
case fut.M_FU_MARG_FQ
when 0 then 'Daily'
when 1 then 'Matset' 
when 2 then 'Monthly' else null end MRG_FRQ,
case fut.M_FU_MARG_F
when 0 then 'Future CUR'
when 1 then 'Price/(1 + X DT)'
when 2 then 'Notional bond'
when 3 then 'DI rate'
when 4 then 'DDI rate'
when 5 then 'Other CUR'
when 6 then 'DAP rate'
when 7 then 'Underlying bond' else null end MRG_BASIS,
rtrim(fut.M_FU_CLEAR) CLEARING,
rtrim(sh.M_SE_LABEL),
fut.M_FU_INUM NUM

from SE_ROOT_DBF sr
left join SE_HEAD_DBF sh on sr.M_SE_LABEL = sh.M_SE_LABEL
left join SE_MKT1_DBF sm1 on sr.M_SE_MARKET = sm1.M_SE_MARKET 
left join SE_TRDQ_DBF qot on sr.M_SE_TCQ_L = qot.M_SE_TCQ_L
left join MATSET_DBF mat on sr.M_SE_MAT_SET = mat.M_LABEL
left join SE_MKTOP_DBF mkop on sr.M_SE_LABEL = mkop.M_SE_LABEL
left join FU_FUT_DBF fut on mkop.M_SE_INUM = fut.M_FU_INUM
left join RT_INSGN_DBF bgen on fut.M_FU_BD_GEN = bgen.M_GEN_NUM
left join RT_INSGN_DBF fgen on fut.M_FU_GEN = fgen.M_GEN_NUM
left join RT_INDEX_DBF ind on fut.M_FU_UNDERL = ind.M_INDEX
left join SE_HEAD_DBF sec on fut.M_FU_UNDERL = sec.M_SE_LABEL
left join TABLE#DATA#MARKET_DBF udfmkt on rtrim(sr.M_SE_MARKET) = rtrim(udfmkt.M_SE_MARKET)
-- left join TABLE#DATA#SECURITI_DBF udfsec on sh.M_SE_LABEL = udfsec.M_SE_LABEL

where sh.M_SE_GROUP = 'Future' and sh.M_SE_TYPE = 'Plain' and sh.M_SE_CATE = 'Equity'
order by sr.M_SE_MARKET, sh.M_SE_D_LABEL
