select 
to_char(pc.M_DATE,'YYYYMMDD') SYSDAT,
dlv.M_PRODUCER CNT, dlv.M_TRD_REF TRN, trn.M_GID,
rtrim(class.M_DESC) CLASS, dlv.M_REFERENCE F_REF, 
dlv.M_PROD_VER F_VS, dlv.M_STP_STATUS F_STP,
rtrim(ori.M_DSP_LABEL) ORI, rtrim(bnf.M_DSP_LABEL) BNF,
case dlv.M_S_R when 1 then 'Send' when 2 then 'Receive' else null end DIR,  
dlv.M_CURRENCY CUR, dlv.M_R_QUANTITY AMT,
to_char(dlv.M_VAL_DATE,'YYYY-MM-DD') DT_VAL, to_char(dlv.M_REL_DATE,'YYYY-MM-DD') DT_REL, 
-- to_char(dlv.M_ASS_DATE,'YYYY-MM-DD') DT_ASS,
ftypo.M_TYPE0||'|'||ftypo.M_TYPE1||'|'||ftypo.M_TYPE2||'|'||ftypo.M_TYPE3||'|'||ftypo.M_TYPE4 F_TYPO,
rtrim(le.M_DSP_LABEL) LE, rtrim(pfl.M_LABEL) PFL, 
rtrim(ctypo.M_LABEL) CTYPO, rtrim(plin.M_DSP_LABEL) INS,
dlv.M_LEG LEG, to_char(dlv.M_P_START_DT,'YYYY-MM-DD') PERF, to_char(dlv.M_P_END_DT,'YYYY-MM-DD') PERL
from DLV_CASH_DBF dlv
left join TRN_PC_DBF pc on 1 = 1
left join CLASS_MAPPING_DBF class on dlv.M_PROD_INTID = class.M_ID
left join TRN_CPDF_DBF ori on dlv.M_ORIG_PARTY = ori.M_ID
left join TRN_CPDF_DBF bnf on dlv.M_BENF_PARTY = bnf.M_ID
left join TRN_CPDF_DBF le  on dlv.M_LENT_REF = le.M_ID
left join TRN_PFLD_DBF pfl on dlv.M_PORTFOLIO = pfl.M_REF
left join FLOW_TYPO_DBF ftypo on dlv.M_TYPOLOGY = ftypo.M_REF
left join TYPOLOGY_DBF ctypo on dlv.M_TRD_TYPO = ctypo.M_REFERENCE
left join TRN_PLIN_DBF plin on dlv.M_INSTRUMENT = plin.M_REFERENCE
left join TRN_HDR_DBF trn on dlv.M_TRD_REF = trn.M_NB
where 
to_char(dlv.M_VAL_DATE,'YYYYMMDD') > to_char(pc.M_DATE,'YYYYMMDD')
and to_char(dlv.M_VAL_DATE,'YYYYMMDD') < '20171201'
and trn.M_TRN_GTYPE in (102, 103)
-- and substr(trn.M_GID,1,6) = 'TDLPTE'
-- where dlv.M_PRODUCER = 956327
-- where dlv.M_REFERENCE = 250092
order by BNF, DT_VAL, TRN