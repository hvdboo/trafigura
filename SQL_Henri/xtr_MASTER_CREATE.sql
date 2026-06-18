-- Excel : at beginning, add columns ID, SRCSYS, SRCDAT + relabel existing columns (cf. below)
-- Save Excel as CSV
-- Load from CSV (H2 Database)
select * from csvread('M:\_Projects\CEDOil\Master file\workbench\Master\CCE_OilToMx.csv');

-- Default field values for new columns fields
ID     =  XTR_MASTER_DBFS.nextval
SRCSYS = 'Master'
SRCDAT = 'YYYY-MM-DD' with date of the MASTER FILE export

-- Create Oracle sequence
drop sequence XTR_MASTER_DBFS;
create sequence XTR_MASTER_DBFS
minvalue 1
start with 1
increment by 1
cache 10;

-- Create Oracle table
drop table XTR_MASTER_DBF;
create table XTR_MASTER_DBF
(
ID                INTEGER,
SRCSYS            CHARACTER VARYING(10),
SRCDAT            CHARACTER VARYING(10),
ASSETLABEL        CHARACTER VARYING(30), 
ASSET             CHARACTER VARYING(10), 
PRODUCTCODE       CHARACTER VARYING(20), 
MXTYPOLOGY        CHARACTER VARYING(10), 
MXINSLABEL        CHARACTER VARYING(50), 
MXDESCRIPTION     CHARACTER VARYING(150), 
MXPLIUID          INTEGER, 
MKTPUBLICATION    CHARACTER VARYING(10), 
MKTMIC            CHARACTER VARYING(5), 
MKTSYMBOL         CHARACTER VARYING(10), 
OBSERVATION       CHARACTER VARYING(10), 
MATURITYCAST      CHARACTER VARYING(20), 
CONTRACT_STYLE    CHARACTER VARYING(5), 
CONTRACT_EXR      CHARACTER VARYING(5), 
CONTRACT_PRM      CHARACTER VARYING(5), 
CONTRACT_CUR      CHARACTER VARYING(5), 
CONTRACT_FCT      INTEGER, 
UOQ               CHARACTER VARYING(10), 
UOD               CHARACTER VARYING(10), 
LOT               INTEGER, 
TICK              NUMERIC(12,6), 
DECI              INTEGER,
TAS_TAM           CHARACTER VARYING(20), 
ICEECONFIRM       CHARACTER VARYING(10), 
OTCEQV            CHARACTER VARYING(40),
INDEXTYPE         CHARACTER VARYING(10), 
INDEXLABEL        CHARACTER VARYING(40), 
INDEXPUBLICATION  CHARACTER VARYING(20), 
INDEXSYMBOL       CHARACTER VARYING(20),
INDEXSERIE        CHARACTER VARYING(10), 
C_U               CHARACTER VARYING(10), 
BASKETINDEX1      CHARACTER VARYING(40), 
BASKETPUB1        CHARACTER VARYING(20), 
BASKETSYMBOL1     CHARACTER VARYING(20), 
BASKETSERIE1      CHARACTER VARYING(10), 
BASKETINDEX2      CHARACTER VARYING(40), 
BASKETPUB2        CHARACTER VARYING(20), 
BASKETSYMBOL2     CHARACTER VARYING(20), 
BASKETSERIE2      CHARACTER VARYING(10), 
TITANLABEL        CHARACTER VARYING(100), 
TITANGUID         CHARACTER VARYING(40), 
PLUTO1            CHARACTER VARYING(20), 
PLUTO2            CHARACTER VARYING(20), 
PLUTO3            CHARACTER VARYING(20), 
PLUTO4            CHARACTER VARYING(20), 
PLUTO5            CHARACTER VARYING(20)
);

-- Columns equivalence
ID                   INTEGER
SRCSYS               CHARACTER VARYING(10)
SRCDAT               CHARACTER VARYING(10)
ASSETLABEL           CHARACTER VARYING(30)       productAsset
ASSET                CHARACTER VARYING(10)       Asset
PRODUCTCODE          CHARACTER VARYING(20)       productCode
MXTYPOLOGY           CHARACTER VARYING(10)       mxTypology
MXINSLABEL           CHARACTER VARYING(50)       mxInsLabel
MXDESCRIPTION        CHARACTER VARYING(150)      mxDescription
MXPLIUID             INTEGER                     mxPliUID
MKTPUBLICATION       CHARACTER VARYING(10)       mktPublication
MKTMIC               CHARACTER VARYING(5)        mktMIC
MKTSYMBOL            CHARACTER VARYING(10)       mktSymbol
OBSERVATION          CHARACTER VARYING(10)       Observation
MATURITYCAST         CHARACTER VARYING(20)       maturityCast
CONTRACT_STYLE       CHARACTER VARYING(5)        contract_Style
CONTRACT_EXR         CHARACTER VARYING(5)        contact_Exr
CONTRACT_PRM         CHARACTER VARYING(5)        contract_Prm
CONTRACT_CUR         CHARACTER VARYING(5)        conract_Cur
CONTRACT_FCT         INTEGER                     contract_Fct
UOQ                  CHARACTER VARYING(10)       UOQ
UOD                  CHARACTER VARYING(10)       UOD
LOT                  INTEGER                     Lot
TICK                 NUMERIC(12,6)               Tick
DECI                 INTEGER                     Deci
TAS_TAM              CHARACTER VARYING(20)       TAS_TAM
ICEECONFIRM          CHARACTER VARYING(10)       iceEConfirm
OTCEQV               CHARACTER VARYING(40)       OTCEquivalent
INDEXTYPE            CHARACTER VARYING(10)       indexType
INDEXLABEL           CHARACTER VARYING(40)       indexLabel
INDEXPUBLICATION     CHARACTER VARYING(20)       indexPublication
INDEXSYMBOL          CHARACTER VARYING(20)       indexSymbol
INDEXSERIE           CHARACTER VARYING(10)       indexSerie
C_U                  CHARACTER VARYING(10)       C_U
BASKETINDEX1         CHARACTER VARYING(40)       basketIndex1
BASKETPUB1           CHARACTER VARYING(20)       basketPub1
BASKETSYMBOL1        CHARACTER VARYING(20)       basketSymbol1
BASKETSERIE1         CHARACTER VARYING(10)       basketSerie1
BASKETINDEX2         CHARACTER VARYING(40)       basketIndex2
BASKETPUB2           CHARACTER VARYING(20)       basketPub2
BASKETSYMBOL2        CHARACTER VARYING(20)       basketSymbol2
BASKETSERIE2         CHARACTER VARYING(10)       basketSerie2
TITANLABEL           CHARACTER VARYING(100)      titanLabel
TITANGUID            CHARACTER VARYING(40)       titanInstrumentGUID
PLUTO1               CHARACTER VARYING(20)       Pluto1
PLUTO2               CHARACTER VARYING(20)       Pluto2
PLUTO3               CHARACTER VARYING(20)       Pluto3
PLUTO4               CHARACTER VARYING(20)       Pluto4
PLUTO5               CHARACTER VARYING(20)       Pluto5



