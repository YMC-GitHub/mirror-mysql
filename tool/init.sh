#!/bin/sh

THIS_FILE_PATH=$(
    cd $(dirname $0)
    pwd
)
source $THIS_FILE_PATH/function-list.sh
THIS_PROJECT_PATH=$(path_resolve "$THIS_FILE_PATH" "../")
RUN_SCRIPT_PATH=$(pwd)

function add_dockerfile() {
    local author=
    local email=
    local TXT=
    author=ymc-github
    email=yemiancheng@gmail.com
    local TXT=
    TXT=$(
        cat <<EOF
# base mysql image with alpine
# 基础镜像
#FROM alpine:3.7.3
#FROM alpine:3.9.4
FROM alpine:3.10.4
#FROM reg.qiniu.com/library/alpine:3.8
# 维护作者
LABEL MAINTAINER="${author} <${email}>"
ENV TIMEZONE Asia/Shanghai
# 工作目录
WORKDIR /app

# 挂载目录
VOLUME [ "/app" ]
# 拷贝脚本
COPY startup.sh /startup.sh
# 安装软件mysql+清除安装记录+创建用户+创建小组
RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.aliyun.com/g' /etc/apk/repositories && apk add --update mysql mysql-client && rm -f /var/cache/apk/* && addgroup mysql mysql
# 拷贝配置mysql
COPY my.cnf /etc/mysql/my.cnf
# 暴露端口
EXPOSE 3306
# 启动脚本
CMD ["/startup.sh"]
EOF
    )
    TXT=$(echo "$TXT" | sed "s/^ *#.*//g" | sed "/^$/d")
    echo "$TXT"
}

function add_dockerignore() {
    local TXT=
    TXT=$(
        cat <<EOF
.git
LICENSE
README.md
tool/
EOF
    )
    TXT=$(echo "$TXT" | sed "s/^ *#.*//g" | sed "/^$/d")
    echo "$TXT"
}

function add_myconf() {
    local TXT=
    TXT=$(
        cat <<EOF
[mysqld]
# mysql服务谁能使用
user = root
# mysql数据目录位置
datadir = /app/mysql
# mysql服务端口位置
port = 3306
# mysql服务日志文件
log-bin = /app/mysql/mysql-bin
EOF
    )
    TXT=$(echo "$TXT" | sed "s/^ *#.*//g" | sed "/^$/d")
    echo "$TXT"
}

function add_license() {
    local author=
    local email=
    local TXT=
    author=ymc-github
    email=yemiancheng@gmail.com
    local TXT=
    TXT=$(
        cat <<EOF
The MIT License (MIT)

Copyright (c) 2019 ${author} <${email}>

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
EOF
    )
    TXT=$(echo "$TXT" | sed "s/^ *#.*//g" | sed "/^$/d")
    echo "$TXT"
}

function add_readme() {
    local author=
    local email=
    local TXT=
    author=ymc-github
    email=yemiancheng@gmail.com
    local TXT=
    TXT=$(
        cat <<EOF
# alpine-mysql

## desc

a docker image base on alpine with mysql

## how to use with developer?

### define config
\`\`\`
cat >tool/hub_list.txt <<EOF
#repo-owner-pass
#hub.docker.com=your user =your pass
registry.cn-hangzhou.aliyuncs.com=xxx=xxx
 EOF
\`\`\`


\`\`\`
cat >tool/img_list.txt <<EOF
#name-label=name-label
mysql-alpine-3.8.4=mysql-alpine-3.8.4
mysql-alpine-3.9.4=mysql-alpine-3.9.4
#mysql-alpine-3.10.3=mysql-alpine-3.10.3
 EOF
\`\`\`


### build image
build the image with your config
\`\`\`
./tool/build.sh
\`\`\`

it will build image mysql:alpine-3.8.4 and mysql:alpine-3.9.4 .

then tag image for docker hub registry.cn-hangzhou.aliyuncs.com ,so there will be:
\`\`\`
registry.cn-hangzhou.aliyuncs.com/mysql:alpine-3.8.4
registry.cn-hangzhou.aliyuncs.com/mysql:alpine-3.9.4
\`\`\`

the mysql:alpine-3.10.3 will not be build with \`#\` comment.

the hub.docker.com will not be tag with \`#\` comment.


### test image
test the image you build
\`\`\`
./tool/test.sh
\`\`\`

it will test image mysql:alpine-3.8.4 and mysql:alpine-3.9.4 .

### push image

push the image to some docker hub ,eg. docker hub ,aliyun,qiniu ...
\`\`\`
./tool/push.sh
\`\`\`

it will push image :
\`\`\`
registry.cn-hangzhou.aliyuncs.com/mysql:alpine-3.8.4
registry.cn-hangzhou.aliyuncs.com/mysql:alpine-3.9.4
\`\`\`

so that you need to set pass in tool/hub_list.txt . and for secure dont let other know it.

## how to use with production ?

### pull image with docker cli
\`\`\`
tag=registry.cn-hangzhou.aliyuncs.com/yemiancheng/mysql:alpine-X.X.X
docker pull "\$tag"
\`\`\`

### run image with docker cli
\`\`\`
docker run -d --name mysql -p 3306:3306 -v \$(pwd):/app -e MYSQL_DATABASE=admin -e MYSQL_USER=huahua -e MYSQL_PASSWORD=MjAxOS -e MYSQL_ROOT_PASSWORD=jo1NQo "\$tag"
\`\`\`

note:in the .env file , you can change the different values to suit your needs.

### uses with a dockerfile 
\`\`\`
FROM registry.cn-hangzhou.aliyuncs.com/yemiancheng/mysql:alpine-3.9.4
\`\`\`

your can run with docker cli :
\`\`\`
docker run -v /mysql/data/:/var/lib/mysql -d -p 3306:3306 --name mysql-alpine-3.9.4 where/your/dockerfile
\`\`\`

or your can run with docker-compose ,

or your can run with k8s .

## building log

\`\`\`
ok:mysql-10.3.18-alpine-3.10.3
ok:mysql-10.3.17-alpine-3.9.4
ok:mysql-10.2.26-alpine-3.8.4
ok:mysql-10.1.41-alpine-3.7.3
\`\`\`

EOF
    )
    #TXT=$(echo "$TXT" | sed "s/^ *#.*//g" | sed "/^$/d")
    echo "$TXT"
}

function add_gitignore() {
    local TXT=
    TXT=$(
        cat <<EOF
mysql
tool/hub_list.txt
tool/img_list.txt
EOF
    )
    TXT=$(echo "$TXT" | sed "s/^ *#.*//g" | sed "/^$/d")
    echo "$TXT"
}

function main_fun() {
    local path=
    local TXT=
    local file=

    path="$THIS_PROJECT_PATH"
    #path="/d/code-store/mirros/mysql"
    mkdir -p "$path"
    file="$path/Dockerfile"
    echo "gen Dockerfile :$file"
    TXT=$(add_dockerfile)
    TXT=$(echo "$TXT" | sed "s/^ *#.*//g" | sed "/^$/d")
    echo "$TXT" >"$file"

    file="$path/.dockerignore"
    echo "gen .dockerignore :$file"
    TXT=$(add_dockerignore)
    TXT=$(echo "$TXT" | sed "s/^ *#.*//g" | sed "/^$/d")
    echo "$TXT" >"$file"

    file="$path/my.cnf"
    echo "gen my.cnf :$file"
    TXT=$(add_myconf)
    TXT=$(echo "$TXT" | sed "s/^ *#.*//g" | sed "/^$/d")
    echo "$TXT" >"$file"

    file="$path/license"
    echo "gen license :$file"
    TXT=$(add_license)
    TXT=$(echo "$TXT" | sed "s/^ *#.*//g" | sed "/^$/d")
    echo "$TXT" >"$file"

    file="$path/readme.md"
    echo "gen readme.md :$file"
    TXT=$(add_readme)
    #TXT=$(echo "$TXT" | sed "s/^ *#.*//g" | sed "/^$/d")
    echo "$TXT" >"$file"

    file="$path/.gitignore"
    echo "gen .gitignore :$file"
    TXT=$(add_gitignore)
    TXT=$(echo "$TXT" | sed "s/^ *#.*//g" | sed "/^$/d")
    echo "$TXT" >"$file"
}

main_fun

#### usage
#./tool/init.sh

#https://github.com/search?q=alpine+mysql&type=Repositories
#https://hub.docker.com/_/mysql/
