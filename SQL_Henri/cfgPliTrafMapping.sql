select
pli.M_PLITYP  PLITYP,
pli.M_PLILAB  PLILAB,
pli.M_CRVICM0 CRVICM0,
pli.M_EAICOD  EAIPLI,
eai.EAIQUOTEID EAIEAI,
pli.M_EAILAB  EAILAB,
pli.M_MV_FWD  PLICRV,
eai.MVCURVE   EAICRV

from VIW_PLITRAF_DBF pli
left join IMPEAI eai on to_number(pli.M_EAICOD) = eai.EAIQUOTEID
left join KEYMAP_STC_DBF alteai on to_char(pli.M_INDUID0) = rtrim(altindeai.M_OBJ_DESC) and rtrim(altindeai.M_OBJ_CLASS) in ('MnXbT37735', 'MwOJI56899') and rtrim(substr(altindeai.M_OBJ_ASYS,1,3)) = 'EAI'
