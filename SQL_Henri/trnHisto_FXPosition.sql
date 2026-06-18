select * from
(

select 
case trn.M_COMMENT_BS  when 'B' then trn.M_BPFOLIO when 'S' then trn.M_SPFOLIO end PFL,
rtrim(plin.M_DSP_LABEL) PLIN,
to_char(trn.M_TRN_EXP,'YYYY-MM-DD') EXP,
-- rtrim(typo.M_LABEL) TYPO,
-- trn.M_PL_INSCUR CUR,
trn.M_BRW_NOMU1 UND,
trn.M_BRW_NOMU2 BASE,
round(sum(case when trn.M_COMMENT_BS = 'B' then trn.M_BRW_NOM1 else (trn.M_BRW_NOM1)*-1 end),2) NOM_UND, 
round(sum(case when trn.M_COMMENT_BS = 'B' then (trn.M_BRW_NOM2)*-1 else trn.M_BRW_NOM2 end),2) NOM_BAS

from TRN_HDR_DBF trn
left join TRN_PC_DBF pc on 1 = 1
left join CONTRACT_DBF cnt on trn.M_CONTRACT = cnt.M_REFERENCE
left join SRC_MOD_DBF src on cnt.M_SRC_MODULE = src.M_REFERENCE
left join TYPOLOGY_DBF typo on cnt.M_TYPOLOGY = typo.M_REFERENCE
left join TRN_PLIN_DBF plin on trn.M_INSTRUMENT = plin.M_REFERENCE
left join FD111200_DBF fxd on trn.M_NB = fxd.M_NB
left join FX_CNT_DBF fxc on rtrim(plin.M_DSP_LABEL) = rtrim(fxc.M_LABEL)

where 1 = 1
and trn.M_TRN_GTYPE in (76, 77, 92)
and trn.M_MOP_LAST not in (6, 7)
and to_char(trn.M_TRN_EXP,'YYYY-MM-DD') < '2020-03-09'
-- and trn.M_TRN_STATUS <> 'DEAD'

group by
case trn.M_COMMENT_BS when 'B' then trn.M_BPFOLIO when 'S' then trn.M_SPFOLIO end,
trn.M_TRN_EXP,
plin.M_DSP_LABEL,
trn.M_BRW_NOMU1,
trn.M_BRW_NOMU2

order by PFL, PLIN, EXP

)

where NOM_UND < -0.99 or NOM_UND > 0.99