set colsep '#';
SET TERMOUT OFF;
SPOOL &1;
set linesize 175;
set pagesize 2048;
select  M_LABEL as Adjustment, 
	case when  (M_TYPE=6 ) then 'Stub Condition' else to_char(M_TYPE) end  as Type,
	M_LABELC as Shifter , 
	case when (M_FC_COUP = 0 ) then 'Short Coupon' when (M_FC_COUP = 1) then 'Long Coupon' 
		when (M_FC_COUP = 3 ) then 'Full Coupon' end as IfCoupon, 
	case when (M_SC_COUP = 0 ) then 'Short Coupon' when (M_SC_COUP = 1) then 'Long Coupon' 
		when (M_SC_COUP = 3 ) then 'Full Coupon' end as ElseCoupon 
from DAT_ADJT_DBF 
where M_TYPE=6 
order by  M_LABEL;
quit;
SPOOL OFF;