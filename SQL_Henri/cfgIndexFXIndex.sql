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
rtrim(ind.M_FX_GROUP)||' '||rtrim(ind.M_CURR1)||'/'||rtrim(ind.M_CURR2)||' '||rtrim(M_COL_CODE) KEY,
ind.M_CURR1             CUR1, 
rtrim(cur1.M_FULL_NAME) CUR1_DES,
ind.M_CURR2             CUR2, 
rtrim(cur2.M_FULL_NAME) CUR2_DES,
rtrim(ind.M_FX_GROUP)   PUB, 
rtrim(ind.M_COL_CODE)   COL,
rtrim(arc.M_CONTRACT)   CNT, 
arc.M_QUOTATION         QUOT,
rtrim(alt.M_OBJ_ALT)    SRD,
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
left join KEYMAP_STC_DBF alt on (
rtrim(ind.M_FX_GROUP)||' '||rtrim(ind.M_CURR1)||'/'||rtrim(ind.M_CURR2)||' '||rtrim(M_COL_CODE) = rtrim(alt.M_OBJ_DESC)
and rtrim(arc.M_CONTRACT) = rtrim(alt.M_OBJ_ALBL) 
and rtrim(alt.M_OBJ_ASYS) = 'SRD' 
and rtrim(alt.M_OBJ_CLASS) = 'MdDui65528')

where ind.M_CATEGORY = 4
order by ind.M_IND_LAB