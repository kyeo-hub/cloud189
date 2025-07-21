# cloud189

## Docker部署WebDAV服务

### 前提条件
- Docker和Docker Compose已安装

### 构建和启动
```bash
# 构建并启动服务
docker-compose up --build -d

# 查看服务状态
docker-compose ps

# 查看日志
docker-compose logs -f
```

### 配置说明
1. **推荐：使用环境变量设置凭据**
   创建`.env`文件：
   ```env
   CLOUD189_USERNAME=your_username
   CLOUD189_PASSWORD=your_password
   ```

2. **可选：使用配置文件**
   将配置文件放在项目根目录的`config`文件夹下，文件名为`config.json`
   ```json
   {
     "sson": "your_sson_cookie",
     "auth": "your_auth_cookie"
   }
   ```

3. 首次启动会自动创建必要的目录结构
4. 数据会持久化存储在`data`目录中

### GitHub Actions自动构建
1. 在GitHub仓库设置以下Secrets：
   - `DOCKERHUB_USERNAME`: Docker Hub用户名
   - `DOCKERHUB_TOKEN`: Docker Hub访问令牌
2. 推送标签(tag)后会自动触发构建并推送到Docker Hub和GHCR

### 默认参数
- WebDAV服务端口: 8080
- 配置文件路径: ./config/config.json
- 数据存储路径: ./data

# cloud189

封装天翼云盘接口实现命令行访问, 个人开发不足之处还请包涵, 本人将持续优化使用体验

## 命令列表

命令中云端路径均以`/`开头, `...`表示支持多参数, 全局参数`--config`指定配置文件路径，默认路径为`${HOME}/.config/cloud189/config.json`，例：`cloud189 --config /tmp/config.json ls {云盘路径}`

- 显示帮助: `cloud189 -h`
- 显示版本: `cloud189 version`
- 用户登录
  - `cloud189 qrlogin` 浏览器打开控制台中二维码链接扫码登录
  - `cloud189 login` 控制台中输入用户名密码登陆
  - `cloud189 login -i {用户名} {密码}` 用户名密码登录
- 退出登录
  - `cloud189 logout` 将询问是否退出，`y` 表示退出
  - `cloud189 logout -f` 不询问直接退出
- 每日签到: `cloud189 sign` 支持签到及抽奖获取空间
- 查看空间: `cloud189 df` 查看云盘空间的使用信息
- 文件夹创建: `cloud189 mkdir {云盘路径}` 支持多层级目录创建
- 文件上传: `cloud189 up  -p {上传并发数默认5} -n {文件过滤表达式, 不匹配则不上传, 默认不过滤} {本地路径|http~~|fast...~~} {云盘路径}`，支持三种模式文件上传，已知网页版上传接口存在bug不支持断点续传, 例
  - 本地上传`cloud189 up {本地路径...} {云盘路径}`，例 `cloud189 up /tmp/cloud189 /我的应用` 本地文件支持秒传
  - http上传 `cloud189 up {http://文件...} {云盘路径}`，例 `cloud189 up https://github.com/gowsp/cloud189/releases/download/v0.4.2/cloud189_0.4.2_linux_amd64.tar.gz /我的应用`，该模式不支持10M以上的文件秒传
  - ~~手动秒传 `cloud189 up {fast://文件MD5:文件大小/文件名...} {云盘路径}`，例 `cloud189 up fast://3BACAB45A36BE381390035D228BB23E0:7598080/cloud189 /我的应用`，可以实现无文件上传，例如：系统镜像~~, 经验证已失效
- 文件下载: `cloud189 dl {云端路径...} {本地路径}` 支持文件夹, 支持断点续传
- 文件列表: `cloud189 ls {云盘路径}` 大小为`-`表示文件夹
- 文件删除: `cloud189 rm {云盘路径...}`
- 文件复制: `cloud189 mv {云盘路径...} {目标路径}`
- 文件移动: `cloud189 cp {云盘路径...} {目标路径}`
- WebDAV（待优化）: `cloud189 webdav :{端口}` 启动 webdav服务, 上传不支持10M以上的文件秒传
- 文件共享: `cloud189 share :{端口} {云盘路径}` 指定http端口对外提供文件直链分享 
- cli终端模式：`cloud189` 无参启动终端模式，`Ctrl + C`退出，该模式下无需输入`cloud189`即可支持以上所有命令，支持`Tab键`参数补全，并新增目录命令
  - `cd {云盘路径}` 进入指定目录
  - `pwd` 查看当前目录
  - `exit` 退出终端模式

## TODO

计划于未来更新如下一些内容：

- [ ] webdav优化
