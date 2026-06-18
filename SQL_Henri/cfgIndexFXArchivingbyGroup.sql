select rtrim(arc.M_DESC) ARCHIV, 
rtrim(arc.M_CONTRACT) CNT, 
arc.M_QUOTATION       QUOT, 
arc.M_FORM_FACT FF

from FX_ARCCT_DBF arc

order by arc.M_DESC, arc.M_CONTRACT