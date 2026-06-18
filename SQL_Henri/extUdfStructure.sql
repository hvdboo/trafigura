select 
rtrim(tbl.M_LABEL) TBLLAB,
rtrim(tbl.M_DESC)  TBLDES, 
rtrim(lay.M_LABEL) LAYOUT,
rtrim(fld.M_LABEL) FLDLAB, 
rtrim(fld.M_DESCRIPTION) FLDDES,
case fld.M_TYPE
when 1 then 'String'
when 2 then 'Numeric'
when 3 then 'Date'
when 4 then 'String (variable)' else null end TYP,
fld.M_SIZE SIZ,
fld.M_DECIMAL PRC,
case fld.M_ETYPE
when 1 then 'Manual'
when 2 then 'List' end VALTYP,
rtrim(fld.M_ELABEL) VALLST, 
rtrim(fld.M_FILTER) VALFLT

from TABLE#STRUCT#TAB_UTF_DBF fld
left join TABLE#STRUCT#TAB_UTH_DBF tbl on fld.M_HEADER = tbl.M_REF
left join TABLE#STRUCT#TAB_UTL_DBF lay on tbl.M_REF = lay.M_HEADER

where 1 =1 
--and rtrim(tbl.M_LABEL) = 'UDFS_PTF'

order by rtrim(tbl.M_LABEL), rtrim(lay.M_LABEL), rtrim(fld.M_LABEL) 