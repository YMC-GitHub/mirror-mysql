# 使用 GitHub CLI (gh) 重命名仓库

GitHub CLI (`gh`) 提供了简单的方式来重命名仓库。以下是完整步骤：

## 前提条件
1. 已安装 [GitHub CLI](https://cli.github.com/)
2. 已通过 `gh auth login` 登录
3. 有仓库的管理员权限

## 重命名仓库步骤

### 1. 查看当前仓库信息
```bash
gh repo view
```

### 2. 重命名仓库
```bash
gh repo rename <新仓库名>
```
或者直接在当前仓库目录执行：
```bash
gh repo rename
```
然后按提示输入新名称

### 3. 确认重命名
系统会提示确认操作：
```
? Rename repository from <旧仓库名> to <新仓库名>? (Y/n)
```
按 `Y` 确认

## 重命名后的本地仓库更新

重命名后，远程仓库URL会改变，需要更新本地git配置：

```bash
git remote set-url origin https://github.com/<用户名>/<新仓库名>.git
```

## 注意事项

1. **影响**：
   - 所有克隆链接会改变
   - 已有的GitHub Pages URL会改变
   - 引用旧仓库名的API请求会失效

2. **权限要求**：
   - 必须是仓库管理员
   - 组织仓库可能需要组织所有者权限

3. **重命名限制**：
   - 新名称必须唯一（在用户/组织命名空间内）
   - 不能与已有仓库名冲突
   - 必须符合GitHub命名规则

## 替代方法（通过Web界面）

如果不想使用CLI，也可以在GitHub网站上操作：
1. 进入仓库 → Settings
2. 在"Danger Zone"部分点击"Rename this repository"
3. 输入新名称并确认

## 验证重命名是否成功

```bash
gh repo view
```
或访问新URL：
```
https://github.com/<用户名>/<新仓库名>
```