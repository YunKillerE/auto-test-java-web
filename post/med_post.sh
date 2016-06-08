#!/bin/bash
#****************************************************************#
# ScriptName: med_post.sh
# Author: liujmsunits@hotmail.com
# Create Date: 2016-03-21 10:31
# Modify Author: liujmsunits@hotmail.com
# Modify Date: 2016-04-07 16:25
# Function: 
#***************************************************************#
function error_log(){
	echo $1 >>/root/install.log
}

function progress(){
	:
}

PWD=`pwd`

source "$PWD/post/set_begin.sh"
source "$PWD/post/set_variable.sh"

#更改函数名称
sed -i "s/o_run\$xtype/o_run$xtype/g" $PWD/post/[00-99]*.sh
sed -i "s/s_run\$xtype/s_run$xtype/g" $PWD/post/[00-99]*.sh

source "$PWD/post/00public_function.sh"

for i in `ls $PWD/post/[01-99]*.sh`
do
		echo "========$i========"
		source $i 2>&1|tee -a $PWD/med_post.log
		echo ""
done

#还原函数名称
sed -i "s/o_run$xtype/o_run\$xtype/g" $PWD/post/[00-99]*.sh
sed -i "s/s_run$xtype/s_run\$xtype/g" $PWD/post/[00-99]*.sh
