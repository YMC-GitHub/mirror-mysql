## 使用示例 | Docker CLI
构建镜像
```bash
docker build -t my-mysql-alpine -f Dockerfile-alpine .
```

运行容器
```bash
docker run -d -p 3306:3306 \
  -e MYSQL_ROOT_PASSWORD=your_root_password \
  --name my-mysql-container \
  my-mysql-alpine
```

## 使用示例 | Docker Compose
创建 `docker-compose.yml` 文件：
```yaml
version: '3'
services:
  mysql:
    build:
      context: .
      dockerfile: Dockerfile-alpine
    environment:
      MYSQL_ROOT_PASSWORD: your_root_password
    ports:
      - "3306:3306"
    volumes:
      - mysql_data:/var/lib/mysql

volumes:
  mysql_data:
```
启动服务：
```bash
docker-compose up -d
```

## 使用示例 | Kubernetes (K8s)
创建 `mysql-deployment.yaml` 文件：
```yaml
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
          value: your_root_password
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

## 使用示例 | k8s | Helm
创建 Helm Chart：
```bash
helm create mysql-chart
```
编辑相关文件后安装：
```bash
helm install my-mysql mysql-chart
```

