select
brk.M_REFERENCE BRK_ID,
trn.M_CONTRACT CNT_ID,
cnt.M_ORIG_REF CNT_ORI,
cnt.M_VERSION CNT_VS,
brk.M_NB TRN_IID,
to_char(trn.M_TRN_DATE,'YYYY-MM-DD') TRN_DAT,
brk.M_LINE BRK_LINE,
case brk.M_TYPE
when 0 then 'None'
when 1 then 'BrokerFee'
when 2 then 'BrokerTax' 
when 3 then 'ClearerFee'
when 4 then 'ClearerTax'
when 5 then 'InternalFee'
when 6 then 'ClientFee'
when 7 then 'CVAFee'
else null end BRK_TYP,
rtrim(pfs.M_LABEL) PFL_SRC,
rtrim(pfd.M_LABEL) PFL_DST,
rtrim(ctp.M_DSP_LABEL) CTP,
rtrim(brk.M_CODE) BRK_CODE,
brk.M_CUR CUR,
brk.M_FEE AMT,
to_char(M_VALUE_DATE,'YYYY-MM-DD') STL,
brk.M_VERSION BRK_VS

from TRN_BROKER_DBF brk
left join TRN_PFLD_DBF pfs on brk.M_SRC_PFOLIO = pfs.M_REF 
left join TRN_PFLD_DBF pfd on brk.M_DST_PFOLIO = pfd.M_REF
left join TRN_CPDF_DBF ctp on brk.M_CNTRP = ctp.M_ID
left join TRN_HDR_DBF trn on brk.M_NB = trn.M_NB
left join CONTRACT_DBF cnt on trn.M_CONTRACT = cnt.M_REFERENCE

where 
-- brk.M_FEE <> 0
-- trn.M_CONTRACT = 3326096
cnt.M_ORIG_REF = 3320280

order by CNT_ORI, CNT_VS, BRK_LINE