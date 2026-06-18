select rtrim(arc.M_CONTRACT) CNT, 
rtrim(arc.M_DESC) ARCHIV, 
arc.M_QUOTATION   QUOT,
arc.M_FORM_FACT   FF

from FX_ARCCT_DBF arc

order by arc.M_CONTRACT, arc.M_DESC