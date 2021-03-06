

drop table "ESBACH"."DDI_GP_HEADER_INFO" 

  CREATE TABLE "ESBACH"."DDI_GP_HEADER_INFO" 
   (	"DDI_GP_HEADER_ID" NUMBER NOT NULL ENABLE, 
	"MSG_ID" VARCHAR2(16 CHAR), 
	"CREATION_DATETIME" TIMESTAMP (6), 
	"NO_OF_TXNS" NUMBER(*,0), 
	"TOTAL_INTRBANK_SETTLE_AMT" BINARY_DOUBLE, 
	"INTERBANK_SETTLE_DATE" DATE, 
	"SETTLE_INFO_METHOD" VARCHAR2(10 CHAR) DEFAULT 'CLRG' NOT NULL ENABLE, 
	"SETTLE_INFO_CLR_SYS_PRTRY" VARCHAR2(10 CHAR) DEFAULT 'CBO' NOT NULL ENABLE, 
	"PMT_TP_INF_LCL_INST_CODE" VARCHAR2(40 CHAR), 
	"PMT_TP_INF_CTGY_PURP_PRTRY" VARCHAR2(35 CHAR), 
	"INSTG_AGT_FIN_ID_BICFI" VARCHAR2(40 CHAR), 
	"INSTG_AGT_FIN_ID_CLR_SYS_MMBID" VARCHAR2(35 CHAR), 
	"INSTG_AGT_BRNCHID_ID" VARCHAR2(35 CHAR), 
	"INSTD_AGT_FIN_ID_BICFI" VARCHAR2(40 CHAR), 
	"INSTD_AGT_FIN_ID_CLR_SYS_MMBID" VARCHAR2(40 CHAR), 
	"INSTD_AGT_BRNCHID_ID" VARCHAR2(35 CHAR), 
	"SRC_MSG" CLOB, 
	 PRIMARY KEY ("DDI_GP_HEADER_ID")
  USING INDEX PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1 BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "SYSTEM"  ENABLE
   ) SEGMENT CREATION IMMEDIATE 
  PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255 NOCOMPRESS LOGGING
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1 BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "SYSTEM" 
 LOB ("SRC_MSG") STORE AS BASICFILE (
  TABLESPACE "SYSTEM" ENABLE STORAGE IN ROW CHUNK 8192 RETENTION 
  NOCACHE LOGGING 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1 BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)) ;

  
   
   
   
   CREATE SEQUENCE  "ESBACH"."DDI_GP_HEADER_INFO_SEQ"  MINVALUE 1 MAXVALUE 9999999999999999999999999999 INCREMENT BY 1 START WITH 8011 CACHE 500 NOORDER  NOCYCLE ;


  
  
  
  CREATE OR REPLACE TRIGGER "ESBACH"."DDI_GP_HEADER_INFO_TRIG" 
   before INSERT
   ON esbach.DDI_GP_HEADER_INFO
   FOR EACH ROW
BEGIN
    
   SELECT DDI_GP_HEADER_INFO_SEQ.NEXTVAL INTO :NEW.DDI_GP_HEADER_ID FROM SYS.DUAL;
END;
commit
/
ALTER TRIGGER "ESBACH"."DDI_GP_HEADER_INFO_TRIG" ENABLE;
