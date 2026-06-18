select
-- viw.M_CFG_REF VIW_REF,
rtrim(viw.M_CFG_LBL) VIW_LAB,
-- elt.M_ELT_REF ELT_REF,
case elt.M_ELT_SEL
when 1 then 'Outputs'
when 2 then 'Lin.Bkd'
when 3 then 'Col.Bkd' else null end ELT_TYP,
rtrim(elt.M_ELT_LBL) ELT_LAB,
-- elt.M_ELT_LEV,
elt.M_ELT_INST,
-- rtrim(elt.M_DB_LBL) ELT_DB,
-- dic.M_OBJ_REF DIC_REF,
rtrim(dic.M_OBJ_DESC) DIC_DES,
rtrim(dic.M_DES_PATH) DIC_PATH,
case trim(stg.M_IMPLEMENT)
when 'object * Simulation *  * 0_0.66_66.5_5.15_3.16_16' then std.M_DSP_CCY
else null end STD,
-- src.M_OPT_REF SRC_REF,
rtrim(src.M_TABLE) SRC_TBL,
rtrim(src.M_S_FIEL_N) SRC_FLD,
rtrim(src.M_D_SHIFT) SRC_SHF,
rtrim(src.M_TAG) SRC_TAG,
case src.M_D_MODE
when 0 then 'Absolute'
when 1 then 'Variation'
when 2 then 'Performance'
when 3 then 'Cummulate with current' else null end SRC_DPM,
dic.M_OBJ_REF 

from VWR_CFG_DBF elt
left join VWR_CFGS_DBF viw on elt.M_CFG_REF = viw.M_CFG_REF
left join VWR_DCT_DBF dic on (elt.M_OBJ_UID = dic.M_OBJ_REF and dic.M_OBJ_ORD=0)
left join VWR_STG_DBF stg on elt.M_ELT_STG = stg.M_STG_REF
left join SMVWRSTG_DBF std on stg.M_EXT_REF = std.M_ID
left join SRC_DESC_DBF src on stg.M_SRC_REF = src.M_REF


--where rtrim(viw.M_CFG_LBL) = 'RM_COM P3UD H3OD-2'
-- where viw.M_CFG_REF = 3557

order by 
rtrim(viw.M_CFG_LBL), 
elt.M_ELT_SEL, elt.M_ELT_LEV, elt.M_ELT_INST,
dic.M_OBJ_ORD