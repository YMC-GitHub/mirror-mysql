
## SQL 文件初始化 | 使用示例 

### 1. docker cli

通过环境变量 `INIT_SQL_FILES`，可以灵活控制是否执行 SQL 文件初始化，满足不同场景的需求。


- **默认执行 SQL 文件初始化**：
  ```bash
  docker run -d --name mysql-alpine mysql-alpine
  ```

- **跳过 SQL 文件初始化**：
  ```bash
  docker run -d --name mysql-alpine -e INIT_SQL_FILES=false mysql-alpine
  ```


### 2. Docker Compose 示例
  ```bash
  yours edit-yaml --file docker-compose.yaml --name "services.mysql.environment.INIT_SQL_FILES" --value "false" --type "string"
  ```

### 3. Kubernetes 示例
  ```bash
  yours edit-yaml --file mysql-deployment.yaml --name "spec.template.spec.containers[0].env[0].name" --value "INIT_SQL_FILES"
  yours edit-yaml --file mysql-deployment.yaml --name "spec.template.spec.containers[0].env[0].value" --value "false" --type "string"
  ```


### 3. Helm 示例
  ```bash
  yours edit-yaml --file values.yaml --name "mysql.initSqlFiles" --value "false"

  yours edit-yaml --file templates/deployment.yaml --name "spec.template.spec.containers[0].env[0].name" --value "INIT_SQL_FILES"
  yours edit-yaml --file templates/deployment.yaml --name "spec.template.spec.containers[0].env[0].value" --value "{{ .Values.mysql.initSqlFiles }}" --type "string"
  ```