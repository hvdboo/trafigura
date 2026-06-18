select 
pfl.M_LAB    PFLLAB,
pfl.M_ACCCOD ACCCOD,
pfl.M_ACCLAB ACCMDK,
--pfl.M_RMDCOD RMDCOD,
pfl.M_RMDLAB RMDLAB,
pfl.M_MASTER PFLMDK,
srd.DES      SRDMDK,
case when rtrim(pfl.M_ACCLAB) = rtrim(pfl.M_MASTER) then 1 else 0 end DIFMDK,
rtrim(accsec.M_STRLAB) ACCSTR,
pfl.M_STREAM PFLSTR,
case when rtrim(accsec.M_STRLAB) = rtrim(pfl.M_STREAM) then 1 else 0 end DIFSTR,
rtrim(accsec.M_DIVLAB) ACCDIV,
pfl.M_DIVISION PFLDIV,
case when rtrim(accsec.M_DIVLAB) = rtrim(pfl.M_DIVISION) then 1 else 0 end DIFDIV,
srd.STA

from VIW_PFL_DBF pfl
left join SRD_MDK srd on rtrim(M_RMDCOD) = rtrim(srd.ORA)
left join TABLE#DATA#ACCSECTI_DBF accsec on rtrim(M_RMDCOD) = rtrim(accsec.M_LABEL)

order by PFLLAB



