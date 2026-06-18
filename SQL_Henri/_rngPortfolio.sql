
select
rtrim(pfl.M_LABEL) SRCLAB,
case 
when rtrim(udf.M_STRATEGY_C) = 'SB' then 'MX'
else rtrim(udf.M_STREAM_C) end || 
case 
when rtrim(udf.M_STRATEGY_C) = 'SB' then rtrim(pfl.M_ENTITY)
when rtrim(udf.M_STRATEGY_C) = 'IR' then 'IR' 
when rtrim(udf.M_MASTRDSK_C) = 'SY' then 'SD' 
else rtrim(udf.M_MASTRDSK_C) end||' '||
case 
when rtrim(udf.M_STRATEGY_C) = 'SB' then 'TEC'
when rtrim(udf.M_STRATEGY_C) = 'IR' then 'TEC'
when rtrim(udf.M_MASTRDSK_C) = 'SY' then 'CNY'
else case rtrim(udf.M_PTFCAT)
when 'F' then 'FLW'
when 'H' then 'HDG'
when 'P' then 'PHD'
when 'S' then 'SPE' end end ||' '||
rtrim(cto.M_DSP_LABEL) TGTPFL,
rtrim(udf.M_STRATEGY)  TGTSTG,
rtrim(udf.M_STREAM)    STREAM,
rtrim(udf.M_MASTRDSK)  MASTER,
rtrim(udf.M_PTFTYPE)   CATEGORY,
rtrim(cto.M_DSP_LABEL) SRCLE,
rtrim(udf.M_MKTTYPE)   MARKET,
rtrim(udf.M_OWNER)     OWNER,
rtrim(pfl.M_DESC)      SRCDES,
pfl.M_REF SRCUID
 
from TRN_PFLD_DBF pfl
left join TRD_SEC_DBF trd on pfl.M_TRDSECTION = trd.M_ID
left join TRN_ACSC_DBF acc on rtrim(pfl.M_ACCSECTION) = rtrim(acc.M_LABEL)
left join TRN_CPDF_DBF cto on pfl.M_PROC_AREA = cto.M_ID
left join TRN_CPDF_DBF cts on pfl.M_SERVICER  = cts.M_ID
left join TRN_CPDF_DBF ctc on rtrim(pfl.M_LABEL) = rtrim(ctc.M_COMMENT0)
left join TABLE#DATA#PORTFOLI_DBF udf on rtrim(pfl.M_LABEL) = rtrim(udf.M_LABEL)
left join KEYMAP_STC_DBF alt on (rtrim(pfl.M_LABEL) = rtrim(alt.M_OBJ_DESC) and alt.M_OBJ_CLASS = 'MJkQC54506' and rtrim(alt.M_OBJ_ASYS) = 'SRD')
left join UDTB251_DBF lut on (
rtrim(udf.M_STREAM) = rtrim(lut.M_STREAM) and
rtrim(udf.M_PTFTYPE) = rtrim(lut.M_PTFTYPE) and
rtrim(lut.M_DIVISION) is null and
rtrim(lut.M_MASTRDSK) is null
)
 
where 1 = 1
and pfl.M_TYPE = 0
and pfl.M_REF not in (2,3,5,6,7,1723)
and substr(pfl.M_LABEL,1,4) not in ('ORDE','WASH')
and pfl.M_REF in
(
select
case when trn.M_COMMENT_BS = 'B' then bpfl.M_REF else spfl.M_REF end PFLUID
 
from TRN_HDR_DBF trn
left join TRN_PC_DBF pc on 1 = 1
left join TRN_PFLD_DBF bpfl on rtrim(trn.M_BPFOLIO) = rtrim(bpfl.M_LABEL)
left join TRN_PFLD_DBF spfl on rtrim(trn.M_SPFOLIO) = rtrim(spfl.M_LABEL)
 
where
trn.M_PURPOSE <> 'MeHzv70053'
and trn.M_MOP_LAST not in (6,7)
 
group by
case when trn.M_COMMENT_BS = 'B' then bpfl.M_REF else spfl.M_REF end
)
order by SRCLAB

