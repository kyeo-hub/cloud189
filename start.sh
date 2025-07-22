#!/bin/sh
if [ -n "$USERNAME" ] && [ -n "$PASSWORD" ]; then
  echo "正在使用环境变量中的用户名和密码登录..."
  cloud189 login -i "$USERNAME" "$PASSWORD"
  if [ $? -ne 0 ]; then
    echo "登录失败，请检查用户名和密码"
    exit 1
  fi
else
  echo "未设置用户名或密码环境变量，请使用交互式登录"
  cloud189 login
fi

# 启动webdav服务
echo "启动WebDAV服务在端口 ${PORT:-8080}..."
exec cloud189 webdav :${PORT:-8080}