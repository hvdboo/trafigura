set colsep '#';
SET TERMOUT OFF;
SPOOL &1;
set linesize 800;
set pagesize 2048;
select 	T1.M_LABEL as ClearedAsians, T1.M_DESC as Description,
case when T1.M_OSPRD_TYP=0 then 'Simple'
when T1.M_OSPRD_TYP=1 then 'ProductSpread'
when T1.M_OSPRD_TYP=2 then 'TimeSpread' end as optionNature,
T18.M_LABEL as Instrument,
case when  T1.M_OSPRD_TYP=1  then T19.M_LABEL else ' ' end as SecondInstrument,
case when  T1.M_OSPRD_TYP=2 then   to_char(T1.M_MAT_SPRD) else ' '  end as  ShiftFarMaturity,
case when  T1.M_OSPRD_TYP=0 then ' ' when T1.M_BENCHMARK=0 then '1st' else '2nd' end as BenchMarkContract,
T2.M_LABEL as ForwardQuotation, 
T4.M_LABEL as MaturitySet,
case when T16.M_LABEL is NULL then ' ' else T16.M_LABEL end as OptionMaturitySet,
case when T1.M_ALLOWSPLT =1 then 'Yes' when T1.M_ALLOWSPLT =0 then 'No' end as AllowSplit, 
case when T1.M_IGN_DISC =1 then 'Yes' when T1.M_IGN_DISC =0 then 'No' end as IgnoreDiscounting, 
case when T1.M_NETTING_ALLOWED =1 then 'Yes' when T1.M_NETTING_ALLOWED =0 then 'No' end as NettingAllowed,
T1.M_QTY as LotSize,
case
when T1.M_OSTYLE=0 then 'European'
when T1.M_OSTYLE=1 then 'American'
end as Style,
case when (T1.M_EXR_MODE=0) then 'Cash settlement' 
	when (T1.M_EXR_MODE=1) then 'Delivery'
	when (T1.M_EXR_MODE=2) then ' ' 
end as ExerciseMode,
case
when T1.M_OEXR_STYLE=0 then 'European'
when T1.M_OEXR_STYLE=1 then 'American'
end as ExerciseStyle,
case when (T1.M_QTY_TYPE=0) then 'Bulk'
	when (T1.M_QTY_TYPE=1) then 'Flow'
end as QuantityType,
case when T1.M_PRC_DISC=0 then 'Quotation end'
	when T1.M_PRC_DISC=1 then 'Delivery end'
end as MatDisplayedUntil,
case
when T1.M_OP_OTCZDAT=0  then 'Trade date'
when T1.M_OP_OTCZDAT=1 then 'Maturity date'
end as PremPayDate,
T1.M_OPREM_OTC as PremPayShift, 
T5.M_LABEL as QuotationSet,T10.M_LABEL as Publication,T5.M_TRAD_SMB as TradingSymbol,
CAST(T5.M_CURR AS VARCHAR2(9)) as Currency, T5.M_PRC_FACT as PriceFactor,  T8.M_LABEL as Unit, T9.M_LABEL as QuantityUnit,
T5.M_TIC as Tic, T5.M_PRC_WIDTH as PriceWidth, T5.M_PRC_DEC as PriceDecimal, T5.M_VOL_WIDTH as VolatilityWidth, T5.M_VOL_DEC as VolatilityDecimal,
case when T14.M_IND_LAB  is null then ' ' else to_char(T5.M_SERIE) end  as IndexSerie,
case when (T14.M_IND_LAB is null) then ' ' else T14.M_IND_LAB end as IndLab, 
T1.M_REALTIME as IndexCode, 
case when (T15.M_LABEL is NULL) then ' ' else T15.M_LABEL end as Asset,
T1.M_COMMENT0 as Comment0, 
T1.M_COMMENT1 as Comment1, T1.M_COMMENT2 as Comment2, T1.M_COMMENT3 as Comment3, T1.M_COMMENT4 as Comment4,
case when (T1.M_PRC_EVAL =0) then 'Marked to market' when (T1.M_PRC_EVAL =1) then 'Theoretical' end as PriceEvaluation,
case
when T1.M_SPRD_TYP=0 then 'Price'
when T1.M_SPRD_TYP=1 then 'Volatility'
end as SpreadType

from 	CM_FUT_DBF T1
left outer join CMC_QUOT_DBF T2 on T2.M_REFERENCE=T1.M_QUOT_FWD
left outer join RT_INSGN_DBF T3 on T3.M_GEN_NUM=T1.M_CM_INSTR
left outer join CM_FMAT_DBF T4  on T4.M_REFERENCE=T1.M_FUT_MAT
left outer join CMC_QUOT_DBF T5 on T5.M_SET=T1.M_QUOT_SET 
left outer join CM_UNIT_DBF T8  on T5.M_UNIT=T8.M_REFERENCE
left outer join CM_UNIT_DBF T9  on T5.M_QTY_UNIT=T9.M_REFERENCE
left outer join CM_MKT_DBF T10  on T5.M_PUBLI=T10.M_REFERENCE 
left outer join CM_FUT_DBF T18 on T1.M_CM_INSTR=T18.M_REFERENCE
left outer join CM_FUT_DBF T19 on T1.M_CONTRACT2=T19.M_REFERENCE
left outer join RT_INDEX_DBF T14 on T5.M_INDEX = T14.M_INDEX
left outer join CM_ASSET_DBF T15 on T1.M_ASSET=T15.M_REFERENCE
left outer join CM_OMAT_DBF T16 on T16.M_REFERENCE=T1.M_OPT_MAT

where T1.M_LISTED=64
order by T1.M_LABEL,T5.M_LABEL;
quit;
SPOOL OFF;
