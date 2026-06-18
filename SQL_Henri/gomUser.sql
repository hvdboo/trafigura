select 
usr.M_REFERENCE,
rtrim(usr.M_LABEL) LABEL, 
rtrim(usr.M_FULL_NAME) NAME, 
rtrim(usr.M_CODE) CODE, 
rtrim(usr.M_DESC) DESCRIPTION,
usr.M_SUSPENDED SUSPEND

from MX_USER_DBF usr

--where usr.M_SUSPENDED<>1
order by usr.M_LABEL