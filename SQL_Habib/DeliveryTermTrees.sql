set colsep '#';
SET TERMOUT OFF;
SPOOL &1;
set linesize 150;
set pagesize 2048;
select T1.M_LABEL as DeliveryTermsTree, T1.M_DESC as Description, T3.M_LABEL as DeliveryTerm, 
case when (T4.M_LABEL is null) then ' ' else T4.M_LABEL end as Father
from CSF_TREE_DBF T1 
left outer join CSF_NODE_DBF T2 on T1.M_REFERENCE= T2.M_TREE
left outer join CMC_DLV_TRM_DBF T3 on T2.M_OBJ_REF=T3.M_REFERENCE
left outer join CSF_NODE_DBF T5 on T5.M_ID=T2.M_FATHER_ID
left outer join CMC_DLV_TRM_DBF  T4 on T4.M_REFERENCE = T5.M_OBJ_REF
where T1.M_NODE_CLASS = 'MfKgV42056'
order by 1,4,3;
quit;
SPOOL OFF;