select 
rtrim(tbl.M_LABEL) TBLLAB,
rtrim(tbl.M_DESC)  TBLDES,
rtrim(lay.M_LABEL) LAYLAB,
rtrim(lay.M_DESC)  LAYDES,
itm.M_LINE LINE,
max(case when itm.M_COLUMN = 0 then rtrim(itm.M_LABEL) else null end) COL1,
max(case when itm.M_COLUMN = 1 then rtrim(itm.M_LABEL) else null end) COL2,
max(case when itm.M_COLUMN = 2 then rtrim(itm.M_LABEL) else null end) COL3,
max(case when itm.M_COLUMN = 3 then rtrim(itm.M_LABEL) else null end) COL4,
max(case when itm.M_COLUMN = 4 then rtrim(itm.M_LABEL) else null end) COL5,
max(case when itm.M_COLUMN = 5 then rtrim(itm.M_LABEL) else null end) COL6

from TABLE#STRUCT#TAB_UTLI_DBF itm
left join TABLE#STRUCT#TAB_UTL_DBF lay on itm.M_REF = lay.M_REF
left join TABLE#STRUCT#TAB_UTH_DBF tbl on lay.M_HEADER = tbl.M_REF

where 1 =1 
and rtrim(tbl.M_LABEL) = 'UDFS_PTF'
and rtrim(lay.M_LABEL) = 'Portfolio' 

group by rtrim(tbl.M_LABEL), rtrim(tbl.M_DESC), rtrim(lay.M_LABEL), rtrim(lay.M_DESC), itm.M_LINE

order by TBLLAB, LAYLAB, LINE
