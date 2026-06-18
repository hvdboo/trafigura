set colsep '#';
SET TERMOUT OFF;
SPOOL &1;
set linesize 3810;
set pagesize 2048;
select T1.M_INSTR as ReturnSwapTemplate,
	T1.M_INSTR_DESC as Description,
	case when (T1.M_EVAL_MODE = 0) then 'Default'
		 when (T1.M_EVAL_MODE = 1) then 'Net Present Value'
		 when (T1.M_EVAL_MODE = 2) then 'Accrual'
		end as EvaluationMode,

/* Evaluation Accrual fields (comon fileds) ###start### */
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
	case when M_FINCPDIR=0 then 'Quantity'
		when M_FINCPDIR=1 then 'Price'
		when M_FINCPDIR=3 then 'Nominal'
	end as Direction,
	case when M_NSC_HNDL=0 then 'In future cash' else 'In market value' end as NonSettCashHand,
	
	case when (T1.M_BROKEN =0 ) then 'Up front'
		 when (T1.M_BROKEN =1 ) then 'In arrears' 
		 when (T1.M_BROKEN=3 )  then 'Both ends (backward)'
		 when (T1.M_BROKEN = 5) then 'Both ends (forward)' 
	end as StubPosition, -- 1ere case a gauche
/* Evaluation Accrual fields (common fields)  ###end### */ 


	case when T1.M_NB_LEG = 3 then 'On deal level' else ' On pool level' end as TreatCol,
	case when ( mod(T1.M_FLAGS, 256) < 256 and mod (T1.M_FLAGS, 512) >=256) then 'No' else 'Yes' end as EarlySettlement,
	case when (mod(T1.M_FLAGS, 256 ) < 256 and mod (T1.M_FLAGS, 512) >=256) then 'Inherited from currency' 
		else case when (T1.M_SETTL_MOD=0) then 'Inherited from currency'
				when (T1.M_SETTL_MOD=1) then 'Specific delay' end 
		end as SettlementDelay,
	case when ( mod(T1.M_FLAGS, 256) < 256 and mod (T1.M_FLAGS, 512) >=256) then ' '
		else case when (T1.M_SETTL_MOD=1) then T1.M_SETTL
			when (T1.M_SETTL_MOD=0) then ' ' end 
		end as SettDelayShfiter,
	case when M_GEN_VAL_S_MOD= 1 then 'Specific delay' else 'Inherited from security' end as ValuationShifterMode,
	case when M_GEN_VAL_S_MOD=1 then M_GEN_VAL_S else ' ' end as ValuationShifter,
	case when T2.M_REVOLV0 =1 then 'first in- first out'
		when T2.M_REVOLV0 =2 then 'Average price' 
	end as Liquidation,

/* Security */	
	T2.M_START0 as StartDelaySec,


	/* Schedules definition - Security ###start### */

	case when T2.M_EP_TYPE0 = 0 then 'Driving Schedule'
		when T2.M_EP_TYPE0= 1 then 'Equal to'
		when T2.M_EP_TYPE0=2 then 'Deduced from'
		when T2.M_EP_TYPE0=5 then 'Driving deduced schedule'
	end as PaymentSch1Sec,
	case when (T2.M_EP_TYPE0 in (1,2) and T2.M_EP_UNDRL0 =2) then 'Fixing start schedule'
		when (T2.M_EP_TYPE0 in (1,2) and T2.M_EP_UNDRL0=10 ) then 'Fixing end schedule'
		else ' '
	end as PaymentSch2Sec,
	case when T2.M_EP_TYPE0 <> 1 then T2.M_EP0 else ' ' end as PaymentSch3Sec,
	case when ((T2.M_EP_TYPE0 in (1,2)) and (T2.M_SIMP_SCH0 = 0)) then to_char(T2.M_EP_FREQ0)
		else ' ' 
	end as PaymentFreqSec,

	case when T2.M_EI_TYPE0 = 0 then 'Driving Schedule'
		when T2.M_EI_TYPE0 = 1 then 'Equal to'
		when T2.M_EI_TYPE0 = 2 then 'Deduced from'
		when T2.M_EI_TYPE0 = 5 then 'Driving deduced schedule'
	end as FixingStartSchd1Sec,
	case when (T2.M_EI_TYPE0 in (1, 2) and T2.M_EI_UNDRL0 =2) then 'Payment schedule'
		 when (T2.M_EI_TYPE0 in (1, 2) and T2.M_EI_UNDRL0 =10) then 'Fixi9ng end schedule'
		 else ' ' 
	end as FixingStartSchd2Sec,
	case when T2.M_EI_TYPE0 <> 1 then T2.M_EI0 else ' ' end as FixingStartSchd3Sec,
		case when ((T2.M_EI_TYPE0 in (1,2)) and (T2.M_SIMP_SCH0 = 0)) then to_char(T2.M_EI_FREQ0)
		else ' ' 
	end as FixingStartFreqSec,

	case when T2.M_EIE_TYPE0 =1 then 'Equal to'
		when T2.M_EIE_TYPE0 =2 then 'Deduced from'
	end as FixingEndSchd1Sec,
	case when  T2.M_EIE_UNDRL0 =0 then 'Payment schedule'
		when T2.M_EIE_UNDRL0 =2 then 'Fixing start schedule'
	end as FixingEndSchd2Sec,
	case when T2.M_EIE_TYPE0 =2 then T2.M_EIE0 else ' ' end as FixingEndSchd3Sec,
	case when (T2.M_EIE_FREQ0 = -1 and T2.M_SIMP_SCH0 = 0) then 'Zero coupon'
		when (T2.M_EIE_FREQ0 = -2  and T2.M_SIMP_SCH0 = 0) then 'Automatic cmp.'
		when (T2.M_EIE_FREQ0 not in (-1, -2) and (T2.M_SIMP_SCH0 = 0)) then 'Frequency ratio'
		else ' '
	end as FixingEndFreq1Sec,
	case when (T2.M_EIE_FREQ0 not in (-1, -2) and (T2.M_SIMP_SCH0 = 0)) then to_char(T2.M_EIE_FREQ0) else ' ' end as FixingEndFreq2Sec,
	
	case when (T2.M_FOLW_FXNG0=0) then 'No (time series)'
		when (T2.M_FOLW_FXNG0=1) then 'Yes (time series)'
		when (T2.M_FOLW_FXNG0=2) then 'No (published)'
		when (T2.M_FOLW_FXNG0=3) then 'Yes (published)'
	end as CalcFixSec,
	case when (T2.M_SIMP_SCH0 = 0) then 'No'
		when (T2.M_SIMP_SCH0 = 1) then 'Yes'
	end as SinglePeriodSec,
	case when (mod (T2.M_LNGN_FLGS1, 2097152 ) < 2097152 and mod (T2.M_LNGN_FLGS1, 4194304) >=2097152) 
			then 'Maturity adjustment modfol' else 'No maturity adjustment' 
	end as SinglePeriodMatSec,
/* Schedules definition - Security ###end### */
	
/* Dividends-Tax credit fields ###start### */
	case when ( mod (T2.M_LNGN_FLGS0, 131072 ) < 131072 and mod (T2.M_LNGN_FLGS0, 262144) >=131072) then 'In market value' else 'In future cash' end as DivTaxHandling,
	T2.M_DIV_PFRAC0 as DivPayFrac,
	T2.M_DIV_RFRAC0 as DivReinvFrac,
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
		case when (mod (T2.M_LNGN_FLGS0, 2 ) < 2 and mod (T2.M_LNGN_FLGS0, 4) >=2) then 'Payment currency' else 'Security currency' end 
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
		case when (mod (T2.M_LNGN_FLGS0, 2 ) < 2 and mod (T2.M_LNGN_FLGS0, 4) >=2) then 'Payment currency' else 'Security currency' end 
		when (T2.M_TC_PCR0 = 3) then 'Fees currency'
		when (T2.M_TC_PCR0 = 1) then 'Own currency'
		when (T2.M_TC_PCR0 = 2) then 'Other currency'
	end as TaxPayCurrency,
	case when (T2.M_TC_PCR0 = 2) then T2.M_TC_PCRL0
		else ' ' end as TaxOtherCurrency,
/* Dividends-Tax credit fields ###end### */	

	/* Performance-Return fields ###start### */
	case when ( mod(T2.M_LNGN_FLGS0, 2 ) < 2 and mod (T2.M_LNGN_FLGS0, 4) >=2) then 
		case when (T2.M_RETDSCEV0 = 0) then 'Forward'
			when (T2.M_RETDSCEV0 = 1) then 'Discounting' end
		else ' ' end as ReturnEvalMode,
	case when ( mod(T2.M_LNGN_FLGS0, 2 ) < 2 and mod (T2.M_LNGN_FLGS0, 4) >=2) then 
		case when (T2.M_RETCRDEV0 = 0) then 'No'
			when (T2.M_RETCRDEV0 = 1) then 'Yes' end
		else ' ' end as ReturnCredit,
	case when (mod (T2.M_LNGN_FLGS0, 2 ) < 2 and mod (T2.M_LNGN_FLGS0, 4) >=2) then 
		case when (T2.M_TR_TYP0 = 0) then 'Dirty price'
			when (T2.M_TR_TYP0 = 1) then 'Clean price' 
			when (T2.M_TR_TYP0 = 2) then 'Yield' end
		else ' ' end as ReturnBasedOn,
	case when (mod (T2.M_LNGN_FLGS0, 2 ) < 2 and mod (T2.M_LNGN_FLGS0, 4) >=2) then 
		case when (T2.M_RETINT0 = 0) then 'Return (P2-P1)/P1'
			when (T2.M_RETINT0 = 1) then 'Spread (P2-P1)' end
		else ' ' end as ReturnType,	
	case when (mod (T2.M_LNGN_FLGS0, 2 ) < 2 and mod (T2.M_LNGN_FLGS0, 4) >=2) then 
		case when (T2.M_RETINRP0 = 0) then 'Piecewise'
			when (T2.M_RETINRP0 = 1) then 'Linear' 
			when (T2.M_RETINRP0 = 2) then 'Log linear' end
		else ' ' end as ReturnInterpol,
	case when ( mod (T2.M_LNGN_FLGS0, 2 ) < 2 and mod (T2.M_LNGN_FLGS0, 4) >=2) then 
		case when (T2.M_PROTZ0 = 0) then 'Ignore'
			when (T2.M_PROTZ0 = 1) then 'Apply' end
		else ' ' end as ReturnDayCount,
	case when ( mod(T2.M_LNGN_FLGS0, 2 ) < 2 and mod (T2.M_LNGN_FLGS0, 4) >=2) then T2.M_RSHIFT0
		else ' ' end as ReturnFixing,
/* Performance-Return fields ###end### */

	T2.M_PAY_CLN0 as PaymentCalendarSec,  -- Security
	T2.M_FIX_CLN0 as FixingCalendarSec,
	case when (mod (T2.M_LNGN_FLGS0, 921602) < 921602 and mod (T2.M_LNGN_FLGS0, 1843204) >=921602) then 'Yes' else 'No' end as FixingTradeDate,
	
	
	/* Stub period Security- Start*/
	
	case when (T2.M_BROK_IND0 = 0) then 'Current index'
		 when (T2.M_BROK_IND0 = 1) then 'Closest index'
		 when (T2.M_BROK_IND0 = 2) then 'Next index'
		 when (T2.M_BROK_IND0 = 3) then 'Previous index'
		 when (T2.M_BROK_IND0 = 4) then 'Interpolated'
		 else ' '
	end as StubPeriodRate1Sec,
	
	case when (T2.M_BROK_COUP0= 0) then 'Short Coupon'
		when (T2.M_BROK_COUP0= 1) then 'Long Coupon'
		when (T2.M_BROK_COUP0= 3) then 'Full Coupon'
		when (T2.M_BROK_COUP0= 4) then 'Conditional'
	end as CouponSec,
	
	case  when (T2.M_BRK2_IND0 = 0) then 'Current index'
		 when (T2.M_BRK2_IND0 = 1) then 'Closest index'
		 when (T2.M_BRK2_IND0 = 2) then 'Next index'
		 when (T2.M_BRK2_IND0 = 3) then 'Previous index'
		 when ( T2.M_BRK2_IND0 = 4) then 'Interpolated'
		 else ' '
	end as StubPeriodRate2Sec,
	
/* Stub period Security -end */
	
	case when (T2.M_INDEXED0 =0) then 'No'
		when (T2.M_INDEXED0 =1) then 'Yes'
	end as IndexedSec,
	
	case when (mod (T1.M_FLAGS, 2048 ) < 2048 and mod (T1.M_FLAGS, 4096) >=2048) then 'Yes' else 'No' end as MultiCurrencyProp,
	
	case when T2.M_CMP_ROUND0= 0 then 'None'
		when T2.M_CMP_ROUND0=1 then 'Nearest'
		when T2.M_CMP_ROUND0=2 then 'By default'
		when T2.M_CMP_ROUND0= 3 then 'By excess'
	end as IntFlowsRnd,
	
	case when T2.M_LNGN_SFLGS1 = 0 then 'No'
		when T2.M_LNGN_SFLGS1 =128 then 'Yes'
	end as InterestRoundingsSec,
	
	case when T2.M_LNGN_SFLGS0 = 1152 then 'Yes' else 'No' end as NPVCurrencySec,
	case when T2.M_CMP_ROUND0 <>0 then to_char(T2.M_CMP_DEC0) else ' ' end as IntFlowsRndDec,

/* Security */

	
/* Interest-Collateral ###start### */

	 case when (mod (T2.M_LNGN_FLGS1, 8 ) <8 and mod (T2.M_LNGN_FLGS1, 16) >=8) then 'Marked to market' 
		when (mod (T2.M_LNGN_FLGS1, 16384 ) < 16384 and mod (T2.M_LNGN_FLGS1, 32768) >=16384) then 'Based on reset prices'
		when (mod (T2.M_LNGN_FLGS1, 8192 ) < 18192 and mod (T2.M_LNGN_FLGS1, 16384) >=8192) then 'Independent amount' 
		else 'Based on reset prices' end as MarkedtoMarket, -- interest
	case when (T2.M_RATE_TYPE1  = 0) then 'Fixed rate' 
		when (T2.M_RATE_TYPE1= 1) then 'Floating rate' 
		end as RateType,  --interest
	T2.M_START1 as StartDelay,  --interest
	T2.M_PAY_CLN1 as PaymentCalendar, --interest
	case when (T2.M_RATE_TYPE1= 1) then T2.M_FIX_CLN1
		else ' ' end as FixingCalendar,  --floating
	case when (T2.M_EP_TYPE1 = 0) then 
		(case 	when (T2.M_MRG_CMP1=0) then '(I+M) at (I+M)'
			when (T2.M_MRG_CMP1=1) then '(I+M) at I'
			when (T2.M_MRG_CMP1=2) then '(I at I) + M'
			when (T2.M_MRG_CMP1=3) then 'I at (I+M)'			
			when (T2.M_MRG_CMP1=4) then 'I at (I+M) + M'
			when (T2.M_MRG_CMP1=5) then 'No compounding'
			when (T2.M_MRG_CMP1=6) then '(I+M1) at (I+M2)'
			when (T2.M_MRG_CMP1=8) then '(I+M) at C'
		end) else ' ' end as Compounding,

	case when ((T2.M_RATE_TYPE1= 1) and (T2.M_FIXING1 = 0 )) then 'Up front'
		when ((T2.M_RATE_TYPE1= 1) and (T2.M_FIXING1 = 1 )) then 'In arrears'
		else ' ' end  as Fixing, --floating
	case when (T2.M_PAYMENT1 = 0) 	then 'In arrears' 
		when  (T2.M_PAYMENT1 = 1) then 'Up front'
		when (T2.M_PAYMENT1 = 2) then 'Up front disc.'
		end as Payment,
	case when ((T2.M_PAYMENT1 = 2) and (T2.M_DISC_RATE1 =0)) then 'Floating rate'
		 when ((T2.M_PAYMENT1 = 2) and (T2.M_DISC_RATE1 =1)) then 'Fixed rate'
		 when ((T2.M_PAYMENT1 = 2) and (T2.M_DISC_RATE1 =2)) then 'Specific index'
		 when ((T2.M_PAYMENT1 = 2) and (T2.M_DISC_RATE1 =3)) then 'Current leg'
		 when ((T2.M_PAYMENT1 = 2) and (T2.M_DISC_RATE1 =4)) then 'Specific leg'
		 when ((T2.M_PAYMENT1 = 2) and (T2.M_DISC_RATE1 =5)) then 'Fixing'
		 else ' '
	end as DiscountRate,
	case when ((T2.M_PAYMENT1 = 2) and (T2.M_DISC_RATE1 =2)) then T2.M_DISC_IND1 else ' ' end as DiscountingIndex,
	case when ((T2.M_PAYMENT1 = 2) and (T2.M_DISC_RATE1 =4)) then to_char(T2.M_DISC_LEG1) else ' ' end as DiscountingLeg,
	T2.M_RATE_CONV1 as RateConvention,
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
	
	/* Schedules definition - Interest ###start### */
case when (T2.M_ECP_TYPE1 = 0) then 'Driving schedule' 
		when (T2.M_ECP_TYPE1 = 1) then 'Equal to'
		when  (T2.M_ECP_TYPE1 = 2) then 'Deduced from'
	end as CalcStartSch1, 
	case 	when (T2.M_ECP_TYPE1=0) then ' '
		when (T2.M_ECP_UNDRL1 = -1) then ' ' 
		when (T2.M_ECP_UNDRL1= 0) then 'Payment schedule'
		when (T2.M_ECP_UNDRL1= 7) then 'Calculation end schedule'
		when (T2.M_ECP_UNDRL1 = 8) then 'Delivery schedule'
	end as CalcStartSch2, 
	T2.M_ECP1 as CalcStartSch3,
	case 	when (T2.M_ECPE_TYPE1 = 1) then 'Equal to'
		when (T2.M_ECPE_TYPE1 = 2) then 'Deduced from'
	end as CalcEndSch1, 
	case 	when (T2.M_ECPE_UNDR1 = -1) then ' ' 
		when (T2.M_ECPE_UNDR1 = 0) then 'Payment schedule'
		when (T2.M_ECPE_UNDR1 = 1) then 'Calculation start schedule'
		when (T2.M_ECPE_UNDR1 = 8) then 'Delivery schedule'
	end as CalcEndSch2, 
	T2.M_ECPE1 as CalcEndSch3, 
	case 	when (T2.M_EP_TYPE1 = 0) then 'Driving schedule' 
		when (T2.M_EP_TYPE1 = 1) then 'Equal to'
		when  (T2.M_EP_TYPE1 = 2) then 'Deduced from'
	end as PaymentSch1,
	case 	when (T2.M_EP_UNDRL1 = -1) then ' '
		when (T2.M_EP_TYPE1=0) then ' ' 
		when (T2.M_EP_UNDRL1 = 1) then 'Calculation start schedule'
		when (T2.M_EP_UNDRL1= 7) then 'Calculation end schedule'
		when (T2.M_EP_UNDRL1 = 8) then 'Delivery schedule'
	end as PaymentSch2,
	T2.M_EP1 as PaymentSch3,
	case when (T2.M_EP_FREQ1 = -1 and T2.M_SIMP_SCH1 = 0) then 'Zero coupon'
		when (T2.M_EP_FREQ1 = -2  and T2.M_SIMP_SCH1 = 0) then 'Formula adjusted'
		when (T2.M_EP_FREQ1 not in (-1, -2) and (T2.M_SIMP_SCH1 = 0)) then 'Frequency ratio'
		else ' '
	end as PaymentFreq1,
	case when ((T2.M_EP_TYPE1 in (1,2)) and (T2.M_SIMP_SCH1 = 0)) then to_char(T2.M_EP_FREQ1)
		else ' ' end as PaymentFreq2,
		
	case	when ((T2.M_RATE_TYPE1= 1) and (T2.M_EI_TYPE1 = 0)) then 'Driving schedule'
		when ((T2.M_RATE_TYPE1= 1) and (T2.M_EI_TYPE1 = 1)) then 'Equal to'
		when ((T2.M_RATE_TYPE1= 1) and (T2.M_EI_TYPE1 = 2)) then 'Deduced from'
		else ' ' end as FixingSch1,
	case	when ((T2.M_EI_UNDRL1 = -1) or (T2.M_EI_UNDRL1 = 0))  then ' '
		when (T2.M_EI_TYPE1 =0) then ' '
		when ((T2.M_RATE_TYPE1= 1) and (T2.M_EI_UNDRL1= 1)) then 'Calculation start schedule'
		when ((T2.M_RATE_TYPE1= 1) and (T2.M_EI_UNDRL1 = 7)) then 'Calculation end schedule'
		when ((T2.M_RATE_TYPE1= 1) and (T2.M_EI_UNDRL1 = 0)) then 'Payment schedule'
		else ' ' end as FixingSch2,
	case	when ((T2.M_RATE_TYPE1= 1) and (T2.M_EI_TYPE1 = 0)) then to_char(T2.M_EI1)
		else ' ' end as FixingSch3,
		
	case when (T2.M_EI_FREQ1 = -1 and T2.M_SIMP_SCH1 = 0) then 'Zero coupon'
		when (T2.M_EI_FREQ1 = -2  and T2.M_SIMP_SCH1 = 0) then 'Automatic cmp.'
		when (T2.M_EI_FREQ1 not in (-1, -2) and (T2.M_SIMP_SCH1 = 0)) then 'Frequency ratio'
		else ' '
	end as FixingFreq1,
	case	when ((T2.M_RATE_TYPE1= 1) and (T2.M_EI_TYPE1 in (1,2)))then to_char(T2.M_EI_FREQ1)
		else ' ' end as FixingFreq2,
		
	case when (T2.M_FOLW_FXNG1=0) then 'No (time series)'
		when (T2.M_FOLW_FXNG1=1) then 'Yes (time series)'
		when (T2.M_FOLW_FXNG1=2) then 'No (published)'
		when (T2.M_FOLW_FXNG1=3) then 'Yes (published)'
		end as CalcFix,
	case when (T2.M_SIMP_SCH1 = 0) then 'No'
		when (T2.M_SIMP_SCH1 = 1) then 'Yes'
		end as SinglePeriod,
	case when (T2.M_SIMP_SCH1 = 1) then
		case when (mod(T2.M_LNGN_FLGS1, 2097152 ) < 2097152 and mod (T2.M_LNGN_FLGS1, 4194304) >=2097152) 
			then 'Maturity adjustment modfol' else 'No maturity adjustment' end 
		else ' ' end as SinglePeriodMat,
/* Schedules definition - Interest ###end### */


/* Stub period characteristics Interest ###start### */
	
	case when (T2.M_RATE_TYPE1= 1 and T2.M_BROK_IND1 = 0) then 'Current index'
		 when (T2.M_RATE_TYPE1= 1 and T2.M_BROK_IND1 = 1) then 'Closest index'
		 when (T2.M_RATE_TYPE1= 1 and T2.M_BROK_IND1 = 2) then 'Next index'
		 when (T2.M_RATE_TYPE1= 1 and T2.M_BROK_IND1 = 3) then 'Previous index'
		 when (T2.M_RATE_TYPE1= 1 and T2.M_BROK_IND1 = 4) then 'Interpolated'
		 else ' '
	end as StubPeriodRate1,
	
	case when (T3.M_BRK2_COUP0= 0) then 'Short Coupon'
		when (T3.M_BRK2_COUP0= 1) then 'Long Coupon'
		when (T3.M_BRK2_COUP0= 3) then 'Full Coupon'
	end as Coupon,

	case when T1.M_NB_LEG <> 3  then ' '
		 when (T2.M_RATE_TYPE1= 1 and T2.M_BRK2_IND1 = 0) then 'Current index'
		 when (T2.M_RATE_TYPE1= 1 and T2.M_BRK2_IND1 = 1) then 'Closest index'
		 when (T2.M_RATE_TYPE1= 1 and T2.M_BRK2_IND1 = 2) then 'Next index'
		 when (T2.M_RATE_TYPE1= 1 and T2.M_BRK2_IND1 = 3) then 'Previous index'
		 when (T2.M_RATE_TYPE1= 1 and T2.M_BRK2_IND1 = 4) then 'Interpolated'
		 else ' '
	end as StubPeriodRate2,
	
/* Stub period characteristics Interest ###end### */

/* Accrual & Yield conventions Interest ###start### */
	case	when (T2.M_ACC_METH0 = 0 ) then 'Use interest convention'  
		when (T2.M_ACC_METH0 = 1 ) then 'Specific convention'
		when (T2.M_ACC_METH0 = 2 ) then 'External'  
		when (T2.M_ACC_METH0 = 3 ) then 'Prorate interest'
	end as AccrualMethod, 
	T2.M_ACC_CONV0 as AccrualConvention,
	case	when (T2.M_ACC_ROUND0 = 0) then 'None' 
		when (T2.M_ACC_ROUND0 = 1) then 'Nearest' 
		when (T2.M_ACC_ROUND0 = 2) then 'By default' 
		when (T2.M_ACC_ROUND0 = 3) then 'By excess' 
	end as AccrualRoundingRule,
	case when (T2.M_ACC_ROUND0 = 0) then ' ' else to_char(T2.M_ACC_DEC0) end as AccrualDecimals, 
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
		 when (T2.M_YLD_CALC0 = 15 ) then 'AIBD (Effective flows)'
		 when (T2.M_YLD_CALC0 = 16 ) then 'Specific convention cristalized'
		 when (T2.M_YLD_CALC0 = 17 ) then 'Korean (Effective flows + Linear stub)'
		 when (T2.M_YLD_CALC0 = 18 ) then 'Thai'
		 when (T2.M_YLD_CALC0 = 19 ) then 'IAB'
		 when (T2.M_YLD_CALC0 = 20 ) then 'Multiplicative Discount margin'
		 when (T2.M_YLD_CALC0 = 21 ) then 'Specific convention (indexed bond)'
		 when (T2.M_YLD_CALC0 = 50) then 'External'
		end as YielCalculation, 
	T2.M_YLD_CONV0 as YielConvention, 
	case when T2.M_YLD_CALC0 not in (1, 16, 20, 21) then ' '
		 else (case when (T2.M_YLD_SCHED0 = 0) then 'Anniversary schedule' 
				when (T2.M_YLD_SCHED0 = 1) then 'Payment schedule' 
				end) 
		end as  YieldSchedule,
	case when ((T2.M_RATE_TYPE1= 0) and (T2.M_YLD_CALC0 = 0 ) and( T2.M_YLD_FREQ0 = 0)) then 'at coupon frequency (standard)' 
		 when ((T2.M_RATE_TYPE1= 0) and (T2.M_YLD_CALC0 = 0 ) and( T2.M_YLD_FREQ0 = 1)) then 'Annual compounding'
		 else ' '
		 end as YieldFrequency, 		
	case when ( T2.M_GC_ACC0 = 0) then 'Standard' 
		 when ( T2.M_GC_ACC0 = 1) then 'Specific convention' 
		 end as GrossToCleanAccrual,
	T2.M_GC_ACCCNV0 as GrossToCleanConvention,
	case when ( T2.M_ALT_YL0 = 0 ) then 'No' 
		 when ( T2.M_ALT_YL0 = 1 ) then 'During last period'
		 when ( T2.M_ALT_YL0 = 2 ) then 'During last year'
		 when ( T2.M_ALT_YL0 = 3 ) then 'During last period + ExDiv'
	end as AltrntYield ,
	T2.M_ALT_YLCNV0 as AlternateYieldConvention,
case when (mod (T2.M_LNGN_FLGS1, 65536) <65536) and (mod (T2.M_LNGN_FLGS1, 131072) >= 65536) then 'Time to next coupon'
	when (mod (T2.M_LNGN_FLGS1, 16) <16) and (mod (T2.M_LNGN_FLGS1, 32) >= 16) then 'DV01 approach'
else 'Macaulay'
end as Duration,

/* Accrual & Yield conventions Interest ###end### */


	case when (T2.M_INDEXED1 =0) then 'No'
		when (T2.M_INDEXED1 =1) then 'Yes'
	end as Indexed,
	case when (mod (T2.M_LNGN_FLGS1, 8) < 8 and mod (T2.M_LNGN_FLGS1, 16) >=8) then  
		case when (mod (T2.M_LNGN_FLGS1, 536870912 ) < 536870912 and mod (T2.M_LNGN_FLGS1, 1073741824) >=536870912) then 'Floating indexation' 
			when (mod (T2.M_LNGN_FLGS1,  536870912 ) < 536870912 and mod ( T2.M_LNGN_FLGS1, 1073741824) >=536870912) and (mod(T2.M_LNGN_FLGS1, 268435456) < 268435456 and mod (T2.M_LNGN_FLGS1, 536870912) >=268435456) then 'Formula'
			else 'Fixed Indexation' end 
	else ' ' end as MultiCurrIndex,
	case when to_number (T2.M_INDEXED1) =1 and ( T2.M_INTRS_CUR1 <> ' ' or  T2.M_INTRM_CUR1 <> ' ' or T2.M_FINAL_CUR1 <> '  ')  then 'Yes' else 'No' end as MultiCurrency,
	case when T2.M_LNGN_SFLGS1 = 0 then 'No'
		when T2.M_LNGN_SFLGS1 =128 then 'Yes'
	end as InterestRoundings,
	case when to_number (T2.M_INDEXED1) =1 then T2.M_INTRS_CUR1 else ' ' end as IntflowCurr,
	case when to_number (T2.M_INDEXED1) =1 then T2.M_INTRM_CUR1 else ' ' end as InterCapCurr,
	case when to_number (T2.M_INDEXED1) =1 then T2.M_FINAL_CUR1 else ' ' end as FinalCapCurr,

	/* Collateral - Treat collateral = 'On pool level'   ###start### */	
	
	case when (mod(T3.M_LNGN_FLGS0, 8) <8 and mod(T3.M_LNGN_FLGS0, 16) >=8) then 'Marked to market' 
		when (mod(T3.M_LNGN_FLGS0, 16384) < 16384 and mod (T3.M_LNGN_FLGS0, 32768) >=16384) then 'Based on reset prices'
		when (mod(T3.M_LNGN_FLGS0, 8192) < 8192 and mod (T3.M_LNGN_FLGS0, 16384) >=8192) then 'Independent amount' 
		else 'Based on initial prices' end as MarkedtoMarketCol,
		
	case when T1.M_NB_LEG <> 3  then ' ' 
		when (T3.M_RATE_TYPE0  = 0) then 'Fixed rate' 
		when (T3.M_RATE_TYPE0= 1) then 'Floating rate' 
	end as RateTypeCol,
	case when T1.M_NB_LEG <> 3  then ' ' else T3.M_START0 end as StartDelayCol,
	case when T1.M_NB_LEG <> 3  then ' ' else T3.M_PAY_CLN0 end as PaymentCalendarCol,
	case when T1.M_NB_LEG <> 3 or T3.M_RATE_TYPE0 <> 1 then ' ' else T3.M_FIX_CLN0 end as FixingCalendarCol,
	case when T1.M_NB_LEG <> 3  then ' ' 
		when ((T3.M_RATE_TYPE0= 1) and (T3.M_FIXING0 = 0 )) then 'Up front'
		when ((T3.M_RATE_TYPE0= 1) and (T3.M_FIXING0 = 1 )) then 'In arrears'
		else ' ' 
	end as FixingCol,
	
	case when T1.M_NB_LEG <> 3  then ' ' 
		 when (T3.M_PAYMENT0 = 0) 	then 'In arrears' 
		 when  (T3.M_PAYMENT0 = 1) then 'Up front'
		 when (T3.M_PAYMENT0 = 2) then 'Up front disc.'
	end as PaymentCol,
	
	case when T1.M_NB_LEG <> 3  then ' '
		 when ((T3.M_PAYMENT0 = 2) and (T3.M_DISC_RATE0 =0)) then 'Floating rate'
		 when ((T3.M_PAYMENT0 = 2) and (T3.M_DISC_RATE0 =1)) then 'Fixed rate'
		 when ((T3.M_PAYMENT0 = 2) and (T3.M_DISC_RATE0 =2)) then 'Specific index'
		 when ((T3.M_PAYMENT0 = 2) and (T3.M_DISC_RATE0 =3)) then 'Current leg'
		 when ((T3.M_PAYMENT0 = 2) and (T3.M_DISC_RATE0 =4)) then 'Specific leg'
		 when ((T3.M_PAYMENT0 = 2) and (T3.M_DISC_RATE0 =5)) then 'Fixing'
		 else ' '
	end as DiscountingRateCol,
	
	case when T1.M_NB_LEG <> 3  then ' ' 
		when ((T3.M_PAYMENT1 = 2) and (T3.M_DISC_RATE1 =2)) then T3.M_DISC_IND1 
		else ' ' 
	end as DiscountingIndexCol,
	case when T1.M_NB_LEG <> 3  then ' ' 
		when ((T3.M_PAYMENT1 = 2) and (T3.M_DISC_RATE1 =4)) then to_char(T3.M_DISC_LEG1) 
		else ' ' 
	end as DiscountingLegCol,
	case when T1.M_NB_LEG <> 3  then ' ' else T3.M_RATE_CONV1 end as RateConvCol,
	
	case when T1.M_NB_LEG <> 3  then ' ' 
		 when (T3.M_ROUND_RUL0 = 0) then 'None' 
		 when (T3.M_ROUND_RUL0 = 1) then 'Nearest' 
		 when (T3.M_ROUND_RUL0 = 2) then 'By default' 
		 when (T3.M_ROUND_RUL0 = 3) then 'By excess' 
	end as RoundingRuleCol,
	case when T1.M_NB_LEG <> 3  then ' '
		 when (T3.M_ROUND_RUL0 = 0) then ' ' 
		else to_char(T3.M_DECIMALS0) 
	end as DecimalsCol,
	
	case when T1.M_NB_LEG <> 3  then ' '
		 when (T3.M_AMORT0 = 0 ) then 'None'
		 when (T3.M_AMORT0 = 1 ) then 'Linear (rate)'
		 when (T3.M_AMORT0 = 2 ) then 'Constant'
		 when (T3.M_AMORT0 = 3 ) then 'Constant annuities' 
		 when (T3.M_AMORT0 = 4 ) then 'Constant number of shares'
		 when (T3.M_AMORT0 = 5 ) then 'Coupon reinvestment'
		 when (T3.M_AMORT0 = 6 ) then 'Constant annuities (r)' 
		 when (T3.M_AMORT0 = 7 ) then 'Linear (amount)' 
		 when (T3.M_AMORT0 = 8 ) then 'Dividends reinvestment (in new shares)'
	end as AmortizingCol,
	
	case when T1.M_NB_LEG <> 3  then ' ' 
		 when (T3.M_EP_TYPE0 = 0) then 
		(case 	when (T3.M_MRG_CMP0=0) then '(I+M) at (I+M)'
			when (T3.M_MRG_CMP0=1) then '(I+M) at I'
			when (T3.M_MRG_CMP0=2) then '(I at I) + M'
			when (T3.M_MRG_CMP0=3) then 'I at (I+M)'			
			when (T3.M_MRG_CMP0=4) then 'I at (I+M) + M'
			when (T3.M_MRG_CMP0=5) then 'No compounding'
			when (T3.M_MRG_CMP0=6) then '(I+M1) at (I+M2)'
			when (T3.M_MRG_CMP0=8) then '(I+M) at C'
		end) 
		else ' ' 
	end as CompoundingCol,

	/* Schedules definition - Collateral ###start### */

	case when T1.M_NB_LEG <> 3  then ' '
		when (T3.M_ECP_TYPE0 = 0) then 'Driving schedule' 
		when (T3.M_ECP_TYPE0 = 1) then 'Equal to'
		when  (T3.M_ECP_TYPE0 = 2) then 'Deduced from'
	end as CalcStartSch1Col, 
	case when T1.M_NB_LEG <> 3  then ' ' 
		when (T3.M_ECP_TYPE0=0) then ' '
		when (T3.M_ECP_UNDRL0 = -1) then ' ' 
		when (T3.M_ECP_UNDRL0= 0) then 'Payment schedule'
		when (T3.M_ECP_UNDRL0= 7) then 'Calculation end schedule'
		when (T3.M_ECP_UNDRL0 = 8) then 'Fixing schedule'
	end as CalcStartSch2Col, 
	case when T1.M_NB_LEG <> 3  then ' '
		 when T3.M_ECP_TYPE0 in (0, 2) then T3.M_ECP0 
		 else ' ' 
	end as CalcStartSch3Col,
	case when T1.M_NB_LEG <> 3  then ' '
		when (T3.M_ECPE_TYPE0 = 0) then 'Driving schedule' 
		when (T3.M_ECPE_TYPE0 = 1) then 'Equal to'
		when (T3.M_ECPE_TYPE0 = 2) then 'Deduced from'
	end as CalcEndSch1Col, 
	case when T1.M_NB_LEG <> 3  then ' '
		when (T3.M_ECPE_UNDR0 = -1) then ' ' 
		when (T3.M_ECPE_UNDR0 = 0) then 'Payment schedule'
		when (T3.M_ECPE_UNDR0 = 1) then 'Calculation start schedule'
		when (T3.M_ECPE_UNDR0 = 2) then 'Fixing schedule'
	end as CalcEndSch2Col, 
	case when T1.M_NB_LEG <> 3  then ' ' 
		when T3.M_ECPE_TYPE0 = 2 then T3.M_ECPE0 
		else ' ' 
	end as CalcEndSch3Col,
	
	case when T1.M_NB_LEG <> 3  then ' ' 
		when T3.M_EP_TYPE0 = 0 then 'Driving Schedule'
		when T3.M_EP_TYPE0= 1 then 'Equal to'
		when T3.M_EP_TYPE0=2 then 'Deduced from'
	end as PaymentSch1Col,
	case when T1.M_NB_LEG <> 3  then ' ' 
		when (T3.M_EP_TYPE0 in (1,2) and T3.M_EP_UNDRL0 =1) then 'Calculation start schedule'
		when (T3.M_EP_TYPE0 in (1,2) and T3.M_EP_UNDRL0 =2) then 'Fixing schedule'
		when (T3.M_EP_TYPE0 in (1,2) and T3.M_EP_UNDRL0=7 ) then 'Calculation end schedule'
		else ' '
	end as PaymentSch2Col,
	case when T1.M_NB_LEG <> 3  then ' ' 
		when T3.M_EP_TYPE0 <> 1 then T3.M_EP0 
		else ' ' 
	end as PaymentSch3Col,
	case when T1.M_NB_LEG <> 3  then ' ' 
		when (T3.M_EP_FREQ0 = -1 and T3.M_SIMP_SCH0 = 0) then 'Zero coupon'
		when (T3.M_EP_FREQ0 = -2  and T3.M_SIMP_SCH0 = 0) then 'Formula adjusted'
		when (T3.M_EP_FREQ0 not in (-1, -2) and (T3.M_SIMP_SCH0 = 0)) then 'Frequency ratio'
		else ' '
	end as PaymentFreq1Col,
	case when T1.M_NB_LEG <> 3  then ' ' 
		when ((T3.M_EP_TYPE0 in (1,2)) and (T3.M_SIMP_SCH0 = 0) and T3.M_EP_FREQ0 not in (-1, -2)) then to_char(T3.M_EP_FREQ0)
		else ' ' 
	end as PaymentFreq2Col,

	case when T1.M_NB_LEG <> 3  then ' '
		when T3.M_EI_TYPE0 = 0 then 'Driving Schedule'
		when T3.M_EI_TYPE0 = 1 then 'Equal to'
		when T3.M_EI_TYPE0 = 2 then 'Deduced from'
	end as FixingSchd1Col,
	case when T1.M_NB_LEG <> 3  then ' '
		 when (T3.M_EI_TYPE0 in (1, 2) and T3.M_EI_UNDRL0 =0) then 'Payment schedule'
		 when (T3.M_EI_TYPE0 in (1, 2) and T3.M_EI_UNDRL0 =1) then 'Calculation start schedule'
		 when (T3.M_EI_TYPE0 in (1, 2) and T3.M_EI_UNDRL0 =7) then 'Calculation end schedule'
		 else ' ' 
	end as FixingSchd2Col,
	case when T1.M_NB_LEG <> 3  then ' ' 
		when T3.M_EI_TYPE0 <> 1 then T3.M_EI0 
		else ' ' 
	end as FixingSchd3Col,
		case when T1.M_NB_LEG <> 3  then ' ' 
		when (T3.M_EI_FREQ0 = -1 and T3.M_SIMP_SCH0 = 0) then 'Zero coupon'
		when (T3.M_EI_FREQ0 = -2  and T3.M_SIMP_SCH0 = 0) then 'Automatic cmp.'
		when (T3.M_EI_FREQ0 not in (-1, -2) and (T3.M_SIMP_SCH0 = 0)) then 'Frequency ratio'
		else ' '
	end as FixingFreq1Col,
	case when T1.M_NB_LEG <> 3  then ' ' 
		when ((T3.M_EI_TYPE0 in (1,2)) and (T3.M_SIMP_SCH0 = 0) and T3.M_EI_FREQ0 not in (-1, -2)) then to_char(T3.M_EI_FREQ0)
		else ' ' 
	end as FixingFreq2Col,

	case when T1.M_NB_LEG <> 3  then ' ' 
		when (T3.M_FOLW_FXNG0=0) then 'No (time series)'
		when (T3.M_FOLW_FXNG0=1) then 'Yes (time series)'
		when (T3.M_FOLW_FXNG0=2) then 'No (published)'
		when (T3.M_FOLW_FXNG0=3) then 'Yes (published)'
	end as CalcFixCol,
	case when T1.M_NB_LEG <> 3  then ' ' 
		when (T3.M_SIMP_SCH0 = 0) then 'No'
		when (T3.M_SIMP_SCH0 = 1) then 'Yes'
	end as SinglePeriodCol,
	case when T1.M_NB_LEG <> 3  then ' ' 
		when (mod(T3.M_LNGN_FLGS1, 2097152 ) < 2097152 and mod(T3.M_LNGN_FLGS1, 4194304) >=2097152) then 'Maturity adjustment modfol' 
		else 'No maturity adjustment' 
	end as SinglePeriodMatCol,

/* Schedules definition - Collateral ###end### */
	
	/* Stub period characteristics Collateral ###Start### */
	
	case when T1.M_NB_LEG <> 3  then ' '
		 when (T3.M_RATE_TYPE0= 1 and T3.M_BROK_IND0 = 0) then 'Current index'
		 when (T3.M_RATE_TYPE0= 1 and T3.M_BROK_IND0 = 1) then 'Closest index'
		 when (T3.M_RATE_TYPE0= 1 and T3.M_BROK_IND0 = 2) then 'Next index'
		 when (T3.M_RATE_TYPE0= 1 and T3.M_BROK_IND0 = 3) then 'Previous index'
		 when (T3.M_RATE_TYPE0= 1 and T3.M_BROK_IND0 = 4) then 'Interpolated'
		 else ' '
	end as StubPeriodRate1Col,
	
	case when T1.M_NB_LEG <> 3  then ' ' 
		when (T3.M_BRK2_COUP0= 0) then 'Short Coupon'
		when (T3.M_BRK2_COUP0= 1) then 'Long Coupon'
		when (T3.M_BRK2_COUP0= 3) then 'Full Coupon'
		end as CouponCol,
		
	case when T1.M_NB_LEG <> 3  then ' '
		 when (T3.M_RATE_TYPE0= 1 and T3.M_BRK2_IND0 = 0) then 'Current index'
		 when (T3.M_RATE_TYPE0= 1 and T3.M_BRK2_IND0 = 1) then 'Closest index'
		 when (T3.M_RATE_TYPE0= 1 and T3.M_BRK2_IND0 = 2) then 'Next index'
		 when (T3.M_RATE_TYPE0= 1 and T3.M_BRK2_IND0 = 3) then 'Previous index'
		 when (T3.M_RATE_TYPE0= 1 and T3.M_BRK2_IND0 = 4) then 'Interpolated'
		 else ' '
	end as StubPeriodRate2Col,

/* Stub period characteristics Collateral ###end### */

/* Accrual & Yield conventions Collateral ###start### */

case when T1.M_NB_LEG <> 3  then ' '	
		when (T3.M_ACC_METH0 = 0 ) then 'Use interest convention'  
		when (T3.M_ACC_METH0 = 1 ) then 'Specific convention'
		when (T3.M_ACC_METH0 = 2 ) then 'External'  
		when (T3.M_ACC_METH0 = 3 ) then 'Prorate interest'
	end as AccrualMethodCol, 
	case when T1.M_NB_LEG <> 3  then ' ' else T3.M_ACC_CONV0 end as AccrualConventionCol,
	case when T1.M_NB_LEG <> 3  then ' '
		 when (T3.M_ACC_ROUND0 = 0) then 'None' 
		 when (T3.M_ACC_ROUND0 = 1) then 'Nearest' 
		 when (T3.M_ACC_ROUND0 = 2) then 'By default' 
		 when (T3.M_ACC_ROUND0 = 3) then 'By excess' 
	end as AccrualRoundingRuleCol,
	case when T1.M_NB_LEG <> 3  then ' '
		when (T3.M_ACC_ROUND0 = 0) then ' ' 
		else to_char(T3.M_ACC_DEC0) 
	end as AccrualDecimalsCol, 
	case when T1.M_NB_LEG <> 3  then ' '
		 when (T3.M_ACC_RMODE0 =0 ) then 'Standard' 
		 when (T3.M_ACC_RMODE0 =1) then 'Ex-dividend' 
         When (T3.M_ACC_RMODE0 =2) then 'Always applied to fraction'
	end as AccrualRoundingModeCol,
	case when T1.M_NB_LEG <> 3  then ' '
		 when (T3.M_YLD_CALC0 = 0 ) then 'AIBD' 
		 when (T3.M_YLD_CALC0 = 1) then 'Specific convention'
		 when (T3.M_YLD_CALC0 = 2 ) then 'Moosmuller'
		 when (T3.M_YLD_CALC0 = 3 ) then 'Braess-Fangmeyer'
		 when (T3.M_YLD_CALC0 = 4) then 'Simple yield'
		 when (T3.M_YLD_CALC0 = 5 ) then 'Discount margin'
		 when (T3.M_YLD_CALC0 = 6) then 'Btp'
		 when (T3.M_YLD_CALC0 = 7) then 'Perpetual'
		 when (T3.M_YLD_CALC0 = 8) then 'Sobretasa'
		 when (T3.M_YLD_CALC0 = 9 ) then 'Stripped yield'
		 when (T3.M_YLD_CALC0 = 10) then 'Linear Sobretasa'
		 when (T3.M_YLD_CALC0 = 11) then 'CPI' 
		 when (T3.M_YLD_CALC0 = 12) then 'LFT'
		 when (T3.M_YLD_CALC0 = 14 ) then 'Discount margin (indexed bond)'
		 when (T3.M_YLD_CALC0 = 15 ) then 'AIBD (Effective flows)'
		 when (T3.M_YLD_CALC0 = 16 ) then 'Specific convention cristalized'
		 when (T3.M_YLD_CALC0 = 17 ) then 'Korean (Effective flows + Linear stub)'
		 when (T3.M_YLD_CALC0 = 18 ) then 'Thai'
		 when (T3.M_YLD_CALC0 = 19 ) then 'IAB'
		 when (T3.M_YLD_CALC0 = 20 ) then 'Multiplicative Discount margin'
		 when (T3.M_YLD_CALC0 = 21 ) then 'Specific convention (indexed bond)'
		 when (T3.M_YLD_CALC0 = 50) then 'External'
		end as YieldCalculationCol, 
	case when T1.M_NB_LEG <> 3  then ' ' else T3.M_YLD_CONV0 end as YielConventionCol, 
	case when T3.M_YLD_CALC0 not in (1, 16, 20, 21) then ' '
		 else  	(case when (T3.M_YLD_SCHED0 = 0) then 'Anniversary schedule' 
					when (T3.M_YLD_SCHED0 = 1) then 'Payment schedule' 
					end) end as  YieldScheduleCol,
	case when T1.M_NB_LEG <> 3  then ' '
		 when ((T3.M_RATE_TYPE1= 0) and (T3.M_YLD_CALC0 = 0 ) and( T3.M_YLD_FREQ0 = 0)) then 'at coupon frequency (standard)' 
		 when ((T3.M_RATE_TYPE1= 0) and (T3.M_YLD_CALC0 = 0 ) and( T3.M_YLD_FREQ0 = 1)) then 'Annual compounding'
		 else ' '
		 end as YieldFrequencyCol, 		
	case when T1.M_NB_LEG <> 3  then ' '
		 when ( T3.M_GC_ACC0 = 0) then 'Standard' 
		 when ( T3.M_GC_ACC0 = 1) then 'Specific convention' 
		 end as GrossToCleanAccrualCol,
	case when T1.M_NB_LEG <> 3  then ' ' else T3.M_GC_ACCCNV0 end as GrossToCleanConventionCol,
	case when T1.M_NB_LEG <> 3  then ' '
		 when ( T3.M_ALT_YL0 = 0 ) then 'No' 
		 when ( T3.M_ALT_YL0 = 1 ) then 'During last period'
		 when ( T3.M_ALT_YL0 = 2 ) then 'During last year'
		 when ( T3.M_ALT_YL0 = 3 ) then 'During last period + ExDiv'
	end as AltrntYieldCol ,
	case when T1.M_NB_LEG <> 3  then ' ' else T3.M_ALT_YLCNV0 end as AlternateYieldConventionCol,
	case when T1.M_NB_LEG <> 3  then ' '
		 when (mod(T3.M_LNGN_FLGS0, 65536) <65536) and (mod(T3.M_LNGN_FLGS0, 131072) >= 65536) then 'Time to next coupon'
		 when (mod (T3.M_LNGN_FLGS0, 16) <16) and (mod(T3.M_LNGN_FLGS0, 32) >= 16) then 'DV01 approach'
		 else 'Macaulay'
	end as DurationCol,
/* Accrual & Yield conventions Collateral ###end### */
	
	case when T1.M_NB_LEG <> 3  then ' ' 
		when (T3.M_INDEXED0 =0) then 'No'
		when (T3.M_INDEXED0 =1) then 'Yes'
	end as IndexedSecurityCol,
	
	case when T1.M_NB_LEG <> 3  then ' ' 
		when to_number (T3.M_INDEXED0) =1 and ( T3.M_INTRS_CUR0 <>' ' or  T3.M_INTRM_CUR0 <> ' ' or T3.M_FINAL_CUR0 <> '  ')  then 'Yes' 
		else 'No' 
	end as MultiCurrencyCol,

	/* Collateral - Treat collateral = 'On pool level'   ###end### */	
		
	
/* Interest-Collateral ###end### */

/* Indexation - Indexed and FeesNominal (Marked to market) ###start### */	
	case when (T4.M_TYPE is NULL) then ' '
		 when (T4.M_TYPE=0)  then 'Interest flows'
		 when (T4.M_TYPE=1)  then 'Fixings'
		 when (T4.M_TYPE=8)  then 'Strikes'
		 when (T4.M_TYPE=2)  then 'Margins'
		 when (T4.M_TYPE=3)  then 'Interest rates'
		 when (T4.M_TYPE=4)  then 'Initial capital'
		 when (T4.M_TYPE=5)  then 'Intermediate capital'
		 when (T4.M_TYPE=6)  then 'Final capital'
		 when (T4.M_TYPE=7)  then 'Outstanding capital'
		 when (T4.M_TYPE=9)  then 'Dividends'
		 when (T4.M_TYPE=10) then 'Tax Credit'
		 when (T4.M_TYPE=12) then 'Recovery nominal'
		 when (T4.M_TYPE=13) then 'Cap strikes'
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
		 else to_char (T4.M_IND_NAT)
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
	case when (T4.M_FREQ is NULL) then ' ' else to_char (T4.M_FREQ) end as FrequencyRatio,
	case when (T4.M_DATE_POS is NULL) then ' ' 
	when (T4.M_DATE_POS=0) then 'Unchecked'
	when (T4.M_DATE_POS=1) then 'Checked'
	end as UpFront,
	case when (T4.M_FACTOR is NULL) then ' ' else to_char (T4.M_FACTOR) end as IndexationFactor,
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
/* Indexation - Indexed and FeesNominal (Marked to market) ###end### */


from RT_INSGN_DBF T1
left join RT_LNGN_DBF T2 on T1.M_GEN_NUM = T2.M_GEN_NUM
left join RT_LNGN_DBF T3 on T1.M_GEN_NUM = T3.M_GEN_NUM
left outer join RT_LNDXG_DBF T4 on T2.M_GEN_NUM=T4.M_GEN_NUM
left outer join RT_INDEX_DBF T5 on T4.M_INDEX=T5.M_INDEX
left outer join RT_INDEX_DBF T6 on T2.M_INDEX0=T6.M_INDEX
where  T1.M_INSTR_TYPE = 26
and T1.M_GEN_NUM = T2.M_GEN_NUM
and T2.M_IDENTITY < T3.M_IDENTITY
and T1.M_CREAT_MODE=0

---------------------------------------------------------------------------------------- End of first part (Collateral)----------------------------------------------------------------------------------------

Union all


select T1.M_INSTR as ReturnSwapTemplate,
	T1.M_INSTR_DESC as Description,
	case when (T1.M_EVAL_MODE = 0) then 'Default'
		 when (T1.M_EVAL_MODE = 1) then 'Net Present Value'
		 when (T1.M_EVAL_MODE = 2) then 'Accrual'
		end as EvaluationMode,
		
	/* Evaluation Accrual fields (comon fileds) ###start### */
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
	case when M_FINCPDIR=0 then 'Quantity'
		when M_FINCPDIR=1 then 'Price'
		when M_FINCPDIR=3 then 'Nominal'
	end as Direction,
	case when M_NSC_HNDL=0 then 'In future cash' else 'In market value' end as NonSettCashHand,
	
	case when (T1.M_BROKEN =0 ) then 'Up front'
		 when (T1.M_BROKEN =1 ) then 'In arrears' 
		 when (T1.M_BROKEN=3 )  then 'Both ends (backward)'
		 when (T1.M_BROKEN = 5) then 'Both ends (forward)' 
	end as StubPosition,  -- 1ere case a gauche
/* Evaluation Accrual fields (common fields)  ###end### */ 

	case when T1.M_NB_LEG = 3 then 'On deal level' else ' On pool level' end as TreatCol,
	case when (mod(T1.M_FLAGS, 256 ) < 256 and mod (T1.M_FLAGS, 512) >=256) then 'No' else 'Yes' end as EarlySettlement,
	case when (mod(T1.M_FLAGS, 256 ) < 256 and mod(T1.M_FLAGS, 512) >=256) then 'Inherited from currency' 
		else case when (T1.M_SETTL_MOD=0) then 'Inherited from currency'
				when (T1.M_SETTL_MOD=1) then 'Specific delay' end 
		end as SettlementDelay,
	case when (mod(T1.M_FLAGS, 256 ) < 256 and mod(T1.M_FLAGS, 512) >=256) then ' '
		else case when (T1.M_SETTL_MOD=1) then T1.M_SETTL
			when (T1.M_SETTL_MOD=0) then ' ' end 
		end as SettDelayShfiter,
	case when M_GEN_VAL_S_MOD= 1 then 'Specific delay' else 'Inherited from security' end as ValuationShifterMode,
	case when M_GEN_VAL_S_MOD=1 then M_GEN_VAL_S else ' ' end as ValuationShifter,
	case when T2.M_REVOLV0 =1 then 'first in- first out'
		when T2.M_REVOLV0 =2 then 'Average price' 
	end as Liquidation,
	
	
/* Security */

	T2.M_START0 as StartDelaySec,

/* Schedules definition - Security ###start### */

	case when T2.M_EP_TYPE0 = 0 then 'Driving Schedule'
		when T2.M_EP_TYPE0= 1 then 'Equal to'
		when T2.M_EP_TYPE0=2 then 'Deduced from'
		when T2.M_EP_TYPE0=5 then 'Driving deduced schedule'
	end as PaymentSch1Sec,
	case when (T2.M_EP_TYPE0 in (1,2) and T2.M_EP_UNDRL0 =2) then 'Fixing start schedule'
		when (T2.M_EP_TYPE0 in (1,2) and T2.M_EP_UNDRL0=10 ) then 'Fixing end schedule'
		else ' '
	end as PaymentSch2Sec,
	case when T2.M_EP_TYPE0 <> 1 then T2.M_EP0 else ' ' end as PaymentSch3Sec,
	case when ((T2.M_EP_TYPE0 in (1,2)) and (T2.M_SIMP_SCH0 = 0)) then to_char(T2.M_EP_FREQ0)
		else ' ' 
	end as PaymentFreqSec,
	
	case when T2.M_EI_TYPE0 = 0 then 'Driving Schedule'
		when T2.M_EI_TYPE0 = 1 then 'Equal to'
		when T2.M_EI_TYPE0 = 2 then 'Deduced from'
		when T2.M_EI_TYPE0 = 5 then 'Driving deduced schedule'
	end as FixingStartSchd1Sec,
	case when (T2.M_EI_TYPE0 in (1, 2) and T2.M_EI_UNDRL0 =2) then 'Payment schedule'
		 when (T2.M_EI_TYPE0 in (1, 2) and T2.M_EI_UNDRL0 =10) then 'Fixi9ng end schedule'
		 else ' ' 
	end as FixingStartSchd2Sec,
	case when T2.M_EI_TYPE0 <> 1 then T2.M_EI0 else ' ' end as FixingStartSchd3Sec,
		case when ((T2.M_EI_TYPE0 in (1,2)) and (T2.M_SIMP_SCH0 = 0)) then to_char(T2.M_EI_FREQ0)
		else ' ' 
	end as FixingStartFreqSec,
	
	case when T2.M_EIE_TYPE0 =1 then 'Equal to'
		when T2.M_EIE_TYPE0 =2 then 'Deduced from'
	end as FixingEndSchd1Sec,
	case when  T2.M_EIE_UNDRL0 =0 then 'Payment schedule'
		when T2.M_EIE_UNDRL0 =2 then 'Fixing start schedule'
	end as FixingEndSchd2Sec,
	case when T2.M_EIE_TYPE0 =2 then T2.M_EIE0 else ' ' end as FixingEndSchd3Sec,
	case when (T2.M_EIE_FREQ0 = -1 and T2.M_SIMP_SCH0 = 0) then 'Zero coupon'
		when (T2.M_EIE_FREQ0 = -2  and T2.M_SIMP_SCH0 = 0) then 'Automatic cmp.'
		when (T2.M_EIE_FREQ0 not in (-1, -2) and (T2.M_SIMP_SCH0 = 0)) then 'Frequency ratio'
		else ' '
	end as FixingEndFreq1Sec,
	case when (T2.M_EIE_FREQ0 not in (-1, -2) and (T2.M_SIMP_SCH0 = 0)) then to_char(T2.M_EIE_FREQ0) else ' ' end as FixingEndFreq2Sec,
	
	case when (T2.M_FOLW_FXNG0=0) then 'No (time series)'
		when (T2.M_FOLW_FXNG0=1) then 'Yes (time series)'
		when (T2.M_FOLW_FXNG0=2) then 'No (published)'
		when (T2.M_FOLW_FXNG0=3) then 'Yes (published)'
	end as CalcFixSec,
	case when (T2.M_SIMP_SCH0 = 0) then 'No'
		when (T2.M_SIMP_SCH0 = 1) then 'Yes'
	end as SinglePeriodSec,
	case when (mod (T2.M_LNGN_FLGS1, 2097152) < 2097152 and mod (T2.M_LNGN_FLGS1, 4194304) >=2097152) 
			then 'Maturity adjustment modfol' else 'No maturity adjustment' 
	end as SinglePeriodMatSec,
/* Schedules definition - Security ###end### */

/* Dividends-Tax credit fields ###start### */
	case when (mod (T2.M_LNGN_FLGS0, 131072 ) < 131072 and mod (T2.M_LNGN_FLGS0, 262144) >=131072) then 'In market value' else 'In future cash' end as DivTaxHandling,
	T2.M_DIV_PFRAC0 as DivPayFrac,
	T2.M_DIV_RFRAC0 as DivReinvFrac,
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
		case when (mod (T2.M_LNGN_FLGS0,  2 ) < 2 and mod (T2.M_LNGN_FLGS0, 4) >=2) then 'Payment currency' else 'Security currency' end 
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
		case when ( mod (T2.M_LNGN_FLGS0, 2) < 2 and mod (T2.M_LNGN_FLGS0, 4) >=2) then 'Payment currency' else 'Security currency' end 
		when (T2.M_TC_PCR0 = 3) then 'Fees currency'
		when (T2.M_TC_PCR0 = 1) then 'Own currency'
		when (T2.M_TC_PCR0 = 2) then 'Other currency'
	end as TaxPayCurrency,
	case when (T2.M_TC_PCR0 = 2) then T2.M_TC_PCRL0
		else ' ' end as TaxOtherCurrency,
/* Dividends-Tax credit fields ###end### */

/* Performance-Return fields ###start### */
	case when (mod (T2.M_LNGN_FLGS0, 2 ) < 2 and mod (T2.M_LNGN_FLGS0, 4) >=2) then 
		case when (T2.M_RETDSCEV0 = 0) then 'Forward'
			when (T2.M_RETDSCEV0 = 1) then 'Discounting' end
		else ' ' end as ReturnEvalMode,
	case when ( mod (T2.M_LNGN_FLGS0, 2) < 2 and mod (T2.M_LNGN_FLGS0, 4) >=2) then 
		case when (T2.M_RETCRDEV0 = 0) then 'No'
			when (T2.M_RETCRDEV0 = 1) then 'Yes' end
		else ' ' end as ReturnCredit,
	case when ( mod (T2.M_LNGN_FLGS0, 2) < 2 and mod (T2.M_LNGN_FLGS0, 4) >=2) then 
		case when (T2.M_TR_TYP0 = 0) then 'Dirty price'
			when (T2.M_TR_TYP0 = 1) then 'Clean price' 
			when (T2.M_TR_TYP0 = 2) then 'Yield' end
		else ' ' end as ReturnBasedOn,
	case when (mod (T2.M_LNGN_FLGS0,  2 ) < 2 and mod (T2.M_LNGN_FLGS0, 4) >=2) then 
		case when (T2.M_RETINT0 = 0) then 'Return (P2-P1)/P1'
			when (T2.M_RETINT0 = 1) then 'Spread (P2-P1)' end
		else ' ' end as ReturnType,	
	case when ( mod (T2.M_LNGN_FLGS0, 2 ) < 2 and mod (T2.M_LNGN_FLGS0, 4) >=2) then 
		case when (T2.M_RETINRP0 = 0) then 'Piecewise'
			when (T2.M_RETINRP0 = 1) then 'Linear' 
			when (T2.M_RETINRP0 = 2) then 'Log linear' end
		else ' ' end as ReturnInterpol,
	case when (mod (T2.M_LNGN_FLGS0, 2) < 2 and mod (T2.M_LNGN_FLGS0, 4) >=2) then 
		case when (T2.M_PROTZ0 = 0) then 'Ignore'
			when (T2.M_PROTZ0 = 1) then 'Apply' end
		else ' ' end as ReturnDayCount,
	case when (mod (T2.M_LNGN_FLGS0, 2) < 2 and mod (T2.M_LNGN_FLGS0, 4) >=2) then T2.M_RSHIFT0
		else ' ' end as ReturnFixing,
/* Performance-Return fields ###end### */

	
	T2.M_PAY_CLN0 as PaymentCalendarSec,  -- Security
	T2.M_FIX_CLN0 as FixingCalendarSec,

	case when ( mod (T2.M_LNGN_FLGS0, 921602) < 921602 and mod (T2.M_LNGN_FLGS0, 1843204) >=921602) then 'Yes' else 'No' end as FixingTradeDate,
	
	/*Stub period Security  -start- */
	case when (T2.M_BROK_IND0 = 0) then 'Current index'
		 when (T2.M_BROK_IND0 = 1) then 'Closest index'
		 when (T2.M_BROK_IND0 = 2) then 'Next index'
		 when (T2.M_BROK_IND0 = 3) then 'Previous index'
		 when (T2.M_BROK_IND0 = 4) then 'Interpolated'
		 else ' '
	end as StubPeriodRate1Sec,	
	
	case when (T2.M_BROK_COUP0= 0) then 'Short Coupon'
		when (T2.M_BROK_COUP0= 1) then 'Long Coupon'
		when (T2.M_BROK_COUP0= 3) then 'Full Coupon'
		when (T2.M_BROK_COUP0= 4) then 'Conditional'
	end as CouponSec,

	case  when (T2.M_BRK2_IND0 = 0) then 'Current index'
		 when (T2.M_BRK2_IND0 = 1) then 'Closest index'
		 when (T2.M_BRK2_IND0 = 2) then 'Next index'
		 when (T2.M_BRK2_IND0 = 3) then 'Previous index'
		 when ( T2.M_BRK2_IND0 = 4) then 'Interpolated'
		 else ' '
	end as StubPeriodRate2Sec,
	
	/*Stub period Security  -end- */
	
	case when (T2.M_INDEXED0 =0) then 'No'
		when (T2.M_INDEXED0 =1) then 'Yes'
	end as IndexedSec,
	case when (mod(T1.M_FLAGS, 2048) < 2048 and mod(T1.M_FLAGS, 4096) >=2048) then 'Yes' else 'No' end as MultiCurrencyProp,
	case when T2.M_CMP_ROUND0= 0 then 'None'
		when T2.M_CMP_ROUND0=1 then 'Nearest'
		when T2.M_CMP_ROUND0=2 then 'By default'
		when T2.M_CMP_ROUND0= 3 then 'By excess'
	end as IntFlowsRnd,
	
	case when T2.M_LNGN_SFLGS1 = 0 then 'No'
		when T2.M_LNGN_SFLGS1 =128 then 'Yes'
	end as InterestRoundingsSec,
	
	case when T2.M_LNGN_SFLGS0 = 1152 then 'Yes' else 'No' end as NPVCurrencySec,
	
	
	case when T2.M_CMP_ROUND0 <>0 then to_char(T2.M_CMP_DEC0) else ' ' end as IntFlowsRndDec,

	
/* Interest-Collateral ###start### */

	 case when ( mod (T2.M_LNGN_FLGS1,  8) <8 and mod (T2.M_LNGN_FLGS1, 16) >=8) then 'Marked to market' 
		when (mod (T2.M_LNGN_FLGS1,  16384) < 16384 and mod (T2.M_LNGN_FLGS1, 32768) >=16384) then 'Based on reset prices'
		when (mod (T2.M_LNGN_FLGS1,  8192) < 18192 and mod (T2.M_LNGN_FLGS1, 16384) >=8192) then 'Independent amount' 
		else 'Based on reset prices' end as MarkedtoMarket, -- interest
	case when (T2.M_RATE_TYPE1  = 0) then 'Fixed rate' 
		when (T2.M_RATE_TYPE1= 1) then 'Floating rate' 
		end as RateType,  --interest
	T2.M_START1 as StartDelay,  --interest
	T2.M_PAY_CLN1 as PaymentCalendar, --interest
	case when (T2.M_RATE_TYPE1= 1) then T2.M_FIX_CLN1
		else ' ' end as FixingCalendar,  --floating
	case when (T2.M_EP_TYPE1 = 0) then 
		(case 	when (T2.M_MRG_CMP1=0) then '(I+M) at (I+M)'
			when (T2.M_MRG_CMP1=1) then '(I+M) at I'
			when (T2.M_MRG_CMP1=2) then '(I at I) + M'
			when (T2.M_MRG_CMP1=3) then 'I at (I+M)'			
			when (T2.M_MRG_CMP1=4) then 'I at (I+M) + M'
			when (T2.M_MRG_CMP1=5) then 'No compounding'
			when (T2.M_MRG_CMP1=6) then '(I+M1) at (I+M2)'
			when (T2.M_MRG_CMP1=8) then '(I+M) at C'
		end) else ' ' end as Compounding,
	case when ((T2.M_RATE_TYPE1= 1) and (T2.M_FIXING1 = 0 )) then 'Up front'
		when ((T2.M_RATE_TYPE1= 1) and (T2.M_FIXING1 = 1 )) then 'In arrears'
		else ' ' end  as Fixing, --floating
	case when (T2.M_PAYMENT1 = 0) 	then 'In arrears' 
		when  (T2.M_PAYMENT1 = 1) then 'Up front'
		when (T2.M_PAYMENT1 = 2) then 'Up front disc.'
		end as Payment,
	case when ((T2.M_PAYMENT1 = 2) and (T2.M_DISC_RATE1 =0)) then 'Floating rate'
		 when ((T2.M_PAYMENT1 = 2) and (T2.M_DISC_RATE1 =1)) then 'Fixed rate'
		 when ((T2.M_PAYMENT1 = 2) and (T2.M_DISC_RATE1 =2)) then 'Specific index'
		 when ((T2.M_PAYMENT1 = 2) and (T2.M_DISC_RATE1 =3)) then 'Current leg'
		 when ((T2.M_PAYMENT1 = 2) and (T2.M_DISC_RATE1 =4)) then 'Specific leg'
		 when ((T2.M_PAYMENT1 = 2) and (T2.M_DISC_RATE1 =5)) then 'Fixing'
		 else ' '
	end as DiscountRate,
	case when ((T2.M_PAYMENT1 = 2) and (T2.M_DISC_RATE1 =2)) then T2.M_DISC_IND1 else ' ' end as DiscountingIndex,
	case when ((T2.M_PAYMENT1 = 2) and (T2.M_DISC_RATE1 =4)) then to_char(T2.M_DISC_LEG1) else ' ' end as DiscountingLeg,
	T2.M_RATE_CONV1 as RateConvention,
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
	
	/* Schedules definition - Interest ###start### */
case when (T2.M_ECP_TYPE1 = 0) then 'Driving schedule' 
		when (T2.M_ECP_TYPE1 = 1) then 'Equal to'
		when  (T2.M_ECP_TYPE1 = 2) then 'Deduced from'
	end as CalcStartSch1, 
	case 	when (T2.M_ECP_TYPE1=0) then ' '
		when (T2.M_ECP_UNDRL1 = -1) then ' ' 
		when (T2.M_ECP_UNDRL1= 0) then 'Payment schedule'
		when (T2.M_ECP_UNDRL1= 7) then 'Calculation end schedule'
		when (T2.M_ECP_UNDRL1 = 8) then 'Delivery schedule'
	end as CalcStartSch2, 
	T2.M_ECP1 as CalcStartSch3,
	case 	when (T2.M_ECPE_TYPE1 = 1) then 'Equal to'
		when (T2.M_ECPE_TYPE1 = 2) then 'Deduced from'
	end as CalcEndSch1, 
	case 	when (T2.M_ECPE_UNDR1 = -1) then ' ' 
		when (T2.M_ECPE_UNDR1 = 0) then 'Payment schedule'
		when (T2.M_ECPE_UNDR1 = 1) then 'Calculation start schedule'
		when (T2.M_ECPE_UNDR1 = 8) then 'Delivery schedule'
	end as CalcEndSch2, 
	T2.M_ECPE1 as CalcEndSch3, 
	case 	when (T2.M_EP_TYPE1 = 0) then 'Driving schedule' 
		when (T2.M_EP_TYPE1 = 1) then 'Equal to'
		when  (T2.M_EP_TYPE1 = 2) then 'Deduced from'
	end as PaymentSch1,
	case 	when (T2.M_EP_UNDRL1 = -1) then ' '
		when (T2.M_EP_TYPE1=0) then ' ' 
		when (T2.M_EP_UNDRL1 = 1) then 'Calculation start schedule'
		when (T2.M_EP_UNDRL1= 7) then 'Calculation end schedule'
		when (T2.M_EP_UNDRL1 = 8) then 'Delivery schedule'
	end as PaymentSch2,
	T2.M_EP1 as PaymentSch3,
	case when (T2.M_EP_FREQ1 = -1 and T2.M_SIMP_SCH1 = 0) then 'Zero coupon'
		when (T2.M_EP_FREQ1 = -2  and T2.M_SIMP_SCH1 = 0) then 'Formula adjusted'
		when (T2.M_EP_FREQ1 not in (-1, -2) and (T2.M_SIMP_SCH1 = 0)) then 'Frequency ratio'
		else ' '
	end as PaymentFreq1,
	case when ((T2.M_EP_TYPE1 in (1,2)) and (T2.M_SIMP_SCH1 = 0)) then to_char(T2.M_EP_FREQ1)
		else ' ' end as PaymentFreq2,
		
	case	when ((T2.M_RATE_TYPE1= 1) and (T2.M_EI_TYPE1 = 0)) then 'Driving schedule'
		when ((T2.M_RATE_TYPE1= 1) and (T2.M_EI_TYPE1 = 1)) then 'Equal to'
		when ((T2.M_RATE_TYPE1= 1) and (T2.M_EI_TYPE1 = 2)) then 'Deduced from'
		else ' ' end as FixingSch1,
	case	when ((T2.M_EI_UNDRL1 = -1) or (T2.M_EI_UNDRL1 = 0))  then ' '
		when (T2.M_EI_TYPE1 =0) then ' '
		when ((T2.M_RATE_TYPE1= 1) and (T2.M_EI_UNDRL1= 1)) then 'Calculation start schedule'
		when ((T2.M_RATE_TYPE1= 1) and (T2.M_EI_UNDRL1 = 7)) then 'Calculation end schedule'
		when ((T2.M_RATE_TYPE1= 1) and (T2.M_EI_UNDRL1 = 0)) then 'Payment schedule'
		else ' ' end as FixingSch2,
	case	when ((T2.M_RATE_TYPE1= 1) and (T2.M_EI_TYPE1 = 0)) then to_char(T2.M_EI1)
		else ' ' end as FixingSch3,
		
	case when (T2.M_EI_FREQ1 = -1 and T2.M_SIMP_SCH1 = 0) then 'Zero coupon'
		when (T2.M_EI_FREQ1 = -2  and T2.M_SIMP_SCH1 = 0) then 'Automatic cmp.'
		when (T2.M_EI_FREQ1 not in (-1, -2) and (T2.M_SIMP_SCH1 = 0)) then 'Frequency ratio'
		else ' '
	end as FixingFreq1,
	case	when ((T2.M_RATE_TYPE1= 1) and (T2.M_EI_TYPE1 in (1,2)))then to_char(T2.M_EI_FREQ1)
		else ' ' end as FixingFreq2,
		
	case when (T2.M_FOLW_FXNG1=0) then 'No (time series)'
		when (T2.M_FOLW_FXNG1=1) then 'Yes (time series)'
		when (T2.M_FOLW_FXNG1=2) then 'No (published)'
		when (T2.M_FOLW_FXNG1=3) then 'Yes (published)'
		end as CalcFix,
	case when (T2.M_SIMP_SCH1 = 0) then 'No'
		when (T2.M_SIMP_SCH1 = 1) then 'Yes'
		end as SinglePeriod,
	case when (T2.M_SIMP_SCH1 = 1) then
		case when (mod (T2.M_LNGN_FLGS1,  2097152) < 2097152 and mod (T2.M_LNGN_FLGS1, 4194304) >=2097152) 
			then 'Maturity adjustment modfol' else 'No maturity adjustment' end 
		else ' ' end as SinglePeriodMat,
/* Schedules definition - Interest ###end### */


/* Schedules definition - Collateral ###start### */
	' ' as CalcStartSch1Col, 
	' ' as CalcStartSch2Col, 
	' ' as CalcStartSch3Col,
	' ' as CalcEndSch1Col, 
	' ' as CalcEndSch2Col, 
	' ' as CalcEndSch3Col,
	' ' as PaymentSch1Col,
	' ' as PaymentSch2Col,
	' ' as PaymentSch3Col,
	' ' as PaymentFreq1Col,
	' ' as PaymentFreq2Col,
	' ' as FixingSchd1Col,
	' ' as FixingSchd2Col,
	' ' as FixingSchd3Col,
	' ' as FixingFreq1Col,
	' ' as FixingFreq2Col,
	' ' as CalcFixCol,
	' ' as SinglePeriodCol,
	' ' as SinglePeriodMatCol,

/* Schedules definition - Collateral ###end### */
	
	
/* Stub period characteristics Interest ###start### */
	
	case when (T2.M_RATE_TYPE1= 1 and T2.M_BROK_IND1 = 0) then 'Current index'
		 when (T2.M_RATE_TYPE1= 1 and T2.M_BROK_IND1 = 1) then 'Closest index'
		 when (T2.M_RATE_TYPE1= 1 and T2.M_BROK_IND1 = 2) then 'Next index'
		 when (T2.M_RATE_TYPE1= 1 and T2.M_BROK_IND1 = 3) then 'Previous index'
		 when (T2.M_RATE_TYPE1= 1 and T2.M_BROK_IND1 = 4) then 'Interpolated'
		 else ' '
	end as StubPeriodRate1,	
	
	case 
		when (T2.M_BRK2_COUP0= 0) then 'Short Coupon'
		when (T2.M_BRK2_COUP0= 1) then 'Long Coupon'
		when (T2.M_BRK2_COUP0= 3) then 'Full Coupon'
	end as Coupon,

	case when T1.M_NB_LEG <> 3  then ' '
		 when (T2.M_RATE_TYPE1= 1 and T2.M_BRK2_IND1 = 0) then 'Current index'
		 when (T2.M_RATE_TYPE1= 1 and T2.M_BRK2_IND1 = 1) then 'Closest index'
		 when (T2.M_RATE_TYPE1= 1 and T2.M_BRK2_IND1 = 2) then 'Next index'
		 when (T2.M_RATE_TYPE1= 1 and T2.M_BRK2_IND1 = 3) then 'Previous index'
		 when (T2.M_RATE_TYPE1= 1 and T2.M_BRK2_IND1 = 4) then 'Interpolated'
		 else ' '
	end as StubPeriodRate2,
	
/* Stub period characteristics Interest ###end### */

/* Accrual & Yield conventions Interest ###start### */
	case	when (T2.M_ACC_METH0 = 0 ) then 'Use interest convention'  
		when (T2.M_ACC_METH0 = 1 ) then 'Specific convention'
		when (T2.M_ACC_METH0 = 2 ) then 'External'  
		when (T2.M_ACC_METH0 = 3 ) then 'Prorate interest'
	end as AccrualMethod, 
	T2.M_ACC_CONV0 as AccrualConvention,
	case	when (T2.M_ACC_ROUND0 = 0) then 'None' 
		when (T2.M_ACC_ROUND0 = 1) then 'Nearest' 
		when (T2.M_ACC_ROUND0 = 2) then 'By default' 
		when (T2.M_ACC_ROUND0 = 3) then 'By excess' 
	end as AccrualRoundingRule,
	case when (T2.M_ACC_ROUND0 = 0) then ' ' else to_char(T2.M_ACC_DEC0) end as AccrualDecimals, 
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
		 when (T2.M_YLD_CALC0 = 15 ) then 'AIBD (Effective flows)'
		 when (T2.M_YLD_CALC0 = 16 ) then 'Specific convention cristalized'
		 when (T2.M_YLD_CALC0 = 17 ) then 'Korean (Effective flows + Linear stub)'
		 when (T2.M_YLD_CALC0 = 18 ) then 'Thai'
		 when (T2.M_YLD_CALC0 = 19 ) then 'IAB'
		 when (T2.M_YLD_CALC0 = 20 ) then 'Multiplicative Discount margin'
		 when (T2.M_YLD_CALC0 = 21 ) then 'Specific convention (indexed bond)'
		 when (T2.M_YLD_CALC0 = 50) then 'External'
		end as YielCalculation, 
	T2.M_YLD_CONV0 as YielConvention, 
	case when T2.M_YLD_CALC0 not in (1, 16, 20, 21) then ' '
		 else (case when (T2.M_YLD_SCHED0 = 0) then 'Anniversary schedule' 
				when (T2.M_YLD_SCHED0 = 1) then 'Payment schedule' 
				end) 
				end as  YieldSchedule,
	case when ((T2.M_RATE_TYPE1= 0) and (T2.M_YLD_CALC0 = 0 ) and( T2.M_YLD_FREQ0 = 0)) then 'at coupon frequency (standard)' 
		 when ((T2.M_RATE_TYPE1= 0) and (T2.M_YLD_CALC0 = 0 ) and( T2.M_YLD_FREQ0 = 1)) then 'Annual compounding'
		 else ' '
		 end as YieldFrequency, 		
	case when ( T2.M_GC_ACC0 = 0) then 'Standard' 
		 when ( T2.M_GC_ACC0 = 1) then 'Specific convention' 
		 end as GrossToCleanAccrual,
	T2.M_GC_ACCCNV0 as GrossToCleanConvention,
	case when ( T2.M_ALT_YL0 = 0 ) then 'No' 
		 when ( T2.M_ALT_YL0 = 1 ) then 'During last period'
		 when ( T2.M_ALT_YL0 = 2 ) then 'During last year'
		 when ( T2.M_ALT_YL0 = 3 ) then 'During last period + ExDiv'
	end as AltrntYield ,
	T2.M_ALT_YLCNV0 as AlternateYieldConvention,
case when ( mod (T2.M_LNGN_FLGS1, 65536) <65536) and ( mod (T2.M_LNGN_FLGS1, 131072) >= 65536) then 'Time to next coupon'
	when ( mod (T2.M_LNGN_FLGS1, 16) <16) and ( mod (T2.M_LNGN_FLGS1, 32) >= 16) then 'DV01 approach'
else 'Macaulay'
end as Duration,
/* Accrual & Yield conventions Interest ###end### */

	case when (T2.M_INDEXED1 =0) then 'No'
		when (T2.M_INDEXED1 =1) then 'Yes'
	end as Indexed,
	case when ( mod (T2.M_LNGN_FLGS1,  8 ) < 8 and mod (T2.M_LNGN_FLGS1, 16) >=8) then  
		case when (mod (T2.M_LNGN_FLGS1, 536870912) < 536870912 and mod (T2.M_LNGN_FLGS1, 1073741824) >=536870912) then 'Floating indexation' 
			when ( mod (T2.M_LNGN_FLGS1,  536870912 ) < 536870912 and mod (T2.M_LNGN_FLGS1, 1073741824) >=536870912) and (mod (T2.M_LNGN_FLGS1, 268435456) < 268435456 and mod (T2.M_LNGN_FLGS1, 536870912) >=268435456) then 'Formula'
			else 'Fixed Indexation' end 
	else ' ' end as MultiCurrIndex, 
	case when to_number (T2.M_INDEXED1) =1 and ( T2.M_INTRS_CUR1 <>' ' or  T2.M_INTRM_CUR1 <> ' ' or T2.M_FINAL_CUR1 <> '  ')  then 'Yes' else 'No' end as MultiCurrency,
	case when T2.M_LNGN_SFLGS1 = 0 then 'No'
		when T2.M_LNGN_SFLGS1 =128 then 'Yes'
	end as InterestRoundings,
	case when to_number (T2.M_INDEXED1) =1 then T2.M_INTRS_CUR1 else ' ' end as IntflowCurr,
	case when to_number (T2.M_INDEXED1) =1 then T2.M_INTRM_CUR1 else ' ' end as InterCapCurr,
	case when to_number (T2.M_INDEXED1) =1 then T2.M_FINAL_CUR1 else ' ' end as FinalCapCurr,

	
	/* Collateral - Treat collateral = 'On pool level'   ###start### */	
		' ' as MarkedtoMarketCol,
		' ' as RateTypeCol,
		' ' as StartDelayCol,
		' ' as PaymentCalendarCol,
		' ' as FixingCalendarCol,
		' ' as FixingCol,
		' ' as PaymentCol,
		' ' as DiscountingRateCol,
		' ' as DiscountingIndexCol,
		' ' as DiscountingLegCol,
		' ' as RateConvCol,
		' ' as RoundingRuleCol,
		' ' as DecimalsCol,
		' ' as AmortizingCol,
		' ' as CompoundingCol,
		' ' as IndexedSecurityCol,
		' ' as MultiCurrencyCol,
/* Stub period characteristics Collateral ###Start### */
		' ' as StubPeriodRate1Col,
		' ' as CouponCol,
		' ' as StubPeriodRate2Col,
		
/* Stub period characteristics Collateral ###end### */		
		
/* Accrual & Yield conventions Collateral ###start### */

	' ' as AccrualMethodCol, 
	' ' as AccrualConventionCol,
	' ' as AccrualRoundingRuleCol,
	' ' as AccrualDecimalsCol, 
	' ' as AccrualRoundingModeCol,
	' ' as YieldCalculationCol, 
	' ' as YielConventionCol, 
	' ' as  YieldScheduleCol,
	' ' as YieldFrequencyCol, 		
	' ' as GrossToCleanAccrualCol,
	' ' as GrossToCleanConventionCol,
	' ' as AltrntYieldCol ,
	' ' as AlternateYieldConventionCol,
	' ' as DurationCol,
	
/* Accrual & Yield conventions Collateral ###end### */

	/* Collateral - Treat collateral = 'On pool level'   ###end### */	
		
	
/* Interest-Collateral ###end### */


/* Indexation - Indexed and FeesNominal (Marked to market) ###start### */	
	case when (T4.M_TYPE is NULL) then ' '
		 when (T4.M_TYPE=0)  then 'Interest flows'
		 when (T4.M_TYPE=1)  then 'Fixings'
		 when (T4.M_TYPE=8)  then 'Strikes'
		 when (T4.M_TYPE=2)  then 'Margins'
		 when (T4.M_TYPE=3)  then 'Interest rates'
		 when (T4.M_TYPE=4)  then 'Initial capital'
		 when (T4.M_TYPE=5)  then 'Intermediate capital'
		 when (T4.M_TYPE=6)  then 'Final capital'
		 when (T4.M_TYPE=7)  then 'Outstanding capital'
		 when (T4.M_TYPE=9)  then 'Dividends'
		 when (T4.M_TYPE=10) then 'Tax Credit'
		 when (T4.M_TYPE=12) then 'Recovery nominal'
		 when (T4.M_TYPE=13) then 'Cap strikes'
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
		 else to_char(T4.M_IND_NAT)
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
/* Indexation - Indexed and FeesNominal (Marked to market) ###end### */

from RT_INSGN_DBF T1
left join RT_LNGN_DBF T2 on T1.M_GEN_NUM = T2.M_GEN_NUM
left join RT_LNGN_DBF T3 on T1.M_GEN_NUM = T3.M_GEN_NUM
left outer join RT_LNDXG_DBF T4 on T2.M_GEN_NUM=T4.M_GEN_NUM
left outer join RT_INDEX_DBF T5 on T4.M_INDEX=T5.M_INDEX
left outer join RT_INDEX_DBF T6 on T2.M_INDEX0=T6.M_INDEX
where  T1.M_INSTR_TYPE = 26
and T1.M_GEN_NUM = T2.M_GEN_NUM
and T2.M_IDENTITY = T3.M_IDENTITY
and T1.M_CREAT_MODE=0

and T1.M_INSTR not in
(
select T1.M_INSTR
from RT_INSGN_DBF T1
left join RT_LNGN_DBF T2 on T1.M_GEN_NUM = T2.M_GEN_NUM
left join RT_LNGN_DBF T3 on T1.M_GEN_NUM = T3.M_GEN_NUM
where  T1.M_INSTR_TYPE = 26
and T1.M_GEN_NUM = T2.M_GEN_NUM
and T2.M_IDENTITY < T3.M_IDENTITY
and T1.M_CREAT_MODE=0
)
quit;