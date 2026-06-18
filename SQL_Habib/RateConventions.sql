set colsep '#';
SET TERMOUT OFF;
SPOOL &1;
set linesize 320;
set pagesize 2048;
select M_RATE_CONV as RateConvention, M_BASIS as Basis, 
	case when (M_COMP_MODE = 0 ) then 'Linear' when (M_COMP_MODE = 1 ) then 'Daily compounded'
		when (M_COMP_MODE = 2 ) then 'Yield' when (M_COMP_MODE = 3 ) then 'Exponential'
		end as ComputingMode,
	case when (M_RAT_EXPR = 0) then 'Standard basis' when (M_RAT_EXPR = 1) then 'Discount basis' when (M_RAT_EXPR = 2) then 'Fra basis' 
		end as RateExpression,
        case when (M_RAT_QUOT = 0 ) then 'Annualized form      (r)' when (M_RAT_QUOT = 1 ) then 'Semi-annualized form (r x 2)'
		when (M_RAT_QUOT = 2 ) then 'Quarterly form       (r x 4)' when (M_RAT_QUOT = 3 ) then 'Monthly form         (r x 12)'
	end as RateQuotation,
	case when (M_CONVERT = 0 ) then 'No' when (M_CONVERT = 1) then 'Yes' end as Conversion ,
	M_CAP_FACT as ConvertFrom, M_IMP_RATE as ConvertTo,
	case when (M_CVRT_PER = -20) then 'Interest calculation period' when (M_CVRT_PER = -22) then 'Total Interest period' 
		when ((M_CVRT_PER = 0) and (M_CONVERT = 0))  then ' ' else to_char(M_CVRT_PER )  
	end as ConversionPeriod,
	case when ((M_CONVERT = 1) and (M_ROUND_RUL =0)) then 'None' 
	when ((M_CONVERT = 1) and (M_ROUND_RUL =1)) then 'Nearest'  
		when ((M_CONVERT = 1) and (M_ROUND_RUL =2)) then 'By default' 
		 when ((M_CONVERT = 1) and (M_ROUND_RUL =3)) then 'By excess' 
		when ((M_CONVERT = 1) and (M_ROUND_RUL =5)) then 'Nearest 5th' 
		when ((M_CONVERT = 1) and (M_ROUND_RUL =6)) then 'By excess 5th' 
		when ((M_CONVERT = 1) and (M_ROUND_RUL =7)) then 'By default 5th' 
		else ' ' 
		end  as RoundingRule,
	M_DECIMALS  as decimals
	from RT_CONV_DBF
order by M_RATE_CONV;
quit;
SPOOL OFF;