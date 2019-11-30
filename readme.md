# alpine-mysql

## desc

a docker image base on alpine with mysql

## build image
```
tag=registry.cn-hangzhou.aliyuncs.com/yemiancheng/mysql:latest-alpine
docker build --tag "$tag" .
```

## run container
```
docker run -it --rm -v $(pwd):/app -p 3306:3306  "$tag"
```

## usage example

```
docker run -it --name mysql -p 3306:3306 -v $(pwd):/app -e MYSQL_DATABASE=admin -e MYSQL_USER=huahua -e MYSQL_PASSWORD=MjAxOS -e MYSQL_ROOT_PASSWORD=jo1NQo "$tag"
```
