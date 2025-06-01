## gh - git & mono-ify

## gh - git init

```powershell
git init
git add . ; git commit -m "docs(core): init and custom title-bar"
```

## gh - prepare vars

```powershell
$repo="ymc-github/pinc";
$repo_desc="an artist dancing on a piece of paper";

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
# todo:
# yours gh/repo --name xx --description xx --method create

# create github repo
gh repo create $repo_name --public --description "$repo_desc"

gh repo create $repo_name --private --description "$repo_desc"
```

## gh - create deploy token

```powershell
# $repo="ymc-github/yours"

# list repo for some repo
gh repo deploy-key list --repo $repo

# std repo name and get email from git
# $repo_uname=$repo -replace "-","_" -replace "/","_";$email=git config user.email;

# mkdir -p ~/.ssh/;

# ssh-keygen -C "$email" -f ~/.ssh/gh_$repo_uname -t ed25519 -N "123" #done

ssh-keygen -C "$email" -f $HOME/.ssh/gh_$repo_uname -t ed25519 -N '""' #done

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

## gh - push to github ghg with git

```powershell
# git remote -v
# git remote remove ghg
git remote add ghg git@github.com:$repo.git
git push -u ghg main
git push ghg main
```

```powershell
git commit -m "docs(core): init"
git add secret/.gitignore; git commit -m "build(core): ignore token in secret"
```

```powershell
git log --oneline
```

## gh - edit repo issue

```powershell
$repo="ymc-github/issues"
# $repo="ymc-github/some-issues"

# create your github repo ? do

# rename your github repo ? do
gh repo rename issues --repo ymc-github/some-issues
gh repo rename utxt --repo ymc-github/nano-utxt

# enable issues and wiki ? do
gh repo edit --enable-issues --enable-wiki --repo $repo

# enable discussions in the repository
gh repo edit --enable-discussions --repo $repo

# put  your github repo to private ? do
gh repo edit --visibility "private" --repo $repo

# put  your github repo to public ? do
gh repo edit --visibility "public" --repo $repo
```

## gh - commit

```powershell
git add template ; git commit -m "build(core): add template dir"


git add . ; git commit -m "build(mono): set root workspace"
yours git/modified/file --method put

yours git/commit --msg "build(mono): set homepage and repo url"

git add ${pkgsloc}/${name}; git commit -m "code(core): put ${name}"

git add ${pkgsloc}/${name}; git commit -m "test(core): add linear"

git add ${pkgsloc}/${name}; git commit -m "build(core): del unused file"

git add ${pkgsloc}/${name}; git commit -m "build(core): rename extend.d.ts name"
```

## gh - del unused file

```powershell
# del node_modules in template
$shcode="find $rootws/template -name 'node_modules' -type d -prune -print -exec rm -rf '{}' \;";sh -c "$shcode";

# del .github in template
$shcode="find $rootws/template -name '.github' -type d -prune -print -exec rm -rf '{}' \;";sh -c "$shcode";



# del .npmrc in some sw pkg
$shcode="find ${rootws}/${pkgsloc}/${name} -name '.npmrc' -type f -prune -print -exec rm -rf '{}' \;";sh -c "$shcode";


$shcode="find ${pkgsloc}/${name} -name '.github' -type d -prune -print -exec rm -rf '{}' \;";sh -c "$shcode";

```