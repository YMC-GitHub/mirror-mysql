#!/bin/sh

THIS_FILE_PATH=$(
    cd $(dirname $0)
    pwd
)
source $THIS_FILE_PATH/function-list.sh
THIS_PROJECT_PATH=$(path_resolve "$THIS_FILE_PATH" "../")
RUN_SCRIPT_PATH=$(pwd)
logfile=$THIS_PROJECT_PATH/tool/debug-log.txt

#run image with:
docker run -v /mysql/data/:/var/lib/mysql -d -p 3306:3306 --name mysql-alpine-3.7.3 mysql:alpine-3.7.3
sleep 30
#see cm logs with:
docker container logs mysql-alpine-3.7.3
ver=$(docker container logs mysql-alpine-3.7.3 | grep "Version: " | sed "s/MariaDB.*//" | sed "s/Version: '//")
if [ 0 -eq 0 ]; then echo "mysql--alpine-3.7.3"; fi >>$logfile
#go into cm with:
#docker exec -it mysql-alpine-3.7.3 /bin/sh
#exit cm with:
#exit
#stop cm with:
#docker container stop mysql-alpine-3.7.3
#delete cm with:
#docker container rm --force --volumes mysql-alpine-3.7.3
