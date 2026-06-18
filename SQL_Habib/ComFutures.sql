set colsep '#';
SET TERMOUT OFF;
SPOOL &1;
set linesize 1700;
set pagesize 2048;
select 	T1.M_LABEL as CommodityFutures, T1.M_DESC as Description,
T2.M_LABEL as ForwardQuotation, 
case when T1.M_INS_MODE = 0 then 'Custom'
	when T1.M_INS_MODE = 1 then 'Simple'
end as ConfigurationMode,
case when (T3.M_INSTR is NULL or T1.M_INS_MODE=1) then ' ' else  T3.M_INSTR end as Instrument,
case when (T18.M_IND_LAB is NULL or T1.M_INS_MODE=0) then ' ' else  T18.M_IND_LAB end as IndexLabel,
case when T1.M_INS_MODE = 0 then ' '
	when (T1.M_EXR_MODE = 1 and T17.M_EXR_MODE = 1) then 'PhysicalDelivery'
	when (T1.M_EXR_MODE = 1 and T17.M_EXR_MODE = 0) then 'FinancialDelivery'
	when (T1.M_EXR_MODE = 0 and T17.M_EXR_MODE = 0) then 'CashSettlement'
end as DeliveryMode,
T4.M_LABEL as MaturitySet,
case 
when T1.M_LISTED =1 then
 case when T1.M_LOOKALIKE_ENABLED=1 then 'Listed and lookalike'
      else 'Listed' end
else 'OTC' end as ContractType,
case when T1.M_MCALL_SYS =1 then 'Yes' when T1.M_MCALL_SYS =0 then 'No' end as MarginCalls,
case when T1.M_ALLOWSPLT =1 then 'Yes' when T1.M_ALLOWSPLT =0 then 'No' end as AllowSplit, 
case when T1.M_MCALL_DSC =1 then 'Yes' when T1.M_MCALL_DSC =0 then 'No' end as DiscountMarginCalls, 
case when T1.M_SPRD_TYP =1 then 'Yes' when T1.M_SPRD_TYP =0 then 'No' end as IgnoreDiscounting,
case when T1.M_NETTING_ALLOWED =1 then 'Yes' when T1.M_NETTING_ALLOWED =0 then 'No' end as NettingAllowed, 
case when T1.M_DSP_MAT_AL=1 then 'Yes' when T1.M_DSP_MAT_AL=0 then 'No' end as DisplayMatAliases,
T1.M_QTY as LotSize, 
case when T1.M_INS_MODE = 1 then ' '
	when T1.M_EXR_MODE = 0 then 'CashSettlement'
	when T1.M_EXR_MODE = 1 then 'Delivery'
end as ExerciseMode,
case when T1.M_QTY_TYPE =0 then 'Bulk'
	when T1.M_QTY_TYPE =1 then 'Flow'
end as QuantityType, 
case when T1.M_PRC_DISC = 0 then 'Quotation end'
	when T1.M_PRC_DISC = 1 then 'Delivery period'
end as PriceDiscovery,
case when T1.M_MAT_FILTER=0 then 'Quotation end'
         when T1.M_MAT_FILTER=1 then 'Delivery end'
end as MatDispUntil,
case when T1.M_PRC_EVAL =0 then 'Marked to market' when T1.M_PRC_EVAL =1 then 'Theoretical' end as PriceEvaluation,
case when T1.M_FX_FIXDATE=0 then 'Quotation end date'
         when T1.M_FX_FIXDATE=1 then 'Delivery start date'
         when T1.M_FX_FIXDATE=2 then 'spot date'
end as SecQuotFixDate,
T5.M_LABEL as QuotationSet,T10.M_LABEL as Publication,T5.M_TRAD_SMB as TradingSymbol,
CAST(T5.M_CURR AS VARCHAR2(9)) as Currency, T5.M_PRC_FACT as PriceFactor,  T8.M_LABEL as Unit, T9.M_LABEL as QuantityUnit,
T5.M_TIC as Tic, T5.M_PRC_WIDTH as PriceWidth, T5.M_PRC_DEC as PriceDecimal, T5.M_VOL_WIDTH as VolatilityWidth, T5.M_VOL_DEC as VolatilityDecimal,
case when T5.M_SERIE = 0 then ' ' else to_char(T5.M_SERIE) end as IndexSerie, 
case when T16.M_IND_LAB is null then ' ' else T16.M_IND_LAB end as IndLab, 
case when T1.M_SPLT_RULE = 0 then 'QuotationEnd' when T1.M_SPLT_RULE = 1 then 'TransactionDate' end as SplittingRule,
-------
case 
when T13.M_TYPE=0 then'Future'
when T13.M_TYPE=1 then 'Index'
else ' ' 
end as NearbyType,
case 
when T13.M_TYPE=1 then ' '
when T13.M_SHIFT_TYPE=0 then 'Expiry Date'
when T13.M_SHIFT_TYPE=1 then 'Notification first' 
when T13.M_SHIFT_TYPE=2 then 'Notification Last'
else ' '
end as ShiftType,
case
when T13.M_TYPE=1 then ' '
when T13.M_MAT_TYPE=-9 then 'ALL'
when T13.M_MAT_TYPE=-1 then 'Floating'
when T13.M_MAT_TYPE=0 then 'Fixed'
else ' '
end as MaturityType,
case when T13.M_ORDER is null then 0 else  T13.M_ORDER  end as NearbyOrder,
case when T13.M_RW_SHIFTER is NULL then ' ' else T13.M_RW_SHIFTER end as NearbyShifter,
-------
T1.M_OTRD_SYM as OptionTradingSymbol, 
case when (T11.M_LABEL is NULL) then ' ' else  T11.M_LABEL end  as OptionMaturitySet,
case when T1.M_OSTYLE=0 then 'European' 
	when T1.M_OSTYLE=1 then 'American'
	when T1.M_OSTYLE=2 then ' '
end as OptionStyle,
T1.M_OQTY as OptionLotSize,
case when T1.M_OEXR_MODE=0 then 'Cash Settlement' 
	when T1.M_OEXR_MODE=1 then 'Delivery'
	when T1.M_OEXR_MODE=2 then 'Delivery ATM '
end as OptionExerciseMode,
T1.M_OCUTOFF as CutOff,
case when T1.M_OP_OTCZDAT=0 then 'Trade date' when T1.M_OP_OTCZDAT=1 then 'Maturity date' end as PremiumPayment, 
CAST(T1.M_OPREM_OTC AS VARCHAR2(18)) as PremiumPayShifter,T1.M_ODELIV_OTC as CashPayShifter,
case when M_VOL_UND = 0 then 'Own' when M_VOL_UND = 1 then 'UnderlyingIndex' end as VolatilityCurve,
T1.M_REALTIME as RealTimeCode, 
case when (T15.M_LABEL is NULL) then ' ' else T15.M_LABEL end as Asset,
T1.M_COMMENT0 as Comment0, 
T1.M_COMMENT1 as Comment1, T1.M_COMMENT2 as Comment2, T1.M_COMMENT3 as Comment3, T1.M_COMMENT4 as Comment4
-------
from 	CM_FUT_DBF T1
left outer join CMC_QUOT_DBF T2 on T2.M_REFERENCE=T1.M_QUOT_FWD
left outer join RT_INSGN_DBF T3 on T3.M_GEN_NUM=T1.M_CM_INSTR
left outer join CM_FMAT_DBF T4  on T4.M_REFERENCE=T1.M_FUT_MAT
left outer join CMC_QUOT_DBF T5 on T5.M_SET=T1.M_QUOT_SET 
left outer join CM_UNIT_DBF T8  on T5.M_UNIT=T8.M_REFERENCE
left outer join CM_UNIT_DBF T9  on T5.M_QTY_UNIT=T9.M_REFERENCE
left outer join CM_MKT_DBF T10  on T5.M_PUBLI=T10.M_REFERENCE 
left outer join	CM_OMAT_DBF T11 on T1.M_OPT_MAT=T11.M_REFERENCE 
left outer join CM_NEARBY_DBF T13 on T1.M_NEARBY=T13.M_REFERENCE
left outer join CM_ASSET_DBF T15 on T1.M_ASSET=T15.M_REFERENCE
left outer join RT_INDEX_DBF T16 on T16.M_INDEX = T5.M_INDEX
left join CMC_MGEN_DBF T17 on T1.M_CM_INSTR = T17.M_REFERENCE
left join RT_INDEX_DBF T18 on T17.M_INDEX = T18.M_INDEX
-------
where T1.M_LISTED=0 or T1.M_LISTED=1
order by T1.M_LABEL,T5.M_LABEL;
quit;
