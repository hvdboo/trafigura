select 
trn.M_NB TRN,
trn.M_CONTRACT CNT,
rtrim(trn.M_GID) GID,
rtrim(trn.M_TRN_STATUS) STAT,
-- trn.M_TRN_GTYPE FGT,
rtrim(typo.M_LABEL) TYPO,
rtrim(pli.M_DSP_LABEL) PLIN,
rtrim(qot.M_CURR) CUR,
rtrim(uom.M_LABEL) UOM,
rtrim(ext.M_OBS) OBS,
rtrim(ext.M_MATLAB) MATLAB,
to_char(ext.M_MATDAT,'YYYY-MM-DD') MATDAT,
to_char(ext.M_CALC_FST,'YYYY-MM-DD') CLCFST,
to_char(ext.M_CALC_LST,'YYYY-MM-DD') CLCLST,
trn.M_BRW_STRK STK,
trn.M_BRW_CP RGT,
trn.M_BRW_RTE1 PRC,
--case (when trn.M_BRW_RTE1 PRM,
case when trn.M_TRN_GTYPE in (1, 2, 130, 131, 134, 136, 146, 154) then
case trn.M_BRW_PR1
when 'R' then 'B'
when 'P' then 'S' else null end
else rtrim(trn.M_COMMENT_BS) end DIR,
trn.M_BRW_NOM1 NOM,
ext.M_TOT_QTY QTY,
case when trn.M_BINTERNAL = trn.M_SINTERNAL then 'I' else 'E' end IE,
rtrim(src.M_LABEL) PFL,
case when trn.M_BINTERNAL = trn.M_SINTERNAL then rtrim(dst.M_LABEL) else rtrim(ctp.M_DSP_LABEL) end CTP

from TRN_HDR_DBF trn
left join CONTRACT_DBF cnt on trn.M_CONTRACT = cnt.M_REFERENCE
left join TYPOLOGY_DBF typo on cnt.M_TYPOLOGY = typo.M_REFERENCE 
left join TRN_PLIN_DBF pli on trn.M_INSTRUMENT = pli.M_REFERENCE
left join CMT_PLKEY1_DBF plk on trim(trn.M_PL_KEY1) = to_char(plk.M_REFERENCE)
left join CMC_QUOT_DBF qot on plk.M_QUOT = qot.M_REFERENCE
left join CM_UNIT_DBF uom on qot.M_UNIT = uom.M_REFERENCE
left join EXT_COM_DBF  ext on trn.M_NB = ext.M_TNB
left join TRN_PFLD_DBF src on trn.M_SRC_PFOLIO = src.M_REF
left join TRN_PFLD_DBF dst on trn.M_DST_PFOLIO = dst.M_REF
left join TRN_CPDF_DBF ctp on trn.M_COUNTRPART = ctp.M_ID

where 1 = 1
and trn.M_TRN_FMLY = 'COM'
and trn.M_MOP_LAST not in (6,7)
and ext.M_OBS in ('BOM','DLY','TMA','LNG','BAS','NDX','SWG')

order by CNT
