#./tool/build.sh
#run image with:
docker run -v /mysql/data/:/var/lib/mysql -d -p 3306:3306 --name mysql-alpine-3.10.3 mysql:alpine-3.10.3
#see cm logs with:
docker container logs mysql-alpine-3.10.3
#go into cm with:
docker exec -it mysql-alpine-3.10.3 /bin/sh
#exit cm with:
exit
#stop cm with:
docker container stop mysql-alpine-3.10.3
#delete cm with:
docker container rm --force --volumes mysql-alpine-3.10.3

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

run image with:
docker run -v /mysql/data/:/var/lib/mysql -d -p 3306:3306 --name mysql-alpine-3.9.4 mysql:alpine-3.9.4
see cm logs with:
docker container logs mysql-alpine-3.9.4
go into cm with:
docker exec -it mysql-alpine-3.9.4 /bin/sh
exit cm with:
exit
stop cm with:
docker container stop mysql-alpine-3.9.4
delete cm with:
docker container rm --force --volumes mysql-alpine-3.9.4

run image with:
docker run -v /mysql/data/:/var/lib/mysql -d -p 3306:3306 --name mysql-alpine-3.8.4 mysql:alpine-3.8.4
see cm logs with:
docker container logs mysql-alpine-3.8.4
go into cm with:
docker exec -it mysql-alpine-3.8.4 /bin/sh
exit cm with:
exit
stop cm with:
docker container stop mysql-alpine-3.8.4
delete cm with:
docker container rm --force --volumes mysql-alpine-3.8.4
