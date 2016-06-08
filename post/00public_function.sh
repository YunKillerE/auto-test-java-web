#!/bin/bash
#****************************************************************#
# ScriptName: 00function.sh 
# Author: 云尘(jimmy)
# Create Date: 2016-03-16 17:48
# Modify Author: liujmsunits@hotmail.com
# Modify Date: 2016-04-18 20:10
# Function:
#***************************************************************#
echo "==========================================function.sh start================================================================="

echo ""

echo -e "\033[41;33;1m 先修改好agent的配置文件，先别启动tomcat，后面会提示启动。。\033[0m"
echo -e "\033[41;33;1m 先修改好agent的配置文件，先别启动tomcat，后面会提示启动。。\033[0m"
echo -e "\033[41;33;1m 先修改好agent的配置文件，先别启动tomcat，后面会提示启动。。\033[0m"

#公共函数
echo $xtype
#判断命令是否执行成功，则待颜色输出\$1中的内容
function decide_echo(){
    if [ X$? = X0 ];then
            echo -e "\033[42;33;1m $1  \033[0m"
    else
            echo -e "\033[41;33;1m $1  \033[0m"
    fi
}
function decide_exit(){
    if [ X$? = X0 ];then
            echo -e "\033[42;33;1m $1  \033[0m"
    else
            echo -e "\033[41;33;1m $1  \033[0m"
            exit 1
    fi
}

get_char() 
{ 
	SAVEDSTTY=`stty -g` 
	stty -echo 
	stty cbreak 
	dd if=/dev/tty bs=1 count=1 2> /dev/null 
	stty -raw 
	stty echo 
	stty $SAVEDSTTY 
} 

function press_any_key(){
echo -e "\033[46;33;1m Press any key to continue! \033[0m" 
char=`get_char` 
}

#判断两个变量是否相等
function diff_variable(){
    if [ X$1 = X$2 ];then
            echo "$3"
    else
            echo -e "\033[41;33;1m $4 \033[0m" 
    fi
}

#判断文件是否存在
function is_exist(){
    if [ -s $1 ];then
            :
    else
            echo -e "\033[41;33;1m $2  \033[0m"
            exit 1;
    fi
}

#执行mysql命令
function s_runmysql(){
#    mysql -u$mysql_user -p$mysql_passwd -h $mysql_address -e "$1"
	 python $spwd/mysql.py	"$1" s
}
function o_runmysql(){
#    mysql -u$mysql_user -p$mysql_passwd -h $mysql_address -e "$1"
	 python $spwd/mysql.py	"$1" o
}

function runmysql(){
    mysql -u$mysql_user -p$mysql_passwd -h $mysql_address $mysql_database -e "$1"
 }


#执行mongo命令
function runmongo(){
	mq="`cat $1`"
	#echo mq=$mq
   	echo "$mq" |mongo $mongo_address:$mongo_port/$mongo_database --shell
}

#执行sql server命令
#function runsqlserver(){
#    #暂时没办法，初步由开发提供接口
#}
#
##执行oracle命令
#function runoracle(){
#    #暂时没办法，初步由开发提供接口
#}

#执行sqlserver/oracle查询命令
function s_run$xtype(){
    if [ X$xtype = Xsqlserver ];then
            python $spwd/mssql.py "$1" s
    elif [ X$xtype = Xoracle ];then
            python $spwd/oracle.py "$1" s
	else
			echo "input error!!"
			exit 1
    fi
}

#执行sqlserver/oracle非查询命令
function o_run$xtype(){
    if [ X$xtype = Xsqlserver ];then
            python $spwd/mssql.py "$1" o
    elif [ X$xtype = Xoracle ];then
            python $spwd/oracle.py "$1" o
	else
		echo "input error!!"
		exit 1
    fi
}


#100：sql下单，下单的前提条件需要先检查，否则可能会导致下单不成功
function create_order_mysql(){
    #o_runmysql "$TB_ORDER_INSERTORDER"
    o_runmysql "$1"
    decide_echo "脚本：00function.sh 位置：create_order_mysql 结果：Sucessful!!!" "脚本：00function.sh 位置：create_order_mysql 结果： $TB_ORDER_INSERTORDER mysql下单失败!!"
}

#101：mongo下单
function create_order_mongo(){
    #runmongo "$TB_ORDER_INSERTORDER_MONGO"
    runmongo "$1"
    decide_echo "脚本：00function.sh 位置：create_order_mongo 结果：Sucessful!!!" "脚本：00function.sh 位置：create_order_mongo 结果： $TB_ORDER_INSERTORDER_MONGO mongo下单失败!!"
}


#针对订单、单项、单位、体检报告每个部分写个函数用来修改模板

function mm_sed_start(){
	for i in $1
	do
		sed -i "s/$[$i]/$i/g" $2
	done
}


function mm_sed_end(){
	for i in $1
	do
		sed -i "s/$i/$[$i]/g" $2
	done
}

#=======================================order===========================================
VARIABLE_ALL="$SELECT_ITEMVIEW_ROWS $SELECT_TB_EXAMITEM $TB_EXAMITEM_SELECTNAME $TB_EXAMITEM_SELECTGENDER $TB_EXAMITEM_SELECTPRICE $TB_EXAMITEM_SELECTTYPE $TB_EXAMITEM_DISCOUNT $TB_EXAMITEM_SELECTTYPE $TB_EXAMITEM_TYPE $CLEAR_ALL_ITEMVIEW $TBL_ORDER_SELECT_ORDERNUM $TBL_ORDER_ITEM_SELECTITEMCOUNT $ACCOMPLISH_ORDER_INSERTNO $ACCOMPLISH_ORDER_INSERTALL $ACCOMPLISH_ORDER_INSERTUN $ACCOMPLISH_ORDER_INSERTREJECT $TB_ORDER_INSERTORDER $TB_ORDER_INSERTORDER $TB_ORDER_INSERTORDER_MONGO $TB_ORDER_INSERTORDER_MONGO_N $DELETE_ALL_INSERT_DATA $TB_PAYMENTRECORD_TRADETYPE $TB_PAYMENTRECORD_AMOUNT $TB_ORDER_SELECT_NOSTATUS $TB_ORDER_SELECTSTATUS $MONGO_ITEM_COUNTS $TBL_ORDER_REFUND_LOG_SELECTID $TB_ORDER_INSERTORDER_ONLY"

function modify_order_sqltemplate_end(){
	sed -i "s/$COMPANY_NAME/COMPANY_NAME/g" $VARIABLE_ALL
	sed -i "s/$COMPANY_ID/COMPANY_ID/g" $VARIABLE_ALL
	sed -i "s/$HOSPITAL_ID/HOSPITAL_ID/g" $VARIABLE_ALL
	sed -i "s#$ITEM_AND_MEAL#ITEM_AND_MEAL#g" $VARIABLE_ALL
	sed -i "s/$ORDER_PRICE/ORDER_PRICE/g" $VARIABLE_ALL
	sed -i "s#$MEDAUTO_EXAMDATE#MEDAUTO_EXAMDATE#g" $VARIABLE_ALL
	sed -i "s#$MEDAUTO_hisItemIds#MEDAUTO_hisItemIds#g" $VARIABLE_ALL
	sed -i "s/$UNCHECK_ITEM_PRICE/UNCHECK_ITEM_PRICE/g" $VARIABLE_ALL
	sed -i "s/$UNCHECK_ITEM_CODE/UNCHECK_ITEM_CODE/g" $VARIABLE_ALL
}
function modify_order_sqltemplate_start(){
	sed -i "s/COMPANY_NAME/$COMPANY_NAME/g" $VARIABLE_ALL
	sed -i "s/COMPANY_ID/$COMPANY_ID/g" $VARIABLE_ALL
	sed -i "s/HOSPITAL_ID/$HOSPITAL_ID/g" $VARIABLE_ALL
	sed -i "s#ITEM_AND_MEAL#$ITEM_AND_MEAL#g" $VARIABLE_ALL
	sed -i "s/ORDER_PRICE/$ORDER_PRICE/g" $VARIABLE_ALL
	sed -i "s#MEDAUTO_EXAMDATE#$MEDAUTO_EXAMDATE#g" $VARIABLE_ALL
	sed -i "s#MEDAUTO_hisItemIds#$MEDAUTO_hisItemIds#g" $VARIABLE_ALL
	sed -i "s/UNCHECK_ITEM_PRICE/$UNCHECK_ITEM_PRICE/g" $VARIABLE_ALL
	sed -i "s/UNCHECK_ITEM_CODE/$UNCHECK_ITEM_CODE/g" $VARIABLE_ALL
}

#=======================================item===========================================
VARIABLE_ALL_ITEM="$ITEM_VIEW $ITEM_VIEW_TABLE $INSERT_ITEM_VIEW $ITEM_VIEW_UPDATE_NAME $ITEM_VIEW_UPDATE_GENDER $ITEM_VIEW_UPDATE_PRICE $ITEM_VIEW_UPDATE_DISCOUNT $DELETE_ITEMVIEW $SELECT_ITEMVIEW_ROWS $SELECT_TB_EXAMITEM $TB_EXAMITEM_SELECTGENDER $TB_EXAMITEM_SELECTPRICE $TB_EXAMITEM_SELECTTYPE $TB_EXAMITEM_TYPE $CLEAR_ALL_ITEMVIEW"

function modify_item_sqltemplate_start()
{
	sed -i "s/MEDAUTO_ITEM_CODE/$MEDAUTO_ITEM_CODE/g" $VARIABLE_ALL_ITEM
	sed -i "s/MEDAUTO_ITEM_NAME/$MEDAUTO_ITEM_NAME/g" $VARIABLE_ALL_ITEM
	sed -i "s/MEDAUTO_ITEM_PRICE/$MEDAUTO_ITEM_PRICE/g" $VARIABLE_ALL_ITEM
	sed -i "s/HOSPITAL_ID/$HOSPITAL_ID/g" $VARIABLE_ALL_ITEM
}


function modify_item_sqltemplate_end()
{
	sed -i "s/$MEDAUTO_ITEM_CODE/MEDAUTO_ITEM_CODE/g" $VARIABLE_ALL_ITEM
	sed -i "s/$MEDAUTO_ITEM_NAME/MEDAUTO_ITEM_NAME/g" $VARIABLE_ALL_ITEM
	sed -i "s/$MEDAUTO_ITEM_PRICE/MEDAUTO_ITEM_PRICE/g" $VARIABLE_ALL_ITEM
	sed -i "s/$HOSPITAL_ID/HOSPITAL_ID/g" $VARIABLE_ALL_ITEM
}


#=======================================company===========================================

VARIABLE_ALL_COMPANY="$TB_EXAM_COMPANY_ICOMPANY $TB_EXAM_COMPANY_MONGO $TB_EXAM_COMPANY_ORDER_MONGO $TB_EXAM_COMPANY_ORDER  $TB_EXAM_COMPANY_ORDER_MONGO $TB_EXAM_COMPANY_UPDATENAME $EXAM_COMPANY_SELECTNAME $TB_EXAM_COMPANY_UPDATENAME $TB_EXAM_COMPANY_UPDATENAME_MONGO $TB_EXAM_COMPANY_UPDATESANKENAME $TB_EXAM_COMPANY_UPDATESANKENAME_MONGO $TB_EXAM_COMPANY_SELECTNAME $TB_EXAM_COMPANY_UPDATENAME $EXAM_COMPANY_SELECTSANKENAME $EXAM_COMPANY_MODIFYNAME"

function modify_company_sqltemplate_start(){
unset COMPANY_NAME 
unset COMPANY_ID

COMPANY_NAME="$NEW_COMPANY_NAME"
COMPANY_ID="$NEW_COMPANY_ID"

	sed -i "s/COMPANY_NAME/$COMPANY_NAME/g" $VARIABLE_ALL_COMPANY
	sed -i "s/COMPANY_ID/$COMPANY_ID/g" $VARIABLE_ALL_COMPANY
	sed -i "s/HOSPITAL_ID/$HOSPITAL_ID/g" $VARIABLE_ALL_COMPANY

	sed -i "s#ITEM_AND_MEAL#$ITEM_AND_MEAL#g" $VARIABLE_ALL_COMPANY
	sed -i "s/ORDER_PRICE/$ORDER_PRICE/g" $VARIABLE_ALL_COMPANY
	sed -i "s#MEDAUTO_EXAMDATE#$MEDAUTO_EXAMDATE#g" $VARIABLE_ALL_COMPANY
	sed -i "s#MEDAUTO_hisItemIds#$MEDAUTO_hisItemIds#g" $VARIABLE_ALL_COMPANY
	sed -i "s/UNCHECK_ITEM_PRICE/$UNCHECK_ITEM_PRICE/g" $VARIABLE_ALL_COMPANY
	sed -i "s/UNCHECK_ITEM_CODE/$UNCHECK_ITEM_CODE/g" $VARIABLE_ALL_COMPANY

	sed -i "s/UPDATE_COMPANY_NAME/$UPDATE_COMPANY_NAME/g" $VARIABLE_ALL_COMPANY
}

function modify_company_sqltemplate_end(){
	sed -i "s/$COMPANY_NAME/COMPANY_NAME/g" $VARIABLE_ALL_COMPANY
	sed -i "s/$COMPANY_ID/COMPANY_ID/g" $VARIABLE_ALL_COMPANY
	sed -i "s/$HOSPITAL_ID/HOSPITAL_ID/g" $VARIABLE_ALL_COMPANY

	sed -i "s#$ITEM_AND_MEAL#ITEM_AND_MEAL#g" $VARIABLE_ALL_COMPANY
	sed -i "s/$ORDER_PRICE/ORDER_PRICE/g" $VARIABLE_ALL_COMPANY
	sed -i "s#$MEDAUTO_EXAMDATE#MEDAUTO_EXAMDATE#g" $VARIABLE_ALL_COMPANY
	sed -i "s#$MEDAUTO_hisItemIds#MEDAUTO_hisItemIds#g" $VARIABLE_ALL_COMPANY
	sed -i "s/$UNCHECK_ITEM_PRICE/UNCHECK_ITEM_PRICE/g" $VARIABLE_ALL_COMPANY
	sed -i "s/$UNCHECK_ITEM_CODE/UNCHECK_ITEM_CODE/g" $VARIABLE_ALL_COMPANY

	sed -i "s/$UPDATE_COMPANY_NAME/UPDATE_COMPANY_NAME/g" $VARIABLE_ALL_COMPANY
}

#=======================================report===========================================
function modify_report_sqltemplate_start(){
	:
}
function modify_report_sqltemplate_end(){
	:
}

echo "==========================================function.sh end================================================================="
echo ""
press_any_key
echo ""
