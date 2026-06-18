select 
pfl.M_REF ID,
rtrim(pfl.M_LABEL) LABEL, 
rtrim(pfl.M_DSP_LABEL) DISPLAY, 
rtrim(pfl.M_DESC) DESCRIPTION,
case 
when pfl.M_TYPE = 0 then 'Simple' 
when pfl.M_TYPE = 1 then 'Combined'  end as TYPE,
case 
when pfl.M_SUBTYPE = 0 then 'Standard' 
when pfl.M_SUBTYPE = 1 then 'Draft' 
when pfl.M_SUBTYPE = 2 then 'Hub'   end as SUBTYPE,
-- pfl.M_ACCSECTION ACC_SCT, pfl.M_ACCCUR ACC_CUR, 
-- rtrim(trd.M_LABEL) TRD_SCT,
rtrim(pfl.M_ENTITY) CE,
rtrim(cto.M_DSP_LABEL) PC,
-- rtrim(pfl.M_COMMENT0) COMMENT_,
rtrim(udf.M_DIVISION) DIVISION, 
rtrim(udf.M_STREAM) STREAM, 
rtrim(udf.M_MASTRDSK) MASTER,
rtrim(udf.M_OWNER) OWNER, 
rtrim(udf.M_OWNER_DD) OWNER_DD,
rtrim(udf.M_PTFTYPE) CATEGORY, 
rtrim(udf.M_MKTTYPE) MARKET, 
rtrim(udf.M_STRATEGY) STRATEGY,
rtrim(udf.M_STRATEGY_C) STG,
-- rtrim(udf.M_REP_LBL) REPLAB, rtrim(udf.M_REP_DSK) REPDSK,
rtrim(lut.M_BUS_LINE) BL

from TRN_PFLD_DBF pfl
left join TRD_SEC_DBF trd on pfl.M_TRDSECTION = trd.M_ID 
left join TRN_CPDF_DBF cto on pfl.M_PROC_AREA = cto.M_ID
left join TRN_CPDF_DBF cts on pfl.M_SERVICER  = cts.M_ID
left join TRN_CPDF_DBF ctc on rtrim(pfl.M_LABEL) = rtrim(ctc.M_COMMENT0)
left join TABLE#DATA#PORTFOLI_DBF udf on rtrim(pfl.M_LABEL) = rtrim(udf.M_LABEL)
left join UDTB251_DBF lut on (
rtrim(udf.M_STREAM) = rtrim(lut.M_STREAM) and 
rtrim(udf.M_PTFTYPE) = rtrim(lut.M_PTFTYPE) and
rtrim(lut.M_DIVISION) is null and
rtrim(lut.M_MASTRDSK) is null
) 

where rtrim(cto.M_DSP_LABEL) in ('CHB','NTT', 'TEZ','TNJ', 'TTH', 'TTS', 'TTY')
--and rtrim(udf.M_STRATEGY_C) not in ('OD','SD') 

order by pfl.M_TYPE, pfl.M_LABEL