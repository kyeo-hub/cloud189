# Cloud189 WebDAV Docker 部署指南

这个项目提供了Docker化的cloud189 WebDAV服务，让你可以通过WebDAV协议访问天翼云盘。

## 先决条件

- Docker
- Docker Compose
- 天翼云盘账号

## 快速开始

### 1. 设置环境变量

创建一个`.env`文件，包含以下内容：

```
CLOUD189_USERNAME=你的天翼云盘用户名
CLOUD189_PASSWORD=你的天翼云盘密码
WEBDAV_PORT=8080
HOST_PORT=8080
```

### 2. 构建并启动服务

```bash
docker-compose up -d
```

这将在后台启动cloud189 WebDAV服务。

### 3. 查看日志

```bash
docker-compose logs -f
```

## 环境变量说明

| 变量名 | 必填 | 默认值 | 说明 |
|--------|------|--------|------|
| CLOUD189_USERNAME | 是 | - | 天翼云盘用户名 |
| CLOUD189_PASSWORD | 是 | - | 天翼云盘密码 |
| WEBDAV_PORT | 否 | 8080 | 容器内WebDAV服务端口 |
| HOST_PORT | 否 | 8080 | 主机映射端口 |

## 使用说明

启动服务后，你可以使用支持WebDAV协议的客户端连接到服务：

- 地址：`http://你的服务器IP:HOST_PORT`
- 用户名：与天翼云盘相同
- 密码：与天翼云盘相同

### 支持的客户端

- Windows: Windows资源管理器、RaiDrive
- macOS: Finder、Mountain Duck
- Linux: davfs2、Nautilus
- 移动设备: ES文件浏览器、nPlayer等

## 数据持久化

配置文件和登录状态会保存在名为`cloud189-config`的Docker卷中。这样即使容器重启，也不需要重新登录。

## 故障排除

### 登录失败

如果登录失败，请检查用户名和密码是否正确。你可以查看容器日志获取更多信息：

```bash
docker-compose logs
```

### WebDAV连接问题

确保防火墙允许指定的端口通过。如果在公网环境使用，建议设置反向代理并启用HTTPS。

## 高级配置

### 使用自定义配置文件

如果需要使用自定义配置文件，可以修改docker-compose.yml，添加以下卷挂载：

```yaml
volumes:
  - ./custom-config.json:/root/.config/cloud189/config.json
```

### 更改端口

可以通过修改`.env`文件中的`HOST_PORT`和`WEBDAV_PORT`变量来更改端口。