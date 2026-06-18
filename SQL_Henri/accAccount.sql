select 
rtrim(ac1.M_LABEL) ACC_LAB, rtrim(ac1.M_DESC) ACC_DES, 
case ac1.M_CLASS
when 'BS' then 'Balance sheet'
when 'IS' then 'Income statement' 
when 'OS' then 'Off balance sheet' end ACC_CLASS,
case ac1.M_ACC_TYPE
when 'BS' then 'Balance sheet'
when 'NO' then 'None'
when 'OB' then 'Off balance sheet'
when 'PL' then 'P&L' end ACC_FMLY,
case M__INTID_
when 'MsMlP60056' then 'Static'
when 'MzFzS78952' then 'Dynamic' end ACC_TYP,
case M_CHK_MAN
when 'N' then 'Allow'
when 'Y' then 'Forbid' end MANUAL,
/*
rtrim(ac1.M_LABEL_GL) GL_COD, rtrim(ac1.M_LABEL_SUB) GL_SUBCOD,
rtrim(ac1.M_CATEGORY0) CAT1, rtrim(ac1.M_CATEGORY1) CAT2,
rtrim(ac1.M_MAPPING) MAPP,
*/
ac3.M_POS_CHAR1 DYN_POS1, ac3.M_POS_CHAR2 DYN_POS2,
case ac3.M_TYPE_STR
when 'C' then 'Calculation'
when 'F' then 'Field'
when 'V' then 'Value' end DYN_TYP,
case ac3.M_TYPE_STR
when 'C' then rtrim(ac3.M_CALC)
when 'F' then rtrim(ac3.M_CLASS)||'|'||rtrim(ac3.M_STRING)
when 'V' then rtrim(ac3.M_STRING) end DYN_VAL,
/*
rtrim(cal.M_DESC) CAL_DES, 
case cal.M_RETTYPE 
when 1 then 'String'
when 2 then 'Numeric' end CAL_RET,
rtrim(cal.M_EXPRESSION) CAL_FRM,
*/
ac1.M_REFERENCE ACC_REF
from TRN_ACA1_DBF ac1
left join TRN_ACA3_DBF ac3 on ac1.M_REFERENCE = ac3.M_DY_ACC_REF and ac1.M__INTID_ = 'MzFzS78952'
left join ACCCFG#FIL_ACCD_DBF cal on rtrim(ac3.M_CALC) = rtrim(cal.M_LABEL) and ac3.M_TYPE_STR = 'C'
where substr(ac1.M_LABEL,6,1)='.' or substr(ac1.M_LABEL,1,7)='Clearer'
order by ac1.M_LABEL, ac1.M_REFERENCE, ac3.M_REFERENCE