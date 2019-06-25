#!/bin/sh

#  oclint.sh
#  Jenkins
#
#  Created by liufeng on 2019/6/25.
#  Copyright © 2019 成都尚医信息技术有限公司. All rights reserved.

#!/bin/bash

# 指定编码
export LANG="zh_CN.UTF-8"
export LC_COLLATE="zh_CN.UTF-8"
export LC_CTYPE="zh_CN.UTF-8"
export LC_MESSAGES="zh_CN.UTF-8"
export LC_MONETARY="zh_CN.UTF-8"
export LC_NUMERIC="zh_CN.UTF-8"
export LC_TIME="zh_CN.UTF-8"
export LC_ALL=

function checkDepend () {
command -v xcpretty >/dev/null 2>&1 || {
echo >&2 "I require xcpretty but it's not installed.  Install：gem install xcpretty";
exit
}
command -v oclint-json-compilation-database >/dev/null 2>&1 || {
echo >&2 "I require oclint-json-compilation-database but it's not installed.  Install：brew install oclint";
exit
}
}

function oclintForProject () {

# 检测依赖
checkDepend

projectName=$1
scheme=$2
reportType=$3

REPORT_PMD="pmd"
REPORT_XCODE="xcode"

myprojectName=${projectName}
myscheme=${scheme}
echo "myprojectName是：${myprojectName}"
echo "myscheme是：${myscheme}"
echo "reportType为：${reportType}"

# 清除上次编译数据
if [ -d ./build/derivedData ]; then
echo '-----清除上次编译数据derivedData-----'
rm -rf ./build/derivedData
fi

 xcodebuild -project $myprojectName -scheme $myscheme clean
#xcodebuild clean

echo '-----开始编译-----'

# 生成编译数据
xcodebuild -project ${myprojectName} -scheme ${myscheme} -sdk iphonesimulator -derivedDataPath ./build/derivedData -configuration Debug COMPILER_INDEX_STORE_ENABLE=NO | xcpretty -r json-compilation-database -o compile_commands.json


if [ -f ./compile_commands.json ]
then
echo '-----编译数据生成完毕-----'
else
echo "-----生成编译数据失败-----"
return -1
fi

echo '-----分析中-----'

# 自定义排除警告的目录，将目录字符串加到数组里面
# 转化为：-e Debug.m -e Port.m -e Test
exclude_files=("cardloan_js" "Pods")

exclude=""
for i in ${exclude_files[@]}; do
exclude=${exclude}"-e "${i}" "
done
echo "排除目录：${exclude}"

# 分析reportType =~判断子字符串包含关系
if [[ ${reportType} =~ ${REPORT_PMD} ]]
then
nowReportType="-report-type html -o pmd.html"
else
nowReportType="-report-type xcode"
fi
# 自定义report 如：
# nowReportType="-report-type html -o oclint_result.html"

# 生成报表
oclint-json-compilation-database ${exclude} -- \
${nowReportType} \
-rc=LONG_CLASS=1500 \
-rc=NESTED_BLOCK_DEPTH=5 \
-rc=LONG_VARIABLE_NAME=80 \
-rc=LONG_METHOD=200 \
-rc=LONG_LINE=300 \
-max-priority-1=100000 \
-max-priority-2=100000 \
-max-priority-3=100000

#-disable-rule ShortVariableName \
#-disable-rule ObjCAssignIvarOutsideAccessors \
#-disable-rule AssignIvarOutsideAccessors \

rm compile_commands.json
#获取上一条命令的返回状态，OCLint生成报表时，如果警告数量超过配置的数量，则会返回5
result=$?
echo "-------代码分析结果：$result---------"

if [[ ${reportType} =~ ${REPORT_PMD} ]] && [ ! -f ./pmd.html ]
then
    echo "-----分析失败-----"
    return -1
else
    echo '-----分析完毕-----'
    if [ $result == 0 ]
    then
        echo '-----扫描通过-----'
        return 0
    else
        echo '-----扫描未通过-----'
        return -1
    fi
fi
}

# 替换workspace的名字
myworkspace="Jenkins.xcodeproj"
# 替换scheme的名字
myscheme="Jenkins"
# 输出方式 xcode/pmd
reportType="pmd"

oclintForProject ${myworkspace} ${myscheme} ${reportType}
#if [ $? == 0 ]
#then
#fastlane beta
#fi
