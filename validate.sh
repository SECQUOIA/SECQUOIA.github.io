#!/bin/bash

echo "🔍 Running local validation checks..."
echo "=================================="

# Check 1: YAML syntax
echo "📋 Checking YAML files..."
find . -name "*.yml" -o -name "*.yaml" | while read file; do
    if command -v yamllint >/dev/null 2>&1; then
        yamllint "$file" && echo "✅ $file is valid" || echo "❌ $file has issues"
    else
        echo "⚠️  yamllint not available, skipping $file"
    fi
done

# Check 2: Jekyll build
echo ""
echo "🏗️  Testing Jekyll build..."
if bundle exec jekyll build --verbose 2>&1 | grep -i error; then
    echo "❌ Jekyll build has errors"
else
    echo "✅ Jekyll build successful"
fi

# Check 3: Check for common issues
echo ""
echo "🔎 Checking for common issues..."

# Trailing whitespace
echo "   Checking for trailing whitespace..."
if find . -name "*.md" -exec grep -l '[[:space:]]$' {} \; | head -1; then
    echo "   ❌ Found trailing whitespace in markdown files"
else
    echo "   ✅ No trailing whitespace found"
fi

# Check for broken internal links
echo "   Checking for potential link issues..."
if grep -r "secquoia\.github\.io" . --include="*.md" | grep -v "SECQUOIA\.github\.io"; then
    echo "   ❌ Found lowercase secquoia links (should be SECQUOIA)"
else
    echo "   ✅ No lowercase secquoia links found"
fi

# Check file encoding
echo "   Checking file encoding..."
if find . -name "*.md" -exec file {} \; | grep -v "UTF-8" | head -1; then
    echo "   ❌ Found non-UTF8 files"
else
    echo "   ✅ All files are UTF-8"
fi

echo ""
echo "🎉 Validation complete!"
