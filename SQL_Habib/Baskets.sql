set colsep '#';
SET TERMOUT OFF;
SPOOL &1;
set linesize 550;
set pagesize 2048;


select	T1.M_SE_D_LABEL as "Label", T1.M_SE_CATE as Category, T1.M_SE_TYPE as Type,T1.M_SE_CODE as SecurityCode, T1.M_SE_I_CODE as InternalCode, 
T1.M_SE_F_NAME as FullName, T1.M_SE_RTF0 as RealTimeCode,T2.M_SE_MARKET as Market, 
T2.M_SE_TRDCL  as tradingClauses ,
T8.M_SE_TCQ_L as InheritedQuotation,

case when (T2.M_SE_TCQ_L<>T8.M_SE_TCQ_L) then T2.M_SE_TCQ_L else ' ' end as CustomizedQuotation,
case when T2.M_SE_SEC_LS0 = 0 then T15.M_SE_SEC_LS0 else T2.M_SE_SEC_LS0 end as LotSize ,
case when (T5.M_SE_B_W = 0) then 'User defined' 
when (T5.M_SE_B_W = 1) then  'Listed Capital' 
when (T5.M_SE_B_W = 2) then  'List of assets' 
when (T5.M_SE_B_W = 3) then  'Proxy Hedge' 

end  as BasketType ,
case	
when T5.M_SE_B_W = 3 or T5.M_SE_B_W = 2 then ' ' 
when (T5.M_SE_B_SF = 0 ) then 'Index weighting'
when (T5.M_SE_B_SF = 1 ) then 'Constant weighting'
when (T5.M_SE_B_SF = 2 ) then 'Percentage weighting'
when (T5.M_SE_B_SF = 3) then 'Excess return DJUBCI'
 when T5.M_SE_B_SF is null then ' '
end as SpotFormula,


case 
when T1.M_SE_TYPE = 'ETF' then ' '
when T1.M_SE_CATE='Commodity' then ' '
when T1.M_SE_CATE in ('Equity', 'Hybrid','Composite','Bond') then
		 case 
          when T5.M_SE_B_W = 3 or  T5.M_SE_B_W = 2 then ' ' 
          when T5.M_SE_FX_RULE=0 and (T5.M_SE_B_W = 0 or T5.M_SE_B_W = 1)  then 'Standard/Composite'
			 when T5.M_SE_FX_RULE=1 and (T5.M_SE_B_W = 0 or T5.M_SE_B_W = 1) then 'Quanto'
		   else ' '
      end

end as MultiCurrRule,


case	
	when (T5.M_SE_B_SW = 0 and T1.M_SE_CATE<>'Commodity' and T1.M_SE_TYPE='Std' and (T5.M_SE_B_W = 0 or T5.M_SE_B_W = 1)) then 'No' 
	when (T5.M_SE_B_SW = 1 and T1.M_SE_CATE<>'Commodity' and T1.M_SE_TYPE='Std' and (T5.M_SE_B_W = 0 or T5.M_SE_B_W = 1)) then 'Yes' 
   else ' '
end as AdjustCoefBySecurity,
case  when T5.M_SE_B_W = 2 then ' '
when  (T1.M_SE_CATE='Commodity' or  T1.M_SE_TYPE<>'Std' or T5.M_SE_B_SF<>0)   then ' ' else  CAST(T5.M_SE_B_II as VARCHAR2(30))  end as InitialIndex, 

case when T5.M_SE_B_W = 2 then ' '
 when  (T1.M_SE_CATE='Commodity' or T1.M_SE_TYPE<>'Std' or  T5.M_SE_B_SF<>0 ) then ' ' else CAST(T5.M_SE_B_IC as VARCHAR2(30)) end as InitialCapitalization, 

case when T5.M_SE_B_W = 2 then ' '
when  (T1.M_SE_CATE='Commodity' or  T1.M_SE_TYPE<>'Std' or  T5.M_SE_B_SF<>0 ) then ' '  else CAST(T5.M_SE_B_K as VARCHAR2(30)) end  as AdjustmentFactor,

case when T5.M_SE_B_W = 2 then ' '
 when  (T1.M_SE_CATE='Commodity' or T1.M_SE_TYPE<>'ETF' or T5.M_SE_B_SF<>0) then ' ' else CAST(T5.M_SE_B_IC as VARCHAR2(30))  end as NumberOfShares, 

case when  (T1.M_SE_CATE='Commodity' or T1.M_SE_TYPE<>'ETF' )   then ' '  else  CAST(T5.M_SE_B_CSH as VARCHAR2(30)) end as CashValue,

case when T21.M_LABEL is null then ' ' else T21.M_LABEL  end  as ListedIndexTemplate


from  SE_HEAD_DBF  T1, SE_ROOT_DBF T2, SE_BK_DBF T5, 
SE_TRDC_DBF T8 ,SE_TRDS_DBF T15,
SE_MKTOP_DBF T4,CM_LI_TEMP_DBF T21 

where	T1.M_SE_LABEL = T2.M_SE_LABEL
and   	T1.M_SE_LABEL = T4.M_SE_LABEL


and T5.M_SE_B_CTR=T21.M_REFERENCE (+) 

and 	        T5.M_SE_INUM =T4.M_SE_INUM 


and  	T15.M_SE_TCS_L = T8.M_SE_TCS_L
and 	T2.M_SE_TRDCL = T8.M_SE_TRDCL
and 	T1.M_SE_GROUP = 'Basket'
and     T1.M_SE_TYPE  <> 'Adr'

and 	T4.M_IDENTITY IN (select b.M_IDENTITY
                           from SE_MKTOP_DBF b
                            where b.M_SE_GEN = 
                            (select MAX (a.M_SE_GEN)
                                from SE_MKTOP_DBF a
                                where a.M_SE_LABEL = b.M_SE_LABEL)
                                and b.M_SE_LABEL = T1.M_SE_LABEL)
order by  T1.M_SE_D_LABEL,T2.M_SE_MARKET;

----
quit;
SPOOL OFF;