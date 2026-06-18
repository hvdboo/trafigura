DROP TABLE _mx_MAPTYP;
CREATE TABLE _mx_MAPTYP (ID INTEGER, LAB VARCHAR2(30), DES VARCHAR2(100), SSCH VARCHAR2(30), STBL VARCHAR2(60), SCOL VARCHAR2(30), TSCH VARCHAR2(30), TTBL VARCHAR2(60), TCOL VARCHAR2(30));
INSERT INTO _mx_MAPTYP (ID, LAB, DES, SSCH, STBL, SCOL, TSCH, TTBL, TCOL) VALUES (1, 'Buzobj - DynTable', null, 'murex', 'mxbuzobj', null, 'murex', 'mx_dyntbl', null);
INSERT INTO _mx_MAPTYP (ID, LAB, DES, SSCH, STBL, SCOL, TSCH, TTBL, TCOL) VALUES (2, 'Buzobj - RiskEngine', null, null, null, null, null, null, null);
INSERT INTO _mx_MAPTYP (ID, LAB, DES, SSCH, STBL, SCOL, TSCH, TTBL, TCOL) VALUES (3, 'Buzobj - MxML', null, null, null, null, null, null, null);
INSERT INTO _mx_MAPTYP (ID, LAB, DES, SSCH, STBL, SCOL, TSCH, TTBL, TCOL) VALUES (4, 'Buzobj - Schema', null, 'murex', 'mxbuzobj', null, 'murex', 'syscolumns', null);
INSERT INTO _mx_MAPTYP (ID, LAB, DES, SSCH, STBL, SCOL, TSCH, TTBL, TCOL) VALUES (5, 'DynTable - Schema', null, null, null, null, null, null, null);
INSERT INTO _mx_MAPTYP (ID, LAB, DES, SSCH, STBL, SCOL, TSCH, TTBL, TCOL) VALUES (6, 'Registration - Events', null, 'murex', 'mx_reg', 'INST', 'murex', 'mx_evt', 'CLASS');
