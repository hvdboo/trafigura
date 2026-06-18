select *
from STPDOC_ENTRY_TABLE stp
where 1 = 1
-- and stp.FC_ID in (100, 130)
-- and stp.SOURCE_EVENT_CLASS_ID = 'IMOS_Out'
-- and stp.CTP_LABEL = 'DFOT MSI TMPI'
and stp.XMLFLOW_STATUS = '21258'
-- and to_char(stp.JOB_DATE,'YYYYMMDD') = '20191028'

