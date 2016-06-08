#!/bin/bash
#****************************************************************#
# ScriptName: 30company_sync.sh 
# Author: 云尘(jimmy)
# Create Date: 2016-03-16 17:48
# Modify Author: liujmsunits@hotmail.com
# Modify Date: 2016-04-18 20:19
# Function:
#***************************************************************#

echo -e "\033[41;33;1m ==================================30company_sync.sh start================================ \033[0m"
press_any_key

#单位同步
#1,我们同步到中间表
#	正常单位 
#	散客单位 1585 
#
#2,修改
#	修改正常单位
#	修改散客单位
#
#3,中间表同步到mysql
#	修改正常单位的名字和change_type 2 is_complete

#100：正常单位同步到中间表
function normal_company_sync_middletable(){
	#sql语句插入单位到mysql 	单位名称：完美世界 		单位id：888888
	o_runmysql "$TB_EXAM_COMPANY_ICOMPANY"
	decide_echo "脚本：30company_sync.sh 位置：100 结果：Sucessful!!!" "脚本：30company_sync.sh 位置：100 结果： $TB_EXAM_COMPANY_ICOMPANY 插入单位失败!"

	#sql语句插入单位到mongo中
	runmongo "$TB_EXAM_COMPANY_MONGO"
	decide_echo "脚本：30company_sync.sh 位置：100 结果：Sucessful!!!" "脚本：30company_sync.sh 位置：100 结果： $TB_EXAM_COMPANY_MONGO 插入单位到mongo失败!"

	#通过这个单位下一个单	先插入mysql	这里最好弄一个通用的sql，可以多次使用的
	#o_runmysql "$TB_EXAM_COMPANY_ORDER"
	#decide_echo "脚本：30company_sync.sh 位置：100 结果：Sucessful!!!" "脚本：30company_sync.sh 位置：100 结果： \$TB_EXAM_COMPANY_ORDER 插入单位订单到mysql失败!"
	sed -i "s/MYSQL_ORDER_NUM/$MYSQL_ORDER_NUM5/g" $TB_EXAM_COMPANY_ORDER $TB_EXAM_COMPANY_ORDER_MONGO
	create_order_mysql "$TB_EXAM_COMPANY_ORDER"
	create_order_mongo "$TB_EXAM_COMPANY_ORDER_MONGO"
	sed -i "s/$MYSQL_ORDER_NUM5/MYSQL_ORDER_NUM/g" $TB_EXAM_COMPANY_ORDER $TB_EXAM_COMPANY_ORDER_MONGO
	
	#通过这个单位下一个单   在插入mongo
	#runmongo "$TB_EXAM_COMPANY_ORDER_MONGO"
	#decide_echo "脚本：30company_sync.sh 位置：100 结果：Sucessful!!!" "脚本：30company_sync.sh 位置：100 结果： \$TB_EXAM_COMPANY_ORDER_MONGO 插入单位订单到mongo失败!"
	

	#检查单位是否同步到中间表中，通过company id（次id是固定值。插入时就已经固定，结束时记得删除这个单位）和中间表的mytijian_exam_company_code进行比较
	
	#查询出中间表中是否存在888888这个id的单位名称
	echo "sleep 10 to sync company..."
	sleep 10
	middle_company_NAME=`s_run$xtype "$EXAM_COMPANY_SELECTNAME"`
	if [ X$middle_company_NAME = X$NEW_COMPANY_NAME ];then
		echo "脚本：30company_sync.sh 位置：100 结果：Sucessful!!!"
	else
		echo "脚本：30company_sync.sh 位置：100 结果： $TB_EXAM_COMPANY_ORDER_MONGO 单位同步失败!"
	fi
}

#102：修改单位名称同步	单位名称修改为：天下无敌
function normal_company_modify_sync(){
	#修改mysql中的单位名称
	o_runmysql "$TB_EXAM_COMPANY_UPDATENAME"
	decide_echo "脚本：30company_sync.sh 位置：102 结果：Sucessful!!!" "脚本：30company_sync.sh 位置：102 结果： $TB_EXAM_COMPANY_UPDATENAME 单位名称修改失败!"


	#修改了mysql的单位名称同时需要修改mongo里面的名称
	runmongo "$TB_EXAM_COMPANY_UPDATENAME_MONGO"
	decide_echo "脚本：30company_sync.sh 位置：102 结果：Sucessful!!!" "脚本：30company_sync.sh 位置：102 结果： $TB_EXAM_COMPANY_UPDATENAME_MONGO 单位名称修改失败!"

	#需要下单才能同步，再用修改后的单位名称下单
	sed -i "s/MYSQL_ORDER_NUM/$MYSQL_ORDER_NUM6/g" $TB_EXAM_COMPANY_ORDER $TB_EXAM_COMPANY_ORDER_MONGO 
	sed -i "s/$COMPANY_ID/327691/g" $TB_EXAM_COMPANY_ORDER $TB_EXAM_COMPANY_ORDER_MONGO 
	create_order_mysql "$TB_EXAM_COMPANY_ORDER"
	create_order_mongo "$TB_EXAM_COMPANY_ORDER_MONGO"
	sed -i "s/$MYSQL_ORDER_NUM6/MYSQL_ORDER_NUM/g" $TB_EXAM_COMPANY_ORDER $TB_EXAM_COMPANY_ORDER_MONGO 
	sed -i "s/327691/$COMPANY_ID/g" $TB_EXAM_COMPANY_ORDER $TB_EXAM_COMPANY_ORDER_MONGO 
	
#	#通过这个单位下一个单	先插入mysql
#	o_runmysql "$TB_EXAM_MODIFYCOMPANY_ORDER"
#	decide_echo "脚本：30company_sync.sh 位置：102 结果：Sucessful!!!" "脚本：30company_sync.sh 位置：102 结果： \$TB_EXAM_COMPANY_ORDER 插入单位订单到mysql失败!"
#	
#	#通过这个单位下一个单   在插入mongo
#	runmongo "$TB_EXAM_MODIFYCOMPANY_ORDER_MONGO"
#	decide_echo "脚本：30company_sync.sh 位置：102 结果：Sucessful!!!" "脚本：30company_sync.sh 位置：102 结果： \$TB_EXAM_COMPANY_ORDER_MONGO 插入单位订单到mongo失败!"
	

	#等待30s看同步是否成功
	echo "sleep 10 to sync company..."
	sleep 10
	company_name=`s_run$xtype "$EXAM_COMPANY_SELECTNAME"`
	if [ X$company_name = X$UPDATE_COMPANY_NAME ];then
		echo "脚本：30company_sync.sh 位置：102 结果：Sucessful!!!"
	else
		echo "脚本：30company_sync.sh 位置：102 结果： $TB_EXAM_COMPANY_UPDATENAME 单位名称修改比较失败!"
	fi

}

#103：散客单位同步检查
function sanke_company_sync(){
	#散客单位只有一个id为1585，首次同步时会同步到中间表中，只需检查中间表是否有
	sanke_companyname=`s_run$xtype "$EXAM_COMPANY_SELECTSANKENAME"`
	if [ X"$sanke_companyname" = X'散客单位' ];then
		echo "脚本：30company_sync.sh 位置：103 结果：Sucessful!!!"
	else
		echo "脚本：30company_sync.sh 位置：103 结果： $sanke_companyname 散客单位同步失败失败!"
	fi
}


#104:修改散客单位名称	名称为：我是散客
function sanke_company_modify(){
	#修改散客单位名称mysql
	o_runmysql "$TB_EXAM_COMPANY_UPDATESANKENAME"
	decide_echo "脚本：30company_sync.sh 位置：104 结果：Sucessful!!!" "脚本：30company_sync.sh 位置：104 结果： $TB_EXAM_COMPANY_UPDATESANKENAME 散客单位名称修改失败!"

	#修改散客单位名称mongo
	o_runmysql "$TB_EXAM_COMPANY_UPDATESANKENAME_MONGO"
	decide_echo "脚本：30company_sync.sh 位置：104 结果：Sucessful!!!" "脚本：30company_sync.sh 位置：104 结果： $TB_EXAM_COMPANY_UPDATESANKENAME 散客单位名称修改失败!"

	#中间表中查询出散客单位名称进行比较
	sanke_companyname=`s_run$xtype "$EXAM_COMPANY_SELECTSANKENAME"`
	if [ X$sanke_companyname = X我是散客 ];then
		echo "脚本：30company_sync.sh 位置：104 结果：Sucessful!!!"
	else
		echo "脚本：30company_sync.sh 位置：104 结果： $sanke_companyname 散客单位名称修改同步失败!"
	fi
	#修改散客单位后需要下单测试是否能同步过去
	#需要下单才能同步，再用修改后的单位名称下单
	sed -i "s/MYSQL_ORDER_NUM/$MYSQL_ORDER_NUM7/g" $TB_ORDER_INSERTORDER $TB_ORDER_INSERTORDER_MONGO
	create_order_mysql "$TB_EXAM_COMPANY_ORDER"
	create_order_mongo "$TB_EXAM_COMPANY_ORDER_MONGO"
	sed -i "s/$MYSQL_ORDER_NUM7/MYSQL_ORDER_NUM/g" $TB_ORDER_INSERTORDER $TB_ORDER_INSERTORDER_MONGO


	update_sanke_companyname=`s_run$xtype "$EXAM_COMPANY_SELECTSANKENAME"`
	if [ X"$update_sanke_companyname" = X'散客单位' ];then
		echo "脚本：30company_sync.sh 位置：103 结果：Sucessful!!!"
	else
		echo "脚本：30company_sync.sh 位置：103 结果： $update_sanke_companyname 散客单位同步失败失败!"
	fi

}


#105：医院修改单位名称	修改单位名称为：我是医院
function middle_table_modify_companyname(){
	#中间表修改单位名称，并将type值改为2
	o_run$xtype "$EXAM_COMPANY_MODIFYNAME" 
	decide_echo "脚本：30company_sync.sh 位置：105 结果：Sucessful!!!" "脚本：30company_sync.sh 位置：105 $EXAM_COMPANY_MODIFYNAME 中间表单位名称修改失败!"

	#等待60s同步
	ehco "等待60s同步修改的单位名称..."
	sleep 60
	middle_modify_companyname=`s_runmysql $TB_EXAM_COMPANY_SELECTNAME`

	if [ X$middle_modify_companyname = X我是医院 ];then
		echo "脚本：30company_sync.sh 位置：105 结果：Sucessful!!!"
	else
		echo "脚本：30company_sync.sh 位置：105 $middle_modify_companyname 中间表单位名称修改同步失败!"
	fi
}

echo "moidify variable...."
modify_company_sqltemplate_start
press_any_key

normal_company_sync_middletable
press_any_key

normal_company_modify_sync
press_any_key

sanke_company_sync
press_any_key

sanke_company_modify
press_any_key

#middle_table_modify_companyname
#press_any_key

echo "restore variable..."
modify_company_sqltemplate_end


echo -e "\033[41;33;1m ==================================30company_sync.sh end================================ \033[0m"
echo ""
press_any_key
echo ""
