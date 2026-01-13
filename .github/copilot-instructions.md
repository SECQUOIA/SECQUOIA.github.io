# Copilot Instructions for SECQUOIA.github.io

This is a Jekyll-based GitHub Pages site for the SECQUOIA research group.

## Local Development & Testing

### Prerequisites
- Docker (recommended) or Ruby 3.2 with Bundler
- yamllint (for YAML validation)

### Quick Local Verification

Before pushing changes, **always run local validation**:

```bash
# Full validation (YAML, Jekyll build, common issues)
./validate.sh

# Or with Docker (builds and serves site)
docker build -t secquoia-website . && docker run -p 4000:4000 secquoia-website
```

### HTMLProofer Link Checking (requires Ruby/Bundler)

```bash
# Build site first
bundle exec jekyll build

# Check internal links only (fast)
bundle exec htmlproofer ./_site --disable-external --checks Links,Images,Scripts

# Check external links (slow, use sparingly)
bundle exec htmlproofer ./_site \
  --checks Links \
  --ignore-urls "/localhost/,/127.0.0.1/" \
  --typhoeus "{\"timeout\": 30, \"connecttimeout\": 10}" \
  --hydra "{\"max_concurrency\": 10}" \
  --ignore-status-codes "0,429,999"
```

## CI/CD Workflow Overview

| Workflow | Trigger | Purpose |
|----------|---------|---------|
| `ci.yml` | PRs, push to main | Build + lint + link checks |
| `preview.yml` | PRs only | Preview build artifact |
| `pages.yml` | After CI passes on main | Deploy to GitHub Pages |
| `link-checker.yml` | Weekly (Monday 9am UTC) | Full external link audit |

### Important: All workflow jobs have `timeout-minutes` set to prevent hangs.

## Common Issues & Fixes

### HTMLProofer CLI Options
When modifying HTMLProofer commands in workflows, use **escaped double quotes** for JSON arguments:
```yaml
# ✅ Correct (GitHub Actions YAML)
--typhoeus "{\"timeout\": 30}"

# ❌ Wrong (may cause parsing issues)
--typhoeus '{"timeout": 30}'
```

### Deployment Timeouts
If CI jobs hang on external link checking:
1. Ensure `timeout-minutes` is set on the job
2. Add `--hydra "{\"max_concurrency\": 10}"` to limit connections
3. Add `--cache "{\"timeframe\": {\"external\": \"1d\"}}"` to cache results

### Image Format
All images must be WebP format. Use `resize_images.sh` to convert images.

## File Structure

- `_posts/` - News/blog posts
- `_includes/` - Reusable HTML components
- `_layouts/` - Page templates
- `_data/citations.csv` - Publication data
- `assets/images/` - Site images (WebP only)
- `scripts/` - Utility scripts

## Before Merging PRs

1. ✅ Run `./validate.sh` locally
2. ✅ Verify CI passes on the PR
3. ✅ Check GitHub Actions logs for warnings
4. ✅ Test site locally with Docker if making layout changes
