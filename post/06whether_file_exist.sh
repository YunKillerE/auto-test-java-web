#!/bin/bash
#****************************************************************#
# ScriptName: 06whether_file_exist.sh
# Author: 云尘(jimmy)
# Create Date: 2016-03-16 17:48
# Modify Author: liujmsunits@hotmail.com
# Modify Date: 2016-04-01 14:27
# Function: 
#***************************************************************#

#主要判断sql文件是否存在

echo "============================================06whether_file_exist.sh start ==================================================="

#100:订单同步相关文件判断



#101：单项同步相关文件判断
is_exist $ITEM_VIEW "WARNNING:$ITEM_VIEW IS NOT EXIST!!!EXIT!!!"
is_exist $ITEM_VIEW_TABLE "WARNNING:$ITEM_VIEW_TABLE IS NOT EXIST!!!EXIT!!!"



#102：单位同步相关文件判断



#103：体检报告相关文件判断






echo "============================================06whether_file_exist.sh end ==================================================="

echo ""
press_any_key
echo ""
