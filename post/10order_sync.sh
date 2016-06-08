#!/bin/bash
#****************************************************************#
# ScriptName: 10order_sync.sh 
# Author: 云尘(jimmy)
# Create Date: 2016-03-16 17:48
# Modify Author: liujmsunits@hotmail.com
# Modify Date: 2016-04-18 15:56
# Function:
#***************************************************************#
sleep 10

echo -e "\033[41;33;1m ==================================10order_sync.sh start================================ \033[0m"
press_any_key
#订单同步，
#1，下单：通过sql生成订单，插入mysql数据库以及mongodb的sql语句,共插入三个订单
#2，同步：取得订单的order_num，等待1分钟，在sqlserver/oracle中查询是否有这个订单，比对三个订单号，是否需要判断其他字段还是只需要判断订单号？
#这里是否需要判断能否导入his系统？怎么查询sqlserver/oracle中的订单？
#3，回单：修改相应字段模拟正常订单、有拒检项目订单、有未检项目订单、加项订单的回单，修改哪些字段？然后在mysql数据库中查询是否有相应的回单



##100：sql下单，下单的前提条件需要先检查，否则可能会导致下单不成功
#function create_order_mysql(){
#	#o_runmysql "$TB_ORDER_INSERTORDER"
#	o_runmysql "$1"
#	decide_echo "脚本：10order_sync.sh 位置：100 结果：Sucessful!!!" "脚本：10order_sync.sh 位置：100 结果： \$TB_ORDER_INSERTORDER mysql下单失败!!"
#}
#
##101：mongo下单
#function create_order_mongo(){
#	#runmongo "$TB_ORDER_INSERTORDER_MONGO"
#	runmongo "$1"
#	decide_echo "脚本：10order_sync.sh 位置：101 结果：Sucessful!!!" "脚本：10order_sync.sh 位置：101 结果： \$TB_ORDER_INSERTORDER_MONGO mongo下单失败!!"
#}

#102：中间表中检查订单是否同步过去
#tbl_order中查询order_num是否有指定num
#tbl_order_item中查询单项个数
function select_tbl_order_ordernum(){
	echo "等待10s订单同步..."
	sleep 10s

	middle_order_num=`o_run$xtype "$TBL_ORDER_SELECT_ORDERNUM"`

	if [ -n $middle_order_num ];then
		echo "脚本：10order_sync.sh 位置：102 结果：Sucessful!!!"
	else
		echo "脚本：10order_sync.sh 位置：102 结果： $TBL_ORDER_SELECT_ORDERNUM 订单同步失败!!"
	fi
}

#103：tbl_order_item中查询单项个数
function select_tbl_order_item_counts(){
	#查询出mongo中的单项个数
	mongo_item_counts=`runmongo $MONGO_ITEM_COUNTS`
	mongo_item_counts_tmp=`echo $mongo_item_counts | tr -cd ':' | wc -c`

	#查询出中间表的单项个数,通过tbl_order中的id查询出tbl_order_item中单项个数
	middle_item_counts=`s_run$xtype "$TBL_ORDER_ITEM_SELECTITEMCOUNT"`

	if [ X$mongo_item_counts_tmp = X$middle_item_counts ];then
		echo 脚本：10order_sync.sh 位置：103 结果：Sucessful!!!
	else
		echo "脚本：10order_sync.sh 位置：102 结果： $TBL_ORDER_ITEM_SELECTITEMCOUNT 单项个数比对失败!!"
	fi
}


#如果上面都失败了的话。下面的回单就没必要做了，没有意义


#104：模拟未到检情况，is_absent 1
function huidan_no_check(){
	#在accomplish_order中插入一条数据，表示未到检
	o_run$xtype "$ACCOMPLISH_ORDER_INSERTNO"
	decide_echo "脚本：10order_sync.sh 位置：104-1 结果：Sucessful!!!" "脚本：10order_sync.sh 位置：104-1 结果： $ACCOMPLISH_ORDER_INSERT 改变订单状态失败!!"

	echo "等待10s进行同步..."
	sleep 10s

	#查询tbl_order_refund_log是否生成日志，查询出结果检查一个字段是否为空
	#accomplish_order必须为试图
	tb_order_refund_log=`s_runmysql "$TBL_ORDER_REFUND_LOG_SELECTID"`

	if [ -n $tbl_order_refund_log ];then
		echo "脚本：10order_sync.sh 位置：104-2 结果：Sucessful!!!"
	else
		echo "脚本：10order_sync.sh 位置：104-2 结果： $TBL_ORDER_REFUND_LOG_SELECTID 插入数据失败!!"
	fi

	#查询tb_order中status值是否变为5,表示已撤单
	tb_order_status=`s_runmysql "$TB_ORDER_SELECTSTATUS"`

	if [ X$tb_order_status = X5 ];then
		echo "脚本：10order_sync.sh 位置：104-3 结果：Sucessful!!!"
	else
		echo "脚本：10order_sync.sh 位置：104-3 结果： $TB_ORDER_SELECTSTATUS 插入数据失败!!"
	fi

	#查询tb_paymentrecord是否插入支付记录，并trade_tpe为3
	#下单是需要有支付记录，否则部分回单会有问题，数据会不对
	tb_paymentrecord_tradetpe=`s_runmysql $TB_PAYMENTRECORD_TRADETYPE`

	if [ X$tb_paymentrecord_tradetpe = X3 ];then
		echo "脚本：10order_sync.sh 位置：104-4 结果：Sucessful!!!"
	else
		echo "脚本：10order_sync.sh 位置：104-4 结果： $TB_PAYMENTRECORD_TRADETYPE 插入数据失败!!"
	fi
}


#105：所有项目都体检完成 is_absent 0

function huidan_all_check(){
	#在accomplish_order中插入一条数据，表示未到检
	o_run$xtype "$ACCOMPLISH_ORDER_INSERTALL"
	decide_echo "脚本：10order_sync.sh 位置：105-1 结果：Sucessful!!!" "脚本：10order_sync.sh 位置：105-1 结果： $ACCOMPLISH_ORDER_INSERTALL 改变订单状态失败!!"

	echo "等待10s进行同步..."
	sleep 10s

	#查询tbl_order_refund_log是否生成日志，查询出结果检查一个字段是否为空
	tb_order_refund_log=`s_runmysql "$TBL_ORDER_REFUND_LOG_SELECTID"`

	if [ -n $tbl_order_refund_log ];then
		echo "脚本：10order_sync.sh 位置：105-2 结果：Sucessful!!!"
	else
		echo "脚本：10order_sync.sh 位置：105-2 结果： $TBL_ORDER_REFUND_LOG_SELECTID 插入数据失败!!"
	fi

	#查询tb_order中status值是否变为3,表示已完成
	tb_order_status=`s_runmysql "$TB_ORDER_SELECTSTATUS"`

	if [ X$tb_order_status = X3 ];then
		echo "脚本：10order_sync.sh 位置：105-3 结果：Sucessful!!!"
	else
		echo "脚本：10order_sync.sh 位置：105-3 结果： $TB_ORDER_SELECTSTATUS 插入数据失败!!"
	fi
}


#106：有未检项目is_absent 0
function huidan_un_check(){
	#在accomplish_order中插入一条数据，表示未到检
	o_run$xtype "$ACCOMPLISH_ORDER_INSERTUN"
	decide_echo "脚本：10order_sync.sh 位置：106-1 结果：Sucessful!!!" "脚本：10order_sync.sh 位置：106-1 结果： $ACCOMPLISH_ORDER_INSERTUN 改变订单状态失败!!"

	echo "等待10s进行同步..."
	sleep 10s

	#查询tbl_order_refund_log是否生成日志，查询出结果检查一个字段是否为空
	tb_order_refund_log=`s_runmysql "$TBL_ORDER_REFUND_LOG_SELECTID"`

	if [ -n $tbl_order_refund_log ];then
		echo "脚本：10order_sync.sh 位置：106-2 结果：Sucessful!!!"
	else
		echo "脚本：10order_sync.sh 位置：106-2 结果： $TBL_ORDER_REFUND_LOG_SELECTID 插入数据失败!!"
	fi

	#查询tb_order中status值是否变为9,表示有未检项目
	tb_order_status=`s_runmysql "$TB_ORDER_SELECTSTATUS"`

	if [ X$tb_order_status = X9 ];then
		echo "脚本：10order_sync.sh 位置：106-3 结果：Sucessful!!!"
	else
		echo "脚本：10order_sync.sh 位置：106-3 结果： $TB_ORDER_SELECTSTATUS 插入数据失败!!"
	fi

	#查询tb_paymentrecord是否插入支付记录，并amount为未检项目金额，金额需先固定
	#mysql_uncheck_num="$MYSQL_UNCHECK_NUM"
	tb_paymentrecord_tradetpe=`s_runmysql $TB_PAYMENTRECORD_AMOUNT`

	if [ X$tb_paymentrecord_tradetpe = X$UNCHECK_ITEM_PRICE ];then
		echo "脚本：10order_sync.sh 位置：106-4 结果：Sucessful!!!"
	else
		echo "脚本：10order_sync.sh 位置：106-4 结果： $TB_PAYMENTRECORD_AMOUNT 插入数据失败!!"
	fi
}


#107：有拒检项目is_absent 0
function huidan_reject_check(){
	#在accomplish_order中插入一条数据，表示未到检
	o_run$xtype "$ACCOMPLISH_ORDER_INSERTREJECT"
	decide_echo "脚本：10order_sync.sh 位置：107-1 结果：Sucessful!!!" "脚本：10order_sync.sh 位置：107-1 结果： $ACCOMPLISH_ORDER_INSERTREJECT 改变订单状态失败!!"

	echo "等待10s进行同步..."
	sleep 10s

	#查询tbl_order_refund_log是否生成日志，查询出结果检查一个字段是否为空
	tb_order_refund_log=`s_runmysql "$TBL_ORDER_REFUND_LOG_SELECTID"`

	if [ -n $tbl_order_refund_log ];then
		echo "脚本：10order_sync.sh 位置：107-2 结果：Sucessful!!!"
	else
		echo "脚本：10order_sync.sh 位置：107-2 结果： \$tbl_order_refund_log 插入数据失败!!"
	fi

#	#查询tb_order中status值是否变为9,表示有拒检项目
#	tb_order_status=`s_runmysql "$TB_ORDER_SELECTSTATUS"`
#
#	if [ X$tb_order_status = X9 ];then
#		echo "脚本：10order_sync.sh 位置：107-3 结果：Sucessful!!!"
#	else
#		echo "脚本：10order_sync.sh 位置：107-3 结果： \$tb_order_status 插入数据失败!!"
#	fi
	
	#这里先要查询出tb_hospital_settings.refund_refused_item值为多少，1退款，0不退
	#如果为1查询tb_paymentrecord是否插入支付记录，并amount为未检项目金额，金额需先固定
	refund_refused_item=`s_runmysql $TB_HOSPITAL_SETTINGS_SELECTREFUSED`

	if [ X$refund_refused_item = X1 ];then
		#mysql_uncheck_num="$MYSQL_UNCHECK_NUM"
		tb_paymentrecord_tradetpe=`s_runmysql $TB_PAYMENTRECORD_AMOUNT`

		if [ X$tb_paymentrecord_tradetpe = X$UNCHECK_ITEM_PRICE ];then
			echo "脚本：10order_sync.sh 位置：107-4 结果：Sucessful!!!"
		else
			echo "脚本：10order_sync.sh 位置：107-4 结果： $TB_PAYMENTRECORD_AMOUNT 插入数据失败!!"
		fi

		#查询tb_order中status值是否变为9,表示有拒检项目
		tb_order_status=`s_runmysql "$TB_ORDER_SELECTSTATUS"`

		if [ X$tb_order_status = X9 ];then
			echo "脚本：10order_sync.sh 位置：107-3 结果：Sucessful!!!"
		else
			echo "脚本：10order_sync.sh 位置：107-3 结果： $TB_ORDER_SELECTSTATUS 插入数据失败!!"
		fi

	else
		#查询tb_order中status值是否变为9,表示有拒检项目
		tb_order_status=`s_runmysql "$TB_ORDER_SELECTSTATUS"`

		if [ X$tb_order_status = X9 ];then
			echo "脚本：10order_sync.sh 位置：107-3 结果：Sucessful!!!"
		else
			echo "脚本：10order_sync.sh 位置：107-3 结果： $TB_ORDER_SELECTSTATUS 插入数据失败!!"
		fi

	fi
}

function order_one(){
echo "==================================order1======================================"
#第一个单子测试	未到检
modify_order_sqltemplate_start
sed -i "s/MYSQL_ORDER_NUM/$MYSQL_ORDER_NUM1/g" $VARIABLE_ALL  
create_order_mysql "$TB_ORDER_INSERTORDER"
create_order_mongo "$TB_ORDER_INSERTORDER_MONGO"
create_order_mongo "$TB_ORDER_INSERTORDER_MONGO_N"
select_tbl_order_ordernum
huidan_no_check
modify_order_sqltemplate_end
sed -i "s/$MYSQL_ORDER_NUM1/MYSQL_ORDER_NUM/g" $VARIABLE_ALL 
}
press_any_key

function order_two(){
echo "==================================order2======================================"
#第二个单子测试	所有项目完成体检
unset COMPANY_ID
COMPANY_ID='327681'
modify_order_sqltemplate_start
sed -i "s/MYSQL_ORDER_NUM/$MYSQL_ORDER_NUM2/g" $VARIABLE_ALL 
sed -i "s/961be8ce0cf2572ba0246823/961be8ce0cf2572ba0246825/g" $TB_ORDER_INSERTORDER_MONGO_N
create_order_mysql "$TB_ORDER_INSERTORDER_ONLY"
create_order_mongo "$TB_ORDER_INSERTORDER_MONGO_N"
select_tbl_order_ordernum
huidan_all_check
sed -i "s/$MYSQL_ORDER_NUM2/MYSQL_ORDER_NUM/g" $VARIABLE_ALL 
sed -i "s/961be8ce0cf2572ba0246825/961be8ce0cf2572ba0246823/g" $TB_ORDER_INSERTORDER_MONGO_N
modify_order_sqltemplate_end

}

function order_three(){
echo "==================================order3======================================"
#第三个单子测试	有未检项目
unset COMPANY_ID
COMPANY_ID='327682'
modify_order_sqltemplate_start
sed -i "s/MYSQL_ORDER_NUM/$MYSQL_ORDER_NUM3/g" $VARIABLE_ALL 
sed -i "s/961be8ce0cf2572ba0246823/961be8ce0cf2572ba0246826/g" $TB_ORDER_INSERTORDER_MONGO_N
create_order_mysql "$TB_ORDER_INSERTORDER_ONLY"
create_order_mongo "$TB_ORDER_INSERTORDER_MONGO_N"
select_tbl_order_ordernum
huidan_un_check
modify_order_sqltemplate_end
sed -i "s/961be8ce0cf2572ba0246826/961be8ce0cf2572ba0246823/g" $TB_ORDER_INSERTORDER_MONGO_N
sed -i "s/$MYSQL_ORDER_NUM3/MYSQL_ORDER_NUM/g" $VARIABLE_ALL 
}

function order_four(){
echo "==================================order4======================================"
#第四个单子测试	有拒检项目
unset COMPANY_ID
COMPANY_ID='327683'
modify_order_sqltemplate_start
sed -i "s/961be8ce0cf2572ba0246823/961be8ce0cf2572ba0246827/g" $TB_ORDER_INSERTORDER_MONGO_N
sed -i "s/MYSQL_ORDER_NUM/$MYSQL_ORDER_NUM4/g" $VARIABLE_ALL 
create_order_mysql "$TB_ORDER_INSERTORDER_ONLY"
create_order_mongo "$TB_ORDER_INSERTORDER_MONGO_N"
select_tbl_order_ordernum
huidan_reject_check
modify_order_sqltemplate_end
sed -i "s/961be8ce0cf2572ba0246827/961be8ce0cf2572ba0246823/g" $TB_ORDER_INSERTORDER_MONGO_N
sed -i "s/$MYSQL_ORDER_NUM4/MYSQL_ORDER_NUM/g" $VARIABLE_ALL 
}

#order_one
#press_any_key
#
#order_two
#press_any_key
#
#order_three
#press_any_key
#
#order_four
#press_any_key

echo 'clear COMPANY_ID value'
unset COMPANY_ID
COMPANY_ID='327684'
echo ""
echo -e "\033[41;33;1m ==================================10order_sync.sh end================================ \033[0m"
echo ""
press_any_key
echo ""
