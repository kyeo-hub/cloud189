# 构建阶段
FROM golang:1.21-alpine AS builder

# 安装构建依赖
RUN apk add --no-cache git

# 设置工作目录
WORKDIR /app

# 复制go.mod和go.sum文件
COPY go.mod go.sum ./

# 下载依赖
RUN go mod download

# 复制源代码
COPY . .

# 构建应用
RUN CGO_ENABLED=0 GOOS=linux go build -o cloud189 ./cmd/cloud189

# 运行阶段
FROM alpine:latest

# 安装运行时依赖
RUN apk add --no-cache ca-certificates tzdata

# 设置时区
ENV TZ=Asia/Shanghai

# 创建配置目录
RUN mkdir -p /root/.config/cloud189

# 从构建阶段复制二进制文件
COPY --from=builder /app/cloud189 /usr/local/bin/

# 添加启动脚本
RUN echo '#!/bin/sh\n\
if [ -n "$USERNAME" ] && [ -n "$PASSWORD" ]; then\n\
  echo "正在使用环境变量中的用户名和密码登录..."\n\
  cloud189 login -i "$USERNAME" "$PASSWORD"\n\
  if [ $? -ne 0 ]; then\n\
    echo "登录失败，请检查用户名和密码"\n\
    exit 1\n\
  fi\n\
else\n\
  echo "未设置用户名或密码环境变量，请使用交互式登录"\n\
  cloud189 login\n\
fi\n\
\n\
# 启动webdav服务\n\
echo "启动WebDAV服务在端口 ${PORT:-8080}..."\n\
exec cloud189 webdav :${PORT:-8080}\n\
' > /usr/local/bin/start.sh && chmod +x /usr/local/bin/start.sh

# 设置工作目录
WORKDIR /root

# 暴露端口（默认8080）
EXPOSE 8080

# 设置入口点
ENTRYPOINT ["/usr/local/bin/start.sh"]