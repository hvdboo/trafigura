select 
pfl.M_LAB    LAB,
-- rtrim(pfldbf.M_COMMENT1) TGTLAB,
pfl.M_ACCCOD ACSCOD,
pfl.M_RMDCOD RMDCOD,
case when rtrim(pfl.M_ACCCOD) = rtrim(pfl.M_RMDCOD) then null else 0 end ACSCODDIF,
pfl.M_ACCLAB ACSLAB,
pfl.M_RMDLAB RMDLAB,
case when rtrim(pfl.M_ACCLAB) = rtrim(pfl.M_RMDLAB) then null else 0 end ACSLABDIF,
pfl.M_MASTER MDKPFL,
case when rtrim(pfl.M_ACCLAB) =
(case 
when substr(pfl.M_LAB,1,2) = 'CO' then rtrim(pfl.M_MASTER)||' (Conc)'
when substr(pfl.M_LAB,1,2) = 'RM' then rtrim(pfl.M_MASTER)||' (RM)'
when substr(pfl.M_LAB,1,2) = 'MC' then 'CED '||rtrim(pfl.M_MASTER)
else rtrim(pfl.M_MASTER) end) 
then null else 0 end MDKDIF,
rtrim(acsudf.M_STRLAB) STRACS,
rtrim(pfl.M_STREAM) STRPFL,
case when rtrim(acsudf.M_STRLAB) = rtrim(pfl.M_STREAM) then null else 0 end STRDIF,
rtrim(acsudf.M_DIVLAB) DIVACS,
rtrim(pfl.M_DIVISION) DIVPFL,
case when rtrim(acsudf.M_DIVLAB) = rtrim(pfl.M_DIVISION) then null else 0 end DIVDIF,
rtrim(acsudf.M_BZLLAB) BZLACS,
rtrim(pfl.M_TITBSL) BZLPFL,
case when trim(substr(acsudf.M_BZLLAB,19,15)) = trim(pfl.M_TITBSL) then null else 0 end BZLDIF
--rtrim(pfldbf.M_COMMENT0)

from VIW_PFL_DBF pfl
left join TRN_ACSC_DBF acs on rtrim(pfl.M_ACCCOD) = rtrim(acs.M_LABEL)
left join TRN_PFLD_DBF pfldbf on rtrim(pfl.M_LAB) = rtrim(pfldbf.M_LABEL)
left join TABLE#DATA#ACCSECTI_DBF acsudf on rtrim(pfl.M_ACCCOD) = rtrim(acsudf.M_LABEL)

where rtrim(pfldbf.M_COMMENT0) is null
