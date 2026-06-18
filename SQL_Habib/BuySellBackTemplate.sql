set colsep '#';
SET TERMOUT OFF;
SPOOL &1;
set linesize 4500;
set pagesize 2048;
select  T1.M_INSTR as BSBTemplate,
	T1.M_INSTR_DESC as Description,
	M_START0 as StartDelay,
	case when (T1.M_EVAL_MODE = 0) then 'Default'
		 when (T1.M_EVAL_MODE = 1) then 'MTM'
		 when (T1.M_EVAL_MODE = 2) then 'Accrual'
		when (T1.M_EVAL_MODE = 3) then 'Repo rates'
		end as EvaluationMode,
	case when ((MOD(T1.M_FLAGS,  256 ) < 256) and (MOD( T1.M_FLAGS, 512) >=256)) then 'No' else 'Yes' end as EarlySettlement,
	case when ((MOD(T1.M_FLAGS,  256 ) < 256) and (MOD( T1.M_FLAGS, 512) >=256)) then 'Inherited from currency' 
		else case when (T1.M_SETTL_MOD=0) then 'Inherited from currency'
				when (T1.M_SETTL_MOD=1) then 'Specific delay' end 
		end as SettlementDelay,
	case when ((MOD(T1.M_FLAGS,  256 ) < 256) and (MOD( T1.M_FLAGS, 512) >=256)) then ' '
		else case when (T1.M_SETTL_MOD=1) then T1.M_SETTL
			when (T1.M_SETTL_MOD=0) then ' ' end 
		end as SettlementDelayShfiter,
/* Dividends-Tax credit fields ###start### */
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
/* Dividends-Tax credit fields ###end### */
-------
/* Schedules definition - Main ###start### */
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
	case when (T2.M_SIMP_SCH1 = 0) then 'No'
		when (T2.M_SIMP_SCH1 = 1) then 'Yes'
		end as SinglePeriod,
	case when (T2.M_SIMP_SCH1 = 1) then
		case when ((MOD(T2.M_LNGN_FLGS1,  2097152 ) < 2097152) and (MOD( T2.M_LNGN_FLGS1, 4194304) >=2097152)) 
			then 'Maturity adjustment modfol' else 'No maturity adjustment' end 
		else ' ' end as SinglePeriodMat
/* Schedules definition - Main ###end### */
-------
from RT_INSGN_DBF T1, RT_LNGN_DBF T2
-------
left outer join RT_INDEX_DBF T3 on T2.M_INDEX0=T3.M_INDEX
left outer join RT_LNDXGL_DBF T20 left outer join RT_LNDXG_DBF T4 on T20.M_REF_INDEXATION_TEMPL=T4.M_REFERENCE on T2.M_REFERENCE=T20.M_REF_LOAN_GENERATOR
left outer join RT_INDEX_DBF T5 on T4.M_INDEX=T5.M_INDEX
left outer join RT_INDEX_DBF T6 on T2.M_INDEX0=T6.M_INDEX
-------
where T1.M_GEN_NUM = T2.M_GEN_NUM
and  T1.M_INSTR_TYPE = 22
and T1.M_CREAT_MODE=0
-------
order by M_INSTR;
quit;
SPOOL OFF;
