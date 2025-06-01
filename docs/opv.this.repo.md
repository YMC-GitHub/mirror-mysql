## 版本管理

## gh - init repo
```bash
git config --global init.defaultBranch main
git init
# git branch -m main
```

## set git user name and email
```bash
git config --global user.name "yemiancheng"; git config --global user.email "ymc.github@gmail.com";
```

## opv - basic files
```bash
git add .dockerignore .editorconfig .gitattributes LICENSE README.md .env; git commit -m "build(core): init directory constructure";

```

## opv - docs
```bash

git add docs/*.md; git commit -m "docs(core): update docs";
git add docs/*.md; git commit -m "docs(core): update docs";

git add README.md; git commit -m "docs(core): set tags format in readme";
git add README.md; git commit -m "docs(core): put usage";

git add docs/opv*.md; git commit -m "docs(core): put note for opv.this.repo";

git add docs/*alpine.versions.md; git commit -m "docs(core): add alpine versions";
```

## opv - scripts
```bash
git add scripts/*.sh; git commit -m "build(core): init scripts"; 
git add scripts/*.sh; git commit -m "build(core): update scripts"; 
```

## opv - assets
```bash
git add assets/*.svg; git commit -m "assets(core): init assets"; 
git add assets/*.svg; git commit -m "assets(core): update assets"; 

```

## opv - secrets
```bash
git add secrets/*; git commit -m "build(core): init directory constructure";
```

## opv - sql-backup
```bash
git add sql-backup/*; git commit -m "build(core): init directory constructure";
```

## opv - sql-init
```bash
git add sql-init/*; git commit -m "build(core): init directory constructure";
```

## opv - sql-config
```bash
git add my.cnf; git commit -m "build(core): set mysqld config";
```

## opv - env files
```bash
git add .env ; git commit -m "build(core): use env file";
```

## opv - workflows fiels
```bash
git add .github/workflows/docker-publish-alpine.yml; git commit -m "build(core): init github workflows";
git add .github/workflows/docker-publish-alpine.yml; git commit -m "build(core): use Dockerfile-alpine";

git add .github/workflows/docker-publish-alpine.yml; git commit -m "build(core): use sql-init as path trigger and hand trigger";
git add .github/workflows/check-environment.yml; git commit -m "build(core): check environment";
git add .github/workflows/docker-publish-alpine.yml; git commit -m "build(core): fix runs-on";
git add .github/workflows/docker-publish-alpine.yml; git commit -m "build(core): del unused platforms";
git add .github/workflows/docker-publish-alpine.yml; git commit -m "build(core): fix image tags format";
git add .github/workflows/docker-publish-alpine.yml; git commit -m "build(core): allow this file as trigger (dryrun)";
git add .github/workflows/build.yml; git commit -m "build(core): set tags for readme";
git add .github/workflows/build.yml; git commit -m "build(core): del 3.20";
git add .github/workflows/build.yml; git commit -m "build(core): fix passed env";
git add .github/workflows/build.yml; git commit -m "build(core): use workflow like pnpm-docker";
git add .github/workflows/build.yml; git commit -m "build(core): fix test";
git rm .github/workflows/docker-publish-alpine.yml;git commit -m "build(core): del unused files";
```

## opv - dockerfiles
```bash

git add Dockerfile-alpine; git commit -m "build(core): init dockerfile";
git add Dockerfile; git commit -m "build(core): sync to Dockerfile-alpine";


git add Dockerfile; git commit -m "build(core): init dockerfile";
git add Dockerfile-alpine; git commit -m "build(core): use ALPINE_VERSION as arg to set alpine version";

```

## 代码托管 （github）

## gh - prepare vars

```powershell
$repo="ymc-github/mirror-mysql";
$repo_desc="a docker image base on alpine and more with mysql";

$repo_uname=$repo -replace "-","_" -replace "/","_";
$repo_name=$repo  -replace ".*/","";
$repo_user=$repo  -replace "/.*","";

$email=git config user.email;

$repo_user;
$repo_name;
```

## gh - login with token from file

```powershell
# gh auth login --with-token < mytoken.txt
$token=get-content secret/github.token.md;
# $token

# gh auth login --with-token $token # fail in powershell

# gh login with token from file in powershell
get-content secret/github.token.md | gh auth login --with-token

# sh -c 'gh auth login --with-token < secret/github.token.md'

# gh issue list --label "bug" --label "help wanted"
```

## gh - add github repo

```powershell
# create github repo
gh repo create $repo_name --public --description "$repo_desc"
# gh repo create $repo_name --private --description "$repo_desc"
```

## git - push to github ghh with git

```bash
git remote add ghh https://github.com/$repo.git
git push -u ghh main
```

## create deploy token

```powershell
# list repo for some repo
gh repo deploy-key list --repo $repo;

# std repo name and get email from git
# $repo_uname=$repo -replace "-","_" -replace "/","_";$email=git config user.email;

# mkdir -p ~/.ssh/;

# generate ssh key pair for github deploy key
# ssh-keygen -C "$email" -f ~/.ssh/gh_$repo_uname -t ed25519 -N "123" #done
ssh-keygen -C "$email" -f $HOME/.ssh/gh_$repo_uname -t ed25519 -N '""' #done

# list ssh key pair for github deploy key
sh -c "ls -al ~/.ssh/gh_$repo_uname*"
```

[ssh-keygen-in-windows-powershell-create-a-key-pair-and-avoid-pr](https://superuser.com/questions/1634427/non-interactive-ssh-keygen-in-windows-powershell-create-a-key-pair-and-avoid-pr)

## gh - upload github deploy

```powershell
# gh repo deploy-key list --repo $repo;
gh repo deploy-key add $HOME/.ssh/gh_${repo_uname}.pub --repo $repo -w --title deploy;
```

## gh - set ssh key client

```powershell
$txt=@"
Host github.com
    User git
    HostName github.com
    PreferredAuthentications publickey
    IdentityFile ~/.ssh/gh_${repo_uname}
"@

set-content -path $HOME/.ssh/config -value $txt
ssh -T git@github.com
# ssh -Tv git@github.com
```

## gh - set workflow write mode in webui (todo)

## prepare npm (and more) toekn as secret for github workflow

```powershell
gh secret list --repo $repo

# gh secret set NPM_TOKEN --body "$ENV_VALUE" --repo $repo
# gh secret set GITHUB_TOKEN --body "$ENV_VALUE" --repo $repo

# gh secret set -f .env --repo $repo

# gh secret set --repo $repo  -f D:\book\secret\npm.token.md
# gh secret set --repo $repo  -f D:\book\secret\npm.token.auto.md

gh secret set --repo $repo  -f D:\book\secret\gh.token.auto.md
# gh secret set --repo $repo  -f secret\env.docker

# NPM_TOKEN=xx in npm.token.md

# gh secret delete NPM_TOKEN --repo $repo
#

# gh secret set --env --repo $repo  -f D:\book\secret\npm.token.md
# gh variable list --repo $repo

```

## push to github ghg with git

```powershell
# git remote -v
# git remote remove ghh
git remote add ghg git@github.com:$repo.git
git push -u ghg main
git push ghg main
```

## rename master branch to main for remote repository (github) 
```powershell
git branch -m master main
git push -u ghg main
git push ghg main
```

## rename main branch to master for remote repository (github)
```powershell
git branch -m main master
git push -u ghg master
git push ghg master
```

## new orphan branch
- git clone repo from github，create new orphan branch,push to remote repository (github), and set as default branch (github)   
```powershell
# 1. 克隆仓库
git clone https://github.com/$repo.git
cd your-repo

# 2. 创建并切换到孤儿分支
git checkout --orphan main

# 3. 添加文件并提交
git add .
git commit -m "Initial commit on orphan branch"

# 4. 推送到远程仓库
git push ghg main

# 5. 使用 GitHub CLI 设置默认分支
# gh repo edit . --default-branch main
# gh repo edit $repo --default-branch main


# 6. (可选) 删除旧的默认分支
git push ghg --delete master
git push ghg master:master 
```

## gh - info or run workflows
```powershell
# list workflow
gh workflow list --repo $repo

# info workflow status
gh workflow view release  --repo $repo
# gh run list --workflow deploy.yml  --repo $repo

```


## gh - change repo visibility
```bash
gh repo edit $repo --visibility "public"
gh repo edit ymc-github/pnpm-docker --visibility "public"
```

## gh - rename github repo in cli (docs)
```powershell
yours touch docs/opv.this.repo.01-gh-rename-repo.md
```

## gh - rename github repo in cli (bash)

```bash
new_name="mysql-docker";
# in this repo project root
# gh repo rename $new_name --yes
# in other diretory
gh repo rename "$new_name" --repo ymc-github/mirror-mysql --yes
[ $? -eq 0 ] && git remote set-url ghg git@github.com:ymc-github/$new_name.git
# gh repo view 
git remote -v
```