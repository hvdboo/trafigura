set colsep '#';
SET TERMOUT OFF;
SPOOL &1;
set linesize 120;
set pagesize 2048;
select  T2.M_DSP_LABEL as Label, T2.M_ISS_CAT as IssuerCategory, CAST(T2.M_STATE AS CHAR(10)) as IsState, T1.M_RED_ID as "RedID", 
 CAST(T1.M_CLS_M AS CHAR(15)) as "CLSEligible", T1.M_MKIT_TCKR as "MKITTCKR"
from TABLE#DATA#COUNTERP_DBF  T1, TRN_CPDF_DBF T2 
where T2.M_ISSUER='Y' and T2.M_LABEL=T1.M_LABEL 
order by T2.M_DSP_LABEL;
quit;
SPOOL OFF;