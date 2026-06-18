set colsep '#';
SET TERMOUT OFF;
SPOOL &1;
set linesize 200;
set pagesize 2048;
select  CAST(M_SE_DCONV AS VARCHAR2(20)) as DefaultConvention, M_SE_PAY_NBD as PaymentDate, M_SE_CD_NBD as CouponDate,
	case	when (M_SE_CD_EI = 0) then 'Exclusive'  when (M_SE_CD_EI = 1) then 'Inclusive' end as InclusiveExclusive,
	case	when (M_SE_PAF_NBD = 0) then 'No' when (M_SE_PAF_NBD = 1) then 'Yes' end as AdjustmentDate,
	M_SE_PA_NBD as Adjustment , 
	case	when (M_SE_EX_D_F = 0) then 'No' when (M_SE_EX_D_F = 1) then 'Yes' end as ExdividendBasedOnPayment
------
from SE_TRCO_DBF
------
order by M_SE_DCONV;
quit;
SPOOL OFF;