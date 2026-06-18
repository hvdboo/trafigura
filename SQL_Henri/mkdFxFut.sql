select
to_char(pc.M_DATE,'YYYY-MM-DD') SYSDAT,
to_char(mkdhdr.M__DATE_,'YYYY-MM-DD') VALDAT,
rtrim(mkdhdr.M_MARKET) MKT,
rtrim(mkdhdr.M_CONTRACT) CNT,
rtrim(mkdbdy.M_R_QUOT) QOT,
rtrim(mat.M_LABEL) MATLAB,
to_char(mat.M_MAT,'YYYY-MM-DD') MATDAT,
rtrim(mkdhdr.M__ALIAS_) MDS,
mkdbdy.M_R_BID P_BID,
mkdbdy.M_R_ASK P_ASK

from MPY_PFUT_DBF mkdbdy
left join TRN_PC_DBF pc on 1 = 1
left join MPX_PFUT_DBF mkdhdr on mkdbdy.M__INDEX_ = mkdhdr.M__INDEX_
left join OM_MAT_DBF mat on mkdbdy.M_MAT_CODE = mat.M_CODE

where mkdhdr.M__DATE_ = ?

order by VALDAT, MKT, CNT, QOT, MATDAT, MDS