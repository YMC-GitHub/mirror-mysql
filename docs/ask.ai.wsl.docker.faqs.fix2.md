## 端口被占用 | 3306
```
docker: Error response from daemon: driver failed programming external connectivity on endpoint mysql-test (f4fc921be4556027c52b76dbbd4cb8211e47a995987bc963835ebae0249a7aaf): Error starting userland proxy: listen tcp4 0.0.0.0:3306: bind: address already in use.
```

## Check which process is using port 3306 | wsl
```bash
sudo lsof -i :3306

# mysqld  1253 mysql   18u  IPv6  37097      0t0  TCP *:mysql (LISTEN)
```


## Check which process is using port 3306 | win
```powershell
netstat -ano | findstr :3306
#   TCP    [::1]:3306             [::]:0                 LISTENING       9744
```

## Stop the conflicting process | wsl
```bash
sudo kill -9 1253
```

## Stop the conflicting process | win
```powershell
taskkill /F /PID 9744
```

## Use a different port
```bash
docker run --rm --env-file .env -d --name mysql-test -p 3307:3306 zero-mysql-alpine:cn
```

## list all containers with ports | win or wsl
```bash
docker ps --format "table {{.ID}}\t{{.Names}}\t{{.Status}}\t{{.Ports}}"
```

## list all processes with ports | wsl

```bash
sudo netstat -tulpn | grep LISTEN
```

## list all processes with ports | win

```bash
netstat -aon | findstr LISTENING
```