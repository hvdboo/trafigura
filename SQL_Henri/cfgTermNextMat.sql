select
to_char(pc.M_DATE,'YYYY-MM-DD') SYSDAT,
rtrim(fut.M_LABEL) FUT,
rtrim(matset.M_LABEL) MATSET,
rtrim(matdat.M_LABEL) MAT,
to_char(M_QT_END,'YYYY-MM-DD') QOTL,
to_char(M_ST_START,'YYYY-MM-DD') DLVF,
to_char(M_ST_END,'YYYY-MM-DD') DLVL

from CM_FMAT1_DBF matdat
left join TRN_PC_DBF pc on 1 = 1
left join CM_FMAT_DBF matset on matdat.M_FMAT_ID = matset.M_REFERENCE
left join CM_FUT_DBF fut on matset.M_REFERENCE = fut.M_FUT_MAT 

-- Instrument
where rtrim(fut.M_LABEL) = 'CO CSSE'

-- Expiry date
and to_char(M_QT_END,'YYYY-MM-DD') > '2018-01-01'
and M_QT_END < pc.M_DATE+30
