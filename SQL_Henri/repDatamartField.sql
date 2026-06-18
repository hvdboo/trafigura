select 
dmt.M_LABEL TBL, rtrim(dmt.M_DESC) TDES,
dmf.M_LABEL FLD, rtrim(dmf.M_DESC) FDES,
case dmf.M_TYPE
when 65 then 'American'
when 67 then 'Character'
when 68 then 'Date'
when 70 then 'Float'
when 71 then 'Long Integer'
when 73 then 'Integer'
when 78 then 'Numeric'
when 87 then 'Wide character' end TYP,
dmf.M_MAX_LENGTH LEN, dmf.M_DECIMAL DECI,
case dmf.M_DATA_TYPE
when 0 then 'Constant'
when 1 then 'Dyn.table'
when 2 then 'Data dictionary'
when 3 then 'Join ID'
when 4 then 'SQL' end SRC_TYP,
dyn.M_DYN_TABLE SRC_TBL, 
case dyn.M_DYN_TABLE_DIR_TYPE
when 0 then rtrim(dynmr.M_DBFALIAS)
when 1 then rtrim(dynma.M_DBFALIAS) 
when 2 then rtrim(dynur.M_DBFALIAS)
when 3 then rtrim(dynua.M_DBFALIAS) end SRC_UND,
rtrim(dmf.M_RELATED_DATA) SRC_FLD
from RPO_DMSETUP_COLUMN_DBF dmf
left join RPO_DMSETUP_TABLE_DBF dmt on dmf.M_RPO_DMSETUP_TABLE_REF = dmt.M_REFERENCE
left join RPO_DMSETUP_DYN_TABLE_DBF dyn on dmt.M_REFERENCE = dyn.M_REFERENCE
left join RPO_DMSETUP_SQL_TABLE_DBF qry on dmt.M_REFERENCE = qry.M_REFERENCE
left join DYNDBF1#TRN_DYND_DBF dynmr on (dyn.M_DYN_TABLE = dynmr.M_CREATION and dyn.M_DYN_TABLE_DIR_TYPE = 0)
left join DYNDBF2#TRN_DYND_DBF dynur on (dyn.M_DYN_TABLE = dynur.M_CREATION and dyn.M_DYN_TABLE_DIR_TYPE = 2)
left join DYNDBF3#TRN_DYND_DBF dynma on (dyn.M_DYN_TABLE = dynma.M_CREATION and dyn.M_DYN_TABLE_DIR_TYPE = 1)
left join DYNDBF4#TRN_DYND_DBF dynua on (dyn.M_DYN_TABLE = dynua.M_CREATION and dyn.M_DYN_TABLE_DIR_TYPE = 3)
where rtrim(dmt.M_LABEL) ='TR_ST_MIC.REP'
order by TBL, SRC_TYP, FLD