select 
rtrim(rul.LABEL) LAB, rtrim(rul.DESCRIPTION) DES,
rtrim(cat.LABEL) CAT, rtrim(typ.LABEL) TYP, 
rtrim(rul.FORMULA_LABEL) FRM
from WF_DECISION_RULE rul
left join WF_DECISION_CAT cat on rul.CATEGORY_ID = cat.ID
left join WF_DECISION_TYPE typ on rul.TYPE_ID = typ.ID
order by LAB
