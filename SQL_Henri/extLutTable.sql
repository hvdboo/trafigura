
select 
rtrim(lut.M_HEADER) TBL, rtrim(lut.M_LABEL) LUT, rtrim(lut.M_DESCRIPT) LUT_DES,  
case lul.M_CATTRIB when 8 then 'Result' else 'Criteria' end ATTRIB,
rtrim(lul.M_CTITLE) TITLE, 
rtrim(luc.M_LABEL) COL, rtrim(luc.M_TITLE) COL_TITLE,
case luc.M_TYPE
when 0 then 'String'
when 1 then 'Date'
when 4 then 'Numeric'
when 6 then 'Bid Ask'
when 8 then 'Multiple' end TYP,
luc.M_LENGTH SIZ, luc.M_DECIMAL DECI, rtrim(M_BRWFRML) FRML
from RTG_RCOL_DBF lul
left join RTG_TYP_DBF lut on lul.M_TYPID = lut.M_ID
left join RTG_COL_DBF luc on lul.M_COLID = luc.M_ID
--where lut.M_HEADER in ('UDTH291','UDTH293')
order by LUT, lul.M_COLRANK