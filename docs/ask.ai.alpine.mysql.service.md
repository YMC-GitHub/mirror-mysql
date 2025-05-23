## mysql 服务启动 | 语义化
- 让其更具有语义化，带有alpine,mysql,deps,setup等关键字?


为了让代码更具语义化，同时包含 `alpine`、`mysql`、`deps` 和 `setup` 等关键词，可以将 `startup-alpine.sh` 重命名为更具描述性的名称，例如 `setup-alpine-mysql-entrypoint.sh`。以下是修改方案：

```dockerfile
# ... existing code ...

# 启动命令
CMD ["setup-alpine-mysql-entrypoint.sh"]
```

修改说明：
1. 将 `startup-alpine.sh` 改为 `setup-alpine-mysql-entrypoint.sh`，明确包含了 `alpine`、`mysql`、`setup` 和 `entrypoint` 这些关键词。
2. 保持了原有的功能不变，但提高了代码的可读性和语义化程度。

同时，建议将 `scripts/startup-alpine.sh` 文件重命名为 `scripts/setup-alpine-mysql-entrypoint.sh`，以保持一致性。