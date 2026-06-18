select
rtrim(modu.MAIN_MODULE) MODU, rtrim(modu.MODULE) PACK,
rtrim(frm.FORMULA_LABEL) FRM, rtrim(frm.FORMULA_TYPE) TYP,
frm.XML XML
from XMLSPACE_DD_FORMULAE_TABLE frm
left join DD_MODULES modu on frm.MODULE_ID = modu.ID
-- where frm.REFERENCE_ID = 9809
order by FRM