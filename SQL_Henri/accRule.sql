select 
/*Rule*/
acr1.M_RULE_NB RUL_NB,
rtrim(acr1.M_RULE_LB) RUL_LAB, 
-- acr1.M_RUL_VAL RUL_VAL,
case acr1.M_TRN_CLASS
when 0 then 'Trade'
when 2 then 'Cash flow'
when 2 then 'FX Complement'
when 3 then 'Hedge'
when 4 then 'Position' end RUL_CLAS,
case acr1.M_TRN_CLASS
when 0 then rtrim(acr1.M_TRN_FMLY)||'|'||rtrim(acr1.M_TRN_GRP)||'|'||rtrim(acr1.M_TRN_TYPE)
when 1 then null
when 2 then null
when 3 then acr1.M_TRN_FMLY
when 4 then rtrim(acr1.M_TRN_FMLY) end RUL_SCOPE,
/*Filter*/
rtrim(acr1.M_TRN_IE) FLT_IE,
rtrim(acr1.M_TRN_BS) FLT_BS,
rtrim(acr1.M_TRN_ENT) FLT_ENT, 
rtrim(acr1.M_TRN_SEC) FLT_ACCSEC,
rtrim(acr1.M_TRN_STTCAT) FLT_STTCAT,
coalesce(rtrim(flts.M_LABEL),rtrim(fltt.M_LABEL),'None') FLT,
/*Event*/
case acr1.M_EVENT0
when 'AR'         then 'Accrual(Realized-Dead)'
when 'BS'         then 'Balance Sheet'
when 'CLASS'      then 'Reclassification'
when 'EARN'       then 'Earning Variation'
when 'EF'         then 'Event flow'
when 'INITNPV'    then 'Initial NPV'
when 'LIQUID'     then 'Liquidation'
when 'LPOS_RPL'   then 'Realized PL'
when 'LPOS_UPL'   then 'Unrealized PL'
when 'NPV_VAR'    then 'NPV Variation'
when 'OCI'        then 'OCI Variation'
when 'OS'         then 'Off Balance Sheet'
when 'PE'         then 'Payment event'
when 'REVTERM'    then 'Revaluation Termination'
when 'RL'         then 'Result(Realized-Live)'
when 'RP'         then 'AVP Results'
when 'RZ'         then 'Result(Realized-Dead)'
when 'UDF_EVT'    then 'Uder definable Event'
when 'UP'         then 'Result(Unrealized AVP)'
when 'USER_DAILY' then 'User Daily'
when 'USER_PL'    then 'User PL'
when 'UZ'         then 'Result(Unrealized)'
else acr1.M_EVENT0 end EVT_TYP,
case acr1.M_EVENT1
when 'CM'         then 'Commitment'
when 'CMDV'       then 'No selection'
when 'DV'         then 'Delivery'
when 'EARN'       then 'Earning variation'
when 'EARN_REV'   then 'Earning variation revsersal'
when 'NONE'       then 'No selection'
when 'PRCM'       then 'Pre-commitment'
when 'RV'         then 'Reversal'
when 'USER_DAILY' then 'User daily'
when 'USER_PL_IN' then 'User P&L Initial'
else acr1.M_EVENT1 end EVT_SUBTYP,
case acr1.M_BOOKMODE
when 0 then 'Offset'
when 1 then 'Incremental' else null end EVT_BOOK,
case acr1.M_EVT_PLTYPE
when 'OLD' then 'Default'       
when 'NEW' then 'Custom' else null end EVT_CALCTYP,       
case acr1.M_EVENT_PL
when 'P' then 'Profit'
when 'L' then 'Loss'
when 'PL' then 'No sel.' else null end EVT_PL,
case acr1.M_EVT_PLTYPE
when 'NEW' then '['||rtrim(frm.M_LABEL)||'] '||rtrim(frm.M_DESC)
when 'OLD' then 
case acr1.M_EVENT_RV
when 'MTM_A'     then 'MTM'
when 'MKT_A'     then 'NPV'
when 'MTMPV_A'   then 'MTM (PV)'
when 'MKTPV_A'   then 'NPV (PV)'
when 'PV_EFT'    then 'PV'
when 'PV_MV'     then 'PV(MV)'
when 'PV_FCP'    then 'PV(FCP)'
when 'MV_FCP'    then 'MV+FCP+PV'
when 'MV_FCP_A'  then 'MV+FCP'
when 'FCP'       then 'FCP'
when 'PCP'       then 'PCP'
when 'PCP_FNPV'  then 'PCP_FNPV'
when 'PCP_NFNPV' then 'PCP_NFNPV' else null end end EVT_PLTYP,
case acr1.M_EVENT_RVC
when 'CUR_PL' then 'PnL.Cur' 
when 'CUR_OG' then 'Org.Cur' else null end EVT_CUR,
case acr1.M_EVT_DEAD
when 'I' then 'Incl.'
when 'E' then 'Excl.' else null end EVT_DEAD,
case acr1.M_EVT_CALCM
when 0 then 'Default'
when 1 then 'Closing MV'
when 2 then 'Theo. MV' else null end EVT_CALMOD,
case acr1.M_STO_EVAL
when 0 then 'None'
when 1 then 'Diff to cost' else null end REF_EVAL,
/*Flow*/
case acr1.M_EVENT_PR
when 'P'  then 'Pay'
when 'PR' then 'No selection'
when 'R'  then 'Receive'
else acr1.M_EVENT_PR end EVT_PR,
case acr1.M_EVT_FLWSRC
when 0 then 'Trade flow'
when 1 then 'Event flow' else null end EVT_FLW,
acr1.M_FLW_NAT_CAP CAP, 
case acr1.M_FLW_NAT_CAP when 1 then rtrim(ftcap.M_TYPE0)||'|'||rtrim(ftcap.M_TYPE1)||'|'||rtrim(ftcap.M_TYPE2)||'|'||rtrim(ftcap.M_TYPE3) else null end CAPTYP,
acr1.M_FLW_NAT_INT INTR, 
case acr1.M_FLW_NAT_INT when 1 then rtrim(ftint.M_TYPE0)||'|'||rtrim(ftint.M_TYPE1)||'|'||rtrim(ftint.M_TYPE2)||'|'||rtrim(ftint.M_TYPE3) else null end INTTYP,
M_FLW_NAT_UD UDF, 
case acr1.M_FLW_NAT_UD  when 1 then rtrim(ftudf.M_TYPE0)||'|'||rtrim(ftudf.M_TYPE1)||'|'||rtrim(ftudf.M_TYPE2)||'|'||rtrim(ftudf.M_TYPE3) else null end UDFTYP,
M_FLW_NAT_BRO BRK,
/*Accounts*/
case M_DR_CLS_ACC
when 'MsMlP60056' then 'Simple'
when 'MtBDY60163' then 'Formula'
when 'MwYDF68605' then 'Linked'
when 'MzFzS78952' then 'Dynamic' end ACC_OWN_D_CLAS,
case M_DR_CLS_ACC
when 'MsMlP60056' then rtrim(sod.M_LABEL)
when 'MtBDY60163' then rtrim(fod.M_LABEL)
when 'MwYDF68605' then null
when 'MzFzS78952' then rtrim(sod.M_LABEL) end ACC_OWN_D_ACC,
case M_CR_CLS_ACC
when 'MsMlP60056' then 'Simple'
when 'MtBDY60163' then 'Formula'
when 'MwYDF68605' then 'Linked'
when 'MzFzS78952' then 'Dynamic' end ACC_OWN_C_CLAS,
case M_CR_CLS_ACC
when 'MsMlP60056' then rtrim(soc.M_LABEL)
when 'MtBDY60163' then rtrim(foc.M_LABEL)
when 'MwYDF68605' then null
when 'MzFzS78952' then rtrim(soc.M_LABEL) end ACC_OWN_C_ACC,
case M_DR_CLS_FGN
when 'MsMlP60056' then 'Simple'
when 'MtBDY60163' then 'Formula'
when 'MwYDF68605' then 'Linked'
when 'MzFzS78952' then 'Dynamic' end ACC_FGN_D_CLAS,
case M_DR_CLS_FGN
when 'MsMlP60056' then rtrim(sfd.M_LABEL)
when 'MtBDY60163' then rtrim(ffd.M_LABEL)
when 'MwYDF68605' then null
when 'MzFzS78952' then rtrim(sfd.M_LABEL) end ACC_FGN_D_ACC,
case M_CR_CLS_FGN
when 'MsMlP60056' then 'Simple'
when 'MtBDY60163' then 'Formula'
when 'MwYDF68605' then 'Linked'
when 'MzFzS78952' then 'Dynamic' end ACC_FGN_C_CLAS,
case M_CR_CLS_FGN
when 'MsMlP60056' then rtrim(sfc.M_LABEL)
when 'MtBDY60163' then rtrim(ffc.M_LABEL)
when 'MwYDF68605' then null
when 'MzFzS78952' then rtrim(sfc.M_LABEL) end ACC_FGN_C_ACC
from TRN_ACR1_DBF acr1
left join TRN_ACA1_DBF soc on acr1.M_CR_REF_ACC = soc.M_REFERENCE
left join TRN_ACA1_DBF sod on acr1.M_DR_REF_ACC = sod.M_REFERENCE
left join TRN_ACA1_DBF sfc on acr1.M_CR_REF_FGN = sfc.M_REFERENCE
left join TRN_ACA1_DBF sfd on acr1.M_DR_REF_FGN = sfd.M_REFERENCE
left join TRN_ACAF_DBF foc on acr1.M_CR_REF_ACC = foc.M_REFERENCE
left join TRN_ACAF_DBF fod on acr1.M_DR_REF_ACC = fod.M_REFERENCE
left join TRN_ACAF_DBF ffc on acr1.M_CR_REF_FGN = ffc.M_REFERENCE
left join TRN_ACAF_DBF ffd on acr1.M_DR_REF_FGN = ffd.M_REFERENCE
left join SFVFLTM_DBF flts on acr1.M_SIMPLE_FLT = flts.M_ID
left join ACCCFG#FIL_ACCH_DBF fltt on acr1.M_TREE_FLT = fltt.M_REF
left join TRN_ACPL_DBF frm on rtrim(acr1.M_PL_CLCLBL) = rtrim(frm.M_LABEL)
left join FLOW_TYPO_DBF ftcap on acr1.M_FLW_TYPO_CAP = ftcap.M_REF
left join FLOW_TYPO_DBF ftint on acr1.M_FLW_TYPO_INT = ftint.M_REF
left join FLOW_TYPO_DBF ftudf on acr1.M_FLW_TYPO_UD  = ftudf.M_REF
where 
-- coalesce(to_char(acr1.M_RUL_DVAL),'Y') = 'Y'
acr1.M_RULE_NB in (388, 389, 390, 391, 392, 393)
order by RUL_CLAS, RUL_SCOPE, RUL_LAB, EVT_TYP, EVT_SUBTYP