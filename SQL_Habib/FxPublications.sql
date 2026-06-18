set colsep '#';
SET TERMOUT OFF;
SPOOL &1;
set linesize 150;
set pagesize 2048;
select T1.M_DESC as Label, T1.M_CALENDAR as Calendar, 
case when T1.M_FREQUENCY=0 then 'Daily' end as Frequency,
T1.M_COL_NUM as NumberOfColumns,
T3.M_CONTRACT as Contract,
CAST(T3.M_QUOTATION AS VARCHAR2(10)) as Quotation,
T3.M_FORM_FACT as FormFactor,
T2.M_COLUMN as ColumnName,
T2.M_INDEX as ColumnNumber 
-------
from FX_ARCGR_DBF T1, FX_ARCCL_DBF T2, FX_ARCCT_DBF T3
where T3.M_DESC=T1.M_DESC and T2.M_LINK=T1.M_COL_LINK 
-------
order by T1.M_DESC, T3.M_CONTRACT, T2.M_COLUMN;
quit;
SPOOL OFF;