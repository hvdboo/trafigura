update TRN_PFLD_DBF pfl set M_COMMENT1 = (
case 
when (select rtrim(udf.M_STRATEGY_C) from TABLE#DATA#PORTFOLI_DBF udf where pfl.M_LABEL = udf.M_LABEL) = 'SB' then 'MX'
else substr(pfl.M_LABEL,1,2)
-- else rtrim(udf.M_STREAM_C) 
end || 
-- Strategy
case 
when (select rtrim(udf.M_STRATEGY_C) from TABLE#DATA#PORTFOLI_DBF udf where pfl.M_LABEL = udf.M_LABEL) = 'SB' then rtrim(pfl.M_ENTITY)
else (select rtrim(udf.M_STRATEGY_C) from TABLE#DATA#PORTFOLI_DBF udf where pfl.M_LABEL = udf.M_LABEL)
end||' '||
-- Owner, Asset
case 
when substr(pfl.M_LABEL,6,3) in 
(select rtrim(atr.M_CODE) from TABLE#LIST#ATTR_DBF atr where rtrim(atr.M_TYPE) = 'Owner' and substr(atr.M_DESC,1,1) <> '_') 
then substr(pfl.M_LABEL,6,3)
when substr(pfl.M_LABEL,6,3) in (select rtrim(rng.SRC) from RNGPFL_MAP rng) 
then (select rtrim(rng.TGT) from RNGPFL_MAP rng where substr(pfl.M_LABEL,6,3) = rtrim(rng.SRC))
else 'XXX'
end||' '||
-- Category
(select rtrim(udf.M_PTFCAT) from TABLE#DATA#PORTFOLI_DBF udf where pfl.M_LABEL = udf.M_LABEL)
||' '||
-- Legal entity
(select rtrim(len.M_DSP_LABEL) from TRN_CPDF_DBF len where pfl.M_PROC_AREA = len.M_ID)

)

where rtrim(pfl.M_COMMENT0) is null
