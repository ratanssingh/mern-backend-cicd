#!/bin/bash

# Release script for MERN Backend CI
# Usage: ./scripts/release.sh [version]
# Example: ./scripts/release.sh 1.0.0

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Check if version is provided
if [ -z "$1" ]; then
    print_error "Version not provided!"
    echo "Usage: $0 [version]"
    echo "Example: $0 1.0.0"
    exit 1
fi

VERSION=$1
TAG="v$VERSION"

# Validate version format (semantic versioning)
if ! [[ $VERSION =~ ^[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
    print_error "Invalid version format. Please use semantic versioning (e.g., 1.0.0)"
    exit 1
fi

# Check if we're on main branch
CURRENT_BRANCH=$(git branch --show-current)
if [ "$CURRENT_BRANCH" != "main" ]; then
    print_warning "You are not on the main branch (current: $CURRENT_BRANCH)"
    read -p "Do you want to continue? (y/N): " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        print_status "Release cancelled."
        exit 1
    fi
fi

# Check if working directory is clean
if ! git diff-index --quiet HEAD --; then
    print_error "Working directory is not clean. Please commit or stash your changes."
    exit 1
fi

# Check if tag already exists
if git rev-parse "$TAG" >/dev/null 2>&1; then
    print_error "Tag $TAG already exists!"
    exit 1
fi

print_status "Preparing release $VERSION..."

# Update package.json version
print_status "Updating package.json version to $VERSION..."
npm version $VERSION --no-git-tag-version

# Run tests
print_status "Running tests..."
npm test

# Build Docker image locally to verify
print_status "Building Docker image locally to verify..."
docker build -t mern-backend-ci:$VERSION .

# Test the Docker image
print_status "Testing Docker image..."
docker run -d -p 3001:3000 --name test-release-container mern-backend-ci:$VERSION
sleep 3

# Test health endpoint
if curl -f http://localhost:3001/health > /dev/null 2>&1; then
    print_status "Health check passed ✓"
else
    print_error "Health check failed ✗"
    docker stop test-release-container
    docker rm test-release-container
    exit 1
fi

# Cleanup test container
docker stop test-release-container
docker rm test-release-container

# Commit version change
print_status "Committing version change..."
git add package.json
git commit -m "chore: bump version to $VERSION"

# Create and push tag
print_status "Creating and pushing tag $TAG..."
git tag -a "$TAG" -m "Release version $VERSION"
git push origin main
git push origin "$TAG"

print_status "🎉 Release $VERSION has been triggered!"
print_status "🔗 Check GitHub Actions: https://github.com/$(git config --get remote.origin.url | sed 's/.*github.com[:/]\([^/]*\/[^/]*\).*/\1/' | sed 's/\.git$//')/actions"
print_status "🐳 Docker image will be available at: docker pull YOUR_USERNAME/mern-backend-ci:$VERSION"

echo
print_status "Next steps:"
echo "1. Monitor the GitHub Actions workflow"
echo "2. Check the Docker Hub for the new image"
echo "3. Update your deployment to use the new version"