select  
-- omat.M_REFERENCE,
rtrim(omat.M_LABEL) LABEL, 
rtrim(omat.M_DESC) DESCRIPTION, 
case omat.M_TYPE
when 0 then 'Standard'
when 1 then 'Series'
when 2 then 'Composite' else '' end TYP,
rtrim(fmat.M_LABEL) UNDERLYING, 
omat.M_OPT_COUNT MAT,
rtrim(omat.M_OQT_RULE0) QOTFST,
rtrim(omat.M_OQT_RULE1) QOTLST,
case omat.M_LAB_FORMULA when 0 then 'Standard' else 'Formula' end LABFRM,
case omat.M_DSP_ALIAS when 1 then 'Yes' else 'No' end ALIAS,

case omat.M_AUTO_ROLL when 1 then 'Yes' else 'No' end ROLL_AUTO,
to_char(omat.M_CUTOFF,'YYYY-MM-DD') ROLL_CUTOFF,
case omat.M_CUTOFF_AUTOSET when 1 then 'Yes' else 'No' end CUTOFF_QE,
case cat.M_CATEGORY
when 1 then 'Regular'
when 2 then 'Serial'
when 3 then 'Weekly'
when 4 then 'Short term' else null end CAT,
cat.M_NB_MAT CATMAT,
case cat.M_QTSTARTFRM
when 0 then 'From driving date'
when 1 then 'From underlying quotation start'
when 2 then 'From underlying quotation end' 
when 3 then 'From underlying delivery start'
when 4 then 'From underlying delivery end' 
when 5 then 'From underlying notification start'
when 6 then 'From underlying notification end' else null end CATFSTFRM,
rtrim(cat.M_QTSTARTSHF) CATFSTSHF,
case cat.M_QTENDFRM 
when 0 then 'From driving date'
when 1 then 'From underlying quotation start'
when 2 then 'From underlying quotation end' 
when 3 then 'From underlying delivery start'
when 4 then 'From underlying delivery end' 
when 5 then 'From underlying notification start'
when 6 then 'From underlying notification end' else null end CATLSTFRM,
rtrim(cat.M_QTENDSHF) CATLSTSHF

from CM_OMAT_DBF omat 
left join CM_FMAT_DBF fmat on omat.M_FMAT_ID = fmat.M_REFERENCE
left join CM_OM_CATCFG_DBF cat on omat.M_REFERENCE = cat.M_OMAT_ID 

order by omat.M_LABEL, CAT