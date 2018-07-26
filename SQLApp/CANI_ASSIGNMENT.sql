
  CREATE TABLE "ESBACH"."CANI_ASSIGNMENT" 
   (	"CANC_ASSIGNMENT_ID" NUMBER NOT NULL ENABLE, 
	"ID" VARCHAR2(35 CHAR), 
	"ASSGNR_AGT_FININSTID_BICFI" VARCHAR2(35 CHAR), 
	"ASSGNR_AGT_FINSID_CSMBID_MMBID" VARCHAR2(40 CHAR), 
	"ASSGNE_AGT_FININSTNID_BICFI" VARCHAR2(40 CHAR), 
	"ASSGNE_AGT_FINSID_CSMBID_MMBID" VARCHAR2(40 CHAR), 
	"CREATION_DATETIME" TIMESTAMP (6), 
	"MSG_RECV_TIMESTAMP" TIMESTAMP (6), 
	 PRIMARY KEY ("CANC_ASSIGNMENT_ID")
  USING INDEX PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1 BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "SYSTEM"  ENABLE
   ) SEGMENT CREATION IMMEDIATE 
  PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255 NOCOMPRESS LOGGING
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1 BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "SYSTEM" ;

  
   CREATE SEQUENCE  "ESBACH"."CANI_ASSIGNMENT_SEQ"  MINVALUE 1 MAXVALUE 9999999999999999999999999999 INCREMENT BY 1 START WITH 7001 CACHE 500 NOORDER  NOCYCLE ;

  
  
  CREATE OR REPLACE TRIGGER "ESBACH"."CANI_ASSIGNMENT_TRIG" 
   before INSERT
   ON esbach.CANI_ASSIGNMENT
   FOR EACH ROW
BEGIN
  
    SELECT CANI_ASSIGNMENT_SEQ.NEXTVAL INTO :NEW.CANC_ASSIGNMENT_ID FROM SYS.DUAL;
END;
/
ALTER TRIGGER "ESBACH"."CANI_ASSIGNMENT_TRIG" ENABLE;