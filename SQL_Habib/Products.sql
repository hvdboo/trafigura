set colsep '#';
SET TERMOUT OFF;
SPOOL &1;
set linesize 500;
set pagesize 2048;
select T1.M_LABEL as Products, T1.M_DESC as Description, T7.M_LABEL as Type,
	case when T1.M_GENSTOCK = 2 then 'NotAtAll'
		when T1.M_GENSTOCK = 0 then 'EvaluationFlowsWithoutRealCashFlows'
		when T1.M_GENSTOCK = 1 then 'StockModeWithTodaysSpot'
		end as PastCashEvaluation,
	case when T8.M_LABEL is null then ' ' else T8.M_LABEL end as DefaultUnit,
	case when T1.M_CNV_VW =0 then 'No'
		when T1.M_CNV_VW =1 then 'Yes'
		end as VolumetricDensity, 
	T1.M_CNV_VWF1 as VolumeDensity,
	case when  T1.M_CNV_VWU0=0 then ' '
		else T3.M_LABEL
		end as VolumeDensityUnit,
	case when T1.M_CNV_VWU1=0 then ' '
		else T4.M_LABEL
		end as PerUnitVol,
	case when T1.M_CNV_EW =0 then 'No'
		when T1.M_CNV_EW=1 then 'Yes'
		end as CaloricValue,
	T1.M_CNV_EWF1 as CaloricValueNum, 
	case when T1.M_CNV_EWU0=0 then ' '
		else T5.M_LABEL
		end as CaloricValueUnit,
	case when T1.M_CNV_EWU1=0 then ' '
		else T6.M_LABEL
		end as perUnitCal,
	case when T11.M_LABEL is null then ' ' else T11.M_LABEL end as DefaultQality,
	case when T10.M_LABEL is null then ' ' else T10.M_LABEL end as Qualities
-------
from CM_PHYS_DBF T1 
-------
left outer join CM_PTYPE_DBF T7	on T1.M_TYPE= T7.M_REFERENCE
left outer join CM_UNIT_DBF T3 on T1.M_CNV_VWU0= T3.M_REFERENCE
left outer join CM_UNIT_DBF T4 on T1.M_CNV_VWU1= T4.M_REFERENCE
left outer join CM_UNIT_DBF T5 on T1.M_CNV_EWU0= T5.M_REFERENCE
left outer join CM_UNIT_DBF T6 on T1.M_CNV_EWU1= T6.M_REFERENCE
left outer join CM_UNIT_DBF T8 on T1.M_DEFUNIT= T8.M_REFERENCE
left outer join CM_QUALMAP_PHYS_DBF T9 on T1.M_REFERENCE = T9.M_PHYS_REF
left outer join CM_QUALITY_DBF T10 on T9.M_QUAL_REF = T10.M_REFERENCE
left outer join CM_QUALITY_DBF T11 on T1.M_DEF_QUAL = T11.M_REFERENCE
order by T1.M_LABEL;
quit;
SPOOL OFF;