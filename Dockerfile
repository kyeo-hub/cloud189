# 构建阶段
FROM golang:1.21-alpine AS builder
ENV GOPROXY=https://goproxy.cn,direct
WORKDIR /app
COPY go.mod go.sum ./
RUN go mod download
COPY . .
RUN CGO_ENABLED=0 GOOS=linux go build -a -installsuffix cgo -o cloud189 ./cmd/cloud189

# 运行阶段
FROM alpine:3.18
WORKDIR /app
COPY --from=builder /app/cloud189 .
COPY --from=builder /app/docs ./docs

# 创建非root用户
RUN adduser -D -H -h /app webdavuser && \
    mkdir -p /app/.config/cloud189 && \
    chown -R webdavuser:webdavuser /app/.config
USER webdavuser

# 暴露WebDAV端口
EXPOSE 8080

# 启动WebDAV服务
CMD ["./cloud189", "webdav", "0.0.0.0:8080"]