
drop table "ESBACH"."WPS_SIF_RECORD_INFO" 

  CREATE TABLE "ESBACH"."WPS_SIF_RECORD_INFO" 
   (	"WPS_SIF_RECORD_INFO_ID" NUMBER NOT NULL ENABLE, 
	"SIF_FILE_NAME" VARCHAR2(200 CHAR) NOT NULL ENABLE, 
	"EMPLOYEE_ID_TYPE" VARCHAR2(20 CHAR), 
	"EMPLOYEE_ID" VARCHAR2(20 CHAR), 
	"EMPLOYEE_NAME" VARCHAR2(70 CHAR), 
	"EMPLOYEE_BANK_CODE" VARCHAR2(10 CHAR), 
	"EMPLOYEE_ACC_NO" VARCHAR2(30 CHAR), 
	"SALARY_FREQUENCY" VARCHAR2(1 CHAR), 
	"NO_OF_WORKING_DAYS" VARCHAR2(10 CHAR), 
	"NET_SALARY" VARCHAR2(30 CHAR), 
	"BASIC_SALARY" VARCHAR2(30 CHAR), 
	"EXTRA_HOURS" VARCHAR2(10 CHAR), 
	"EXTRA_INCOME" VARCHAR2(30 CHAR), 
	"DEDUCTIONS" VARCHAR2(30 CHAR), 
	"SOCIAL_SECURITY_DEDUCTIONS" VARCHAR2(30 CHAR), 
	"NOTES_COMMENTS" VARCHAR2(300 CHAR), 
	"RECORD_ID" VARCHAR2(400 CHAR), 
	"DUPLICATE" VARCHAR2(20 CHAR), 
	"STATUS" VARCHAR2(100 CHAR), 
	"EXEC_DESC" VARCHAR2(4000 CHAR), 
	"TXN_REF_ID" VARCHAR2(30 CHAR), 
	"WPS_SIF_HEADER_INFO_ID" NUMBER NOT NULL ENABLE, 
	"ACCOUNT_STATUS" VARCHAR2(20 CHAR), 
	"CBS_PAY_REF" VARCHAR2(20 BYTE), 
	"REFERENCE_NUMBER" VARCHAR2(35 CHAR), 
	"CBS_FAULT_CODE" VARCHAR2(40 BYTE), 
	"CBS_FAULT_STRING" VARCHAR2(100 BYTE), 
	"CHL_REFERENCE" VARCHAR2(30 BYTE), 
	"CBS_REQUEST_MESSAGE" CLOB, 
	 PRIMARY KEY ("WPS_SIF_RECORD_INFO_ID")
  USING INDEX PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1 BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "SYSTEM"  ENABLE, 
	 FOREIGN KEY ("WPS_SIF_HEADER_INFO_ID")
	  REFERENCES "ESBACH"."WPS_SIF_HEADER_INFO" ("WPS_SIF_HEADER_INFO_ID") ENABLE
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

  CREATE SEQUENCE  "ESBACH"."WPS_SIF_RECORD_INFO_SEQ"  MINVALUE 1 MAXVALUE 9999999999999999999999999999 INCREMENT BY 1 START WITH 364 CACHE 20 NOORDER  NOCYCLE ;
  
  
  CREATE OR REPLACE TRIGGER "ESBACH"."WPS_SIF_RECORD_INFO_TRIG" 
   before INSERT
   ON esbach.WPS_SIF_RECORD_INFO
   FOR EACH ROW
BEGIN
   SELECT WPS_SIF_RECORD_INFO_SEQ.NEXTVAL INTO :NEW.WPS_SIF_RECORD_INFO_ID FROM SYS.DUAL;
END;
/
ALTER TRIGGER "ESBACH"."WPS_SIF_RECORD_INFO_TRIG" ENABLE;


commit