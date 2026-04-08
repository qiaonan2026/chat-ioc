# Chat-IoC 部署配置

此目录包含 Chat-IoC 应用的完整部署配置文件。

## 目录结构

```
deployment/
├── configs/                    # 配置文件
│   ├── frontend.Dockerfile     # 前端 Docker 配置
│   ├── backend.Dockerfile      # 后端 Docker 配置
│   └── nginx.conf             # Nginx 配置
├── docker-compose.yml         # Docker Compose 配置
├── Jenkinsfile               # Jenkins CI/CD 流水线
├── kubernetes-deployment.yaml # Kubernetes 部署配置
├── local-deploy.sh           # 本地开发环境部署脚本
├── health-check.sh           # 健康检查脚本
└── DEPLOYMENT_GUIDE.md       # 部署指南
```

## 部署方式

### 1. 本地开发环境部署

```bash
# 确保已安装 Node.js, Java, Maven
./local-deploy.sh
```

### 2. Docker Compose 部署

```bash
# 构建并启动服务
docker-compose up --build -d
```

### 3. Kubernetes 部署

```bash
kubectl apply -f kubernetes-deployment.yaml
```

### 4. Jenkins CI/CD

将 Jenkinsfile 添加到 Jenkins 流水线中。

## 服务地址

- 前端: http://localhost:3000
- 后端: http://localhost:8080
- 生产前端: http://localhost (通过 Nginx 代理)
- 生产后端: http://localhost:8080 (内部服务)

## 依赖

- Docker & Docker Compose (容器化部署)
- Java 17 & Maven (后端构建)
- Node.js & npm (前端构建)
- Kubernetes (可选，用于生产环境)
- Jenkins (可选，用于 CI/CD)