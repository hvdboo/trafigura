set colsep '#';
SET TERMOUT OFF;
SPOOL &1;
set linesize 550;
set pagesize 2048;


select	T1.M_SE_D_LABEL as "Label", T1.M_SE_CATE as Category,

case when T16.M_SE_SEC_WEI=0 then ' '  when  T17.M_LABEL is null then ' ' else T17.M_LABEL   end as CommodityFutureLabel,
case when T1.M_SE_CATE='Equity' or T18.M_LABEL is NULL then ' '  else T18.M_LABEL end as MarketQuotation,
case when T1.M_SE_CATE='Equity' or T19.M_LABEL is null then ' ' else T19.M_LABEL  end as MaturityInstrument,

case when T16.M_SE_SEC_WEI<>0 or T1.M_SE_CATE = 'Commodity' then ' ' when T20.M_SE_D_LABEL is null then  T16.M_SE_BSK_COM   else  T20.M_SE_D_LABEL end as SecurityLabel,
case when T16.M_SE_SEC_WEI<>0  or T1.M_SE_CATE = 'Commodity' or  T16.M_SE_BSK_MAR is NULL then ' ' else T16.M_SE_BSK_MAR end as SecurityMarket,

case when T16.M_SE_SEC_WEI<>2 then ' ' else T22.M_IND_LAB end as CommodityIndexLabel,
case when T16.M_SE_SEC_WEI=0 then ' '  when  T1.M_SE_CATE='Hybrid' and M_SE_SEC_WEI=1 then T22.M_IND_LAB else ' '   end as IRLabel,
case when T16.M_SE_SEC_WEI<>3 then ' ' else  T22.M_IND_LAB end  as FxLabel,
case when T16.M_SE_SEC_WEI<>4 then ' ' else  T23.M_INSTR end  as InflationLabel,


case when  T5.M_SE_B_W = 2 then CAST(T16.M_SE_BSK_WEI as VARCHAR2(30))  else CAST(T16.M_SE_BSK_WEI as VARCHAR2(30))  end as WeightInstrument,
case when T5.M_SE_B_W = 3 then ' '
when T1.M_SE_CATE='Commodity' then ' ' else CAST(T16.M_SE_THI_WEI as VARCHAR2(30)) end as InitialSpotInstrument

from  SE_HEAD_DBF  T1, SE_ROOT_DBF T2, SE_BK_DBF T5, 
SE_TRDC_DBF T8 ,SE_TRDS_DBF T15,
SE_MKTOP_DBF T4,
SE_BKC_DBF T16 left outer join CM_FUT_DBF T17 on T16.M_SE_BSK_COM = to_char(T17.M_REFERENCE)||'.000000'
               left outer join CMC_QUOT_DBF T18 on T16.M_SE_BSK_MAR =  to_char(T18.M_REFERENCE)||'.000000'
               left outer join CM_FMAT1_DBF T19 on T16.M_SE_BSK_MAT = T19.M_REFERENCE
               left outer join SE_HEAD_DBF T20 on T16.M_SE_BSK_COM =  to_char(T20.M_REFERENCE)
               left outer join RT_INDEX_DBF T22 on T16.M_SE_BSK_COM = to_char(T22.M_REFERENCE )
               left outer join RT_INSGN_DBF T23 on T16.M_SE_BSK_COM = to_char(T23.M_GEN_NUM) ,
CM_LI_TEMP_DBF T21 

where	T1.M_SE_LABEL = T2.M_SE_LABEL
and   	T1.M_SE_LABEL = T4.M_SE_LABEL
and          T4.M_SE_INUM   = T16.M_SE_INUM   

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