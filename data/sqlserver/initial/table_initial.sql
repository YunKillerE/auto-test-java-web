CREATE TABLE [tbl_order] (
	[id] varchar(50) NOT NULL PRIMARY KEY,
	[order_num] varchar(100) UNIQUE NOT NULL,
	[exam_date]	datetime NOT NULL,
	[name]	varchar(200) NOT NULL,
	[idcard] varchar(50) NOT NULL,
	[financename] varchar(255) NOT NULL,
	[department] varchar(255) DEFAULT NULL,
	[fee_type] varchar(50) NOT NULL,
	[owner] varchar(100) NOT NULL,
	[status] varchar(5) NOT NULL,
	[import_time] datetime NOT NULL,
	[operator] varchar(100) NOT NULL,
	[his_bm] varchar(20) DEFAULT NULL,
	[exam_company_code] varchar(20) NOT NULL,
	[exam_company_name] varchar(255) NOT NULL,
	[cancel_order_flags] varchar(5) DEFAULT NULL,
	[position] varchar(50) DEFAULT NULL ,
	[cancel_order_status] varchar(5) NOT NULL,
	[meal_name]	varchar(100) NOT NULL ,
	[meal_code]	varchar(100) DEFAULT NULL,
	[health_num] varchar(50) DEFAULT NULL,
	[is_retire]	varchar(50) DEFAULT NULL,
	[mobile] varchar(50) DEFAULT NULL,
	[health_level] varchar(50) DEFAULT NULL,
	[marriage_status] varchar(50) DEFAULT NULL,
	[his_tjkh] varchar(50) DEFAULT NULL,
	[order_money] numeric(9,2) NOT NULL,
	[online_pay_money] numeric(9,2) DEFAULT NULL,
	[offline_pay_money]	numeric(9,2) DEFAULT NULL,
	[sequence] varchar(50) DEFAULT NULL,
	[is_vip] varchar(5) NOT NULL,
	[workno] varchar(50) DEFAULT NULL,
	[has_paperreport] varchar(50) NOT NULL DEFAULT 1,
	[remark] varchar(2000) DEFAULT NULL,
	[gender] varchar(50),
	[age] varchar(50) NOT NULL,
	[birthday] datetime NOT NULL,
);

CREATE TABLE TBL_ORDER_ITEM (
	order_id varchar(50),
	item_code varchar(50),
	item_init_price numeric(9,2),
	item_discount numeric(9,2),
	item_type varchar(50)
);

CREATE TABLE [exam_company](
	[exam_company_name] varchar(255) NOT NULL,
	[exam_company_oldname] varchar(255) NULL,
	[his_exam_company_code] varchar(255) NULL,
	[mytijian_exam_company_code] varchar(255) NULL,
	[change_type] varchar(10) DEFAULT NULL,
	[is_complete] int DEFAULT NULL,
	[create_time] datetime NOT NULL,
	[update_time] datetime NOT NULL
);

CREATE TABLE [item_view](
	[item_name] varchar(255) UNIQUE NOT NULL,
	[item_code] varchar(255) UNIQUE NOT NULL,
	[gender] varchar(5)	NOT NULL,
	[price] numeric(9,2) NOT NULL,
	[is_discount] varchar(5) NOT NULL,
	[description] varchar(255) DEFAULT NULL
);

CREATE TABLE [meal_view](
	[meal_name]	varchar(255) UNIQUE NOT NULL,
	[meal_code]	varchar(255) UNIQUE NOT NULL
);

CREATE TABLE [dictionary_view](
	[dictionary_type] varchar(5) UNIQUE NOT NULL,
	[dictionary_name] varchar(255) UNIQUE NOT NULL,
	[dictionary_code] varchar(255) UNIQUE NOT NULL
);

CREATE TABLE [accomplish_order](
	[order_num] varchar(100) UNIQUE DEFAULT NULL,
	[status] varchar(5) DEFAULT NULL,
	[is_absent] varchar(5) NOT NULL,
	[name] varchar(200)	NOT NULL,
	[exam_date] datetime NOT NULL,
	[idcard] varchar(50) DEFAULT NULL,
	[mobile] varchar(50) DEFAULT NULL,
	[age] varchar(50) NOT NULL,
	[gender] varchar(50) NOT NULL,
	[marriage_status] varchar(50) DEFAULT NULL,
	[exam_company] varchar(255)	NOT NULL,
	[department] varchar(255) DEFAULT NULL,
	[workno] varchar(50) DEFAULT NULL,
	[offline_pay_amount] numeric(9,2) DEFAULT NULL
);

CREATE TABLE [accomplish_order_item](
	order_num varchar(100) DEFAULT NULL,
	item_code varchar(50)	NOT NULL,
	item_price numeric(9,2) NOT NULL,
	refuse_flag varchar(5) NOT NULL
);

CREATE TABLE report_state(
	report_id	varchar(100) NOT NULL PRIMARY KEY,
	[state]	varchar(5) DEFAULT NULL
);

CREATE TABLE report_baseinfo(
	report_id varchar(100) NOT NULL PRIMARY KEY,
	order_num varchar(50) UNIQUE DEFAULT NULL,
	name varchar(200)	NOT NULL,
	exam_date datetime DEFAULT NULL,
	idcard varchar(50) DEFAULT NULL,
	mobile varchar(50) DEFAULT NULL,
	gender varchar(50) NOT NULL,
	age varchar(50) NOT NULL,
	marriage_status varchar(50) DEFAULT NULL,
	exam_company varchar(255) DEFAULT NULL,
	department varchar(255) DEFAULT NULL,
	workno varchar(50) DEFAULT NULL	
);

CREATE TABLE report_summary(
	report_id varchar(100) NOT NULL PRIMARY KEY,
	doc_name varchar(200) NOT NULL,
	report_time datetime NOT NULL,
	audit_doc varchar(200) NOT NULL,
	audit_time datetime NOT NULL,
	detail varchar(5000) DEFAULT NULL,
	advice varchar(5000) DEFAULT NULL,
	attention varchar(5000) DEFAULT NULL
);

CREATE TABLE report_department(
	report_id	varchar(100) NOT NULL PRIMARY KEY,
	department_id varchar(50) NOT NULL,
	department varchar(50) NOT NULL,
	department_result varchar(1000) DEFAULT NULL,
	doc_name varchar(200) NOT NULL,
	exam_time datetime NOT NULL
);

CREATE TABLE report_detail(
	report_id	varchar(100) NOT NULL PRIMARY KEY,
	department_id varchar(50) NOT NULL,
	department varchar(50) NOT NULL,
	class_id varchar(50) DEFAULT NULL,
	class_name varchar(200) DEFAULT NULL,
	class_result varchar(1000) NOT NULL,
	item_id varchar(50) NOT NULL,
	item_name varchar(200) NOT NULL,
	item_result varchar(1000) NOT NULL,
	reference varchar(50) DEFAULT NULL,
	item_tip varchar(50) DEFAULT NULL,
	unit varchar(50) DEFAULT NULL,
	pic_url varchar(255) DEFAULT NULL	
);

CREATE TABLE EXAM_COMPANY_VIEW (
		exam_company_name varchar(255),
		exam_company_code varchar(255)
);
