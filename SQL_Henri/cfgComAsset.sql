select 
rtrim(atp.M_LABEL) TYPLAB,
rtrim(atp.M_DESC)  TYPDES,
rtrim(ass.M_LABEL) ASSLAB,
rtrim(ass.M_DESC)  ASSDES

from CM_ASSET_DBF ass
left join CM_ATYPE_DBF atp on ass.M_TYPE = atp.M_REFERENCE

order by TYPLAB, ASSLAB