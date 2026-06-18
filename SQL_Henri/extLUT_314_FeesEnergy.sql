select 
rtrim(tbl.M_FEE_TYPE)   FeeType,
rtrim(tbl.M_SOURCEMOD)  SourceModule,
rtrim(tbl.M_EVENT)      Event,
rtrim(tbl.M_CTP)        Counterpart,
rtrim(tbl.M_INSTRUMENT) Instrument,
rtrim(tbl.M_TRADESRC)   TradeSource,
rtrim(tbl.M_TRADETYP)   TradeType,
rtrim(tbl.M_LEGAL_ENTY) LegalEntity,
rtrim(tbl.M_UNIT)       Unit,
rtrim(tbl.M_PHYSICAL)   Physical,
rtrim(tbl.M_LOCATION)   Location,
rtrim(tbl.M_CURRENCY)   Currency,
rtrim(tbl.M_INST_CAT)   InstrumentCategory,
rtrim(tbl.M_CMASSET)    COMAsset,
'>',
rtrim(tbl.M_CALC_TYPE)  CalculationType,
rtrim(tbl.M_CALC_VALUE) CalculationValue,
rtrim(tbl.M_CALC_CUR)   CalculationCurrency,
rtrim(tbl.M_ROUND_METH) RoundingMethod,
rtrim(tbl.M_DECIMALS)   Decimals,
rtrim(tbl.M_FIELD_NAME) FieldName,
rtrim(tbl.M_SHIFTER)    Shifter,
rtrim(tbl.M_UNDEF11)    Undef1Crit1,
rtrim(tbl.M_DATE)       Date_

from UDTB314_DBF tbl
order by FeeType, Counterpart, Sourcemodule, InstrumentCategory, Instrument, Undef1Crit1