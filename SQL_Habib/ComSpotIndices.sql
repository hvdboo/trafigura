set colsep '#';
SET TERMOUT OFF;
SPOOL &1;
set linesize 700;
set pagesize 2048;
select 	T1.M_LABEL as CommoditySpotIndex, T1.M_DESC as Description, T2.M_LABEL as PhysicalProduct,
T3.M_LABEL as Location, 
case when T1.M_DEL_MECHAN=0 then 'Stock'
	when T1.M_DEL_MECHAN =1 then 'Flow' 
end as Delivery, 
T4.M_LABEL as ForwardQuotation, T1.M_LOTSIZE as LotSize,T1.M_FXNG_SCHD as FixingSchedule, CAST(T1.M_ST_SHFT AS VARCHAR2(20)) as StartDelayShifter, CAST(T1.M_INIT_SHFT AS VARCHAR2(20)) as InitiationShifter,
T5.M_LABEL as QuotationSet,
T10.M_LABEL as Publication,
T5.M_TRAD_SMB as TradingSymbol,CAST(T5.M_CURR AS VARCHAR2(10)) as Currency, T5.M_PRC_FACT as PriceFactor,  T8.M_LABEL as Unit,
T9.M_LABEL as QuantityUnit, T5.M_TIC as Tic, T5.M_PRC_WIDTH as PriceWidth, T5.M_PRC_DEC as PriceDecimal, T5.M_VOL_WIDTH as VolatilityWidth, T5.M_VOL_DEC as VolatilityDecimal,
case when (T13.M_LABEL is NULL) then ' '	else T13.M_LABEL end as Profile,
case when (T12.M_LABEL is NULL) then ' '	else T12.M_LABEL end as SubProfiles, 	
T1.M_REALTIME as IndexCode, 
case when T14.M_LABEL is null then ' ' else T14.M_LABEL end as Asset,
T1.M_COMMENT0 as Comment0, 
T1.M_COMMENT1 as Comment1, T1.M_COMMENT2 as Comment2, T1.M_COMMENT3 as Comment3, T1.M_COMMENT4 as Comment4, 
case when T1.M_FLEXFLAG=0 then 'No'
	when T1.M_FLEXFLAG =1 then 'Yes'
end as Flex,
case when T16.M_LABEL is null then ' ' else T16.M_LABEL end as Registration
-------
from 	CM_INDEX_DBF T1
left outer join CM_PHYS_DBF T2 	on T2.M_REFERENCE=T1.M_PHYSICAL
left outer join CM_LOCAT_DBF T3 on T3.M_REFERENCE=T1.M_LOCATION
left outer join CMC_QUOT_DBF T4 on T4.M_REFERENCE=T1.M_QUOT_FWD
left outer join CMC_QUOT_DBF T5 on T5.M_SET=T1.M_QUOT_SET 
left outer join CM_UNIT_DBF T8 	on T5.M_UNIT=T8.M_REFERENCE
left outer join CM_UNIT_DBF T9  on T5.M_QTY_UNIT=T9.M_REFERENCE
left outer join CM_MKT_DBF T10  on T5.M_PUBLI=T10.M_REFERENCE 
left outer join CM_INDPF_DBF T11 on	T1.M_REFERENCE=T11.M_REFERENCE
left outer join CM_PROFH_DBF T12 on	T11.M_PROFILE=T12.M_REFERENCE
left outer join CM_PROFH_DBF T13 on	T1.M_PROF_FULL=T13.M_REFERENCE
left outer join CM_ASSET_DBF T14 on T1.M_ASSET = T14.M_REFERENCE
left outer join CM_REGMAP_IND_DBF T15 on T1.M_REFERENCE = T15.M_IND_REF
left outer join CM_REG_DBF T16 on T15.M_REG_REF = T16.M_REFERENCE
order by T1.M_LABEL, T5.M_LABEL,T12.M_LABEL;
quit;
SPOOL OFF;