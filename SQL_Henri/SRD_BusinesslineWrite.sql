drop table SRD_BZL;
create table SRD_BZL
(
ID   INTEGER NOT NULL,
GUID VARCHAR(32),
COD  VARCHAR2(5),
LAB  VARCHAR2(60), 
STA  INTEGER, 
PRIMARY KEY (ID)
);

insert into SRD_BZL (ID, GUID, COD, LAB, STA) values (1 , '205695217718537fe053c10615aca3aa', 'AGR'  , 'Agriculture', null);
insert into SRD_BZL (ID, GUID, COD, LAB, STA) values (2 , '205695217720537fe053c10615aca3aa', 'ASC'  , 'Assets: Corporate & Other', null);
insert into SRD_BZL (ID, GUID, COD, LAB, STA) values (3 , '205695217722537fe053c10615aca3aa', 'ASG'  , 'Assets: Group Non-Divisional', null);
insert into SRD_BZL (ID, GUID, COD, LAB, STA) values (4 , '205695217721537fe053c10615aca3aa', 'ASN'  , 'Assets: Non-Ferrous', null);
insert into SRD_BZL (ID, GUID, COD, LAB, STA) values (5 , '20569521771f537fe053c10615aca3aa', 'ASO'  , 'Assets: Oil', null);
insert into SRD_BZL (ID, GUID, COD, LAB, STA) values (6 , '205695217717537fe053c10615aca3aa', 'BLK'  , 'Physical Trading: Bulk', null);
insert into SRD_BZL (ID, GUID, COD, LAB, STA) values (7 , '20569521771b537fe053c10615aca3aa', 'CHN'  , 'Chartering: Non-Ferrous', null);
insert into SRD_BZL (ID, GUID, COD, LAB, STA) values (8 , '20569521771c537fe053c10615aca3aa', 'CHO'  , 'Chartering: Oil', null);
insert into SRD_BZL (ID, GUID, COD, LAB, STA) values (9 , 'c47ce367fa424ac8b8625f4571464131', 'CONC' , 'Physical Trading: Concentrates', null);
insert into SRD_BZL (ID, GUID, COD, LAB, STA) values (10, '205695217719537fe053c10615aca3aa', 'DRN'  , 'Derivatives: Non-Ferrous', null);
insert into SRD_BZL (ID, GUID, COD, LAB, STA) values (11, '20569521771a537fe053c10615aca3aa', 'DRO'  , 'Derivatives: Oil', null);
insert into SRD_BZL (ID, GUID, COD, LAB, STA) values (12, 'f7a4bd2f2182248fe0536b2ace0a7083', 'DTA'  , 'DT Assets', null);
insert into SRD_BZL (ID, GUID, COD, LAB, STA) values (13, '205695217729537fe053c10615aca3aa', 'FIN'  , 'Financing', null);
insert into SRD_BZL (ID, GUID, COD, LAB, STA) values (14, '205695217724537fe053c10615aca3aa', 'GLN'  , 'Galena', null);
insert into SRD_BZL (ID, GUID, COD, LAB, STA) values (15, '0358afadbbdfaa13e05015ac680675a8', 'GRP'  , 'Group Costs: Non-Divisional', null);
insert into SRD_BZL (ID, GUID, COD, LAB, STA) values (16, 'acaa07ffbce12791e05388733e0a7691', 'IMPNF', 'Impala - NF', null);
insert into SRD_BZL (ID, GUID, COD, LAB, STA) values (17, 'acaa07ffbce02791e05388733e0a7691', 'IMPOL', 'Impala - Oil', null);
insert into SRD_BZL (ID, GUID, COD, LAB, STA) values (18, '205695217725537fe053c10615aca3aa', 'INF'  , 'Investments and Assets: Non Ferrous', null);
insert into SRD_BZL (ID, GUID, COD, LAB, STA) values (19, '205695217728537fe053c10615aca3aa', 'ING'  , 'Investments and Assets: Group Non Divisional', null);
insert into SRD_BZL (ID, GUID, COD, LAB, STA) values (20, '205695217727537fe053c10615aca3aa', 'INM'  , 'Investments: Mining', null);
insert into SRD_BZL (ID, GUID, COD, LAB, STA) values (21, '205695217726537fe053c10615aca3aa', 'INO'  , 'Investments and Assets: Oil', null);
insert into SRD_BZL (ID, GUID, COD, LAB, STA) values (22, '20569521771e537fe053c10615aca3aa', 'LGS'  , 'Oil Downstream', null);
insert into SRD_BZL (ID, GUID, COD, LAB, STA) values (23, '20569521771d537fe053c10615aca3aa', 'MIN'  , 'Mining', null);
insert into SRD_BZL (ID, GUID, COD, LAB, STA) values (24, '97237e57fe1c72e8e0536e733e0a3361', 'NYR'  , 'Nyrstar', null);
insert into SRD_BZL (ID, GUID, COD, LAB, STA) values (25, 'edbc94d743004fccae2c8260ec4b7c53', 'OIL'  , 'Physical Trading: Oil', null);
insert into SRD_BZL (ID, GUID, COD, LAB, STA) values (26, '425ef59e067d6801e0536e733e0ad087', 'OTM'  , 'Other (Murex only Pre-NAV)', null);
insert into SRD_BZL (ID, GUID, COD, LAB, STA) values (27, 'acaa07ffbcdf2791e05388733e0a7691', 'POW'  , 'Physical Trading: Gas and Power', null);
insert into SRD_BZL (ID, GUID, COD, LAB, STA) values (28, '9b9e7fc8215d185fe05388733e0a07bf', 'PUMA' , 'PUMA', null);
insert into SRD_BZL (ID, GUID, COD, LAB, STA) values (29, '205695217723537fe053c10615aca3aa', 'REC'  , 'Recycling', null);
insert into SRD_BZL (ID, GUID, COD, LAB, STA) values (30, 'ff2f666f316f2aa0e0536b2ace0a5bfc', 'REN'  , 'Renewable Energy', null);
insert into SRD_BZL (ID, GUID, COD, LAB, STA) values (31, '1091ebbc447a44b3a6851c4e82b7e818', 'RMET' , 'Physical Trading: Refined Metals', null);
insert into SRD_BZL (ID, GUID, COD, LAB, STA) values (32, '425ef59e067e6801e0536e733e0ad087', 'TTD'  , 'Transit Trading', null);


