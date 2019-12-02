# alpine-mysql

## desc

a docker image base on alpine with mysql

## how to use with developer?

### define config
```
cat >tool/hub_list.txt <<EOF
#repo-owner-pass
#hub.docker.com=your user =your pass
registry.cn-hangzhou.aliyuncs.com=xxx=xxx
 EOF
```


```
cat >tool/img_list.txt <<EOF
#name-label=name-label
mysql-alpine-3.8.4=mysql-alpine-3.8.4
mysql-alpine-3.9.4=mysql-alpine-3.9.4
#mysql-alpine-3.10.3=mysql-alpine-3.10.3
 EOF
```


### build image
build the image with your config
```
./tool/build.sh
```

it will build image mysql:alpine-3.8.4 and mysql:alpine-3.9.4 .

the mysql:alpine-3.10.3 will not be build with `#` comment.

### test image
test the image you build
```
./tool/test.sh
```

it will test image mysql:alpine-3.8.4 and mysql:alpine-3.9.4 .

### push image

tag and push the image to some docker hub ,eg. docker hub ,aliyun,qiniu ...
```
img_ns=yemiancheng
./tool/push.sh ""
```

it will tag image for docker hub registry.cn-hangzhou.aliyuncs.com ,so there will be:
```
registry.cn-hangzhou.aliyuncs.com/yemiancheng/mysql:alpine-3.8.4
registry.cn-hangzhou.aliyuncs.com/yemiancheng/mysql:alpine-3.9.4
```

the hub.docker.com will not be taged with `#` comment.


it will push image :
```
registry.cn-hangzhou.aliyuncs.com/yemiancheng/mysql:alpine-3.8.4
registry.cn-hangzhou.aliyuncs.com/yemiancheng/mysql:alpine-3.9.4
```

the hub.docker.com will not be pushed with `#` comment.

so that you need to set pass in tool/hub_list.txt . and for secure dont let other person know it.

## how to use with production ?

### pull image with docker cli
```
tag=registry.cn-hangzhou.aliyuncs.com/yemiancheng/mysql:alpine-X.X.X
docker pull "$tag"
```

### run image with docker cli
```
docker run -d --name mysql -p 3306:3306 -v $(pwd):/app -e MYSQL_DATABASE=admin -e MYSQL_USER=huahua -e MYSQL_PASSWORD=MjAxOS -e MYSQL_ROOT_PASSWORD=jo1NQo "$tag"
```

note:in the .env file , you can change the different values to suit your needs.

### uses with a dockerfile 
```
FROM registry.cn-hangzhou.aliyuncs.com/yemiancheng/mysql:alpine-3.9.4
```

your can run with docker cli :
```
docker run -v /mysql/data/:/var/lib/mysql -d -p 3306:3306 --name mysql-alpine-3.9.4 where/your/dockerfile
```

or your can run with docker-compose ,

or your can run with k8s .

## building log

```
#2019-12-02 10:19:59
ok:mysql-10.1.41-alpine-3.7.3
ok:mysql-10.2.26-alpine-3.8.4
ok:mysql-10.3.17-alpine-3.9.4
ok:mysql-10.3.18-alpine-3.10.3
```
