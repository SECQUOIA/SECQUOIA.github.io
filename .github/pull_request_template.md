## PR Summary
Provide a concise summary of the changes. Focus on: purpose, scope, and any user-facing impact.

- Motivation:
- Main changes:
- Related issues (if any):

## Preview Artifact
This PR triggers the `Preview Build` workflow.
- Download the `preview-site` artifact from the workflow run to inspect the generated site locally.
- Internal and external link check logs are in the `preview-link-check-logs` artifact.
- Link checks are non-blocking; fix issues where practical before merge.

## Image & Asset Guidelines
Only WebP images should be referenced in the site; originals (PNG/JPG/etc.) may be stored for provenance.
1. Always reference the `.webp` version in Markdown/HTML.
2. Originals can live alongside WebP conversions but must NOT be used directly in content.
3. Prefer descriptive, kebab-case filenames (e.g., `joao-victor-paim.webp`).
4. If adding a new image, convert to WebP first. Example conversion commands:

```bash
# Using cwebp
cwebp input.jpg -q 80 -o output.webp

# Using ImageMagick
magick input.png -quality 80 output.webp
```

1. Run the existing resize helper if appropriate:

```bash
./resize_images.sh
```

(Ensure the script suits the new image before relying on it.)

## Checks Before Requesting Review
- [ ] Jekyll preview build succeeds locally (`bundle exec jekyll build`).
- [ ] All referenced images are WebP (originals not directly referenced).
- [ ] All member/profile links verified.
- [ ] External links added are valid (ignore transient 429/timeout warnings unless persistent).
- [ ] No large binary files (>5MB) added without justification.

## Follow-up / Deployment Notes
(Optional) Add anything maintainers should do post-merge (e.g., invalidate CDN, update external references).

## Screenshots (If UI/Content Changes)
Attach before/after comparisons for visual modifications.

---
Maintainers: Ensure branch protection requires only CI + Preview jobs, not production Pages deployment for PRs.
