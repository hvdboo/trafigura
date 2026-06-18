set colsep '#';
SET TERMOUT OFF;
SPOOL &1;
set linesize 550;
set pagesize 2048;

select  T1.M_SE_D_LABEL as "ETF",T1.M_SE_F_NAME as FullName, T1.M_SE_I_CODE as InternalCode, T1.M_SE_CODE as SecurityCode,
case when (T1.M_SE_ISS ='') then ' ' else T3.M_DSP_LABEL end as Issuer,T1.M_SE_RTF0 as RealTimeCode,
T2.M_SE_MARKET as Market, T2.M_SE_TRDCL  as TradingClauses,													
T6.M_SE_CUR as InheritedCurrrency,


case when (T2.M_SE_CUR<>T6.M_SE_CUR) then T2.M_SE_CUR else ' ' end as CustomizedCurrency,
T6.M_SE_TCQ_L as InheritedQuotation,
case when (T2.M_SE_TCQ_L<>T6.M_SE_TCQ_L) then T2.M_SE_TCQ_L else ' ' end as CustomizedQuotation,
T6.M_SE_TCS_L as InheritedSettlement,
case when (T2.M_SE_TCS_L<>T6.M_SE_TCS_L) then T2.M_SE_TCS_L else ' ' end as CustomizedSettlement,
case when (T7.M_SE_SEC_LS0=0) then 1 else T7.M_SE_SEC_LS0 end as InheritedLotSize,
case when (T2.M_SE_SEC_LS0=0) then ' ' 
	when (T2.M_SE_SEC_LS0<>T7.M_SE_SEC_LS0) then CAST( T2.M_SE_SEC_LS0 AS varchar2(30)) 
	else ' ' 
end as CustomizedLotSize,
case when (T2.M_SE_FIRSTSD is null) then ' ' else CAST(T2.M_SE_FIRSTSD AS varchar2(3))  end as FirstSettlementDate,
case when T2.M_SE_SEC_LS1 = 0 then T7.M_SE_SEC_LS1 else T2.M_SE_SEC_LS1 end as Nominal ,														

case when T12.M_SE_RND_R_L is null then ' ' else T12.M_SE_RND_R_L  end   as RoundRuleLab,
case	when (T12.M_SE_TRND_R = 0) then 'None' 																
when (T12.M_SE_TRND_R = 1) then 'Nearest' 															
when (T12.M_SE_TRND_R = 2) then 'By default' 
when (T12.M_SE_TRND_R = 3) then 'By excess'											
when T12.M_SE_TRND_R  is null then ' '
end as TAmountRoundingRule,

case when T12.M_SE_TRND_D is null then 0 else   T12.M_SE_TRND_D  end as TAmountDecimals, 

case	 when (T12.M_SE_ARND_R = 0) then 'None' 																
when (T12.M_SE_ARND_R = 1) then 'Nearest' 															
when (T12.M_SE_ARND_R = 2) then 'By default' 
when (T12.M_SE_ARND_R = 3) then 'By excess'											
when T12.M_SE_ARND_R  is null then ' '
end as AccAmntRoundRule,
case when T12.M_SE_ARND_D is null then 0 else  T12.M_SE_ARND_D  end as AccAmntDecimals,	

case when (T2.M_SE_AMORTT = 0 ) then 'Nominal'
when (T2.M_SE_AMORTT = 1 ) then 'Position'
end as AmortizingType,															
case when T15.M_SE_D_LABEL is null then ' ' else T15.M_SE_D_LABEL end as UnderlyingBasket,
case when T14.M_EQ_BMARKET is null then ' ' else T14.M_EQ_BMARKET end as BasketMarket,
case 
when T14.M_EQ_D_R_F=0 then 'Detached'
when T14.M_EQ_D_R_F=1 then 'Net amount reinvested'
when T14.M_EQ_D_R_F=2 then 'Gross amount reinvested'
end as Dividends,  
case when T16.M_IND_LAB is null then ' ' else T16.M_IND_LAB end as Multiplier


from  SE_ROOT_DBF T2, SE_TRDC_DBF T6,  SE_TRDS_DBF T7 , SE_HEAD_DBF  T1, TRN_CPDF_DBF T3, SE_SRNDR_DBF T12,
SE_MKTOP_DBF T13, EQ_SE_DBF T14,SE_HEAD_DBF T15,RT_INDEX_DBF T16																				

						
where	T1.M_SE_LABEL = T2.M_SE_LABEL 
and 	T1.M_SE_TYPE  = 'ETF'
and	T1.M_SE_GROUP = 'Equity'															
and	T2.M_SE_TRDCL 	= T6.M_SE_TRDCL 													
and	T6.M_SE_TCS_L	= T7.M_SE_TCS_L
and T1.M_SE_ISS = T3.M_LABEL (+)
and T2.M_SE_RND_R = T12.M_REFERENCE (+)	
and T1.M_SE_LABEL=T13.M_SE_LABEL (+)
and  T13.M_SE_INUM =T14.M_EQ_INUM (+)
and T14.M_EQ_BASKET = T15.M_SE_LABEL (+)
and T14.M_EQ_RT_INDEX =T16.M_INDEX (+)	
																						
order by T1.M_SE_D_LABEL, T2.M_SE_MARKET;


quit;
SPOOL OFF;
