drop table SRD_FNL;
create table SRD_FNL
(
ID   INTEGER NOT NULL,
GUID VARCHAR(32),
LAB  VARCHAR2(60), 
STA  INTEGER, 
PRIMARY KEY (ID)
);

insert into SRD_FNL (ID, GUID, LAB, STA) values ( 1, null, 'Concentrate', null);
insert into SRD_FNL (ID, GUID, LAB, STA) values ( 2, null, 'Refined Metal', null);
insert into SRD_FNL (ID, GUID, LAB, STA) values ( 3, null, 'Bulk', null);
insert into SRD_FNL (ID, GUID, LAB, STA) values ( 4, null, 'Energy', null);


