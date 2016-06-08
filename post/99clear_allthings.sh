#!/bin/bash
#****************************************************************#
# ScriptName: 99clear_allthings.sh
# Author: liujmsunits@hotmail.com
# Create Date: 2016-03-22 16:55
# Modify Author: liujmsunits@hotmail.com
# Modify Date: 2016-04-18 19:49
# Function: 
#***************************************************************#
echo -e "\033[41;33;1m ==================================99clear_allthings.sh start================================ \033[0m"
#清理测试时生成的数据，特别是测试过程中所用到的数据一定要删除，比如his_item_id=8888这些数
source $spwd/07data_initial.sh clearall


#===========================order data clear===========================
function clear_order_data(){
	COMPANY_ID="$1"
	sed -i "s/COMPANY_ID/$COMPANY_ID/g" $DELETE_ALL_INSERT_DATA	
	while read line
	do
		echo $line
		runmysql "$line"
	done < $DELETE_ALL_INSERT_DATA
	sed -i "s/$COMPANY_ID/COMPANY_ID/g" $DELETE_ALL_INSERT_DATA	
}
function clear_order_data_mongo(){
	sed -i "s/COMPANY_ID/$COMPANY_ID/g" $DELETE_ALL_INSERT_DATA_MONGO	
	while read line
	do
		echo $line
		runmongo "$line"
	done < $DELETE_ALL_INSERT_DATA_MONGO
	sed -i "s/$COMPANY_ID/COMPANY_ID/g" $DELETE_ALL_INSERT_DATA_MONGO
	
}

clear_order_data 327680
clear_order_data 327681
clear_order_data 327682
clear_order_data 327683
clear_order_data_mongo

#===========================item data clear===========================
o_runmysql "$CLEAR_ALL_ITEMVIEW"


#===========================company data clear===========================
function clear_company_order_data(){
	COMPANY_ID="$1"
	sed -i "s/COMPANY_ID/$COMPANY_ID/g" $COMPANY_DELETE_INSERT_DATA 
	while read line
	do
		echo $line
		runmysql "$line"
	done < $COMPANY_DELETE_INSERT_DATA
	sed -i "s/$COMPANY_ID/COMPANY_ID/g" $COMPANY_DELETE_INSERT_DATA 
}

clear_company_order_data 327690
clear_company_order_data 327691
clear_company_order_data 327692






echo -e "\033[41;33;1m ==================================99clear_allthings.sh end================================ \033[0m"
