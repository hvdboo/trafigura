select 
rtrim(pfl.M_LABEL)    SRCLAB, 
rtrim(pfl.M_COMMENT1) TGTLAB,
rtrim(udf.M_STREAM_C) STR,
rtrim(udf.M_MASTRDSK_C) MDK,

/*
substr(pfl.M_LABEL,1,2) SRCLAB12,
rtrim(udf.M_STREAM_C) STR,
case when substr(pfl.M_LABEL,1,2) = rtrim(udf.M_STREAM_C) then 0 else 1 end CHKSTR,
substr(pfl.M_LABEL,3,2) LAB32,
substr(pfl.M_LABEL,6,2) LAB62,
rtrim(pfl.M_DSP_LABEL) DISPLAY, 
rtrim(pfl.M_DESC) DESCRIPTION,
case 
when pfl.M_TYPE = 0 then 'Simple' 
when pfl.M_TYPE = 1 then 'Combined'  end as TYPE,
case 
when pfl.M_SUBTYPE = 0 then 'Standard' 
when pfl.M_SUBTYPE = 1 then 'Draft'
when pfl.M_SUBTYPE = 2 then 'Hub'   end as SUBTYPE,
-- pfl.M_ACCCUR ACC_CUR, 
rtrim(trd.M_LABEL) TRD_SCT,
*/
rtrim(pfl.M_ENTITY) CE,
rtrim(cou.M_COUNTRY) COU,
rtrim(cto.M_DSP_LABEL) PC,
rtrim(cto.M_NAME) COMPANY,
-- pfl.M_PROC_AREA,
rtrim(pfl.M_COMMENT0) COMMENT0,
rtrim(pfl.M_COMMENT1) COMMENT1,
rtrim(pfl.M_COMMENT2) COMMENT2,
rtrim(udf.M_DIVISION) DIVISION,
--rtrim(udf.M_STREAM_C) STR, 
rtrim(udf.M_STREAM)   STREAM,
-- rtrim(udf.M_STREAM_D) STREAMD,
--rtrim(udf.M_MASTRDSK_C) MDK,
rtrim(udf.M_MASTRDSK)   MASDSK,
-- rtrim(udf.M_MASTRDSK_D) MASTERD,
rtrim(udf.M_OWNER_C) OWNC, 
rtrim(udf.M_OWNER) OWNER, 
-- rtrim(udf.M_OWNER_DD) OWNER_DD,
rtrim(udf.M_PTFCAT) CAT,
rtrim(udf.M_PTFTYPE) CATEGORY, 
rtrim(udf.M_MKTTYPE_C) MKT, 
rtrim(udf.M_MKTTYPE) MARKET, 
rtrim(udf.M_STRATEGY_C) STG,
rtrim(udf.M_STRATEGY) STRATEGY,
rtrim(lut.M_BUS_LINE) BSL,
rtrim(udf.M_TITAN_ELIG) TITELG,
rtrim(udf.M_TITAN_BL) TITBSL,
--rtrim(pfl.M_ACCSECTION) ACCCOD, 
--rtrim(acc.M_DESC) ACCLAB,
rtrim(udf.M_RMDCOD) RMDCOD, 
rtrim(udf.M_RMDLAB) RMDLAB,
rtrim(udf.M_RMDFLG) RMDFLG,
rtrim(udf.M_RMDPHY) RMDPHY,
rtrim(udf.M_SDNPFL) SDNPFL,
rtrim(alt.M_OBJ_ALT) ALT_SRD,
/*
upper(udf.M_MASTRDSK) ANA_MAS,
case
when rtrim(udf.M_RMDPHY) = upper(udf.M_MASTRDSK) then 1 else 0 end TEST,
*/
-- rtrim(udf.M_REP_LBL) REPLAB, 
-- rtrim(udf.M_REP_DSK) REPDSK,
pfl.M_REF ID

from TRN_PFLD_DBF pfl
left join TRD_SEC_DBF trd on pfl.M_TRDSECTION = trd.M_ID
left join TRN_ACSC_DBF acc on rtrim(pfl.M_ACCSECTION) = rtrim(acc.M_LABEL)
left join TRN_CPDF_DBF cto on pfl.M_PROC_AREA = cto.M_ID
left join CR_CTRY_DBF  cou on cto.M_COUNTRY = cou.M_REFERENCE
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
and pfl.M_COMMENT0 not in ('Do not use')
-- and rtrim(pfl.M_LABEL) like ('XT%')
-- and pfl.M_ACCSECTION <> udf.M_RMDCOD

order by STR, MDK, TGTLAB