drop table   TRAF_FLOW;
create table TRAF_FLOW (ID INTEGER, TYPO VARCHAR(30), CMT VARCHAR(300));
insert into  TRAF_FLOW (ID,TYPO,CMT) values (1,'TYPO1','C Capital; R Revenue; P Premium; UDEF User defined');
insert into  TRAF_FLOW (ID,TYPO,CMT) values (1,'TYPO2','BRK Brokerage; CAP Capital; MRG Margin; REV Revenue');
insert into  TRAF_FLOW (ID,TYPO,CMT) values (1,'TYPO3','ADJ Adjustment; BFEE Brokerage fee; BTAX Brokerage tax; CFEE Clearing fee; CIFE ; CPN Coupon; CTAX Clearing tax; DIV Dividend; IFEE Initial fee; IPAY Initial payment; M_C Margin call; NOM Nominal; PERF ; PRO ; PROV Provision; RCL ; RPL ;  STL Settlement; TAXC ; XIT Exit');
insert into  TRAF_FLOW (ID,TYPO,CMT) values (1,'TYPO4','DELV ; EST Estimated; FIC ; FIX Fixed; RTRN ; UPFD ; UPFI ; UPFN ; ');
insert into  TRAF_FLOW (ID,TYPO,CMT) values (1,'TYPO5','ACC Accrual; ADD Additional flow; CVA ; INT Interest; OFF ; PROJ ; RES ; UND ; ');