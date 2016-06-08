#!/bin/bash
#****************************************************************#
# ScriptName: 20item_sync.sh
# Author: 云尘(jimmy)
# Create Date: 2016-03-16 17:48
# Modify Author: liujmsunits@hotmail.com
# Modify Date: 2016-04-13 19:10
# Function:
#***************************************************************#

echo -e "\033[41;33;1m ==================================20item_sync.sh start================================ \033[0m"
press_any_key

#单项同步
#1,数据初始化：先删除item_view中的数据，通过sql在中间表item_view中插入单项，并同时删除mysql数据库中tb_examitem的单项，然后等待，查询出行数进行比对
#2，增：在中间表插入一条单项数据，记录item_code，然后等待，在mysql数据库中通过his_item_id(=item_code)查询是否有结果，检测新增单项是否同步成功？
#3，改：依次修改上面插入的单项的名称、性别两种情况，然后等待，在mysql中查询是否也修改了，判断单项修改是否成功？
#   改：修改上面插入单项的价格、折扣，然后等待，在mysql中查询tb_examitem_change_log表是否生成了相应的修改记录，通过tb_examitem表中的主键
#4, 删：删除上面插入的那条数据，然后等待，在mysql中看是否也删除了，判断删除单项是否成功？
#
#分析：1，插入sqlserver/oracle的接口，需要将相应的数据插入中间表
#      2，需要两个全局变量，新增订单的item_code=his_item_id以及tb_examitem中的主键id
#      3，单项插入语句，查询语句，修改语句，删除语句

#100: 创建单项表，通过传入sql语句创建表，函数调用公共函数（一个通用的创建表的函数sqlserver/oracle）
#createtable_$xtype $ITEM_VIEW_TABLE  #此部分放到07中一起做了

#101：插入单项数据，通过传入sql语句，插入初始单项数据，函数调用公共函数（一个通用的执行sql的函数sqlserver/oracle）
#run$xtype $ITEM_VIEW  #此部分放到07中一起做了

#102:等待1分钟，然后比对同步结果，初步采用比对行数的办法
function compare_table_rows(){
    echo "sleep 10s to wait initial item sync..."
    sleep 10

    middle_table_rows=`cat $ITEM_VIEW | wc -l`
    mysql_table_rows=`s_runmysql $SELECT_ITEMVIEW_ROWS` 

    if [ X$middle_table_rows = X$mysql_table_rows ];then
            echo -e "\033[43;33;1m 脚本：20item_sync.sh 位置：102 Sucessful!!! \033[0m"
    else
            echo -e "\033[41;33;1m 脚本：20item_sync.sh 位置：102 结果：$SELECT_ITEMVIEW_ROWS 初始化同步单项失败!!! \033[0m"
    fi
}

#103：插入一条单项数据，并查看同步结果
function insert_item_view_sqlserver(){
    echo "插入一条单项测试数据到中间表。。。"
    o_run$xtype "$INSERT_ITEM_VIEW"
    decide_echo "脚本：20item_sync.sh 位置：103 结果：Sucessful!!!" "脚本：20item_sync.sh 位置：103 结果： $INSERT_ITEM_VIEW 插入单项数据失败!"

    echo "等待刚插入的单项数据同步到mysql。。。10s"
    sleep 10
    s_runmysql "$SELECT_TB_EXAMITEM"
    decide_echo "脚本：20item_sync.sh 位置：103 结果：Sucessful!!!" "脚本：20item_sync.sh 位置：103 结果： $SELECT_TB_EXAMITEM 插入单项数据失败!!"
}

#104：修改单项名称，并在mysql中查看同步结果
function update_itemview_name(){
    echo "修改单项名称。。。"
    o_run$xtype "$ITEM_VIEW_UPDATE_NAME"
    decide_echo "脚本：20item_sync.sh 位置：104 结果：Sucessful!!!" "脚本：20item_sync.sh 位置：104 结果： $ITEM_VIEW_UPDATE_NAME 修改单项名称失败!!"

    echo "等待10s查询修改单项名称mysql中同步结果..."
    sleep 10
    itemname=`s_runmysql "$TB_EXAMITEM_SELECTNAME"`
	echo X$itemname
    if [ X$itemname = Xtxwd ];then
            echo -e "\033[43;33;1m 脚本：20item_sync.sh 位置：104 结果：Sucessful!!! \033[0m"
    else
            echo -e "\033[41;33;1m 脚本：20item_sync.sh 位置：104 结果： $TB_EXAMITEM_SELECTNAME 单项名称修改同步失败!!\033[0m"
    fi
}

#105：修改单项性别，并在mysql中查看同步结果
function update_itemview_gender(){
    echo "修改单项性别..."
    o_run$xtype "$ITEM_VIEW_UPDATE_GENDER"
    decide_echo "脚本：20item_sync.sh 位置：105 结果：Sucessful!!!" "脚本：20item_sync.sh 位置：105 结果： $ITEM_VIEW_UPDATE_NAME 修改性别失败!!"

    echo "等等10s查询修改单项性别mysql中同步结果..."
    sleep 10
    mysql_itemgender=`s_runmysql $TB_EXAMITEM_SELECTGENDER`
    if [ X$mysql_itemgender = X0 ];then
            echo -e "\033[43;33;1m 脚本：20item_sync.sh 位置：105 结果：Sucessful!!! \033[0m"
    else
            echo -e "\033[41;33;1m 脚本：20item_sync.sh 位置：105 结果： $TB_EXAMITEM_SELECTNAME 单项性别修改同步失败!! \033[0m"
    fi
}

#106：修改单项价格，并在mysql中查看同步结果，并查看tb_examitem_change_log中是否生成log
function update_itemview_price(){
    echo "修改单项价格..."
    o_run$xtype "$ITEM_VIEW_UPDATE_PRICE"
    decide_echo "脚本：20item_sync.sh 位置：106 结果：Sucessful!!!" "脚本：20item_sync.sh 位置：106 结果： $ITEM_VIEW_UPDATE_PRICE 修改价格失败!!"

    echo "等等10s查询修改单项价格是否成功..."
    sleep 10
    #mysql_itemprice=`s_runmysql $TB_EXAMITEM_SELECTPRICE`
    #if [ X$mysql_itemprice = X999 ];then
    #        echo -e "\033[43;33;1m 脚本：20item_sync.sh 位置：106 结果：Sucessful!!! \033[0m"
    #else
    #        echo -e "\033[41;33;1m 脚本：20item_sync.sh 位置：106 结果： $TB_EXAMITEM_SELECTPRICE 单项价格修改同步失败!! \033[0m"
    #fi

    echo "查询tb_examitem_change_log中是否生成log..."
    mysql_itemlogtype=`s_runmysql $TB_EXAMITEM_SELECTTYPE`
    if [ X$mysql_itemlogtype = X1 ];then
            echo -e "\033[43;33;1m 脚本：20item_sync.sh 位置：106 结果：Sucessful!!! \033[0m"
    else
            echo -e "\033[41;33;1m 脚本：20item_sync.sh 位置：106 结果： $TB_EXAMITEM_SELECTYPE 单项价格修改写log表失败!! \033[0m"
    fi
}

#107：修改单项折扣，并在mysql中查询同步结果，并查看tb_examitem_change_log中是否生成log
function update_itemview_isdiscount(){
    echo "修改单项折扣..."
    o_run$xtype "$ITEM_VIEW_UPDATE_DISCOUNT"
    decide_echo "脚本：20item_sync.sh 位置：107 结果：Sucessful!!!" "脚本：20item_sync.sh 位置：107 结果： $ITEM_VIEW_UPDATE_DISCOUNT 修改折扣失败!!"

    echo "等等10s查询修改单项折扣是否成功..."
    sleep 10
    #mysql_itemdiscount=`s_runmysql $TB_EXAMITEM_DISCOUNT`
    #if [ X$mysql_itemdiscount = X1 ];then
    #        echo -e "\033[43;33;1m 脚本：20item_sync.sh 位置：107 结果：Sucessful!!! \033[0m"
    #else
    #        echo -e "\033[41;33;1m 脚本：20item_sync.sh 位置：107 结果： $TB_EXAMITEM_DISCOUNT 单项折扣修改写log表失败!! \033[0m"
    #fi

    echo "查询查询tb_examitem_change_log中是否生成log..."
    mysql_itemlogtype=`s_runmysql $TB_EXAMITEM_SELECTTYPE`
    if [ X$mysql_itemlogtype = X2 ];then
            echo -e "\033[43;33;1m 脚本：20item_sync.sh 位置：107 结果：Sucessful!!! \033[0m"
    else
            echo -e "\033[41;33;1m 脚本：20item_sync.sh 位置：107 结果： $TB_EXAMITEM_SELECTYPE 单项折扣修改写log表失败!! \033[0m"
    fi
}

#108：删除单项，并在mysql中查询type是否等于6，并查看tb_examitem_change_log中是否生成log
function delete_itemview(){
    echo "删除单项..."
    o_run$xtype "$DELETE_ITEMVIEW"
    decide_echo "脚本：20item_sync.sh 位置：108 结果：Sucessful!!!" "脚本：20item_sync.sh 位置：108 结果： $DELETE_ITEMVIEW 删除单项失>败!!"

    echo "等等10s查询删除订单是否成功..."
    sleep 10
    #mysql_itemtype=`s_runmysql $TB_EXAMITEM_TYPE`
    #if [ X$mysql_itemtype = X6 ];then
    #        echo -e "\033[43;33;1m 脚本：20item_sync.sh 位置：108 结果：Sucessful!!! \033[0m"
    #else
    #        echo -e "\033[41;33;1m 脚本：20item_sync.sh 位置：108 结果： $TB_EXAMITEM_TYPE 单项删除失败!! \033[0m"
    #fi

    echo "查询tb_examitem_change_log中是否生成log..."
    mysql_itemlogtype=`s_runmysql $TB_EXAMITEM_SELECTTYPE`
	echo X$mysql_itemlogtype
    if [ X$mysql_itemlogtype = X3 ];then
            echo -e "\033[43;33;1m 脚本：20item_sync.sh 位置：108 结果：Sucessful!!! \033[0m"
    else
            echo -e "\033[41;33;1m 脚本：20item_sync.sh 位置：108 结果： $TB_EXAMITEM_SELECTYPE 单项删除写log表失败!! \033[0m"
    fi
}

function modify_item_sqltemplate_start()
{
    sed -i "s/MEDAUTO_ITEM_CODE/$MEDAUTO_ITEM_CODE/g" $ITEM_VIEW $INSERT_ITEM_VIEW $ITEM_VIEW_UPDATE_NAME $ITEM_VIEW_UPDATE_GENDER $ITEM_VIEW_UPDATE_PRICE $ITEM_VIEW_UPDATE_DISCOUNT $DELETE_ITEMVIEW $SELECT_ITEMVIEW_ROWS $SELECT_TB_EXAMITEM $TB_EXAMITEM_SELECTGENDER $TB_EXAMITEM_SELECTPRICE $TB_EXAMITEM_SELECTTYPE $TB_EXAMITEM_TYPE $CLEAR_ALL_ITEMVIEW $TB_EXAMITEM_SELECTNAME
    sed -i "s/MEDAUTO_ITEM_NAME/$MEDAUTO_ITEM_NAME/g" $ITEM_VIEW $INSERT_ITEM_VIEW $ITEM_VIEW_UPDATE_NAME $ITEM_VIEW_UPDATE_GENDER $ITEM_VIEW_UPDATE_PRICE $ITEM_VIEW_UPDATE_DISCOUNT $DELETE_ITEMVIEW $SELECT_ITEMVIEW_ROWS $SELECT_TB_EXAMITEM $TB_EXAMITEM_SELECTGENDER $TB_EXAMITEM_SELECTPRICE $TB_EXAMITEM_SELECTTYPE $TB_EXAMITEM_TYPE $CLEAR_ALL_ITEMVIEW $TB_EXAMITEM_SELECTNAME
    sed -i "s/MEDAUTO_ITEM_PRICE/$MEDAUTO_ITEM_PRICE/g" $ITEM_VIEW $INSERT_ITEM_VIEW $ITEM_VIEW_UPDATE_NAME $ITEM_VIEW_UPDATE_GENDER $ITEM_VIEW_UPDATE_PRICE $ITEM_VIEW_UPDATE_DISCOUNT $DELETE_ITEMVIEW $SELECT_ITEMVIEW_ROWS $SELECT_TB_EXAMITEM $TB_EXAMITEM_SELECTGENDER $TB_EXAMITEM_SELECTPRICE $TB_EXAMITEM_SELECTTYPE $TB_EXAMITEM_TYPE $CLEAR_ALL_ITEMVIEW $TB_EXAMITEM_SELECTNAME
    sed -i "s/HOSPITAL_ID/$HOSPITAL_ID/g" $ITEM_VIEW $INSERT_ITEM_VIEW $ITEM_VIEW_UPDATE_NAME $ITEM_VIEW_UPDATE_GENDER $ITEM_VIEW_UPDATE_PRICE $ITEM_VIEW_UPDATE_DISCOUNT $DELETE_ITEMVIEW $SELECT_ITEMVIEW_ROWS $SELECT_TB_EXAMITEM $TB_EXAMITEM_SELECTGENDER $TB_EXAMITEM_SELECTPRICE $TB_EXAMITEM_SELECTTYPE $TB_EXAMITEM_TYPE $CLEAR_ALL_ITEMVIEW $TB_EXAMITEM_SELECTNAME
}

function modify_item_sqltemplate_end()
{
   sed -i "s/$MEDAUTO_ITEM_CODE/MEDAUTO_ITEM_CODE/g" $ITEM_VIEW $INSERT_ITEM_VIEW $ITEM_VIEW_UPDATE_NAME $ITEM_VIEW_UPDATE_GENDER $ITEM_VIEW_UPDATE_PRICE $ITEM_VIEW_UPDATE_DISCOUNT $DELETE_ITEMVIEW $SELECT_ITEMVIEW_ROWS $SELECT_TB_EXAMITEM $TB_EXAMITEM_SELECTGENDER $TB_EXAMITEM_SELECTPRICE $TB_EXAMITEM_SELECTTYPE $TB_EXAMITEM_TYPE $CLEAR_ALL_ITEMVIEW $TB_EXAMITEM_SELECTNAME
   sed -i "s/$MEDAUTO_ITEM_NAME/MEDAUTO_ITEM_NAME/g" $ITEM_VIEW $INSERT_ITEM_VIEW $ITEM_VIEW_UPDATE_NAME $ITEM_VIEW_UPDATE_GENDER $ITEM_VIEW_UPDATE_PRICE $ITEM_VIEW_UPDATE_DISCOUNT $DELETE_ITEMVIEW $SELECT_ITEMVIEW_ROWS $SELECT_TB_EXAMITEM $TB_EXAMITEM_SELECTGENDER $TB_EXAMITEM_SELECTPRICE $TB_EXAMITEM_SELECTTYPE $TB_EXAMITEM_TYPE $CLEAR_ALL_ITEMVIEW $TB_EXAMITEM_SELECTNAME
   sed -i "s/$MEDAUTO_ITEM_PRICE/MEDAUTO_ITEM_PRICE/g" $ITEM_VIEW $INSERT_ITEM_VIEW $ITEM_VIEW_UPDATE_NAME $ITEM_VIEW_UPDATE_GENDER $ITEM_VIEW_UPDATE_PRICE $ITEM_VIEW_UPDATE_DISCOUNT $DELETE_ITEMVIEW $SELECT_ITEMVIEW_ROWS $SELECT_TB_EXAMITEM $TB_EXAMITEM_SELECTGENDER $TB_EXAMITEM_SELECTPRICE $TB_EXAMITEM_SELECTTYPE $TB_EXAMITEM_TYPE $CLEAR_ALL_ITEMVIEW $TB_EXAMITEM_SELECTNAME
   sed -i "s/$HOSPITAL_ID/HOSPITAL_ID/g" $ITEM_VIEW $INSERT_ITEM_VIEW $ITEM_VIEW_UPDATE_NAME $ITEM_VIEW_UPDATE_GENDER $ITEM_VIEW_UPDATE_PRICE $ITEM_VIEW_UPDATE_DISCOUNT $DELETE_ITEMVIEW $SELECT_ITEMVIEW_ROWS $SELECT_TB_EXAMITEM $TB_EXAMITEM_SELECTGENDER $TB_EXAMITEM_SELECTPRICE $TB_EXAMITEM_SELECTTYPE $TB_EXAMITEM_TYPE $CLEAR_ALL_ITEMVIEW $TB_EXAMITEM_SELECTNAME
}

function main(){
	echo "modify template..."
	modify_item_sqltemplate_start

	compare_table_rows
	insert_item_view_sqlserver
	update_itemview_name
	update_itemview_gender
	update_itemview_price
	update_itemview_isdiscount
	delete_itemview

	press_any_key
	echo "recovery template..."
	modify_item_sqltemplate_end
}

echo ""
echo -e "\033[41;33;1m ==================================20item_sync.sh end================================ \033[0m"
echo ""
press_any_key
echo ""
