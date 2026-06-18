-- Comment
update 
TRN_HDRF_DBF flw 
set M_COMMENT = 'Neutralize: '||to_char(M_AMOUNT)
where rtrim(M_EVT_INTID) = 'MfDcS60401'
and M_EVT_REF > ?;

-- Neutralize amount
update 
TRN_HDRF_DBF flw 
set M_AMOUNT = 0
where rtrim(M_EVT_INTID) = 'MfDcS60401'
and M_EVT_REF > ?;
