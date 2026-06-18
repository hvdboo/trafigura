select 
to_char(trn.M_SYS_DATE,'YYYY-MM-DD') SYSDAT,
to_char(trn.M_TRN_DATE,'YYYY-MM-DD') TRNDAT,
rtrim(trn.M_TRN_STATUS) STAT,
trn.M_NB TRN,
trn.M_CONTRACT CNT,
rtrim(trn.M_GID) GID,
trn.M_BTRADER TRD,
case when trn.M_COMMENT_BS = 'B' then rtrim(trn.M_BPFOLIO) else rtrim(trn.M_SPFOLIO) end PFL, 
case when trn.M_COMMENT_BS = 'B' then rtrim(trn.M_SPFOLIO) else rtrim(trn.M_BPFOLIO) end CTP,
case when trn.M_TRN_GTYPE in (1, 2, 130, 131, 134, 136, 146, 154) then
case trn.M_BRW_PR1
when 'R' then 'B'
when 'P' then 'S' else null end
else rtrim(trn.M_COMMENT_BS) end DIR,
trn.M_BRW_CP RGT,
-- case when trn.M_BRW_CP = 'C' then 'Call' when trn.M_BRW_CP = 'P' then 'Put' else null end RGT,
rtrim(dlv.M_PHYSICAL) PHY,
rtrim(typo.M_LABEL) TYPO,
rtrim(plin.M_DSP_LABEL) PLIN,
-- gen.M_GEN_NUM GEN,
rtrim(und.M_IND_LAB) UND,
(trn.M_BRW_NOM1/cmi.M_LOTSIZE) LOTS,
trn.M_BRW_NOM1 QTY,
rtrim(uni.M_LABEL) UOM,
trn.M_BRW_RTE1 PRMRTE,
(trn.M_BRW_RTE1*trn.M_BRW_NOM1) PRMAMT,
to_char(trn.M_OPT_FLWFST,'YYYY-MM-DD') PRMDAT,
-- Flex
rtrim(flxhdr.M_BK_TYPE) FLEX,
to_char(flxtmp.M_XEXPIRY,'YYYY-MM-DD') EXP,
to_char(flxtmp.M_XPRMPT,'YYYY-MM-DD') PROMPT,
trim(flxtmp.M_XPSHIFT) PRCSHF,
trim(flxtmp.M_XVSHIFT) VOLSHF,
rtrim(flxtmp.M_XMULTIP) SCALE,
case when flxtmp.M_XISOPT='True' then 'Option' else 'Obligation' end ISOPT,
to_char(flxtmp.M_XCLCFST,'YYYY-MM-DD') CLCFST,
to_char(flxtmp.M_XCLCLST,'YYYY-MM-DD') CLCLST,
flxtmp.M_XCLCSCH CLCSCH,
--(select ROW_NUMBER () over (partition by flxsch.M_LINK order by flxsch.M_LINK)) PERSEQ,
to_char(flxsch.M_XPSTART,'YYYY-MM-DD') PRCFST,
to_char(flxsch.M_XPEND,'YYYY-MM-DD') PRCLST,
rtrim(flxsch.M_XWINPRC) WINPRC,
trim(flxsch.M_XISOPTM) OPTIM

from RTBLOCK#RTBK1_DBF flxsch
left join RTBLOCK#RTBK0_DBF flxtmp on flxsch.M_LINK = flxtmp.M_LINK
left join RTBLOCK#RTBKSKL_DBF flxhdr on flxtmp.M_INT_NB = flxhdr.M_BK_INT_N
left join TRN_HDR_DBF trn on flxhdr.M_INT_NB = trn.M_NB
left join CONTRACT_DBF cnt on trn.M_CONTRACT = cnt.M_REFERENCE
left join TYPOLOGY_DBF typo on cnt.M_TYPOLOGY = typo.M_REFERENCE
left join CMT_DLVEXT_DBF dlv on trn.M_NB = dlv.M_NB
left join TRN_PLIN_DBF plin on rtrim(trn.M_INSTRUMENT) = rtrim(plin.M_REFERENCE)
left join CMT_PLKEY1_DBF plk on trim(trn.M_PL_KEY1) = to_char(plk.M_REFERENCE)
left join RT_INDEX_DBF ind on rtrim(plk.M_INDEX) = rtrim(ind.M_INDEX)
left join RT_INDEX_DBF und on rtrim(plk.M_RT_UNDL) = rtrim(und.M_INDEX)
left join CM_INDEX_DBF cmi on plk.M_UNDL = cmi.M_REFERENCE 
left join CM_FUT_DBF cmf on plk.M_UNDL = cmf.M_REFERENCE 
left join RT_LOAN_DBF loan on trn.M_NB = loan.M_NB
left join RT_LNGN_DBF gen on loan.M_GEN_NUM = gen.M_GEN_NUM
left join CM_UNIT_DBF uni on trn.M_BRW_NOMU1 = uni.M_REFERENCE

where 1 = 1  
and trn.M_TYPOLOGY = 1402

order by TRN, PRCFST
