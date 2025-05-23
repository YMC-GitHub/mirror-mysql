- 在本地构建和测试 Alpine 版 MySQL 镜像的完整步骤，包含详细的验证方法.

### 1. 准备测试环境

```bash
# 克隆仓库（或使用现有项目）
git clone your-repo-url
cd your-repo

# 确保已安装 Docker
docker --version  # 需要 Docker 20.10+
```

### 2. 本地构建镜像（中国网络版）

```bash
rm -f Dockerfile;cp Dockerfile-alpine Dockerfile

# 构建 cn 版本
docker build \
  --build-arg NETWORK_REGION=cn \
  -t mysql-alpine:cn-latest .

# 构建 global 版本（对比测试）
docker build \
  --build-arg NETWORK_REGION=global \
  -t mysql-alpine:global-latest .
```

### 3. 运行容器测试

#### 中国网络版测试：

```bash
docker run -d \
  --name mysql-cn \
  -p 3306:3306 \
  -e MYSQL_ROOT_PASSWORD=test123 \
  -e NETWORK_REGION=cn \
  -v ./sql-init:/docker-entrypoint-initdb.d \
  mysql-alpine:cn-latest
```

#### 国际网络版测试：

```bash
docker run -d \
  --name mysql-global \
  -p 3307:3306 \
  -e MYSQL_ROOT_PASSWORD=test123 \
  -e NETWORK_REGION=global \
  -v ./sql-init:/docker-entrypoint-initdb.d \
  mysql-alpine:global-latest
```

### 4. 验证网络配置

```bash
# 检查中国版的网络配置
docker exec mysql-cn cat /etc/resolv.conf
# 应显示 223.5.5.5 等国内DNS

# 检查国际版的网络配置
docker exec mysql-global cat /etc/resolv.conf
# 应显示 8.8.8.8 等国际DNS

# 测试网络连通性（中国版）
docker exec mysql-cn ping -c 2 baidu.com

# 测试网络连通性（国际版）
docker exec mysql-global ping -c 2 google.com
```

### 5. 数据库功能测试

```bash
# 连接中国版数据库
docker exec -it mysql-cn mysql -uroot -ptest123

# 执行测试命令
> SHOW VARIABLES LIKE '%version%';
> CREATE DATABASE test_cn;
> USE test_cn;
> CREATE TABLE t1 (id INT PRIMARY KEY, name VARCHAR(20));
> INSERT INTO t1 VALUES (1, '测试数据');
> SELECT * FROM t1;
> EXIT;

# 验证初始化脚本
docker logs mysql-cn | grep "Initializing database"
```

### 6. 数据持久化测试

```bash
# 创建持久化卷
docker volume create mysql-cn-data

# 运行带持久化的容器
docker run -d \
  --name mysql-cn-persistent \
  -p 3308:3306 \
  -e MYSQL_ROOT_PASSWORD=test123 \
  -v mysql-cn-data:/var/lib/mysql \
  mysql-alpine:cn-latest

# 创建测试数据
docker exec -i mysql-cn-persistent mysql -uroot -ptest123 <<EOF
CREATE DATABASE persistent_db;
USE persistent_db;
CREATE TABLE persistent_data (id INT PRIMARY KEY);
INSERT INTO persistent_data VALUES (1);
EOF

# 删除容器后重新创建验证数据
docker stop mysql-cn-persistent
docker rm mysql-cn-persistent
docker run -d \
  --name mysql-cn-new \
  -p 3308:3306 \
  -e MYSQL_ROOT_PASSWORD=test123 \
  -v mysql-cn-data:/var/lib/mysql \
  mysql-alpine:cn-latest

# 验证数据存在
docker exec -i mysql-cn-new mysql -uroot -ptest123 -e "SELECT * FROM persistent_db.persistent_data"
```

### 7. 性能测试对比

```bash
# 中国版性能测试
time docker exec mysql-cn \
  mysql -uroot -ptest123 -e "SELECT BENCHMARK(1000000,ENCODE('hello',RAND()));"

# 国际版性能测试
time docker exec mysql-global \
  mysql -uroot -ptest123 -e "SELECT BENCHMARK(1000000,ENCODE('hello',RAND()));"
```

### 8. 清理测试环境

```bash
# 停止并删除所有测试容器
docker stop mysql-cn mysql-global mysql-cn-new
docker rm mysql-cn mysql-global mysql-cn-new

# 删除测试镜像
docker rmi mysql-alpine:cn-latest mysql-alpine:global-latest

# 保留数据卷（如需完全清理）
docker volume rm mysql-cn-data
```

### 测试用例表格

| 测试项目   | 中国版预期结果 | 国际版预期结果 |
| ---------- | -------------- | -------------- |
| 镜像大小   | ≤160MB         | ≤150MB         |
| 启动时间   | <10 秒         | <10 秒         |
| DNS 配置   | 223.5.5.5      | 8.8.8.8        |
| 百度 PING  | 可通           | 可能超时       |
| GooglePING | 可能超时       | 可通           |
| 初始化脚本 | 执行成功       | 执行成功       |
| 数据持久化 | 重启保留数据   | 重启保留数据   |

### 常见问题排查

1. **初始化脚本未执行**：

   ```bash
   # 检查脚本权限
   chmod +x sql-init/*.sh

   # 查看日志
   docker logs mysql-cn | grep -i "init"
   ```

2. **网络连接失败**：

   ```bash
   # 进入容器检查网络
   docker exec -it mysql-cn ash
   ping baidu.com
   nslookup baidu.com
   ```

3. **时区不正确**：

   ```bash
   # 检查容器时间
   docker exec mysql-cn date
   # 如果不对，重建镜像时添加：
   # RUN apk add tzdata && cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime
   ```

4. **性能问题**：
   ```bash
   # 查看容器资源使用
   docker stats mysql-cn
   ```

通过以上完整的本地测试流程，您可以全面验证镜像的功能性、网络适应性和数据持久化能力。测试通过后再推送到 GitHub 触发自动化构建流程。

### 检查构建日志

### 验证镜像内容

```bash
# 检查构建日志
docker build --progress=plain --build-arg NETWORK_REGION=cn -t mysql-alpine:cn-latest .


# 验证镜像内容

# 检查 apk repos 设置
docker run --rm mysql-alpine:cn-latest cat /etc/apk/repositories

# 检查默认DNS配置
docker run --rm mysql-alpine:cn-latest  cat /etc/resolv.conf
```
