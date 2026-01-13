#!/bin/bash

echo "🔍 Running local validation checks..."
echo "=================================="

# Check 1: YAML syntax
echo "📋 Checking YAML files..."
if command -v yamllint >/dev/null 2>&1; then
    find . -name "*.yml" -o -name "*.yaml" | grep -v vendor | grep -v node_modules | while read file; do
        yamllint -d relaxed "$file" && echo "✅ $file is valid" || echo "❌ $file has issues"
    done
else
    echo "⚠️  yamllint not installed. Install with: sudo apt install yamllint"
fi

# Check 2: Jekyll build
echo ""
echo "🏗️  Testing Jekyll build..."
if command -v bundle >/dev/null 2>&1; then
    if bundle exec jekyll build 2>&1 | tee /tmp/jekyll-build.log | grep -i "error\|fatal"; then
        echo "❌ Jekyll build has errors"
    else
        echo "✅ Jekyll build successful"
        
        # Check 3: Validate _site structure (deployment dry-run)
        echo ""
        echo "📦 Validating site structure for GitHub Pages..."
        if [ -d "_site" ] && [ -f "_site/index.html" ]; then
            echo "✅ Site structure valid for deployment"
        else
            echo "❌ Site structure invalid - _site/index.html missing"
        fi
        
        # Check 4: HTMLProofer internal links (if available)
        echo ""
        echo "🔗 Checking internal links..."
        if bundle exec htmlproofer --version >/dev/null 2>&1; then
            if bundle exec htmlproofer ./_site --disable-external --checks Links,Images,Scripts 2>&1 | tee /tmp/linkcheck.log; then
                echo "✅ Internal links valid"
            else
                echo "❌ Broken internal links found (see above)"
            fi
        else
            echo "⚠️  html-proofer not installed. Add to Gemfile: gem 'html-proofer'"
        fi
    fi
else
    echo "⚠️  Bundler not installed. Install Ruby and run: gem install bundler"
fi

# Check 5: Common issues
echo ""
echo "🔎 Checking for common issues..."

# Trailing whitespace
echo "   Checking for trailing whitespace..."
if find . -name "*.md" -not -path "./vendor/*" -exec grep -l '[[:space:]]$' {} \; 2>/dev/null | head -1 | grep -q .; then
    echo "   ⚠️  Found trailing whitespace in markdown files (warning only)"
else
    echo "   ✅ No trailing whitespace found"
fi

# Check for broken internal links
echo "   Checking for potential link issues..."
if grep -r "secquoia\.github\.io" . --include="*.md" 2>/dev/null | grep -v "SECQUOIA\.github\.io" | head -1 | grep -q .; then
    echo "   ❌ Found lowercase secquoia links (should be SECQUOIA)"
else
    echo "   ✅ No lowercase secquoia links found"
fi

# Check file encoding
echo "   Checking file encoding..."
if find . -name "*.md" -not -path "./vendor/*" -exec file {} \; 2>/dev/null | grep -v "UTF-8" | grep -v "empty" | head -1 | grep -q .; then
    echo "   ❌ Found non-UTF8 files"
else
    echo "   ✅ All files are UTF-8"
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
echo "🎉 Validation complete!"
echo ""
echo "💡 Tip: Run 'bundle exec htmlproofer ./_site --checks Links' for full link check"
