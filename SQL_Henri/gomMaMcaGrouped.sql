select distinct
max(rtrim(mca.M_LABEL)) MCA, max(rtrim(mcat.M_LABEL)) MCATYP,
max(rtrim(ma.M_LABEL)) MA, max(rtrim(mat.M_LABEL)) MATYP,
max(case when scop.M_CRIT_TYPE = 4 then rtrim(ctp.M_DSP_LABEL) else null end) LE,
max(case when scop.M_CRIT_TYPE = 1 then rtrim(ctp.M_DSP_LABEL) else null end) CTP,
max(case when scop.M_CRIT_TYPE = 2 then rtrim(ctp.M_DSP_LABEL) else null end) FUND,
max(case when scop.M_CRIT_TYPE = 3 then rtrim(typo.M_LABEL) else null end) TYPO,
max(case when scop.M_CRIT_TYPE = 5 then rtrim(adc.M_LABEL) else null end) ADDC,
count(*) OCC
from MA_MCA_SELECTION_DBF scop
left join MA_MCA_DBF mca on scop.M_OUTPUT_REF = mca.M_REFERENCE
left join MA_MCAT_DBF mcat on mca.M_MCA_TYPE = mcat.M_REFERENCE
left join MA_MAGR_DBF ma on mca.M_MA = ma.M_REFERENCE
left join MA_MAT_DBF mat on ma.M_MA_TYPE = mat.M_REFERENCE
left join TRN_CPDF_DBF ctp on scop.M_CRIT_REF = ctp.M_ID and scop.M_CRIT_TYPE in (1, 2, 4)
left join TYPOLOGY_DBF typo on scop.M_CRIT_REF = typo.M_REFERENCE and scop.M_CRIT_TYPE = 3
left join MA_MCAAC_DBF adc on scop.M_CRIT_REF = adc.M_REFERENCE and scop.M_CRIT_TYPE in (5)
group by scop.M_OUTPUT_REF
order by MCA