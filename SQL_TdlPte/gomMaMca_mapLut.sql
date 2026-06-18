select
fin.MCA, fin.MCATYP, fin.CTP, 
fin.LEN CFG_LEN, rtrim(lut.M_RECIPIENT) LUT_LEN,
fin.LO CFG_LO, rtrim(lut.M_ISOTC) LUT_LO,
max(fin.VALFST) CFG_VALFST, max(to_char(lut.M_VALIDFROM,'YYYY-MM-DD'))  LUT_VALFST,
max(fin.VALLST) CFG_VALLST, max(to_char(lut.M_VALIDUNTIL,'YYYY-MM-DD')) LUT_VALLST,
min(fin.ASSET) CFG_ASSET,
min(case rtrim(lut.M_CMASSET) when 'CURR' then 'CURR|' else '____|' end)||
min(case rtrim(lut.M_CMASSET) when 'IRD'  then 'IRD|'  else '___|'  end)||
min(case rtrim(lut.M_CMASSET) when 'EQD'  then 'EQD|'  else '___|'  end)||
min(case rtrim(lut.M_CMASSET) when 'BMT'  then 'BMT|'  else '___|'  end)||
min(case rtrim(lut.M_CMASSET) when 'FMT'  then 'FMT|'  else '___|'  end)||
min(case rtrim(lut.M_CMASSET) when 'PMT'  then 'PMT|'  else '___|'  end)||
min(case rtrim(lut.M_CMASSET) when 'FRT'  then 'FRT|'  else '___|'  end)||
min(case rtrim(lut.M_CMASSET) when 'AGS'  then 'AGS|'  else '___|'  end)||
min(case rtrim(lut.M_CMASSET) when 'COAL' then 'COAL|' else '___|'  end)||
min(case rtrim(lut.M_CMASSET) when 'EMI'  then 'EMI|'  else '___|'  end)||
min(case rtrim(lut.M_CMASSET) when 'OIL'  then 'OIL|'  else '___|'  end) LUT_ASSET

from

(
select
rtrim(mca.M_LABEL) MCA, rtrim(mcat.M_LABEL) MCATYP,
to_char(mca.M_START_DATE,'YYYY-MM-DD') VALFST, to_char(mca.M_END_DATE,'YYYY-MM-DD') VALLST,
max(case scop.M_CRIT_TYPE when 1 then (case scop.M_CRIT_REF when -1 then 'All' else rtrim(ctp.M_DSP_LABEL) end) else null end) CTP,
max(case scop.M_CRIT_TYPE when 4 then (case scop.M_CRIT_REF when -1 then 'All' else rtrim(len.M_DSP_LABEL) end) else null end) LEN,
max(case scop.M_CRIT_TYPE when 5 then (case scop.M_CRIT_REF when -1 then 'All' else rtrim(substr(adc.M_MCA_TYPE,9,3)) end) else null end) LO,
min(case rtrim(adc.M_LABEL) when 'CURR' then 'CURR|' else '____|' end)||
min(case rtrim(adc.M_LABEL) when 'IRD'  then 'IRD|'  else '___|'  end)||
min(case rtrim(adc.M_LABEL) when 'EQD'  then 'EQD|'  else '___|'  end)||
min(case rtrim(adc.M_LABEL) when 'BMT'  then 'BMT|'  else '___|'  end)||
min(case rtrim(adc.M_LABEL) when 'FMT'  then 'FMT|'  else '___|'  end)||
min(case rtrim(adc.M_LABEL) when 'PMT'  then 'PMT|'  else '___|'  end)||
min(case rtrim(adc.M_LABEL) when 'FRT'  then 'FRT|'  else '___|'  end)||
min(case rtrim(adc.M_LABEL) when 'AGS'  then 'AGS|'  else '___|'  end)||
min(case rtrim(adc.M_LABEL) when 'COAL' then 'COAL|' else '___|'  end)||
min(case rtrim(adc.M_LABEL) when 'EMI'  then 'EMI|'  else '___|'  end)||
min(case rtrim(adc.M_LABEL) when 'OIL'  then 'OIL|'  else '___|'  end) ASSET
from MA_MCA_SELECTION_DBF scop
left outer join MA_MCA_DBF mca on scop.M_OUTPUT_REF = mca.M_REFERENCE
left outer join MA_MCAT_DBF mcat on mca.M_MCA_TYPE = mcat.M_REFERENCE
left outer join MA_MAGR_DBF ma on mca.M_MA = ma.M_REFERENCE
left outer join MA_MAT_DBF mat on ma.M_MA_TYPE = mat.M_REFERENCE
left outer join TRN_CPDF_DBF ctp on scop.M_CRIT_REF = ctp.M_ID and scop.M_CRIT_TYPE in (1)
left outer join TRN_CPDF_DBF len on scop.M_CRIT_REF = len.M_ID and scop.M_CRIT_TYPE in (4)
left outer join TYPOLOGY_DBF typo on scop.M_CRIT_REF = typo.M_REFERENCE and scop.M_CRIT_TYPE = 3
left outer join MA_MCAAC_DBF adc on scop.M_CRIT_REF = adc.M_REFERENCE and scop.M_CRIT_TYPE = 5
group by 
rtrim(mca.M_LABEL), 
rtrim(mcat.M_LABEL), 
to_char(mca.M_START_DATE,'YYYY-MM-DD'), to_char(mca.M_END_DATE,'YYYY-MM-DD')
) fin

left join UDTB266_DBF lut on 
rtrim(fin.MCA)||rtrim(substr(MCATYP,9,3)) =
rtrim(lut.M_NAVPATH)||rtrim(lut.M_ISOTC)
and lut.M__INDEX_ = 901232

group by 
fin.MCA, fin.MCATYP, fin.CTP, 
fin.LEN, rtrim(lut.M_RECIPIENT),
fin.LO, rtrim(lut.M_ISOTC)

order by fin.MCA