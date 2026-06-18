DROP VIEW PFL_VIW;
CREATE VIEW PFL_VIW
(
M_LAB,
M_DSPLAB,
M_DES,
M_TYP,
M_SUBTYP,
M_CE,
M_PC,
M_COMPANY,
M_CLOSED,
M_CMT0,
M_CMT1,
M_DIVC,
M_DIVISION,
M_STR, 
M_STREAM,
M_MAS,
M_MASTER,
M_OWNC, 
M_OWNER, 
M_CAT,
M_CATEGORY, 
M_TYPCOD,
M_TYPLAB,
M_MKT, 
M_MARKET, 
M_BSL,
M_TITELG,
M_TITBSL,
M_ACCCOD, 
M_ACCLAB,
M_RMDCOD, 
M_RMDLAB,
M_RMDFLG,
M_RMDPHY,
M_SDNPFL,
M_SRDUID,
M_ID
) 

AS

(
select 
rtrim(pfl.M_LABEL) LAB, 
rtrim(pfl.M_DSP_LABEL) DSPLAB, 
rtrim(pfl.M_DESC) DES,
case 
when pfl.M_TYPE = 0 then 'Simple' 
when pfl.M_TYPE = 1 then 'Combined'  end TYP,
case 
when pfl.M_SUBTYPE = 0 then 'Standard' 
when pfl.M_SUBTYPE = 1 then 'Draft'
when pfl.M_SUBTYPE = 2 then 'Hub'   end SUBTYP,
-- pfl.M_ACCCUR ACC_CUR, 
-- rtrim(trd.M_LABEL) TRD_SCT,
rtrim(pfl.M_ENTITY)    CE,
rtrim(cto.M_DSP_LABEL) PC,
rtrim(cto.M_NAME)      COMPANY,
-- pfl.M_PROC_AREA PRCENT,
to_char(udf.M_CLOSURE_DT,'YYYY_MM-DD') CLOSED,
rtrim(pfl.M_COMMENT0) CMT0,
rtrim(pfl.M_COMMENT1) CMT1,
rtrim(udf.M_DIVISION_C) DIVC,
rtrim(udf.M_DIVISION) DIVISION,
rtrim(udf.M_STREAM_C) STR, 
rtrim(udf.M_STREAM) STREAM,
-- rtrim(udf.M_STREAM_D) STREAMD,
rtrim(udf.M_MASTRDSK_C) MAS,
rtrim(udf.M_MASTRDSK) MASTER,
-- rtrim(udf.M_MASTRDSK_D) MASTERD,
rtrim(udf.M_OWNER_C) OWNC, 
rtrim(udf.M_OWNER) OWNER, 
-- rtrim(udf.M_OWNER_DD) OWNER_DD,
rtrim(udf.M_PTFCAT)     CAT,
rtrim(udf.M_PTFTYPE)    CATEGORY, 
rtrim(udf.M_STRATEGY_C) TYPCOD,
rtrim(udf.M_STRATEGY)   TYPLAB,
rtrim(udf.M_MKTTYPE_C)  MKT, 
rtrim(udf.M_MKTTYPE)    MARKET, 
rtrim(lut.M_BUS_LINE)   BSL,
rtrim(udf.M_TITAN_ELIG) TITELG,
rtrim(udf.M_TITAN_BL)   TITBSL,
rtrim(pfl.M_ACCSECTION) ACCCOD, 
rtrim(acc.M_DESC)       ACCLAB,
rtrim(udf.M_RMDCOD)     RMDCOD, 
rtrim(udf.M_RMDLAB)     RMDLAB,
rtrim(udf.M_RMDFLG)     RMDFLG,
rtrim(udf.M_RMDPHY)     RMDPHY,
rtrim(udf.M_SDNPFL)     SDNPFL,
rtrim(alt.M_OBJ_ALT)    SRDUID,
pfl.M_REF ID

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
rtrim(lut.M_MASTRDSK) is null)

where 1 = 1
and pfl.M_TYPE = 0
and pfl.M_REF not in (2,3,5,6,7,1723)
and substr(pfl.M_LABEL,1,4) not in ('ORDE','WASH')

);

drop table VIW_PFL_DBF;
create table VIW_PFL_DBF as (select * from PFL_VIW);
