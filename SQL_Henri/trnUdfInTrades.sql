select 
trn.M_NB TRN, 
rtrim(trn.M_TRN_GRP) GRP, rtrim(trn.M_TRN_TYPE) TYP, 
case 
when trn.M_BINTERNAL = trn.M_SINTERNAL then 'I' else 'E' end IE,
rtrim(trn.M_BPFOLIO) BUYPFL, rtrim(trn.M_SPFOLIO) SELPFL, 
rtrim(pfs.M_LABEL) SRCPFL, rtrim(pfd.M_LABEL) DSTPFL, 
rtrim(ctp.M_DSP_LABEL) CTP,
rtrim(plin.M_DSP_LABEL) INS,
udf.M_PL_ASSIG PL_ASG, 
udf.M_PL_ASSIG2 PL_ASG2,
rtrim(trn.M_COMMENT_BS) BS_CMT,
case when trn.M_COMMENT_BS = 'B' then udf.M_PL_ASSIG  else udf.M_PL_ASSIG2 end BSTG,
case when trn.M_COMMENT_BS = 'B' then udf.M_PL_ASSIG2 else udf.M_PL_ASSIG  end SSTG 

from TABLE#DATA#DEALCURR_DBF udf
left join TRN_EXT_DBF ext on udf.M_NB = ext.M_UDF_REF 
left join TRN_HDR_DBF trn on ext.M_TRADE_REF = trn.M_NB
join CONTRACT_DBF cnt on (trn.M_CONTRACT = cnt.M_REFERENCE and ext.M_VERSION = cnt.M_VERSION)
left join TRN_PFLD_DBF pfs on trn.M_SRC_PFOLIO = pfs.M_REF
left join TRN_PFLD_DBF pfd on trn.M_DST_PFOLIO = pfd.M_REF
left join TRN_CPDF_DBF ctp on trn.M_COUNTRPART = ctp.M_ID
left join TRN_PLIN_DBF plin on rtrim(trn.M_INSTRUMENT) = rtrim(plin.M_REFERENCE)

where 
trim(udf.M_PL_ASSIG) is not null
-- or trim(udf.M_PL_ASSIG2) is not null
-- and trim(udf.M_PL_ASSIG) <> trim(udf.M_PL_ASSIG2)

order by TRN

