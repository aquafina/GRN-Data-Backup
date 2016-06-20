

DROP TABLE APPS.XX_RECEIPT_APPROVERS CASCADE CONSTRAINTS;

CREATE TABLE APPS.XX_RECEIPT_APPROVERS
(
  ENTITY     VARCHAR2(100 BYTE),
  ENTITY_ID  NUMBER,
  APPROVERS  VARCHAR2(1000 BYTE)
)
TABLESPACE APPS_TS_TX_DATA
PCTUSED    0
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          128K
            NEXT             128K
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
LOGGING 
NOCOMPRESS 
NOCACHE
NOPARALLEL
MONITORING;