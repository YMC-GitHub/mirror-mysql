## 版本管理
```bash
git status

git add docs/*.md; git commit -m "docs(core): update docs";



git add scripts/*.sh; git commit -m "build(core): init scripts"; 
git add scripts/*.sh; git commit -m "build(core): update scripts"; 


git add assets/*.svg; git commit -m "assets(core): init assets"; 
git add assets/*.svg; git commit -m "assets(core): update assets"; 


git add secrets/*; git commit -m "build(core): init directory constructure";
git add sql-backup/*; git commit -m "build(core): init directory constructure";
git add sql-init/*; git commit -m "build(core): init directory constructure";
git add .dockerignore .editorconfig .gitattributes LICENSE README.md .env; git commit -m "build(core): init directory constructure";

git add my.cnf; git commit -m "build(core): set mysqld config";
git add .env ; git commit -m "build(core): use env file";

git add .github/workflows/docker-publish-alpine.yml; git commit -m "build(core): init github workflows";
git add docs/*.md; git commit -m "docs(core): update docs";

git push origin main;

```


## set git user name and email
```bash
git config --global user.name "yemiancheng"
git config --global user.email "ymc.github@gmail.com"
```

