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
FROM alpine:3.9.4
#FROM reg.qiniu.com/library/alpine:3.8
# 维护作者
MAINTAINER ${author} <${email}>
# 工作目录
WORKDIR /app
# 挂载目录
VOLUME /app
# 拷贝脚本
COPY startup.sh /startup.sh
# 安装软件mysql+清除安装记录
RUN apk add --update mysql mysql-client && rm -f /var/cache/apk/*
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

## build image
\`\`\`
tag=registry.cn-hangzhou.aliyuncs.com/yemiancheng/mysql:latest-alpine
docker build --tag "\$tag" .
\`\`\`

## run container
\`\`\`
docker run -it --rm -v \$(pwd):/app -p 3306:3306  "\$tag"
\`\`\`

## usage example

\`\`\`
docker run -it --name mysql -p 3306:3306 -v \$(pwd):/app -e MYSQL_DATABASE=admin -e MYSQL_USER=huahua -e MYSQL_PASSWORD=MjAxOS -e MYSQL_ROOT_PASSWORD=jo1NQo "\$tag"
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
tool/
mysql
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

    file="$path/my.conf"
    echo "gen my.conf :$file"
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
