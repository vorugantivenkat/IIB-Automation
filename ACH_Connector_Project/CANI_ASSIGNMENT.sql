--<ScriptOptions statementTerminator=";"/>

CREATE TABLE "ACHADMIN"."CANI_ASSIGNMENT" (
		"CANC_ASSIGNMENT_ID" NUMBER NOT NULL,
		"ID" VARCHAR2(35 CHAR),
		"ASSGNR_AGT_FININSTID_BICFI" VARCHAR2(35 CHAR),
		"ASSGNR_AGT_FINSID_CSMBID_MMBID" VARCHAR2(40 CHAR),
		"ASSGNE_AGT_FININSTNID_BICFI" VARCHAR2(40 CHAR),
		"ASSGNE_AGT_FINSID_CSMBID_MMBID" VARCHAR2(40 CHAR),
		"CREATION_DATETIME" VARCHAR2(40)
	)
	LOGGING;

ALTER TABLE "ACHADMIN"."CANI_ASSIGNMENT" ADD CONSTRAINT "SYS_C0011388" PRIMARY KEY
	("CANC_ASSIGNMENT_ID");

ALTER TABLE "ACHADMIN"."CANI_ASSIGNMENT" ADD CONSTRAINT "SYS_C0011389" CHECK ("CANC_ASSIGNMENT_ID" IS NOT NULL);
CREATE SEQUENCE  "ACHADMIN"."CANI_ASSIGNMENT_SEQ"  MINVALUE 1 MAXVALUE 9999999999999999999999999999 INCREMENT BY 1 START WITH 1 CACHE 500 NOORDER  NOCYCLE ;

CREATE OR REPLACE TRIGGER "ACHADMIN"."CANI_ASSIGNMENT_TRIG" 
	BEFORE INSERT ON "ACHADMIN"."CANI_ASSIGNMENT"
	REFERENCING NEW AS NEW OLD AS OLD
	FOR EACH ROW
BEGIN
  
    SELECT CANI_ASSIGNMENT_SEQ.NEXTVAL INTO :NEW.CANC_ASSIGNMENT_ID FROM SYS.DUAL;
END;
COMMIT
