select
'Closing entity' UNIT, rtrim(cle.M_LABEL) LAB, rtrim(cle.M_DESC) DES, 
substr(cle.M_ACC_DATE,1,10) ACCDAT, 1 ORD
from TRN_ENTD_DBF cle

union

select
'Processing' UNIT, rtrim(pc.M_LABEL) LAB, rtrim(pc.M_DESC) DES, 
substr(pc.M_DATE,1,10) DAT, 2 ORD
from TRN_PC_DBF pc

union

select
'PL Control' UNIT, rtrim(plc.M_LABEL) LAB, rtrim(plc.M_DESC) DES, 
substr(plc.M_DATE,1,10) DAT, 3 ORD
from TRN_PLCC_DBF plc

union

select
'Desk' UNIT, rtrim(dsk.M_LABEL) LAB, rtrim(dsk.M_DESC) DES, 
substr(dsk.M_DATE,1,10) DAT, 4 ORD
from TRN_DSKD_DBF dsk

order by ORD