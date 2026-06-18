set colsep '#';
SET TERMOUT OFF;
SPOOL &1;
set linesize 800;
set pagesize 2048;
SELECT T1.M_LABEL as ComAccount,T1.M_DESC as Description, 
case when T2.M_DSP_LABEL is NULL then ' ' else T2.M_DSP_LABEL end as Owner,
case when T3.M_DSP_LABEL is NULL then ' ' else T3.M_DSP_LABEL end as Holder
 FROM ACT_PHYS_DBF T1
left outer join TRN_CPDF_DBF T2 on T2.M_ID=T1.M_OWNER
left outer join TRN_CPDF_DBF T3 on T3.M_ID=T1.M_HOLDER
order by 1;
quit;
SPOOL OFF;