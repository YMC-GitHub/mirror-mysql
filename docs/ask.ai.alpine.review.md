- 如何通过docker cli 查看dockerfile
- 如何通过docker build 时将dockerfile作为label
- 如何通过docker cli 查看dockerfile 的author信息
- 如何通过docker cli 检查mysql 是否正常

## 查看dockerfile 的author信息
```bash
docker inspect --format='{{index .Config.Labels "org.opencontainers.image.authors"}}' mysql-alpine
```


## label dockerfile
- 构建镜像时将dockerfile作为label，可以通过docker inspect 查看。
```bash
# 添加 DOCKERFILE LABEL
docker build -t my-image --label "dockerfile=$(cat Dockerfile | base64)" .

# 查看 DOCKERFILE LABEL
docker inspect my-image --format '{{index .Config.Labels "dockerfile"}}' | base64 -d
```