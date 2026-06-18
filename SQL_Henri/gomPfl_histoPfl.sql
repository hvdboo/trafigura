select distinct
case when trn.M_COMMENT_BS = 'B' then rtrim(trn.M_BPFOLIO) else rtrim(trn.M_SPFOLIO) end PFL,
sum(case when trn.M_TRN_STATUS <> 'DEAD' then 1 else 0 end) LIVE,
sum(case when trn.M_TRN_STATUS = 'DEAD'  then 1 else 0 end) DEAD,
count(*) OCC

from TRN_HDR_DBF trn

group by (case when trn.M_COMMENT_BS = 'B' then rtrim(trn.M_BPFOLIO) else rtrim(trn.M_SPFOLIO) end)
order by PFL