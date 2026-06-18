select distinct
viwhdr.M_CFG_LBL VIW,
viwfld.M_ELT_LBL FLD,
pilset.M_LABEL   PILSET

from VWR_STG_DBF  viwstg
join VWR_CFG_DBF  viwfld on viwstg.M_STG_REF = viwfld.M_ELT_STG
join VWR_CFGS_DBF viwhdr on viwfld.M_CFG_REF = viwhdr.M_CFG_REF
join SMVWRSTG_DBF simviwstg on viwstg.M_EXT_REF = simviwstg.M_ID
join CM_PLST_DBF  pilset on simviwstg.M_CMC_PILLAR = pilset.M_REFERENCE

where pilset.M_LABEL = 'P_LME_LIQUID'
