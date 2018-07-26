--<ScriptOptions statementTerminator=";"/>

CREATE TABLE "ESBACH"."CANO_REVO_RETO_GRPHDR_INFO" (
		"GRP_MSG_MODE" VARCHAR2(20),
		"GRP_CHANNEL" VARCHAR2(20),
		"GRP_BATCH_REF" VARCHAR2(20),
		"GRP_ORGIN_BATCH" VARCHAR2(20),
		"GRP_REASON" VARCHAR2(100),
		"STATUS" VARCHAR2(30),
		"CHL_BTCH_REF" VARCHAR2(32),
		"MSG_RCV_TIMESTAMP" VARCHAR2(40),
		"GRP_HEADER_ID" NUMBER NOT NULL,
		"MSG_ID" VARCHAR2(30),
		"CBO_STATUS" VARCHAR2(40),
		"DESCRIPTION" VARCHAR2(300)
	)
	LOGGING;

CREATE UNIQUE INDEX "ESBACH"."CANO_REVO_RETO_GRPHDR_INFO_PK"
	ON "ESBACH"."CANO_REVO_RETO_GRPHDR_INFO"
	("GRP_HEADER_ID"		ASC)
	LOGGING;

ALTER TABLE "ESBACH"."CANO_REVO_RETO_GRPHDR_INFO" ADD CONSTRAINT "CANO_REVO_RETO_GRPHDR_INFO_PK" PRIMARY KEY
	("GRP_HEADER_ID");

ALTER TABLE "ESBACH"."CANO_REVO_RETO_GRPHDR_INFO" ADD CONSTRAINT "SYS_C0011524" CHECK ("GRP_HEADER_ID" IS NOT NULL);

CREATE TRIGGER "ESBACH"."CANO_REVO_RETO_GRPHDR_INFO_TRG" 
	BEFORE INSERT ON "ESBACH"."CANO_REVO_RETO_GRPHDR_INFO"
	REFERENCING NEW AS NEW OLD AS OLD
	FOR EACH ROW
BEGIN
  <<COLUMN_SEQUENCES>>
  BEGIN
    IF INSERTING AND :NEW.GRP_HEADER_ID IS NULL THEN
      SELECT CANO_REVO_RETO_GRPHDR_INFO_SEQ.NEXTVAL INTO :NEW.GRP_HEADER_ID FROM SYS.DUAL;
    END IF;
  END COLUMN_SEQUENCES;
END;

