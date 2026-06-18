
select 'update TRN_PFLD_DBF set M_COMMENT1= "'||TGTPFL||'" where M_REF = '||M_REF||';' from 
(

select
rtrim(pfl.M_LABEL) SRCLAB,
-- Stream
case
when rtrim(udf.M_STRATEGY_C) = 'MT' then 'OT'
when rtrim(udf.M_STRATEGY_C) = 'SB' then 'MX'
when rtrim(udf.M_STREAM_C) = 'OC' and rtrim(udf.M_MASTRDSK_C) in ('CR','FU') then 'OT'
when rtrim(udf.M_STREAM_C) in ('CH') then 'OT'
when rtrim(udf.M_STREAM_C) in ('OC','OT') and rtrim(udf.M_MASTRDSK_C) in ('CB','LN','NG','PW') then 'GP'
when rtrim(udf.M_STREAM_C) in ('NG','PW') then 'GP'
else rtrim(udf.M_STREAM_C) end ||
-- Purpose
case 
when rtrim(udf.M_STRATEGY_C) in ('MT') then 'UA'
when rtrim(udf.M_STRATEGY_C) in ('IR','SB','SD') then rtrim(udf.M_STRATEGY_C)
when rtrim(udf.M_STRATEGY_C) in ('PR','PT') then rtrim(udf.M_STRATEGY_C) --'PH'
when rtrim(udf.M_STRATEGY_C) in ('AR','DF','EX','OP','OT','RV','TS') then rtrim(udf.M_STRATEGY_C) --'CE'
when rtrim(udf.M_STRATEGY_C) in ('EQ','IN','SA') then 'CP'
when rtrim(udf.M_STRATEGY_C) in ('FX') then 'FX'
when rtrim(udf.M_STRATEGY_C) in ('RA') then 'RA' 
else '__' end ||' '||
-- Master desk
case 
when rtrim(udf.M_STRATEGY_C) = 'IR' then rtrim(cto.M_DSP_LABEL)
when rtrim(udf.M_STRATEGY_C) = 'MT' then 'OO'
when rtrim(udf.M_STRATEGY_C) = 'SB' then rtrim(pfl.M_ENTITY)
when rtrim(udf.M_STRATEGY_C) = 'SD' then 
   case 
   when (rtrim(pfl.M_ENTITY) = 'AP' or substr(pfl.M_LABEL,6,2) = 'SY') then 'CNY'
   when (rtrim(pfl.M_ENTITY) = 'EM' or substr(pfl.M_LABEL,6,2) = 'EM') then 'EUR' 
   else '___' end 
else rtrim(udf.M_MASTRDSK_C) end||
-- Category
case 
when rtrim(udf.M_STRATEGY_C) = 'IR' then null
when rtrim(udf.M_STRATEGY_C) = 'SB' then null
when rtrim(udf.M_STRATEGY_C) = 'SD' then null
else 
   case 
   when rtrim(udf.M_PTFCAT) = 'F' then 'F'
   when rtrim(udf.M_PTFCAT) = 'H' then 'H'
   when rtrim(udf.M_PTFCAT) = 'P' then 'P'
   when rtrim(udf.M_PTFCAT) = 'S' then 'S' 
   else '_' end 
end ||' '||
-- Entity
case
when rtrim(udf.M_STRATEGY_C) in ('IR','SB') then null
when rtrim(cto.M_DSP_LABEL) in ('TTS') then 'TIC'
when rtrim(cto.M_DSP_LABEL) in ('CIT') then 'T2C'
else rtrim(cto.M_DSP_LABEL) end 
--||' '||rtrim(pfl.M_ENTITY)
TGTPFL,
pfl.M_REF,
-- Strategy
case 
when rtrim(udf.M_STRATEGY) = 'FX' then 'Forex'
when rtrim(udf.M_STRATEGY) = 'Intercompany Routing' then 'Routing'
when rtrim(udf.M_STRATEGY) = 'Investments' then 'Investment'
when rtrim(udf.M_STRATEGY) = 'Market Execution' then 'Market Exec.'
when rtrim(udf.M_STRATEGY) = 'Options' then 'Option'
when rtrim(udf.M_STRATEGY) = 'Outrights' then 'Outright'
when rtrim(udf.M_STRATEGY) = 'Physical Risk Management' then 'Phys.Risk Mng.'
when rtrim(udf.M_STRATEGY) = 'Physical Transfer' then 'Phys.Transfer'
when rtrim(udf.M_STRATEGY) = 'Time Spreads' then 'Time Spread'
else rtrim(udf.M_STRATEGY) end TGTSTG,
-- Usage
case 
when rtrim(udf.M_OWNER_C) in('AL-','AP-','XX-') then null
when rtrim(udf.M_OWNER_C) in('CMA','FOP','RMO') then null
when rtrim(udf.M_OWNER_C) in('GRY','LYK','NYR') then null
else rtrim(udf.M_OWNER_C) end TGTUSG,
-- Analysis
rtrim(udf.M_STREAM_C)   STR,
rtrim(udf.M_STREAM)     STREAM,
rtrim(udf.M_MASTRDSK_C) MDK,
rtrim(udf.M_MASTRDSK)   MASDSK,
rtrim(udf.M_PTFCAT)     CAT,
rtrim(udf.M_PTFTYPE)    CATEGORY,
rtrim(udf.M_STRATEGY_C) SRCSTG,
rtrim(pfl.M_ENTITY)     SRCCE,
rtrim(cou.M_COUNTRY)    SRCCOU,
rtrim(cto.M_DSP_LABEL)  SRCLE,
rtrim(udf.M_MKTTYPE)    MARKET,
rtrim(udf.M_OWNER_C)    OWNR,
rtrim(udf.M_OWNER)      OWNER,
rtrim(pfl.M_COMMENT0)   CMT0,
rtrim(pfl.M_COMMENT1)   CMT1,
rtrim(pfl.M_COMMENT2)   CMT2,
rtrim(pfl.M_DESC)       SRCDES,
pfl.M_REF SRCUID
 
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
/*
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
*/
order by SRCLAB
)
