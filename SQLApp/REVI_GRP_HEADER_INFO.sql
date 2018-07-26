

drop table "ESBACH"."REVI_GRP_HEADER_INFO"

  CREATE TABLE "ESBACH"."REVI_GRP_HEADER_INFO" 
   (	"REV_GRP_HEADER_ID" NUMBER NOT NULL ENABLE, 
	"MSG_ID" VARCHAR2(16 CHAR), 
	"CREATION_DATETIME" VARCHAR2(30 BYTE), 
	"NO_OF_TXNS" NUMBER(*,0), 
	"TOTAL_INTRBANK_SETTLE_AMT" NUMBER(18,5), 
	"INTERBANK_SETTLE_DATE" CHAR(20 BYTE), 
	"SETTLE_INFO_METHOD" VARCHAR2(35 CHAR) DEFAULT 'CLRG' NOT NULL ENABLE, 
	"SETTLE_INFO_CLR_SYS_PRTRY" VARCHAR2(35 CHAR) DEFAULT 'CBO' NOT NULL ENABLE, 
	"INSTG_AGT_FIN_ID_BICFI" VARCHAR2(20 CHAR), 
	"INSTG_AGT_FIN_ID_CLR_SYS_MMBID" VARCHAR2(35 CHAR), 
	"INSTG_AGT_BRNCHID_ID" VARCHAR2(35 CHAR), 
	"INSTD_AGT_FIN_ID_BICFI" VARCHAR2(20 CHAR), 
	"INSTD_AGT_FIN_ID_CLR_SYS_MMBID" VARCHAR2(35 CHAR), 
	"INSTD_AGT_BRNCHID_ID" VARCHAR2(35 CHAR), 
	"SOURCE_SYS_CODE" VARCHAR2(20 CHAR), 
	"SOURCE_SYS_ID" VARCHAR2(20 CHAR), 
	"INTERFACE_CODE" VARCHAR2(20 CHAR), 
	"SOURCE_SYS_TIMESTAMP" TIMESTAMP (6), 
	 PRIMARY KEY ("REV_GRP_HEADER_ID")
  USING INDEX PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1 BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "SYSTEM"  ENABLE
   ) SEGMENT CREATION IMMEDIATE 
  PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255 NOCOMPRESS LOGGING
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1 BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "SYSTEM" ;
  
  
  
   CREATE SEQUENCE  "ESBACH"."REVI_GRP_HEADER_INFO_SEQ"  MINVALUE 1 MAXVALUE 9999999999999999999999999999 INCREMENT BY 1 START WITH 6508 CACHE 500 NOORDER  NOCYCLE ;


  CREATE OR REPLACE TRIGGER "ESBACH"."REVI_GRP_HEADER_INFO_TRIG" 
   before INSERT
   ON esbach.REVI_GRP_HEADER_INFO
   FOR EACH ROW
BEGIN
    
   
    SELECT REVI_GRP_HEADER_INFO_SEQ.NEXTVAL INTO :NEW.REV_GRP_HEADER_ID FROM SYS.DUAL;
END;
/
ALTER TRIGGER "ESBACH"."REVI_GRP_HEADER_INFO_TRIG" ENABLE;

commit