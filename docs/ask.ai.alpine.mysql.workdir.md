## mysql 服务工作目录 | 脚本化
- 您觉得使用什么目录更合适，参考语义化等 ？

根据语义化和最佳实践，`/app` 作为工作目录可能不太适合 MySQL 容器。以下是更合适的建议：

1. **`/var/lib/mysql`**：
   - 这是 MySQL 默认的数据存储目录，与 `MYSQL_DATA_DIR` 环境变量一致
   - 语义上更明确，直接表明这是 MySQL 数据存储的位置
   - 符合 MySQL 官方镜像的惯例

2. **`/opt/mysql`**：
   - `/opt` 通常用于存放第三方应用程序
   - 语义上表明这是 MySQL 的安装目录
   - 适合存放配置文件或自定义脚本

3. **`/usr/local/mysql`**：
   - `/usr/local` 通常用于本地安装的软件
   - 语义上表明这是 MySQL 的安装位置
   - 适合存放与 MySQL 相关的文件

推荐使用 `/var/lib/mysql`，因为它与 MySQL 的默认数据目录一致，语义更清晰，且符合官方镜像的惯例。修改如下：

```Dockerfile
# ... existing code ...

# 工作目录
WORKDIR /var/lib/mysql

# ... existing code ...
```

这样修改的好处：
1. 语义更明确，直接关联到 MySQL 数据存储
2. 与 `MYSQL_DATA_DIR` 环境变量一致，避免混淆
3. 符合 MySQL 官方镜像的惯例，便于理解和维护