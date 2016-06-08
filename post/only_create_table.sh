#!/bin/bash
#****************************************************************#
# ScriptName: only_create_table.sh
# Author: liujmsunits@hotmail.com
# Create Date: 2016-03-22 00:31
# Modify Author: liujmsunits@hotmail.com
# Modify Date: 2016-04-12 14:43
# Function: 
#***************************************************************#
echo "========================================07data_initial.sh start=========================================================="

#数据初始化，包括所以表的创建，所有初始数据的插入

#100：创建所有表sqlserver/oracle
function create_initial_table(){
	echo "开始创建表....."
	o_run$xtype "$TABLE_INITIAL"
	decide_exit "脚本：07data_initial.sh 位置：100 结果：successful！！！" "脚本：07data_initial.sh 位置：100 结果：\$TABLE_INITIAL 表创建失败！！！"
}

#101：创建所有视图
function create_initial_view(){
	echo "开始创建视图..."
	o_run$xtype "$VIEW_INITIAL"
	decide_exit "脚本：07data_initial.sh 位置：101 结果：successful！！！" "脚本：07data_initial.sh 位置：101 结果：\$VIEW_INITIAL 视图创建失败！！！"
}

#108：创建函数
function create_initial_function(){
	echo "开始创建函数..."
	o_run$xtype "$FUNCTION_INITIAL"
	decide_exit "脚本：07data_initial.sh 位置：108 结果：successful！！！" "脚本：07data_initial.sh 位置：108 结果：\$VIEW_INITIAL 视图创建失败！！！"
}


#102：创建所有存储过程
function create_initial_procedure(){
	echo "开始创建存储过程..."
	o_run$xtype "$PROCEDURE_SQL"
	decide_exit "脚本：07data_initial.sh 位置：102 结果：successful！！！" "脚本：07data_initial.sh 位置：102 结果：\$PROCEDURE_SQL 存储过程创建失败！！！"
}

#103：插入初始数据
function insert_initial_data(){
	echo "开始初始化数据...."
	o_run$xtype "$DATA_INITIAL"
	decide_exit "脚本：07data_initial.sh 位置：103 结果：successful！！！" "脚本：07data_initial.sh 位置:103 结果：\$DATA_INITIAL 数据初始化失败！！！"
}

#104：插入初始数据
function insert_initial_procedure(){
	echo "开始初始化存储过程..."
	o_run$xtype "$DATA_PROCEDURE_INITIAL"
    decide_exit "脚本：07data_initial.sh 位置：104 结果：successful！！！" "脚本：07data_initial.sh 位置:104 结果：\$DATA_PROCEDURE_INITIAL 存储过程初始化失败！！！"
}

#105：删除表
function delete_all_table(){
	echo "开始清理所以表..."
	o_run$xtype "$DELETE_ALL_TABLE"
	decide_exit "脚本：07data_initial.sh 位置：105 结果：successful！！！" "脚本：07data_initial.sh 位置:105 结果：\$DELETE_TABLE 表删除失败！！！"
}

#106：删除视图
function delete_all_view(){
	echo "开始清理所以视图..."
	o_run$xtype "$DELETE_ALL_VIEW"
	decide_exit "脚本：07data_initial.sh 位置：106 结果：successful！！！" "脚本：07data_initial.sh 位置:106 结果：\$DELETE_TABLE 视图删除失败！！！"
}

#107：删除存储过程
function delete_all_procedure(){
	echo "开始清理所有存储过程..."
	o_run$xtype "$DELETE_ALL_PROCEDURE"
	decide_exit "脚本：07data_initial.sh 位置：107 结果：successful！！！" "脚本：07data_initial.sh 位置:107 结果：\$DELETE_TABLE 存储过程删除失败！！！"

}

#109：删除函数
function delete_all_function(){
	echo "开始清理所有函数..."
	o_run$xtype "$DELETE_ALL_FUNCTION"
	decide_exit "脚本：07data_initial.sh 位置：109 结果：successful！！！" "脚本：07data_initial.sh 位置:109 结果：\$DELETE_TABLE 存储过程删除失败！！！"
}

source ./set_variable.sh
source ./set_begin.sh

if [ X$1 = Xclearall ];then
	delete_all_function
	delete_all_procedure
	delete_all_view
	delete_all_table
else
	#delete_all_function
	#delete_all_procedure
	#delete_all_view
	#delete_all_table
	echo -e "\033[41;33;1m 请先清理中间表中的所有表。。。\033[0m"
	echo ""
	echo "之所以手工清理表，是因为删除表很容易报错，一旦报错，此脚本就会退出导致无法新建表。。。"
	create_initial_table
	create_initial_view
	create_initial_function
	create_initial_procedure
	insert_initial_data
	echo ""
	echo -e "\033[41;33;1m 此时才启动tomcat \033[0m"
	echo -e "\033[41;33;1m 此时才启动tomcat \033[0m"
	echo -e "\033[41;33;1m 此时才启动tomcat \033[0m"
	echo ""
fi


echo "========================================07data_initial.sh end=========================================================="
echo ""
echo ""
