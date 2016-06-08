#!/bin/bash
#****************************************************************#
# ScriptName: 00set_variable.sh 
# Author: 云尘(jimmy)
# Create Date: 2016-03-16 17:48
# Modify Author: liujmsunits@hotmail.com
# Modify Date: 2016-06-08 22:44
# Function:
#***************************************************************#
echo "====================================set_variable.sh start==========================="
spwd="$PWD/post"
datapath="$PWD/data"
sqlserver_path="$datapath/sqlserver"
oracle_path="$datapath/oracle"
mysql_path="$datapath/mysql"

#sqlserver or oracle
xtype="$xtype"

#mysql
mysql_address=192.168.3.179
mysql_user=root
mysql_passwd='xxxxxxxxxx'
mysql_database=medauto
#mongo
mongo_address=192.168.3.168
mongo_port=22333
mongo_user=root
mongo_passwd=xxx
mongo_database=order


#sqlserver/oracle file path
if [ X$xtype = Xsqlserver ];then
    	#sqlserver目录
	initialpath="$sqlserver_path/initial"
	orderpath="$sqlserver_path/order"
	itempath="$sqlserver_path/item"
	companypath="$sqlserver_path/company"
	reportpath="$sqlserver_path/report"

	#============================================表、视图、存储过程、函数清理=================

	#创建所有表视图
	TABLE_INITIAL="$initialpath/table_initial.sql"
	VIEW_INITIAL="$initialpath/view_initial.sql"
	#创建所有存储过程
	PROCEDURE_SQL="$initialpath/procedure_sql.sql"
	#插入初始数据
	DATA_INITIAL="$initialpath/data_initial.sql"
	#创建存储过程
	DATA_PROCEDURE_INITIAL="$initialpath/data_procedure_initial.sql"
	#创建函数
	FUNCTION_INITIAL="$initialpath/function_initial.sql"

	#=============================================数据初始化===========================

	#插入初始数据
	DATA_INITIAL="$initialpath/data_initial.sql"

	#==============================================表、视图、存储过程、函数清理===============

	#删除所有表
	DELETE_ALL_TABLE="$initialpath/delete_all_table.sql"
	#删除所有视图
	DELETE_ALL_VIEW="$initialpath/delete_all_view.sql"
	#删除所有存储过程
	DELETE_ALL_PROCEDURE="$initialpath/delete_all_procedure.sql"
	#删除所以函数
	DELETE_ALL_FUNCTION="$initialpath/delete_all_function.sql"

	#=============================================订单同步============================
	#未到检
	#查询订单中间表中是否有指定的ordernum
	TBL_ORDER_SELECT_ORDERNUM="$orderpath/tbl_order_select_ordernum.sql"
	#查询中间表中指定订单的单项个数
	TBL_ORDER_ITEM_SELECTITEMCOUNT="$orderpath/tbl_order_item_selectitemcount.sql"
	#未到检情况sql插入accomplish_order
	ACCOMPLISH_ORDER_INSERTNO="$orderpath/accomplish_order_insertno.sql"
	
	#所有已检
	ACCOMPLISH_ORDER_INSERTALL="$orderpath/accomplish_order_insertall.sql"
	
	#有未检项目
	ACCOMPLISH_ORDER_INSERTUN="$orderpath/accomplish_order_insertun.sql"
	
	#有拒检项目
	ACCOMPLISH_ORDER_INSERTREJECT="$orderpath/accomplish_order_insertreject.sql"
	
	#=============================================单项同步=================================

    #初始单项数据sql语句文件
    ITEM_VIEW="$itempath/item_view.sql" 
    #创建item_view的sql文件
    ITEM_VIEW_TABLE="$itempath/item_view_table.sql"
    #中间表中插入测试数据的sql文件
    INSERT_ITEM_VIEW="$itempath/insert_item_view.sql"
    #查询item_view中行数的sql文件
    #SELECT_ITEMVIEW_ROWS="$itempath/select_itemview_rows.sql"
    #修改item_view中单项名称sql文件
    ITEM_VIEW_UPDATE_NAME="$itempath/item_view_update_name.sql"
    #修改item_view中单项性别sql问
    ITEM_VIEW_UPDATE_GENDER="$itempath/item_view_update_gender.sql"
    #修改item_view中单项价格sql文件
    ITEM_VIEW_UPDATE_PRICE="$itempath/item_view_update_price.sql"
    #修改单项折扣sql文件
    ITEM_VIEW_UPDATE_DISCOUNT="$itempath/item_view_update_discount.sql"
	#删除单项
	DELETE_ITEMVIEW="$itempath/delete_itemview.sql"
	

	#=============================================单位同步==============================
	#在中间表中查询上面新建的单位是否同步过去
	EXAM_COMPANY_SELECTNAME="$companypath/exam_company_selectname.sql"
	#修改单位名称
	TB_EXAM_COMPANY_UPDATENAME="$companypath/tb_exam_company_updatename.sql"
	#在中间表中查询上面修改的单位名称是否同步过去
	#EXAM_CONPANY_SELECTNAME="exam_company_selectname.sql"
	#查询散客单位是否同步过去
	#EXAM_COMPANY_SELECTSANKENAME="$companypath/exam_company_selectsankename.sql"
	#在中间表中查询散客单位修改是否同步过去
	EXAM_COMPANY_SELECTSANKENAME="$companypath/exam_company_selectsankename.sql"
	#中间表修改单位名称
	EXAM_COMPANY_MODIFYNAME="$companypath/exam_company_modifyname.sql"



elif [ X$xtype = Xoracle ];then
    	#oracle目录
	initialpath="$oracle_path/initial"
	orderpath="$oracle_path/order"
	itempath="$oracle_path/item"
	companypath="$oracle_path/company"
	reportpath="$oracle_path/report"

else
	echo "pls input sqlserver/oracle!!"
	exit 1
fi




#mysql目录
	mysql_initialpath="$mysql_path/initial"	
	mysql_orderpath="$mysql_path/order"
	mysql_itempath="$mysql_path/item"
	mysql_companypath="$mysql_path/company"
	mysql_reportpath="$mysql_path/report"

#====================================================initial==========================
	#查询医院关于拒检项目是否退款的设置
	TB_HOSPITAL_SETTINGS_SELECTREFUSED="$mysql_initialpath/tb_hospital_settings_selectrefused.sql"


#====================================================order===========================
	#下单sql
	TB_ORDER_INSERTORDER="$mysql_orderpath/tb_order_insertorder.sql"
	#mongo下单sql
	TB_ORDER_INSERTORDER_MONGO="$mysql_orderpath/tb_order_insertorder_mongo.sql"
	TB_ORDER_INSERTORDER_MONGO_N="$mysql_orderpath/tb_order_insertorder_mongo_n.sql"

	#单纯下单sql
	TB_ORDER_INSERTORDER_ONLY="$mysql_orderpath/tb_order_insertorder_only.sql"

	#mongo中查询item string
	MONGO_ITEM_COUNTS="$mysql_orderpath/mongo_item_counts.sql"

	#未到检

	#查询tbl_order_refund_log是否生成日志，查询出结果检查一个字段是否为空
	TBL_ORDER_REFUND_LOG_SELECTID="$mysql_orderpath/tbl_order_refund_log_selectid.sql"
	#查询未到检的回单的订单状态
	TB_ORDER_SELECT_NOSTATUS="$mysql_orderpath/tb_order_select_nostatus.sql"
	#查询未到检情况tb_paymentrecord是否插入支付记录，并trade_tpe为3
	TB_PAYMENTRECORD_TRADETYPE="$mysql_orderpath/tb_paymentrecord_tradetype.sql"

	#所有项目体检完成
	TB_ORDER_SELECTSTATUS="$mysql_orderpath/tb_order_selectstatus.sql"
	
	#有未检项目
	#查询拒检/未检项目编号
	MYSQL_UNCHECK_NUM="$mysql_orderpath/mysql_uncheck_num.sql"
	#查询tb_paymentrecord未检/拒检项目金额
	TB_PAYMENTRECORD_AMOUNT="$mysql_orderpath/tb_paymentrecord_amount.sql"

	#删除所以中途插入的数据
	DELETE_ALL_INSERT_DATA=$mysql_orderpath/delete_all_insert_data.sql
	DELETE_ALL_INSERT_DATA_MONGO=$mysql_orderpath/delete_all_insert_data_mongo.sql
	

#====================================================item============================

	#查询itb_itemexam中单项行数的sql文件
	SELECT_ITEMVIEW_ROWS="$mysql_itempath/select_itemview_rows.sql"
	#查询tb_examitem表格中是否有插入的888888单项数据
	SELECT_TB_EXAMITEM="$mysql_itempath/select_tb_examitem.sql"
	#查询单项名称同步结果
	TB_EXAMITEM_SELECTNAME="$mysql_itempath/tb_examitem_selectname.sql"
	#查询单项性别同步结果
	TB_EXAMITEM_SELECTGENDER="$mysql_itempath/tb_examitem_selectgender.sql"
	#查询单项价格同步结果，以及change log写入结果
	TB_EXAMITEM_SELECTPRICE="$mysql_itempath/tb_examitem_selectprice.sql"
	TB_EXAMITEM_SELECTTYPE="$mysql_itempath/tb_examitem_selecttype.sql"
	#查询单项折扣同步结果以及change log写入结果
	TB_EXAMITEM_DISCOUNT="$mysql_itempath/tb_examitem_discount.sql"
	TB_EXAMITEM_SELECTTYPE="$mysql_itempath/tb_examitem_selecttype.sql"
	#查询删除单项同步结果，以及change log写入结果
	TB_EXAMITEM_TYPE="$mysql_itempath/tb_examitem_type.sql"
	#清理所有插入的单项
	CLEAR_ALL_ITEMVIEW="$mysql_itempath/clear_all_itemview.sql"


#====================================================company==========================
	#新建单位的sql语句
	TB_EXAM_COMPANY_ICOMPANY="$mysql_companypath/tb_exam_company_icompany.sql"
	#新建单位的mongo语句
	TB_EXAM_COMPANY_MONGO="$mysql_companypath/tb_exam_company_mongo.sql"
	#在上面的单位里面下一个单
	TB_EXAM_COMPANY_ORDER="$mysql_companypath/tb_exam_company_order.sql"
	#在上面的单位里面下一个单mongo
	TB_EXAM_COMPANY_ORDER_MONGO="$mysql_companypath/tb_exam_company_order_mongo.sql"
	#修改单位名称
	TB_EXAM_COMPANY_UPDATENAME="$mysql_companypath/tb_exam_company_updatename.sql"
	#修改单位名称mongo
	TB_EXAM_COMPANY_UPDATENAME_MONGO="$mysql_companypath/tb_exam_company_updatename_mongo.sql"
	#修改散客单位名称
	TB_EXAM_COMPANY_UPDATESANKENAME="$mysql_companypath/tb_exam_company_updatesankename.sql"
	#修改散客单位名称mongo
	TB_EXAM_COMPANY_UPDATESANKENAME_MONGO="$mysql_companypath/tb_exam_company_updatesankename_mongo.sql"
	#mysql中查询中间表中修改的单位名称是否同步过来
	TB_EXAM_COMPANY_SELECTNAME="$mysql_companypath/tb_exam_company_selectname.sql"
	#删除中途插入的数据
	COMPANY_DELETE_INSERT_DATA="$mysql_companypath/company_delete_insert_data.sql"


#====================================================report============================




echo "==================================================set_variable.sh end=================="
echo ""
