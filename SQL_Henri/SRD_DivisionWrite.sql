drop table SRD_DIV;
create table SRD_DIV
(
ID   INTEGER NOT NULL,
GUID VARCHAR(32),
COD  VARCHAR2(5), 
LAB  VARCHAR2(60), 
STA  INTEGER, 
PRIMARY KEY (ID)
);

insert into SRD_DIV (ID, GUID, COD, LAB, STA) values ( 1, '6990bda4485f637fe05388733e0ab95e', null, 'Metals and Minerals', null);
insert into SRD_DIV (ID, GUID, COD, LAB, STA) values ( 2, '7532723a062d4d10e05339733e0a5e24', null, 'Group', null);
insert into SRD_DIV (ID, GUID, COD, LAB, STA) values ( 3, '6990bda44860637fe05388733e0ab95e', null, 'Oil and Petroleum', null);
insert into SRD_DIV (ID, GUID, COD, LAB, STA) values ( 4, '7532723a062b4d10e05339733e0a5e24', null, 'Derivatives', null);
insert into SRD_DIV (ID, GUID, COD, LAB, STA) values ( 5, '7532723a062c4d10e05339733e0a5e24', null, 'Freight', null);
insert into SRD_DIV (ID, GUID, COD, LAB, STA) values ( 6, '7532723a06324d10e05339733e0a5e24', null, 'Treasury', null);
insert into SRD_DIV (ID, GUID, COD, LAB, STA) values ( 7, '7532723a062e4d10e05339733e0a5e24', null, 'Impala', null);
insert into SRD_DIV (ID, GUID, COD, LAB, STA) values ( 8, '7532723a06304d10e05339733e0a5e24', null, 'Oil', null);
insert into SRD_DIV (ID, GUID, COD, LAB, STA) values ( 9, '265d6bc8e6014b908416efcca5322001', null, 'Gas and Power', null);
insert into SRD_DIV (ID, GUID, COD, LAB, STA) values (10, '7532723a06314d10e05339733e0a5e24', null, 'Puma', null);
insert into SRD_DIV (ID, GUID, COD, LAB, STA) values (11, '7532723a062a4d10e05339733e0a5e24', null, 'DT', null);

