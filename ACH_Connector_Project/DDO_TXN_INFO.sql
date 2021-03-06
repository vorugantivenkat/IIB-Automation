--<ScriptOptions statementTerminator=";"/>

CREATE TABLE "ACHADMIN"."DDO_TXN_INFO" (
		"DDO_TXN_INF_ID" NUMBER NOT NULL,
		"DDO_GRP_HDR_ID_TXN_INFO_FK" NUMBER NOT NULL,
		"TXN_REF" VARCHAR2(16 CHAR),
		"END_TO_END_ID" VARCHAR2(35 CHAR),
		"USER_REF" VARCHAR2(35 CHAR),
		"MANDATEID" VARCHAR2(20),
		"MANDATE_FIRST_COLLECTION_DATE" DATE,
		"MANDATE_PAY_COLLECTION_DATE" VARCHAR2(20 CHAR),
		"MANDATE_PAY_SEQUENCE" NUMBER,
		"AMOUNT" NUMBER(18 , 5),
		"PAYER_BANK" VARCHAR2(35 CHAR),
		"PAYER_ACCOUNT" VARCHAR2(30 CHAR),
		"PAYER_NAME" VARCHAR2(140 CHAR),
		"PAYER_ID" VARCHAR2(35 CHAR),
		"PAYER_ID_TYPE" VARCHAR2(35 CHAR),
		"PURP_OF_TRANSFER" VARCHAR2(20),
		"DETAILS_OF_PMTS" VARCHAR2(140 CHAR),
		"STATUS" VARCHAR2(35 CHAR),
		"DESCRIPTION" VARCHAR2(500 CHAR),
		"CBS_TRAN_REF" VARCHAR2(40 CHAR),
		"CBS_PAY_REF" VARCHAR2(40 CHAR),
		"EXEC_DESC" VARCHAR2(2000 CHAR),
		"IIB_STATUS" VARCHAR2(4),
		"MSG_ID" VARCHAR2(20),
		"TXN_ID" VARCHAR2(20),
		"PMT_ID_TXN_ID" VARCHAR2(40),
		"DBTRACCT_ID_IBAN" VARCHAR2(40),
		"CBO_STATUS" VARCHAR2(40),
		"CBS_REQUEST_MESSAGE" CLOB,
		"FAULT_CODE" VARCHAR2(30),
		"FAULT_STRING" VARCHAR2(500)
	)
	LOGGING;

CREATE UNIQUE INDEX "ACHADMIN"."DD_TXN_INFO_PK"
	ON "ACHADMIN"."DDO_TXN_INFO"
	("DDO_TXN_INF_ID"		ASC)
	LOGGING;

ALTER TABLE "ACHADMIN"."DDO_TXN_INFO" ADD CONSTRAINT "DD_TXN_INFO_PK" PRIMARY KEY
	("DDO_TXN_INF_ID");

ALTER TABLE "ACHADMIN"."DDO_TXN_INFO" ADD CONSTRAINT "SYS_C0011489" CHECK ("DDO_GRP_HDR_ID_TXN_INFO_FK" IS NOT NULL);

ALTER TABLE "ACHADMIN"."DDO_TXN_INFO" ADD CONSTRAINT "DD_GRP_HDR_ID_TXN_INFO_FK" FOREIGN KEY
	("DDO_GRP_HDR_ID_TXN_INFO_FK")
	REFERENCES "ACHADMIN"."DDO_GROUP_HEADER_INFO"
	("DDO_GRP_HEADER_ID");

CREATE SEQUENCE  "ACHADMIN"."DDO_TXN_INFO_SEQ"  MINVALUE 1 MAXVALUE 9999999999999999999999999999 INCREMENT BY 1 START WITH 1 CACHE 500 NOORDER  NOCYCLE ;	
CREATE OR REPLACE TRIGGER "ACHADMIN"."DDO_TXN_INFO_TRG" 
	BEFORE INSERT ON "ACHADMIN"."DDO_TXN_INFO"
	REFERENCING NEW AS NEW OLD AS OLD
	FOR EACH ROW
BEGIN
  
   
   SELECT DDO_TXN_INFO_SEQ.NEXTVAL INTO :NEW.DDO_TXN_INF_ID FROM SYS.DUAL;
END;
COMMIT 
