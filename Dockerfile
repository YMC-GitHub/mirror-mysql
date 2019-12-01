FROM alpine:3.7.3
LABEL MAINTAINER="ymc-github <yemiancheng@gmail.com>"
ENV TIMEZONE Asia/Shanghai
WORKDIR /app
VOLUME [ "/app" ]
COPY startup.sh /startup.sh
RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.aliyun.com/g' /etc/apk/repositories && apk add --update mysql mysql-client && rm -f /var/cache/apk/* && addgroup mysql mysql
COPY my.cnf /etc/mysql/my.cnf
EXPOSE 3306
CMD ["/startup.sh"]
