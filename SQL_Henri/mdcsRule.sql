select 
case rulh.M_IMPEXP
when 0 then 'Subsciption'
when 1 then 'Import-Export' else null end CAT,
rtrim(rulh.M_LABEL) RUL_LAB, rtrim(rulh.M_DESC) RUL_DES,
rulb.M_TYPE,
case rulb.M_TYPE 
when  0 then 'fxsp:spot'
when  2 then 'fxvl:volatility'
when  6 then 'fxsm:smile'
when  7 then 'rtsh:sheet'
when 10 then 'fxsw:swap'
when 17 then 'cdsh:sheet'
when 19 then 'scpr:price'
when 26 then 'cmfp:futurePrice'
when 27 then 'cmip:indexPrice'
when 28 then 'cmop:optionPrice'
when 34 then 'cmcu:curve'
when 50 then 'cmvolcu:volcurve'
when 51 then 'cdbsk:sheet'
when 55 then 'cmsmile:smile'
else null end TYP,
rulb.M_FREQUENCY FRQS, 
case M_RETRIEVE
when 0 then 'Default'
when 1 then 'Live feed'
when 2 then 'On demand' else null end RETRIEVE,
case rulb.M_DFLT_PAGE
when 3 then 'Realtime'
when 7 then 'Publish'
when 10 then 'Snapshot' else null end PAGE,
rtrim(actf.M_LABEL) ACTFEEDER,
case M_FAMILY
when 0 then 'Off'
when 1 then 'On' else null end FMLY,
case M_P_AUDIT
when 0 then 'Off'
when 1 then 'On' else null end PUBAUD,
--rtrim(valh.M_LABEL) VALSET,
case valb.M_VALUE_ID
when 0 then 'mp:bid'
when 1 then 'mp:ask'
when 2 then 'mp:formFactor'
when 3 then 'mp:quotation'
when 4 then 'mp:mid'
when 5 then 'mp:low'
when 6 then 'mp:high' else null end VAL
from MD_RTSRB_DBF rulb
left join MD_RTSRH_DBF rulh on rulb.M_REFERENCE = rulh.M_REFERENCE
left join MD_ACTIVITY_FEEDER_DBF actf on rulb.M_ACTFEEDER = actf.M_REFERENCE
left join MD_VALUES_DBF valh on rulb.M_V_FILTER = valh.M_REFERENCE
left join MD_VALUE_DBF valb on valh.M_REFERENCE = valb.M_VALUES_REF and valb.M_SELECTED = 1
order by CAT, RUL_LAB,TYP 