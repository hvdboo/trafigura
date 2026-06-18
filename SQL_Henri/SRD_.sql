select 
rtrim(div.LAB) DIVLAB,
rtrim(str.COD) STRCOD,
rtrim(str.LAB) STRLAB,
rtrim(mdk.COD) MDKLAB,
rtrim(mdk.DES) MDKLAB,
rtrim(mdk.ORA) ORA,
mdk.STA        STATUS,  
rtrim(bzl.COD) BZLCOD,
rtrim(bzl.LAB) BZLLAB,
mdkstr.SEQLAB,
rtrim(div.GUID) DIVGUID,
rtrim(str.GUID) STRGUID,
rtrim(mdk.GUID) MDKGUID

from SRD_MDK mdk
left join SRD_LNK mdkstr on mdk.GUID = mdkstr.SRCINS and mdkstr.SRCOBJ = 'MDK' and mdkstr.TGTOBJ = 'STR'
left join SRD_STR str on mdkstr.TGTINS = str.GUID
left join SRD_LNK strdiv on str.GUID = strdiv.SRCINS and strdiv.SRCOBJ = 'STR' and strdiv.TGTOBJ = 'DIV'
left join SRD_DIV div on strdiv.TGTINS = div.GUID
left join SRD_LNK mdkbzl on mdk.GUID = mdkbzl.SRCINS and mdkbzl.SRCOBJ = 'MDK' and mdkbzl.TGTOBJ = 'BZL'
left join SRD_BZL bzl on mdkbzl.TGTINS = bzl.GUID

where mdk.STA is null
order by mdkstr.SEQLAB

/*
select 
rtrim(div.LAB) DIV,
rtrim(str.LAB) STR,
strdiv.SEQ,
strdiv.ID

from SRD_STR str
left join SRD_MAP strdiv on str.GUID = strdiv.SRCINS and strdiv.SRCOBJ = 'STR' and strdiv.TGTOBJ = 'DIV'
left join SRD_DIV div on strdiv.TGTINS = div.GUID

order by strdiv.SEQ asc
*/

