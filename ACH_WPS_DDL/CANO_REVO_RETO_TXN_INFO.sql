--<ScriptOptions statementTerminator=";"/>

CREATE TABLE "ESBACH"."CANO_REVO_RETO_TXN_INFO" (
		"CAN_REV_RET_TXN_INF_ID" NUMBER NOT NULL,
		"GRP_HDR_ID_TXN_INFO_FK" NUMBER,
		"TXN_RCVD_BY" VARCHAR2(40 CHAR),
		"USER_REF" VARCHAR2(40 CHAR),
		"TRAN_REF" VARCHAR2(40 CHAR),
		"END_TO_END_ID" VARCHAR2(48 CHAR),
		"ORIGIN_END_TO_END_ID" VARCHAR2(40 CHAR),
		"TXN_REASON" VARCHAR2(100 CHAR),
		"TXN_FOUND" VARCHAR2(40 CHAR),
		"ORIG_MSG_ID" VARCHAR2(40 CHAR),
		"ORIG_TXN_ID" VARCHAR2(40 CHAR),
		"CREDITOR_BANK_BICFI" VARCHAR2(40 CHAR),
		"CREDITOR_ACC_NO" VARCHAR2(40 CHAR),
		"TXN_AMOUNT" NUMBER,
		"CBS_TRAN_REF" VARCHAR2(40),
		"CBS_PAY_REF" VARCHAR2(40),
		"STATUS" VARCHAR2(40),
		"DESCRIPTION" VARCHAR2(500 CHAR),
		"EXEC_DESC" VARCHAR2(2000 CHAR),
		"OPTIONAL_ID" VARCHAR2(40 CHAR),
		"MSG_ID" VARCHAR2(40 CHAR),
		"TXN_ID" VARCHAR2(40 CHAR),
		"DEBTOR_BANK_BICFI" VARCHAR2(40 CHAR),
		"DEBTOR_ACC_NO" VARCHAR2(40 CHAR),
		"CBS_FAULT_CODE" VARCHAR2(40),
		"CBS_FAULT_STRING" VARCHAR2(50),
		"CBS_REQUEST" CLOB,
		"FAULT_CODE" VARCHAR2(40),
		"FAULT_STRING" VARCHAR2(500),
		"CBO_STATUS" VARCHAR2(40)
	)
	LOGGING;

CREATE UNIQUE INDEX "ESBACH"."CANO_REVO_RETO_TXN_INFO_PK"
	ON "ESBACH"."CANO_REVO_RETO_TXN_INFO"
	("CAN_REV_RET_TXN_INF_ID"		ASC)
	LOGGING;

ALTER TABLE "ESBACH"."CANO_REVO_RETO_TXN_INFO" ADD CONSTRAINT "CANO_REVO_RETO_TXN_INFO_PK" PRIMARY KEY
	("CAN_REV_RET_TXN_INF_ID");

ALTER TABLE "ESBACH"."CANO_REVO_RETO_TXN_INFO" ADD CONSTRAINT "SYS_C0011526" CHECK ("CAN_REV_RET_TXN_INF_ID" IS NOT NULL);

CREATE TRIGGER "ESBACH"."CANO_REVO_RETO_TXN_INFO_TRG" 
	BEFORE INSERT ON "ESBACH"."CANO_REVO_RETO_TXN_INFO"
	REFERENCING NEW AS NEW OLD AS OLD
	FOR EACH ROW
BEGIN  
   SELECT CANO_REVO_RETO_TXN_INFO_SEQ.NEXTVAL INTO :NEW.CAN_REV_RET_TXN_INF_ID FROM SYS.DUAL;
END;

