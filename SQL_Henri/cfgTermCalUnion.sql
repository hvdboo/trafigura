select 
rtrim(clu.M_DSP_LABEL) UNILAB,
rtrim(clu.M_DESC) UNIDES,
rtrim(cmp.M_DSP_LABEL) CALLAB,
rtrim(cmp.M_DESC) CALDES

from CAL_UNI_DBF uni
left join CAL_DEF_DBF clu on uni.M_CTN = clu.M_LABEL
left join CAL_DEF_DBF cmp on uni.M_REF = cmp.M_LABEL

order by UNILAB, CALLAB