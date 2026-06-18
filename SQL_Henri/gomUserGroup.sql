select 
case
when mxg.M_TYPE = 0 then 'MX USER ADMIN'
when mxg.M_TYPE = 1 then 'MX LICENSE ADMIN'
when mxg.M_TYPE = 2 then 'MX RIGHT ADMIN'
when mxg.M_TYPE = 3 then 'MX MIDDLEWARE ADMIN'
when mxg.M_TYPE = 4 then 'MX INSTALL'
when mxg.M_TYPE = 5 then 'MX GROUP'
when mxg.M_TYPE = 6 then 'MLC GROUP'
when mxg.M_TYPE = 7 then 'MLC RIGHT ADMIN'
when mxg.M_TYPE = 8 then 'ACTUATE RIGHT ADMIN'
when mxg.M_TYPE = 9 then 'MX MIDDLEWARE AUDIT' end CATEGORY,
rtrim(mxg.M_LABEL) LABEL, 
rtrim(grp.M_DESC) DESCRIPTION,
case
when grp.M_BO_FO = 0 then 'Front-office'
when grp.M_BO_FO = 1 then 'P&L Control'
when grp.M_BO_FO = 2 then 'Processing' else '' end TYPE,
case
when grp.M_ACTIVITY = 'C'  then 'Configurator' else '' end SUBTYPE

from MX_GROUP_DBF mxg 
left join TRN_GRPD_DBF grp on mxg.M_REFERENCE = grp.M_EXT_REF

order by CATEGORY, TYPE, SUBTYPE, mxg.M_LABEL