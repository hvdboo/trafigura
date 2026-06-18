select
rtrim(str.M_DES)   SRDSTR,
case 
when rtrim(lut.M_DIVISION) = 'CED Oil' then 'Oil Trading'
when rtrim(lut.M_DIVISION) = 'Macro Trading'  then 'Refined Metals'
when rtrim(lut.M_DIVISION) = 'NF Derivatives' then 'CED Metals'
when rtrim(lut.M_DIVISION) = 'Strategic Equity - Energy' then 'Investments and Assets Oil'
when rtrim(lut.M_DIVISION) = 'Strategic Equity - Financ' then 'Investment and Assets: Group Non-Divisional'
when rtrim(lut.M_DIVISION) = 'Strategic Equity - Mining' then 'Investment and Assets: Non-Ferrous'
else rtrim(lut.M_DIVISION) end LUTSTR,
case
when rtrim(lut.M_DIVISION) = 'CED Oil' then 'CED Oil'
when rtrim(lut.M_DIVISION) = 'Macro Trading'  then 'Macro Trading'
when rtrim(lut.M_DIVISION) = 'NF Derivatives' then 'NF Derivatives'
else rtrim(lut.M_PTFTYPE) end LUTMDK,
rtrim(lut.M_MASTRDSK)  CAT,
--rtrim(M_PORTFOLIO) PFL,
rtrim(lut.M_BUS_LINE) LUTBZL,
rtrim(str.M_STL)      SRDBZL,
rtrim(lut.M_STREAM)   LUTDIV,
rtrim(str.M_SEQ)      SEQ

from UDTB251_DBF lut

left join TABLE#LIST#SRD_DBF str on rtrim(M_DIVISION) = rtrim(str.M_DES) and rtrim(str.M_OBJ) = 'STR'


order by SEQ, LUTSTR, LUTMDK, CAT
