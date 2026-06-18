(
select 
'01'              SEQ,
'Business line'   TYP, 
null              COD,
rtrim(M_BUS_LINE) LAB

from TABLE#LIST#BUS_LINE_DBF

union

select
case rtrim(udfatt.M_TYPE)
when 'Division'   then '02.01'
when 'Stream'     then '02.02'
when 'MasterDesk' then '02.03' 
when 'Type'       then '03'
when 'Types'      then '03'
when 'Owner'      then '04'
else null end SEQ,
rtrim(udfatt.M_TYPE)  TYP,
rtrim(udfatt.M_CODE)  COD,
rtrim(udfatt.M_VALUE) LAB

from TABLE#LIST#ATTR_DBF udfatt
where rtrim(udfatt.M_TYPE) in
(
'Division',
'Stream',
'MasterDesk',
'Type',
'Types',
'Owner'
)

)
order by SEQ, LAB

