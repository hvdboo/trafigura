select
dtm.M_MX_REF_JOB JOB,
rtrim(job.M_TAGDATA) TAG,
case 
when substr(dtm.M_TP_GID,1,3) <> 'TDL' then to_char(dtm.M_NB)
when substr(dtm.M_TP_GID,1,3) =  'TDL' then rtrim(substr(dtm.M_TP_GID,12,10))
else null end as REFS,
case 
when substr(dtm.M_TP_GID,1,3) <> 'TDL' then '0_ORI' 
when substr(dtm.M_TP_GID,8,3) = 'OFF'  then '1_OFF' 
when substr(dtm.M_TP_GID,8,3) = 'TRF'  then '2_TRF' 
else null end as GEN,
'INT' POS,
to_char(dtm.M_TP_TSD,'YYYYMMDD') TMSDAT,
rtrim(dtm.M_CNT_SRCMOD) SRC,
dtm.M_NB TRN,
dtm.M_CONTRACT CNT,
dtm.M_CNT_ORG CNTORI,
dtm.M_CNT_VS2 CVS,
dtm.M_PACKAGE PCK,
rtrim(dtm.M_TP_GID) GID,
rtrim(dtm.M_CNT_USI_NS) UTI_NS,
rtrim(dtm.M_CNT_USI_ID) UTI_ID,
rtrim(dtm.M_UDF_REFUTI)  UTI_MIG,
rtrim(dtm.M_TP_INT) TRN_IE,
rtrim(dtm.M_TP_LENTDSP) LE,
rtrim(dtm.M_TP_ENTITY) CE,
rtrim(dtm.M_TP_PFOLIO) PFL,
rtrim(dtm.M_TP_CNTRP) CTP,
dtm.M_TP_LSTOTC LO,
-- ASS,
rtrim(dtm.M_TRN_FMLY)||'|'||rtrim(dtm.M_TRN_GRP)||'|'||coalesce(rtrim(dtm.M_TRN_TYPE),' ') FGT,
rtrim(dtm.M_CNT_TYPO) TYPO,
rtrim(dtm.M_INSTRUMENT) INS,
rtrim(dtm.M_TP_CMCLAB) FUT,
rtrim(dtm.M_TP_CMILAB0) IND,
rtrim(dtm.M_TP_CMULAB0) UND,
rtrim(dtm.M_TP_CMIQ0) QOT,
rtrim(dtm.M_TP_CMIPUB0) PUB,
rtrim(dtm.M_TP_CMIHSR0) HSR,
dtm.M_TP_CMIQC0 CUR,
rtrim(dtm.M_TP_CMIQU0) UOM,
rtrim(dtm.M_TP_CMDFYS0) PHY,
rtrim(dtm.M_TP_CMCMAT) MAT,
to_char(dtm.M_TP_DTEFST,'YYYYMMDD') CFST1,
to_char(dtm.M_TP_DTELST,'YYYYMMDD') CLST1,
to_char(dtm.M_TP_CMGFF1,'YYYYMMDD') CFST2,
to_char(dtm.M_TP_CMGFL1,'YYYYMMDD') CLST2,
to_char(dtm.M_TP_DTEPMT,'YYYYMMDD') STL,
to_char(dtm.M_TP_DTEEXP,'YYYYMMDD') EXP,
coalesce(dtm.M_TP_STRIKE,0) STK,
rtrim(dtm.M_TP_CP) CP,
rtrim(dtm.M_TP_BUY_E) BS_E,
-- rtrim(dtm.M_TP_BUY) BS,
dtm.M_TP_NOMINAL NOM,
dtm.M_TP_LQTYS2 QTY,
dtm.M_TP_PRICE PRC, 
dtm.M_TP_RTMMRG1 MRG,
dtm.M_PL_GEPL2 PL_GE,
dtm.M_PL_NEPL2 PL_NE,
dtm.M_PL_MV_FIN2 PL_MV_FIN,
dtm.M_PL_FP_FIN2 PL_FP_FIN,
dtm.M_PL_PC_FIN2 PL_PC_FIN,
dtm.M_PL_FE_FIN2 PL_FE_FIN,
dtm.M_PL_FTFI2 PL_FTFI,
dtm.M_PL_CSFI2 PL_CSFI

from MUREX_DM_OWNER.TRAF_TDLPTE_REP dtm
left join MUREX_MX_OWNER.ACT_JOBDAP_DBF job on dtm.M_MX_REF_JOB = job.M_IDJOB

where 
dtm.M_MX_REF_JOB =?
-- and dtm.M_NB in (10202622, 10565056, 10582333)