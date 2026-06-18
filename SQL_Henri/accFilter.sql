select
rtrim(tre.M_TRE_NAME) REF,
rtrim(hdr.M_LABEL) FLT_LAB, 
rtrim(hdr.M_DESC) FLT_DES,
case hdr.M_TEMPLATE
when 0 then 'Simple'
when 1 then 'OR Combi'
when 2 then 'AND Combi'
when 3 then 'Complex' else null end FLT_TYP,
case when tre.M_HEIGHT = 0 then rtrim(tre.M_LABEL) else null end FLT_NOD0,
case when tre.M_HEIGHT = 1 then rtrim(tre.M_LABEL) else null end FLT_NOD1,
case when tre.M_HEIGHT = 2 then rtrim(tre.M_LABEL) else null end FLT_NOD2,
case bdy.M_FIELD_TYP
when 1 then 'Field'
when 2 then 'Calc' else null end EXP_LTYP,
rtrim(bdy.M_FIELD) EXP_LVAL,
case bdy.M_OPERATOR
when  0 then '='
when  1 then '!='
when  2 then '=*'
when  3 then '*='
when  4 then 'contain'
when  5 then '!contain'
when  6 then '<'
when  7 then '<='
when  8 then '>'
when  9 then '>='
when 10 then 'in'
when 11 then '!in' else null end EXP_OPR,
case bdy.M_VALUE_TYP0
when 0 then 'Const'
when 1 then 'Field'
when 2 then 'Calc' else null end EXP_RTYP0,
rtrim(bdy.M_VALUE0) EXP_RVAL0,
case bdy.M_VALUE_TYP1
when 0 then 'Const'
when 1 then 'Field'
when 2 then 'Calc' else null end EXP_RTYP1,
rtrim(bdy.M_VALUE1) EXP_RVAL1
from ACCCFG#FIL_ACCT_DBF tre
left join ACCCFG#FIL_ACCH_DBF hdr on tre.M_TRE_NAME = hdr.M_REF
left join ACCCFG#FIL_ACCB_DBF bdy on tre.M_REF = bdy.M_NODE
-- where tre.M_TRE_NAME = '106'
order by hdr.M_LABEL, tre.M_NODE_ID