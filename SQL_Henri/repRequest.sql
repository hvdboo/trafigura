select 
req.M_REF REQ_REF, 
trim(req.M_LABEL) REQ_LAB, trim(req.M_DESC) REQ_DES,
req.M_REQUEST REQ_QRY

from ACT_REQXTR_DBF req
order by REQ_LAB