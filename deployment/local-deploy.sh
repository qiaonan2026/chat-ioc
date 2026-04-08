#!/bin/bash

# 本地开发环境部署脚本
# 用于验证部署配置和启动服务

set -e

echo "======= Chat-IoC 本地开发环境部署脚本 ======="

# 检查 Node.js 和 npm
if ! command -v node &> /dev/null; then
    echo "错误: Node.js 未安装"
    exit 1
fi

if ! command -v npm &> /dev/null; then
    echo "错误: npm 未安装"
    exit 1
fi

# 检查 Java
if ! command -v java &> /dev/null; then
    echo "错误: Java 未安装"
    exit 1
fi

# 检查 Maven
if ! command -v mvn &> /dev/null; then
    echo "错误: Maven 未安装"
    exit 1
fi

echo "✓ 环境检查通过"

# 启动后端服务
echo "======= 启动后端服务 ======="
cd ~/chat-ioc-service/chat-ioc-service

echo "构建后端项目..."
mvn clean compile

echo "启动后端服务..."
nohup mvn exec:java -Dexec.mainClass="com.chat.ioc.HttpServerApplication" > backend.log 2>&1 &
BACKEND_PID=$!

echo "后端服务 PID: $BACKEND_PID"
sleep 10  # 等待后端服务启动

# 检查后端是否成功启动
if kill -0 $BACKEND_PID 2>/dev/null; then
    echo "✓ 后端服务启动成功"
else
    echo "✗ 后端服务启动失败，请检查错误日志"
    exit 1
fi

# 启动前端服务
echo "======= 启动前端服务 ======="
cd ~/chat-ioc-frontend

echo "安装前端依赖..."
npm install

echo "启动前端开发服务器..."
nohup npm run dev > frontend.log 2>&1 &
FRONTEND_PID=$!

echo "前端服务 PID: $FRONTEND_PID"
sleep 5  # 等待前端服务启动

# 检查前端是否成功启动
if kill -0 $FRONTEND_PID 2>/dev/null; then
    echo "✓ 前端服务启动成功"
else
    echo "✗ 前端服务启动失败，请检查错误日志"
    exit 1
fi

echo ""
echo "======= 部署完成 ======="
echo "前端服务: http://localhost:3000"
echo "后端服务: http://localhost:8080"
echo ""
echo "要停止服务，请运行: pkill -f 'mvn exec:java' && pkill -f 'npm run dev'"
echo ""

# 检查服务健康状态
echo "======= 服务健康检查 ======="
sleep 10

if curl -f http://localhost:8080/api/health > /dev/null 2>&1; then
    echo "✓ 后端服务健康检查通过"
else
    echo "✗ 后端服务健康检查失败"
fi

if curl -f http://localhost:3000 > /dev/null 2>&1; then
    echo "✓ 前端服务健康检查通过"
else
    echo "✗ 前端服务健康检查失败"
fi

echo ""
echo "======= 验证完成 ======="