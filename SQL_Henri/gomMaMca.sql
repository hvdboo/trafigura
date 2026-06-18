select 
-- mca.M_REFERENCE MCAREF,
rtrim(mca.M_LABEL) MCA, rtrim(mcat.M_LABEL) MCATYP,
rtrim(ma.M_LABEL) MA, rtrim(mat.M_LABEL) MATYP,
to_char(mca.M_START_DATE,'YYYY-MM-DD') VALFST, to_char(mca.M_END_DATE,'YYYY-MM-DD') VALLST,
case scop.M_CRIT_TYPE
when 1 then 'Counterpart'
when 2 then 'Fund'
when 3 then 'Typology'
when 4 then 'Legal Entity'
when 5 then rtrim(adc.M_MCA_TYPE) end CRITTYP,
case scop.M_CRIT_TYPE
when 1 then case scop.M_CRIT_REF when -1 then 'All' else rtrim(ctp.M_DSP_LABEL) end
when 2 then case scop.M_CRIT_REF when -1 then 'All' else rtrim(ctp.M_DSP_LABEL) end
when 3 then case scop.M_CRIT_REF when -1 then 'All' else rtrim(typo.M_LABEL) end
when 4 then case scop.M_CRIT_REF when -1 then 'All' else rtrim(ctp.M_DSP_LABEL) end
when 5 then case scop.M_CRIT_REF when -1 then 'All' else rtrim(adc.M_LABEL) end end CRITVAL,
case scop.M_CRIT_TYPE
when 1 then rtrim(ctp.M_NAME)
when 4 then rtrim(ctp.M_NAME)
when 5 then case
when rtrim(adc.M_LABEL) = 'AGS'       then 'Agriculture'
when rtrim(adc.M_LABEL) = 'BMT'       then 'Base metals'
when rtrim(adc.M_LABEL) = 'COAL'      then 'Coal'
when rtrim(adc.M_LABEL) = 'CURR'      then 'Forex'
when rtrim(adc.M_LABEL) = 'EMI'       then 'Emissions'
when rtrim(adc.M_LABEL) = 'EQD'       then 'Equities'
when rtrim(adc.M_LABEL) = 'FMT'       then 'Ferrous metals'
when rtrim(adc.M_LABEL) = 'FRT'       then 'Dry freight'
when rtrim(adc.M_LABEL) = 'FRW'       then 'Wet freight'
when rtrim(adc.M_LABEL) = 'GAS EU'    then 'Natgas Europe'
when rtrim(adc.M_LABEL) = 'GAS US'    then 'Natgas USA'
when rtrim(adc.M_LABEL) = 'IRD'       then 'Interest rate'
when rtrim(adc.M_LABEL) = 'OIL'       then 'Oil'
when rtrim(adc.M_LABEL) = 'PMT'       then 'Precious metals'
when rtrim(adc.M_LABEL) = 'SCF'       then 'Cash' else null end else null end CRITDESC,
rtrim(mca.M_COMMENT) CMT

from MA_MCA_SELECTION_DBF scop
left join MA_MCA_DBF mca on scop.M_OUTPUT_REF = mca.M_REFERENCE
left join MA_MCAT_DBF mcat on mca.M_MCA_TYPE = mcat.M_REFERENCE
left join MA_MAGR_DBF ma on mca.M_MA = ma.M_REFERENCE
left join MA_MAT_DBF mat on ma.M_MA_TYPE = mat.M_REFERENCE
left join TRN_CPDF_DBF ctp on scop.M_CRIT_REF = ctp.M_ID and scop.M_CRIT_TYPE in (1, 2, 4)
-- left join TRN_CPDF_DBF len on scop.M_CRIT_REF = len.M_ID and scop.M_CRIT_TYPE in (4)
left join TYPOLOGY_DBF typo on scop.M_CRIT_REF = typo.M_REFERENCE and scop.M_CRIT_TYPE = 3
left join MA_MCAAC_DBF adc on scop.M_CRIT_REF = adc.M_REFERENCE and scop.M_CRIT_TYPE = 5

-- where scop.M_CRIT_TYPE = 4 and rtrim(ctp.M_DSP_LABEL) = 'PTE'
order by mca.M_LABEL, scop.M_CRIT_TYPE, CRITVAL