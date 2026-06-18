select
rtrim(luc.M_LABEL) LAB,
rtrim(luc.M_TITLE) TITL,
case luc.M_TYPE
when 0 then 'String'
when 1 then 'Date'
when 4 then 'Numeric' 
when 6 then 'Bid Ask'
when 8 then 'Multiple' else null end TYP,
luc.M_LENGTH SIZ, luc.M_DECIMAL DECI,
rtrim(luc.M_CHOICE) CHOIC, rtrim(luc.M_BRWFRML) BRWFRM,
frm.FORMULA_TYPE FRM_TYP, frm.FORMULA_CONTEXT FRM_CTX, frm.XML
--rtrim(luc.M_TYPCLASS) CLASS, luc.M_ID
from RTG_COL_DBF luc
left join XMLSPACE_DD_FORMULAE_TABLE frm on rtrim(luc.M_BRWFRML) = rtrim(frm.FORMULA_LABEL)
where luc.M_ID in (137,170)
order by luc.M_LABEL