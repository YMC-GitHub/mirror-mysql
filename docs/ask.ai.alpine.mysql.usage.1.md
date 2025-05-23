- 在 Docker 中部署基于 Alpine 系统的 MySQL 服务的详细指南，涵盖了使用 Dockerfile 构建镜像、支持不同网络环境、初始化数据导入，以及数据导入、导出、备份和还原操作指南，同时提供了 Docker CLI、Docker Compose 和 Kubernetes（K8s）的部署手册。

## 1. Dockerfile 构建指南

## 2. 网络环境配置

## 3. 数据初始化

将 SQL 脚本放入`sql-init/`目录，容器启动时会自动执行：

- `00-schema.sql`：数据库结构
- `01-seed-data.sql`：初始数据

## 4. 数据操作指南

### 导出数据

```bash
docker exec -it mysql-container mysqldump -u root -p database > backup.sql
```

### 导入数据

```bash
docker exec -i mysql-container mysql -u root -p database < backup.sql
```

### 备份数据

```bash
docker exec mysql-container mysqldump -u root -p database | gzip > backup.sql.gz
```

### 还原数据

```bash
gunzip < backup.sql.gz | docker exec -i mysql-container mysql -u root -p database
```

## 5. 部署指南

### Docker CLI

```bash
docker build -t mysql-alpine .
docker run -d --name mysql \
  -e MYSQL_ROOT_PASSWORD=yourpassword \
  -v /path/to/data:/var/lib/mysql \
  -p 3306:3306 \
  mysql-alpine
```

### Docker Compose

```yaml:docker-compose.yml
version: '3'
services:
  mysql:
    image: mysql-alpine
    build: .
    environment:
      MYSQL_ROOT_PASSWORD: yourpassword
    volumes:
      - /path/to/data:/var/lib/mysql
    ports:
      - "3306:3306"
```

### Kubernetes

```yaml:mysql-deployment.yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: mysql
spec:
  replicas: 1
  template:
    spec:
      containers:
      - name: mysql
        image: mysql-alpine
        env:
        - name: MYSQL_ROOT_PASSWORD
          value: "yourpassword"
        ports:
        - containerPort: 3306
        volumeMounts:
        - mountPath: /var/lib/mysql
          name: mysql-data
      volumes:
      - name: mysql-data
        persistentVolumeClaim:
          claimName: mysql-pvc
```

## 6. 维护建议

1. 定期备份数据
2. 监控数据库性能
3. 使用持久化存储
4. 设置合理的资源限制
5. 定期更新镜像版本


<!-- 数据初始化指南、数据操作指南、部署指南、维护建议、-->