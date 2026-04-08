# Chat-IoC 应用部署指南

## 项目概述

本项目包含两个组件：
- **前端**: 基于 React + TypeScript + Vite + Tailwind CSS
- **后端**: 基于 Java 17 + 自研 IoC 容器框架

## 部署方式

### 方式一：使用 Docker Compose（推荐用于本地开发/测试）

1. 确保已安装 Docker 和 Docker Compose
2. 在 `projects` 目录下运行以下命令：

```bash
# 构建并启动服务
docker-compose up --build -d

# 查看服务状态
docker-compose ps

# 查看日志
docker-compose logs -f
```

3. 访问应用
   - 前端界面：http://localhost
   - 后端 API：http://localhost:8080

### 方式二：使用 Jenkins CI/CD

1. 在 Jenkins 中创建新流水线
2. 设置源码管理，指向项目仓库
3. 配置 Jenkinsfile 路径
4. 执行流水线构建

### 方式三：使用 Kubernetes

1. 确保已配置好 kubectl 并连接到集群
2. 应用部署文件：

```bash
kubectl apply -f kubernetes-deployment.yaml
```

3. 检查部署状态：

```bash
kubectl get pods
kubectl get services
```

## 部署后验证

运行健康检查脚本验证服务状态：

```bash
./health-check.sh all
```

## 回滚策略

### Docker Compose 环境回滚

```bash
# 查看之前的镜像版本
docker images | grep chat-ioc

# 停止当前服务
docker-compose down

# 使用之前的镜像标签重新启动
# 修改 docker-compose.yml 中的镜像标签，然后重新启动
docker-compose up -d
```

### Kubernetes 环境回滚

```bash
# 查看部署历史
kubectl rollout history deployment/chat-ioc-service
kubectl rollout history deployment/chat-ioc-frontend

# 回滚到上一个版本
kubectl rollout undo deployment/chat-ioc-service
kubectl rollout undo deployment/chat-ioc-frontend
```

## 监控与日志

### Docker Compose 环境

```bash
# 查看所有服务日志
docker-compose logs -f

# 查看特定服务日志
docker-compose logs -f chat-ioc-backend
docker-compose logs -f chat-ioc-frontend
```

### Kubernetes 环境

```bash
# 查看 Pod 日志
kubectl logs -f deployment/chat-ioc-service
kubectl logs -f deployment/chat-ioc-frontend

# 查看 Pod 状态
kubectl describe pod -l app=chat-ioc-service
kubectl describe pod -l app=chat-ioc-frontend
```

## 故障排查

### 常见问题

1. **前端无法访问后端 API**
   - 检查 Nginx 配置中的代理设置
   - 确认后端服务已正常启动并监听 8080 端口

2. **后端服务启动失败**
   - 检查数据库连接配置
   - 查看后端日志中的错误信息

3. **构建失败**
   - 确认 Docker 版本兼容性
   - 检查 Maven/Node.js 依赖是否正确

### 快速诊断命令

```bash
# 检查所有容器状态
docker-compose ps

# 检查网络连接
docker network ls
docker-compose exec chat-ioc-frontend ping chat-ioc-service

# 检查磁盘空间
df -h

# 检查系统资源使用
docker stats
```