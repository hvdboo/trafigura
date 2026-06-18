update TRN_PFLD_DBF
set M_COMMENT0 = '20250728_Closed'
where rtrim(M_LABEL) in
(
select rtrim(M_LABEL) from TABLE#DATA#PORTFOLI_DBF where to_char(M_CLOSURE_DT,'YYYY-MM-DD') is not null
)