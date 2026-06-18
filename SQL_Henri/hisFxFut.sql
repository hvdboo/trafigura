
select 
to_char(bdy.M_INS_DATE,'YYYY-MM-DD') DATINS,
to_char(bdy.M_DATE,'YYYY-MM-DD') DATVAL,
rtrim(cnt.M_LABEL) CNT,
rtrim(mat.M_LABEL) MATLAB,
to_char(mat.M_MAT,'YYYY-MM-DD') MATDAT, 
round(bdy.M_OPEN,4) H_OPEN,
round(bdy.M_CLOSE,4) H_CLOSE,
round(bdy.M_FIXING,4) H_FIXING

from BS000072_HBS bdy
left join HS000072_H1S hdr on bdy.M_KEYID = hdr.M_KEYID
left join FX_CNT_DBF cnt on 1 = 1 and cnt.M_HISFN = 'HS000072'
left join OM_MAT_DBF mat on to_number(rtrim(substr(hdr.M_KEY0,3,9))) = mat.M_CODE

where bdy.M_INS_DATE = trim(?)

order by DATVAL, MATDAT 

