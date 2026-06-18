select * from SRC_DESC_DBF where trim(M_TABLE) is not null 


select T2.M_LABEL As Portfolio , T1.M_PORTFOLIO as Reference
from CLASS_ID_DBF T1 inner join TRN_PFLD_DBF T2
on T1.M_PORTFOLIO = T2.M_REF
where T1.M_FIN_ID in 
(select M_CLASSID from CLASSIFICATION_KEYS_P_DBF where M_CLASKEYID in 
(select CLASSIFICATION_KEY_P from PS_POS_EX_E where TRADE_NUMBER = 13388992))
