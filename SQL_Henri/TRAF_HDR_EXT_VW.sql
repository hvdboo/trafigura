DROP VIEW HDREXT_VW_DBF;
CREATE VIEW
    HDREXT_VW_DBF
    (
        M_TNB,
        M_PLKEY,
        M_UNDERL1,
        M_INDEX1,
        M_MATURITY1,
        M_QT_END,
        M_DLV_FST,
        M_DLV_LST,
        M_SPLITMODE,
        M_NETMODE,
        M_ASSET,
        M_ASSETTYPE,
        M_REF,
        M_OP_ID,
        M_OP_ID2,
        M_OP_SYS,
        M_OP_SYS2,
        M_HR_ID,
        M_HR_TYPE,
        M_MIG_EXTPLT,
        M_MIG_TRADER,
        M_MIG_UTI,
        M_ORG_TRADER,
        M_DAY_NIGHT,
        M_TP_IE,
        M_PTF,
        M_PTF2,
        M_LEGAL_ENT,
        M_CTP,
        M_CTPCODE,
        M_CALC_FST,
        M_CALC_LST,
        M_CALC_FST1,
        M_CALC_LST1,
        M_TOT_QTY,
        M_LOCATION,
        M_PHYSICAL,
        M_TP_BUY,
        M_TP_TRADER,
        M_TP_TRADER2,
        M_PACKAGE,
        M_VERSION,
        M_CNT_ORG,
        M_STP_STATUS,
        M_STP_STAT_1,
        M_STP_STAT_2,
        M_STP_STAT_3,
        M_STP_STAT_4,
        M_ORG_EVT,
        M_ACTION_LST,
        M_ACTION_LST_D,
        M_ACTION_LST_CD,
        M_ACTION_TODAY,
        M_TM_INS_SEC,
        M_DT_INS,
        M_TM_INS,
        M_ACTION_USER,
        M_ACTION_USER_FULL,
        M_REG_SPACE,
        M_REG_ID,
        M_REG_UTI,
        M_SRC_SYS,
        M_TRN_FY
    ) AS
SELECT
    H.M_NB AS M_TNB,
    P."M_PLKEY",
    P."M_UNDERL1",
    P."M_INDEX1",
    P."M_MATURITY1",
    P."M_QT_END",
    P."M_DLV_FST",
    P."M_DLV_LST",
    P."M_SPLITMODE",
    P."M_NETMODE",
    P."M_ASSET",
    P."M_ASSETTYPE",
    U."M_REF",
    U."M_OP_ID",
    U."M_OP_ID2",
    U."M_OP_SYS",
    U."M_OP_SYS2",
    U."M_HR_ID",
    U."M_HR_TYPE",
    U."M_MIG_EXTPLT",
    U."M_MIG_TRADER",
    U."M_MIG_UTI",
    U."M_ORG_TRADER",
    U."M_DAY_NIGHT",
    CASE
        WHEN H.M_DST_PFOLIO=0
        THEN 'E'
        ELSE 'I'
    END                            AS M_TP_IE,
    PF.M_LABEL                     AS M_PTF,
    PF2.M_LABEL                    AS M_PTF2,
    LE.M_DSP_LABEL                 AS M_LEGAL_ENT,
    CTP.M_DSP_LABEL                AS M_CTP,
    CTP.M_CODE                     AS M_CTPCODE,
    NVL(P.M_DLV_FST,D0.M_CALC_FST) AS M_CALC_FST,
    NVL(P.M_DLV_LST,D0.M_CALC_LST) AS M_CALC_LST,
    D1.M_CALC_FST                  AS M_CALC_FST1,
    D1.M_CALC_LST                  AS M_CALC_LST1,
    D0.M_TOT_QTY,
    D0.M_LOCATION,
    D0.M_PHYSICAL,
    -- Buy/Sell
    CASE
        WHEN M_TRN_GRP IN('SWAP',
                          'SCF',
                          'CS',
                          'IRS',
                          'SPOT')
        THEN
            CASE
                WHEN M_BRW_FV1='F'
                THEN
                    CASE
                        WHEN M_BRW_PR1 ='P'
                        THEN 'Buy'
                        ELSE 'Sell'
                    END
                ELSE
                    CASE
                        WHEN M_BRW_PR1 ='R'
                        THEN 'Buy'
                        ELSE 'Sell'
                    END
            END
        ELSE DECODE(M_COMMENT_BS,'S','Sell','B','Buy')
    END AS M_TP_BUY,
    -- Trader internal
    CASE
        WHEN H.M_TRN_GRP IN ('SWAP',
                             'CS',
                             'IRS',
                             'SPOT')
        THEN H.M_BTRADER
        ELSE
            CASE
                WHEN H.M_COMMENT_BS='B'
                THEN H.M_BTRADER
                ELSE H.M_STRADER
            END
    END AS M_TP_TRADER,
    -- Trader external
    CASE
        WHEN H.M_TRN_GRP IN ('SWAP',
                             'CS',
                             'IRS',
                             'SPOT')
        THEN H.M_STRADER
        ELSE
            CASE
                WHEN H.M_COMMENT_BS='B'
                THEN H.M_STRADER
                ELSE H.M_BTRADER
            END
    END            AS M_TP_TRADER2,
    CTN.M_PACK_REF AS M_PACKAGE,
    CTN.M_VERSION  AS M_VERSION,
    CTN.M_ORIG_REF AS M_CNT_ORG,
    CTN.M_STP_STATUS,
    CTN.M_STP_STAT_1,
    CTN.M_STP_STAT_2,
    CTN.M_STP_STAT_3,
    CTN.M_STP_STAT_4,
    -- Package type
    -- cast(nvl(trim(cm1.m_desc),substr(CM1.M_NAME,11,18)) as varchar2(18)) as M_PCK_TYPE,
    -- Event at the origin of the trade
    CAST(NVL(trim(cm2.m_desc),SUBSTR(CM2.M_NAME,17,18)) AS VARCHAR2(18)) AS M_ORG_EVT, --
    -- Last event done on the trade, stays empty for trade issued by C/R?
    DECODE(E.M_VERSION, 1, 'New Trade', IMP.M_LST_EVT) AS M_ACTION_LST,
    E.M_DATE                                           AS M_ACTION_LST_D,
    TRUNC(E.M__DT_TS)                                  AS M_ACTION_LST_CD,
    CASE
        WHEN TRUNC(E.M__DT_TS)=TRUNC(SYSDATE)
        THEN 'Y'
        ELSE 'N'
    END AS M_ACTION_TODAY,
    -- Amount of seconds booking follows midnight on evening of T
    -- cast(greatest(0,round((cast(H.M__DT_TS as DATE)-H.M_TRN_DATE-1)*24*60*60,0)) as number(10,0)
    -- ) as M_TM_INS_SEC,
    TO_CHAR(H.M__DT_TS,'sssss')                                          AS M_TM_INS_SEC,
    CAST(H.M__DT_TS AS DATE)                                             AS M_DT_INS,
    TO_CHAR(H.M__DT_TS,'HH:MI:SS')                                       AS M_TM_INS,
    USR.M_LABEL                                                          AS M_ACTION_USER,
    USR.M_FULL_NAME                                                      AS M_ACTION_USER_FULL,
    REG.M_NAMESPACE                                                      AS M_REG_SPACE,
    REG.M_TRANSACTION_ID                                                 AS M_REG_ID,
    NVL(U.M_MIG_UTI,trim(REG.M_NAMESPACE) || trim(REG.M_TRANSACTION_ID)) AS M_REG_UTI,
    SRC.M_LABEL                                                          AS M_SRC_SYS,
    -- Fiscal year
    case 
    when extract(month from H.M_TRN_EXP) < 10 then 'FY'||to_char(H.M_TRN_EXP,'YY')
    else 'FY'||substr(trim(to_char(extract(year from H.M_TRN_EXP)+1,'9999')),3,2) end as M_TRN_FY
    
FROM
    TRN_HDR_DBF H,
    TRN_EXT_DBF E,
    SOMEUDF_DBF U,
    CMT_PLKEYEXT3_DBF P,
    TRN_PFLD_DBF PF,
    TRN_PFLD_DBF PF2,
    TRN_CPDF_DBF CTP,
    CMT_DLVEXT_DBF D0,
    CMT_DLVEXT1_DBF D1,
    -- TYPOLOGY_DBF T,
    -- TRN_PLIN_DBF INST,
    CONTRACT_DBF CTN,
    TRN_CPDF_DBF LE,
    -- CLASS_MAPPING_DBF CM1,
    CLASS_MAPPING_DBF CM2,
    LAST_IMP_VW_DBF IMP,
    TRN_REG_INF_DBF REG,
    MX_USER_DBF USR,
    SRC_MOD_DBF SRC
WHERE
    H.M_NB=E.M_TRADE_REF
AND E.M_VERSION=CTN.M_VERSION
AND H.M_CONTRACT=CTN.M_REFERENCE
AND CTN.M_ORIG_REF=REG.M_CONTRACT_REF (+)
    --  and CTN.M_REFERENCE=REG.M_CONTRACT_REF (+)
    --  and CTN.M_VERSION=REG.M_CONTRACT_VERSION (+)
AND CTN.M_SRC_MODULE=SRC.M_REFERENCE (+)
AND E.M_UDF_REF=U.M_REF (+)
AND H.M_PL_KEY1=P.M_PLKEY (+)
AND H.M_SRC_PFOLIO=PF.M_REF (+)
AND H.M_DST_PFOLIO=PF2.M_REF (+)
AND H.M_COUNTRPART=CTP.M_ID (+)
AND PF.M_PROC_AREA=le.m_id (+)
AND H.M_NB=D0.M_NB (+)
AND H.M_NB=D1.M_NB (+)
AND H.M_NB=IMP.M_NB (+)
AND E.M_ACTOR=USR.M_REFERENCE (+)
    --  and CM1.M_ID (+) =CTN.M_PACK_INTID
AND CM2.M_ID (+) =E.M_EVT_INTID;