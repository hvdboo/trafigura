select max(M_NB) from TRN_HDR_DBF

select * from TRN_HDR_DBF where M_NB in 
(
9995053
)

select * from TRN_HDR_DBF where M_TRN_GTYPE in (90)

select * from RT_LOAN_DBF where M_NB in 
(
9995053
)


select * from RT_LNGN_DBF where M_GEN_NUM = 4001

select * from CMT_DLV_DBF where M_NB in (9995053)

select * from COM_LOAN_DBF where M_REFERENCE in (9995053)
select * from COM_LOAN_DBF where M_REF_DB > 0

select * from FD111200_DBF where M_NB in 
(
9694434,
10461118,
10584733
)

select distinct M_TRN_FMLY, M_TRN_GTYPE from TRN_HDR_DBF

select * from CM_FMAT1_DBF where M_REFERENCE = 6227

select * from PACKAGE_DBF where M_REFERENCE = 519032

select * from CONTRACT_DBF where M_REFERENCE = 849556

select * from TRN_CPDF_DBF

select * from TYPOLOGY_DBF where M_REFERENCE = 1339

select * from TRN_PLIN_DBF where M_REFERENCE = '9019'

SELECT
  next_day(trunc(TO_DATE('10-OCT-17','DD-MON-YY'),'mm')-1,'Wednesday') + 14 AS THIRD_WED 
  FROM 
  DUAL
  
select trunc(TO_DATE('10-OCT-17','DD-MON-YY'),'YY')-1 from dual

select to_date('15-NOV-17','DD-MON-YY') from dual

select distinct M_TRN_GTYPE, M_TRN_FMLY, M_TRN_GRP, M_TRN_TYPE from TRN_HDR_DBF

select * from TRN_BROKER_DBF where M_NB = 10379650

select M_MX_REF_JOB, count (*) 
from TRAF_TDLPTE_REP
group by M_MX_REF_JOB

select distinct M_MX_REF_JOB from TRAF_TDLPTE_REP

delete from TRAF_TDLPTE_REP where M_MX_REF_JOB = 25944

select M_MX_REF_JOB, count(*) 
from TRAF_TDLPTE_REP
group by M_MX_REF_JOB
-- and M_NB = 10204661

select * from TRAF_TDLPTE_REP
where M_MX_REF_JOB = 25946
and M_NB = 10577522


truncate table TRAF_TDLPTE_REP


select count(*) 
from TRN_HDR_DBF
where 
coalesce(ble.M_DSP_LABEL,sle.M_DSP_LABEL) in ('TDL')
and trn.M_BINTERNAL <> trn.M_SINTERNAL
and coalesce(ctyp.M_REF,0) = 0

select 
trn.M_GID, brk.* 
from TRN_BROKER_DBF brk
left join TRN_HDR_DBF trn on brk.M_NB = trn.M_NB
where substr(trn.M_GID,1,6) = 'TDLPTE';

delete 
from 
(
select *  
from TRN_BROKER_DBF brk
left join TRN_HDR_DBF trn on brk.M_NB = trn.M_NB 
where substr(trn.M_GID,1,6) = 'TDLPTE'
);


select
trn.M_TRN_GTYPE FGTID,
trn.M_TRN_FMLY, trn.M_TRN_GRP, trn.M_TRN_TYPE,
rtrim(typo.M_LABEL) TYPO, 
count(*)
from TRN_HDR_DBF trn
left join CONTRACT_DBF cnt on trn.M_CONTRACT = cnt.M_REFERENCE
left join TYPOLOGY_DBF typo on cnt.M_TYPOLOGY = typo.M_REFERENCE
where trn.M_TRN_STATUS <> 'DEAD'
group by trn.M_TRN_GTYPE, trn.M_TRN_FMLY, trn.M_TRN_GRP, trn.M_TRN_TYPE, typo.M_LABEL;


select
count(*)
from TRN_HDR_DBF trn
left join CONTRACT_DBF cnt on trn.M_CONTRACT = cnt.M_REFERENCE
where substr(trn.M_GID,1,6) = 'TDLPTE';

select 
-- PFL, SRC, 
count(*) 
from TRAF_TDLPTE 
group by PFL, SRC;

select * 
from TRAF_TDLPTE_REP
where M_NB in (9748233,10482492)
-- where FGTID = 154;

select distinct M_OBJ_CLASS, rtrim(clas.M_NAME)
from KEYMAP_STC_DBF altid
left join CLASS_MAPPING_DBF clas on altid.M_OBJ_CLASS = clas.M_ID


