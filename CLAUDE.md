# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is a personal blog built with Hugo static site generator, using the Hermit theme. The blog is published to GitHub Pages.

## Repository Structure

- **Two Git Repositories:**
  - Main repo (`mybloog`): Source code for the blog
  - `public/` directory: Git submodule pointing to `takumi34/takumi34.github.io` (GitHub Pages)

- **Theme Handling:**
  - `themes/hermit/`: Git submodule from `Track3/hermit`
  - Local modifications exist in theme files for Hugo compatibility
  - **Do NOT commit or push theme changes** - they are kept local only

## Build and Development

### Using Makefile (Recommended)

```bash
# Build the site
make build

# Run development server
make serve
# Access at http://localhost:1313/

# Create new post
make new POST=my-post-name

# Publish everything (build + push pages + push source)
make publish

# Publish only GitHub Pages
make publish-pages

# Publish only source code
make publish-source

# Clean generated files
make clean
```

### Manual Commands

```bash
# Build the site
hugo

# Run development server
hugo server

# Create new post
hugo new posts/sample.md
```

## Publishing Workflow

The site requires a two-step publish process:

1. **Publish to GitHub Pages** (public/ directory)
2. **Commit source changes** (main repo)

Use `make publish` to automate both steps, or run them manually as described in the Makefile.

Note: There's also a legacy `push.fish` script available.

## Important Files

- `config.toml`: Site configuration including social links, menu, author info
- `content/posts/`: Blog posts in Markdown
- `content/about-me.md`: About page
- `content/projects.md`: Projects showcase page
- `.gitignore`: Excludes `.hugo_build.lock` and `resources/_gen/`

## Hugo Version Compatibility

This site uses Hugo v0.152.2 (extended). The Hermit theme has been locally patched for compatibility:
- Changed `.Site.Author` to `.Site.Params.Author`
- Updated Disqus references for newer Hugo API
- Modified RSS template
- Removed deprecated analytics template

These local theme modifications should be preserved but not committed to the theme submodule.
