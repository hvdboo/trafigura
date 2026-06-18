-- View
update VWR_VISH_DBF set M_OWNER = 'MUREXBO' where M_TYPE = 1 and rtrim(M_OWNER) = 'JOHN.SMITH';

-- Breakdown formula
update VWR_VISH_DBF set M_OWNER = 'MUREXBO' where  M_TYPE = 10 rtrim(M_OWNER) = 'MUREXFO';