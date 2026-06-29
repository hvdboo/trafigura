drop view INDFXD_VIW;
create view INDFXD_VIW
(
M_CAT,
M_LAB,
M_DES,
M_CUR1,
M_CUR1_DES,
M_CUR2,
M_CUR2_DES,
M_PUB,
M_HSR,
M_CNT,
M_QUOT,
M_HIS,
M_INDUID
)

as

(
select 
case ind.M_CATEGORY
when 0 then 'Rate'
when 1 then 'Equity'
when 2 then 'Bond'
when 3 then 'Inflation'
when 4 then 'Forex'
when 8 then 'Commodity'
when 9 then 'Com FWD' else null end CAT,
rtrim(ind.M_IND_LAB)    LAB, 
rtrim(ind.M_IND_DESC)   DES,
ind.M_CURR1             CUR1, 
rtrim(cur1.M_FULL_NAME) CUR1_DES,
ind.M_CURR2             CUR2, 
rtrim(cur2.M_FULL_NAME) CUR2_DES,
rtrim(ind.M_FX_GROUP)   PUB, 
rtrim(ind.M_COL_CODE)   HSR,
rtrim(arc.M_CONTRACT)   CNT, 
arc.M_QUOTATION         QUOT,
ind.M_HISFILE           HIS,
--ind.M_INDEX INDNDX,
ind.M_REFERENCE INDUID

from RT_INDEX_DBF ind
left join FX_CURR_DBF cur1 on ind.M_CURR1 =  cur1.M_LABEL
left join FX_CURR_DBF cur2 on ind.M_CURR2 =  cur2.M_LABEL
left join FX_ARCCT_DBF arc on ( 
rtrim(ind.M_FX_GROUP) = rtrim(arc.M_DESC) and
ind.M_CURR1 = substr(arc.M_QUOTATION,1,3) and
ind.M_CURR2 = substr(arc.M_QUOTATION,5,3))

where ind.M_CATEGORY = 4

);

drop table VIW_INDFXD_DBF;
create table VIW_INDFXD_DBF as (select * from INDFXD_VIW);
