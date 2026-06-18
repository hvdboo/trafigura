select * from
(

select
rtrim(dtm.M_TP_PFOLIO) PFL,
rtrim(dtm.M_TRN_FMLY) FML,
-- rtrim(dtm.M_CNT_TYPO) TYPO,
rtrim(dtm.M_INSTRUMENT) PLIN,
to_char(dtm.M_TP_DTEEXP,'YYYY-MM-DD') EXP,
dtm.M_F_CURRENCY FLWCUR,
dtm.M_F_TYPELAB1 FLWTYP,
round(sum(dtm.M_F_AMOUNT),2) FLWAMT

from MUREX_DM_OWNER.CHECK_CS_REP dtm
where 1 = 1
and dtm.M_F_CURRENCY <> 'USD'
and to_char(dtm.M_F_VALUE,'YYYY-MM-DD') < '2020-03-09'

group by
dtm.M_TP_PFOLIO,
dtm.M_TRN_FMLY,
-- dtm.M_CNT_TYPO,
dtm.M_INSTRUMENT,
dtm.M_TP_DTEEXP,
dtm.M_F_CURRENCY,
dtm.M_F_TYPELAB1

order by PFL, FML, PLIN, FLWCUR, EXP

)

where FLWAMT <> 0
