select 
ace.M_NB POST,
ace.M_NB_TRN TRN,
case ace.M_TRN_FGT
when 130 then 'COM|SWAP'
when 131 then 'COM|ASIAN'
when 146 then 'COM|ASIAN|CLR' else null end FGT,
rtrim(acr.M_RULE_LB) RULE,
rtrim(acd.M_LABEL) DEB,
rtrim(acc.M_LABEL) CRD,
rtrim(plin.M_DSP_LABEL) INS,
ace.M_EN_AMT AMT, 
ace.M_NB_REVERSE REVERS,
rtrim(ace.M_EN_COMMENT) CMT

from ACG_ENTRY_DBF ace
left join TRN_ACR1_DBF acr on ace.M_NB_RULE = acr.M_RULE_NB
left join TRN_ACA1_DBF acd on ace.M_EN_DEBIT = acd.M_REFERENCE
left join TRN_ACA1_DBF acc on ace.M_EN_CREDIT = acc.M_REFERENCE
left join TRN_PLIN_DBF plin on ace.M_INSTRUMENT = plin.M_ID

where ace.M_NB_TRN = 13442054
and to_char(ace.M_EN_DATE,'YYYYMMDD') = '20190412'


/* 
(
select M_NB
from TRN_HDR_DBF trn
-- 7295  | ASIAN   | FE 62% TSI SGX_AVM
-- 8896  | SWAP    | FE 62 TSI_AVM
-- 9001  | SWAP    | FE 62 TSI_AVG
-- 10054 | ASN.CLR | FEF 62% SGX
-- 14502 | SWAP    | FE LP SGX USD/DMTU_AVM
-- 15430 | ASIAN   | COAL AUST FOB TSI USD/MT_AVM
-- 15431 | SWAP    | COAL AUST FOB TSI USD/MT_AVM
-- 15433 | ASN.CLR | COAL AU COKE TSI SGX
               
where rtrim(trn.M_INSTRUMENT) in
(
'7295' ,  
'8896' ,  
'9001' ,  
'10054', 
'14502', 
'15430', 
'15431', 
'15433')
and to_char(trn.M_OPT_FLWLST,'YYYYMMDD') > '20180730'
and to_char(trn.M_OPT_FLWLST,'YYYYMMDD') < '20180807'
)
*/

order by ace.M_NB_TRN, ace.M_EN_DATE
