select distinct
rtrim(coalesce(sdn.M_SD_PTF, res.M_RES_PTF)) CONFIG,
rtrim(pflAsgH.M_LABEL) PFLASG,
-- rtrim(pflAsgB.M_ENTITY) SRC_CE,
rtrim(pflAsgB.M_PORTFOLIO) SRC_PFL,
rtrim(pflAsgB.M_PNLCUR) SDN_CUR,
rtrim(pflAsgB.M_SDPTF) TGT_PFL,
--Stream
rtrim(srcudf.M_STREAM_C) SRC_STR,
rtrim(tgtudf.M_STREAM_C) TGT_STR,
case when rtrim(srcudf.M_STREAM_C) = rtrim(tgtudf.M_STREAM_C) then 1 else 0 end CHK_STR,
-- Category
rtrim(srcudf.M_PTFCAT) SRC_CAT,
rtrim(tgtudf.M_PTFCAT) TGT_CAT,
case when srcudf.M_PTFCAT in ('H','P') then case when rtrim(srcudf.M_PTFCAT) = rtrim(tgtudf.M_PTFCAT) then 1 else 0 end else 1 end CHK_CAT,
-- Market
rtrim(srcudf.M_MKTTYPE_C) SRC_MKT,
rtrim(tgtudf.M_MKTTYPE_C) TGT_MKT,
case when rtrim(srcudf.M_MKTTYPE_C) = rtrim(tgtudf.M_MKTTYPE_C) then 1 else 0 end CHK_MKT,
-- LE
rtrim(srcpcc.M_DSP_LABEL) SRC_LE,
rtrim(tgtpcc.M_DSP_LABEL) TGT_LE,
case when srcpcc.M_DSP_LABEL = tgtpcc.M_DSP_LABEL then 1 else 0 end CHK_LE

from RTGSDPB_DBF pflAsgB

left join RTGSDPH_DBF pflAsgH on pflAsgB.M__INDEX_ = pflAsgH.M__INDEX_
left join SD_CFG_DBF sdn on rtrim(pflAsgH.M_LABEL) = rtrim(sdn.M_SD_PTF)
left join SD_CFG_DBF res on rtrim(pflAsgH.M_LABEL) = rtrim(res.M_RES_PTF)
left join TRN_PFLD_DBF srcpfl on rtrim(pflAsgB.M_PORTFOLIO) = rtrim(srcpfl.M_LABEL)
left join TRN_PFLD_DBF tgtpfl on rtrim(pflAsgB.M_SDPTF) = rtrim(tgtpfl.M_LABEL)
left join TABLE#DATA#PORTFOLI_DBF srcudf on rtrim(srcpfl.M_LABEL) = rtrim(srcudf.M_LABEL)
left join TABLE#DATA#PORTFOLI_DBF tgtudf on rtrim(tgtpfl.M_LABEL) = rtrim(tgtudf.M_LABEL)
left join TRN_CPDF_DBF srcpcc on srcpfl.M_PROC_AREA = srcpcc.M_ID
left join TRN_CPDF_DBF tgtpcc on tgtpfl.M_PROC_AREA = tgtpcc.M_ID

order by PFLASG, SRC_PFL, SRC_LE, SDN_CUR, TGT_PFL
