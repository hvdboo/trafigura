select 
case att.M_TYPE
when 'Division'    then 1
when 'Stream'      then 2
when 'MasterDesk'  then 3
when 'Owner'       then 4
when 'Category'    then 5
when 'Market type' then 6
when 'Type'        then 7 else null end ORD,
att.M_TYPE TYP,
att.M_CODE CODE,
rtrim(att.M_VALUE) VAL

from TABLE#LIST#ATTR_DBF att

where att.M_TYPE in
(
'Division',
'Stream',
'MasterDesk',
'Owner',
'Category',
'Market type',
'Type'
)

order by ORD, VAL
