select
tag.M_REFERENCE    REF,
rtrim(tag.M_LABEL) LAB,
rtrim(tag.M_DESC)  DES

from TRN_TAG_DBF tag
order by LAB
