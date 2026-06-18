select distinct
rtrim(viwhdr.M_CFG_LBL) LVB_VIEW,
ltrim(rtrim(viwbdy.M_ELT_LBL)) LVB_FLDLAB,
dtm.DTMLAB,
-- dtm.DTMDES,
'M_' || dtm.DTMFLDLAB DTMFLD,
dtm.DTMFLDDES,
dct.M_DES_PATH DICPATH

from VWR_CFGS_DBF viwhdr
inner join vwr_cfg_dbf viwbdy on viwhdr.M_CFG_REF = viwbdy.M_CFG_REF
inner join vwr_dct_dbf dct on viwbdy.M_OBJ_UID = dct.M_OBJ_REF
join livebook_view_dbf lvb on lvb.M_VIEW_REF = viwbdy.M_CFG_REF
inner join
(
select
dtmhdr.M_LABEL DTMLAB,
dtmhdr.M_DESC  DTMDES,
dtmbdy.M_LABEL DTMFLDLAB,
dtmbdy.M_DESC  DTMFLDDES
from rpo_dmsetup_table_dbf dtmhdr
left join rpo_dmsetup_column_dbf dtmbdy on dtmhdr.M_REFERENCE = dtmbdy.M_RPO_DMSETUP_TABLE_REF 
) dtm 

on ltrim(rtrim(viwbdy.M_ELT_LBL)) = ltrim(rtrim(dtm.DTMFLDLAB))

where 1 = 1
and ltrim(rtrim(dct.M_DES_PATH)) is not null
and dtm.DTMLAB in ('TRF_PL_DAILYMOVE.REP', 'TRAF_PL_CONSO.REP', 'PL_BKD_CNV_C.REP')
