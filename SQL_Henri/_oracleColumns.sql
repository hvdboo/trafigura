select 
tbl.TABLESPACE_NAME SCH,
col.TABLE_NAME TBL, 
col.COLUMN_ID ID, col.COLUMN_NAME COL,
col.DATA_TYPE TYP, col.DATA_LENGTH LEN, col.DATA_PRECISION PRC,
col.NULLABLE NUL
from user_tab_columns col
left join user_tables tbl on col.TABLE_NAME = tbl.TABLE_NAME
order by tbl.TABLESPACE_NAME, col.TABLE_NAME, col.COLUMN_ID




