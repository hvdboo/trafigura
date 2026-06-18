set colsep '#';
SET TERMOUT OFF;
SPOOL &1;
set linesize 2910;
set pagesize 2048;
select  
	T1.M_IND_LAB as InterestRateIndex, 
	case	 when (T1.M_CATEGORY  = 0 ) then 'Rate' end as Category,
	T1.M_IND_DESC as Description, T1.M_IND_CODE as Code, 
	case 	when (T1.M_RESET = 0) then 'Published index'
	 	when (T1.M_RESET = 2) then 'Compounded'
		when (T1.M_RESET = 3) then 'Average'
		when (T1.M_RESET = 4) then 'Basket'
		when (T1.M_RESET = 5) then 'Start-end'
		when (T1.M_RESET = 6) then 'Nearby'
	end as Formula,
	T2.M_GRP_DESC as ArchivingGroup, 
	case	 when (T1.M_RESET <> 0) and (T1.M_ESTIM_MODE=0) then 'Current Index'
		 when (T1.M_RESET <> 0) and (T1.M_ESTIM_MODE =1) then 'Underlying Indices' 
		else ' ' end as EstimationMode, 
		case	when (T1.M_OFF_RESET = 0) then 'UNCHECKED' when (T1.M_OFF_RESET =1) then 'CHECKED' end as OfficialReset,
	case 	when (T1.M_FLEX = 0 ) then 'UNCHECKED' when (T1.M_FLEX = 1) then 'CHECKED' end as Flex ,
	case	when (T1.M_RAT_NAT = 0) then 'Standard Rate'  when (T1.M_RAT_NAT = 1) then 'Swap rate' end as Nature, 
	case	when (T3.M_INSTR is null) then ' ' else T3.M_INSTR  end as SwapGenerator  , 
	CAST(T1.M_MAT_LAB AS VARCHAR2(25))  as SwapGeneratorMaturity, 
	T1.M_CURRENCY as Currency, 
	T1.M_START as StartDelay, 
	case 	when (T1.M_ECP_TYPE = 0) then 'Driving schedule' 
		when (T1.M_ECP_TYPE = 1) then 'Equal to'
		when  (T1.M_ECP_TYPE = 2) then 'Deduced from'
	end as CalcStartSched1, 
	case 	when (T1.M_ECP_TYPE = 0) then ' ' 
		when (T1.M_ECP_UNDRL= 0) then 'Payment schedule'
		when (T1.M_ECP_UNDRL= 2) then 'Fixing schedule'
		when (T1.M_ECP_UNDRL= 7) then 'Calculation end schedule'
		when (T1.M_ECP_UNDRL = 8) then 'Delivery schedule'
	end as CalcStartSched2, 
	T1.M_ECP as CalcStartSched3,
	case	when (T1.M_ECPE_TYPE = 0) then 'Driving schedule' 
		when (T1.M_ECPE_TYPE = 1) then 'Equal to'
		when (T1.M_ECPE_TYPE = 2) then 'Deduced from'
	end as CalcEndSched1, 
	case 	when (T1.M_ECPE_UNDR = -1) then ' ' 
		when (T1.M_ECPE_UNDR = 0) then 'Payment schedule'
		when (T1.M_ECPE_UNDR = 1) then 'Calculation start schedule'
		when (T1.M_ECPE_UNDR= 2) then 'Fixing schedule'
		when (T1.M_ECPE_UNDR = 8) then 'Delivery schedule'
	end as CalcEndSched2, 
	T1.M_ECPE as CalcEndSched3, 
	case 	when (T1.M_EP_TYPE = 0) then 'Driving schedule' 
		when (T1.M_EP_TYPE = 1) then 'Equal to'
		when  (T1.M_EP_TYPE = 2) then 'Deduced from'
	end as PaymentSched1, 
	case 	when (T1.M_EP_UNDRL = -1) then ' ' 
		when (T1.M_EP_UNDRL = 1) then 'Calculation start schedule'
		when (T1.M_EP_UNDRL= 7) then 'Calculation end schedule'
		when (T1.M_EP_UNDRL = 8) then 'Delivery schedule'
	end as PaymentSched2,
	T1.M_EP as PaymentSched3,
	case 	when (T1.M_EI_TYPE = 0) then 'Driving schedule' 
		when (T1.M_EI_TYPE = 1) then 'Equal to'
		when  (T1.M_EI_TYPE = 2) then 'Deduced from'
	end as FixingSched1, 
	case 	when (T1.M_EI_UNDRL = -1) then ' ' 
		when (T1.M_EI_UNDRL = 0) then 'Payment schedule'
		when (T1.M_EI_UNDRL = 1) then 'Calculation start schedule'
		when (T1.M_EI_UNDRL= 7) then 'Calculation end schedule'
		when (T1.M_EI_UNDRL = 8) then 'Delivery schedule'
	end as FixingSched2,
	T1.M_EI as FixingSched3,
	T1.M_RATE_CONV as RateConv, 
	case	when  (T1.M_ROUND_RUL =0 ) then 'None' when  (T1.M_ROUND_RUL =1) then 'Nearest'  
		when (T1.M_ROUND_RUL =2)  then 'By default'  when (T1.M_ROUND_RUL =3 ) then 'By excess' 
		when (T1.M_ROUND_RUL =5) then 'Nearest 5th' when (T1.M_ROUND_RUL =6)  then 'By excess 5th' 
		when (T1.M_ROUND_RUL=7 ) then 'By default 5th' else ' ' end  as IndexRndgRule,
	T1.M_DECIMALS as IndexRndgDec, 
	case	 when (T1.M_CONTANGO = 0) then 'UNCHEKED' else 'CHECKED' end as Contango, 
        case    when (T1.M_CONTANGO = 1) then T1.M_CURRENCY  else ' ' end as NumeratorCurr,
-------
        case    when (T1.M_CONTANGO = 1) then T1.M_DEN_CURR  else ' ' end as DenominatorCurr,
-------
-------
        case when (T1.M_RESET = 2) then to_char(T1.M_URAT_CONV) else ' ' end as ImpliedRateConv,
        case 	when  ((T1.M_RESET in (2,3,5))  or ((T1.M_RESET =4) and (T1.M_AVG_UND = 1)))  and (T1.M_CRND_RULE =0 ) then 'None' 
                       when  ((T1.M_RESET in (2,3,5))  or ((T1.M_RESET =4) and (T1.M_AVG_UND = 1)))  and (T1.M_CRND_RULE =1) then 'Nearest'  
		      when ((T1.M_RESET in (2,3,5))  or ((T1.M_RESET =4) and (T1.M_AVG_UND = 1)))  and (T1.M_CRND_RULE =2) then 'By default' 
                     when ((T1.M_RESET in (2,3,5))  or ((T1.M_RESET =4) and (T1.M_AVG_UND = 1)))  and (T1.M_CRND_RULE =3) then 'By excess' 
	else ' ' end  as ComputedRndgRule,
	case when  ((T1.M_RESET in (2,3,5))  or ((T1.M_RESET =4) and (T1.M_AVG_UND = 1)))  and (T1.M_CRND_RULE <>0) then to_char(T1.M_CRND_DEC) else ' ' end as ComputedRndgDec,
        case when ((T1.M_RESET in (2,3,5)) or ((T1.M_RESET =4) and (T1.M_AVG_UND = 1)))   then to_char(T4.M_IND_LAB)  else ' 'end as UnderlyingIndex, 
        case when (T1.M_RESET in (2,3)) or ((T1.M_RESET =4) and (T1.M_AVG_UND = 1))  then to_char(T1.M_UEI) else ' ' end as FixingSched,
        case when (T1.M_RESET = 2)   then to_char(T1.M_UECF) else ' ' end as CmpdngSched, 
        case when  (T1.M_RESET = 2)  then to_char(T1.M_URAT_CONV) else ' ' end as UnderlyingRateConv,
        case 	when (T1.M_RESET = 2)  and (T1.M_FIXING = 0 ) then 'In advance'
		when (T1.M_RESET = 2)  and  (T1.M_FIXING = 1 ) then 'In arrears' else ' ' end as Fixing ,
        case when ((T1.M_RESET = 4) and (T1.M_BSK_MODE = 0)) then 'Weighted average'  
                 when ((T1.M_RESET = 4) and (T1.M_BSK_MODE = 1)) then 'Sum'  
                 when ((T1.M_RESET = 4) and (T1.M_BSK_MODE = 2)) then 'Multiplication'
                 when ((T1.M_RESET = 4) and (T1.M_BSK_MODE = 3)) then 'Max'
                 when ((T1.M_RESET = 4) and (T1.M_BSK_MODE = 4)) then 'Min'
                 when ((T1.M_RESET = 4) and (T1.M_BSK_MODE = 5)) then 'Ratio'
                 when ((T1.M_RESET = 4) and (T1.M_BSK_MODE = 6)) then 'Inverse'
                 when ((T1.M_RESET = 4) and (T1.M_BSK_MODE = 7)) then 'User Defined'
                  else ' '  end as BskFormulaType,
       case when  ((T1.M_RESET = 4) and (T1.M_BSK_MODE = 7)) then T6.M_BUFFER else ' ' end as BskFormulaDetails,
        case when (T1.M_RESET = 4) and (T1.M_CRND_RULE = 0) then 'None'
	        when (T1.M_RESET = 4)  and T1.M_CRND_RULE = 1 then 'Nearest'
	        when (T1.M_RESET = 4)  and T1.M_CRND_RULE = 2 then 'By default'
	        when (T1.M_RESET = 4)  and T1.M_CRND_RULE = 3 then 'By excess'
        else ' 'end as BskRoundingRule,
case when (T1.M_RESET = 4)  and T1.M_CRND_RULE <> 0  then to_char(T1.M_CRND_DEC) else ' ' end as BskRdgRuleDecimals,
case    when (T1.M_RESET = 4)  and (T1.M_CONVERT = 0) then 'No'
                when (T1.M_RESET = 4)  and (T1.M_CONVERT = 1) then 'Yes' else ' ' end as BskRateConversion,
        case    when (T1.M_RESET = 4)  and  (T1.M_CONVERT = 1) then T1.M_CAP_FACT else ' ' end as BskConvertFrom,
        case    when (T1.M_RESET = 4)  and (T1.M_CONVERT = 1) then T1.M_IMP_RATE else ' ' end as BskConvertTo, 
       case    when ((T1.M_RESET = 4)  and (T1.M_CONVERT = 1) and ( T1.M_CVRT_PER = -20)) then 'Interest calculation period'
                 when ((T1.M_RESET = 4)  and (T1.M_CONVERT = 1) and (T1.M_CVRT_PER = -22)) then 'Total interest period'
                 when (T1.M_RESET = 4)  and (T1.M_CVRT_PER <>0) then to_char(T1.M_CVRT_PER) else ' ' end as BskConversionPeriod, 
        case    when ((T1.M_RESET = 4)  and (T1.M_CONVERT = 1) and (T1.M_RCRND_RL = 0)) then 'None'
                when ((T1.M_RESET = 4)  and (T1.M_CONVERT = 1) and (T1.M_RCRND_RL = 1)) then 'Nearest'
                when ((T1.M_RESET = 4)  and (T1.M_CONVERT = 1) and (T1.M_RCRND_RL = 2)) then 'By default'
                when ((T1.M_RESET = 4)  and (T1.M_CONVERT = 1) and (T1.M_RCRND_RL = 3)) then 'By excess'
                when ((T1.M_RESET = 4)  and (T1.M_CONVERT = 1) and (T1.M_RCRND_RL = 5)) then 'Nearest 5th'
                when ((T1.M_RESET = 4)  and (T1.M_CONVERT = 1) and (T1.M_RCRND_RL = 6)) then 'By excess 5th'
                when ((T1.M_RESET = 4)  and (T1.M_CONVERT = 1) and (T1.M_RCRND_RL = 7)) then 'By default 5th' else ' ' end as BskRateConvRndgRule,
         case when (T1.M_RESET = 4)  then to_char(T1.M_RC_DEC) else ' ' end as BskRateConvDec,
         case when (T1.M_RESET = 4)   and (T1.M_AVG_UND = 1) then 'Yes' 
                 when (T1.M_RESET = 4)   and (T1.M_AVG_UND = 0) then 'No' 
                  else ' ' end as BskAveragedComponents,
case when ((T1.M_RESET = 3) or ((T1.M_RESET =4) and (T1.M_AVG_UND = 1))) and (T1.M_MEAN_TYPE = 0 ) then 'Simple'
             when ((T1.M_RESET = 3) or ((T1.M_RESET =4) and (T1.M_AVG_UND = 1)))  and (T1.M_MEAN_TYPE = 1 ) then 'Built on a weighting schedule'
             when ((T1.M_RESET = 3) or ((T1.M_RESET =4) and (T1.M_AVG_UND = 1)))  and (T1.M_MEAN_TYPE = 2 ) then 'Manually weighted'
             when ((T1.M_RESET = 3) or ((T1.M_RESET =4) and (T1.M_AVG_UND = 1)))  and (T1.M_MEAN_TYPE = 3 ) then 'Automatically weighted'
             when ((T1.M_RESET = 3) or ((T1.M_RESET =4) and (T1.M_AVG_UND = 1)))  and (T1.M_MEAN_TYPE = 4 ) then 'Sum'
             when ((T1.M_RESET = 3) or ((T1.M_RESET =4) and (T1.M_AVG_UND = 1)))  and (T1.M_MEAN_TYPE = 5 ) then 'Min'
             when ((T1.M_RESET = 3) or ((T1.M_RESET =4) and (T1.M_AVG_UND = 1)))  and (T1.M_MEAN_TYPE = 6 ) then 'Max' 
             else ' ' end as MeanType,
case    when ((T1.M_RESET in (2,3,5))  or ((T1.M_RESET =4) and (T1.M_AVG_UND = 1)))  and (T1.M_F_SHIFT = 0) then 'No'
                when  ((T1.M_RESET in (2,3,5))  or ((T1.M_RESET =4) and (T1.M_AVG_UND = 1)))  and (T1.M_F_SHIFT = 1) then 'Yes'  else ' ' end as ShiftFirstDate,
        case    when ((T1.M_F_SHIFT = 1) and ((T1.M_RESET in (2,3,5))  or ((T1.M_RESET =4) and (T1.M_AVG_UND = 1)))  and (T1.M_U_LSHIFT = 0)) then 'First'
                when ((T1.M_F_SHIFT = 1) and (((T1.M_RESET in (2,3,5))  or ((T1.M_RESET =4)) and (T1.M_AVG_UND = 1)))  and  (T1.M_U_LSHIFT = 1)) then 'Last' else ' ' end as Choice,
        case when  ((T1.M_RESET in (2,3,5))  or ((T1.M_RESET =4) and (T1.M_AVG_UND = 1)))  and (T1.M_F_SHIFT = 1) then T1.M_F_SHIFTER  else ' ' end as FirstShifter,
        case    when ((T1.M_RESET in (2,3,5))  or ((T1.M_RESET =4) and (T1.M_AVG_UND = 1)))  and T1.M_L_SHIFT = 0 then 'No'
                when ((T1.M_RESET in (2,3,5))  or ((T1.M_RESET =4) and (T1.M_AVG_UND = 1)))  and (T1.M_L_SHIFT = 1) then 'Yes' else ' ' end as ShiftLastDate,
        case    when (T1.M_L_SHIFT = 1) and ((T1.M_RESET in (2,3,5))  or ((T1.M_RESET =4) and (T1.M_AVG_UND = 1)))    and  (T1.M_U_FSHIFT = 0) then 'First'
                when ((T1.M_L_SHIFT = 1) and ((T1.M_RESET in (2,3,5))  or ((T1.M_RESET =4) and (T1.M_AVG_UND = 1)))    and (T1.M_U_FSHIFT = 1)) then 'Last' else ' ' end as Choice2,
        case when (T1.M_L_SHIFT = 1)  and ((T1.M_RESET in (2,3,5))  or ((T1.M_RESET =4) and (T1.M_AVG_UND = 1)))    then to_char(T1. M_L_SHIFTER) else ' ' end as LastShifter,
	-------
	case 	when  ((T1.M_RESET = 3)  or ((T1.M_RESET =4) and (T1.M_AVG_UND = 1)))   and (T1.M_FIRST_EXCL = 0) then 'Included'
                      when (T1.M_RESET = 3)    or ((T1.M_RESET =4) and (T1.M_AVG_UND = 1))   and (T1.M_FIRST_EXCL = 1) then 'Excluded'  else ' 'end as FirstExcluded,
	case 	when (T1.M_RESET = 3)  or ((T1.M_RESET =4) and (T1.M_AVG_UND = 1))   and ( T1.M_LAST_EXCL = 0) then 'Included' 
                       when (T1.M_RESET = 3)    or ((T1.M_RESET =4) and (T1.M_AVG_UND = 1))  and (T1.M_LAST_EXCL = 1 ) then 'Excluded'  else ' ' end as LastExcluded, 
	case 	when ((T1.M_RESET =3)  or ((T1.M_RESET =4) and (T1.M_AVG_UND = 1)))  and (T1.M_BROKEN = 0) then 'Up front' 
		        when  ((T1.M_RESET =3)  or ((T1.M_RESET =4) and (T1.M_AVG_UND = 1)))  and (T1.M_BROKEN = 1) then 'In arrears' else ' ' end as StubPeriod ,
        case    when ((T1.M_RESET =3)  or ((T1.M_RESET =4) and (T1.M_AVG_UND = 1)))  and (T1.M_CONVERT = 0) then 'No'
                when ((T1.M_RESET in (3,5))  or ((T1.M_RESET =4) and (T1.M_AVG_UND = 1)))  and (T1.M_CONVERT = 1) then 'Yes' else ' ' end as RateConversion,
        case    when ((T1.M_RESET in (3,5))  or ((T1.M_RESET =4) and (T1.M_AVG_UND = 1)))  and  (T1.M_CONVERT = 1) then T1.M_CAP_FACT else ' ' end as ConvertFrom,
        case    when ((T1.M_RESET in(3,5))  or ((T1.M_RESET =4) and (T1.M_AVG_UND = 1)))  and (T1.M_CONVERT = 1) then T1.M_IMP_RATE else ' ' end as ConvertTo, 
       case    when ((T1.M_RESET in (3,5))  or ((T1.M_RESET =4) and (T1.M_AVG_UND = 1)))  and (T1.M_CONVERT = 1) and ( T1.M_CVRT_PER = -20) then 'Interest calculation period'
                 when ((T1.M_RESET in (3,5))  or ((T1.M_RESET =4) and (T1.M_AVG_UND = 1)))  and (T1.M_CONVERT = 1) and (T1.M_CVRT_PER = -22) then 'Total interest period'
				when((T1.M_RESET in (3,5))  or ((T1.M_RESET =4) and (T1.M_AVG_UND = 1)))  and (T1.M_CVRT_PER <>0) then to_char(T1.M_CVRT_PER) else ' ' end as ConversionPeriod, 
-------
        case    when ((T1.M_RESET in (3,5))  or ((T1.M_RESET =4) and (T1.M_AVG_UND = 1)))  and (T1.M_CONVERT = 1) and (T1.M_RCRND_RL = 0) then 'None'
                when ((T1.M_RESET in (3,5))  or ((T1.M_RESET =4) and (T1.M_AVG_UND = 1)))    and (T1.M_CONVERT = 1) and (T1.M_RCRND_RL = 1) then 'Nearest'
                when ((T1.M_RESET in (3,5))  or ((T1.M_RESET =4) and (T1.M_AVG_UND = 1)))   and (T1.M_CONVERT = 1) and (T1.M_RCRND_RL = 2) then 'By default'
                when ((T1.M_RESET in (3,5))  or ((T1.M_RESET =4) and (T1.M_AVG_UND = 1)))    and (T1.M_CONVERT = 1) and (T1.M_RCRND_RL = 3) then 'By excess'
                when ((T1.M_RESET in (3,5))  or ((T1.M_RESET =4) and (T1.M_AVG_UND = 1)))    and (T1.M_CONVERT = 1) and (T1.M_RCRND_RL = 5) then 'Nearest 5th'
                when ((T1.M_RESET in (3,5))  or ((T1.M_RESET =4) and (T1.M_AVG_UND = 1)))   and (T1.M_CONVERT = 1) and (T1.M_RCRND_RL = 6) then 'By excess 5th'
                when ((T1.M_RESET in (3,5))  or ((T1.M_RESET =4) and (T1.M_AVG_UND = 1)))    and (T1.M_CONVERT = 1) and (T1.M_RCRND_RL = 7) then 'By default 5th' else ' ' end as RateConvRndgRule,
         case when ((T1.M_RESET in (3,5))  or ((T1.M_RESET =4) and (T1.M_AVG_UND = 1)))    then to_char(T1.M_RC_DEC) else ' ' end as RateConvDec,
        case when ((T1.M_RESET in (2,3))  or ((T1.M_RESET =4) and (T1.M_AVG_UND = 1)))    and (T1.M_LOK_PER = 0) then 'No'
                when ((T1.M_RESET in (2,3))  or ((T1.M_RESET =4) and (T1.M_AVG_UND = 1)))    and (T1.M_LOK_PER = 1) then 'Yes' else ' ' end as LockoutPeriod,
        case when ((T1.M_RESET in (2,3))  or ((T1.M_RESET =4) and (T1.M_AVG_UND = 1)))    and (T1.M_LOK_PER = 1) then T1.M_LOK_PER_SH else ' ' end as LockoutPeriodShift,
	case	 when ((T1.M_RESET =3)  or ((T1.M_RESET =4) and (T1.M_AVG_UND = 1))) and  (T1.M_EXCLUDE = 0) then 'No' when (T1.M_EXCLUDE = 1) then 'Yes'  else ' ' end as ExcludeDates, 
        case    when ((T1.M_RESET =3)  or ((T1.M_RESET =4) and (T1.M_AVG_UND = 1))) and (T1.M_EXCLUDE = 1) and (T1.M_EXCL_STYLE = 0) then 'InheritedFromUnderlyg'
                when ((T1.M_RESET =3)  or ((T1.M_RESET =4) and (T1.M_AVG_UND = 1))) and (T1.M_EXCLUDE = 1) and (T1.M_EXCL_STYLE = 1) then 'Specific' else ' ' end as ExcludeDatesStyle,
        case    when ((T1.M_RESET =3)  or ((T1.M_RESET =4) and (T1.M_AVG_UND = 1)) )and (T1.M_EXCLUDE = 1) then  T1.M_EXCL_GEN else ' ' end as ExcludedDatesGenerator, 
        case    when (T1.M_RESET =3) and (T1.M_INTRPL = 0) then 'No'
                    when (T1.M_RESET =3) and (T1.M_INTRPL = 1) then 'Yes'
                    else ' ' end as ConvAdjustment,
        case    when ((T1.M_RESET =3)  or ((T1.M_RESET =4) and (T1.M_AVG_UND = 1))) and (T1.M_CONVERT = 1) and (T1.M_CNV_APPL = 0 )  then 'Underlying'
                   when ((T1.M_RESET =3)  or ((T1.M_RESET =4) and (T1.M_AVG_UND = 1))) and (T1.M_CONVERT = 1) and (T1.M_CNV_APPL = 1 )  then 'Mean'  else ' ' end as ConvApp,
        case when (T1.M_RESET=4) then   to_char(T7.M_ORDER) else ' ' end as BskComponentOrder,
          case when (T1.M_RESET=4) then   to_char(T8.M_IND_LAB) else ' '  end as BskElement,             
         case when  (T1.M_RESET=4) and M_FORMULA =' ' then 'Inherited' 
                  when (T1.M_RESET=4)  and M_FORMULA <> ' ' then 'FIXING'
                else ' ' end as BskFormula,
         case when (T1.M_RESET=4) then to_char(T7.M_WEIGHT) else ' ' end as Weight, 
         case when (T1.M_RESET=4) then to_char(T7.M_SPREAD) else ' ' end as Spread, 
        case when (T1.M_RESET=4) then to_char(T7.M_POWER) else ' ' end as Power, 
        case when T7.M_EXCLUDE_DATES= '1' then 'Yes'  when T7.M_EXCLUDE_DATES= '0' then 'No' else ' ' end as BskExcludeDates,
        case  when (T1.M_RESET=5) and (T1.M_MEAN_TYPE=0) then 'Ratio'
                 when (T1.M_RESET=5) and (T1.M_MEAN_TYPE=1) then 'Return'
                  when (T1.M_RESET=5) and (T1.M_MEAN_TYPE=2) then 'Implied ratio'
                 when (T1.M_RESET=5) and (T1.M_MEAN_TYPE=3) then 'Max'
                  when (T1.M_RESET=5) and (T1.M_MEAN_TYPE=4) then 'Min'
                  when (T1.M_RESET=5) and (T1.M_MEAN_TYPE=5) then 'Initial ratio'
                 when (T1.M_RESET=5) and (T1.M_MEAN_TYPE=6) then 'Initial return'
                 when (T1.M_RESET=5) and (T1.M_MEAN_TYPE=7) then 'Spread'
                 when (T1.M_RESET=5) and (T1.M_MEAN_TYPE=8) then 'Abs Spread'
                 else ' '  end as StartEndType
-------
from  RT_GROUP_DBF T2 , RT_INDEX_DBF T1
-------
left outer join RT_INSGN_DBF T3 on T1.M_GEN_NUM=T3.M_GEN_NUM
left outer join RT_INDEX_DBF T4 on T1.M_UNDRL= T4.M_INDEX
left outer join FRM_FILE_DBF T6 on T1.M_IND_FORMID = T6.M_GROUP
left outer join  RT_INDBK_COMPONENT_DBF T7 on T7.M_BASKET_REFERENCE=T1.M_REFERENCE
left outer join RT_INDEX_DBF T8 on T7.M_INDEX=T8.M_INDEX 
-------
where		T1.M_CATEGORY=0
and 		T1.M_HISFILE=T2.M_HISFILE
and 		T1.M_CREAT_MODE = 0
order by T1.M_IND_LAB, T8.M_IND_LAB;
-------
quit;
SPOOL OFF;