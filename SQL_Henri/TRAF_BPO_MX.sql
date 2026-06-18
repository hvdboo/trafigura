select 
cnt.M_REFERENCE CNT,
cnt.M_VERSION CVS,
cnt.M_PACK_REF PCK,
trn.M_NB TRN,
rtrim(trn.M_GID) GID,
rtrim(typo.M_LABEL) TYPO,
rtrim(plin.M_DSP_LABEL) INS,
trn.M_TRN_STATUS STAT,
trn.M_COMMENT_BS DIR,
trn.M_BRW_CP RGT,
rtrim(bk0.M_XISOPT) ISOPT,
to_char(bk0.M_XEXPIRY,'YYYY-MM-DD') EXP,
to_char(bk0.M_XPRMPT,'YYYY-MM-DD') PMPDAT,
rtrim(bk0.M_XMULTIP) MULTIP,
rtrim(bk0.M_XVSHIFT) VOLBMP,
rtrim(bk0.M_XPSHIFT) PRCSHF,
to_char(bk1.M_XPSTART,'YYYY-MM-DD') PERFST,
to_char(bk1.M_XPEND,'YYYY-MM-DD') PERLST

from MUREX_MX_OWNER.TRN_HDR_DBF trn
left join MUREX_MX_OWNER.TRN_PC_DBF pc on 1 = 1
left join MUREX_MX_OWNER.CONTRACT_DBF cnt on trn.M_CONTRACT = cnt.M_REFERENCE
left join MUREX_MX_OWNER.TYPOLOGY_DBF typo on cnt.M_TYPOLOGY = typo.M_REFERENCE
left join MUREX_MX_OWNER.TRN_PLIN_DBF plin on trn.M_INSTRUMENT = plin.M_REFERENCE
left join MUREX_MX_OWNER.RTBLOCK#RTBKSKL_DBF skl on trn.M_NB = skl.M_INT_NB
left join MUREX_MX_OWNER.RTBLOCK#RTBK0_DBF bk0 on skl.M_BK_INT_N = bk0.M_INT_NB
left join MUREX_MX_OWNER.RTBLOCK#RTBK1_DBF bk1 on bk0.M_LINK = bk1.M_LINK

where rtrim(typo.M_LABEL) = 'Back Pricing'
-- and trn.M_TRN_STATUS not in ('DEAD')

order by TRN, PERFST