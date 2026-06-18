select distinct
src.M_TABLE     REPTBL,
src.M_TAG       REPTAG,
src.M_S_FIEL_N  REPFLD,
hdr.M_CFG_LBL   VIWLAB,
bdy.M_ELT_LBL   VIWFLD

from vwr_stg_dbf stg
join src_desc_dbf      src on stg.M_SRC_REF = src.M_REF
join vwr_cfg_dbf       bdy on stg.M_STG_REF = bdy.M_ELT_STG
join vwr_cfgs_dbf      hdr on hdr.M_CFG_REF = bdy.M_CFG_REF
join livebook_view_dbf lvb on bdy.M_CFG_REF = lvb.M_VIEW_REF  
join vwr_dct_dbf       dic on bdy.M_OBJ_UID = dic.M_OBJ_REF

where 1 = 1
and (src.M_TABLE = 'TRF_PL_DAILYMOVE.REP' and src.M_TAG = 'PL_EOD')
or  (src.M_TABLE = 'TRAF_PL_LIGHT.REP' and src.M_TAG = 'PL_EOD')
or  (src.M_TABLE = 'TRAF_PL_CONSO.REP' and src.M_TAG = 'ALL_EOD')
or  (src.M_TABLE = 'PL_BKD_CNV_C.REP'  and src.M_TAG = 'MXPRESS' )

order by src.M_TABLE, hdr.M_CFG_LBL
