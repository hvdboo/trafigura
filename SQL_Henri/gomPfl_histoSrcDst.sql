select 
rtrim(src.M_LABEL) SRCLAB,
rtrim(dst.M_LABEL) DSTLAB,
count(*)

from TRN_HDR_DBF trn
left join TRN_PFLD_DBF src on trn.M_SRC_PFOLIO = src.M_REF
left join TRN_PFLD_DBF dst on trn.M_DST_PFOLIO = dst.M_REF

group by rtrim(src.M_LABEL), rtrim(dst.M_LABEL)

order by SRCLAB, DSTLAB