
drop table "ESBACH"."DCI_TXN_INFO" 



  CREATE TABLE "ESBACH"."DCI_TXN_INFO" 
   (	"DCI_TXN_INFO_ID" NUMBER NOT NULL ENABLE, 
	"DCI_GP_HDR_ID_TXN_FK" NUMBER, 
	"PMT_ID_INSTR_ID" VARCHAR2(35 CHAR), 
	"PMT_ID_ENDTOEND_ID" VARCHAR2(30 CHAR), 
	"PMT_ID_TXN_ID" VARCHAR2(40 CHAR), 
	"INTERBANK_SETTLE_AMT" NUMBER(18,5), 
	"STLMT_PRITRY" VARCHAR2(40 CHAR), 
	"CHARGE_BEARER" VARCHAR2(10 CHAR) DEFAULT 'SLEV' NOT NULL ENABLE, 
	"INSTD_AGT_FIN_ID_BICFI" VARCHAR2(40 CHAR), 
	"INSTD_AGT_BNCHID_ID" VARCHAR2(35 CHAR), 
	"DBTR_NAME" VARCHAR2(140 CHAR), 
	"DBTR_ACCT_ID_IBAN" VARCHAR2(30 CHAR), 
	"DBTR_ACCT_OTHR_ID" VARCHAR2(34 CHAR), 
	"DBTR_ACCT_FIN_ID_BICFI" VARCHAR2(40 CHAR), 
	"DBTR_ACCT_BNCHID_ID" VARCHAR2(35 CHAR), 
	"CDTR_NAME" VARCHAR2(140 CHAR), 
	"CDTR_ACCT_ID_IBAN" VARCHAR2(30 CHAR), 
	"CDTR_ACCT_OTHR_ID" VARCHAR2(34 CHAR), 
	"CDTR_ACCT_FIN_ID_BICFI" VARCHAR2(40 CHAR), 
	"CDTR_ACCT_BNCHID_ID" VARCHAR2(35 CHAR), 
	"PURP_PROPTYCHAR" VARCHAR2(35 CHAR), 
	"STATUS" VARCHAR2(40 CHAR), 
	"CBS_TRAN_REF" VARCHAR2(40 CHAR), 
	"CBS_PAY_REF" VARCHAR2(35 CHAR), 
	"EXEC_DESC" VARCHAR2(2000 BYTE), 
	"DESCRIPTION" VARCHAR2(100 BYTE), 
	"MSG_ID" VARCHAR2(20 CHAR), 
	"CBS_REQUEST_MESSAGE" CLOB, 
	"FAULT_CODE" VARCHAR2(20 BYTE), 
	"FAULT_STRING" VARCHAR2(60 BYTE), 
	 PRIMARY KEY ("DCI_TXN_INFO_ID")
  USING INDEX PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1 BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "SYSTEM"  ENABLE, 
	 FOREIGN KEY ("DCI_GP_HDR_ID_TXN_FK")
	  REFERENCES "ESBACH"."DCI_GP_HEADER_INFO" ("DCI_GP_HEADER_ID") ENABLE
   ) SEGMENT CREATION IMMEDIATE 
  PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255 NOCOMPRESS LOGGING
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1 BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "SYSTEM" 
 LOB ("CBS_REQUEST_MESSAGE") STORE AS BASICFILE (
  TABLESPACE "SYSTEM" ENABLE STORAGE IN ROW CHUNK 8192 RETENTION 
  NOCACHE LOGGING 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1 BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)) ;

  
  CREATE SEQUENCE  "ESBACH"."DCI_TXN_INFO_SEQ"  MINVALUE 1 MAXVALUE 9999999999999999999999999999 INCREMENT BY 1 START WITH 7011 CACHE 500 NOORDER  NOCYCLE ;
  
  
  CREATE OR REPLACE TRIGGER "ESBACH"."DCI_TXN_INFO_TRIG" 
   before INSERT
   ON esbach.DCI_TXN_INFO
   FOR EACH ROW
BEGIN
   
    SELECT DCI_TXN_INFO_SEQ.NEXTVAL INTO :NEW.DCI_TXN_INFO_ID FROM SYS.DUAL;
END;
/
ALTER TRIGGER "ESBACH"."DCI_TXN_INFO_TRIG" ENABLE;



commit