drop view   SRD_VIW;
create view SRD_VIW
(
M_DIVLAB,
M_STRCOD,
M_STRLAB,
M_MDKCOD,
M_MDKLAB,
M_ORA,
M_STATUS,  
M_BZLCOD,
M_BZLLAB,
M_SEQLAB,
M_DIVGUID,
M_STRGUID,
M_MDKGUID
)

as

(
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
--order by mdkstr.SEQLAB
);

drop table VIW_SRD_DBF;
create table VIW_SRD_DBF as (select * from SRD_VIW);
