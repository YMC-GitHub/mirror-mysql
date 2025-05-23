- 基于 `"Dockerfile-alpine"`、`setup-alpine-mysql-entrypoint.sh` 和 `sql-init` 目录的使用文档说明，包含数据初始化设计，用户使用示例、研发人员维护示例等。

---

## 数据初始化设计文档

### 1. 概述
本项目使用 Docker 容器化 MySQL 服务，并通过 SQL 文件初始化数据库结构和数据。主要设计如下：
- **`Dockerfile-alpine`**：定义容器镜像的构建过程。
- **`setup-alpine-mysql-entrypoint.sh`**：负责 MySQL 服务的启动和初始化。
- **`sql-init` 目录**：存放初始化数据库的 SQL 文件。

### 2. 数据初始化流程
1. **容器启动时**：
   - 执行 `setup-alpine-mysql-entrypoint.sh` 脚本。
   - 初始化 MySQL 用户、目录和数据库。
   - 执行 `/docker-entrypoint-initdb.d/` 目录中的 SQL 文件，完成数据库结构和数据的初始化。

2. **SQL 文件执行顺序**：
   - 按文件名排序执行，例如 `00-schema.sql` 先于 `01-seed-data.sql` 执行。

### 3. 用户使用示例

#### 3.1 构建镜像
```bash
docker build -t mysql-alpine .
```

#### 3.2 运行容器
```bash
docker run -d \
  --name mysql-alpine \
  -e MYSQL_ROOT_PASSWORD=yourpassword \
  -e MYSQL_DATABASE=app_db \
  -e MYSQL_USER=app_user \
  -e MYSQL_PASSWORD=userpass \
  -p 3306:3306 \
  mysql-alpine
```

#### 3.3 验证数据初始化
```bash
docker exec -it mysql-alpine mysql -u root -p
```
执行以下 SQL 查询验证数据：
```sql
USE app_db;
SELECT * FROM users;
SELECT * FROM orders;
```

#### 3.4 删除容器
```bash
docker rm -f mysql-alpine
```
#### 3.5 删除镜像
```bash
docker rmi mysql-alpine
```

### 4. 研发人员维护示例

#### 4.1 添加新的 SQL 文件
1. 在 `sql-init` 目录中创建新的 SQL 文件，例如 `02-additional-data.sql`。
2. 确保文件名按执行顺序命名（如 `00-`、`01-`、`02-`）。

#### 4.2 修改现有 SQL 文件
1. 编辑 `sql-init` 目录中的 SQL 文件，例如 `00-schema.sql` 或 `01-seed-data.sql`。
2. 重新构建镜像并运行容器以应用更改。

#### 4.3 调试初始化脚本
1. 进入容器：
   ```bash
   docker exec -it mysql-alpine /bin/sh
   ```
2. 查看日志：
   ```bash
   cat /var/log/mysql/error.log
   ```

### 5. 目录结构说明
- **`sql-init/00-schema.sql`**：创建数据库和表结构。
- **`sql-init/01-seed-data.sql`**：插入初始数据。
- **`/docker-entrypoint-initdb.d/`**：容器中用于存放初始化 SQL 文件的目录。

### 6. 注意事项
- **SQL 文件顺序**：确保文件名按执行顺序命名，例如 `00-schema.sql` 先于 `01-seed-data.sql`。
- **数据持久化**：使用 Docker 数据卷（`/var/lib/mysql`）确保数据持久化。
- **安全性**：避免在 SQL 文件中硬编码敏感信息，使用环境变量传递。

---

通过以上文档，用户可以快速理解和使用数据初始化功能，研发人员也能高效维护和扩展初始化逻辑。