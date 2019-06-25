#!/bin/sh
#if [ "Release" == "${CONFIGURATION}" ];then
buildNumber=$(date +%Y%m%d%H%M%S)
/usr/libexec/PlistBuddy -c "Set :CFBundleVersion $buildNumber" "$INFOPLIST_FILE"
#fi

#最后一次提交的SHA
git_sha=$(git rev-parse HEAD)

#当前的分支
git_branch=$(git symbolic-ref --short -q HEAD)

#最后一次提交的作者
git_last_commit_user=$(git log -1 --pretty=format:'%an')

#最后一次提交的时间
git_last_commit_date=$(git log -1 --format='%cd')

#获取App安装包下的info.plist文件路径
info_plist="${BUILT_PRODUCTS_DIR}/${EXECUTABLE_FOLDER_PATH}/Info.plist"

#/usr/libexec/PlistBuddy -c "Add :GitLastCommitAbbreviatedHash string ${gitLastCommitAbbreviatedHash}" ${buildInfoPlist}
/usr/libexec/PlistBuddy -c 'Add :HELLO string hahahah' info.plist

/usr/libexec/PlistBuddy -c "Set :GitCommitBranch ${git_branch}" "$INFOPLIST_FILE"

#利用PlistBuddy改变info.plist的值
/usr/libexec/PlistBuddy -c "Set :'GitCommitSHA'       '${git_sha}'"                "${info_plist}"
/usr/libexec/PlistBuddy -c "Set :'GitCommitBranch'    '${git_branch}'"                 "${info_plist}"
/usr/libexec/PlistBuddy -c "Set :'GitCommitUser'      ${git_last_commit_user}"       "${info_plist}"
/usr/libexec/PlistBuddy -c "Set :'GitCommitDate'      '${git_last_commit_date}'"       "${info_plist}"

