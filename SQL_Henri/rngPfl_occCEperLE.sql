select 
LE,
count(*) OCC,
sum(case when CE = 'AP' then 1 else 0 end) AP,
sum(case when CE = 'EM' then 1 else 0 end) EM,
sum(case when CE = 'AM' then 1 else 0 end) AM
from

(
select distinct M_PC LE, M_CE CE from VIW_PFL_DBF
)

group by LE
order by LE
