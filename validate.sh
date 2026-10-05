#!/bin/bash

echo "🔍 Running local validation checks..."
echo "=================================="

# Keep running independent checks, but fail overall if a required check fails.
VALIDATION_FAILED=0

# Detect if we should use Docker and if sudo is needed
USE_DOCKER=false
DOCKER_CMD="docker"

if ! command -v bundle >/dev/null 2>&1; then
    if command -v docker >/dev/null 2>&1; then
        # Check if Docker needs sudo
        if ! docker info >/dev/null 2>&1; then
            if sudo -n docker info >/dev/null 2>&1; then
                DOCKER_CMD="sudo docker"
            else
                echo "❌ Docker is unavailable or permission was denied."
                echo "   Check that the Docker daemon is running and your user belongs to the docker group."
                echo '   For group access: sudo usermod -aG docker "$USER" (then log out and back in).'
                exit 1
            fi
        fi
        
        echo "ℹ️  Bundler not found, using Docker for Jekyll/HTMLProofer checks"
        USE_DOCKER=true
        
        # Build Docker image if needed
        if ! $DOCKER_CMD image inspect secquoia-website >/dev/null 2>&1; then
            echo "🐳 Building Docker image (first time only)..."
            if ! $DOCKER_CMD build -t secquoia-website .; then
                echo "❌ Could not build the validation image."
                exit 1
            fi
        fi
    fi
fi

# Helper function to run commands (locally or via Docker)
run_bundle() {
    if [ "$USE_DOCKER" = true ]; then
        $DOCKER_CMD run --rm -v "$(pwd)":/app -w /app secquoia-website "$@"
    else
        "$@"
    fi
}

# Helper function to run shell commands in Docker
run_docker_shell() {
    if [ "$USE_DOCKER" = true ]; then
        $DOCKER_CMD run --rm -v "$(pwd)":/app -w /app secquoia-website bash -c "$1"
    fi
}

# Keep generated content and dependencies out of all source-file checks.
find_sources() {
    find . -type d \( -name vendor -o -name node_modules -o -name .git -o -name _site -o -name _sources \) -prune -o -type f "$@" -print0
}

check_yaml_files() {
    local yaml_status=0
    # Process substitution keeps the failure flag in this shell. Null-separated
    # paths also let filenames with spaces reach yamllint intact.
    while IFS= read -r -d '' file; do
        if yamllint --strict "$file"; then
            echo "✅ $file is valid"
        else
            echo "❌ $file has issues"
            yaml_status=1
        fi
    done < <(find_sources \( -name '*.yml' -o -name '*.yaml' -o -name .yamllint \))
    return "$yaml_status"
}

# Check 1: YAML syntax
echo "📋 Checking YAML files..."
if command -v yamllint >/dev/null 2>&1; then
    check_yaml_files || VALIDATION_FAILED=1
elif [ "$USE_DOCKER" = true ]; then
    # Pass the same functions to the container so both paths check the same files.
    if ! run_docker_shell "$(declare -f find_sources check_yaml_files)
        check_yaml_files"; then
        VALIDATION_FAILED=1
    fi
else
    echo "❌ yamllint not installed. Install with: sudo apt install yamllint"
    VALIDATION_FAILED=1
fi

# Check 2: Jekyll build
echo ""
echo "🏗️  Testing Jekyll build..."
if command -v bundle >/dev/null 2>&1 || [ "$USE_DOCKER" = true ]; then
    # Run Jekyll build and capture exit code
    run_bundle bundle exec jekyll build > /tmp/jekyll-build.log 2>&1
    BUILD_EXIT=$?
    
    if [ $BUILD_EXIT -eq 0 ]; then
        echo "✅ Jekyll build successful"
        
        # Check 3: Validate _site structure (deployment dry-run)
        echo ""
        echo "📦 Validating site structure for GitHub Pages..."
        if [ -d "_site" ] && [ -f "_site/index.html" ]; then
            echo "✅ Site structure valid for deployment"
        else
            echo "❌ Site structure invalid - _site/index.html missing"
            VALIDATION_FAILED=1
        fi
        
        # Check 4: HTMLProofer internal links
        echo ""
        echo "🔗 Checking internal links..."
        if run_bundle bundle exec htmlproofer --version >/dev/null 2>&1; then
            # Scope pipefail to this pipeline: tee must not hide a failed check.
            if (set -o pipefail; run_bundle bundle exec htmlproofer ./_site --disable-external --checks Links,Images,Scripts 2>&1 | tee /tmp/linkcheck.log); then
                echo "✅ Internal links valid"
            else
                echo "❌ Broken internal links found (see above)"
                VALIDATION_FAILED=1
            fi
        else
            echo "❌ HTMLProofer unavailable. Install the Gemfile's test dependencies."
            VALIDATION_FAILED=1
        fi
    else
        echo "❌ Jekyll build failed (exit code: $BUILD_EXIT)"
        cat /tmp/jekyll-build.log
        VALIDATION_FAILED=1
    fi
else
    echo "❌ Bundler not installed and Docker not available."
    echo "   Install Ruby and run: gem install bundler"
    echo "   Or install Docker: sudo apt install docker.io"
    VALIDATION_FAILED=1
fi

# Check 5: Common issues
echo ""
echo "🔎 Checking for common issues..."

# Trailing whitespace
echo "   Checking for trailing whitespace..."
WHITESPACE_FOUND=0
while IFS= read -r -d '' file; do
    if grep -q '[[:space:]]$' "$file"; then
        WHITESPACE_FOUND=1
        break
    fi
done < <(find_sources -name '*.md')
if [ "$WHITESPACE_FOUND" -ne 0 ]; then
    echo "   ⚠️  Found trailing whitespace in markdown files (warning only)"
else
    echo "   ✅ No trailing whitespace found"
fi

# Check file encoding
echo "   Checking file encoding..."
ENCODING_FAILED=0
while IFS= read -r -d '' file; do
    if ! file --brief "$file" | grep -Eq 'UTF-8|ASCII|empty'; then
        echo "   ❌ $file is not UTF-8 compatible"
        ENCODING_FAILED=1
    fi
done < <(find_sources -name '*.md')
if [ "$ENCODING_FAILED" -ne 0 ]; then
    echo "   ❌ Found non-UTF8 files"
    VALIDATION_FAILED=1
else
    echo "   ✅ All files are UTF-8 compatible"
fi

# Check 6: GitHub Actions workflow syntax
echo ""
echo "⚙️  Checking workflow files..."
for workflow in .github/workflows/*.yml; do
    if [ -f "$workflow" ]; then
        # Basic syntax check - look for common YAML issues
        if grep -q "timeout-minutes:" "$workflow"; then
            echo "   ✅ $workflow has timeout configured"
        else
            echo "   ⚠️  $workflow missing timeout-minutes (may hang indefinitely)"
        fi
    fi
done

echo ""
echo "=================================="
if [ "$VALIDATION_FAILED" -ne 0 ]; then
    echo "❌ Validation failed. Fix the errors above before opening a PR."
    exit 1
fi
echo "🎉 Validation complete!"
echo ""
echo "💡 Tip: Run 'bundle exec htmlproofer ./_site --checks Links' for full link check"
