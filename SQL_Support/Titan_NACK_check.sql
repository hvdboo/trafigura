select  distinct
case
when  a.XMLFLOW_STATUS = 21407 then
nvl(
(select max('Solved: MX->HM trade import ACK for: '||R.STPDOC_DATA_TYPE1||':'|| R.STPDOC_DATA_TYPE2 ||' Received at: '||SUBSTR(to_char(timestamp '1970-01-01 02:00:00' + numtodsinterval((R.TS_TIME_LONG)/1000/60, 'MINUTE'),'YYYY-MM-DD hh24:mi:ss.FF'),1,23)) 
from MUREX_MX_OWNER.STPDOC_ENTRY_TABLE R where /*R.STATUS_TAKEN = 'N' and*/ R.STPDOC_REF = 'TITANHM' and  R.XMLFLOW_STATUS = 20577 
and R.STPDOC_DATA_TYPE1 = a.STPDOC_DATA_TYPE1 
and R.STPDOC_DATA_TYPE2 >= a.STPDOC_DATA_TYPE2
and r.STPDOC_ACTION = 'ACK' /* and R.TS_TIME_LONG > a.TS_TIME_LONG */ ), 'NOT: MX->HM ACK *NOT* Received (Trade not imported to HM)' ) 
when a.XMLFLOW_STATUS = 19962 then
nvl(
(select max('Solved: HM->MX trade imported to MX, ACK for: '||R.STPDOC_DATA_TYPE1||':'|| R.STPDOC_DATA_TYPE2 ||' Sent at: '||SUBSTR(to_char(timestamp '1970-01-01 02:00:00' + numtodsinterval((R.TS_TIME_LONG)/1000/60, 'MINUTE'),'YYYY-MM-DD hh24:mi:ss.FF'),1,23)) 
from MUREX_MX_OWNER.STPDOC_ENTRY_TABLE R where /*R.STATUS_TAKEN = 'N' and*/ R.STPDOC_REF = 'TITANHM' and  R.XMLFLOW_STATUS = 19963 
and R.STPDOC_DATA_TYPE1 = a.STPDOC_DATA_TYPE1 
and (R.STPDOC_DATA_TYPE2 >= a.STPDOC_DATA_TYPE2 or ( R.STPDOC_DATA_TYPE2 = ' ' and R.TS_TIME_LONG > a.TS_TIME_LONG ) )
and r.STPDOC_ACTION = 'ACK' /* and R.TS_TIME_LONG > a.TS_TIME_LONG */ ), 'NOT: HM->MX trade import ACK *NOT* Sent (Trade not imported to MX)' ) 
end Status_Solved_or_Not,
a.STPDOC_DATA_TYPE1 HR_ID, 
a.STPDOC_DATA_TYPE2 VR, 
a.STPDOC_ACTION ACTION,
    a.JOB_DESCRIPTION,
SUBSTR(to_char(timestamp '1970-01-01 02:00:00' + numtodsinterval((a.TS_TIME_LONG)/1000/60, 'MINUTE'),'YYYY-MM-DD hh24:mi:ss.FF'),1,23)||'.' time_stamp ,
a.STATUS_TAKEN P
, a.XMLFLOW_STATUS
from MUREX_MX_OWNER.STPDOC_ENTRY_TABLE a 
left join ( select distinct tsk.FILTER_CODE, task_header.REFERENCE_ID, '['||task_header.TYPE_CODE||']'||task_header.CODE||'->'||tsk.CODE||'['||trim(tsk.FILTER_CODE)||']' Task_Name from murex_mx_owner.MXMLEX_TASK_TABLEBODY  tsk join murex_mx_owner.MXMLEX_TASK_TABLE  task_header on task_header.REFERENCE_ID=tsk.REFERENCE_ID) task on (a.XMLFLOW_STATUS=task.FILTER_CODE)
where 1=1
and ( a.XMLFLOW_STATUS = 21407  /* 21407 HM->MX NACK OSP */
   OR a.XMLFLOW_STATUS = 19962  /* 21407 MX NACK -> TO HM  */  
   )
and a.JOB_DATE >  sysdate-20
order by time_stamp desc