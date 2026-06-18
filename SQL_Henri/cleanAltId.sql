-- Remove reference to DG model. Is maintained in LUT table  [888 records]
delete from KEYMAP_STC_DBF where rtrim(M_OBJ_ASYS) in ('DG_FWD','DG_HIS','DG_SRD');

-- Adapt URL for ICE to new ICE url access [656 records]
update KEYMAP_STC_DBF 
set M_OBJ_ALT = replace(M_OBJ_ALT,'theice','ice') 
where substr(M_OBJ_ALT,13,6) = 'theice';  

-- Define reference to exchange URL as a single alternate sys (instead of one per exchange) [1245 records]
update KEYMAP_STC_DBF
set M_OBJ_ASYS = 'URL'
where rtrim(M_OBJ_ASYS) in
(
'BBB_URL',
'BMD_URL',
'BSE_URL',
'CME_URL',
'CSS_URL',
'DCE_URL',
'DME_URL',
'EEX_URL',
'ENX_URL',
'EUR_URL',
'ICE_URL',
'JPX_URL',
'LME_URL',
'MCX_URL',
'MSE_URL',
'MXC_URL',
'NSE_URL',
'ROF_URL',
'SGE_URL',
'SGX_URL',
'SHF_URL',
'ZCE_URL'
);

-- Correct typo errors [1+1 record]
update KEYMAP_STC_DBF set M_OBJ_ASYS = 'ACC_ID' where rtrim(M_OBJ_ASYS) = 'ACC_D'; 
update KEYMAP_STC_DBF set M_OBJ_ASYS = 'EAI' where rtrim(M_OBJ_ASYS) = 'EIA';

-- Remove Pluto as Alt System (merged with Titan) [883 records]
delete from KEYMAP_STC_DBF where rtrim(M_OBJ_ASYS) in ('PLUTO','PLUTO_OPT');
