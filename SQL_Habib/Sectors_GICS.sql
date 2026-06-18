set colsep '#';
SET TERMOUT OFF;
SPOOL &1;
set linesize 150;
set pagesize 2048;
select T1.M_LABEL as Sector, T1.M_DESC as Description, T4.M_LABEL as Father
-------
from CSF_FOLDER_DBF T1,  CSF_NODE_DBF T2, CSF_TREE_DBF T3 ,  CSF_FOLDER_DBF T4  
-------
where T1.M_REFERENCE =T2.M_OBJ_REF
and T2.M_TREE=T3.M_REFERENCE 
and T3.M_LABEL='Sectors_GICS'  
and T1.M_LABEL<>'Sectors_GICS'
and T4.M_REFERENCE = ( select  T5.M_OBJ_REF from  CSF_NODE_DBF T5  where T5.M_ID=T2.M_FATHER_ID)
-------
order by 1,2,3;
quit;
SPOOL OFF;