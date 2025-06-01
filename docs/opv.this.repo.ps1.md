
```plaintext
文件迁移：
将ask.ai.db.sql.nf.*.md 迁移到 {repo}/docs
将sql-design/* 迁移到 {repo}/sql-design
repo 位置 d:/code/mysql-db-design

创建新的git repo。新的repo位置为当前repo的上级目录 
git init

git remote add ghg git@github.com:ymc-github/mysql-db-design.git
git push --mirror origin


# - 文件迁移，您认为使用ps,bash,typescript,python,go,rust,java，哪个好
```

```powershell

function Migrate-RepoFiles {
    param (
        [string]$SourceRepo = "d:\code\mysql-docker",
        [string]$TargetRepo = "d:\code\mysql-db-design"
    )

    # 创建目标目录结构
    if (!(Test-Path -Path "$TargetRepo\docs")) {
        New-Item -ItemType Directory -Path "$TargetRepo\docs" | Out-Null
    }
    if (!(Test-Path -Path "$TargetRepo\sql-design")) {
        New-Item -ItemType Directory -Path "$TargetRepo\sql-design" | Out-Null
    }

    # 迁移文档文件
    $docFiles = Get-ChildItem -Path "$SourceRepo\docs\ask.ai.db.sql.nf.*.md"
    foreach ($file in $docFiles) {
        Move-Item -Path $file.FullName -Destination "$TargetRepo\docs" -Force
        Write-Host "已迁移文档: $($file.Name)"
    }

    # 迁移SQL设计文件
    $sqlFiles = Get-ChildItem -Path "$SourceRepo\sql-design\*"
    foreach ($file in $sqlFiles) {
        Move-Item -Path $file.FullName -Destination "$TargetRepo\sql-design" -Force
        Write-Host "已迁移SQL文件: $($file.Name)"
    }

    # 初始化Git仓库
    if (!(Test-Path -Path "$TargetRepo\.git")) {
        Set-Location -Path $TargetRepo
        git init | Out-Null
        git remote add origin git@github.com:ymc-github/mysql-db-design.git
        Write-Host "Git仓库已初始化并设置远程仓库"
    }

    Write-Host "文件迁移完成！目标位置: $TargetRepo"
}

# 使用示例
Migrate-RepoFiles
# 或指定自定义路径
# Migrate-RepoFiles -SourceRepo "d:\custom\source" -TargetRepo "d:\custom\target"

# trae d:/code/mysql-db-design
```