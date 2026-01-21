# Production-Ready CI/CD Portfolio Sample

## 🧠 Problem

A typical small team struggles with:
- **Unsafe deployments** - Manual processes prone to human error
- **No rollback strategy** - When things go wrong, recovery is slow and painful
- **Security vulnerabilities** - Exposed secrets, vulnerable dependencies, insecure code
- **Slow feedback loops** - Long wait times to know if code works
- **Inconsistent environments** - "Works on my machine" syndrome

## 🛠 Solution

This portfolio demonstrates a **production-ready CI/CD pipeline** that solves these problems:

### ✅ Automated Build & Test
- Code is automatically tested on every change
- Quality gates prevent bad code from reaching production
- Fast feedback with optimized build caching

### ✅ Zero-Downtime Deployment
- Services update without interrupting users
- Health checks ensure only healthy versions go live
- Automatic rollback if something goes wrong

### ✅ Rollback Ready
- Previous versions are always available
- One-command rollback to last known good state
- Automatic rollback on health check failure

### ✅ Environment-Based Configuration
- Separate configs for development, staging, and production
- Secrets managed securely via CI/CD variables
- No hardcoded credentials in code

### ✅ Security First
- Package vulnerability scanning (npm audit)
- Code security analysis (SAST)
- Secrets detection (prevents credential leaks)
- Container image scanning (Trivy)

## 🚀 CI/CD Flow

```
Code Push
    ↓
Run Lint (Code Quality)
    ↓
Security Scan (Package + Code + Secrets)
    ↓
Run Tests (Unit + Integration)
    ↓
Build Docker Images (with caching)
    ↓
Scan Container Images
    ↓
Deploy to Server
    ↓
Health Check
    ↓
Smoke Tests
    ↓
✅ Mark Live
```

If any step fails, the pipeline stops and alerts the team. If deployment fails health checks, it automatically rolls back.

## 🧯 Incident Handling

### Failed Deploy → Auto Rollback
When a deployment fails health checks:
1. New container is stopped immediately
2. Previous version is automatically restored
3. Team is notified of the rollback
4. System remains operational

### Logs Centralized
- All service logs accessible in one place
- Structured logging for easy debugging
- Health check status always visible

### Security Alerts
- Vulnerabilities detected during build
- Secrets exposure prevented before commit
- Container vulnerabilities flagged before deployment

## 💡 Why This Matters

### For Business
- **Reduced Risk** - Automated checks catch issues before they reach users
- **Less Downtime** - Zero-downtime deployments mean no service interruption
- **Faster Recovery** - Automatic rollback means problems are fixed in seconds, not hours
- **Security Confidence** - Multiple security layers protect against breaches

### For Developers
- **Faster Feedback** - Know immediately if code works
- **Less Stress** - Automated deployments reduce human error
- **Better Quality** - Quality gates enforce standards
- **Easy Rollback** - Fix mistakes quickly and safely

### For Operations
- **Consistent Deployments** - Same process every time
- **Visibility** - Know exactly what's deployed and when
- **Reliability** - Health checks ensure services are working
- **Scalability** - Process works the same at any scale

## 📁 Project Structure

```
.
├── backend/              # Express.js API server
├── frontend/             # React application
├── infra/
│   ├── docker/          # Dockerfiles & docker-compose files
│   ├── nginx/           # Nginx configurations
│   └── terraform/       # Infrastructure as code (optional)
├── scripts/             # Deployment & utility scripts
├── .github/workflows/   # GitHub Actions pipelines
├── .gitlab-ci.yml       # GitLab CI pipeline
└── README.md
```

## 🚀 Quick Start

### Development

```bash
# Start development environment
cd infra/docker
docker compose -f docker-compose.dev.yml up
# OR from project root:
# docker compose -f infra/docker/docker-compose.dev.yml up
```

Or with detached mode:
```bash
cd infra/docker
docker compose -f docker-compose.dev.yml up -d
```

Backend: http://localhost:3000  
Frontend: http://localhost:3001

### Staging

```bash
# Deploy to staging
cd infra/docker
# Build images first (or use --build flag)
docker compose -f docker-compose.staging.yml build
docker compose -f docker-compose.staging.yml up -d

# Or build and start in one command:
docker compose -f docker-compose.staging.yml up -d --build
```

### Production

```bash
# Deploy to production
cd infra/docker
export VERSION=1.0.0

# Optional: Use custom ports if 80/443 are already in use
# export NGINX_HTTP_PORT=8080
# export NGINX_HTTPS_PORT=8443

# Build images first (or use --build flag)
docker compose -f docker-compose.prod.yml build
docker compose -f docker-compose.prod.yml up -d

# Or build and start in one command:
docker compose -f docker-compose.prod.yml up -d --build
```

**Note**: 
- By default, production uses port 80 (HTTP). Port 443 (HTTPS) is commented out until SSL is configured.
- If port 80 is already in use, set `NGINX_HTTP_PORT` environment variable.
- Architecture: Nginx container acts as reverse proxy to frontend container (port 80) and backend container (port 3000).

### Common Commands

```bash
# Navigate to docker directory first
cd infra/docker

# View logs
docker compose -f docker-compose.dev.yml logs -f

# Stop services
docker compose -f docker-compose.dev.yml down

# Rebuild and restart
docker compose -f docker-compose.dev.yml up --build

# View running containers
docker compose -f docker-compose.dev.yml ps

# Check status of all services (from project root)
./scripts/check-status.sh dev
./scripts/check-status.sh staging
./scripts/check-status.sh prod

# Clean up containers (if you get name conflicts)
# From project root:
./scripts/cleanup-containers.sh dev
# Or for all environments:
./scripts/cleanup-containers.sh all
```

### Troubleshooting

#### Docker Compose Command Not Found

If `docker compose` command is not found:
- **Docker Compose v2** (recommended): `docker compose` (included with Docker Desktop)
- **Docker Compose v1**: Install with `sudo apt install docker-compose` then use `docker-compose`

#### Package Lock File Out of Sync

If you see errors like "package-lock.json out of sync" or "lock file's X does not satisfy Y":

**In CI/CD**: The workflows now automatically fallback to `npm install` if `npm ci` fails, so CI should continue to work.

**To fix permanently** (regenerate lock files):

```bash
# Regenerate package-lock.json files
./scripts/fix-dependencies.sh

# Or manually:
cd frontend && rm package-lock.json && npm install
cd ../backend && rm package-lock.json && npm install

# Commit the updated package-lock.json files
git add frontend/package-lock.json backend/package-lock.json
git commit -m "chore: update package-lock.json files"
```

**Note**: After adding new dependencies (like `globals`, `@eslint/js`), always regenerate lock files before committing.

#### Container Name Conflicts

If you see errors like "container name is already in use":

```bash
# Clean up existing containers
./scripts/cleanup-containers.sh dev

# Or manually:
cd infra/docker
docker compose -f docker-compose.dev.yml down
docker rm -f portfolio-backend-dev portfolio-frontend-dev 2>/dev/null || true

# Then start again
docker compose -f docker-compose.dev.yml up --build
```

#### Vite/Node Modules Not Found

If you see errors like "vite: not found" or "command not found":

```bash
# Clean up and rebuild without cache
cd infra/docker
docker compose -f docker-compose.dev.yml down -v
docker compose -f docker-compose.dev.yml build --no-cache frontend
docker compose -f docker-compose.dev.yml up

# Or force rebuild everything:
docker compose -f docker-compose.dev.yml build --no-cache
docker compose -f docker-compose.dev.yml up
```

The entrypoint script will automatically install dependencies if node_modules is missing.

#### Port Already in Use

If you see errors like "address already in use" for port 80 or 443:

```bash
# Check which ports are in use
./scripts/check-ports.sh

# Option 1: Stop the service using the port
sudo systemctl stop apache2  # or nginx, or other service
# Or find and stop the process:
sudo lsof -ti:80 | xargs sudo kill -9

# Option 2: Use different ports for production
cd infra/docker
export NGINX_HTTP_PORT=8080
export NGINX_HTTPS_PORT=8443
docker compose -f docker-compose.prod.yml up -d

# Option 3: Move nginx from port 8080 to port 80
# First, check what's using port 80:
sudo lsof -i :80
# Or use the helper script:
./scripts/check-ports.sh

# If port 80 is free, restart nginx on port 80:
cd infra/docker
unset NGINX_HTTP_PORT  # Use default port 80
docker compose -f docker-compose.prod.yml up -d nginx

# Or use the helper script:
./scripts/fix-port-80.sh
```

## 🔒 Security Features

- **Package Scanning**: npm audit checks for vulnerable dependencies
- **Code Analysis**: ESLint security plugins + Semgrep detect code vulnerabilities
- **Secrets Detection**: Prevents committing API keys, passwords, tokens
- **Container Scanning**: Trivy scans Docker images for vulnerabilities
- **Environment Isolation**: Separate configs prevent cross-environment leaks

See [SECURITY.md](SECURITY.md) for detailed security information, known vulnerabilities, and mitigation strategies.

## 📊 Monitoring

- Health endpoints: `/health`, `/health/ready`, `/health/live`
- Structured logging for all services
- Health checks in Docker Compose
- Smoke tests verify deployment success

## 🔄 Deployment Strategy

1. **Blue-Green Deployment**: New version runs alongside old version
2. **Health Checks**: Only healthy services are marked live
3. **Automatic Rollback**: Failed deployments revert automatically
4. **Zero Downtime**: Users never experience service interruption

## 🛠 Technologies

- **Backend**: Node.js 24 LTS, Express.js
- **Frontend**: React 18, Vite 6 (modern, fast build tool)
- **Containerization**: Docker, Docker Compose
- **Reverse Proxy**: Nginx
- **CI/CD**: GitHub Actions, GitLab CI
- **Security**: npm audit, Semgrep, Trivy, Snyk
- **Testing**: Vitest, Jest (backend)

### ✨ Frontend Technology

This project uses **Vite** with React 18, providing:
- ⚡ Lightning-fast HMR (Hot Module Replacement)
- 🚀 Fast build times
- 📦 Optimized production builds
- 🔒 No known security vulnerabilities in build tools
- 🎯 Modern tooling with excellent developer experience

## 📝 Environment Variables

See `backend/env.example` and `frontend/env.example` for required environment variables.

## 🤝 Contributing

1. Create a feature branch
2. Make your changes
3. Push to trigger CI pipeline
4. All checks must pass before merge
5. Deploy to staging for testing
6. Deploy to production after approval

## 📄 License

MIT

---

**This is a production-ready example** - Use it as a template for your own projects, or as a portfolio piece to demonstrate CI/CD expertise.
