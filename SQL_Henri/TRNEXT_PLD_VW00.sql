select
-- Dates
to_char(pld.M_VAL_DAT2,'YYYYMMDD') PCDAT,
to_char(pld.M_TP_DTETRN,'YYYYMMDD') TRNDAT,
-- Identifiers
rtrim(pld.M_CNT_SRCMOD) SRC,
pld.M_NB TRN,
pld.M_CONTRACT CNT,
pld.M_CNT_VS2 CVS,
pld.M_PACKAGE PCK,
rtrim(pld.M_TP_GID) GID,
-- Parties
case pld.M_TP_INT when 'Y' then 'I' else 'E' end TRN_IE,
-- case when ctyp.M_REF = 16 then 'I' else 'E' end CTP_IE,
rtrim(pld.M_TP_LENTDSP) LE,
rtrim(pld.M_TP_ENTITY) CE,
rtrim(pld.M_TP_TRADER) USR,
rtrim(pld.M_TP_PFOLIO) PFL,
rtrim(pld.M_TP_CNTRP) CTP,
-- Product
pld.M_TP_LSTOTC LO,
(case pld.M_TRN_FMLY when 'COM' then rtrim(pld.M_TP_ASSET) else rtrim(pld.M_TRN_FMLY) end) ASS,
rtrim(pld.M_TRN_FMLY) FML,
rtrim(pld.M_TRN_GRP) GRP,
rtrim(pld.M_TRN_TYPE) TYP,
rtrim(pld.M_CNT_TYPO) TYPO,
rtrim(pld.M_INSTRUMENT) INS,
rtrim(pld.M_TP_CMDFYS0) PHY,
---- Index 1
rtrim(pld.M_TP_IND0) IND0,
rtrim(pld.M_TP_CMIQ0) QOT0,
rtrim(pld.M_TP_UND0) UND0,
rtrim(pld.M_TP_PUB0) PUB0,
rtrim(pld.M_TP_HSR0) HSR0,
---- Index 2
rtrim(pld.M_TP_IND1) IND1,
rtrim(pld.M_TP_CMIQ1) QOT1,
rtrim(pld.M_TP_UND1) UND1,
rtrim(pld.M_TP_PUB1) PUB1,
rtrim(pld.M_TP_HSR1) HSR1,
-- Quote
rtrim(pld.M_TP_COQ) CUR,
rtrim(pld.M_TP_UOQ) UOQ,
rtrim(pld.M_TP_UOD0) UOD,
rtrim(pld.M_TP_UOV0) UOV,
pld.M_TP_LOTSIZE LOTSIZ,
-- Tenor
case when pld.M_TRN_FMLY = 'COM' then 
case when (pld.M_TRN_GTYPE in (100,101,102,103) and rtrim(pld.M_TP_CMIPUB0) = 'LME') then 
case when pld.M_TP_DTEEXP = '10-FEB-21' then 'CASH' else
case when pld.M_TP_DTEEXP = '07-MAY-21' then '3M' else
case when to_date(pld.M_TP_DTEEXP) = next_day(trunc(to_date(pld.M_TP_DTEEXP,'DD-MON-YY'),'mm')-1,'Wednesday') + 14 then rtrim(substr(pld.M_TP_DTEEXP,4,6)) 
else rtrim(pld.M_TP_TEN) end end end
else case when pld.M_TRN_GTYPE in (154) then to_char(pld.M_TP_MAT,'YYYY-MM-DD') else rtrim(pld.M_TP_TEN) end end
else null end MAT,
case when pld.M_TRN_GTYPE in (100,101,102,103) then pld.M_TP_CMCMAT else null end FUTMAT, 
case when pld.M_TRN_GTYPE in (101,103) then pld.M_TP_CMCMAT else null end OPTMAT,
---- Trade dates
to_char(pld.M_TP_CMGDF0,'YYYYMMDD') CFST0,
to_char(pld.M_TP_CMGDL0,'YYYYMMDD') CLST0,
to_char(pld.M_TP_CMGDF1,'YYYYMMDD') CFST1,
to_char(pld.M_TP_CMGDL1,'YYYYMMDD') CLST1,
to_char(pld.M_TP_DTEPMT,'YYYYMMDD') STL,
to_char(pld.M_TP_DTEEXP,'YYYYMMDD') EXP,
-- Option
pld.M_TP_STRIKE STK,
case when pld.M_TP_OPT='O' then pld.M_TP_CP else null end RGT,
-- Price
pld.M_TP_RTE02 RTE0,
pld.M_TP_MRG0 MRG0,
pld.M_TP_RTE12 RTE1,
pld.M_TP_MRG1 MRG1,
case M_TP_RTFV1
when 'F' then pld.M_TP_PRICE
when 'V' then pld.M_TP_RTE12
else null end PRC,
pld.M_TP_DIR DIR,
pld.M_TP_LS LS,
-- NOM, QTY
pld.M_TP_NOM0 NOM0,
pld.M_TP_NOM1 NOM1,
abs(pld.M_TP_CMGQTY0) QTY

from MUREX_DM_OWNER.CHECK_PL_REP pld
left join MUREX_MX_OWNER.TRN_CPDF_DBF ctp on pld.M_TP_CNTRPID = ctp.M_ID

where
pld.M_TP_STATUS2 <> 'DEAD'

