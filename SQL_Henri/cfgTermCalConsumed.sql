select distinct 
caltrn.CAL, 
caldef.M_ISUNION TYP, 
-- caldef.M_LABEL LAB, 
rtrim(caldef.M_DESC) DES,
rtrim(altid.M_OBJ_ALT) ALT_ID
from

(

-- INS_CAL0
select INS_CAL0 CAL from
(
select
rtrim(plin.M_DSP_LABEL) INS_LAB,
case plin.M_FAMILY
when    16 then rtrim(fxcnt.M_CALENDAR0)
when    32 then rtrim(cmfcal.M_LABEL) 
when    64 then rtrim(fxcur.M_HOLCLN0)
when   256 then rtrim(cmical.M_LABEL)
when 16384 then rtrim(cmfcal.M_LABEL) else null end INS_CAL0, 
case plin.M_FAMILY 
when    16 then rtrim(fxcnt.M_CALENDAR1) else null end INS_CAL1,
case 
when (plin.M_FAMILY = 2 and insgen.M_INSTR_TYPE in (13)) then rtrim(gen.M_FIX_CLN0)
when plin.M_FAMILY = 512 then rtrim(gen.M_FIX_CLN0)
when (cmf.M_LISTED < 64 and cmf.M_INS_MODE = 0) then rtrim(cmfgen.M_FIX_CLN0) else null end GEN_FIX_CAL0,
case 
when (plin.M_FAMILY = 2 and insgen.M_INSTR_TYPE in (13)) then rtrim(gen.M_PAY_CLN0)
when plin.M_FAMILY = 512 then rtrim(gen.M_PAY_CLN0)
when (cmf.M_LISTED < 64 and cmf.M_INS_MODE = 0) then rtrim(cmfgen.M_PAY_CLN0) else null end GEN_PAY_CAL0,
case
when gniobs0.M_CALENDAR = 2 then 'External'
when gniobs0.M_CALENDAR in(3,4) then rtrim(gniobs0.M_STRCALEN)
when fgiobs0.M_CALENDAR = 2 then 'External'
when fgiobs0.M_CALENDAR in(3,4) then rtrim(fgiobs0.M_STRCALEN) else null end OBSCAL0, 
case 
when gni0.M_RESET = 0 then rtrim(gnical0.M_LABEL) 
when gni0.M_RESET = 3 then rtrim(gnigrp0.M_CALENDAR)
when fgi0.M_RESET = 0 then rtrim(fgical0.M_LABEL)
when fgi0.M_RESET = 3 then rtrim(fgigrp0.M_CALENDAR)
when (cmf.M_LISTED < 64 and cmf.M_INS_MODE = 1) then rtrim(fsical.M_LABEL)
when plin.M_FAMILY = 256 then rtrim(cmical.M_LABEL) else null end ARCCAL0,
rtrim(coalesce(gnucal0.M_LABEL, fgucal0.M_LABEL)) UNDCAL0

from TRN_PLIN_DBF plin
left join FX_CURR_DBF fxcur on (plin.M_LABEL = fxcur.M_LABEL and plin.M_FAMILY = 64)
left join CAL_DEF_DBF fxcurcal on fxcur.M_HOLCLN0 = fxcurcal.M_LABEL
left join FX_CNT_DBF fxcnt on (plin.M_LABEL = fxcnt.M_LABEL and plin.M_FAMILY = 16)
left join RT_INDEX_DBF ind on (rtrim(plin.M_LABEL) = rtrim(ind.M_INDEX) and plin.M_FAMILY = 256)
left join CMC_QUOT_DBF cmiqot on trim(substr(plin.M_LABEL,11,15)) = to_char(cmiqot.M_REFERENCE)
left join CM_MKT_DBF cmipub on cmiqot.M_PUBLI = cmipub.M_REFERENCE
left join CAL_DEF_DBF cmical on cmipub.M_CALENDAR = cmical.M_LABEL
left join CM_FUT_DBF cmf on (rtrim(substr(plin.M_LABEL,9,10)) = to_char(cmf.M_REFERENCE) and plin.M_FAMILY in (32,16384))
left join CMC_QUOT_DBF cmfqot on cmf.M_QUOT_FWD = cmfqot.M_REFERENCE
left join CM_MKT_DBF cmfpub on cmfqot.M_PUBLI= cmfpub.M_REFERENCE
left join CAL_DEF_DBF cmfcal on cmfpub.M_CALENDAR = cmfcal.M_LABEL
left join RT_INSGN_DBF insgen on (rtrim(plin.M_LABEL) = to_char(insgen.M_GEN_NUM) and plin.M_FAMILY in (2,512))
left join RT_LNGN_DBF gen on (rtrim(plin.M_LABEL) = to_char(gen.M_GEN_NUM) and plin.M_FAMILY in (2,512))
left join RT_LNGN_DBF  cmfgen on (cmf.M_CM_INSTR = cmfgen.M_GEN_NUM and cmf.M_INS_MODE = 0)
left join RT_INSGN_DBF cmfins on (cmfgen.M_GEN_NUM = cmfins.M_GEN_NUM)
left join RT_INDEX_DBF gni0 on gen.M_INDEX0 = gni0.M_INDEX
left join RT_GROUP_DBF gnigrp0 on gni0.M_HISFILE = gnigrp0.M_HISFILE
left join CMC_QUOT_DBF gniqot0 on gni0.M_COM_QUOT = gniqot0.M_REFERENCE
left join CM_MKT_DBF   gnipub0 on gniqot0.M_PUBLI = gnipub0.M_REFERENCE
left join CAL_DEF_DBF  gnical0 on gnipub0.M_CALENDAR = gnical0.M_LABEL
left join DAT_ECH_DBF gniobs0 on gni0.M_UEI = gniobs0.M_LABEL
left join RT_INDEX_DBF fgi0 on cmfgen.M_INDEX0 = fgi0.M_INDEX
left join RT_GROUP_DBF fgigrp0 on fgi0.M_HISFILE = fgigrp0.M_HISFILE
left join CMC_QUOT_DBF fgiqot0 on fgi0.M_COM_QUOT = fgiqot0.M_REFERENCE
left join CM_MKT_DBF   fgipub0 on fgiqot0.M_PUBLI = fgipub0.M_REFERENCE
left join CAL_DEF_DBF  fgical0 on fgipub0.M_CALENDAR = fgical0.M_LABEL
left join DAT_ECH_DBF fgiobs0 on fgi0.M_UEI = fgiobs0.M_LABEL
left join CMC_MGEN_DBF mgen on (cmf.M_CM_INSTR = mgen.M_REFERENCE and cmf.M_INS_MODE = 1)
left join RT_INDEX_DBF fsi on mgen.M_INDEX = fsi.M_INDEX
left join CMC_QUOT_DBF fsiqot on fsi.M_COM_QUOT = fsiqot.M_REFERENCE
left join CM_MKT_DBF   fsipub on fsiqot.M_PUBLI = fsipub.M_REFERENCE
left join CAL_DEF_DBF  fsical on fsipub.M_CALENDAR = fsical.M_LABEL
left join RT_INDEX_DBF gnu0 on gni0.M_UNDRL = gnu0.M_INDEX
left join RT_GROUP_DBF gnugrp0 on gnu0.M_HISFILE = gnugrp0.M_HISFILE
left join CMC_QUOT_DBF gnuqot0 on gnu0.M_COM_QUOT = gnuqot0.M_REFERENCE
left join CM_MKT_DBF   gnupub0 on gnuqot0.M_PUBLI = gnupub0.M_REFERENCE
left join CAL_DEF_DBF  gnucal0 on gnupub0.M_CALENDAR = gnucal0.M_LABEL
left join RT_INDEX_DBF fgu0 on fgi0.M_UNDRL = fgu0.M_INDEX
left join RT_GROUP_DBF fgugrp0 on fgu0.M_HISFILE = fgugrp0.M_HISFILE
left join CMC_QUOT_DBF fguqot0 on fgu0.M_COM_QUOT = fguqot0.M_REFERENCE
left join CM_MKT_DBF   fgupub0 on fguqot0.M_PUBLI = fgupub0.M_REFERENCE
left join CAL_DEF_DBF  fgucal0 on fgupub0.M_CALENDAR = fgucal0.M_LABEL

where 
plin.M_REFERENCE in (select distinct trn.M_INSTRUMENT from TRN_HDR_DBF trn)
)

union

-- INS_CAL1
select INS_CAL1 from
(
select
rtrim(plin.M_DSP_LABEL) INS_LAB,
case plin.M_FAMILY
when    16 then rtrim(fxcnt.M_CALENDAR0)
when    32 then rtrim(cmfcal.M_LABEL) 
when    64 then rtrim(fxcur.M_HOLCLN0)
when   256 then rtrim(cmical.M_LABEL)
when 16384 then rtrim(cmfcal.M_LABEL) else null end INS_CAL0, 
case plin.M_FAMILY 
when    16 then rtrim(fxcnt.M_CALENDAR1) else null end INS_CAL1,
case 
when (plin.M_FAMILY = 2 and insgen.M_INSTR_TYPE in (13)) then rtrim(gen.M_FIX_CLN0)
when plin.M_FAMILY = 512 then rtrim(gen.M_FIX_CLN0)
when (cmf.M_LISTED < 64 and cmf.M_INS_MODE = 0) then rtrim(cmfgen.M_FIX_CLN0) else null end GEN_FIX_CAL0,
case 
when (plin.M_FAMILY = 2 and insgen.M_INSTR_TYPE in (13)) then rtrim(gen.M_PAY_CLN0)
when plin.M_FAMILY = 512 then rtrim(gen.M_PAY_CLN0)
when (cmf.M_LISTED < 64 and cmf.M_INS_MODE = 0) then rtrim(cmfgen.M_PAY_CLN0) else null end GEN_PAY_CAL0,
case
when gniobs0.M_CALENDAR = 2 then 'External'
when gniobs0.M_CALENDAR in(3,4) then rtrim(gniobs0.M_STRCALEN)
when fgiobs0.M_CALENDAR = 2 then 'External'
when fgiobs0.M_CALENDAR in(3,4) then rtrim(fgiobs0.M_STRCALEN) else null end OBSCAL0, 
case 
when gni0.M_RESET = 0 then rtrim(gnical0.M_LABEL) 
when gni0.M_RESET = 3 then rtrim(gnigrp0.M_CALENDAR)
when fgi0.M_RESET = 0 then rtrim(fgical0.M_LABEL)
when fgi0.M_RESET = 3 then rtrim(fgigrp0.M_CALENDAR)
when (cmf.M_LISTED < 64 and cmf.M_INS_MODE = 1) then rtrim(fsical.M_LABEL)
when plin.M_FAMILY = 256 then rtrim(cmical.M_LABEL) else null end ARCCAL0,
rtrim(coalesce(gnucal0.M_LABEL, fgucal0.M_LABEL)) UNDCAL0

from TRN_PLIN_DBF plin
left join FX_CURR_DBF fxcur on (plin.M_LABEL = fxcur.M_LABEL and plin.M_FAMILY = 64)
left join CAL_DEF_DBF fxcurcal on fxcur.M_HOLCLN0 = fxcurcal.M_LABEL
left join FX_CNT_DBF fxcnt on (plin.M_LABEL = fxcnt.M_LABEL and plin.M_FAMILY = 16)
left join RT_INDEX_DBF ind on (rtrim(plin.M_LABEL) = rtrim(ind.M_INDEX) and plin.M_FAMILY = 256)
left join CMC_QUOT_DBF cmiqot on trim(substr(plin.M_LABEL,11,15)) = to_char(cmiqot.M_REFERENCE)
left join CM_MKT_DBF cmipub on cmiqot.M_PUBLI = cmipub.M_REFERENCE
left join CAL_DEF_DBF cmical on cmipub.M_CALENDAR = cmical.M_LABEL
left join CM_FUT_DBF cmf on (rtrim(substr(plin.M_LABEL,9,10)) = to_char(cmf.M_REFERENCE) and plin.M_FAMILY in (32,16384))
left join CMC_QUOT_DBF cmfqot on cmf.M_QUOT_FWD = cmfqot.M_REFERENCE
left join CM_MKT_DBF cmfpub on cmfqot.M_PUBLI= cmfpub.M_REFERENCE
left join CAL_DEF_DBF cmfcal on cmfpub.M_CALENDAR = cmfcal.M_LABEL
left join RT_INSGN_DBF insgen on (rtrim(plin.M_LABEL) = to_char(insgen.M_GEN_NUM) and plin.M_FAMILY in (2,512))
left join RT_LNGN_DBF gen on (rtrim(plin.M_LABEL) = to_char(gen.M_GEN_NUM) and plin.M_FAMILY in (2,512))
left join RT_LNGN_DBF  cmfgen on (cmf.M_CM_INSTR = cmfgen.M_GEN_NUM and cmf.M_INS_MODE = 0)
left join RT_INSGN_DBF cmfins on (cmfgen.M_GEN_NUM = cmfins.M_GEN_NUM)
left join RT_INDEX_DBF gni0 on gen.M_INDEX0 = gni0.M_INDEX
left join RT_GROUP_DBF gnigrp0 on gni0.M_HISFILE = gnigrp0.M_HISFILE
left join CMC_QUOT_DBF gniqot0 on gni0.M_COM_QUOT = gniqot0.M_REFERENCE
left join CM_MKT_DBF   gnipub0 on gniqot0.M_PUBLI = gnipub0.M_REFERENCE
left join CAL_DEF_DBF  gnical0 on gnipub0.M_CALENDAR = gnical0.M_LABEL
left join DAT_ECH_DBF gniobs0 on gni0.M_UEI = gniobs0.M_LABEL
left join RT_INDEX_DBF fgi0 on cmfgen.M_INDEX0 = fgi0.M_INDEX
left join RT_GROUP_DBF fgigrp0 on fgi0.M_HISFILE = fgigrp0.M_HISFILE
left join CMC_QUOT_DBF fgiqot0 on fgi0.M_COM_QUOT = fgiqot0.M_REFERENCE
left join CM_MKT_DBF   fgipub0 on fgiqot0.M_PUBLI = fgipub0.M_REFERENCE
left join CAL_DEF_DBF  fgical0 on fgipub0.M_CALENDAR = fgical0.M_LABEL
left join DAT_ECH_DBF fgiobs0 on fgi0.M_UEI = fgiobs0.M_LABEL
left join CMC_MGEN_DBF mgen on (cmf.M_CM_INSTR = mgen.M_REFERENCE and cmf.M_INS_MODE = 1)
left join RT_INDEX_DBF fsi on mgen.M_INDEX = fsi.M_INDEX
left join CMC_QUOT_DBF fsiqot on fsi.M_COM_QUOT = fsiqot.M_REFERENCE
left join CM_MKT_DBF   fsipub on fsiqot.M_PUBLI = fsipub.M_REFERENCE
left join CAL_DEF_DBF  fsical on fsipub.M_CALENDAR = fsical.M_LABEL
left join RT_INDEX_DBF gnu0 on gni0.M_UNDRL = gnu0.M_INDEX
left join RT_GROUP_DBF gnugrp0 on gnu0.M_HISFILE = gnugrp0.M_HISFILE
left join CMC_QUOT_DBF gnuqot0 on gnu0.M_COM_QUOT = gnuqot0.M_REFERENCE
left join CM_MKT_DBF   gnupub0 on gnuqot0.M_PUBLI = gnupub0.M_REFERENCE
left join CAL_DEF_DBF  gnucal0 on gnupub0.M_CALENDAR = gnucal0.M_LABEL
left join RT_INDEX_DBF fgu0 on fgi0.M_UNDRL = fgu0.M_INDEX
left join RT_GROUP_DBF fgugrp0 on fgu0.M_HISFILE = fgugrp0.M_HISFILE
left join CMC_QUOT_DBF fguqot0 on fgu0.M_COM_QUOT = fguqot0.M_REFERENCE
left join CM_MKT_DBF   fgupub0 on fguqot0.M_PUBLI = fgupub0.M_REFERENCE
left join CAL_DEF_DBF  fgucal0 on fgupub0.M_CALENDAR = fgucal0.M_LABEL

where 
plin.M_REFERENCE in (select distinct trn.M_INSTRUMENT from TRN_HDR_DBF trn)
)

union 

-- GEN_FIX_CAL0
select GEN_FIX_CAL0 from
(
select
rtrim(plin.M_DSP_LABEL) INS_LAB,
case plin.M_FAMILY
when    16 then rtrim(fxcnt.M_CALENDAR0)
when    32 then rtrim(cmfcal.M_LABEL) 
when    64 then rtrim(fxcur.M_HOLCLN0)
when   256 then rtrim(cmical.M_LABEL)
when 16384 then rtrim(cmfcal.M_LABEL) else null end INS_CAL0, 
case plin.M_FAMILY 
when    16 then rtrim(fxcnt.M_CALENDAR1) else null end INS_CAL1,
case 
when (plin.M_FAMILY = 2 and insgen.M_INSTR_TYPE in (13)) then rtrim(gen.M_FIX_CLN0)
when plin.M_FAMILY = 512 then rtrim(gen.M_FIX_CLN0)
when (cmf.M_LISTED < 64 and cmf.M_INS_MODE = 0) then rtrim(cmfgen.M_FIX_CLN0) else null end GEN_FIX_CAL0,
case 
when (plin.M_FAMILY = 2 and insgen.M_INSTR_TYPE in (13)) then rtrim(gen.M_PAY_CLN0)
when plin.M_FAMILY = 512 then rtrim(gen.M_PAY_CLN0)
when (cmf.M_LISTED < 64 and cmf.M_INS_MODE = 0) then rtrim(cmfgen.M_PAY_CLN0) else null end GEN_PAY_CAL0,
case
when gniobs0.M_CALENDAR = 2 then 'External'
when gniobs0.M_CALENDAR in(3,4) then rtrim(gniobs0.M_STRCALEN)
when fgiobs0.M_CALENDAR = 2 then 'External'
when fgiobs0.M_CALENDAR in(3,4) then rtrim(fgiobs0.M_STRCALEN) else null end OBSCAL0, 
case 
when gni0.M_RESET = 0 then rtrim(gnical0.M_LABEL) 
when gni0.M_RESET = 3 then rtrim(gnigrp0.M_CALENDAR)
when fgi0.M_RESET = 0 then rtrim(fgical0.M_LABEL)
when fgi0.M_RESET = 3 then rtrim(fgigrp0.M_CALENDAR)
when (cmf.M_LISTED < 64 and cmf.M_INS_MODE = 1) then rtrim(fsical.M_LABEL)
when plin.M_FAMILY = 256 then rtrim(cmical.M_LABEL) else null end ARCCAL0,
rtrim(coalesce(gnucal0.M_LABEL, fgucal0.M_LABEL)) UNDCAL0

from TRN_PLIN_DBF plin
left join FX_CURR_DBF fxcur on (plin.M_LABEL = fxcur.M_LABEL and plin.M_FAMILY = 64)
left join CAL_DEF_DBF fxcurcal on fxcur.M_HOLCLN0 = fxcurcal.M_LABEL
left join FX_CNT_DBF fxcnt on (plin.M_LABEL = fxcnt.M_LABEL and plin.M_FAMILY = 16)
left join RT_INDEX_DBF ind on (rtrim(plin.M_LABEL) = rtrim(ind.M_INDEX) and plin.M_FAMILY = 256)
left join CMC_QUOT_DBF cmiqot on trim(substr(plin.M_LABEL,11,15)) = to_char(cmiqot.M_REFERENCE)
left join CM_MKT_DBF cmipub on cmiqot.M_PUBLI = cmipub.M_REFERENCE
left join CAL_DEF_DBF cmical on cmipub.M_CALENDAR = cmical.M_LABEL
left join CM_FUT_DBF cmf on (rtrim(substr(plin.M_LABEL,9,10)) = to_char(cmf.M_REFERENCE) and plin.M_FAMILY in (32,16384))
left join CMC_QUOT_DBF cmfqot on cmf.M_QUOT_FWD = cmfqot.M_REFERENCE
left join CM_MKT_DBF cmfpub on cmfqot.M_PUBLI= cmfpub.M_REFERENCE
left join CAL_DEF_DBF cmfcal on cmfpub.M_CALENDAR = cmfcal.M_LABEL
left join RT_INSGN_DBF insgen on (rtrim(plin.M_LABEL) = to_char(insgen.M_GEN_NUM) and plin.M_FAMILY in (2,512))
left join RT_LNGN_DBF gen on (rtrim(plin.M_LABEL) = to_char(gen.M_GEN_NUM) and plin.M_FAMILY in (2,512))
left join RT_LNGN_DBF  cmfgen on (cmf.M_CM_INSTR = cmfgen.M_GEN_NUM and cmf.M_INS_MODE = 0)
left join RT_INSGN_DBF cmfins on (cmfgen.M_GEN_NUM = cmfins.M_GEN_NUM)
left join RT_INDEX_DBF gni0 on gen.M_INDEX0 = gni0.M_INDEX
left join RT_GROUP_DBF gnigrp0 on gni0.M_HISFILE = gnigrp0.M_HISFILE
left join CMC_QUOT_DBF gniqot0 on gni0.M_COM_QUOT = gniqot0.M_REFERENCE
left join CM_MKT_DBF   gnipub0 on gniqot0.M_PUBLI = gnipub0.M_REFERENCE
left join CAL_DEF_DBF  gnical0 on gnipub0.M_CALENDAR = gnical0.M_LABEL
left join DAT_ECH_DBF gniobs0 on gni0.M_UEI = gniobs0.M_LABEL
left join RT_INDEX_DBF fgi0 on cmfgen.M_INDEX0 = fgi0.M_INDEX
left join RT_GROUP_DBF fgigrp0 on fgi0.M_HISFILE = fgigrp0.M_HISFILE
left join CMC_QUOT_DBF fgiqot0 on fgi0.M_COM_QUOT = fgiqot0.M_REFERENCE
left join CM_MKT_DBF   fgipub0 on fgiqot0.M_PUBLI = fgipub0.M_REFERENCE
left join CAL_DEF_DBF  fgical0 on fgipub0.M_CALENDAR = fgical0.M_LABEL
left join DAT_ECH_DBF fgiobs0 on fgi0.M_UEI = fgiobs0.M_LABEL
left join CMC_MGEN_DBF mgen on (cmf.M_CM_INSTR = mgen.M_REFERENCE and cmf.M_INS_MODE = 1)
left join RT_INDEX_DBF fsi on mgen.M_INDEX = fsi.M_INDEX
left join CMC_QUOT_DBF fsiqot on fsi.M_COM_QUOT = fsiqot.M_REFERENCE
left join CM_MKT_DBF   fsipub on fsiqot.M_PUBLI = fsipub.M_REFERENCE
left join CAL_DEF_DBF  fsical on fsipub.M_CALENDAR = fsical.M_LABEL
left join RT_INDEX_DBF gnu0 on gni0.M_UNDRL = gnu0.M_INDEX
left join RT_GROUP_DBF gnugrp0 on gnu0.M_HISFILE = gnugrp0.M_HISFILE
left join CMC_QUOT_DBF gnuqot0 on gnu0.M_COM_QUOT = gnuqot0.M_REFERENCE
left join CM_MKT_DBF   gnupub0 on gnuqot0.M_PUBLI = gnupub0.M_REFERENCE
left join CAL_DEF_DBF  gnucal0 on gnupub0.M_CALENDAR = gnucal0.M_LABEL
left join RT_INDEX_DBF fgu0 on fgi0.M_UNDRL = fgu0.M_INDEX
left join RT_GROUP_DBF fgugrp0 on fgu0.M_HISFILE = fgugrp0.M_HISFILE
left join CMC_QUOT_DBF fguqot0 on fgu0.M_COM_QUOT = fguqot0.M_REFERENCE
left join CM_MKT_DBF   fgupub0 on fguqot0.M_PUBLI = fgupub0.M_REFERENCE
left join CAL_DEF_DBF  fgucal0 on fgupub0.M_CALENDAR = fgucal0.M_LABEL

where 
plin.M_REFERENCE in (select distinct trn.M_INSTRUMENT from TRN_HDR_DBF trn)
)

union

-- GEN_PAY_CAL0
select GEN_PAY_CAL0 from
(
select
rtrim(plin.M_DSP_LABEL) INS_LAB,
case plin.M_FAMILY
when    16 then rtrim(fxcnt.M_CALENDAR0)
when    32 then rtrim(cmfcal.M_LABEL) 
when    64 then rtrim(fxcur.M_HOLCLN0)
when   256 then rtrim(cmical.M_LABEL)
when 16384 then rtrim(cmfcal.M_LABEL) else null end INS_CAL0, 
case plin.M_FAMILY 
when    16 then rtrim(fxcnt.M_CALENDAR1) else null end INS_CAL1,
case 
when (plin.M_FAMILY = 2 and insgen.M_INSTR_TYPE in (13)) then rtrim(gen.M_FIX_CLN0)
when plin.M_FAMILY = 512 then rtrim(gen.M_FIX_CLN0)
when (cmf.M_LISTED < 64 and cmf.M_INS_MODE = 0) then rtrim(cmfgen.M_FIX_CLN0) else null end GEN_FIX_CAL0,
case 
when (plin.M_FAMILY = 2 and insgen.M_INSTR_TYPE in (13)) then rtrim(gen.M_PAY_CLN0)
when plin.M_FAMILY = 512 then rtrim(gen.M_PAY_CLN0)
when (cmf.M_LISTED < 64 and cmf.M_INS_MODE = 0) then rtrim(cmfgen.M_PAY_CLN0) else null end GEN_PAY_CAL0,
case
when gniobs0.M_CALENDAR = 2 then 'External'
when gniobs0.M_CALENDAR in(3,4) then rtrim(gniobs0.M_STRCALEN)
when fgiobs0.M_CALENDAR = 2 then 'External'
when fgiobs0.M_CALENDAR in(3,4) then rtrim(fgiobs0.M_STRCALEN) else null end OBSCAL0, 
case 
when gni0.M_RESET = 0 then rtrim(gnical0.M_LABEL) 
when gni0.M_RESET = 3 then rtrim(gnigrp0.M_CALENDAR)
when fgi0.M_RESET = 0 then rtrim(fgical0.M_LABEL)
when fgi0.M_RESET = 3 then rtrim(fgigrp0.M_CALENDAR)
when (cmf.M_LISTED < 64 and cmf.M_INS_MODE = 1) then rtrim(fsical.M_LABEL)
when plin.M_FAMILY = 256 then rtrim(cmical.M_LABEL) else null end ARCCAL0,
rtrim(coalesce(gnucal0.M_LABEL, fgucal0.M_LABEL)) UNDCAL0

from TRN_PLIN_DBF plin
left join FX_CURR_DBF fxcur on (plin.M_LABEL = fxcur.M_LABEL and plin.M_FAMILY = 64)
left join CAL_DEF_DBF fxcurcal on fxcur.M_HOLCLN0 = fxcurcal.M_LABEL
left join FX_CNT_DBF fxcnt on (plin.M_LABEL = fxcnt.M_LABEL and plin.M_FAMILY = 16)
left join RT_INDEX_DBF ind on (rtrim(plin.M_LABEL) = rtrim(ind.M_INDEX) and plin.M_FAMILY = 256)
left join CMC_QUOT_DBF cmiqot on trim(substr(plin.M_LABEL,11,15)) = to_char(cmiqot.M_REFERENCE)
left join CM_MKT_DBF cmipub on cmiqot.M_PUBLI = cmipub.M_REFERENCE
left join CAL_DEF_DBF cmical on cmipub.M_CALENDAR = cmical.M_LABEL
left join CM_FUT_DBF cmf on (rtrim(substr(plin.M_LABEL,9,10)) = to_char(cmf.M_REFERENCE) and plin.M_FAMILY in (32,16384))
left join CMC_QUOT_DBF cmfqot on cmf.M_QUOT_FWD = cmfqot.M_REFERENCE
left join CM_MKT_DBF cmfpub on cmfqot.M_PUBLI= cmfpub.M_REFERENCE
left join CAL_DEF_DBF cmfcal on cmfpub.M_CALENDAR = cmfcal.M_LABEL
left join RT_INSGN_DBF insgen on (rtrim(plin.M_LABEL) = to_char(insgen.M_GEN_NUM) and plin.M_FAMILY in (2,512))
left join RT_LNGN_DBF gen on (rtrim(plin.M_LABEL) = to_char(gen.M_GEN_NUM) and plin.M_FAMILY in (2,512))
left join RT_LNGN_DBF  cmfgen on (cmf.M_CM_INSTR = cmfgen.M_GEN_NUM and cmf.M_INS_MODE = 0)
left join RT_INSGN_DBF cmfins on (cmfgen.M_GEN_NUM = cmfins.M_GEN_NUM)
left join RT_INDEX_DBF gni0 on gen.M_INDEX0 = gni0.M_INDEX
left join RT_GROUP_DBF gnigrp0 on gni0.M_HISFILE = gnigrp0.M_HISFILE
left join CMC_QUOT_DBF gniqot0 on gni0.M_COM_QUOT = gniqot0.M_REFERENCE
left join CM_MKT_DBF   gnipub0 on gniqot0.M_PUBLI = gnipub0.M_REFERENCE
left join CAL_DEF_DBF  gnical0 on gnipub0.M_CALENDAR = gnical0.M_LABEL
left join DAT_ECH_DBF gniobs0 on gni0.M_UEI = gniobs0.M_LABEL
left join RT_INDEX_DBF fgi0 on cmfgen.M_INDEX0 = fgi0.M_INDEX
left join RT_GROUP_DBF fgigrp0 on fgi0.M_HISFILE = fgigrp0.M_HISFILE
left join CMC_QUOT_DBF fgiqot0 on fgi0.M_COM_QUOT = fgiqot0.M_REFERENCE
left join CM_MKT_DBF   fgipub0 on fgiqot0.M_PUBLI = fgipub0.M_REFERENCE
left join CAL_DEF_DBF  fgical0 on fgipub0.M_CALENDAR = fgical0.M_LABEL
left join DAT_ECH_DBF fgiobs0 on fgi0.M_UEI = fgiobs0.M_LABEL
left join CMC_MGEN_DBF mgen on (cmf.M_CM_INSTR = mgen.M_REFERENCE and cmf.M_INS_MODE = 1)
left join RT_INDEX_DBF fsi on mgen.M_INDEX = fsi.M_INDEX
left join CMC_QUOT_DBF fsiqot on fsi.M_COM_QUOT = fsiqot.M_REFERENCE
left join CM_MKT_DBF   fsipub on fsiqot.M_PUBLI = fsipub.M_REFERENCE
left join CAL_DEF_DBF  fsical on fsipub.M_CALENDAR = fsical.M_LABEL
left join RT_INDEX_DBF gnu0 on gni0.M_UNDRL = gnu0.M_INDEX
left join RT_GROUP_DBF gnugrp0 on gnu0.M_HISFILE = gnugrp0.M_HISFILE
left join CMC_QUOT_DBF gnuqot0 on gnu0.M_COM_QUOT = gnuqot0.M_REFERENCE
left join CM_MKT_DBF   gnupub0 on gnuqot0.M_PUBLI = gnupub0.M_REFERENCE
left join CAL_DEF_DBF  gnucal0 on gnupub0.M_CALENDAR = gnucal0.M_LABEL
left join RT_INDEX_DBF fgu0 on fgi0.M_UNDRL = fgu0.M_INDEX
left join RT_GROUP_DBF fgugrp0 on fgu0.M_HISFILE = fgugrp0.M_HISFILE
left join CMC_QUOT_DBF fguqot0 on fgu0.M_COM_QUOT = fguqot0.M_REFERENCE
left join CM_MKT_DBF   fgupub0 on fguqot0.M_PUBLI = fgupub0.M_REFERENCE
left join CAL_DEF_DBF  fgucal0 on fgupub0.M_CALENDAR = fgucal0.M_LABEL

where 
plin.M_REFERENCE in (select distinct trn.M_INSTRUMENT from TRN_HDR_DBF trn)
)

union 

-- ARCCAL0
select ARCCAL0 from
(
select
rtrim(plin.M_DSP_LABEL) INS_LAB,
case plin.M_FAMILY
when    16 then rtrim(fxcnt.M_CALENDAR0)
when    32 then rtrim(cmfcal.M_LABEL) 
when    64 then rtrim(fxcur.M_HOLCLN0)
when   256 then rtrim(cmical.M_LABEL)
when 16384 then rtrim(cmfcal.M_LABEL) else null end INS_CAL0, 
case plin.M_FAMILY 
when    16 then rtrim(fxcnt.M_CALENDAR1) else null end INS_CAL1,
case 
when (plin.M_FAMILY = 2 and insgen.M_INSTR_TYPE in (13)) then rtrim(gen.M_FIX_CLN0)
when plin.M_FAMILY = 512 then rtrim(gen.M_FIX_CLN0)
when (cmf.M_LISTED < 64 and cmf.M_INS_MODE = 0) then rtrim(cmfgen.M_FIX_CLN0) else null end GEN_FIX_CAL0,
case 
when (plin.M_FAMILY = 2 and insgen.M_INSTR_TYPE in (13)) then rtrim(gen.M_PAY_CLN0)
when plin.M_FAMILY = 512 then rtrim(gen.M_PAY_CLN0)
when (cmf.M_LISTED < 64 and cmf.M_INS_MODE = 0) then rtrim(cmfgen.M_PAY_CLN0) else null end GEN_PAY_CAL0,
case
when gniobs0.M_CALENDAR = 2 then 'External'
when gniobs0.M_CALENDAR in(3,4) then rtrim(gniobs0.M_STRCALEN)
when fgiobs0.M_CALENDAR = 2 then 'External'
when fgiobs0.M_CALENDAR in(3,4) then rtrim(fgiobs0.M_STRCALEN) else null end OBSCAL0, 
case 
when gni0.M_RESET = 0 then rtrim(gnical0.M_LABEL) 
when gni0.M_RESET = 3 then rtrim(gnigrp0.M_CALENDAR)
when fgi0.M_RESET = 0 then rtrim(fgical0.M_LABEL)
when fgi0.M_RESET = 3 then rtrim(fgigrp0.M_CALENDAR)
when (cmf.M_LISTED < 64 and cmf.M_INS_MODE = 1) then rtrim(fsical.M_LABEL)
when plin.M_FAMILY = 256 then rtrim(cmical.M_LABEL) else null end ARCCAL0,
rtrim(coalesce(gnucal0.M_LABEL, fgucal0.M_LABEL)) UNDCAL0

from TRN_PLIN_DBF plin
left join FX_CURR_DBF fxcur on (plin.M_LABEL = fxcur.M_LABEL and plin.M_FAMILY = 64)
left join CAL_DEF_DBF fxcurcal on fxcur.M_HOLCLN0 = fxcurcal.M_LABEL
left join FX_CNT_DBF fxcnt on (plin.M_LABEL = fxcnt.M_LABEL and plin.M_FAMILY = 16)
left join RT_INDEX_DBF ind on (rtrim(plin.M_LABEL) = rtrim(ind.M_INDEX) and plin.M_FAMILY = 256)
left join CMC_QUOT_DBF cmiqot on trim(substr(plin.M_LABEL,11,15)) = to_char(cmiqot.M_REFERENCE)
left join CM_MKT_DBF cmipub on cmiqot.M_PUBLI = cmipub.M_REFERENCE
left join CAL_DEF_DBF cmical on cmipub.M_CALENDAR = cmical.M_LABEL
left join CM_FUT_DBF cmf on (rtrim(substr(plin.M_LABEL,9,10)) = to_char(cmf.M_REFERENCE) and plin.M_FAMILY in (32,16384))
left join CMC_QUOT_DBF cmfqot on cmf.M_QUOT_FWD = cmfqot.M_REFERENCE
left join CM_MKT_DBF cmfpub on cmfqot.M_PUBLI= cmfpub.M_REFERENCE
left join CAL_DEF_DBF cmfcal on cmfpub.M_CALENDAR = cmfcal.M_LABEL
left join RT_INSGN_DBF insgen on (rtrim(plin.M_LABEL) = to_char(insgen.M_GEN_NUM) and plin.M_FAMILY in (2,512))
left join RT_LNGN_DBF gen on (rtrim(plin.M_LABEL) = to_char(gen.M_GEN_NUM) and plin.M_FAMILY in (2,512))
left join RT_LNGN_DBF  cmfgen on (cmf.M_CM_INSTR = cmfgen.M_GEN_NUM and cmf.M_INS_MODE = 0)
left join RT_INSGN_DBF cmfins on (cmfgen.M_GEN_NUM = cmfins.M_GEN_NUM)
left join RT_INDEX_DBF gni0 on gen.M_INDEX0 = gni0.M_INDEX
left join RT_GROUP_DBF gnigrp0 on gni0.M_HISFILE = gnigrp0.M_HISFILE
left join CMC_QUOT_DBF gniqot0 on gni0.M_COM_QUOT = gniqot0.M_REFERENCE
left join CM_MKT_DBF   gnipub0 on gniqot0.M_PUBLI = gnipub0.M_REFERENCE
left join CAL_DEF_DBF  gnical0 on gnipub0.M_CALENDAR = gnical0.M_LABEL
left join DAT_ECH_DBF gniobs0 on gni0.M_UEI = gniobs0.M_LABEL
left join RT_INDEX_DBF fgi0 on cmfgen.M_INDEX0 = fgi0.M_INDEX
left join RT_GROUP_DBF fgigrp0 on fgi0.M_HISFILE = fgigrp0.M_HISFILE
left join CMC_QUOT_DBF fgiqot0 on fgi0.M_COM_QUOT = fgiqot0.M_REFERENCE
left join CM_MKT_DBF   fgipub0 on fgiqot0.M_PUBLI = fgipub0.M_REFERENCE
left join CAL_DEF_DBF  fgical0 on fgipub0.M_CALENDAR = fgical0.M_LABEL
left join DAT_ECH_DBF fgiobs0 on fgi0.M_UEI = fgiobs0.M_LABEL
left join CMC_MGEN_DBF mgen on (cmf.M_CM_INSTR = mgen.M_REFERENCE and cmf.M_INS_MODE = 1)
left join RT_INDEX_DBF fsi on mgen.M_INDEX = fsi.M_INDEX
left join CMC_QUOT_DBF fsiqot on fsi.M_COM_QUOT = fsiqot.M_REFERENCE
left join CM_MKT_DBF   fsipub on fsiqot.M_PUBLI = fsipub.M_REFERENCE
left join CAL_DEF_DBF  fsical on fsipub.M_CALENDAR = fsical.M_LABEL
left join RT_INDEX_DBF gnu0 on gni0.M_UNDRL = gnu0.M_INDEX
left join RT_GROUP_DBF gnugrp0 on gnu0.M_HISFILE = gnugrp0.M_HISFILE
left join CMC_QUOT_DBF gnuqot0 on gnu0.M_COM_QUOT = gnuqot0.M_REFERENCE
left join CM_MKT_DBF   gnupub0 on gnuqot0.M_PUBLI = gnupub0.M_REFERENCE
left join CAL_DEF_DBF  gnucal0 on gnupub0.M_CALENDAR = gnucal0.M_LABEL
left join RT_INDEX_DBF fgu0 on fgi0.M_UNDRL = fgu0.M_INDEX
left join RT_GROUP_DBF fgugrp0 on fgu0.M_HISFILE = fgugrp0.M_HISFILE
left join CMC_QUOT_DBF fguqot0 on fgu0.M_COM_QUOT = fguqot0.M_REFERENCE
left join CM_MKT_DBF   fgupub0 on fguqot0.M_PUBLI = fgupub0.M_REFERENCE
left join CAL_DEF_DBF  fgucal0 on fgupub0.M_CALENDAR = fgucal0.M_LABEL

where 
plin.M_REFERENCE in (select distinct trn.M_INSTRUMENT from TRN_HDR_DBF trn)
)

union 

-- OBSCAL0
select OBSCAL0 from
(
select
rtrim(plin.M_DSP_LABEL) INS_LAB,
case plin.M_FAMILY
when    16 then rtrim(fxcnt.M_CALENDAR0)
when    32 then rtrim(cmfcal.M_LABEL) 
when    64 then rtrim(fxcur.M_HOLCLN0)
when   256 then rtrim(cmical.M_LABEL)
when 16384 then rtrim(cmfcal.M_LABEL) else null end INS_CAL0, 
case plin.M_FAMILY 
when    16 then rtrim(fxcnt.M_CALENDAR1) else null end INS_CAL1,
case 
when (plin.M_FAMILY = 2 and insgen.M_INSTR_TYPE in (13)) then rtrim(gen.M_FIX_CLN0)
when plin.M_FAMILY = 512 then rtrim(gen.M_FIX_CLN0)
when (cmf.M_LISTED < 64 and cmf.M_INS_MODE = 0) then rtrim(cmfgen.M_FIX_CLN0) else null end GEN_FIX_CAL0,
case 
when (plin.M_FAMILY = 2 and insgen.M_INSTR_TYPE in (13)) then rtrim(gen.M_PAY_CLN0)
when plin.M_FAMILY = 512 then rtrim(gen.M_PAY_CLN0)
when (cmf.M_LISTED < 64 and cmf.M_INS_MODE = 0) then rtrim(cmfgen.M_PAY_CLN0) else null end GEN_PAY_CAL0,
case
when gniobs0.M_CALENDAR = 2 then 'External'
when gniobs0.M_CALENDAR in(3,4) then rtrim(gniobs0.M_STRCALEN)
when fgiobs0.M_CALENDAR = 2 then 'External'
when fgiobs0.M_CALENDAR in(3,4) then rtrim(fgiobs0.M_STRCALEN) else null end OBSCAL0, 
case 
when gni0.M_RESET = 0 then rtrim(gnical0.M_LABEL) 
when gni0.M_RESET = 3 then rtrim(gnigrp0.M_CALENDAR)
when fgi0.M_RESET = 0 then rtrim(fgical0.M_LABEL)
when fgi0.M_RESET = 3 then rtrim(fgigrp0.M_CALENDAR)
when (cmf.M_LISTED < 64 and cmf.M_INS_MODE = 1) then rtrim(fsical.M_LABEL)
when plin.M_FAMILY = 256 then rtrim(cmical.M_LABEL) else null end ARCCAL0,
rtrim(coalesce(gnucal0.M_LABEL, fgucal0.M_LABEL)) UNDCAL0

from TRN_PLIN_DBF plin
left join FX_CURR_DBF fxcur on (plin.M_LABEL = fxcur.M_LABEL and plin.M_FAMILY = 64)
left join CAL_DEF_DBF fxcurcal on fxcur.M_HOLCLN0 = fxcurcal.M_LABEL
left join FX_CNT_DBF fxcnt on (plin.M_LABEL = fxcnt.M_LABEL and plin.M_FAMILY = 16)
left join RT_INDEX_DBF ind on (rtrim(plin.M_LABEL) = rtrim(ind.M_INDEX) and plin.M_FAMILY = 256)
left join CMC_QUOT_DBF cmiqot on trim(substr(plin.M_LABEL,11,15)) = to_char(cmiqot.M_REFERENCE)
left join CM_MKT_DBF cmipub on cmiqot.M_PUBLI = cmipub.M_REFERENCE
left join CAL_DEF_DBF cmical on cmipub.M_CALENDAR = cmical.M_LABEL
left join CM_FUT_DBF cmf on (rtrim(substr(plin.M_LABEL,9,10)) = to_char(cmf.M_REFERENCE) and plin.M_FAMILY in (32,16384))
left join CMC_QUOT_DBF cmfqot on cmf.M_QUOT_FWD = cmfqot.M_REFERENCE
left join CM_MKT_DBF cmfpub on cmfqot.M_PUBLI= cmfpub.M_REFERENCE
left join CAL_DEF_DBF cmfcal on cmfpub.M_CALENDAR = cmfcal.M_LABEL
left join RT_INSGN_DBF insgen on (rtrim(plin.M_LABEL) = to_char(insgen.M_GEN_NUM) and plin.M_FAMILY in (2,512))
left join RT_LNGN_DBF gen on (rtrim(plin.M_LABEL) = to_char(gen.M_GEN_NUM) and plin.M_FAMILY in (2,512))
left join RT_LNGN_DBF  cmfgen on (cmf.M_CM_INSTR = cmfgen.M_GEN_NUM and cmf.M_INS_MODE = 0)
left join RT_INSGN_DBF cmfins on (cmfgen.M_GEN_NUM = cmfins.M_GEN_NUM)
left join RT_INDEX_DBF gni0 on gen.M_INDEX0 = gni0.M_INDEX
left join RT_GROUP_DBF gnigrp0 on gni0.M_HISFILE = gnigrp0.M_HISFILE
left join CMC_QUOT_DBF gniqot0 on gni0.M_COM_QUOT = gniqot0.M_REFERENCE
left join CM_MKT_DBF   gnipub0 on gniqot0.M_PUBLI = gnipub0.M_REFERENCE
left join CAL_DEF_DBF  gnical0 on gnipub0.M_CALENDAR = gnical0.M_LABEL
left join DAT_ECH_DBF gniobs0 on gni0.M_UEI = gniobs0.M_LABEL
left join RT_INDEX_DBF fgi0 on cmfgen.M_INDEX0 = fgi0.M_INDEX
left join RT_GROUP_DBF fgigrp0 on fgi0.M_HISFILE = fgigrp0.M_HISFILE
left join CMC_QUOT_DBF fgiqot0 on fgi0.M_COM_QUOT = fgiqot0.M_REFERENCE
left join CM_MKT_DBF   fgipub0 on fgiqot0.M_PUBLI = fgipub0.M_REFERENCE
left join CAL_DEF_DBF  fgical0 on fgipub0.M_CALENDAR = fgical0.M_LABEL
left join DAT_ECH_DBF fgiobs0 on fgi0.M_UEI = fgiobs0.M_LABEL
left join CMC_MGEN_DBF mgen on (cmf.M_CM_INSTR = mgen.M_REFERENCE and cmf.M_INS_MODE = 1)
left join RT_INDEX_DBF fsi on mgen.M_INDEX = fsi.M_INDEX
left join CMC_QUOT_DBF fsiqot on fsi.M_COM_QUOT = fsiqot.M_REFERENCE
left join CM_MKT_DBF   fsipub on fsiqot.M_PUBLI = fsipub.M_REFERENCE
left join CAL_DEF_DBF  fsical on fsipub.M_CALENDAR = fsical.M_LABEL
left join RT_INDEX_DBF gnu0 on gni0.M_UNDRL = gnu0.M_INDEX
left join RT_GROUP_DBF gnugrp0 on gnu0.M_HISFILE = gnugrp0.M_HISFILE
left join CMC_QUOT_DBF gnuqot0 on gnu0.M_COM_QUOT = gnuqot0.M_REFERENCE
left join CM_MKT_DBF   gnupub0 on gnuqot0.M_PUBLI = gnupub0.M_REFERENCE
left join CAL_DEF_DBF  gnucal0 on gnupub0.M_CALENDAR = gnucal0.M_LABEL
left join RT_INDEX_DBF fgu0 on fgi0.M_UNDRL = fgu0.M_INDEX
left join RT_GROUP_DBF fgugrp0 on fgu0.M_HISFILE = fgugrp0.M_HISFILE
left join CMC_QUOT_DBF fguqot0 on fgu0.M_COM_QUOT = fguqot0.M_REFERENCE
left join CM_MKT_DBF   fgupub0 on fguqot0.M_PUBLI = fgupub0.M_REFERENCE
left join CAL_DEF_DBF  fgucal0 on fgupub0.M_CALENDAR = fgucal0.M_LABEL

where 
plin.M_REFERENCE in (select distinct trn.M_INSTRUMENT from TRN_HDR_DBF trn)
)

union 

select UNDCAL0 from
(
select
rtrim(plin.M_DSP_LABEL) INS_LAB,
case plin.M_FAMILY
when    16 then rtrim(fxcnt.M_CALENDAR0)
when    32 then rtrim(cmfcal.M_LABEL) 
when    64 then rtrim(fxcur.M_HOLCLN0)
when   256 then rtrim(cmical.M_LABEL)
when 16384 then rtrim(cmfcal.M_LABEL) else null end INS_CAL0, 
case plin.M_FAMILY 
when    16 then rtrim(fxcnt.M_CALENDAR1) else null end INS_CAL1,
case 
when (plin.M_FAMILY = 2 and insgen.M_INSTR_TYPE in (13)) then rtrim(gen.M_FIX_CLN0)
when plin.M_FAMILY = 512 then rtrim(gen.M_FIX_CLN0)
when (cmf.M_LISTED < 64 and cmf.M_INS_MODE = 0) then rtrim(cmfgen.M_FIX_CLN0) else null end GEN_FIX_CAL0,
case 
when (plin.M_FAMILY = 2 and insgen.M_INSTR_TYPE in (13)) then rtrim(gen.M_PAY_CLN0)
when plin.M_FAMILY = 512 then rtrim(gen.M_PAY_CLN0)
when (cmf.M_LISTED < 64 and cmf.M_INS_MODE = 0) then rtrim(cmfgen.M_PAY_CLN0) else null end GEN_PAY_CAL0,
case
when gniobs0.M_CALENDAR = 2 then 'External'
when gniobs0.M_CALENDAR in(3,4) then rtrim(gniobs0.M_STRCALEN)
when fgiobs0.M_CALENDAR = 2 then 'External'
when fgiobs0.M_CALENDAR in(3,4) then rtrim(fgiobs0.M_STRCALEN) else null end OBSCAL0, 
case 
when gni0.M_RESET = 0 then rtrim(gnical0.M_LABEL) 
when gni0.M_RESET = 3 then rtrim(gnigrp0.M_CALENDAR)
when fgi0.M_RESET = 0 then rtrim(fgical0.M_LABEL)
when fgi0.M_RESET = 3 then rtrim(fgigrp0.M_CALENDAR)
when (cmf.M_LISTED < 64 and cmf.M_INS_MODE = 1) then rtrim(fsical.M_LABEL)
when plin.M_FAMILY = 256 then rtrim(cmical.M_LABEL) else null end ARCCAL0,
rtrim(coalesce(gnucal0.M_LABEL, fgucal0.M_LABEL)) UNDCAL0

from TRN_PLIN_DBF plin
left join FX_CURR_DBF fxcur on (plin.M_LABEL = fxcur.M_LABEL and plin.M_FAMILY = 64)
left join CAL_DEF_DBF fxcurcal on fxcur.M_HOLCLN0 = fxcurcal.M_LABEL
left join FX_CNT_DBF fxcnt on (plin.M_LABEL = fxcnt.M_LABEL and plin.M_FAMILY = 16)
left join RT_INDEX_DBF ind on (rtrim(plin.M_LABEL) = rtrim(ind.M_INDEX) and plin.M_FAMILY = 256)
left join CMC_QUOT_DBF cmiqot on trim(substr(plin.M_LABEL,11,15)) = to_char(cmiqot.M_REFERENCE)
left join CM_MKT_DBF cmipub on cmiqot.M_PUBLI = cmipub.M_REFERENCE
left join CAL_DEF_DBF cmical on cmipub.M_CALENDAR = cmical.M_LABEL
left join CM_FUT_DBF cmf on (rtrim(substr(plin.M_LABEL,9,10)) = to_char(cmf.M_REFERENCE) and plin.M_FAMILY in (32,16384))
left join CMC_QUOT_DBF cmfqot on cmf.M_QUOT_FWD = cmfqot.M_REFERENCE
left join CM_MKT_DBF cmfpub on cmfqot.M_PUBLI= cmfpub.M_REFERENCE
left join CAL_DEF_DBF cmfcal on cmfpub.M_CALENDAR = cmfcal.M_LABEL
left join RT_INSGN_DBF insgen on (rtrim(plin.M_LABEL) = to_char(insgen.M_GEN_NUM) and plin.M_FAMILY in (2,512))
left join RT_LNGN_DBF gen on (rtrim(plin.M_LABEL) = to_char(gen.M_GEN_NUM) and plin.M_FAMILY in (2,512))
left join RT_LNGN_DBF  cmfgen on (cmf.M_CM_INSTR = cmfgen.M_GEN_NUM and cmf.M_INS_MODE = 0)
left join RT_INSGN_DBF cmfins on (cmfgen.M_GEN_NUM = cmfins.M_GEN_NUM)
left join RT_INDEX_DBF gni0 on gen.M_INDEX0 = gni0.M_INDEX
left join RT_GROUP_DBF gnigrp0 on gni0.M_HISFILE = gnigrp0.M_HISFILE
left join CMC_QUOT_DBF gniqot0 on gni0.M_COM_QUOT = gniqot0.M_REFERENCE
left join CM_MKT_DBF   gnipub0 on gniqot0.M_PUBLI = gnipub0.M_REFERENCE
left join CAL_DEF_DBF  gnical0 on gnipub0.M_CALENDAR = gnical0.M_LABEL
left join DAT_ECH_DBF gniobs0 on gni0.M_UEI = gniobs0.M_LABEL
left join RT_INDEX_DBF fgi0 on cmfgen.M_INDEX0 = fgi0.M_INDEX
left join RT_GROUP_DBF fgigrp0 on fgi0.M_HISFILE = fgigrp0.M_HISFILE
left join CMC_QUOT_DBF fgiqot0 on fgi0.M_COM_QUOT = fgiqot0.M_REFERENCE
left join CM_MKT_DBF   fgipub0 on fgiqot0.M_PUBLI = fgipub0.M_REFERENCE
left join CAL_DEF_DBF  fgical0 on fgipub0.M_CALENDAR = fgical0.M_LABEL
left join DAT_ECH_DBF fgiobs0 on fgi0.M_UEI = fgiobs0.M_LABEL
left join CMC_MGEN_DBF mgen on (cmf.M_CM_INSTR = mgen.M_REFERENCE and cmf.M_INS_MODE = 1)
left join RT_INDEX_DBF fsi on mgen.M_INDEX = fsi.M_INDEX
left join CMC_QUOT_DBF fsiqot on fsi.M_COM_QUOT = fsiqot.M_REFERENCE
left join CM_MKT_DBF   fsipub on fsiqot.M_PUBLI = fsipub.M_REFERENCE
left join CAL_DEF_DBF  fsical on fsipub.M_CALENDAR = fsical.M_LABEL
left join RT_INDEX_DBF gnu0 on gni0.M_UNDRL = gnu0.M_INDEX
left join RT_GROUP_DBF gnugrp0 on gnu0.M_HISFILE = gnugrp0.M_HISFILE
left join CMC_QUOT_DBF gnuqot0 on gnu0.M_COM_QUOT = gnuqot0.M_REFERENCE
left join CM_MKT_DBF   gnupub0 on gnuqot0.M_PUBLI = gnupub0.M_REFERENCE
left join CAL_DEF_DBF  gnucal0 on gnupub0.M_CALENDAR = gnucal0.M_LABEL
left join RT_INDEX_DBF fgu0 on fgi0.M_UNDRL = fgu0.M_INDEX
left join RT_GROUP_DBF fgugrp0 on fgu0.M_HISFILE = fgugrp0.M_HISFILE
left join CMC_QUOT_DBF fguqot0 on fgu0.M_COM_QUOT = fguqot0.M_REFERENCE
left join CM_MKT_DBF   fgupub0 on fguqot0.M_PUBLI = fgupub0.M_REFERENCE
left join CAL_DEF_DBF  fgucal0 on fgupub0.M_CALENDAR = fgucal0.M_LABEL

where 
plin.M_REFERENCE in (select distinct trn.M_INSTRUMENT from TRN_HDR_DBF trn)
)

) caltrn

left join CAL_DEF_DBF caldef on rtrim(caltrn.CAL) = rtrim(caldef.M_LABEL)
left join KEYMAP_STC_DBF altid on (rtrim(caldef.M_LABEL) = rtrim(altid.M_OBJ_DESC) and altid.M_OBJ_CLASS = 'MbRYC67318')  

order by CAL