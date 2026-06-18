set colsep '#';
SET TERMOUT OFF;
SPOOL &1;
set linesize 150;
set pagesize 2048;
select T1.M_LABEL as ProductTree, T1.M_DESC as Description, T3.M_LABEL as Product, 
case when (T4.M_LABEL is NULL) then ' ' else T4.M_LABEL end as Father
-------
from CMU_TREE_DBF T1 
-------
left outer join CMU_MMST_DBF T2 on T1.M_REFERENCE= to_number(T2.M_TRE_NAME)
left outer join CM_PHYS_DBF T3 on T2.M_REF=T3.M_REFERENCE
left outer join CM_PHYS_DBF T4 on T2.M_FATHER_R=T4.M_REFERENCE
-------
where T1.M_OBJ_TP=4
order by 1,4,3;
quit;
SPOOL OFF;