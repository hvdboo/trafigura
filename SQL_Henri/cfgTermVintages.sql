select 
rtrim(vset.M_LABEL) VINSET,
rtrim(vin.M_LABEL) VINLAB,
rtrim(vin.M_DESC) VINDES,
to_char(per.M_START_DATE,'YYYY-MM-DD') DATFST,
to_char(per.M_END_DATE,'YYYY-MM-DD') DATLST

from CM_VINTAGE_PERIOD_DBF per 
left join CM_VINTAGE_DBF vin on per.M_VINTAGE_REF = vin.M_REFERENCE
left join CM_VINTAGESET_DBF vset on per.M_VINTAGE_SET_REF = vset.M_REFERENCE

order by VINSET, DATFST