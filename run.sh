#!/bin/bash
#****************************************************************#
# ScriptName: run.sh
# Author: liujmsunits@hotmail.com
# Create Date: 2016-03-21 10:27
# Modify Author: liujmsunits@hotmail.com
# Modify Date: 2016-03-23 18:40
# Function: 
#***************************************************************#
#一下基本变量的初始化定义，以及脚本执行开始
mpwd=`pwd`
xtype="$1"

source $mpwd/post/med_post.sh 2>&1 |tee -a $mpwd/all.log
