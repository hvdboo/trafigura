-- Excel : at beginning, add columns ID, SRCSYS, SRCDAT + relabel existing columns (cf. below)
-- Save Excel as CSV
-- Load from CSV (H2 Database)
select * from csvread('M:\_Projects\CEDOil\Master file\workbench\Pluto\Pluto.csv');

-- Default field values for new columns fields
ID     =  XTR_PLUTO_DBFS.nextval
SRCSYS = 'Pluto'
SRCDAT = 'YYYY-MM-DD' with date of the PLUTO export

-- Create Oracle sequence
drop sequence XTR_PLUTO_DBFS;
create sequence XTR_PLUTO_DBFS
minvalue 1
start with 1
increment by 1
cache 10;

-- Create Oracle table
drop table XTR_PLUTO_DBF;
create table XTR_PLUTO_DBF 
(
ID                        INTEGER,
SRCSYS                    CHARACTER VARYING(10),
SRCDAT                    CHARACTER VARYING(10),
PRO_REF                   CHARACTER VARYING(20), 
PRO_LOT_SIZE              NUMERIC(10,2), 
QTYCODE                   CHARACTER VARYING(10), 
QUOTEID                   INTEGER, 
LONGNAME                  CHARACTER VARYING(100), 
CLEARPORTDEFAULTPRECISION INTEGER, 
USECUSTOMROUNDING         INTEGER, 
LEG1QUOTEID               INTEGER, 
LEG1PRICEPRECISION        INTEGER, 
LEG1AVGPRECISION          INTEGER, 
LEG2QUOTEID               INTEGER, 
LEG2PRICEPRECISION        INTEGER, 
LEG2AVGPRECISION          INTEGER, 
IS_OPTION                 INTEGER, 
IS_EXTERNAL               INTEGER, 
TRADECOUNT                INTEGER
);

-- Columns equivalence
ID                          INTEGER                 
SRCSYS                      CHARACTER VARYING(10)   
SRCDAT                      CHARACTER VARYING(10)   
PRO_REF                     CHARACTER VARYING(20)   Pro_ref
PRO_LOT_SIZE                NUMERIC(10,2)           pro_lot_size
QTYCODE                     CHARACTER VARYING(10)   QtyCode
QUOTEID                     INTEGER                 QuoteID
LONGNAME                    CHARACTER VARYING(100)  LongName
CLEARPORTDEFAULTPRECISION   INTEGER                 clearportdefaultprecision
USECUSTOMROUNDING           INTEGER                 usecustomrounding
LEG1QUOTEID                 INTEGER                 Leg1QuoteID
LEG1PRICEPRECISION          INTEGER                 Leg1PricePrecision
LEG1AVGPRECISION            INTEGER                 Leg1AvgPrecision
LEG2QUOTEID                 INTEGER                 Leg2QuoteID
LEG2PRICEPRECISION          INTEGER                 Leg2PricePrecision
LEG2AVGPRECISION            INTEGER                 Leg2AvgPrecision
IS_OPTION                   INTEGER                 Is_Option
IS_EXTERNAL                 INTEGER                 Is_External
TRADECOUNT                  INTEGER                 Tradecount

