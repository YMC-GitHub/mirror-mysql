##  网络配置测试（可选）
```bash
docker run -d --name mysql-test \
  -e MYSQL_ROOT_PASSWORD=yourpassword \
  -e NETWORK_REGION=cn \
  -v /path/to/local/data:/var/lib/mysql \
  -p 3306:3306 \
   mysql-alpine:cn-latest
```

##  性能测试（可选）
使用sysbench等工具进行性能测试：
```bash
sysbench oltp_read_write --db-driver=mysql \
  --mysql-host=127.0.0.1 --mysql-port=3306 \
  --mysql-user=root --mysql-password=yourpassword \
  --mysql-db=test_db prepare
```