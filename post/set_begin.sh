#!/bin/bash
#****************************************************************#
# ScriptName: set_begin.sh
# Author: liujmsunits@hotmail.com
# Create Date: 2016-03-28 15:30
# Modify Author: liujmsunits@hotmail.com
# Modify Date: 2016-04-18 16:51
# Function: 
#***************************************************************#

#======================================public===================================
#单位名称
COMPANY_NAME='SUCCESSFUL'
#单位ID
COMPANY_ID='327680'
#医院id
HOSPITAL_ID='7'

#======================================order===================================
#订单1 num
MYSQL_ORDER_NUM1='1111111'
#订单2 num
MYSQL_ORDER_NUM2='1111112'
#订单3 num
MYSQL_ORDER_NUM3='1111113'
#订单4 num
MYSQL_ORDER_NUM4='1111114'
#套餐和单项,插入moo里面的那个单项STRING
ITEM_AND_MEAL="'[{\"discount\":true,\"hisId\":\"4302\",\"id\":4207,\"name\":\"报告抽血材料\",\"originalPrice\":2000,\"type\":1,\"typeToMeal\":1},{\"discount\":true,\"hisId\":\"5424\",\"id\":4213,\"name\":\"电子喉镜\",\"originalPrice\":7000,\"type\":1,\"typeToMeal\":1}]', '{\"adjustPrice\":0,\"discount\":1,\"externalDiscount\":1,\"gender\":3,\"id\":11916,\"name\":\"订单同步测试套餐\",\"originalPrice\":9000,\"price\":9000}'"
#套餐价格
ORDER_PRICE='9000'
#体检时间,影响导出
MEDAUTO_EXAMDATE="`date +%Y-%m-%d`T16:00:00.000Z"
#mongo中单项价格
MEDAUTO_hisItemIds='4302:20.00,5424:70.00'
#未检项目金额
UNCHECK_ITEM_PRICE='70'
#未检项目code
UNCHECK_ITEM_CODE='5424'


#======================================item===================================
MEDAUTO_ITEM_CODE='88888888'
MEDAUTO_ITEM_NAME='SUCCESSFUL'
MEDAUTO_ITEM_PRICE='999'


#======================================company================================
NEW_COMPANY_NAME='TECHNOLOGY'
NEW_COMPANY_ID='327690'
MYSQL_ORDER_NUM5='1111115'
MYSQL_ORDER_NUM6='1111116'
UPDATE_COMPANY_NAME='BEAUTIFULL'
