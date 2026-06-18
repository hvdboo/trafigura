select
rtrim(bzl.COD) BZLCOD,
rtrim(bzl.LAB) BZLLAB,
-- rtrim(div.COD) DIVCOD,
rtrim(div.LAB) DIVLAB,
rtrim(str.LAB) STRLAB,
rtrim(mdk.COD) MDKCOD,
rtrim(mdk.DES) MDKLAB,
rtrim(mdk.ORA) ORACOD,
mdkstr.SEQLAB SEQ

from SRD_MDK mdk
left join SRD_LNK mdkstr on rtrim(mdk.GUID) = rtrim(mdkstr.SRCINS) and mdkstr.TGTOBJ = 'STR'
left join SRD_STR str on rtrim(mdkstr.TGTINS) = rtrim(str.GUID)

left join SRD_LNK strdiv on rtrim(str.GUID) = rtrim(strdiv.SRCINS) and strdiv.SRCOBJ = 'STR'
left join SRD_DIV div on rtrim(strdiv.TGTINS) = rtrim(div.GUID) and strdiv.TGTOBJ = 'DIV'
left join SRD_LNK mdkbzl on rtrim(mdk.GUID) = rtrim(mdkbzl.SRCINS) and mdkbzl.SRCOBJ = 'MDK' and mdkbzl.TGTOBJ = 'BZL'
left join SRD_BZL bzl on rtrim(mdkbzl.TGTINS) = rtrim(bzl.GUID) and mdkbzl.TGTOBJ = 'BZL'

where rtrim(mdk.STA) is null

order by SEQ