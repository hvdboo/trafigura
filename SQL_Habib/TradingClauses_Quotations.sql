set colsep '#';
SET TERMOUT OFF;
SPOOL &1;
set linesize 850;
set pagesize 2048;
select  M_SE_TCQ_L as Quotation, M_SE_GROUP as Type,
	case	when (M_SE_MQUO = 0 ) then 'Price'
		when (M_SE_MQUO = 1 ) then 'Percentage'
		when (M_SE_MQUO = 2 ) then 'Yield'
		when (M_SE_MQUO = 4 ) then '100-X'    
		when (M_SE_MQUO = 5 ) then 'X'
	end as MainQuotation,
	case	when (M_SE_MQUO = 2 ) and (M_SE_MYT = 0) then 'C.freq'  
		when (M_SE_MQUO = 2 ) and (M_SE_MYT = 1) then 'Annual' 
		when (M_SE_MQUO = 2 ) and (M_SE_MYT = 2) then 'Simple'  
	else ' ' end as MainYieldT ,
	case	when (M_SE_MNOT = 0 ) then 'Std'
		when (M_SE_MNOT = 1 ) then '8th'
		when (M_SE_MNOT = 2 ) then '16th'
		when (M_SE_MNOT = 3 ) then '32th'
		when (M_SE_MNOT = 4 ) then '64th'
		when (M_SE_MNOT = 5 ) then '128th'
		when (M_SE_MNOT = 6 ) then '256th'
		when (M_SE_MNOT = 131 ) then '32sp'
               when (M_SE_MNOT = 9) then '32tr'
               when (M_SE_MNOT = 16) then '32tr.4'
	end as MainNotation,
	M_SE_MDEC as MainDecimals, 
	case	when (M_SE_MROUND = 0) then 'None'
		when (M_SE_MROUND = 1) then 'Nearest'
		when (M_SE_MROUND = 2) then 'By default'
		when (M_SE_MROUND = 3) then 'By excess'
	end   as MainRounding,
	M_SE_PRIC_FA as PriceFactor,	M_SE_TICK_SI as TickSize,M_SE_PRI_TOL as PriceTolerance,
	case	when (M_SE_GROUP='Bond') and (M_SE_PPER =0) then 'Unitary'
		when (M_SE_GROUP='Bond') and (M_SE_PPER = 1) then 'Percentage'
		when (M_SE_GROUP='Bond') and (M_SE_PPER = 2) then 'Flat'
		when (M_SE_GROUP<>'Bond') and (M_SE_PPER =0) then 'Unitary'
		when (M_SE_GROUP<>'Bond') and (M_SE_PPER = 1) then 'Percentage'
		when (M_SE_GROUP<>'Bond') and (M_SE_PPER = 2) then 'Flat'
		when (M_SE_GROUP<>'Bond') and (M_SE_PPER = 3) then 'Flat on'
	end as PricePercentage,
-------
case when ((M_SE_GROUP<>'Bond') and (M_SE_PPER = 3)) then to_char(M_SE_PPERF)
when (M_SE_GROUP='Bond') then ' '
when ((M_SE_GROUP<>'Bond') and (M_SE_PPER <> 3)) then ' ' end as PriceExpValue,
-------
case	when (M_SE_GROUP='Future') and (M_SE_HVAL =0) then 'Main'
		when (M_SE_GROUP='Future') and (M_SE_HVAL = 1) then 'Price'
		when (M_SE_GROUP='Future') and (M_SE_HVAL = 2) then 'Yield'
		when (M_SE_GROUP<>'Future') then ' '
	end as HistorizedQuotation,
-------
	case	when (M_SE_MQUO = 0 ) and (M_SE_MPT = 0) then 'Clean'
		when (M_SE_MQUO = 0 ) and (M_SE_MPT = 1) then 'Dirty'
		when (M_SE_MQUO = 0 ) and (M_SE_MPT = 2) then 'Dirty Short Cpn'
                when (M_SE_MQUO = 0 ) and (M_SE_MPT = 3) then 'Clean Full'
	else ' ' end  as MainPriceT, 
	case when (M_SE_GROUP='Bond') and (M_SE_MQUO = 0 ) and (M_SE_MRNDMOD = 0 ) then 'Standard' 
		 when (M_SE_GROUP='Bond') and (M_SE_MQUO = 0 ) and (M_SE_MRNDMOD = 1 ) then 'Clean'
	    	 when (M_SE_GROUP='Bond') and (M_SE_MQUO = 0 ) and (M_SE_MRNDMOD = 2 ) then 'Dirty' 
                 when (M_SE_GROUP='Bond') and (M_SE_MQUO = 0 ) and (M_SE_MRNDMOD = 3 ) then 'None' 
	else ' ' end as MainCleanRoundingMode,
	case	when (M_SE_GROUP='Bond') and (M_SE_MQUO = 0 ) and (M_SE_MDRNMOD = 0 ) then 'None'
	        when (M_SE_GROUP='Bond') and (M_SE_MQUO = 0 ) and (M_SE_MDRNMOD = 1 ) then 'After amortizing'
    		when (M_SE_GROUP='Bond') and (M_SE_MQUO = 0 ) and (M_SE_MDRNMOD = 2 ) then 'Before amortizing' 
	else ' ' end as MainDirtyRoundingMode, 
-------
	case	when (M_SE_GROUP='Bond') and (M_SE_SQUO = 0 ) then 'Price'
		when (M_SE_GROUP='Bond') and (M_SE_SQUO = 1 ) then 'Percentage'
		when (M_SE_GROUP='Bond') and (M_SE_SQUO = 2 ) then 'Yield'
		when (M_SE_GROUP='Bond') and (M_SE_SQUO = 4 ) then '100-X'
		when (M_SE_GROUP='Bond') and (M_SE_SQUO = 5 ) then 'X'
		else ' '
	end as SecondaryQuotation,
	case	when (M_SE_GROUP='Bond') and (M_SE_SQUO = 2 ) and (M_SE_SYT = 0 ) then 'C.freq' 
		when (M_SE_GROUP='Bond') and (M_SE_SQUO = 2 ) and (M_SE_SYT = 1 ) then 'Annual' 
		when (M_SE_GROUP='Bond') and (M_SE_SQUO = 2 ) and (M_SE_SYT = 2 ) then 'Simple' 
	else ' '	end  as SecondaryYieldT,
	case	when (M_SE_GROUP='Bond') and (M_SE_SNOT = 0 ) then 'Std'
		when (M_SE_GROUP='Bond') and (M_SE_SNOT = 1 ) then '8th'
		when (M_SE_GROUP='Bond') and (M_SE_SNOT = 2 ) then '16th'
		when (M_SE_GROUP='Bond') and (M_SE_SNOT = 3 ) then '32th'
		when (M_SE_GROUP='Bond') and (M_SE_SNOT = 4 ) then '64th'
		when (M_SE_GROUP='Bond') and (M_SE_SNOT = 5 ) then '128th'
		when (M_SE_GROUP='Bond') and (M_SE_SNOT = 6 ) then '256th'
		when (M_SE_GROUP='Bond') and (M_SE_SNOT= 131 ) then '32sp'
               when (M_SE_GROUP='Bond') and (M_SE_SNOT= 9 ) then '32tr'
               when (M_SE_GROUP='Bond') and (M_SE_SNOT= 16 ) then '32tr.4'
		else ' 'end as SecondaryNotation, 
	M_SE_SDEC as SecondaryDecimals,
	case	when (M_SE_GROUP='Bond') and (M_SE_SROUND = 0) then 'None'
		when (M_SE_GROUP='Bond') and (M_SE_SROUND = 1) then 'Nearest'
		when (M_SE_GROUP='Bond') and (M_SE_SROUND = 2) then 'By default'
		when (M_SE_GROUP='Bond') and (M_SE_SROUND = 3) then 'By excess'
	else ' ' end   as SecondaryRounding,
	case	when (M_SE_GROUP='Bond') and (M_SE_SQUO = 0 ) and (M_SE_SPT = 0) then 'Clean'
		when (M_SE_GROUP='Bond') and (M_SE_SQUO = 0 ) and (M_SE_SPT = 1) then 'Dirty'
		when (M_SE_GROUP='Bond') and (M_SE_SQUO = 0 ) and (M_SE_SPT = 2) then 'Dirty Short Cpn'
                when (M_SE_GROUP='Bond') and (M_SE_SQUO = 0 ) and (M_SE_SPT = 3) then 'Clean Full'
	else ' ' end  as SecondaryPriceT, 
	case	when (M_SE_GROUP='Bond') and (M_SE_SQUO = 0 ) and (M_SE_SRNDMOD = 0 ) then 'Standard' 
 		when (M_SE_GROUP='Bond') and (M_SE_SQUO = 0 ) and (M_SE_SRNDMOD = 1 ) then 'Clean'
    		when (M_SE_GROUP='Bond') and (M_SE_SQUO = 0 ) and (M_SE_SRNDMOD = 2 ) then 'Dirty' 
                when (M_SE_GROUP='Bond') and (M_SE_SQUO = 0 ) and (M_SE_SRNDMOD = 3) then 'None' 
	else ' ' end as SecondaryCleanRoundingMode, 
        case	 when (M_SE_GROUP='Bond') and (M_SE_SQUO = 0 ) and  (M_SE_SDRNMOD = 0 ) then 'None'
	 	when (M_SE_GROUP='Bond') and (M_SE_SQUO = 0 ) and (M_SE_SDRNMOD = 1) then 'After amortizing'
 	   	when (M_SE_GROUP='Bond') and (M_SE_SQUO = 0 ) and (M_SE_SDRNMOD = 2) then 'Before amortizing' 
	else ' ' end as SecondaryDirtyRoundingMode, 
        case when (M_SE_GROUP='Bond') and (M_SE_CFRRUL =0) then 'None' 
		when (M_SE_GROUP='Bond') and (M_SE_CFRRUL =1) then 'Nearest' 
		when (M_SE_GROUP='Bond') and (M_SE_CFRRUL =2) then 'By default' 
		when (M_SE_GROUP='Bond') and (M_SE_CFRRUL =3) then 'By excess' 
	else ' ' end as CapitalFactorRoundingRule, 
	case when (M_SE_GROUP='Bond') and (M_SE_CFRMOD = 0) then 'After indexation'
		when (M_SE_GROUP='Bond') and (M_SE_CFRMOD = 1) then 'Before indexation'  else ' ' end as CapitalFactorMode, 
	M_SE_CFRDEC as CapitalFactorDecimals,
        case when (M_SE_GROUP='Bond') and (M_SE_FORM_F = 0) then '1.00'
                 when (M_SE_GROUP='Bond') and (M_SE_FORM_F = 1) then '0.01'
        else ' ' end as FormFactor
-------
from SE_TRDQ_DBF
where M_SE_TCQ_T='TRDCL'
and M_SE_TCQ_L <> ' '
order by M_SE_TCQ_L;
quit;
SPOOL OFF;