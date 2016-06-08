CREATE TABLE "tbl_order" (
	"id" VARCHAR2(50) NOT NULL PRIMARY KEY,
	"order_num" VARCHAR2(100) UNIQUE NOT NULL,
	"exam_date"	DATE DEFAULT SYSDATE NOT NULL,
	"name"	VARCHAR2(200) NOT NULL,
	"idcard" VARCHAR2(50) NOT NULL,
	"financename" VARCHAR2(255) NOT NULL,
	"department" VARCHAR2(255)  NULL,
	"fee_type" VARCHAR2(50) NOT NULL,
	"owner" VARCHAR2(100) NOT NULL,
	"status" VARCHAR2(5) NOT NULL,
	"import_time" DATE DEFAULT SYSDATE NOT NULL,
	"operator" VARCHAR2(100) NOT NULL,
	"his_bm" VARCHAR2(20)  NULL,
	"exam_company_code" VARCHAR2(20) NOT NULL,
	"exam_company_name" VARCHAR2(255) NOT NULL,
	"cancel_order_flags" VARCHAR2(5)  NULL,
	"position" VARCHAR2(50)  NULL ,
	"cancel_order_status" VARCHAR2(5) NOT NULL,
	"meal_name"	VARCHAR2(100) NOT NULL ,
	"meal_code"	VARCHAR2(100)  NULL,
	"health_num" VARCHAR2(50)  NULL,
	"is_retire"	VARCHAR2(50)  NULL,
	"mobile" VARCHAR2(50)  NULL,
	"health_level" VARCHAR2(50)  NULL,
	"marriage_status" VARCHAR2(50)  NULL,
	"his_tjkh" VARCHAR2(50)  NULL,
	"order_money" number(9,2) NOT NULL,
	"online_pay_money" number(9,2) NULL,
	"offline_pay_money"	number(9,2) NULL,
	"sequence" VARCHAR2(50) NULL,
	"is_vip" VARCHAR2(5) NOT NULL,
	"workno" VARCHAR2(50)  NULL,
	"has_paperreport" VARCHAR2(50) DEFAULT 1 NOT NULL,
	"remark" VARCHAR2(2000)  NULL
)
;

CREATE TABLE "tbl_order_item" (
	"order_id" VARCHAR2(50) NOT NULL PRIMARY KEY,
	"item_code"	VARCHAR2(50) NOT NULL,
	"item_init_price" number(9,2) NOT NULL,
	"item_discount"	number(9,2) NOT NULL,
	"item_discount_price" number(9,2) NOT NULL,
	"item_type"	VARCHAR2(50) NOT NULL
)
;

CREATE TABLE "exam_company"(
	"exam_company_name" VARCHAR2(255) UNIQUE NOT NULL,
	"exam_company_oldname" VARCHAR2(255) UNIQUE NULL,
	"his_exam_company_code" VARCHAR2(255) UNIQUE NOT NULL,
	"mytijian_exam_company_code" VARCHAR2(255) UNIQUE NULL,
	"change_type" VARCHAR2(10) UNIQUE NULL,
	"is_complete" int NULL,
	"create_time" DATE DEFAULT SYSDATE	NOT NULL,
	"update_time" DATE DEFAULT SYSDATE	NOT NULL
)
;

CREATE VIEW "tbl_order_view" as
select
        o."id",
		o."order_num",
		o."exam_date",
		o."name",
		o."idcard",
		o."financename",
		o."department",
		o."fee_type",
        o."owner",
		o."status",
		o."import_time",
		o."operator",
		o."his_bm",
		c."his_exam_company_code",
        o."cancel_order_flags",
		o."position",
		o."cancel_order_status",
		o."meal_name",
		o."meal_code",
        o."health_num",
		o."is_retire",
		o."mobile",
		o."health_level",
		o."marriage_status",
		o."his_tjkh",
        o."order_money",
		o."online_pay_money",
		o."offline_pay_money",
		o."sequence",
		o."is_vip",
        o."workno",
		o."has_paperreport",
		"remark"
from "tbl_order" o left join "exam_company" c
on
        c."mytijian_exam_company_code" = o."exam_company_code"
        and c."exam_company_name" = o."exam_company_name"
;
CREATE TABLE "item_view" (
	"item_name" VARCHAR2(255) UNIQUE NOT NULL,
	"item_code" VARCHAR2(255) UNIQUE NOT NULL,
	"gender" VARCHAR2(5) NOT NULL,
	"price" number(9,2) NOT NULL,
	"is_discount" VARCHAR2(5) NOT NULL,
	"description" VARCHAR2(255)  NULL
)
;

CREATE TABLE "meal_view"(
	"meal_name"	VARCHAR2(255) UNIQUE NOT NULL,
	"meal_code"	VARCHAR2(255) UNIQUE NOT NULL
)
;

CREATE TABLE "dictionary_view"(
	"dictionary_type" VARCHAR2(5) UNIQUE NOT NULL,
	"dictionary_name" VARCHAR2(255) UNIQUE NOT NULL,
	"dictionary_code" VARCHAR2(255)UNIQUE NOT NULL
)
;

CREATE TABLE "accomplish_order"(
	"order_num" VARCHAR2(100) UNIQUE NULL,
	"status" VARCHAR2(5) NULL,
	"is_absent" VARCHAR2(5) NOT NULL,
	"name" VARCHAR2(200) NOT NULL,
	"exam_date" DATE DEFAULT SYSDATE NOT NULL,
	"idcard" VARCHAR2(50) NULL,
	"mobile" VARCHAR2(50) NULL,
	"age" VARCHAR2(50) NOT NULL,
	"gender" VARCHAR2(50) NOT NULL,
	"marriage_status" VARCHAR2(50) NULL,
	"exam_company" VARCHAR2(255) NOT NULL,
	"department" VARCHAR2(255) NULL,
	"workno" VARCHAR2(50) NULL,
	"offline_pay_amount" number(9,2) NULL
)
;

CREATE TABLE "accomplish_order_item"(
	"order_num" VARCHAR2(100) UNIQUE NULL,
	"item_code" VARCHAR2(50) NOT NULL,
	"item_price" number(9,2) NOT NULL,
	"refuse_flag" VARCHAR2(5) NOT NULL
)
;


CREATE TABLE "report_state"(
	"report_id"	VARCHAR2(100) NOT NULL PRIMARY KEY,
	"state"	VARCHAR2(5) NULL
)
;


CREATE TABLE "report_baseinfo"(
	"report_id" VARCHAR2(100) NOT NULL PRIMARY KEY,
	"order_num" VARCHAR2(50) UNIQUE NULL,
	"name" VARCHAR2(200) NOT NULL,
	"exam_date" DATE DEFAULT SYSDATE NULL,
	"idcard" VARCHAR2(50) NULL,
	"mobile" VARCHAR2(50) NULL,
	"gender" VARCHAR2(50) NOT NULL,
	"age" VARCHAR2(50) NOT NULL,
	"marriage_status" VARCHAR2(50) NULL,
	"exam_company" VARCHAR2(255) NULL,
	"department" VARCHAR2(255) NULL,
	"workno" VARCHAR2(50) NULL	
)
;

CREATE TABLE "report_summary"(
	"report_id" VARCHAR2(100) NOT NULL PRIMARY KEY,
	"doc_name" VARCHAR2(200) NOT NULL,
	"report_time" DATE DEFAULT SYSDATE NOT NULL,
	"audit_doc" VARCHAR2(200) NOT NULL,
	"audit_time" DATE DEFAULT SYSDATE NOT NULL,
	"detail" VARCHAR2(4000) NULL,
	"advice" VARCHAR2(4000) NULL,
	"attention" VARCHAR2(4000) NULL
)
;

CREATE TABLE "report_department"(
	"report_id"	VARCHAR2(100) NOT NULL PRIMARY KEY,
	"department_id" VARCHAR2(50) NOT NULL,
	"department" VARCHAR2(50) NOT NULL,
	"department_result" VARCHAR2(1000)  NULL,
	"doc_name" VARCHAR2(200) NOT NULL,
	"exam_time" DATE DEFAULT SYSDATE NOT NULL
)
;

CREATE TABLE "report_detail"(
	"report_id"	VARCHAR2(100) NOT NULL PRIMARY KEY,
	"department_id" VARCHAR2(50) NOT NULL,
	"department" VARCHAR2(50) NOT NULL,
	"class_id" VARCHAR2(50)  NULL,
	"class_name" VARCHAR2(200)  NULL,
	"class_result" VARCHAR2(1000) NOT NULL,
	"item_id" VARCHAR2(50) NOT NULL,
	"item_name" VARCHAR2(200) NOT NULL,
	"item_result" VARCHAR2(1000) NOT NULL,
	"reference" VARCHAR2(50)  NULL,
	"item_tip" VARCHAR2(50)  NULL,
	"unit" VARCHAR2(50)  NULL,
	"pic_url" VARCHAR2(255)  NULL	
)
;
