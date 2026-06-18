select 
trn.M_NB, trn.M_PURPOSE, trn.M_MOP_LAST, trn.M_TRN_GRP GRP,
rtrim(ben.M_DSP_LABEL) BLEN, rtrim(trn.M_BPFOLIO) BPFL, rtrim(buf.M_RMDLAB) BRMD, rtrim(trn.M_BSTRATEGY) BSTG,
rtrim(sen.M_DSP_LABEL) SLEN, rtrim(trn.M_SPFOLIO) SPFL, rtrim(suf.M_RMDLAB) SRMD, rtrim(trn.M_SSTRATEGY) SSTG

from TRN_HDR_DBF trn
left join TRN_CPDF_DBF ben on rtrim(trn.M_BLENTITY) =  rtrim(ben.M_LABEL)
left join TABLE#DATA#PORTFOLI_DBF buf on rtrim(trn.M_BPFOLIO) = rtrim(buf.M_LABEL)
left join TRN_CPDF_DBF sen on rtrim(trn.M_SLENTITY) =  rtrim(sen.M_LABEL)
left join TABLE#DATA#PORTFOLI_DBF suf on rtrim(trn.M_SPFOLIO) = rtrim(suf.M_LABEL)

where 1 = 1
and rtrim(trn.M_PURPOSE) = 'MfBJy44236'
and trn.M_BINTERNAL = 'Y'
and rtrim(trn.M_BSTRATEGY) is null
and substr(trn.M_BPFOLIO,1,5) <> 'SBOOK'

union

select 
trn.M_NB, trn.M_PURPOSE, trn.M_MOP_LAST, trn.M_TRN_GRP GRP,
rtrim(ben.M_DSP_LABEL) BLEN, rtrim(trn.M_BPFOLIO) BPFL, rtrim(buf.M_RMDLAB) BRMD, rtrim(trn.M_BSTRATEGY) BSTG,
rtrim(sen.M_DSP_LABEL) SLEN, rtrim(trn.M_SPFOLIO) SPFL, rtrim(suf.M_RMDLAB) SRMD, rtrim(trn.M_SSTRATEGY) SSTG

from TRN_HDR_DBF trn
left join TRN_CPDF_DBF ben on rtrim(trn.M_BLENTITY) =  rtrim(ben.M_LABEL)
left join TABLE#DATA#PORTFOLI_DBF buf on rtrim(trn.M_BPFOLIO) = rtrim(buf.M_LABEL)
left join TRN_CPDF_DBF sen on rtrim(trn.M_SLENTITY) =  rtrim(sen.M_LABEL)
left join TABLE#DATA#PORTFOLI_DBF suf on rtrim(trn.M_SPFOLIO) = rtrim(suf.M_LABEL)

where 1 = 1
and rtrim(trn.M_PURPOSE) = 'MfBJy44236'
and trn.M_SINTERNAL = 'Y'
and rtrim(trn.M_SSTRATEGY) is null
and substr(trn.M_SPFOLIO,1,5) <> 'SBOOK'


