--<ScriptOptions statementTerminator=";"/>

CREATE TABLE "ESBACH"."DDI_GP_HEADER_INFO" (
		"DDI_GP_HEADER_ID" NUMBER NOT NULL,
		"MSG_ID" VARCHAR2(16 CHAR),
		"CREATION_DATETIME" TIMESTAMP,
		"NO_OF_TXNS" NUMBER,
		"TOTAL_INTRBANK_SETTLE_AMT" BINARY_DOUBLE,
		"INTERBANK_SETTLE_DATE" DATE,
		"SETTLE_INFO_METHOD" VARCHAR2(10 CHAR) DEFAULT 'CLRG' NOT NULL,
		"SETTLE_INFO_CLR_SYS_PRTRY" VARCHAR2(10 CHAR) DEFAULT 'CBO' NOT NULL,
		"PMT_TP_INF_LCL_INST_CODE" VARCHAR2(40 CHAR),
		"PMT_TP_INF_CTGY_PURP_PRTRY" VARCHAR2(35 CHAR),
		"INSTG_AGT_FIN_ID_BICFI" VARCHAR2(40 CHAR),
		"INSTG_AGT_FIN_ID_CLR_SYS_MMBID" VARCHAR2(35 CHAR),
		"INSTG_AGT_BRNCHID_ID" VARCHAR2(35 CHAR),
		"INSTD_AGT_FIN_ID_BICFI" VARCHAR2(40 CHAR),
		"INSTD_AGT_FIN_ID_CLR_SYS_MMBID" VARCHAR2(40 CHAR),
		"INSTD_AGT_BRNCHID_ID" VARCHAR2(35 CHAR),
		"SRC_MSG" CLOB
	)
	LOGGING;

ALTER TABLE "ESBACH"."DDI_GP_HEADER_INFO" ADD CONSTRAINT "SYS_C0011492" CHECK ("DDI_GP_HEADER_ID" IS NOT NULL);

ALTER TABLE "ESBACH"."DDI_GP_HEADER_INFO" ADD CONSTRAINT "SYS_C0011493" CHECK ("SETTLE_INFO_METHOD" IS NOT NULL);

ALTER TABLE "ESBACH"."DDI_GP_HEADER_INFO" ADD CONSTRAINT "SYS_C0011494" CHECK ("SETTLE_INFO_CLR_SYS_PRTRY" IS NOT NULL);

ALTER TABLE "ESBACH"."DDI_GP_HEADER_INFO" ADD CONSTRAINT "SYS_C0011495" PRIMARY KEY
	("DDI_GP_HEADER_ID");

CREATE TRIGGER "ESBACH"."DDI_GP_HEADER_INFO_TRIG" 
	BEFORE INSERT ON "ESBACH"."DDI_GP_HEADER_INFO"
	REFERENCING NEW AS NEW OLD AS OLD
	FOR EACH ROW
BEGIN
    
   SELECT DDI_GP_HEADER_INFO_SEQ.NEXTVAL INTO :NEW.DDI_GP_HEADER_ID FROM SYS.DUAL;
END;

