select *
from
(
select
M_LAB      LABCUR,
M_CMT1     LABNEW,
M_DES      DES,
M_DIVISION DIV,
M_STREAM   STR,
M_MASTER   MDK,
M_TYPLAB   TYP,
M_CATEGORY CAT,
M_OWNER    OWNR,
M_CMT0     CMT
 
from VIW_PFL_DBF
where M_STR in ('OC','CH','NG','PW','FO','IO','OT','OD','SY')
 
order by SUBSTR(M_CMT1,1,2),rtrim(LABNEW)
)

where substr(LABNEW,3,2) = 'FX' or substr(LABNEW,6,2) = 'FX'