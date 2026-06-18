
-- COM Other
select distinct
rtrim(lut.M_LABEL)            LUT,
rtrim(reg.M_REG_CLALAB)       REGCLA,                  
rtrim(comothbdy.M_REGISTRLBL) REGLAB,
rtrim(reg.M_REG_LO)           REGLO,
rtrim(reg.M_REG_FML)          REGFML,
rtrim(reg.M_REG_GRP)          REGGRP,
rtrim(reg.M_REG_TYP)          REGTYP,
rtrim(reg.M_REG_COD)          REGCOD,
''                            REGDES,
rtrim(comothbdy.M_TYPOLOGY)   TYPOLB,
rtrim(reg.M_REG_CLAUID)       CLAUID,
reg.M_REG_FGT                 REGUID,
typo.M_REFERENCE              TYPOID

from UDTB133_DBF comothbdy
left join UDTH133_DBF comothhdr on comothbdy.M__INDEX_ = comothhdr.M__INDEX_
left join RTG_TYP_DBF  lut  on lut.M_HEADER = 'UDTH133'
left join TYPOLOGY_DBF typo on rtrim(comothbdy.M_TYPOLOGY) = rtrim(typo.M_LABEL)
left join UDTB279_DBF  reg  on rtrim(comothbdy.M_REGISTRLBL) = rtrim(reg.M_REG_FCC)

where typo.M_REFERENCE in (1001,1014,1022,1023,1038,1046,1047,1054,1057,1058,1062,1391,1402,1416,1421,1422)

union all

-- COM Reg
select distinct
rtrim(comreglut.M_LABEL)      LUT,
rtrim(reg.M_REG_CLALAB)       REGCLA,
rtrim(comregbdy.M_REGISTRLBL) REGLAB,
rtrim(reg.M_REG_LO)           REGLO,
rtrim(reg.M_REG_FML)          REGFML,
rtrim(reg.M_REG_GRP)          REGGRP,
rtrim(reg.M_REG_TYP)          REGTYP,
rtrim(reg.M_REG_COD)          REGCOD,
rtrim(reg.M_REG_DES)          REGDES,
rtrim(comregbdy.M_TYPOLOGY)   TYPOLB,
rtrim(reg.M_REG_CLAUID)       CLAUID,
reg.M_REG_FGT                 REGUID,
typo.M_REFERENCE              TYPOID

from UDTB134_DBF comregbdy
left join UDTH134_DBF comreghdr on comregbdy.M__INDEX_ = comreghdr.M__INDEX_
left join RTG_TYP_DBF comreglut on comreglut.M_HEADER = 'UDTH134'
left join TYPOLOGY_DBF typo on rtrim(comregbdy.M_TYPOLOGY) = rtrim(typo.M_LABEL)
left join UDTB279_DBF  reg  on rtrim(comregbdy.M_REGISTRLBL) = rtrim(reg.M_REG_FCC)

where typo.M_REFERENCE in (1012,1013,1388,1392,1394,1395,1398,1401)

union all

-- FXMM
select
rtrim(lut.M_LABEL)         LUT,
rtrim(reg.M_REG_CLALAB)    REGCLA,
rtrim(fxmbdy.M_REGISTRLBL) REGLAB,
rtrim(reg.M_REG_LO)        REGLO,
rtrim(reg.M_REG_FML)       REGFML,
rtrim(reg.M_REG_GRP)       REGGRP,
rtrim(reg.M_REG_TYP)       REGTYP,
rtrim(reg.M_REG_COD)       REGCOD,
case when rtrim(reg.M_REG_CLAUID) = '1.526' then rtrim(reg.M_REG_DES) else null end REGDES,
rtrim(fxmbdy.M_TYPOLOGY)   TYPOLB,
rtrim(reg.M_REG_CLAUID)    CLAUID,
reg.M_REG_FGT              REGUID,
typo.M_REFERENCE           TYPOID

from UDTB122_DBF fxmbdy
left join UDTH122_DBF  fxmhdr on fxmbdy.M__INDEX_ = fxmhdr.M__INDEX_
left join RTG_TYP_DBF  lut  on lut.M_HEADER = 'UDTH122'
left join TYPOLOGY_DBF typo on rtrim(fxmbdy.M_TYPOLOGY) = rtrim(typo.M_LABEL)
left join UDTB279_DBF  reg  on rtrim(fxmbdy.M_REGISTRLBL) = rtrim(reg.M_REG_FCC)

where 1 = 1
and typo.M_REFERENCE in (1248,1261,1262,1263,1264,1265,1267,1407,1408,1417,1420)
and reg.M_REG_FGT <> 92

union all

-- IRD
select
rtrim(lut.M_LABEL)         LUT,
rtrim(reg.M_REG_CLALAB)    REGCLA,
rtrim(irdbdy.M_REGISTRLBL) REGLAB,
rtrim(reg.M_REG_LO)        REGLO,
rtrim(reg.M_REG_FML)       REGFML,
rtrim(reg.M_REG_GRP)       REGGRP,
rtrim(reg.M_REG_TYP)       REGTYP,
rtrim(reg.M_REG_COD)       REGCOD,
case when rtrim(reg.M_REG_CLAUID) = '1.526' then rtrim(reg.M_REG_DES) else null end REGDES,
rtrim(irdbdy.M_TYPOLOGY)   TYPOLB,
rtrim(reg.M_REG_CLAUID)    CLAUID,
reg.M_REG_FGT              REGUID,
typo.M_REFERENCE           TYPOID

from UDTB126_DBF irdbdy
left join UDTH126_DBF  irdhdr on irdbdy.M__INDEX_ = irdhdr.M__INDEX_
left join RTG_TYP_DBF  lut  on lut.M_HEADER = 'UDTH126'
left join TYPOLOGY_DBF typo on rtrim(irdbdy.M_TYPOLOGY) = rtrim(typo.M_LABEL)
left join UDTB279_DBF  reg  on rtrim(irdbdy.M_REGISTRLBL) = rtrim(reg.M_REG_FCC)

where typo.M_REFERENCE in (1194,1206,1228,1250,1251,1253,1256)

union all

-- EQD Reg
select
rtrim(lut.M_LABEL)            LUT,
rtrim(reg.M_REG_CLALAB)       REGCLA,
rtrim(eqdregbdy.M_REGISTRLBL) REGLAB,
rtrim(reg.M_REG_LO)           REGLO,
rtrim(reg.M_REG_FML)          REGFML,
rtrim(reg.M_REG_GRP)          REGGRP,
rtrim(reg.M_REG_TYP)          REGTYP,
rtrim(reg.M_REG_COD)          REGCOD,
case when rtrim(reg.M_REG_CLAUID) = '1.526' then rtrim(reg.M_REG_DES) else null end REGDES,
rtrim(eqdregbdy.M_TYPOLOGY)   TYPOLB,
rtrim(reg.M_REG_CLAUID)       CLAUID,
reg.M_REG_FGT                 REGUID,
typo.M_REFERENCE              TYPOID

from UDTB132_DBF eqdregbdy
left join UDTH132_DBF  eqdreghdr on eqdregbdy.M__INDEX_ = eqdreghdr.M__INDEX_
left join RTG_TYP_DBF  lut  on lut.M_HEADER = 'UDTH132'
left join TYPOLOGY_DBF typo on rtrim(eqdregbdy.M_TYPOLOGY) = rtrim(typo.M_LABEL)
left join UDTB279_DBF  reg  on rtrim(eqdregbdy.M_REGISTRLBL) = rtrim(reg.M_REG_FCC)

where typo.M_REFERENCE in (1110,1112,1115,1130)

order by REGFML, REGCLA, REGCOD, TYPOLB