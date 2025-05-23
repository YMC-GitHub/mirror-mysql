## 当前环境
- 环境：win11
- 工具：scoop 安装docker 客户端有关工具。
- 问题：
  - 在win中搭建wsl（使用ubuntu22），在wsl中使用原生docker，在win中使用scoop 安装docker 客户端有关工具。

<!-- - 在wsl 中检查docker 正常，在 win 中检查存在问题。当前环境：在win中搭建wsl（使用ubuntu22），在wsl中使用原生docker，在win中使用scoop 安装docker 客户端有关工具。 -->


根据你的描述，问题可能出在 Windows 和 WSL 之间的 Docker 配置不一致。以下是排查和解决问题的步骤：

## 检查 Docker 上下文配置 | win
在 Windows 中，确保 Docker 上下文指向正确的 Docker 守护进程：

```powershell
# 列出所有上下文
docker context ls

# 如果默认上下文不是 WSL，切换到 WSL 的上下文
# docker context use <wsl-context-name>
docker context use wsl
```


## 检查 Docker 守护进程状态 | wsl
在 WSL 中检查 Docker 守护进程状态：

```bash
# 检查 Docker 服务状态
sudo service docker status

# 如果未运行，启动 Docker 服务
sudo service docker start
```

## 配置 Windows Docker 客户端连接 WSL 的 Docker 守护进程 | win
在 Windows 中配置 Docker 客户端连接到 WSL 的 Docker 守护进程：

```powershell
# 获取 WSL 的 IP 地址
wsl hostname -I
# 192.168.0.105 172.17.0.1

# 设置 DOCKER_HOST 环境变量
# $env:DOCKER_HOST = "tcp://<wsl-ip>:2375"


$wsl_ip=(wsl hostname -I).Split()[0];$wsl_ip;
# 192.168.0.105 是 WSL 2 的虚拟网络接口 IP 地址，用于与 Windows 主机通信。你应该使用这个 IP 地址来配置 Docker 客户端连接。
# 172.17.0.1 是 Docker 默认的桥接网络接口 IP 地址，用于容器之间的通信。这个 IP 地址不需要在 Windows 中配置。
# $env:DOCKER_HOST = "tcp://${wsl_ip}:2375"

# 永久设置 DOCKER_HOST
# [System.Environment]::SetEnvironmentVariable('DOCKER_HOST', 'tcp://${wsl_ip}:2375', [System.EnvironmentVariableTarget]::User)

# use envedit cli to set env variable in rust
envedit set DOCKER_HOST "tcp://${wsl_ip}:2375"
envedit get DOCKER_HOST

```

## 验证连接 | win
在 Windows 中验证是否能够连接到 WSL 的 Docker 守护进程：

```powershell
# 检查 Docker 版本
docker --version

# 列出运行中的容器
docker ps
```

## 持久化配置 | win
为了确保每次启动时都能正确连接，可以将配置添加到 Windows 的环境变量中：

```powershell
# 永久设置 DOCKER_HOST
[System.Environment]::SetEnvironmentVariable('DOCKER_HOST', 'tcp://<wsl-ip>:2375', [System.EnvironmentVariableTarget]::User)
```

完成这些步骤后，你应该能够在 Windows 中正常使用 Docker 客户端连接到 WSL 中的 Docker 守护进程。如果问题仍然存在，请提供具体的错误信息以便进一步排查。