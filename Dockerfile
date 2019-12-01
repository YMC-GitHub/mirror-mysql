FROM alpine:3.7.3
LABEL MAINTAINER="ymc-github <yemiancheng@gmail.com>"
ENV TIMEZONE Asia/Shanghai
WORKDIR /app/shell/install-mysql
VOLUME [ "/var/lib/mysql" ]
COPY startup.sh ./startup.sh
RUN apk add --update mysql mysql-client && rm -f /var/cache/apk/* && addgroup mysql mysql
COPY my.cnf /etc/mysql/my.cnf
EXPOSE 3306
CMD ["./startup.sh"]
