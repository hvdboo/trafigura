select 
case when typ.M_REFERENCE < 1000 then 'MX' else 'UDF' end SOURCE,
rtrim(typ.M_LABEL) LABEL, rtrim(typ.M_DESCRIPTION) DESCRIPTION, 
typ.M_REFERENCE ID

from PARTY_TYPE_DBF typ
order by SOURCE, LABEL