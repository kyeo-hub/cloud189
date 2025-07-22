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

# 复制启动脚本
COPY start.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/start.sh

# 设置工作目录
WORKDIR /root

# 暴露端口（默认8080）
EXPOSE 8080

# 设置入口点
ENTRYPOINT ["/usr/local/bin/start.sh"]