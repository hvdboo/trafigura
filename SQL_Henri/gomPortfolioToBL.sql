select distinct
rtrim(pfl.M_LABEL)    PFL_LAB, 
rtrim(pfl.M_DESC)     PFL_DES,
rtrim(udf.M_DIVISION) DIVISION,
rtrim(udf.M_MASTRDSK) MASTER, 
rtrim(udf.M_STREAM)   STREAM, 
rtrim(udf.M_PTFTYPE)  CATEGORY,
rtrim(lut.M_BUS_LINE) BL

from TRN_PFLD_DBF pfl
left join TABLE#DATA#PORTFOLI_DBF udf on rtrim(pfl.M_LABEL) = rtrim(udf.M_LABEL)
left join UDTB251_DBF lut on (
    rtrim(udf.M_STREAM) = rtrim(lut.M_STREAM)  
and rtrim(udf.M_PTFTYPE) = rtrim(lut.M_PTFTYPE) 
and rtrim(lut.M_DIVISION) is null 
and rtrim(lut.M_MASTRDSK) is null
) 

where 
rtrim(udf.M_DIVISION) is not null 
and substr(pfl.M_LABEL,1,5) <> 'ORDER'
-- and rtrim(udf.M_STRATEGY) = 'Selldown'
order by PFL_LAB
