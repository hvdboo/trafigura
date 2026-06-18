select 
-- frm1.ID, qotf.ID FRMID, 
qotf.LongName FRM, 
frm1.Coefficient COEF1, coalesce(elt1.Longname,'') ELT1, frm1.Operator,
frm2.Coefficient COEF2, coalesce(elt2.Longname,'') ELT2, frm2.Operator,
frm3.Coefficient COEF3, coalesce(elt3.Longname,'') ELT3, frm3.Operator,
frm4.Coefficient COEF4, coalesce(elt4.Longname,'') ELT4, frm4.Operator,
frm5.Coefficient COEF5, coalesce(elt5.Longname,'') ELT5, frm5.Operator,
frm6.Coefficient COEF6, coalesce(elt6.Longname,'') ELT6, frm6.Operator,
frm7.Coefficient COEF7, coalesce(elt7.Longname,'') ELT7, frm7.Operator
from tblFormulae frm1
left join tblQuotes qotf on frm1.ID = qotf.FormulaID
left join tblQuotes elt1 on frm1.QuoteID = elt1.ID
left join tblFormulae frm2 on frm1.NextID = frm2.ID
left join tblQuotes elt2 on frm2.QuoteID = elt2.ID
left join tblFormulae frm3 on frm2.NextID = frm3.ID
left join tblQuotes elt3 on frm3.QuoteID = elt3.ID
left join tblFormulae frm4 on frm3.NextID = frm4.ID
left join tblQuotes elt4 on frm4.QuoteID = elt4.ID
left join tblFormulae frm5 on frm4.NextID = frm5.ID
left join tblQuotes elt5 on frm5.QuoteID = elt5.ID
left join tblFormulae frm6 on frm5.NextID = frm6.ID
left join tblQuotes elt6 on frm6.QuoteID = elt6.ID
left join tblFormulae frm7 on frm6.NextID = frm7.ID
left join tblQuotes elt7 on frm7.QuoteID = elt7.ID
where coalesce(qotf.FormulaID,10000) < 10000
order by FRM
