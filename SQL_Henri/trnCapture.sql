select 
tre.OUTL OUTLINE, tre.RNK RANK,
case when tre.TBL = 0 then tre.FLD else str.LAB end NODE,
--str.BOX, str.NMB, 
str.OCC,
case str.REG
when   8 then 'IRD|LN_BR'
when  77 then 'CURR|FXD|FXD'
when  90 then 'SCF|SCF|SCF'
when 100 then 'COM|FUT' 
when 101 then 'COM|OFUT|LST'
when 102 then 'COM|FWD'
when 103 then 'COM|OFUT|OTC'
when 113 then 'COM|OPT|SMP'
when 130 then 'COM|SWAP'
when 131 then 'COM|ASIAN' else null end REGISTRY,
case str.REG
when  8 then 'Generator'
when 77 then 'FX Contract'
else plin.M_DSP_LABEL end INSTRUMENT,
str.PAT PRODUCT, 
typo.M_LABEL TYPOLOGY,
str.EXO EXOTIC,
null CNT



from EDFM_TREB tre
left join EDFM_STR str on (rtrim(tre.FLD) = rtrim(str.LAB) and tre.TRE = 7)
left join TRN_PLIN_DBF plin on str.INS  = plin.M_ID
left join TYPOLOGY_DBF typo on str.TYPO = typo.M_REFERENCE


where tre.TRE = 7
order by tre.OUTL