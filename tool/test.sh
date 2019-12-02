#./tool/build.sh

#log in to mysql serce with:
#mysql -uroot -pe7432c
#show data base with:
#show databases;
#set password with:
#SET PASSWORD = PASSWORD('a9f0e9');
#show timezone with:
#show variables like "%time_zone%";
#show charset with:
#SHOW VARIABLES LIKE 'characterset%';
#SHOW VARIABLES LIKE 'collation_%';
#select a table with:
#use mysql;
#!/bin/sh

THIS_FILE_PATH=$(
    cd $(dirname $0)
    pwd
)
source $THIS_FILE_PATH/function-list.sh
THIS_PROJECT_PATH=$(path_resolve "$THIS_FILE_PATH" "../")
RUN_SCRIPT_PATH=$(pwd)
logfile=$THIS_PROJECT_PATH/tool/debug-log.txt
buildlogfile=$THIS_PROJECT_PATH/tool/build-log.txt

function gen_build_log() {
    local list=
    list=$(cat $logfile)
    list=$(echo "$list" | sed "s/^#.*//g" | sed "/^$/d" | sed "s/^/ok:/g")
    local temp=
    local now_time=
    now_time=$(date "+%Y-%m-%d %H:%M:%S")
    temp="#$now_time"
    for val in $list; do
        val=$(echo "$val")
        temp=$(
            cat <<EOF
$temp
$val
EOF
        )
    done
    #temp=$(echo "$temp" | sed "/^$/d")
    #echo "$temp"
    echo "$temp" >$buildlogfile
}

echo "" >$logfile
source $THIS_FILE_PATH/debug.sh
echo "gen build-log.txt ..."
gen_build_log
#go into cm with:
#docker exec -it mysql-alpine-3.9.4 /bin/sh
#exit cm with:
#exit
#stop cm with:
#docker container stop mysql-alpine-3.9.4
#delete cm with:
#docker container rm --force --volumes mysql-alpine-3.9.4
