-- Excel : at beginning, add columns ID, SRCSYS, SRCDAT + relabel existing columns (cf. below)
-- Save Excel as CSV
-- Load from CSV (H2 Database)
select * from csvread('M:\_Projects\CEDOil\Master file\workbench\Jupiter\EAI.csv');

-- Default field values for new columns fields
ID     =  XTR_EAI_DBFS.nextval
SRCSYS = 'EAI'
SRCDAT = 'YYYY-MM-DD' with date of the EAI export

-- Create Oracle sequence
create sequence XTR_EAI_DBFS;
create sequence XTR_EAI_DBFS
minvalue 1
start with 1
increment by 1
cache 10;

-- Create Oracle table
drop table XTR_EAI_DBF;
create table XTR_EAI_DBF 
(
ID         INTEGER, 
SRCSYS     VARCHAR2(30), 
SRCDAT     VARCHAR2(10), 
EAIQOT     INTEGER, 
NAME       VARCHAR2(150), 
MKTTYP     VARCHAR2(30), 
PUBSCHED   VARCHAR2(30), 
FORMULA    VARCHAR2(300), 
LOTALF     VARCHAR2(30), 
LOTNUM     NUMBER(10,4), 
UOV        VARCHAR2(10), 
CUR        VARCHAR2(10), 
TENOR      VARCHAR2(10), 
CAL        VARCHAR2(30), 
XCH        VARCHAR2(30), 
CUTOFF     VARCHAR2(30), 
HSR        VARCHAR2(30), 
EXPRULE    VARCHAR2(60), 
PHY        VARCHAR2(30), 
CNV_LAB    VARCHAR2(30), 
CNV_FCT    NUMBER(30,12), 
CNV_NUM    VARCHAR2(10), 
CNV_DEN    VARCHAR2(10), 
RISK       VARCHAR2(90), 
OPTSTDDEV  VARCHAR2(30), 
PRCSHIFT   NUMBER(30,12), 
DG_SINCE   DATE, 
DG_SPT     VARCHAR2(300), 
DG_SPTFCT  NUMBER(30,12), 
DG_SPTMAT  VARCHAR2(30), 
DG_CRV     VARCHAR2(300), 
DG_CRVFCT  NUMBER(30,12), 
DG_CRVMAT  VARCHAR2(30), 
DG_FLAT    VARCHAR2(150), 
DG_VOL     VARCHAR2(150), 
DG_VOLFCT  NUMBER(30,12), 
DG_VOLMAT  VARCHAR2(30), 
DG_VOLSPR  VARCHAR2(150), 
DG_FIXPULL INTEGER, 
MV_SINCE   DATE, 
MV_SPT     VARCHAR2(150), 
MV_SPTFCT  NUMBER(30,12), 
MV_CRV     VARCHAR2(150), 
MV_CRVFCT  NUMBER(30,12), 
MV_FLAT    VARCHAR2(150), 
MV_VOL     VARCHAR2(150), 
MV_SPR     VARCHAR2(150), 
MV_FIXPULL INTEGER
);

-- Columns equivalence
ID           INT            
SRCSYS       VARCHAR(30)    
SRCDAT       DATE           
EAIQOT       INT            EAI Quote ID
NAME         VARCHAR(150)   Name
MKTTYP       VARCHAR(30)    Market Type
PUBSCHED     VARCHAR(30)    Publishing Schedule
FORMULA      VARCHAR(300)   Formula
LOTALF       VARCHAR(30)    Lot Size
LOTNUM       DOUBLE         
UOV          VARCHAR(10)    Volume Unit
CUR          VARCHAR(10)    Currency
TENOR        VARCHAR(10)    Tenor
CAL          VARCHAR(30)    Calendar
XCH          VARCHAR(30)    Exchange
CUTOFF       VARCHAR(30)    Close Time
HSR          VARCHAR(30)    Level
EXPRULE      VARCHAR(60)    Expiry Rule
PHY          VARCHAR(30)    Commodity
CNV_LAB      VARCHAR(30)    Conversion Factor
CNV_FCT      DOUBLE         
CNV_NUM      VARCHAR(10)    
CNV_DEN      VARCHAR(10)    
RISK         VARCHAR(90)    Risk Aliases
OPTSTDDEV    VARCHAR(30)    Use StdDev for Options
PRCSHIFT     DOUBLE         Price Shift
DG_SINCE     DATE           Genic Since Day
DG_SPT       VARCHAR(300)   Genic Spot
DG_SPTFCT    DOUBLE         
DG_SPTMAT    VARCHAR(30)    
DG_CRV       VARCHAR(300)   Genic Curves
DG_CRVFCT    DOUBLE         
DG_CRVMAT    VARCHAR(30)    
DG_FLAT      VARCHAR(150)   Genic Flat Rates
DG_VOL       VARCHAR(150)   Genic Vols
DG_VOLFCT    DOUBLE         
DG_VOLMAT    VARCHAR(30)    
DG_VOLSPR    VARCHAR(150)   Genic Spread Vols
DG_FIXPULL   INT            Genic Fixings Pull Days
MV_SINCE     DATE           MV Since Day
MV_SPT       VARCHAR(150)   MV Spot
MV_SPTFCT    DOUBLE         
MV_CRV       VARCHAR(150)   MV Curves
MV_CRVFCT    DOUBLE         
MV_FLAT      VARCHAR(150)   MV Flat Rates
MV_VOL       VARCHAR(150)   MV Vols
MV_SPR       VARCHAR(150)   MV Spread Vols
MV_FIXPULL   INT            MV Fixings Pull Days


