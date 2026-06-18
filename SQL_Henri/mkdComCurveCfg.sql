select distinct
crv.M_REFERENCE CRVREF,
to_char(crv.M__DATE_,'YYYY-MM-DD') CRVDAT,
-- to_char(grpi.M__DATE_,'YYYY-MM-DD') DATGRP,
mds.M_LABEL MDS, 
case grpi.M_GTYPE
when  256 then 'Swap PRC'
when  512 then 'Curve'
when 1024 then 'Future VOL'
when 2048 then 'Index VOL' 
when 4096 then 'Volume bucket'
when 8192 then 'Future VOL' else null end OBJ,
--to_number(substr(crv.M_KEY,1,10)) TST,
ass.M_LABEL ASSET, 
concat(rtrim(crvicm.M_LABEL),substr(crv.M_KEY,21,5)) CURVE,
case grpi.M_GEN_MODE
   when 0 then 
      case grpi.M_FUTURE
         when 0 then -- 'Custom'  
            case ins.M_INSTR_TYPE
            when  3 then 'IR Loan'
            when 13 then 'Index' 
            when 21 then 'Repo'
            else null end
         else 'Future' end
   when 1 then 'Future' 
   when 2 then -- 'COM_INDEX'
      case grpi.M_VAL_TYPE
      when 0 then 'Lease Metal Rate'
      when 2 then 'Lease Cash Rate'
      when 4 then 'Forward Price'
      when 5 then 'Forward Rate' 
      else null end                                                                        
end TYP,
case grpi.M_GEN_MODE
when 0 then 'Custom'
when 1 then 'Simple' end C_MODE,
case grpi.M_GEN_MODE
when 0 then
   case when ins.M_INSTR_TYPE = 13 then rtrim(ins.M_INSTR) else rtrim(fut.M_LABEL) end
when 1 then rtrim(ind.M_IND_LAB) 
when 2 then rtrim(cmi.M_LABEL) else null end INSTRUMENT,
rtrim(pilset.M_LABEL) PILSET, 
case pdf.M_PIL_MODE 
when 1 then 'Delivery period'
when 2 then 'Quotation end' end PIL_PRCGRV, 
case crv.M_ALGORITHM
when 50 then 'Prior absolute minim.' 
when 51 then 'MX Enhanced' 
when 52 then 'Interpolated' 
when 53 then 'Smooth curve'
when 54 then 'Stepwise'
when 55 then 'Prior relative minim.' 
when 56 then 'MX Base Correl' 
when 57 then 'Interpolated Yield' 
when 59 then 'Prior vertical transl.' else 'Undefined' end CRV_ALGO,
case crv.M_INTERPOL
when 50 then 'Linear' 
when 56 then 'Backward scale' 
when 57 then 'Forward scale' 
when 65 then 'LME' 
when 68 then 'Log linear' else ' ' end INTERPOL,
case crv.M_REF_PIL_M
when 0 then 'First'
when 1 then 'Given'
when 2 then 'Relative' else null end REFPILM,
case crv.M_REF_PIL_M
when 1 then rtrim(refpil.M_LABEL)
when 2 then rtrim(pilali.M_LABEL) else null end REFPIL,
/*
case crv.M_QP_INTERP
when -1 then 'Off'
when  0 then 'Linear'
when  1 then 'LME' else null end QPRC_ITP,
*/
rtrim(crv.M_INTERP_CAL) ITP_CAL,
case when crv.M_HEDGEC = 1 then 'Yes' else 'No' end HEDGE,
--case when crv.M_AUTPSI = 1 then 'Yes' else 'No' end PSI_ROLL,
case when crv.M_YLDGEC = 1 then 'Yes' else 'No' end YLDFLG,
case when crv.M_YLDGEC = 1 then
case M_INTRPL_VAL
when 0 then 'Lease metal rate'
when 1 then 'Lease metal disc.fct'
when 2 then 'Lease cash rate'
when 3 then 'Lease cash disc.fct'
when 4 then 'Forward price'
when 5 then 'Forward rate'
when 6 then 'Forward disc.fct' else null end end YLDVAL,
rtrim(crv.M_RATCONV) YLDCNV,
rtrim(rtc.M_DLABEL) YLDCRV,
case crv.M_IGN_FIX
when 0 then 'No'
when 1 then 'Today'
when 2 then 'All'
when 3 then 'No-Apply last known' else null end IGNFIX,
rtrim(crv.M_STORAGE_COSTS_GROUP) STOR_GRP, rtrim(crv.M_STORAGE_COSTS_SHIFTER) STOR_SHIFT,
rtrim(crv.M_KEY) CRVKEY

from CMK_SCCF_DBF crv
left join TRN_PC_DBF bo on 1 = 1
left join TRN_DSKD_DBF fo on 1 = 1
left join TRN_MDS_DBF mds on crv.M__ALIAS_= mds.M_ALIAS
left join CM_INDEX_DBF crvicm on to_number(substr(crv.M_KEY,1,10)) = crvicm.M_REFERENCE
left join CM_ASSET_DBF ass on crvicm.M_ASSET = ass.M_REFERENCE
left join CMG_GRPI_DBF grpi on (crv.M__ALIAS_ = grpi.M__ALIAS_ and crv.M__DATE_ = grpi.M__DATE_ and crv.M_OBJ_PIL = grpi.M_GROUP and grpi.M_GTYPE = 512)
left join CMC_MGEN_DBF mgen on grpi.M_INSTR_GEN = mgen.M_REFERENCE and grpi.M_GEN_MODE = 1
left join RT_INDEX_DBF ind on mgen.M_INDEX = ind.M_INDEX
left join CM_INDEX_DBF cmi on grpi.M_INSTR_GEN = cmi.M_REFERENCE and grpi.M_GEN_MODE = 2
left join RT_INSGN_DBF ins on grpi.M_INSTR_GEN = ins.M_GEN_NUM
left join CM_FUT_DBF fut on grpi.M_FUTURE = fut.M_REFERENCE
left join RT_INSGN_DBF futgen on fut.M_CM_INSTR = futgen.M_GEN_NUM
--left join RT_INSGN_DBF ins on grpi.M_INSTR_GEN = ins.M_GEN_NUM and ins.M_TEMPL_NUM = -1
left join CM_PLST_DBF pilset on grpi.M_PILSET = pilset.M_REFERENCE
right join CMG_CNFL_DBF pdf on pilset.M_REFERENCE = pdf.M_LIST
left join CMK_SCQP_DBF prq on (crv.M__ALIAS_=prq.M__ALIAS_ and crv.M__DATE_=prq.M__DATE_ and crv.M_REFERENCE=prq.M_REFERENCE)
left join CM_PROFH_DBF prh on prq.M_PROFILE=prh.M_REFERENCE
left join RT_CT_DBF rtc on crv.M_RATCRV = rtc.M_LABEL and rtc.M_EVALUATION in (0, 2)
left join CM_FMAT1_DBF refpil on crv.M_REF_PIL = refpil.M_REFERENCE
left join CM_FMAT_RA_DBF pilali on crv.M_REF_ALIAS = pilali.M_REFERENCE

where 1 = 1
and grpi.M_GTYPE = 512 
and crv.M__DATE_ = bo.M_DATE
-- and to_char(crv.M__DATE_,'YYYY-MM-DD') = '2022-05-04' 
and crv.M__ALIAS_ = 'RT'
--and rtrim(crvicm.M_COMMENT0) is null
and crvicm.M_REFERENCE > 0

order by MDS, CRVDAT, CURVE, INSTRUMENT