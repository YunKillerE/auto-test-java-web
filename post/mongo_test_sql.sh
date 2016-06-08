#!/bin/bash
#****************************************************************#
# ScriptName: mongo_test_sql.sh
# Author: liujmsunits@hotmail.com
# Create Date: 2016-04-13 19:04
# Modify Author: liujmsunits@hotmail.com
# Modify Date: 2016-04-13 19:14
# Function: 
#***************************************************************#
TQ="db.examCompanyChangeLog.save({_class: "com.mytijian.company.model.ExamCompanyChangeLog", hospitalId: HOSPITAL_ID, companyId: COMPANY_ID, name: "COMPANY_NAME"});"

function runmongo(){
    for i in `cat $1`
    do
        echo "$i" |mongo $mongo_address:$mongo_port/$mongo_database --shell
    done
}
runmongo $1
