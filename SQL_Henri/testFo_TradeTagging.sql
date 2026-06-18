-- Create tag values
insert into TRN_TAG_DBF (M_IDENTITY, M_REFERENCE, M_LABEL, M_DESC) values(1, 1,'COMBLK', 'Commodities, Bulk');
insert into TRN_TAG_DBF (M_IDENTITY, M_REFERENCE, M_LABEL, M_DESC) values(2, 2,'COMMET', 'Commodities, Metals');
insert into TRN_TAG_DBF (M_IDENTITY, M_REFERENCE, M_LABEL, M_DESC) values(3, 3,'COMNRG', 'Commodities, Energy');
insert into TRN_TAG_DBF (M_IDENTITY, M_REFERENCE, M_LABEL, M_DESC) values(4, 4,'FIE'   , 'Forex, Interest rates, Equity');

-- Assign tags to trades
-- FRT CS TCA 5 APO_SGX
insert into TRN_TAG_J_DBF (M_IDENTITY, M_TAG_REFERENCE, M_TRADE_ORIGIN) values (1, 1, 56929910);
insert into TRN_TAG_J_DBF (M_IDENTITY, M_TAG_REFERENCE, M_TRADE_ORIGIN) values (2, 1, 56929941);
insert into TRN_TAG_J_DBF (M_IDENTITY, M_TAG_REFERENCE, M_TRADE_ORIGIN) values (3, 1, 57260547);
-- FRT CS TCA 5 BAL_ASN
insert into TRN_TAG_J_DBF (M_IDENTITY, M_TAG_REFERENCE, M_TRADE_ORIGIN) values (4, 1, 63986242);
insert into TRN_TAG_J_DBF (M_IDENTITY, M_TAG_REFERENCE, M_TRADE_ORIGIN) values (5, 1, 64616204);

        
