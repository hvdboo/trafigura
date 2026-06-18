set colsep '#';
SET TERMOUT OFF;
SPOOL &1;
set linesize 750;
set pagesize 2048;
select	CAST(T1.M_SE_MKT_OPT AS VARCHAR2(15)) as OptionContract, 
case when (T1.M_SE_CTR_T = 0) then 'Listed' else 'OTC' end as ContractType,
	T1.M_SE_MARKET as Market , CAST(T1.M_SE_GROUP AS VARCHAR2(15)) as UnderlyingGroup, 
	CAST(T1.M_SE_TYPE AS VARCHAR2(15)) as UnderlyingType, T1.M_SE_CATE as Category, CAST(T1.M_SE_PTYPE AS VARCHAR2(15))  as ProductType, T1.M_SE_DESC as Description, 
	case	when (T2.M_SE_OPT_ST =0 ) then 'American' when (T2.M_SE_OPT_ST =1 ) then 'European' end  as Style,
	case	when (T2.M_SE_OPT_SE =0 ) then 'Delivery' when (T2.M_SE_OPT_SE =1 ) then 'Cash'  end as Settlement,
	CAST(T2.M_SE_LST_MAT AS VARCHAR2(15)) as OptionMaturity,
	case	when (T2.M_SE_ECONVF0 =0) then 'Inherited' when (T2.M_SE_ECONVF0 =1) then 'Redefined' end as UnderlyingConventionFlag,
	CAST(T2.M_SE_ECONV0 AS VARCHAR2(20)) as DefaultConvention, 
	case	when (T2.M_SE_MARG_F =0) then 'No' else 'Yes' end as Margining, T2.M_SE_PR_PA as PremiumPayment,
	case when T2.M_SE_OPT_LS0 = 0 then 1 else T2.M_SE_OPT_LS0 end as OptionLotSize,
	case	when (T2.M_SE_KQUOF = 0) then 'Inherited'  when (T2.M_SE_KQUOF = 1) then 'Redefined' end as StrikeQuotation1, 
	case	when (T2.M_SE_KQUO = 0) then 'Price' 
		when (T2.M_SE_KQUO = 2) then 'Converted yield' 
		when (T2.M_SE_KQUO = 6) then 'Non converted yield' 
	end as StrikeQuotation2,
	case	when ((T2.M_SE_KYT = 0) and (T2.M_SE_KQUO = 2)) then 'Coupon frequency'
		when ((T2.M_SE_KYT = 1) and (T2.M_SE_KQUO = 2)) then 'Annual' 
		when ((T2.M_SE_KYT = 2) and (T2.M_SE_KQUO = 2)) then 'Simple' else ' '
	end as StrikeQuotation3,
	case	when ((T2.M_SE_KYC = 0) and (T2.M_SE_KQUO = 2)) then 'Fwd' 
		when ((T2.M_SE_KYC = 1) and (T2.M_SE_KQUO = 2)) then 'Spot' 
		when ((T2.M_SE_KYC = 2) and (T2.M_SE_KQUO = 2)) then 'Exer' else ' '
	end as StrikeQuotation4,
	case	when (T2.M_SE_PQUO =0) then 'Price' 
		when (T2.M_SE_PQUO =1) then 'Yield'
		when (T2.M_SE_PQUO =2) then 'Percentage'
	end as PremiumQuotation,
	case	when (T2.M_SE_PNOT = 0 ) then 'Std'
		when (T2.M_SE_PNOT = 1 ) then '8th'
		when (T2.M_SE_PNOT= 2 ) then '16th'
		when (T2.M_SE_PNOT = 3 ) then '32th'
		when (T2.M_SE_PNOT= 4 ) then '64th'
		when (T2.M_SE_PNOT= 5 ) then '128th'
		when (T2.M_SE_PNOT= 6 ) then '256th'
		when (T2.M_SE_PNOT = 131 ) then '32sp'
	end as PremiumNotation,	
case	when (T2.M_SE_PROUND = 0) then 'None' 
		when (T2.M_SE_PROUND = 1) then 'Nearest' 
		when (T2.M_SE_PROUND = 2) then 'By default' 
		when (T2.M_SE_PROUND = 3) then 'By excess' 
	end as PremiumRoundingRule,
	T2.M_SE_PDEC as PremiumDecimals, 
	case when (T2.M_SE_CROUND = 0) then 'None' 
		when (T2.M_SE_CROUND = 1) then 'Nearest' 
		when (T2.M_SE_CROUND = 2) then 'By default' 
		when (T2.M_SE_CROUND = 3) then 'By excess' 
	end as CashRoundingRule,
	T2.M_SE_CDEC as CashDecimals,
	T2.M_SE_STR_STP as StrikeStep, 
	case	when (T2.M_SE_PAR_O = 0 ) then 'No' else 'Yes' end as ParityOption
-------
from SE_MKT2_DBF T1, SE_TRDO_DBF T2 
-------
where T2.M_SE_TCO_L=T1.M_SE_OPT_IN
and T2.M_IDENTITY in (select b.M_IDENTITY  
                        from SE_TRDO_DBF b
                        where b.M_IDENTITY = 
                        (select MIN(a.M_IDENTITY)
                         from SE_TRDO_DBF a
                         where a.M_SE_TCO_L = b.M_SE_TCO_L)
                         and b.M_SE_TCO_L = T2.M_SE_TCO_L)
order by T1.M_SE_MKT_OPT;
quit;
SPOOL OFF;