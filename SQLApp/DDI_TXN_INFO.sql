drop table "ESBACH"."DDI_TXN_INFO" 
  
CREATE TABLE "ESBACH"."DDI_TXN_INFO" 
   (	"DDI_TXN_INFO_ID" NUMBER NOT NULL ENABLE, 
	"DDI_GP_HDR_ID_TXN_FK" NUMBER, 
	"PMT_ID_INSTR_ID" VARCHAR2(35 CHAR), 
	"PMT_ID_ENDTOEND_ID" VARCHAR2(30 CHAR), 
	"PMT_ID_TXN_ID" VARCHAR2(16 CHAR), 
	"INTERBANK_SETTLE_AMNT" NUMBER(18,5), 
	"STLMT_PRITRY" VARCHAR2(40 CHAR), 
	"CHARGE_BEARER" VARCHAR2(10 CHAR) DEFAULT 'SLEV', 
	"INSTD_AGT_FIN_ID_BICFI" VARCHAR2(40 CHAR), 
	"INSTD_AGT_FIN_ID_CLR_SYS_MID" VARCHAR2(40 CHAR), 
	"INSTD_AGT_BNCHID_ID" VARCHAR2(35 CHAR), 
	"DBTR_NAME" VARCHAR2(140 CHAR), 
	"DBTR_ID_PRVTID_OTHR_ID" VARCHAR2(35 CHAR), 
	"DBTR_ID_PRVTID_OTHR_SCHNM_PRTY" VARCHAR2(35 CHAR), 
	"DBTRACCT_ID_IBAN" VARCHAR2(30 CHAR), 
	"DBTRACCT_ID_OTHR_ID" VARCHAR2(34 CHAR), 
	"DBTRAGNT_ID_FIN_ID_BICFI" VARCHAR2(40 CHAR), 
	"DBTRAGNT_ID_FIN_ID_CLR_SYS_MID" VARCHAR2(35 CHAR), 
	"DBTRAGNT_BNCHID_ID" VARCHAR2(35 CHAR), 
	"CDTR_NAME" VARCHAR2(140 CHAR), 
	"CDTR_ID_PRVTID_OTHR_ID" VARCHAR2(35 CHAR), 
	"CDTR_ID_PRVTID_OTHR_SCHNM_PRTY" VARCHAR2(35 CHAR), 
	"CDTRACCT_ID_IBAN" VARCHAR2(30 CHAR), 
	"CDTRACCT_ID_OTHR_ID" VARCHAR2(34 CHAR), 
	"CGTRAGT_FIN_ID_BICFI" VARCHAR2(40 CHAR), 
	"CGTRAGT_FIN_ID_CLR_SYS_MID" VARCHAR2(35 CHAR), 
	"CGTRAGT_BNCHID_ID" VARCHAR2(35 CHAR), 
	"PURP_PROPTYCHAR" VARCHAR2(35 CHAR), 
	"STATUS" VARCHAR2(35 CHAR), 
	"CBS_TRAN_REF" VARCHAR2(50 CHAR), 
	"DD_TXN_MNDTRLTDINF_MNDTID" VARCHAR2(20 CHAR), 
	"DD_TXN_MNDTRLTDINF_FSTCOLNDT" VARCHAR2(35 CHAR), 
	"CBS_PAY_REF" VARCHAR2(35 CHAR), 
	"EXEC_DESC" VARCHAR2(2000 CHAR), 
	"DESCRIPTION" VARCHAR2(2000 BYTE), 
	"MSG_ID" VARCHAR2(20 BYTE), 
	"FAULT_CODE" VARCHAR2(30 BYTE), 
	"FAULT_STRING" VARCHAR2(60 BYTE), 
	"CBS_REQUEST_MESSAGE" CLOB, 
	 PRIMARY KEY ("DDI_TXN_INFO_ID")
  USING INDEX PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1 BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "SYSTEM"  ENABLE, 
	 FOREIGN KEY ("DDI_GP_HDR_ID_TXN_FK")
	  REFERENCES "ESBACH"."DDI_GP_HEADER_INFO" ("DDI_GP_HEADER_ID") DISABLE
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

   CREATE SEQUENCE  "ESBACH"."DDI_TXN_INFO_SEQ"  MINVALUE 1 MAXVALUE 9999999999999999999999999999 INCREMENT BY 1 START WITH 8015 CACHE 500 NOORDER  NOCYCLE ;

  
  
  
  CREATE OR REPLACE TRIGGER "ESBACH"."DDI_TXN_INFO_TRIG" 
   before INSERT
   ON esbach.DDI_TXN_INFO
   FOR EACH ROW
BEGIN
   
   SELECT DDI_TXN_INFO_SEQ.NEXTVAL INTO :NEW.DDI_TXN_INFO_ID FROM SYS.DUAL;
END;
/
ALTER TRIGGER "ESBACH"."DDI_TXN_INFO_TRIG" ENABLE;



commit