select
rtrim(lvb.M_LABEL)        LVBLAB,
-- rtrim(lvb.M_DESC)         LVBDES,
rtrim(pflset.M_LABEL)     SETLAB,
-- rtrim(pflset.M_DESC)      SETDES,
rtrim(lvbpfl.M_TYPE)      PFLTYP,
rtrim(lvbpfl.M_PTF_LABEL) PFLLAB,
case rtrim(lvbpfl.M_TYPE)
when 'S' then rtrim(pfs.M_LABEL)
when 'C' then rtrim(pfc.M_LABEL) else null end UNDLAB

from LIVEBOOK_PTF_DBF lvbpfl
left join LIVEBOOK_PTF_SET_DBF pflset on lvbpfl.M_PTF_SET_REF = pflset.M_REFERENCE
left join LIVEBOOK_DBF lvb on pflset.M_REFERENCE = lvb.M_PTF_SET_REF
left join TRN_PFLD_DBF pfs on rtrim(lvbpfl.M_PTF_LABEL) = rtrim(pfs.M_LABEL) and rtrim(lvbpfl.M_TYPE) = 'S'
left join MUB#GRP_COMB_DBF cmb on rtrim(lvbpfl.M_PTF_LABEL) = rtrim(cmb.M_LABEL) and rtrim(lvbpfl.M_TYPE) = 'C'
left join TRN_PFLD_DBF pfc on cmb.M_UNIT = pfc.M_LABEL and cmb.M_UNIT_TYPE = 2

order by LVBLAB, SETLAB, PFLLAB, UNDLAB
