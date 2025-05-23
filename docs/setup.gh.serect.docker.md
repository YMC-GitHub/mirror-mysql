## 环境变量配置文档 | github workflow 中发布镜像到 docker hub

1. 环境变量说明
在 "docker-publish-alpine.yml" 使用了以下环境变量：
- `REGISTRY`: Docker 镜像仓库地址，默认为 `docker.io`
- `IMAGE_NAME`: Docker 镜像名称，格式为 `用户名/镜像名`
- `DOCKERHUB_TOKEN`: Docker Hub 的访问令牌

2. 环境变量文件
在项目根目录下创建 `secrets/env.docker` 文件，内容如下：
```plaintext
DOCKERHUB_USERNAME=your_dockerhub_username
DOCKERHUB_TOKEN=your_dockerhub_token
```

3. 使用 GitHub CLI 提交环境变量
使用 GitHub CLI 将环境变量提交到 GitHub Secrets：

```bash
repo="ymc-github/mirror-mysql"

# gh secret set DOCKERHUB_USERNAME < secrets/env.docker
# gh secret set DOCKERHUB_TOKEN < secrets/env.docker
gh secret set --repo $repo  -f secrets/env.docker
```

4. 验证环境变量
可以使用以下命令验证环境变量是否设置成功：
```bash
# gh secret list
gh secret list --repo $repo
```

5. 注意事项
- 确保 `secrets/env.docker` 文件不被提交到版本控制中，可以在 `.gitignore` 中添加：
```plaintext
secrets/env.docker
```
- 环境变量中的 `DOCKERHUB_TOKEN` 需要具有足够的权限来推送镜像到 Docker Hub。

通过以上步骤，您可以正确配置和使用 中的环境变量。


## 环境变量配置文档 | 不同 docker hub 的环境敏感数据配置参考

- 提供发布到不同的docker hub的env.docker 配置文档，比如网易，阿里云，华为云。

1. 网易镜像仓库
```plaintext
DOCKER_REGISTRY=hub-mirror.c.163.com
DOCKERHUB_USERNAME=your_netease_username
DOCKERHUB_TOKEN=your_netease_token
MYSQL_ALPINE_IMAGE_NAME=mysql-alpine
```

2. 阿里云镜像仓库
```plaintext
DOCKER_REGISTRY=registry.aliyuncs.com
DOCKERHUB_USERNAME=your_aliyun_username
DOCKERHUB_TOKEN=your_aliyun_token
MYSQL_ALPINE_IMAGE_NAME=mysql-alpine
```

3. 华为云镜像仓库
```plaintext
DOCKER_REGISTRY=swr.cn-north-4.myhuaweicloud.com
DOCKERHUB_USERNAME=your_huawei_username
DOCKERHUB_TOKEN=your_huawei_token
MYSQL_ALPINE_IMAGE_NAME=mysql-alpine
```

4. Docker Hub
```plaintext
DOCKER_REGISTRY=docker.io
DOCKERHUB_USERNAME=your_dockerhub_username
DOCKERHUB_TOKEN=your_dockerhub_token
MYSQL_ALPINE_IMAGE_NAME=mysql-alpine
```

使用说明
1. **`DOCKER_REGISTRY`**：指定镜像仓库地址。
2. **`DOCKERHUB_USERNAME`**：镜像仓库的用户名。
3. **`DOCKERHUB_TOKEN`**：镜像仓库的访问令牌。
4. **`MYSQL_ALPINE_IMAGE_NAME`**：自定义镜像名称，默认为 `mysql-alpine`。
