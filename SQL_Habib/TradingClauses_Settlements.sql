set colsep '#';
SET TERMOUT OFF;
SPOOL &1;
set linesize 450;
set pagesize 2048;
select	CAST(M_SE_TCS_L AS VARCHAR2(25)) as TradingClausesSettlement, 
	case when (M_SE_SET = 0) then 'Cash' 
		when (M_SE_SET = 1) then 'Forward' 
		when (M_SE_SET = 2) then 'cash (alternated)' 
	end  as DefaultSettlement,
	CAST(M_SE_DCONV AS VARCHAR2(20)) as DefaultConvention, CAST(M_SE_CLEAR AS VARCHAR2(15)) as ClearingCenter,
	case when (M_SE_O_SET_F = 0 ) then 'No'  
		when (M_SE_O_SET_F= 1) then 'Yes' 
	end  as Other,
	case when (M_SE_SEC_LS0=0) then 1 else M_SE_SEC_LS0 end as LotSize, 
	case when (M_SE_EX_D_F = 0 ) then 'No'
		when (M_SE_EX_D_F = 1) then 'Yes(Standard)'
		when (M_SE_EX_D_F = 2) then 'Yes(No Interest)' 
	end as ExDividend,
	case	when (M_SE_MARG_F = 0 ) then 'No'  when (M_SE_MARG_F= 1) then 'Yes' end as Margining,
	CAST(M_SE_EX_D_R AS VARCHAR2(15)) as ExDividendRule , M_SE_SEC_LS1 as Nominal,
	case when ( (M_SE_FS_RSF0 = 0) and (M_SE_SET = 1) ) then 'Rule' 
		when ( (M_SE_FS_RSF0 =1) and (M_SE_SET = 1) ) then 'MaturitySet' 
		else ' ' 
	end as Default_Maturity_Rule,
	CAST(M_SE_FS_RS0 AS VARCHAR2(20)) as Default_MaturitySet  ,
	case when ( (M_SE_FS_RSF1 = 0) and (M_SE_O_SET_F = 1) ) then 'Rule' 
		when ( (M_SE_FS_RSF1 =1) and (M_SE_O_SET_F = 1) ) then 'MaturitySet' else ' ' 
	end as Other_Maturity_Rule,
	CAST(M_SE_FS_RS1 AS VARCHAR2(20)) as Other_MaturitySet , M_SE_SHIFT as Shifter , CAST(M_SE_CACONV AS VARCHAR2(20)) as  AlternateConvention
-------
from SE_TRDS_DBF
-------
where M_SE_TCS_T = 'TRDCL'
and	M_SE_TCS_L <> ' '
-------
order by M_SE_TCS_L;
quit;
SPOOL OFF;