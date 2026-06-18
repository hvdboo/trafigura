set colsep '#';
SET TERMOUT OFF;
SPOOL &1;
set linesize 4500;
set pagesize 2048;
select  T1.M_INSTR as StockLoanTemplate,
	T1.M_INSTR_DESC as Description,
	M_START0 as StartDelay,
	case when (T1.M_EVAL_MODE = 0) then 'Default'
		 when (T1.M_EVAL_MODE = 1) then 'MTM'
		 when (T1.M_EVAL_MODE = 2) then 'Accrual'
		when (T1.M_EVAL_MODE = 3) then 'Repo rates'
		end as EvaluationMode,
	case when (M_INIT_CAP0 = 2) then 'No'
		else 'Yes' end as SecurityExchange,
	case when ((MOD(T2.M_LNGN_FLGS0,  2 ) < 2) and ( MOD(T2.M_LNGN_FLGS0, 4) >=2)) then 'Yes' else 'No' end as Performance,
-----
	case when (T1.M_EVAL_MODE = 2 and T1.M_ACC_MOD=0) then '+1 open day'
		when (T1.M_EVAL_MODE = 2 and T1.M_ACC_MOD=1) then 'Redefined'
		else ' ' end as AccrualDelay,
	case when (T1.M_EVAL_MODE = 2 and T1.M_ACC_MOD=1) then T1.M_ACC
		else ' ' end as AccrualDelayShift,
	case when (T1.M_EVAL_MODE = 2 and T1.M_FLP_MOD=0) then '+1 open day'
		when (T1.M_EVAL_MODE = 2 and T1.M_FLP_MOD=1) then 'Redefined'
		else ' ' end as FlowProjDelay,
	case when (T1.M_EVAL_MODE = 2 and T1.M_FLP_MOD=1) then T1.M_FLP
		else ' ' end as FlowProjDelayShift,
	case when ((MOD(T2.M_LNGN_FLGS0,  512 ) < 512) and (MOD( T2.M_LNGN_FLGS0 , 1024) >=512)) then 'On deal level' else 'On pool level' end as TreatCollateral,
	case when ((MOD(T1.M_FLAGS,  256 ) < 256) and (MOD( T1.M_FLAGS, 512) >=256)) then 'No' else 'Yes' end as EarlySettlement,
	case when ((MOD(T1.M_FLAGS,  256 ) < 256) and (MOD( T1.M_FLAGS, 512) >=256)) then 'Inherited from currency' 
		else case when (T1.M_SETTL_MOD=0) then 'Inherited from currency'
				when (T1.M_SETTL_MOD=1) then 'Specific delay' end 
		end as SettlementDelay,
	case when ((MOD(T1.M_FLAGS,  256 ) < 256) and (MOD( T1.M_FLAGS, 512) >=256)) then ' '
		else case when (T1.M_SETTL_MOD=1) then T1.M_SETTL
			when (T1.M_SETTL_MOD=0) then ' ' end 
		end as SettlementDelayShfiter,
	case when ((MOD(T1.M_FLAGS,  2048 ) < 2048) and (MOD( T1.M_FLAGS, 4096) >=2048)) then 'Yes' else 'No' end as MultiCurrencyProp,
-----
	case when T7.TEMP_LEGTYPE is null then 'Collateral' else 'Fees' end as LegType,
	case when (T2.M_INIT_CAP1 = 2) then 'No'
		else 'Yes' end as CashExchange,
	case when ((MOD(T2.M_LNGN_FLGS1,  8 ) < 8) and (MOD( T2.M_LNGN_FLGS1, 16) >=8)) then 'Market to market' 
		when ((MOD(T2.M_LNGN_FLGS1,  8192 ) < 8192) and (MOD( T2.M_LNGN_FLGS1, 16384) >=8192)) then 'Independent amount'
		when ((MOD(T2.M_LNGN_FLGS1,  16777216 ) < 16777216) and (MOD( T2.M_LNGN_FLGS1, 33554432) >=16777216) and (MOD(T2.M_LNGN_FLGS1,  16384 ) < 16384) and (MOD( T2.M_LNGN_FLGS1, 32768) >=16384)) then 'Quantity' 
		else 'Based on initial price' end as FeesNominal,
	case when (T2.M_RATE_TYPE1  = 0) then 'Fixed rate' 
		when (T2.M_RATE_TYPE1= 1) then 'Floating rate' 
		end as RateType,
	T2.M_START1 as StartDelayFees,
	CAST(T2.M_PAY_CLN0 AS VARCHAR(16)) as PaymentCalendar,
	case when (T2.M_RATE_TYPE1= 1) then M_FIX_CLN1
		else ' ' end as FixingCalendar,
	case when (T2.M_EP_TYPE1 = 0) then 
		(case 	when (M_MRG_CMP1=0) then '(I+M) at (I+M)'
			when (M_MRG_CMP1=1) then '(I+M) at I'
			when (M_MRG_CMP1=2) then '(I at I) + M'
			when (M_MRG_CMP1=3) then 'I at (I+M)'			
			when (M_MRG_CMP1=4) then 'I at (I+M) + M'
			when (M_MRG_CMP1=5) then 'No compounding'
			when (M_MRG_CMP1=6) then '(I+M1) at (I+M2)'
			when (M_MRG_CMP1=8) then '(I+M) at C'
		end) else ' ' end as Compounding,
	case when ((T2.M_RATE_TYPE1= 1) and (T2.M_FIXING1 = 0 )) then 'Up front'
		when ((T2.M_RATE_TYPE1= 1) and (T2.M_FIXING1 = 1 )) then 'In arrears'
		else ' ' end  as Fixing,
	case when (T2.M_PAYMENT1 = 0) 	then 'In arrears' 
		when  (T2.M_PAYMENT1 = 1) then 'Up front'
		when (T2.M_PAYMENT1 = 2) then 'Up front disc.'
		end as Payment,
	T2.M_RATE_CONV1 as RatConvention,
	case when (T2.M_ROUND_RUL1 = 0) then 'None' 
		 when (T2.M_ROUND_RUL1 = 1) then 'Nearest' 
		 when (T2.M_ROUND_RUL1 = 2) then 'By default' 
		 when (T2.M_ROUND_RUL1 = 3) then 'By excess' 
		end as RoundingRule,
	case when (T2.M_ROUND_RUL1 = 0) then ' ' else to_char(T2.M_DECIMALS1) end as Decimals,
	case when (T2.M_AMORT0 = 0 ) then 'None'
		 when (T2.M_AMORT0 = 1 ) then 'Linear (rate)'
		 when (T2.M_AMORT0 = 2 ) then 'Constant'
		 when (T2.M_AMORT0 = 3 ) then 'Constant annuities' 
		 when (T2.M_AMORT0 = 4 ) then 'Constant number of shares'
		 when (T2.M_AMORT0 = 5 ) then 'Coupon reinvestment'
		 when (T2.M_AMORT0 = 6 ) then 'Constant annuities (r)' 
		 when (T2.M_AMORT0 = 7 ) then 'Linear (amount)' 
		 when (T2.M_AMORT0 = 8 ) then 'Dividends reinvestment (in new shares)'
		end as Amortizing,
	case when (T1.M_BROKEN =0 ) then 'Up front'
		 when (T1.M_BROKEN =1 ) then 'In arrears' 
		 when (T1.M_BROKEN=3 )  then 'Both ends (backward)'
		 when (T1.M_BROKEN = 5) then 'Both ends (forward)' 
		end as StubPosition,
-----
	case when (T2.M_BROK_COUP1= 0) then 'Short Coupon'
		when (T2.M_BROK_COUP1= 1) then 'Long Coupon'
		when (T2.M_BROK_COUP1= 3) then 'Full Coupon'
		when (T2.M_BROK_COUP1= 4) then 'Conditional'
		end as Coupon,
	case when (T2.M_BROK_COUP1= 4) then T2.M_BROK_COND1
		else ' ' end as StubCondition,
-----
	case when (T2.M_CONVERT1 =0) then 'No'
		when (T2.M_CONVERT1 =1) then 'Yes'
		end as RateConversion,	
	case when (M_INDEXED1 =0) then 'No'
		when (M_INDEXED1 =1) then 'Yes'
		end as Indexed,
	case when ((MOD(T2.M_LNGN_FLGS1,  32 ) < 32) and (MOD( T2.M_LNGN_FLGS1, 64) >=32)) then 'Clean Price' else 'Dirty Price' 
		end as FeesBasedOn,	
	case when ((MOD(T2.M_LNGN_FLGS1,  8 ) < 8) and (MOD( T2.M_LNGN_FLGS1, 16) >=8)) then  
		case when ((MOD(T2.M_LNGN_FLGS1, 536870912 ) < 536870912) and (MOD(T2.M_LNGN_FLGS1, 1073741824) >=536870912)) then 'Floating indexation' 
			when ((MOD(T2.M_LNGN_FLGS1, 536870912 ) < 536870912) and (MOD( T2.M_LNGN_FLGS1, 1073741824) >=536870912) and (MOD(T2.M_LNGN_FLGS1, 268435456 ) < 268435456) and (MOD(T2.M_LNGN_FLGS1, 536870912) >=268435456)) then 'Formula'
			else 'Fixed Indexation' end 
	else ' ' end as MultiCurrIndex,
	case when ((MOD(T2.M_LNGN_FLGS0,  131072 ) < 131072) and (MOD( T2.M_LNGN_FLGS0, 262144) >=131072)) then 'Paid on termination date' else 'Paid on scheduled date' end as DivTaxRule,
	M_DIV_PFRAC0 as DivPayFrac,
	M_DIV_RFRAC0 as DivReinvFrac,
	case when (T2.M_DIV_RULE0 = 0) then 'with payment dates within period'
		when (T2.M_DIV_RULE0 = 1) then 'with ex-dividend dates within period'
		when (T2.M_DIV_RULE0 = 4) then 'with record dates within period'
		else ' ' end as OnlyDividends,
	case when (T2.M_DIV_SCHED0 = 0) then 'on interest payment date'
		when (T2.M_DIV_SCHED0 = 1) then 'on dividend payment date'
		when (T2.M_DIV_SCHED0 = 3) then 'deduced from dividend payment date'
		when (T2.M_DIV_SCHED0 = 4) then 'deduced from ex-dividend date'
		when (T2.M_DIV_SCHED0 = 7) then 'Specific schedule (payment date matching)'
		when (T2.M_DIV_SCHED0 = 8) then 'at maturity'
		when (T2.M_DIV_SCHED0 = 9) then 'on dividend payment period'
		end as DivPayment,
	case when (T2.M_DIV_SCHED0 in (3,4,7)) then T2.M_DIV_SHIFT0
		else ' ' end as PaymentGenerator,
	case when (T2.M_DIV_PCR0 = 0) then 
		case when ((MOD(T2.M_LNGN_FLGS0,  2 ) < 2) and (MOD( T2.M_LNGN_FLGS0, 4) >=2)) then 'Payment currency' else 'Security currency' end 
		when (T2.M_DIV_PCR0 = 3) then 'Fees currency'
		when (T2.M_DIV_PCR0 = 1) then 'Own currency'
		when (T2.M_DIV_PCR0 = 2) then 'Other currency'
	end as DivPayCurrency,
	case when (T2.M_DIV_PCR0 = 2) then T2.M_DIV_PCRL0
		else ' ' end as DivOtherCurrency,
	case when (T2.M_DISC_RATE0 = 0) then 'No'
		when (T2.M_DISC_RATE0 = 4) then 'Yes'
		end as CapitalizedDiv,
	T2.M_TC_PFRAC0 as TaxPayFrac,
	T2.M_TC_RFRAC0 as TaxReinvFrac,
	case when (T2.M_TC_RULE0 = 0) then 'with payment dates within period'
		when (T2.M_TC_RULE0 = 1) then 'with ex-dividend dates within period'
		when (T2.M_TC_RULE0 = 2) then 'tax credit payment dates within period'
		when (T2.M_TC_RULE0 = 3) then 'tax credit ex-div. dates within period'
		when (T2.M_TC_RULE0 = 4) then 'on interest payment date'
		end as TaxRelated,
	case when (T2.M_TC_SCHED0= 0) then 'on interest payment date'
		when (T2.M_TC_SCHED0= 1) then 'on dividend payment date'
		when (T2.M_TC_SCHED0= 2) then 'on tax credit payment date'
		when (T2.M_TC_SCHED0= 3) then 'deduced from dividend payment date'
		when (T2.M_TC_SCHED0= 4) then 'deduced from ex-dividend date'
		when (T2.M_TC_SCHED0= 5) then 'deduced from tax credit payment date'
		when (T2.M_TC_SCHED0= 6) then 'deduced from tax credit ex-div. date'
		when (T2.M_TC_SCHED0= 7) then 'Specific schedule (payment date matching)'
		when (T2.M_TC_SCHED0= 8) then 'at maturity'
		when (T2.M_TC_SCHED0= 9) then 'on dividend payment period'
		end as TaxPayment,
	case when (T2.M_TC_SCHED0 in (3,4,5,6,7)) then T2.M_TC_SHIFT0
		else ' ' end as TaxGenerator,
	case when (T2.M_TC_PCR0 = 0) then 
		case when ((MOD(T2.M_LNGN_FLGS0, 2 ) < 2) and (MOD( T2.M_LNGN_FLGS0, 4) >=2)) then 'Payment currency' else 'Security currency' end 
		when (T2.M_TC_PCR0 = 3) then 'Fees currency'
		when (T2.M_TC_PCR0 = 1) then 'Own currency'
		when (T2.M_TC_PCR0 = 2) then 'Other currency'
	end as TaxPayCurrency,
	case when (T2.M_TC_PCR0 = 2) then T2.M_TC_PCRL0
		else ' ' end as TaxOtherCurrency,
	case when (T2.M_ECP_TYPE0 = 0) then 'Driving schedule' 
		when (T2.M_ECP_TYPE0 = 1) then 'Equal to'
		when  (T2.M_ECP_TYPE0 = 2) then 'Deduced from'
	end as CalcStartSch1, 
	case when (T2.M_ECP_TYPE0=0) then ' '
		when (T2.M_ECP_UNDRL0 = -1) then ' ' 
		when (T2.M_ECP_UNDRL0= 0) then 'Payment schedule'
		when (T2.M_ECP_UNDRL0= 7) then 'Calculation end schedule'
		when (T2.M_ECP_UNDRL0 = 8) then 'Delivery schedule'
	end as CalcStartSch2, 
	T2.M_ECP0 as CalcStartSch3,
	case when (T2.M_ECPE_TYPE0 = 1) then 'Equal to'
		when (T2.M_ECPE_TYPE0 = 2) then 'Deduced from'
	end as CalcEndSch1, 
	case when (T2.M_ECPE_UNDR0 = -1) then ' ' 
		when (T2.M_ECPE_UNDR0 = 0) then 'Payment schedule'
		when (T2.M_ECPE_UNDR0 = 1) then 'Calculation start schedule'
		when (T2.M_ECPE_UNDR0 = 8) then 'Delivery schedule'
	end as CalcEndSch2, 
	T2.M_ECPE0 as CalcEndSch3, 
	case when (T2.M_EP_TYPE0 = 0) then 'Driving schedule' 
		when (T2.M_EP_TYPE0 = 1) then 'Equal to'
		when  (T2.M_EP_TYPE0 = 2) then 'Deduced from'
	end as PaymentSch1,
	case when (T2.M_EP_UNDRL0 = -1) then ' '
		when (T2.M_EP_TYPE0=0) then ' ' 
		when (T2.M_EP_UNDRL0 = 1) then 'Calculation start schedule'
		when (T2.M_EP_UNDRL0= 7) then 'Calculation end schedule'
		when (T2.M_EP_UNDRL0 = 8) then 'Delivery schedule'
	end as PaymentSch2,
	T2.M_EP0 as PaymentSch3,
	case when ((T2.M_EP_TYPE0 in (1,2)) and (T2.M_SIMP_SCH0 = 0)) then to_char(T2.M_EP_FREQ0)
		else ' ' end as PaymentFreq,
	case when (M_FOLW_FXNG0=0) then 'No (time series)'
		when (M_FOLW_FXNG0=1) then 'Yes (time series)'
		when (M_FOLW_FXNG0=2) then 'No (published)'
		when (M_FOLW_FXNG0=3) then 'Yes (published)'
		end as CalcFix,
	case when (T2.M_SIMP_SCH0 = 0) then 'No'
		when (T2.M_SIMP_SCH0 = 1) then 'Yes'
		end as SinglePeriod,
	case when (T2.M_SIMP_SCH0 = 1) then
		case when ((MOD(T2.M_LNGN_FLGS1, 2097152 ) < 2097152) and (MOD( T2.M_LNGN_FLGS1, 4194304) >=2097152)) 
			then 'Maturity adjustment modfol' else 'No maturity adjustment' end 
		else ' ' end as SinglePeriodMat,
	case when ((MOD(T2.M_LNGN_FLGS0,  2 ) < 2) and (MOD( T2.M_LNGN_FLGS0, 4) >=2)) then 
		case when (T2.M_RETDSCEV0 = 0) then 'Forward'
			when (T2.M_RETDSCEV0 = 1) then 'Discounting' end
		else ' ' end as ReturnEvalMode,
	case when ((MOD(T2.M_LNGN_FLGS0, 2 ) < 2) and (MOD( T2.M_LNGN_FLGS0, 4) >=2)) then 
		case when (T2.M_RETCRDEV0 = 0) then 'No'
			when (T2.M_RETCRDEV0 = 1) then 'Yes' end
		else ' ' end as ReturnCredit,
	case when ((MOD(T2.M_LNGN_FLGS0,  2 ) < 2) and (MOD( T2.M_LNGN_FLGS0, 4) >=2)) then 
		case when (T2.M_TR_TYP0 = 0) then 'Dirty price'
			when (T2.M_TR_TYP0 = 1) then 'Clean price' 
			when (T2.M_TR_TYP0 = 2) then 'Yield' end
		else ' ' end as ReturnBasedOn,
	case when ((MOD(T2.M_LNGN_FLGS0,  2 ) < 2) and (MOD( T2.M_LNGN_FLGS0, 4) >=2)) then 
		case when (T2.M_RETINT0 = 0) then 'Return (P2-P1)/P1'
			when (T2.M_RETINT0 = 1) then 'Spread (P2-P1)' end
		else ' ' end as ReturnType,	
	case when ((MOD(T2.M_LNGN_FLGS0,  2 ) < 2) and (MOD( T2.M_LNGN_FLGS0, 4) >=2)) then 
		case when (T2.M_RETINRP0 = 0) then 'Piecewise'
			when (T2.M_RETINRP0 = 1) then 'Linear' 
			when (T2.M_RETINRP0 = 2) then 'Log linear' end
		else ' ' end as ReturnInterpol,
	case when ((MOD(T2.M_LNGN_FLGS0,  2 ) < 2) and (MOD( T2.M_LNGN_FLGS0, 4) >=2)) then 
		case when (T2.M_PROTZ0 = 0) then 'Ignore'
			when (T2.M_PROTZ0 = 1) then 'Apply' end
		else ' ' end as ReturnDayCount,
	case when ((MOD(T2.M_LNGN_FLGS0, 2 ) < 2) and (MOD( T2.M_LNGN_FLGS0, 4) >=2)) then T2.M_RSHIFT0
		else ' ' end as ReturnFixing,
case when (T2.M_ECP_TYPE1 = 0) then 'Driving schedule' 
		when (T2.M_ECP_TYPE1 = 1) then 'Equal to'
		when  (T2.M_ECP_TYPE1 = 2) then 'Deduced from'
	end as CalcStartSch1Fees, 
	case 	when (T2.M_ECP_TYPE1=0) then ' '
		when (T2.M_ECP_UNDRL1 = -1) then ' ' 
		when (T2.M_ECP_UNDRL1= 0) then 'Payment schedule'
		when (T2.M_ECP_UNDRL1= 7) then 'Calculation end schedule'
		when (T2.M_ECP_UNDRL1 = 8) then 'Delivery schedule'
	end as CalcStartSch2Fees, 
	CAST(T2.M_ECP1 AS VARCHAR(18)) as CalcStartSch3Fees,
	case 	when (T2.M_ECPE_TYPE1 = 1) then 'Equal to'
		when (T2.M_ECPE_TYPE1 = 2) then 'Deduced from'
	end as CalcEndSch1Fees, 
	case 	when (T2.M_ECPE_UNDR1 = -1) then ' ' 
		when (T2.M_ECPE_UNDR1 = 0) then 'Payment schedule'
		when (T2.M_ECPE_UNDR1 = 1) then 'Calculation start schedule'
		when (T2.M_ECPE_UNDR1 = 8) then 'Delivery schedule'
	end as CalcEndSch2Fees, 
	T2.M_ECPE1 as CalcEndSch3Fees, 
	case 	when (T2.M_EP_TYPE1 = 0) then 'Driving schedule' 
		when (T2.M_EP_TYPE1 = 1) then 'Equal to'
		when  (T2.M_EP_TYPE1 = 2) then 'Deduced from'
	end as PaymentSch1Fees,
	case 	when (T2.M_EP_UNDRL1 = -1) then ' '
		when (T2.M_EP_TYPE1=0) then ' ' 
		when (T2.M_EP_UNDRL1 = 1) then 'Calculation start schedule'
		when (T2.M_EP_UNDRL1= 7) then 'Calculation end schedule'
		when (T2.M_EP_UNDRL1 = 8) then 'Delivery schedule'
	end as PaymentSch2Fees,
	T2.M_EP1 as PaymentSch3Fees,
	case when ((T2.M_EP_TYPE1 in (1,2)) and (T2.M_SIMP_SCH1 = 0)) then to_char(T2.M_EP_FREQ1)
		else ' ' end as PaymentFreqFees,
	case	when ((T2.M_RATE_TYPE1= 1) and (T2.M_EI_TYPE1 = 0)) then 'Driving schedule'
		when ((T2.M_RATE_TYPE1= 1) and (T2.M_EI_TYPE1 = 1)) then 'Equal to'
		when ((T2.M_RATE_TYPE1= 1) and (T2.M_EI_TYPE1 = 2)) then 'Deduced from'
		else ' ' end as FixingSch1Fees,
	case	when ((T2.M_EI_UNDRL1 = -1) or (T2.M_EI_UNDRL1 = 0))  then ' '
		when (T2.M_EI_TYPE1 =0) then ' '
		when ((T2.M_RATE_TYPE1= 1) and (T2.M_EI_UNDRL1= 1)) then 'Calculation start schedule'
		when ((T2.M_RATE_TYPE1= 1) and (T2.M_EI_UNDRL1 = 7)) then 'Calculation end schedule'
		when ((T2.M_RATE_TYPE1= 1) and (T2.M_EI_UNDRL1 = 0)) then 'Payment schedule'
		else ' ' end as FixingSch2Fees,
	case	when ((T2.M_RATE_TYPE1= 1) and (T2.M_EI_TYPE1 = 0)) then to_char(T2.M_EI1)
		else ' ' end as FixingSch3Fees,
	case	when ((T2.M_RATE_TYPE1= 1) and (T2.M_EI_TYPE1 in (1,2)))then to_char(T2.M_EI_FREQ1)
		else ' ' end as FixingFreqFees,
	case when (M_FOLW_FXNG1=0) then 'No (time series)'
		when (M_FOLW_FXNG1=1) then 'Yes (time series)'
		when (M_FOLW_FXNG1=2) then 'No (published)'
		when (M_FOLW_FXNG1=3) then 'Yes (published)'
		end as CalcFixFees,
	case when (T2.M_SIMP_SCH1 = 0) then 'No'
		when (T2.M_SIMP_SCH1 = 1) then 'Yes'
		end as SinglePeriodFees,
	case when (T2.M_SIMP_SCH1 = 1) then
		case when ((MOD(T2.M_LNGN_FLGS1,  2097152 ) < 2097152) and (MOD( T2.M_LNGN_FLGS1, 4194304) >=2097152)) 
			then 'Maturity adjustment modfol' else 'No maturity adjustment' end 
		else ' ' end as SinglePeriodMatFees,
	case	when (T2.M_ACC_METH0 = 0 ) then 'Use interest convention'  
		when (T2.M_ACC_METH0 = 1 ) then 'Specific convention'
		when (T2.M_ACC_METH0 = 2 ) then 'External'  
		when (T2.M_ACC_METH0 = 3 ) then 'Prorate interest'
	end as AccrualMethod, 
	CAST(T2.M_ACC_CONV0 AS VARCHAR2(18)) as AccrualConvention,
	case	when (T2.M_ACC_ROUND0 = 0) then 'None' 
		when (T2.M_ACC_ROUND0 = 1) then 'Nearest' 
		when (T2.M_ACC_ROUND0 = 2) then 'By default' 
		when (T2.M_ACC_ROUND0 = 3) then 'By excess' 
	end as AccrualRoundingRule,
	case when (T2.M_ACC_ROUND0 = 0) then ' ' else to_char( T2.M_ACC_DEC0) end as AccrualDecimals, 
	case when (T2.M_ACC_RMODE0 =0 ) then 'Standard' 
		 when (T2.M_ACC_RMODE0 =1) then 'Ex-dividend' 
                 When (T2.M_ACC_RMODE0 =2) then 'Always applied to fraction'
		 end as AccrualRoundingMode,
	case when (T2.M_YLD_CALC0 = 0 ) then 'AIBD' 
		 when (T2.M_YLD_CALC0 = 1) then 'Specific convention'
		 when (T2.M_YLD_CALC0 = 2 ) then 'Moosmuller'
		 when (T2.M_YLD_CALC0 = 3 ) then 'Braess-Fangmeyer'
		 when (T2.M_YLD_CALC0 = 4) then 'Simple yield'
		 when (T2.M_YLD_CALC0 = 5 ) then 'Discount margin'
		 when (T2.M_YLD_CALC0 = 6) then 'Btp'
		 when (T2.M_YLD_CALC0 = 7) then 'Perpetual'
		 when (T2.M_YLD_CALC0 = 8) then 'Sobretasa'
		 when (T2.M_YLD_CALC0 = 9 ) then 'Stripped yield'
		 when (T2.M_YLD_CALC0 = 10) then 'Linear Sobretasa'
		 when (T2.M_YLD_CALC0 = 11) then 'CPI' 
		 when (T2.M_YLD_CALC0 = 12) then 'LFT'
		 when (T2.M_YLD_CALC0 = 14 ) then 'Discount margin (indexed bond)'
		 when (T2.M_YLD_CALC0 = 50) then 'External'
		end as YielCalculation, 
	T2.M_YLD_CONV0 as YielConvention, 
	case when (T2.M_YLD_SCHED0 = 0) then 'Anniversary schedule' 
		 when (T2.M_YLD_SCHED0 = 1) then 'Payment schedule' 
		 end as  YieldSchedule,
	case when ((T2.M_RATE_TYPE1= 0) and (T2.M_YLD_CALC0 = 0 ) and( T2.M_YLD_FREQ0 = 0)) then 'at coupon frequency (standard)' 
		 when ((T2.M_RATE_TYPE1= 0) and (T2.M_YLD_CALC0 = 0 ) and( T2.M_YLD_FREQ0 = 1)) then 'Annual compounding'
		 else ' '
		 end as YieldFrequency, 		
	case when ( T2.M_GC_ACC0 = 0) then 'Standard' 
		 when ( T2.M_GC_ACC0 = 1) then 'Specific convention' 
		 end as GrossToCleanAccrual,
	CAST(T2.M_GC_ACCCNV0 AS VARCHAR2(23)) as GrossToCleanConvention,
	case when ( T2.M_ALT_YL0 = 0 ) then 'No' 
		 when ( T2.M_ALT_YL0 = 1 ) then 'During last period'
		 when ( T2.M_ALT_YL0 = 2 ) then 'During last year'
		 when ( T2.M_ALT_YL0 = 3 ) then 'During last period + ExDiv'
	end as AltrntYield ,
	CAST(T2.M_ALT_YLCNV0 AS VARCHAR2(25)) as AlternateYieldConvention,
	case when (T20.M_TYPE is NULL) then ' '
		 when (T20.M_TYPE=0)  then 'Interest flows'
		 when (T20.M_TYPE=1)  then 'Fixings'
		 when (T20.M_TYPE=8)  then 'Strikes'
		 when (T20.M_TYPE=2)  then 'Margins'
		 when (T20.M_TYPE=3)  then 'Interest rates'
		 when (T20.M_TYPE=4)  then 'Initial capital'
		 when (T20.M_TYPE=5)  then 'Intermediate capital'
		 when (T20.M_TYPE=6)  then 'Final capital'
		 when (T20.M_TYPE=7)  then 'Outstanding capital'
		 when (T20.M_TYPE=9)  then 'Dividends'
		 when (T20.M_TYPE=10) then 'Tax Credit'
		 when (T20.M_TYPE=12) then 'Recovery nominal'
		 when (T20.M_TYPE=13) then 'Cap strikes'
		 end as IndexationListTypes,
	case when (T4.M_RAT_TYPE is NULL) then ' ' 
		 when (T4.M_RAT_TYPE=0) then 'Floating'
		 when (T4.M_RAT_TYPE=1) then 'Fixed'
		 when (T4.M_RAT_TYPE=2) then 'Optional'
		 end as IndexationType,
	case when (T4.M_IND_NAT is NULL) then ' ' 
		 when (T4.M_IND_NAT=0) then 'Rate'
		 when (T4.M_IND_NAT=1) then 'Equity price'
		 when (T4.M_IND_NAT=2) then 'Bond price'
		 when (T4.M_IND_NAT=3) then 'Inflation'
		 when (T4.M_IND_NAT=4) then 'FX Spot'
		 when (T4.M_IND_NAT=5) then 'Pool Factor'
		 when (T4.M_IND_NAT=6) then 'Generic Index'
		 when (T4.M_IND_NAT=7) then 'Formula'
		 when (T4.M_IND_NAT=8) then 'Commodity'
		 end as IndexationNature,
	case when (T4.M_INDX_NAT is NULL) then ' '
		 else to_char( T4.M_IND_NAT)
		end as IndexNature,
	case when (T4.M_RETINRP is NULL) then ' '
		 when (T4.M_RETINRP=0) then 'Inflation'
		 when (T4.M_RETINRP=1) then 'Linear'
		 end as ReturnInterpolIndex,
	case when (T4.M_RSHIFT is NULL) then ' '
		 else T4.M_RSHIFT
		 end as ReturnFixingLag,
	case when (T5.M_IND_LAB is NULL) then ' ' else T5.M_IND_LAB end as IndexLabel,
	case when (T4.M_I_FORMULA is NULL) then ' ' else to_char(T4.M_I_FORMULA) end as IndexFormula,
	case when (T4.M_OPERAND is NULL) then ' ' 
		 when (T4.M_OPERAND=0) then 'Factor (xP)' 
		 when (T4.M_OPERAND=1) then 'Spread (+P)' 
		 when (T4.M_OPERAND=2) then 'Increase (x(1+P))' 
		 when (T4.M_OPERAND=3) then 'Replace (=P)' 
		end as Operand,
	case when (T4.M_FORMULA is NULL) then ' ' 
		 when (T4.M_FORMULA=0) then 'Plain index (P) '
		 when (T4.M_FORMULA=1) then 'Period Return (P=(P2-P1)/P1)'
		 when (T4.M_FORMULA=2) then 'Period Ratio (P=P2/P1)'
		 when (T4.M_FORMULA=3) then 'Initial Return (P=(P2-P0)/P0)'
		 when (T4.M_FORMULA=4) then 'Initial ratio (P=P2/P0)'
		 when (T4.M_FORMULA=5) then 'Inverse (P=(1/P))'
		 end as Formula,
	case when (T4.M_SCHED_TYPE is NULL) then ' ' 
		 when (T4.M_SCHED_TYPE=0) then 'Equal To'
		 when (T4.M_SCHED_TYPE=1) then 'Shifted from'
		 end as ScheduleType, 
	case when (T4.M_OPTION is NULL) then ' ' 
		 when (T4.M_OPTION=0) then 'No'
		 when (T4.M_OPTION=1) then 'Max'
		 when (T4.M_OPTION=2) then 'Min'
		 end as IndexationOption,
	case when (T4.M_UND_SCHED is NULL) then ' ' 
		 when (T4.M_UND_SCHED=0) then 'Payment schedule'
		 when (T4.M_UND_SCHED=1) then 'Calculation schedule'
		 when (T4.M_UND_SCHED=2) then 'Reset schedule'
		end as UnderlyingSchedule,
	case when (T4.M_FREQ is NULL) then ' ' else to_char(T4.M_FREQ) end as FrequencyRatio,
	case when (T4.M_DATE_POS is NULL) then ' ' 
	when (T4.M_DATE_POS=0) then 'Unchecked'
	when (T4.M_DATE_POS=1) then 'Checked'
	end as UpFront,
	case when (T4.M_FACTOR is NULL) then ' ' else to_char(T4.M_FACTOR) end as IndexationFactor,
	case when (T4.M_P_FACTOR is NULL) then ' ' else to_char(T4.M_P_FACTOR) end as PriceFactor,
	case when (T4.M_REPL is NULL) then ' ' 
	when (T4.M_REPL=0) then 'Unchecked'
	when (T4.M_REPL=1) then 'Checked'
	end as Replacement,
	case when (T4.M_RND_RL0 is NULL) then ' ' 
	when (T4.M_RND_RL0=0) then 'None'
	when (T4.M_RND_RL0=1) then 'Nearest'
	when (T4.M_RND_RL0=2) then 'By default'
	when (T4.M_RND_RL0=3) then 'By excess'
	end as IndexationRoundingRule,
	case when (T4.M_RND_RLD0 is NULL) then ' ' else to_char(T4.M_RND_RLD0) end as IndexationRoundingDecimals,
	case when (T4.M_RND_RL1 is NULL) then ' ' 
	when (T4.M_RND_RL1=0) then 'None'
	when (T4.M_RND_RL1=1) then 'Nearest'
	when (T4.M_RND_RL1=2) then 'By default'
	when (T4.M_RND_RL1=3) then 'By excess'
	end as IndexationPostRoundingRule,
	case when (T4.M_RND_RLD1 is NULL) then ' ' else to_char(T4.M_RND_RLD1) end as IndexationPostRdgDecimals,
	case when (T4.M_P_MARGIN is NULL) then ' ' else to_char(T4.M_P_MARGIN) end as PriceMargin
from RT_INSGN_DBF T1, RT_LNGN_DBF T2
-----
left outer join RT_INDEX_DBF T3 on T2.M_INDEX0=T3.M_INDEX
left outer join RT_LNDXGL_DBF T20 left outer join RT_LNDXG_DBF T4 on T20.M_REF_INDEXATION_TEMPL=T4.M_REFERENCE on T2.M_REFERENCE=T20.M_REF_LOAN_GENERATOR
left outer join RT_INDEX_DBF T5 on T4.M_INDEX=T5.M_INDEX
left outer join RT_INDEX_DBF T6 on T2.M_INDEX0=T6.M_INDEX
left outer join (select min(M_IDENTITY) as TEMP_LEGTYPE from RT_LNGN_DBF group by M_GEN_NUM) T7 on T7.TEMP_LEGTYPE = T2.M_IDENTITY
-----
where T1.M_GEN_NUM = T2.M_GEN_NUM
and  T1.M_INSTR_TYPE = 23
and T1.M_CREAT_MODE=0
-----
order by M_INSTR,16;
quit;
SPOOL OFF;
