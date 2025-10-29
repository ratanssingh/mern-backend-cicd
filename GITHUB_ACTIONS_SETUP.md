# GitHub Actions Setup Guide

This repository includes comprehensive CI/CD workflows for the MERN Backend project. Follow these steps to set up automated building and deployment.

## 🔧 Required Setup

### 1. Docker Hub Secrets

To enable Docker image building and pushing, you need to add the following secrets to your GitHub repository:

1. Go to your GitHub repository
2. Navigate to **Settings** → **Secrets and variables** → **Actions**
3. Add these repository secrets:

| Secret Name | Description | How to get it |
|-------------|-------------|---------------|
| `DOCKERHUB_USERNAME` | Your Docker Hub username | Your Docker Hub account username |
| `DOCKERHUB_TOKEN` | Docker Hub access token | Generate at [Docker Hub → Account Settings → Security](https://hub.docker.com/settings/security) |

### 2. Create Docker Hub Access Token

1. Log in to [Docker Hub](https://hub.docker.com)
2. Go to **Account Settings** → **Security**
3. Click **New Access Token**
4. Give it a description (e.g., "GitHub Actions CI/CD")
5. Select **Read, Write, Delete** permissions
6. Copy the generated token and add it as `DOCKERHUB_TOKEN` secret

## 🚀 Workflows Overview

### 1. **CI/CD Pipeline** (`.github/workflows/ci-cd.yml`)
**Triggers:** Push to `main` or `develop`, Pull requests to `main`

**Features:**
- ✅ Tests on multiple Node.js versions (16, 18, 20)
- 🐳 Builds and pushes Docker images to Docker Hub
- 🔒 Security scanning with Trivy
- 🚀 Deployment placeholder (customize for your environment)
- 📦 Multi-platform builds (AMD64, ARM64)
- 🏷️ Smart tagging (branch name, SHA, latest)

### 2. **Development Build** (`.github/workflows/dev-build.yml`)
**Triggers:** Push to non-main branches, Pull requests

**Features:**
- ✅ Quick tests and Docker build validation
- 🧪 Container health checks
- 💡 No Docker push (development only)

### 3. **Dependency Updates** (`.github/workflows/dependency-updates.yml`)
**Triggers:** Weekly schedule (Mondays 2 AM UTC), Manual dispatch

**Features:**
- 📦 Automatic dependency updates
- 🔍 Security audit fixes
- 📋 Auto-generated Pull Requests
- ✅ Tests updated dependencies

## 🔄 Workflow Status

Once set up, you'll see workflow status badges. Add these to your main README:

```markdown
![CI/CD Pipeline](https://github.com/YOUR_USERNAME/mern-backend-ci/workflows/CI/CD%20Pipeline/badge.svg)
![Development Build](https://github.com/YOUR_USERNAME/mern-backend-ci/workflows/Development%20Build/badge.svg)
```

## 📋 Customization

### Docker Image Name
The Docker image is tagged as `{DOCKERHUB_USERNAME}/mern-backend-ci`. If you want a different name:
1. Update the `DOCKER_IMAGE` environment variable in `ci-cd.yml`
2. Create the repository on Docker Hub with the same name

### Deployment
The deployment step in `ci-cd.yml` is a placeholder. Customize it for your target environment:
- **AWS ECS/Fargate**: Use AWS CLI or CDK
- **Kubernetes**: Use `kubectl` or Helm
- **Docker Compose**: SSH and update services
- **Heroku**: Use Heroku CLI

### Branch Protection
Consider setting up branch protection rules:
1. Go to **Settings** → **Branches**
2. Add rule for `main` branch
3. Enable "Require status checks to pass"
4. Select the CI/CD workflow checks

## 🚦 First Run

After setting up secrets:

1. Push your code to GitHub
2. The workflows will automatically trigger
3. Check the **Actions** tab to monitor progress
4. Your Docker image will be available at `docker pull {username}/mern-backend-ci:latest`

## 🛠️ Local Development

To test the Docker build locally:

```bash
# Build image
docker build -t mern-backend-ci:local .

# Run container
docker run -p 3000:3000 mern-backend-ci:local

# Test health endpoint
curl http://localhost:3000/health
```

## 📞 Support

If you encounter issues:
1. Check the **Actions** tab for detailed logs
2. Ensure all secrets are correctly set
3. Verify Docker Hub repository exists and is accessible
4. Check that your Docker Hub token has the required permissions