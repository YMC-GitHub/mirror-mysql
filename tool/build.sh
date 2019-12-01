#!/bin/sh

THIS_FILE_PATH=$(
    cd $(dirname $0)
    pwd
)
source $THIS_FILE_PATH/function-list.sh
THIS_PROJECT_PATH=$(path_resolve "$THIS_FILE_PATH" "../")
RUN_SCRIPT_PATH=$(pwd)
function parse_img_name_label() {
    local val=
    local length=
    local index=
    val="mysql-alpine-3.9.4"
    if [ -n "${1}" ]; then
        val="${1}"
    fi
    #echo "$val"
    name=$(echo $val | awk -F'-' '{print $1}')
    #label=$(echo $val | awk -F'-' '{print $2}')
    length=$(echo "$val" | awk '{print length($0)}')
    index=$(awk -v a="$val" -v b="-" 'BEGIN{print index(a,b)}')
    label=$(echo $val | cut -b $index-$length | sed "s/^-//g")
    #echo "$length,$index,$label"
    echo "name=$name label=$label"
}
function update_dockerfile_base_img() {
    local val=
    local file=
    if [ -n "${1}" ]; then
        val="${1}"
    fi
    file=$(cat "${THIS_PROJECT_PATH}/Dockerfile")
    file=$(echo "$file" | sed "s/FROM .*/FROM $val/")
    key=$(echo "$file" | grep "FROM alpine")
    echo "$file" >"${THIS_PROJECT_PATH}/Dockerfile"
}
function build_image() {
    local name=
    local label=
    name=mysql
    label=alpine
    if [ -n "${1}" ]; then
        name="${1}"
    fi
    if [ -n "${2}" ]; then
        label="${2}"
    fi
    tag="$name:$label"
    #echo "build image $tag"
    docker build --tag "$tag" "$THIS_PROJECT_PATH"
}
#name=label
#build_image

function remove_image() {
    local name=
    local label=
    name=mysql
    label=alpine
    if [ -n "${1}" ]; then
        name="${1}"
    fi
    if [ -n "${2}" ]; then
        label="${2}"
    fi
    tag="$name:$label"
    #echo "build image $tag"
    docker image rm --force "$tag"
}

function local_delete_image_by_tag() {
    local list=
    local REG_SHELL_COMMOMENT_PATTERN=
    local list_ARR=
    local var=
    local key=
    local tag=
    tag=test
    if [ -n "${1}" ]; then
        tag="${1}"
    fi
    list=$(docker image ls --format " {{.ID}}={{.Repository}}" | grep "$tag")
    REG_SHELL_COMMOMENT_PATTERN="^#"
    list_ARR=(${list//,/ })
    for var in ${list_ARR[@]}; do
        if [[ "$var" =~ $REG_SHELL_COMMOMENT_PATTERN ]]; then
            echo "$var" >/dev/null 2>&1
        else
            key=$(echo "$var" | cut -d "=" -f1 | tr "[:upper:]" "[:lower:]")
            echo "rm pratice image $key"
            docker image rm --force "$key"
        fi
    done
}

function main_func() {
    list=$(echo "$list" | sed "s/^#.*//g" | sed "/^$/d")
    local temp=
    for val in $list; do
        val=$(echo $val | awk -F'=' '{print $2}')
        parse_img_name_label "$val"
        # 更新文件
        temp=$(echo $label | sed "s/-/:/")
        #echo "$temp"
        echo "update dockerfile base image with $temp"
        update_dockerfile_base_img "$temp"
        # 删除镜像
        echo "remove image $name:$label"
        #remove_image "$name" "$label"
        #local_delete_image_by_tag "reg.qiniu.com/yemiancheng/mysql"
        local_delete_image_by_tag "$name:$label"
        # 构建镜像
        echo "build image $name:$label"
        build_image "$name" "$label"

    done
}

list=
name=
label=
list=$(
    cat <<EOF
#name-label=name-label
mysql-alpine-3.7.3=mysql-alpine-3.7.3
mysql-alpine-3.8.4=mysql-alpine-3.8.4
mysql-alpine-3.9.4=mysql-alpine-3.9.4
mysql-alpine-3.10.3=mysql-alpine-3.9.4
EOF
)
main_func
