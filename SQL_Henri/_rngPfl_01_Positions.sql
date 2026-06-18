-- Initialize comment field
update TRN_PFLD_DBF set M_COMMENT0 = ' ';
-- OOS
update TRN_PFLD_DBF pfl set pfl.M_COMMENT0 = '20250604_OOS'  
where pfl.M_TYPE <> 0
or pfl.M_REF in (2,3,5,6,7,1723)
or substr(pfl.M_LABEL,1,4) in ('ORDE','WASH');
/*
-- Closed
update TRN_PFLD_DBF pfl set pfl.M_COMMENT0 = '20250604_Closed'  
where rtrim(pfl.M_LABEL) in 
(
select rtrim(udf.M_LABEL)
from TABLE#DATA#PORTFOLI_DBF udf
where rtrim(udf.M_CLOSURE_DT) is not null
);
*/
-- NoPosition
update TRN_PFLD_DBF pfl set pfl.M_COMMENT0 = '20250604_NoPosition' 
where 1 = 1
and pfl.M_TYPE = 0
and pfl.M_REF not in (2,3,5,6,7,1723)
and substr(pfl.M_LABEL,1,4) not in ('ORDE','WASH')
and pfl.M_REF not in
(
select
case when trn.M_COMMENT_BS = 'B' then bpfl.M_REF else spfl.M_REF end PFLUID
 
from TRN_HDR_DBF trn
left join TRN_PC_DBF pc on 1 = 1
left join TRN_PFLD_DBF bpfl on rtrim(trn.M_BPFOLIO) = rtrim(bpfl.M_LABEL)
left join TRN_PFLD_DBF spfl on rtrim(trn.M_SPFOLIO) = rtrim(spfl.M_LABEL)
 
where
trn.M_PURPOSE <> 'MeHzv70053'
and trn.M_MOP_LAST not in (6,7)
 
group by
case when trn.M_COMMENT_BS = 'B' then bpfl.M_REF else spfl.M_REF end
);
