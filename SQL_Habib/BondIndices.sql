set colsep '#';
SET TERMOUT OFF;
SPOOL &1;
set linesize 380;
set pagesize 2048;
select	T1.M_IND_LAB as BondIndex,
	case	when (T1.M_CATEGORY  = 2 ) then 'Bond price' end as Category,
 	T1.M_IND_DESC as Decription,   M_IND_CODE as Code, 
	case	when (M_RESET = 0) then 'Published index'
		when (M_RESET = 2) then 'Compounded'
		when (M_RESET = 3) then 'Average'
		when (M_RESET = 4) then 'Basket'
		when (M_RESET = 5) then 'Start-end'
		when (M_RESET = 6) then 'Nearby'
	end as Formula,
	T3.M_SE_D_LABEL as Underlying, CAST(T1.M_RT_MKT AS VARCHAR2(17)) as UnderlyingMarket,  T2.M_GRP_DESC as ArchivingGroup, 
	case 	when (M_ESTIM_MODE = 0 ) then 'No' when (M_ESTIM_MODE = 1 ) then 'Yes' end as Estimation,
	case 	when (T1.M_FLEX = 0 ) then 'No' when (T1.M_FLEX = 1) then 'Yes' end as Flex ,
	case	when (T1.M_OFF_RESET = 0) then 'No' when (T1.M_OFF_RESET =1) then 'Yes' end as OfficialReset
-------
from	RT_INDEX_DBF T1, RT_GROUP_DBF T2 , SE_HEAD_DBF T3
-------
where	T1.M_CATEGORY=2
and	T1.M_HISFILE=T2.M_HISFILE 
and     T1.M_RT_SELAB = T3.M_SE_LABEL (+)
order by	T1.M_IND_LAB;
quit;
SPOOL OFF;