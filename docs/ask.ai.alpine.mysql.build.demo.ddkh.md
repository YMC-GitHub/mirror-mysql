- 请提供构建时的使用示例。尽可能详细，如包含自定变量。

## 使用 Docker CLI 构建
### 基本构建
```bash
docker build -t my-mysql-alpine -f Dockerfile-alpine .
```

### 自定义构建参数
```bash
docker build -t my-mysql-alpine -f Dockerfile-alpine . \
  --build-arg NETWORK=global \
  --build-arg APK_REPO_CN=mirrors.tuna.tsinghua.edu.cn
```

## 使用 Docker Compose 构建
创建 `docker-compose.yml` 文件：
```yaml:docker-compose.yml
version: '3'
services:
  mysql:
    build:
      context: .
      dockerfile: Dockerfile-alpine
      args:
        NETWORK: ${NETWORK_REGION}
        APK_REPO_CN: ${APK_REPO}
    environment:
      MYSQL_ROOT_PASSWORD: ${MYSQL_ROOT_PASSWORD}
      MYSQL_DATABASE: ${MYSQL_DATABASE}
      MYSQL_USER: ${MYSQL_USER}
      MYSQL_PASSWORD: ${MYSQL_PASSWORD}
    ports:
      - "3306:3306"
    volumes:
      - mysql_data:/var/lib/mysql

volumes:
  mysql_data:
```
启动服务：
```bash
docker-compose --env-file .env up -d
```

## 使用 Kubernetes (K8s) 构建
创建 `mysql-deployment.yaml` 文件：
```yaml:mysql-deployment.yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: mysql-deployment
spec:
  replicas: 1
  selector:
    matchLabels:
      app: mysql
  template:
    metadata:
      labels:
        app: mysql
    spec:
      containers:
      - name: mysql
        image: my-mysql-alpine
        env:
        - name: MYSQL_ROOT_PASSWORD
          value: "123456"
        - name: MYSQL_DATABASE
          value: "testdb"
        - name: MYSQL_USER
          value: "testuser"
        - name: MYSQL_PASSWORD
          value: "testpassword"
        ports:
        - containerPort: 3306
        volumeMounts:
        - name: mysql-data
          mountPath: /var/lib/mysql
      volumes:
      - name: mysql-data
        persistentVolumeClaim:
          claimName: mysql-pvc

---
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: mysql-pvc
spec:
  accessModes:
    - ReadWriteOnce
  resources:
    requests:
      storage: 1Gi

---
apiVersion: v1
kind: Service
metadata:
  name: mysql-service
spec:
  selector:
    app: mysql
  ports:
    - protocol: TCP
      port: 3306
      targetPort: 3306
  type: LoadBalancer
```
部署到 Kubernetes 集群：
```bash
kubectl apply -f mysql-deployment.yaml
```

## 4使用 Helm 构建
创建 Helm Chart：
```bash
helm create mysql-chart
```
编辑 `mysql-chart/values.yaml` 文件：
```yaml:mysql-chart/values.yaml
replicaCount: 1

image:
  repository: my-mysql-alpine
  pullPolicy: IfNotPresent
  tag: ""

mysql:
  rootPassword: "123456"
  database: "testdb"
  user: "testuser"
  password: "testpassword"

service:
  type: LoadBalancer
  port: 3306

persistence:
  size: 1Gi
```
安装 Helm Chart：
```bash
helm install my-mysql mysql-chart
```
