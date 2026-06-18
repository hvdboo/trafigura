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
when mxg.M_TYPE = 9 then 'MX MIDDLEWARE AUDIT' end GRP_CAT,
rtrim(mxg.M_LABEL) GRP_LAB, rtrim(grp.M_DESC) GRP_DES,
case
when grp.M_BO_FO = 0 then 'Front-office'
when grp.M_BO_FO = 1 then 'P&L Control'
when grp.M_BO_FO = 2 then 'Processing' else '' end GRP_TYP,
-- case when grp.M_ACTIVITY = 'C'  then 'Configurator' else '' end GRP_SUBT,
null X,
rtrim(usr.M_LABEL) USR_LAB, 
rtrim(coalesce(usr.M_DESC,' ')) USR_NAME, rtrim(usr.M_CODE) USR_CODE

from MX_USER_GROUP_DBF ug
left join MX_GROUP_DBF mxg on ug.M_GROUP_ID = mxg.M_REFERENCE
left join MX_USER_DBF  usr on ug.M_USER_ID  = usr.M_REFERENCE
left join TRN_GRPD_DBF grp on mxg.M_REFERENCE = grp.M_EXT_REF

order by GRP_CAT, GRP_LAB, USR_LAB